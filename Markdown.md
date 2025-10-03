# Lista completa de formatos Markdown

## Encabezados
```markdown
# Encabezado 1
## Encabezado 2
### Encabezado 3
#### Encabezado 4
##### Encabezado 5
###### Encabezado 6
```

## Énfasis de texto
```markdown
*cursiva* o _cursiva_
**negrita** o __negrita__
***negrita y cursiva*** o ___negrita y cursiva___
~~tachado~~
```

## Listas

### Lista desordenada
```markdown
- Elemento 1
- Elemento 2
  - Subelemento 2.1
  - Subelemento 2.2
* También funciona con asterisco
+ O con signo más
```

### Lista ordenada
```markdown
1. Primer elemento
2. Segundo elemento
   1. Subelemento
   2. Subelemento
3. Tercer elemento
```

### Lista de tareas
```markdown
- [x] Tarea completada
- [ ] Tarea pendiente
- [ ] Otra tarea
```

## Enlaces
```markdown
[Texto del enlace](https://ejemplo.com)
[Enlace con título](https://ejemplo.com "Título al pasar el mouse")
<https://ejemplo.com>
[Enlace de referencia][1]

[1]: https://ejemplo.com
```

## Imágenes
```markdown
![Texto alternativo](url-de-imagen.jpg)
![Alt text](imagen.jpg "Título opcional")
[![Imagen con enlace](imagen.jpg)](https://ejemplo.com)
```

## Código

### Código en línea
```markdown
Usa `código en línea` con backticks
```

### Bloque de código
````markdown
```
código sin resaltado
```

```javascript
// código con resaltado de sintaxis
function hola() {
  console.log("Hola mundo");
}
```
````

## Citas
```markdown
> Esta es una cita
> Puede tener múltiples líneas

> Citas anidadas
>> Segunda cita dentro
```

## Líneas horizontales
```markdown
---
***
___
```

## Tablas
```markdown
| Encabezado 1 | Encabezado 2 | Encabezado 3 |
|--------------|--------------|--------------|
| Celda 1      | Celda 2      | Celda 3      |
| Celda 4      | Celda 5      | Celda 6      |

| Alineado izq | Centrado | Alineado der |
|:-------------|:--------:|-------------:|
| Izquierda    | Centro   | Derecha      |
```

## Enlaces de notas al pie
```markdown
Texto con nota al pie[^1]

[^1]: Contenido de la nota al pie
```

## Listas de definición (algunos editores)
```markdown
Término
: Definición del término

Otro término
: Primera definición
: Segunda definición
```

## HTML embebido
```markdown
<div align="center">
  <strong>Texto en HTML</strong>
</div>

<br>
<hr>
```

## Escapar caracteres especiales
```markdown
\* Asterisco literal
\_ Guión bajo literal
\# Numeral literal
\[ Corchete literal
\] Corchete literal
\\ Barra invertida literal
```

## Fórmulas matemáticas (con soporte LaTeX)
```markdown
Fórmula en línea: $E = mc^2$

Fórmula en bloque:
$$
\frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$
```

## Comentarios
```markdown
[//]: # (Este es un comentario)
[comment]: <> (Este también es un comentario)
```

## Detalles colapsables (GitHub Flavored Markdown)
```markdown
<details>
<summary>Haz clic para expandir</summary>

Contenido oculto que se muestra al hacer clic

</details>
```

## Emojis (GitHub, Discord, etc.)
```markdown
:smile: :heart: :rocket: :fire:
```

## Menciones y referencias (GitHub)
```markdown
@usuario
#123 (issue/PR number)
SHA: abc123def456
usuario/repositorio#123
```

# Alertas y bloques especiales en GitHub

GitHub tiene bloques de alerta especiales que se ven muy nice:

## Sintaxis de alertas

```markdown
> [!NOTE]
> Información útil que los usuarios deberían saber, incluso al ojear el contenido.

> [!TIP]
> Consejo útil para hacer las cosas mejor o más fácil.

> [!IMPORTANT]
> Información crucial que los usuarios necesitan saber para lograr su objetivo.

> [!WARNING]
> Contenido urgente que demanda atención inmediata del usuario debido a riesgos potenciales.

> [!CAUTION]
> Consecuencias negativas potenciales de una acción.
```

## Cómo se ven

**NOTE** - Azul, ícono de información
**TIP** - Verde, ícono de bombilla
**IMPORTANT** - Morado/Violeta, ícono de mensaje
**WARNING** - Amarillo/Naranja, ícono de advertencia
**CAUTION** - Rojo, ícono de peligro

## Ejemplos prácticos

```markdown
> [!NOTE]
> Este proyecto usa Node.js 18 o superior.

> [!TIP]
> Usa `npm ci` en lugar de `npm install` para builds más rápidos en CI/CD.

> [!IMPORTANT]
> Necesitas configurar las variables de entorno antes de ejecutar la app.
> Copia `.env.example` a `.env` y completa los valores.

> [!WARNING]
> No subas tu archivo `.env` al repositorio. Ya está en `.gitignore`.

> [!CAUTION]
> Ejecutar `npm run delete-db` eliminará TODOS los datos permanentemente.
```

## Con múltiples líneas

```markdown
> [!TIP]
> Puedes usar múltiples líneas en estos bloques.
> 
> Incluso con saltos de línea y **formato** _adicional_.
> - Listas
> - También funcionan
> 
> ```javascript
> // Y bloques de código
> console.log("Nice!");
> ```
```

Oka, ahí está todo lo que necesitas para escribir Markdown como un pro. La mayoría de editores soportan el estándar básico, pero cosas como tablas, tareas y fórmulas dependen del sabor de Markdown que uses (GitHub, CommonMark, etc.). Nice para documentación y README files 🚀