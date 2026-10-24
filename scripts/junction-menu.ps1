[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('Pick','Create','Unlink')][string]$Action,
    [string]$SourcePath,
    [string]$DestinationPath,
    [string]$LinkName,
    [string]$StatePath = (Join-Path $env:LOCALAPPDATA 'Biglex\NilesoftShell\junction-source.json'),
    [switch]$Quiet
)

$ErrorActionPreference = 'Stop'

function Show-Notice([string]$Text, [bool]$IsError=$false) {
    if ($Quiet) { Write-Output $Text; return }
    if (-not $IsError) { return }
    Add-Type -AssemblyName System.Windows.Forms
    $icon = if ($IsError) { 'Error' } else { 'Information' }
    [void][System.Windows.Forms.MessageBox]::Show($Text, 'Enlaces de carpetas', 'OK', $icon)
}

function Get-LocalDirectory([string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path)) { throw 'No se recibió una carpeta.' }
    $item = Get-Item -LiteralPath $Path -Force
    if (-not $item.PSIsContainer -or $item.PSProvider.Name -ne 'FileSystem') {
        throw 'Selecciona una carpeta del disco.'
    }
    $full = [IO.Path]::GetFullPath($item.FullName).TrimEnd('\')
    if ($full.StartsWith('\\')) { throw 'Esta opción trabaja con carpetas de discos locales.' }
    if ($full -match '^[A-Za-z]:$') { $full += '\' }
    return $full
}

try {
    # Explorer puede lanzar el helper con el destino como directorio de trabajo.
    # Liberarlo antes de cualquier diálogo para que no bloquee su eliminación.
    $neutralDirectory = [IO.Path]::GetTempPath()
    Set-Location -LiteralPath $neutralDirectory
    [Environment]::CurrentDirectory = $neutralDirectory
    if ($Action -eq 'Unlink') {
        $link = Get-LocalDirectory $SourcePath
        $item = Get-Item -LiteralPath $link -Force
        if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -or
            $item.LinkType -notin @('Junction','SymbolicLink')) {
            throw 'Esta es una carpeta normal. Desenlazar solo quita enlaces; no elimina carpetas ni archivos.'
        }
        # Nunca recursivo: retirar únicamente la entrada del enlace.
        # No enumerar ni borrar contenido del destino.
        [IO.Directory]::Delete($link, $false)
        if (Get-Item -LiteralPath $link -Force -ErrorAction SilentlyContinue) {
            throw 'Windows no confirmó la retirada del enlace.'
        }
        Show-Notice ("Enlace retirado: $link. La carpeta original se conserva.")
        exit 0
    }
    if ($Action -eq 'Pick') {
        $source = Get-LocalDirectory $SourcePath
        $item = Get-Item -LiteralPath $source -Force
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw 'Selecciona la carpeta real, no un enlace ya creado.'
        }
        if ($source.TrimEnd('\') -eq [IO.Path]::GetPathRoot($source).TrimEnd('\')) {
            throw 'Selecciona una carpeta, no la unidad completa.'
        }
        $stateDirectory = Split-Path -Parent $StatePath
        [void][IO.Directory]::CreateDirectory($stateDirectory)
        $state = @{source=$source; selected_at=[DateTime]::UtcNow.ToString('o')} | ConvertTo-Json
        [IO.File]::WriteAllText($StatePath, $state, [Text.UTF8Encoding]::new($false))
        Show-Notice ("Carpeta seleccionada:`n$source`n`nAhora abre el destino y elige Crear enlace aquí.")
        exit 0
    }

    if (-not (Test-Path -LiteralPath $StatePath -PathType Leaf)) {
        throw 'Primero haz clic derecho en la carpeta real y elige Seleccionar para enlazar.'
    }
    $saved = Get-Content -LiteralPath $StatePath -Raw -Encoding UTF8 | ConvertFrom-Json
    $source = Get-LocalDirectory $saved.source
    if ((Get-Item -LiteralPath $source -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) {
        throw 'La carpeta seleccionada ahora es un enlace. Selecciona de nuevo la carpeta real.'
    }
    $destination = Get-LocalDirectory $DestinationPath
    $ancestor = Get-Item -LiteralPath $destination -Force
    while ($null -ne $ancestor) {
        if ($ancestor.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw 'Elige la ubicación física del destino, no una carpeta dentro de otro enlace.'
        }
        $ancestor = $ancestor.Parent
    }
    if ([string]::IsNullOrWhiteSpace($LinkName)) {
        $LinkName = Split-Path -Leaf $source
    }
    if ($LinkName -ne $LinkName.Trim() -or $LinkName.EndsWith('.') -or
        $LinkName -in @('.','..') -or $LinkName.IndexOfAny([IO.Path]::GetInvalidFileNameChars()) -ge 0 -or
        $LinkName -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(\.|$)') {
        throw 'Ese nombre de carpeta no es válido.'
    }
    $link = [IO.Path]::GetFullPath((Join-Path $destination $LinkName))
    $sourcePrefix = $source.TrimEnd('\') + '\'
    if ($link.Equals($source, [StringComparison]::OrdinalIgnoreCase) -or
        $link.StartsWith($sourcePrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'El enlace no puede estar dentro de su propia carpeta real: produciría un recorrido circular.'
    }
    if (Get-Item -LiteralPath $link -Force -ErrorAction SilentlyContinue) {
        throw 'Ya existe un archivo, carpeta o enlace con ese nombre. No se sobrescribió nada.'
    }
    $created = New-Item -ItemType Junction -Path $link -Target $source
    if ($created.LinkType -ne 'Junction') { throw 'Windows no confirmó la creación del enlace.' }
    Show-Notice ("Enlace creado:`n$link`n`nApunta a:`n$source`n`nLos archivos se guardan en la carpeta real; esto no crea una copia de seguridad.")
    exit 0
} catch {
    Show-Notice $_.Exception.Message $true
    exit 1
}
