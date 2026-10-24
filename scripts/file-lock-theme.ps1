# Tema de aplicaciones de Windows. Solo lee preferencias; no cambia el sistema.
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class FileLockWindowTheme {
 [DllImport("dwmapi.dll")] public static extern int DwmSetWindowAttribute(IntPtr hwnd,int attribute,ref int value,int size);
}
'@
function Get-LockThemeMode {
 if([Windows.Forms.SystemInformation]::HighContrast){return 'Contrast'}
 try {
  $light=(Get-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name AppsUseLightTheme -ErrorAction Stop).AppsUseLightTheme
  if($light -eq 0){return 'Dark'}
 }catch{}
 return 'Light'
}
function Set-LockWindowTheme {
 param([Windows.Forms.Form]$Window,[string]$Mode=(Get-LockThemeMode))
 if($Mode -eq 'Contrast') {
  $bg=[Drawing.SystemColors]::Control;$surface=[Drawing.SystemColors]::Window;$fg=[Drawing.SystemColors]::WindowText;$border=[Drawing.SystemColors]::WindowText
 }elseif($Mode -eq 'Dark') {
  $bg=[Drawing.ColorTranslator]::FromHtml('#202020');$surface=[Drawing.ColorTranslator]::FromHtml('#292929');$fg=[Drawing.ColorTranslator]::FromHtml('#F2F2F2');$border=[Drawing.ColorTranslator]::FromHtml('#555555')
 }else {
  $bg=[Drawing.ColorTranslator]::FromHtml('#F3F3F3');$surface=[Drawing.Color]::White;$fg=[Drawing.ColorTranslator]::FromHtml('#202020');$border=[Drawing.ColorTranslator]::FromHtml('#C5C5C5')
 }
 $Window.BackColor=$bg;$Window.ForeColor=$fg
 $queue=New-Object 'Collections.Generic.Queue[Windows.Forms.Control]';$queue.Enqueue($Window)
 while($queue.Count){
  $control=$queue.Dequeue();$control.ForeColor=$fg;$control.BackColor=$bg
  if($control -is [Windows.Forms.TextBox] -or $control -is [Windows.Forms.ListView]){$control.BackColor=$surface}
  if($control -is [Windows.Forms.Button]){
   $control.UseVisualStyleBackColor=$false;$control.FlatStyle='Flat';$control.BackColor=$surface
   $control.FlatAppearance.BorderColor=$border;$control.FlatAppearance.BorderSize=1
  }
  foreach($child in $control.Controls){$queue.Enqueue($child)}
 }
 # La barra de título usa el atributo público de DWM (Windows 11).
 $darkValue=[int]($Mode -eq 'Dark')
 try{[void][FileLockWindowTheme]::DwmSetWindowAttribute($Window.Handle,20,[ref]$darkValue,4)}catch{}
 $Window.Invalidate($true)
}
function Show-LockDialog {
 param([string]$Text,[switch]$Question)
 $dialog=New-Object Windows.Forms.Form;$dialog.Text=if($Question){'Confirmar acción'}else{'Archivos en uso'}
 $dialog.Size=New-Object Drawing.Size(580,300);$dialog.MinimumSize=$dialog.Size;$dialog.StartPosition='CenterParent';$dialog.Font=$form.Font;$dialog.MinimizeBox=$false;$dialog.MaximizeBox=$false
 $body=New-Object Windows.Forms.TextBox;$body.Multiline=$true;$body.ReadOnly=$true;$body.BorderStyle='None';$body.ScrollBars='Vertical';$body.Dock='Fill';$body.Text=$Text
 $panel=New-Object Windows.Forms.FlowLayoutPanel;$panel.Dock='Bottom';$panel.Height=52;$panel.FlowDirection='RightToLeft'
 $dialog.Padding=New-Object Windows.Forms.Padding(16);$dialog.Controls.Add($body);$dialog.Controls.Add($panel)
 $cancel=New-Object Windows.Forms.Button;$cancel.Text=if($Question){'Cancelar'}else{'Aceptar'};$cancel.AutoSize=$true;$cancel.DialogResult='Cancel';$panel.Controls.Add($cancel);$dialog.CancelButton=$cancel
 if($Question){$yes=New-Object Windows.Forms.Button;$yes.Text='Continuar';$yes.AutoSize=$true;$yes.DialogResult='Yes';$panel.Controls.Add($yes)}
 $dialog.AcceptButton=$cancel
 Set-LockWindowTheme -Window $dialog
 try{return $dialog.ShowDialog($form)}finally{$dialog.Dispose()}
}
