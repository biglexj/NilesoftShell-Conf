menu(type='*' where=(sel.count or wnd.is_taskbar or wnd.is_edit) title=title.terminal sep='top' image=icon.run_with_powershell)
{
	$tip_run_admin=["\xE1A7 Presiona SHIFT para ejecutar " + this.title + " como administrador", tip.warning, 1.0]
	$has_admin=key.shift() or key.rbutton()
	
	item(title=title.command_prompt tip=tip_run_admin admin=has_admin image cmd='cmd.exe' args='/K TITLE Command Prompt &ver& PUSHD "@sel.dir"')
	item(title=title.windows_powershell admin=has_admin tip=tip_run_admin image cmd='powershell.exe' args='-noexit -command Set-Location -Path "@sel.dir\."')
	item(where=package.exists("WindowsTerminal") title=title.Windows_Terminal tip=tip_run_admin admin=has_admin image='@package.path("WindowsTerminal")\WindowsTerminal.exe' cmd='wt.exe' arg='-d "@sel.path\."')
	separator
	item(title='Warp' tip=tip_run_admin admin=has_admin image='C:\Program Files\Warp\warp.exe' cmd='warp-terminal.exe' args='--working-directory "@sel.dir"')
	item(title='Wave' tip=tip_run_admin admin=has_admin image='C:\Users\biglexj\AppData\Local\Programs\waveterm\Wave.exe' cmd='wave.exe' args='--cwd "@sel.dir"')
	separator
	item(title='Neovim' tip=tip_run_admin admin=has_admin image='C:\Program Files\Neovim\bin\nvim.exe' cmd='wt.exe' args='-d "@sel.dir" -- nvim "@sel.path"')
	item(title='MySQL Shell' tip=tip_run_admin admin=has_admin image='C:\Program Files\MySQL\MySQL Shell 8.0\bin\mysqlsh.exe' cmd='wt.exe' args='-d "@sel.dir" -- mysql')
}