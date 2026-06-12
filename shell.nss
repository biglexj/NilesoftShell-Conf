settings
{
	priority=1
	exclude.where = !process.is_explorer
	showdelay = 200
	modify.remove.duplicate=1
	tip.enabled=true
}

import 'D:\Proyectos\4. Temas\2. Windows\NilesoftShell\imports/theme.nss'
import 'D:\Proyectos\4. Temas\2. Windows\NilesoftShell\imports/images.nss'
import 'D:\Proyectos\4. Temas\2. Windows\NilesoftShell\imports/modify.nss'
import 'D:\Proyectos\4. Temas\2. Windows\NilesoftShell\imports/remove.nss'
import 'D:\Proyectos\4. Temas\2. Windows\NilesoftShell\imports/terminal.nss'
import 'D:\Proyectos\4. Temas\2. Windows\NilesoftShell\imports/file-manage.nss'
import 'D:\Proyectos\4. Temas\2. Windows\NilesoftShell\imports/develop.nss'
import 'D:\Proyectos\4. Temas\2. Windows\NilesoftShell\imports/goto.nss'
import 'D:\Proyectos\4. Temas\2. Windows\NilesoftShell\imports/taskbar.nss'

// VS Code solo para archivos editables
item(where=str.equals(sel.file.ext, ['txt','md','json','xml','html','css','js','ts','tsx','jsx','py','cs','cpp','c','h','java','php','rb','go','rs','sql','yaml','yml','toml','ini','cfg','conf','log','sh','bat','ps1','nss'])
	type='file'
	title='Editar con VS Code'
	pos=2
	sep='bottom'
	image='C:\Users\biglexj\AppData\Local\Programs\Microsoft VS Code\Code.exe'
	cmd='code'
	args='"@sel.path"')

// VS Code para carpetas
item(type='dir'
	title='Abrir carpeta en VS Code'
	pos=2
	sep='bottom'
	image='C:\Users\biglexj\AppData\Local\Programs\Microsoft VS Code\Code.exe'
	cmd='code'
	args='"@sel.path"')

menu(mode="multiple" title="Fijar/Desfijar" image=icon.pin)
{
}

menu(mode="multiple" title=title.more_options image=icon.more_options)
{
}
