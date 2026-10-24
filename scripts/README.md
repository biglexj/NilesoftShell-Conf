# Herramientas del Explorador

## Archivos en uso

La ventana y sus confirmaciones siguen automáticamente el tema claro u oscuro de las aplicaciones de Windows mediante `file-lock-theme.ps1`. La ventana principal comprueba cambios cada dos segundos mientras está abierta. Respeta el modo de alto contraste; no modifica preferencias del sistema. Los diálogos de permisos UAC mantienen el aspecto que decide Windows.

Clic derecho sobre un archivo o carpeta → **Revisar qué lo bloquea…**. `file-lock-menu.ps1` abre una ventana con proceso, PID, título de ventana, CPU acumulada, ruta abierta y línea de comandos. `file-lock-native.cs` inspecciona identificadores abiertos de Windows sin cerrarlos y consulta el directorio de trabajo de procesos de 64 bits. No necesita instalar Unlocker ni descargar ejecutables.

Acciones: revisar de nuevo, solicitar cierre normal, terminar únicamente el proceso seleccionado (con confirmación), volver a abrir como administrador mediante UAC y eliminar el elemento (con confirmación). Antes de actuar se comprueban la identidad del proceso, su fecha de inicio y su uso actual del elemento. Rechaza procesos críticos, los servicios del sistema y el propio helper. La CPU es acumulada, no una afirmación de actividad actual. Una aplicación puede trabajar sin ventana o con CPU baja.

La eliminación es definitiva y no recursiva: admite archivos, carpetas normales vacías y enlaces de directorio. Al quitar un enlace conserva su destino. No modifica permisos ni toma propiedad; no programa eliminaciones durante el reinicio. Para carpetas con contenido, libera el bloqueo y elimínalas normalmente desde el Explorador.

El análisis tiene un límite de 15 segundos entre identificadores y muestra si fue parcial. Puede omitir procesos por permisos, arquitectura, identificadores remotos o cambios durante la consulta. No garantiza que todos los bloqueos sean detectados. La llamada individual a Windows puede tardar más en unidades problemáticas. La elevación amplía acceso, pero no elimina las restricciones del sistema. No se inyecta código ni se fuerzan cierres de identificadores ajenos.

Verificado: compilación C#, sintaxis PowerShell 5.1, detección de archivo bloqueado exclusivamente, detección a través de una junction y detección de un directorio de trabajo retenido. La captura del usuario confirmó la ventana de prueba. Solo se cerraron los procesos propios de esa prueba y se retiraron sus archivos temporales. El menú requiere recargar Nilesoft; la prueba completa del menú, los botones de cierre/eliminación y el flujo de UAC quedan pendientes de uso real.

## Enlaces de carpetas

`junction-menu.ps1` permite crear junctions desde Nilesoft Shell, sin instalar extensiones adicionales. Las entradas viven en `imports/file-manage.nss`, que la instalación de Program Files ya importa desde este repositorio.

## Uso

1. Recargar Nilesoft con Ctrl + clic derecho en el escritorio o la barra de tareas.
2. Clic derecho sobre la carpeta real → Enlaces de carpetas → Seleccionar para enlazar.
3. Abrir la carpeta de destino y hacer clic derecho en un espacio vacío → Enlaces de carpetas → Crear enlace aquí. También se puede hacer clic derecho sobre la carpeta de destino.
4. El enlace aparece con el mismo nombre de la carpeta real. No hay avisos de selección o éxito ni cuadro para elegir nombre. Después se puede renombrar el enlace desde el Explorador.

La carpeta del enlace no debe existir. Solo los errores muestran mensajes. El programa rechaza sobrescrituras, rutas de red, orígenes que ya son enlaces, destinos dentro de otros enlaces y recorridos circulares. No mueve, copia ni borra contenido del usuario. Los permisos normales de Windows siguen aplicándose.

## Desenlazar

Sobre una carpeta enlazada, el menú Enlaces de carpetas ofrece **Desenlazar esta carpeta**, con un icono de retirada. Comprueba que el objeto sea una junction o un enlace simbólico de directorio y llama a Directory.Delete con recursive=false. No recorre el contenido ni borra archivos del destino. Si se invoca sobre una carpeta normal, se rechaza la operación. No hay cuadro de éxito.

Se probó con una junction a una carpeta que contenía un archivo: desapareció el enlace y el hash del archivo original no cambió. Se comprobó también el rechazo de una carpeta normal. Esta prueba del helper no confirma por sí sola la visibilidad del menú tras recargar Explorer.

No se escribe desktop.ini para personalizar el icono del enlace, porque escribirlo a través de la junction modificaría la carpeta original. El distintivo añadido está en el menú contextual; no se instaló un proveedor de iconos del Explorador.

## Directorio ocupado

Explorer puede iniciar el helper usando la carpeta seleccionada como directorio de trabajo. Una versión anterior dejó procesos pendientes en sus diálogos; tres conservaron D:\Imágenes\Enlace como directorio actual y bloquearon su eliminación. Se cerraron exclusivamente los cinco procesos de powershell.exe cuya línea de comandos correspondía a este helper antiguo. Después se pudo quitar la carpeta normal vacía sin forzar el sistema de archivos.

El helper ahora cambia tanto la ubicación de PowerShell como Environment.CurrentDirectory a la carpeta temporal antes de cualquier acción o diálogo. Así un error pendiente no retiene el directorio elegido por el usuario.

La selección se guarda en `%LOCALAPPDATA%\Biglex\NilesoftShell\junction-source.json` y no cambia el portapapeles. El script se lanza sin consola, sin modificar la política de ejecución y sin elevar privilegios automáticamente. La junction comparte los archivos originales: no es una copia de seguridad.

## Verificación

Probado con Windows PowerShell 5.1: selección de una carpeta con tildes, espacios, ampersand y paréntesis, creación, escritura a través del enlace, rechazo de sobrescritura, de ciclos y de un enlace como origen. También se creó y verificó el enlace solicitado D:\Imágenes\Enlace\NilesoftShell al proyecto original. La opción para fondo vacío tiene menú e item con mode=none; la selección de carpetas usa mode=single. El helper se verificó por línea de comandos; el recorrido completo desde el menú recargado de Explorer sigue pendiente de confirmación manual.
