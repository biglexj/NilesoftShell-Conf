[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$TargetPath,[switch]$ScanOnly)
$ErrorActionPreference='Stop'
$scriptFile=$PSCommandPath
$nativeFile=Join-Path $PSScriptRoot 'file-lock-native.cs'
Set-Location -LiteralPath ([IO.Path]::GetTempPath())
[Environment]::CurrentDirectory=[IO.Path]::GetTempPath()
Add-Type -Path $nativeFile
function Get-Target {
 $item=Get-Item -LiteralPath $TargetPath -Force
 if($item.PSProvider.Name -ne 'FileSystem'){throw 'Selecciona un archivo o carpeta local.'}
 $full=[IO.Path]::GetFullPath($item.FullName)
 if($full.StartsWith('\\') -or $full.TrimEnd('\') -eq [IO.Path]::GetPathRoot($full).TrimEnd('\')){throw 'No se admiten unidades completas ni rutas de red.'}
 return $item
}
function Get-Locks {
 $item=Get-Target
 $report=[FileLockNative]::Scan($item.FullName,$item.PSIsContainer)
 $rows=@(foreach($group in ($report.Matches | Group-Object Pid)) {
  try {
   $p=Get-Process -Id ([int]$group.Name) -ErrorAction Stop
   $start=$p.StartTime.ToUniversalTime().Ticks
   $cpu=$null;try{$cpu=[math]::Round($p.TotalProcessorTime.TotalSeconds,1)}catch{}
   $command='';try{$command=(Get-CimInstance Win32_Process -Filter "ProcessId=$($p.Id)").CommandLine}catch{}
   [pscustomobject]@{PID=$p.Id;Proceso=$p.ProcessName;Ventana=$p.MainWindowTitle;CPU=$cpu;Inicio=$start;Prueba=(($group.Group.Evidence|Select-Object -Unique)-join ', ');Ruta=(($group.Group.Path|Select-Object -Unique)-join "`r`n");Comando=$command}
  }catch{}
 })
 [pscustomobject]@{Rows=$rows;Denied=$report.Denied;Partial=$report.Partial}
}
if($ScanOnly){Get-Locks | ConvertTo-Json -Depth 5;return}
Add-Type -AssemblyName System.Windows.Forms,System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()
. (Join-Path $PSScriptRoot 'file-lock-theme.ps1')
function Notice([string]$text){[void](Show-LockDialog -Text $text)}
function Confirm([string]$text){return (Show-LockDialog -Text $text -Question) -eq 'Yes'}
$form=New-Object Windows.Forms.Form
$form.Text='Archivos en uso';$form.Size=New-Object Drawing.Size(940,650);$form.MinimumSize=New-Object Drawing.Size(820,590);$form.StartPosition='CenterScreen';$form.Font=New-Object Drawing.Font('Segoe UI',10)
$layout=New-Object Windows.Forms.TableLayoutPanel
$layout.Dock='Fill';$layout.Padding=New-Object Windows.Forms.Padding(16);$layout.ColumnCount=1;$layout.RowCount=6
foreach($height in @(48,38,220,100,52,75)){$style=New-Object Windows.Forms.RowStyle;$style.SizeType='Absolute';$style.Height=$height;$layout.RowStyles.Add($style)|Out-Null}
$layout.RowStyles[2].SizeType='Percent';$layout.RowStyles[2].Height=100
$form.Controls.Add($layout)
$pathLabel=New-Object Windows.Forms.Label;$pathLabel.Text=$TargetPath;$pathLabel.Dock='Fill';$pathLabel.AutoEllipsis=$true;$layout.Controls.Add($pathLabel,0,0)
$status=New-Object Windows.Forms.Label;$status.Dock='Fill';$layout.Controls.Add($status,0,1)
$list=New-Object Windows.Forms.ListView;$list.Dock='Fill';$list.View='Details';$list.FullRowSelect=$true;$list.MultiSelect=$false;$list.HideSelection=$false
foreach($col in @(@('Proceso',160),@('PID',70),@('Ventana',220),@('CPU acumulada (s)',135),@('Uso detectado',220))){[void]$list.Columns.Add($col[0],$col[1])};$layout.Controls.Add($list,0,2)
$details=New-Object Windows.Forms.TextBox;$details.Multiline=$true;$details.ReadOnly=$true;$details.Dock='Fill';$details.ScrollBars='Vertical';$layout.Controls.Add($details,0,3)
$buttons=New-Object Windows.Forms.FlowLayoutPanel;$buttons.Dock='Fill';$buttons.Padding=New-Object Windows.Forms.Padding(0,8,0,0);$layout.Controls.Add($buttons,0,4)
function Button([string]$text){$b=New-Object Windows.Forms.Button;$b.Text=$text;$b.AutoSize=$true;$b.Height=33;$buttons.Controls.Add($b);return $b}
$refresh=Button 'Revisar de nuevo';$close=Button 'Solicitar cierre';$kill=Button 'Terminar proceso';$admin=Button 'Como administrador';$delete=Button 'Eliminar elemento'
$hint=New-Object Windows.Forms.Label;$hint.Dock='Fill';$hint.Text="Una ventana vacía o una CPU baja no prueban que el proceso esté inactivo. Terminarlo puede perder cambios sin guardar.`r`nLa revisión puede ser incompleta por permisos, duración o tipos de identificadores. No encontrar procesos no garantiza que esté libre.";$layout.Controls.Add($hint,0,5)
# Dibujar la cabecera evita que quede una franja blanca en el tema oscuro.
$list.OwnerDraw=$true
$list.add_DrawColumnHeader({param($sender,$e)
 $brush=New-Object Drawing.SolidBrush($sender.BackColor)
 try{$e.Graphics.FillRectangle($brush,$e.Bounds)}finally{$brush.Dispose()}
 $rect=$e.Bounds;$rect.Inflate(-6,0)
 [Windows.Forms.TextRenderer]::DrawText($e.Graphics,$e.Header.Text,$sender.Font,$rect,$sender.ForeColor,([Windows.Forms.TextFormatFlags]::Left -bor [Windows.Forms.TextFormatFlags]::VerticalCenter -bor [Windows.Forms.TextFormatFlags]::EndEllipsis))
})
$list.add_DrawItem({param($sender,$e) $e.DrawDefault=$true})
$list.add_DrawSubItem({param($sender,$e) $e.DrawDefault=$true})
$script:lockThemeMode=Get-LockThemeMode
Set-LockWindowTheme -Window $form -Mode $script:lockThemeMode
$themeTimer=New-Object Windows.Forms.Timer;$themeTimer.Interval=2000
$themeTimer.add_Tick({$mode=Get-LockThemeMode;if($mode -ne $script:lockThemeMode){$script:lockThemeMode=$mode;Set-LockWindowTheme -Window $form -Mode $mode}})
$themeTimer.Start()
$form.add_FormClosed({$themeTimer.Stop();$themeTimer.Dispose()})
function Refresh-Locks {
 $status.Text='Revisando…';$list.Items.Clear();$form.UseWaitCursor=$true;$buttons.Enabled=$false;$form.Refresh()
 try{$r=Get-Locks;foreach($row in $r.Rows){$li=New-Object Windows.Forms.ListViewItem($row.Proceso);foreach($v in @($row.PID,$row.Ventana,$row.CPU,$row.Prueba)){[void]$li.SubItems.Add([string]$v)};$li.Tag=$row;[void]$list.Items.Add($li)}
 $status.Text="$($r.Rows.Count) procesos usando este elemento";if($r.Denied){$status.Text+=' · acceso limitado; puedes revisar como administrador'};if($r.Partial){$status.Text+=' · revisión parcial (tiempo)'}
 }catch{$status.Text=$_.Exception.Message}finally{$form.UseWaitCursor=$false;$buttons.Enabled=$true}
}
function Selected-Process {
 if($list.SelectedItems.Count -ne 1){throw 'Selecciona un proceso de la lista.'}
 $row=$list.SelectedItems[0].Tag;$p=Get-Process -Id $row.PID
 [void]$p.Handle
 if($p.StartTime.ToUniversalTime().Ticks -ne $row.Inicio){throw 'El proceso cambió. Revisa de nuevo.'}
 if($p.Id -le 4 -or $p.Id -eq $PID -or $p.ProcessName -match '^(System|Registry|Idle|csrss|smss|wininit|winlogon|services|lsass|svchost|dwm|fontdrvhost|MemCompression|Secure System)$' -or [FileLockNative]::Critical($p.Id)){throw 'Este proceso del sistema no se puede cerrar desde esta herramienta.'}
 # Revalidar el bloqueo evita actuar sobre una lista antigua.
 $fresh=Get-Locks
 if(-not ($fresh.Rows | Where-Object { $_.PID -eq $row.PID -and $_.Inicio -eq $row.Inicio })){throw 'Ese proceso ya no aparece usando el elemento. Revisa de nuevo.'}
 if($p.HasExited){throw 'El proceso ya terminó. Revisa de nuevo.'}
 return $p
}
$list.add_SelectedIndexChanged({if($list.SelectedItems.Count){$r=$list.SelectedItems[0].Tag;$details.Text="Uso: $($r.Ruta)`r`nComando: $($r.Comando)"}})
$refresh.add_Click({Refresh-Locks})
$close.add_Click({try{$p=Selected-Process;if(-not $p.CloseMainWindow()){Notice 'No tiene una ventana principal que acepte el cierre. Puedes terminarlo si reconoces el proceso.'}else{$status.Text='Cierre solicitado. Guarda los cambios si la aplicación lo pide y vuelve a revisar.'}}catch{Notice $_.Exception.Message}})
$kill.add_Click({try{$p=Selected-Process;if(Confirm "¿Terminar $($p.ProcessName) (PID $($p.Id))? Se perderán los cambios sin guardar de ese proceso."){$p.Kill();$p.WaitForExit(1500)|Out-Null;Refresh-Locks}}catch{Notice $_.Exception.Message}})
$admin.add_Click({try{
 $identity=[Security.Principal.WindowsIdentity]::GetCurrent();$principal=New-Object Security.Principal.WindowsPrincipal($identity)
 if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){Notice 'La herramienta ya está abierta como administrador.';return}
 # Pasar datos como Base64 evita problemas con comillas, apóstrofos o rutas con espacios.
 $s=$scriptFile.Replace("'","''");$encodedPath=[Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($TargetPath))
 $code="& '$s' -TargetPath ([Text.Encoding]::Unicode.GetString([Convert]::FromBase64String('$encodedPath')))"
 Start-Process -FilePath "$env:WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" -Verb RunAs -WindowStyle Hidden -ArgumentList @('-NoProfile','-STA','-EncodedCommand',[Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($code))) -WorkingDirectory ([IO.Path]::GetTempPath())
 $form.Close()
 }catch{Notice $_.Exception.Message}})
$delete.add_Click({try{
 $item=Get-Target;$full=$item.FullName
 $isLink=($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
 if($isLink -and $item.LinkType -notin @('Junction','SymbolicLink')){throw 'Este tipo de punto de análisis no se elimina desde esta herramienta.'}
 $message="¿Eliminar definitivamente este elemento?`r`n$full"
 if($isLink){$message="¿Quitar únicamente este enlace? Su destino se conserva.`r`n$full"}
 if(-not (Confirm $message)){return}
 # Nunca recorrer enlaces. Las carpetas normales deben estar vacías.
 if($item.PSIsContainer){[IO.Directory]::Delete($full,$false)}else{[IO.File]::Delete($full)}
 $status.Text='Elemento eliminado.';$list.Items.Clear();$delete.Enabled=$false
 }catch{Notice ("No se pudo eliminar. Las carpetas normales deben estar vacías; no se borra contenido de forma recursiva.`r`n"+$_.Exception.Message)}})
$form.add_Shown({Refresh-Locks})
[void]$form.ShowDialog()
