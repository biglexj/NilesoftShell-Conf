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

// Submenú Abrir carpeta en... para carpetas
menu(type='dir' mode="multiple" title='Abrir carpeta en...' pos=2 sep='bottom' image=icon.code)
{
	item(title='Visual Studio Code' image='C:\Users\biglexj\AppData\Local\Programs\Microsoft VS Code\Code.exe' cmd='code' args='"@sel.path"')
	item(title='Zed' image='C:\Users\biglexj\AppData\Local\Programs\Zed\Zed.exe' cmd='C:\Users\biglexj\AppData\Local\Programs\Zed\Zed.exe' args='"@sel.path"')
	item(title='Antigravity' image='C:\Users\biglexj\AppData\Local\Programs\antigravity\Antigravity.exe' cmd='C:\Users\biglexj\AppData\Local\Programs\antigravity\Antigravity.exe' args='"@sel.path"')
}

menu(mode="multiple" title="Fijar/Desfijar" image=icon.pin)
{
}

menu(mode="multiple" title=title.more_options image=icon.more_options)
{
}
