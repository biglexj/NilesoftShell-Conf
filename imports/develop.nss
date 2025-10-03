menu(mode="multiple" title='&Desarrollo' vis=key.shift() sep=sep.bottom image=\uE26E)
{
	menu(mode="single" title='Editores' image=\uE17A)
	{
		item(title='Visual Studio Code' image=[\uE272, #22A7F2] cmd='code' args='"@sel.path"')
		separator
		item(type='file' mode="single" title='Bloc de notas' image cmd='@sys.bin\notepad.exe' args='"@sel.path"')
	}

	menu(mode="multiple" title='dotnet' image=\uE143)
	{
		item(title='Ejecutar' cmd-line='/K dotnet run' image=\uE149)
		item(title='Watch' cmd-line='/K dotnet watch')
		item(title='Limpiar' image=\uE0CE cmd-line='/K dotnet clean')
		separator
		item(title='Compilar debug' cmd-line='/K dotnet build')
		item(title='Compilar release' cmd-line='/K dotnet build -c release /p:DebugType=None')

		menu(mode="multiple" sep="both" title='Publicar' image=\ue11f)
		{
			$publish='dotnet publish -r win-x64 -c release --output publish /*/p:CopyOutputSymbolsToPublishDirectory=false*/'
			item(title='Archivo único' sep="after" cmd-line='/K @publish --no-self-contained /p:PublishSingleFile=true')
			item(title='Dependiente del framework' cmd-line='/K @publish')
			item(title='Ejecutable dependiente' cmd-line='/K @publish --self-contained false')
			item(title='Auto-contenido' cmd-line='/K @publish --self-contained true')
			item(title='Archivo único' cmd-line='/K @publish /p:PublishSingleFile=true /p:PublishTrimmed=false')
			item(title='Archivo único optimizado' cmd-line='/K @publish /p:PublishSingleFile=true /p:PublishTrimmed=true')
		}
		
		item(title='EF: Agregar migración' cmd-line='/K dotnet ef migrations add InitialCreate')
		item(title='EF: Actualizar BD' cmd-line='/K dotnet ef database update')
		separator
		item(title='Ayuda' image=\uE136 cmd-line='/k dotnet -h')
		item(title='Versión' cmd-line='/k dotnet --info')
	}
}