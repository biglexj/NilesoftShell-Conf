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
		item(title='Affinity' image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\affinity.png' cmd='Affinity.exe')
		item(title='Affinity Photo 2' image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\affinity_photo_2.png' cmd='AffinityPhoto2.exe')
		item(title='Edge' image='@sys.prog32\Microsoft\Edge\Application\msedge.exe' cmd='@sys.prog32\Microsoft\Edge\Application\msedge.exe')
		item(title='Calculadora' image='@sys.bin\calc.exe' cmd='calc.exe')
		item(title=str.res('regedit.exe,-16') image='C:\Windows\regedit.exe' cmd='regedit.exe')
	}
	menu(title=title.windows image=\uE1FB)
	{
		item(title='Ventanas en cascada' cmd=command.cascade_windows)
		item(title='Mostrar ventanas apiladas' cmd=command.Show_windows_stacked)
		item(title='Mostrar ventanas en paralelo' cmd=command.Show_windows_side_by_side)
		sep
		item(title='Minimizar todas las ventanas' cmd=command.minimize_all_windows)
		item(title='Restaurar todas las ventanas' cmd=command.restore_all_windows)
	}
	item(title=title.desktop image=icon.desktop cmd=command.toggle_desktop)
	item(title=title.settings image=icon.settings(auto, image.color1) cmd='ms-settings:')
	item(title='Administrador de tareas' sep=both image=icon.task_manager cmd='taskmgr.exe')
	item(title='Configuración de la barra de tareas' sep=both image=inherit cmd='ms-settings:taskbar')
	item(vis=key.shift() title='Reiniciar Explorador' cmd=command.restart_explorer)
}
