// modify items
modify(type="recyclebin" where=window.is_desktop and this.id==id.empty_recycle_bin pos=1 sep)

modify(find="unpin*" pos="bottom" menu="Fijar/Desfijar")
modify(find="pin*" pos="top" menu="Fijar/Desfijar")

modify(where=this.id==id.copy_as_path menu="Archivos")
modify(type="dir.back|drive.back" where=this.id==id.customize_this_folder pos=1 sep="top" menu="Archivos")

modify(where=str.equals(this.name, ["open in terminal", "open linux shell here"]) || this.id==id.open_powershell_window_here
	pos="bottom" menu="Terminal")

// Submenú pCloud con icono
menu(mode="multiple" title="pCloud" image='C:\Program Files\pCloud Drive\pCloud.exe')
{
}

// Mover opciones de pCloud a su submenú y traducir Sync
modify(find="Sync a pCloud" title="Sincronizar con pCloud" menu="pCloud")
modify(find="*pCloud*|Respaldar esta carpeta" menu="pCloud")

// Icono y traducción de Prisma
modify(find="Open with Prisma" title="Abrir con Prisma" image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\prisma.png')
modify(find="Prisma" image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\prisma.png')

// Asignar icono a Elegir otra aplicación (SVG que adapta a modo claro y oscuro)
modify(find="*Elegir otra*|*otra aplicaci*|*otra aplicación*|*Choose another*|*otra app*|&Elegir otra aplicación|Elegir otra aplicación|Choose another app|&Choose another app|*otra*" image=icon.open_new_window)
modify(find="*Elegir otra*|*otra aplicaci*|*otra aplicación*|*Choose another*|*otra app*|&Elegir otra aplicación|Elegir otra aplicación|Choose another app|&Choose another app|*otra*" in="Abrir con" image=icon.open_new_window)
modify(find="*Elegir otra*|*otra aplicaci*|*otra aplicación*|*Choose another*|*otra app*|&Elegir otra aplicación|Elegir otra aplicación|Choose another app|&Choose another app|*otra*" in="/Abrir con" image=icon.open_new_window)
modify(find="*Elegir otra*|*otra aplicaci*|*otra aplicación*|*Choose another*|*otra app*|&Elegir otra aplicación|Elegir otra aplicación|Choose another app|&Choose another app|*otra*" in="Abrir &con" image=icon.open_new_window)
modify(find="*Elegir otra*|*otra aplicaci*|*otra aplicación*|*Choose another*|*otra app*|&Elegir otra aplicación|Elegir otra aplicación|Choose another app|&Choose another app|*otra*" in="/Abrir &con" image=icon.open_new_window)
modify(find="*Elegir otra*|*otra aplicaci*|*otra aplicación*|*Choose another*|*otra app*|&Elegir otra aplicación|Elegir otra aplicación|Choose another app|&Choose another app|*otra*" parent="Abrir con" image=icon.open_new_window)
modify(where=str.equals(this.name, ['Elegir otra aplicación', '&Elegir otra aplicación', 'Elegir &otra aplicación', 'Choose another app', '&Choose another app', 'openas']) image=icon.open_new_window)
modify(where=str.equals(this.title, ['Elegir otra aplicación', '&Elegir otra aplicación', 'Elegir &otra aplicación', 'Choose another app', '&Choose another app', 'openas']) image=icon.open_new_window)

// Icono global para Abrir, Abrir en nueva pestaña y Abrir en nueva ventana
// Icono global para Abrir (coincidencia exacta para no afectar submenús ni Abrir con Prisma)
modify(where=str.equals(this.name, ['Abrir', '&Abrir', 'Open', '&Open']) image=icon.open_new_window)
modify(type='dir' where=str.equals(this.name, ['Abrir', '&Abrir', 'Open', '&Open']) image=icon.open_folder)
// Reafirmar icono de Prisma
modify(find='*Prisma*' image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\prisma.png')
modify(find='Open with Prisma' title='Abrir con Prisma' image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\prisma.png')
modify(find="*nueva pestaña*|*new tab*" image=icon.open_new_tab)
modify(find="*nueva ventana*|*new window*" image=icon.open_new_window)

// Asignar icono a Anclar a Acceso rápido y Anclar a Inicio
modify(find="*Acceso rápido*|*Quick access*|*Anclar a Inicio*|*Desanclar de Inicio*|*Anclar*|*Desanclar*" image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\pin.png')

// Asegurar que NanaZip no se posicione antes del submenú de edición
modify(find="NanaZip" pos=3)

// Traducciones al español
modify(find="Open project in ChatGPT" title="Abrir proyecto en ChatGPT")
modify(find="Path" title="Variable PATH")
modify(find="Add to PATH" title="Agregar a PATH")
modify(find="Remove from PATH" title="Eliminar de PATH")
modify(find="System PATH" title="PATH del sistema")
modify(find="User PATH" title="PATH de usuario")
modify(find="Check PATH Status" title="Comprobar estado de PATH")
modify(find="Show PATHs" title="Mostrar rutas PATH")

// Asignar icono de Deshacer
modify(find="Deshacer*" image=icon.undo)

modify(mode=mode.multiple
	where=this.id(
		id.send_to,
		id.share,
		id.create_shortcut,
		id.set_as_desktop_background,
		id.rotate_left,
		id.rotate_right,
		id.map_network_drive,
		id.disconnect_network_drive,
		id.format,
		id.eject,
		id.give_access_to,
		id.include_in_library,
		id.print
	)
	pos=1 menu=title.more_options)
