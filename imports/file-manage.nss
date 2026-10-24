menu(where=sel.count>0 type='file|dir|drive|namespace|back' mode="multiple" title='Archivos' image=\uE253)
{
	menu(separator="after" title=title.copy_path image=icon.copy_path)
	{
		item(where=sel.count > 1 title='Copiar (@sel.count) elementos seleccionados' cmd=command.copy(sel(false, "\n")))
		item(mode="single" title=@sel.path tip=sel.path cmd=command.copy(sel.path))
		item(mode="single" type='file' separator="before" find='.lnk' title='Abrir ubicación del archivo')
		separator
		item(mode="single" where=@sel.parent.len>3 title=sel.parent cmd=@command.copy(sel.parent))
		separator
		item(mode="single" type='file|dir|back.dir' title=sel.file.name cmd=command.copy(sel.file.name))
		item(mode="single" type='file' where=sel.file.len != sel.file.title.len title=@sel.file.title cmd=command.copy(sel.file.title))
		item(mode="single" type='file' where=sel.file.ext.len>0 title=sel.file.ext cmd=command.copy(sel.file.ext))
	}

	item(mode="single" type="file" title="Cambiar extensión" image=\uE0B5 cmd=if(input("Cambiar extensión", "Escriba la extensión"),
		io.rename(sel.path, path.join(sel.dir, sel.file.title + "." + input.result))))

	menu(separator="after" image=\uE290 title=title.select)
	{
		item(title="Todo" image=icon.select_all cmd=command.select_all)
		item(title="Invertir" image=icon.invert_selection cmd=command.invert_selection)
		item(title="Ninguno" image=icon.select_none cmd=command.select_none)
	}

	item(type='file|dir|back.dir|drive' title='Tomar propiedad' image=[\uE194,#f00] admin
		cmd args='/K takeown /f "@sel.path" @if(sel.type==1,null,"/r /d y") && icacls "@sel.path" /grant *S-1-5-32-544:F @if(sel.type==1,"/c /l","/t /c /l /q")')
	separator
	menu(title="Mostrar/Ocultar" image=icon.show_hidden_files)
	{
		item(title="Archivos del sistema" image=inherit cmd='@command.togglehidden')
		item(title="Extensiones de archivo" image=icon.show_file_extensions cmd='@command.toggleext')
	}

	menu(type='file|dir|back.dir' mode="single" title='Atributos' image=icon.properties)
	{
		$atrr = io.attributes(sel.path)
		item(title='Oculto' checked=io.attribute.hidden(atrr)
			cmd args='/c ATTRIB @if(io.attribute.hidden(atrr),"-","+")H "@sel.path"' window=hidden)

		item(title='Sistema' checked=io.attribute.system(atrr)
			cmd args='/c ATTRIB @if(io.attribute.system(atrr),"-","+")S "@sel.path"' window=hidden)

		item(title='Solo lectura' checked=io.attribute.readonly(atrr)
			cmd args='/c ATTRIB @if(io.attribute.readonly(atrr),"-","+")R "@sel.path"' window=hidden)

		item(title='Archivo' checked=io.attribute.archive(atrr)
			cmd args='/c ATTRIB @if(io.attribute.archive(atrr),"-","+")A "@sel.path"' window=hidden)
		separator
		item(title="Creado" keys=io.dt.created(sel.path, 'y/m/d') cmd=io.dt.created(sel.path,2000,1,1) vis=label)
		item(title="Modificado" keys=io.dt.modified(sel.path, 'y/m/d') cmd=io.dt.modified(sel.path,2000,1,1) vis=label)
		item(title="Accedido" keys=io.dt.accessed(sel.path, 'y/m/d') cmd=io.dt.accessed(sel.path,2000,1,1) vis=label)
	}

	menu(mode="single" type='file' find='.dll|.ocx' separator="before" title='Registrar Servidor' image=\uea86)
	{
		item(title='Registrar' admin cmd='regsvr32.exe' args='@sel.path.quote' invoke="multiple")
		item(title='Desregistrar' admin cmd='regsvr32.exe' args='/u @sel.path.quote' invoke="multiple")
	}
	
	item(where=!wnd.is_desktop title=title.folder_options image=icon.folder_options cmd=command.folder_options)
}

// Diagnóstico interactivo de bloqueos: no cierra procesos automáticamente.
item(type='file|dir' mode='single' where=!sel.back title='Revisar qué lo bloquea…' pos=3 image=\uE192
	cmd='powershell.exe'
	args='-NoProfile -STA -File "D:\Proyectos\4. Temas\2. Windows\NilesoftShell\scripts\file-lock-menu.ps1" -TargetPath "@sel.path"'
	window=hidden)

// Una biblioteca real accesible desde varias ubicaciones, sin duplicar archivos.
menu(type='dir' mode='single' where=!sel.back title='Enlaces de carpetas' pos=3 image=\uE167)
{
	item(type='dir' where=(!sel.back && !(io.attributes(sel.path) & 1024)) title='Seleccionar para enlazar'
		tip='Selecciona la carpeta real. Después abre la ubicación donde quieras crear el enlace.'
		cmd='powershell.exe'
		args='-NoProfile -STA -File "D:\Proyectos\4. Temas\2. Windows\NilesoftShell\scripts\junction-menu.ps1" -Action Pick -SourcePath "@sel.path\."'
		window=hidden)
	item(type='dir' where=(!sel.back && !(io.attributes(sel.path) & 1024)) title='Crear enlace aquí'
		tip='Crea una junction dentro de esta carpeta, sin mover ni sobrescribir contenido.'
		cmd='powershell.exe'
		args='-NoProfile -STA -File "D:\Proyectos\4. Temas\2. Windows\NilesoftShell\scripts\junction-menu.ps1" -Action Create -DestinationPath "@sel.path\."'
		window=hidden)
	item(type='dir' where=(io.attributes(sel.path) & 1024) title='Desenlazar esta carpeta'
		tip='Quita solo el enlace. La carpeta original y sus archivos se conservan.'
		image=\uE711
		cmd='powershell.exe'
		args='-NoProfile -STA -File "D:\Proyectos\4. Temas\2. Windows\NilesoftShell\scripts\junction-menu.ps1" -Action Unlink -SourcePath "@sel.path"'
		window=hidden)

}

// El fondo sin selección necesita su propio modo: no hereda el de carpeta seleccionada.
menu(type='back.dir|back.drive' mode='none' title='Enlaces de carpetas' pos=3 image=\uE167)
{
	item(type='back.dir|back.drive' mode='none' title='Crear enlace aquí'
		tip='Crea aquí un enlace a la carpeta seleccionada previamente.'
		cmd='powershell.exe'
		args='-NoProfile -STA -File "D:\Proyectos\4. Temas\2. Windows\NilesoftShell\scripts\junction-menu.ps1" -Action Create -DestinationPath "@sel.curdir\."'
		window=hidden)
}


// Submenú Editar con... para imágenes (segunda opción en imágenes)
menu(type='file' mode="multiple" find='.png|.jpg|.jpeg|.webp|.bmp|.gif|.svg|.ico|.tif|.tiff|.avif|.psd|.ai' title='Editar con...' pos=2 sep='bottom' image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\image_edit.png')
{
	item(title='Affinity' image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\affinity.png' cmd='Affinity.exe' args='"@sel.path"')
	item(title='Affinity Photo 2' image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\affinity_photo_2.png' cmd='AffinityPhoto2.exe' args='"@sel.path"')
	item(title='Krita' image='C:\Program Files\Krita (x64)\bin\krita.exe' cmd='C:\Program Files\Krita (x64)\bin\krita.exe' args='"@sel.path"')
	item(title='Paint' image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\paint.png' cmd='mspaint.exe' args='"@sel.path"')
}

// Submenú Editar con... para archivos de código y texto
menu(type='file' mode="multiple" find='.txt|.md|.json|.xml|.html|.css|.js|.ts|.tsx|.jsx|.py|.cs|.cpp|.c|.h|.java|.php|.rb|.go|.rs|.sql|.yaml|.yml|.toml|.ini|.cfg|.conf|.log|.sh|.bat|.ps1|.nss' title='Editar con...' pos=2 sep='bottom' image='D:\Proyectos\4. Temas\2. Windows\NilesoftShell\icons\edit.png')
{
	item(title='Visual Studio Code' image='C:\Users\biglexj\AppData\Local\Programs\Microsoft VS Code\Code.exe' cmd='code' args='"@sel.path"')
	item(title='Zed' image='C:\Users\biglexj\AppData\Local\Programs\Zed\Zed.exe' cmd='C:\Users\biglexj\AppData\Local\Programs\Zed\Zed.exe' args='"@sel.path"')
	item(title='Antigravity' image='C:\Users\biglexj\AppData\Local\Programs\antigravity\Antigravity.exe' cmd='C:\Users\biglexj\AppData\Local\Programs\antigravity\Antigravity.exe' args='"@sel.path"')
	item(title='Bloc de notas' image='@sys.bin\notepad.exe' cmd='notepad.exe' args='"@sel.path"')
}
