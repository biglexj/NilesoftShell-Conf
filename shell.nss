settings
{
	priority=1
	exclude.where = !process.is_explorer
	showdelay = 200
	modify.remove.duplicate=1
	tip.enabled=true
}

import 'E:\Assets\Themes\NilesoftShell\imports/theme.nss'
import 'E:\Assets\Themes\NilesoftShell\imports/images.nss'
import 'E:\Assets\Themes\NilesoftShell\imports/modify.nss'
import 'E:\Assets\Themes\NilesoftShell\imports/remove.nss'

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

import 'E:\Assets\Themes\NilesoftShell\imports/terminal.nss'
import 'E:\Assets\Themes\NilesoftShell\imports/file-manage.nss'
import 'E:\Assets\Themes\NilesoftShell\imports/develop.nss'
import 'E:\Assets\Themes\NilesoftShell\imports/goto.nss'
import 'E:\Assets\Themes\NilesoftShell\imports/taskbar.nss'