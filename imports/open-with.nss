// Menú "Abrir con" personalizado
menu(type='file' mode="single" title='Abrir con' pos=2 image=\uE17A)
{
	item(title='Affinity Designer 2' cmd='AffinityDesigner2.exe' args='"@sel.path"')
	item(title='Affinity Photo 2' cmd='AffinityPhoto2.exe' args='"@sel.path"')
	item(title='Affinity Publisher 2' cmd='AffinityPublisher2.exe' args='"@sel.path"')
	item(title='Krita' cmd='krita.exe' args='"@sel.path"')
	separator
	item(title='Bloc de notas' image='@sys.bin\notepad.exe' cmd='notepad.exe' args='"@sel.path"')
}