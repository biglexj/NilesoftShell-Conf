menu(type='*' where=window.is_taskbar||sel.count mode=mode.multiple title=title.go_to sep=sep.both image=\uE14A)
{
	menu(title='Rutas' image=\uE1F4)
	{
		//Mis rutas
		item(title='Descargas' image=inherit cmd='D:\Descargas')
		item(title='Documentos' image=inherit cmd='D:\Documentos')
		item(title='Imágenes' image=inherit cmd='D:\Imágenes')
		item(title='Música' image=inherit cmd='D:\Música')
		item(title='Vídeos' image=inherit cmd='D:\Vídeos')
		item(title='Proyectos' image=inherit cmd='D:\Proyectos')
		separator
		item(title='Windows' image=inherit cmd=sys.dir)
		item(title='Sistema' image=inherit cmd=sys.bin)
		item(title='Archivos de Programa' image=inherit cmd=sys.prog)
		item(title='Archivos de Programa x86' image=inherit cmd=sys.prog32)
		item(title='Datos de Programa' image=inherit cmd=sys.programdata)
		item(title='Aplicaciones' image=inherit cmd='shell:appsfolder')
		item(title='Usuarios' image=inherit cmd=sys.users)
		separator
		//item(title='@user.name@@@sys.name' vis=label)
		item(title='Menú Inicio' image=inherit cmd=user.startmenu)
		item(title='Perfil' image=inherit cmd=user.dir)
		item(title='AppData' image=inherit cmd=user.appdata)
		item(title='Temporal' image=inherit cmd=user.temp)
	}
	item(title=title.control_panel image=\uE0F3 cmd='shell:::{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}')
	item(title='Panel de Control (Completo)' image=\uE0F3 cmd='shell:::{ED7BA470-8E54-465E-825C-99712043E01C}')
	item(title=title.run image=\uE14B cmd='shell:::{2559a1f3-21d7-11d4-bdaf-00c04f60b9f0}')
	menu(where=sys.ver.major >= 10 title=title.settings sep=sep.before image=\uE0F3)
	{
		// https://docs.microsoft.com/en-us/windows/uwp/launch-resume/launch-settings-app
		item(title='Sistema' image=inherit cmd='ms-settings:')
		item(title='Acerca de' image=inherit cmd='ms-settings:about')
		item(title='Tu información' image=inherit cmd='ms-settings:yourinfo')
		item(title='Información del sistema' image=inherit cmd-line='/K systeminfo')
		item(title='Buscar' cmd='search-ms:' image=inherit)
		item(title='USB' image=inherit cmd='ms-settings:usb')
		item(title='Windows Update' image=inherit cmd='ms-settings:windowsupdate')
		item(title='Windows Defender' image=inherit cmd='ms-settings:windowsdefender')
		menu(title='Aplicaciones' image=inherit)
		{
			item(title='Aplicaciones y características' image=inherit cmd='ms-settings:appsfeatures')
			item(title='Aplicaciones predeterminadas' image=inherit cmd='ms-settings:defaultapps')
			item(title='Características opcionales' image=inherit cmd='ms-settings:optionalfeatures')
			item(title='Inicio automático' image=inherit cmd='ms-settings:startupapps')
		}
		menu(title='Personalización' image=inherit)
		{
			item(title='Personalización' image=inherit cmd='ms-settings:personalization')
			item(title='Pantalla de bloqueo' image=inherit cmd='ms-settings:lockscreen')
			item(title='Fondo' image=inherit cmd='ms-settings:personalization-background')
			item(title='Colores' image=inherit cmd='ms-settings:colors')
			item(title='Temas' image=inherit cmd='ms-settings:themes')
			item(title='Inicio' image=inherit cmd='ms-settings:personalization-start')
			item(title='Barra de tareas' image=inherit cmd='ms-settings:taskbar')
		}
		menu(title='Red' image=inherit)
		{
			item(title='Estado' image=inherit cmd='ms-settings:network-status')
			item(title='Ethernet' image=inherit cmd='ms-settings:network-ethernet')
			item(title='Conexiones' image=inherit cmd='shell:::{7007ACC7-3202-11D1-AAD2-00805FC1270E}')
		}
	}
}
