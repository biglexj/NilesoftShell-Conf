menu(type="taskbar" vis=key.shift() or key.lbutton() pos=0 title=app.name image=\uE249)
{
	item(title="Configuración" image=\uE10A cmd='"@app.cfg"')
	item(title="Administrador" image=\uE0F3 admin cmd='"@app.exe"')
	item(title="Directorio" image=\uE0E8 cmd='"@app.dir"')
	item(title="Versión\t"+@app.ver vis=label col=1)
	item(title="Documentación" image=\uE1C4 cmd='https://nilesoft.org/docs')
	item(title="Donar" image=\uE1A7 cmd='https://nilesoft.org/donate')
}

menu(where=@(this.count == 0) type='taskbar' image=icon.settings expanded=true)
{
	menu(title="Aplicaciones" image=\uE254)
	{
		item(title='Paint' image='@sys.bin\mspaint.exe' cmd='mspaint')
		item(title='Edge' image='@sys.prog32\Microsoft\Edge\Application\msedge.exe' cmd='@sys.prog32\Microsoft\Edge\Application\msedge.exe')
		item(title='Calculator' image='@sys.bin\calc.exe' cmd='calc.exe')
		item(title=str.res('regedit.exe,-16') image='@sys.bin\regedit.exe' cmd='regedit.exe')
		separator
		menu(title='Affinity' image=inherit)
		{
			item(title='Affinity Designer 2' image='C:\Program Files\Affinity\Designer 2\Designer.exe' cmd='AffinityDesigner2.exe')
			item(title='Affinity Photo 2' image='C:\Program Files\Affinity\Photo 2\Photo.exe' cmd='AffinityPhoto2.exe')
			item(title='Affinity Publisher 2' image='C:\Program Files\Affinity\Publisher 2\Publisher.exe' cmd='AffinityPublisher2.exe')
		}
	}
	menu(title=title.windows image=\uE1FB)
	{
		item(title=title.cascade_windows cmd=command.cascade_windows)
		item(title=title.Show_windows_stacked cmd=command.Show_windows_stacked)
		item(title=title.Show_windows_side_by_side cmd=command.Show_windows_side_by_side)
		sep
		item(title=title.minimize_all_windows cmd=command.minimize_all_windows)
		item(title=title.restore_all_windows cmd=command.restore_all_windows)
	}
	item(title=title.desktop image=icon.desktop cmd=command.toggle_desktop)
	item(title=title.settings image=icon.settings(auto, image.color1) cmd='ms-settings:')
	item(title=title.task_manager sep=both image=icon.task_manager cmd='taskmgr.exe')
	item(title=title.taskbar_Settings sep=both image=inherit cmd='ms-settings:taskbar')
	item(vis=key.shift() title=title.exit_explorer cmd=command.restart_explorer)
}