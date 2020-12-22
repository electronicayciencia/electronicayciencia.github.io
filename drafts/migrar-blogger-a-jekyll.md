---
title: Migrar de blogger a Jekyll
layout: post
assets: /assets/drafts/migrar-blogger-jekyll
image: /assets/drafts/migrar-blogger-jekyll/img/featured.jpg
featured: false
tags:
  - Informática
---

En esta entrada te explico cómo hice la migración de Blogger a Jekyll. No te voy a mentir: es difícil. Como en todas las migraciones, cuesta mucho dejar todo bien. Tampoco tengo un programa listo para usar que migre tu blog. Pero intentaré con este post ahorrarte tiempo si te ves en un caso parecido.

La migración tiene tres partes:

- **Descargar el blog** a local. Pero no sólo los artículos, eso es lo más fácil, sino también las imágenes y otros archivos (zip, audios, etc).
- **Montar el entorno** Jekyll local y aprender a usarlo. Personalizarlo a tu manera.
- **Convertir el blog** a Markdown e importarlo en Jekyll. Aunque también soporta HTML, pero si sigues leyendo verás por qué no queda bien.

## ¿Por qué?

¿Cuántas páginas de las que visitas habitualmente o vídeos que te gustan estarán disponibles el año que viene? ¿Y dentro de 5 años? ¿10 años? Cualquiera que tenga una colección de favoritos sabe lo rápido que desparece la información en internet. Google puede seguir ofreciencio Blogger otros 15 años, o puede decidir que ya no le es rentable y cerrarlo. El tráfico e ingresos que obtiene con un canal de Youtube no es ni comparable al que obtiene con un blog.

El detonante ha sido el nuevo editor. A mediados de año (2020) Google deshabilitó la opción de volver al editor clásico de Blogger y forzó el uso del editor nuevo. Podríamos decir que no estaba bien pulido. No es que a mí me gustara más el antiguo, es un sentimiento generalizado. Por ejemplo: [Google's NEW Blogger interface does not work properly!](https://makingamark.blogspot.com/2020/06/googles-new-almost-default-blogger-work.html), 

{% include image.html size="medium" file="blogger_editor_bugs.png" caption="Problemas en el foro de soporte de Google acerca del nuevo editor." %}

¿La respuesta de Google? Algo como: *Ahora funciona así. Habernos dado feedback durante el periodo de convivencia en vez de volver directamente al editor viejo.* ([Comunicado](https://support.google.com/blogger/thread/58098347?hl=en)). 

No se lo reprocho, es su servicio y hacen con él lo que les parece mejor. Como yo con mi blog. Editar en GitHub además me permite escribir en Markdown y versionado. Ahora tengo un sitio web principalmente estático que podría alojar fácilmente en cualquier otra plataforma.

## Descarga a local

Lo primero es reunir todos los estáticos (Jekyll los llama *assets* -activos-) de tu blog. El texto es fácil: ir a blogger y descargar una copia de seguridad. Nos guarda los artículos y también la plantilla y comentarios.

Después las imágenes. Si las tienes alojadas en Blogger debes saber que todas están en el mismo album. Yo las quería agrupadas por post, no todas en la misma carpeta. Hice un script para recorrer todos los enlaces de imágenes en los artículos y me bajé a local los archivos.

En imágenes grandes Blogger reduce la calidad para optimizar el tiempo de carga de la página. Dejando la original enlazada. En tal caso no es suficiente descargar el archivo `src` del tag `img`. Debemos descargar el `href` del enlace. 

Ejemplo:

```html
<table align="center" cellpadding="0" cellspacing="0" class="tr-caption-container" style="margin-left: auto; margin-right: auto; text-align: center;">
  <tbody>
  <tr>
    <td style="text-align: center;">
      <a href="https://1.bp.blogspot.com/-pmzOaynv78w/Xu8vqEClmwI/AAAAAAAABow/PYzfPrbdP1cH_bevCdM8rRDt2vwoM-HFgCLcBGAsYHQ/s1600/buffer_circular.png" imageanchor="1" style="margin-left: auto; margin-right: auto;">
        <img border="0" data-original-height="303" data-original-width="468" height="206" src="https://1.bp.blogspot.com/-pmzOaynv78w/Xu8vqEClmwI/AAAAAAAABow/PYzfPrbdP1cH_bevCdM8rRDt2vwoM-HFgCLcBGAsYHQ/s320/buffer_circular.png" width="320" />
      </a>
    </td>
  </tr>
  <tr>
    <td class="tr-caption" style="text-align: center;">Un búfer circular se configura fácilmente.</td>
  </tr>
  </tbody>
</table>
```

El resto de activos dependerá del blog en concreto.

Si no quieres alojar los estáticos en GitHub hay otras soluciones, por ejemplo un S3. Por eso en cada post he introducido la variable `assets` indicando al resto de componentes dónde están alojados sus estáticos.

## Montar el entorno local

La pieza principal es Jekyll. Es un generador de sitios estáticos. Se trata de un software escrito en **Ruby** que ejecuta unas plantillas y genera un directorio `_sites` donde sólo hay cosas estáticas (html, imágenes, archivos, etc). Eso es lo que publica GitHub Pages.

Las plantillas están escritas en un lenguaje que se llama *Liquid*. Cada página o post tiene unas cabeceras YAML que se llaman *Front Matter* y al final se traducen en variables para usarse en las plantillas de Liquid.

Necesitarás linux. Se puede montar Jekyll en Windows o en contenedores. Pero si es la primera vez que lo usas mejor hacerlo en un entorno conocido. De lo contrario no sabrás si los errores que te van a salir se deben al entorno.

No entro a describir el proceso de instalación porque está muy bien explicado en la documentación oficial:

- [Configurar un sitio de Páginas de GitHub con Jekyll](https://docs.github.com/es/free-pro-team@latest/github/working-with-github-pages/setting-up-a-github-pages-site-with-jekyll)
- [Jekyll Quickstart](https://jekyllrb.com/docs/)

Eso sí, ten cuidado de instalar la versión de Jekyll y plguins que usa GitHub, de lo contrario el resultado puede ser distinto.

- [Dependency versions](https://pages.github.com/versions/)

Te quedará una estructura parecida a esto:

```
.
├── 404.html
├── Gemfile
├── Gemfile.lock
├── _config.yml
├── _includes
├── _layouts
├── _posts
├── _sass
├── _site
├── assets
├── about.md
├── index.html
├── petprojects.md
└── tags.html
```

Por defecto Jekyll toma los activos (digamos imágenes) del directorio *assets*. Es cómodo si no te importa tener todas las imágenes en la misma carpeta. Como yo raramente uso la misma en dos artículos prefiero tenerlas separadas. Cuando me bajé las imágenes lo hice separándolas por año, mes y título del post. Esta sería mi estructura de estáticos:

```
├── assets
│   ├── 2012
│   │   ├── 09
│   │   │   ├── practicas-tpm-virtual
│   │   │   │   └── img
│   │   │   │       ├── 20200925_124336.jpg
│   │   │   │       └── tpm_soldada.jpg
│   │   │   └── sintetizador-de-frecuencias-digital-con
│   │   │       ├── MT-086.pdf
│   │   │       ├── SM5124A.pdf
│   │   │       ├── img
│   │   │       │   ├── HEF4046BP-8649.jpg
│   │   │       │   ├── entrada-salida-buffer.png
│   │   │       │   └── uniden_pro_520e_vco.jpg
│   │   │       └── uniden_pro_520e_sm_sch.jpg
│   │   └── 10
│   │       └── obteniendo-ploam-password-fast-5657
│   │           └── img
│   │               ├── TR_as_admin.png
│   │               ├── acs_unauthorized.png
│   │               └── x_mm_remoteaccess.png
...
```

Antes de continuar te recomiendo que trabajes con algunos artículos de prueba. Aprende cómo enlazar otros artículos, insertar imágenes, videos, etc. No te preocupes por ahora del aspecto general de la web.

## Importar los posts

Ya tienes todo lo necesario en local. Funciona. Puedes hacer pruebas y sabes editar. Es hora de trabajar en migrar las entradas.

La **buena noticia** es que hay un plugin que convierte las entradas del backup de blogger en posts de Jekyll. Sólo hay que instalar la gema y lanzar este hechizo (https://import.jekyllrb.com/docs/blogger/):

```shell
$ ruby -r rubygems -e 'require "jekyll-import";
    JekyllImport::Importers::Blogger.run({
      "source"                => "./blog-12-05-2020.xml",
      "no-blogger-info"       => false, # not to leave blogger-URL info (id and old URL) in the front matter
      "replace-internal-link" => false, # replace internal links using the post_url liquid tag.
    })'
```

La **mala noticia** es que te deja los artículos en HTML. Es decir, así:

{% include image.html file="post_html_feo.png" caption="Artículo en HTML procedente de Blogger." %}

Yo no quería eso. Busqué un conversor de HTML a Markdown pero ninguno me dio un resultado aceptable. Así que me hice uno.

Quizá estás pensando -como yo en su momento- que transcribir un HTML sencillo a Markdown no es complicado. En este blog no uso formatos complicados. Casi todo es texto, **negritas**, *cursivas*, imágenes insertadas, y algún video. Falso. Muy falso. No sabes hasta qué punto de falso.

Por dos razones:

- HTML es más potente que Markdown. Markdown sólo admite un subconjunto del formato de HTML. Tienes que decidir qué hacer con aquellos formatos no soportados oficialmente. Por ejemplo texto de colores.
- Blogger no sólo usa HTML para el contenido, también lo usa como parte del estilo. Es más, a lo largo de 10 años el HTML generado por el editor de Blogger ha ido cambiando.


Te voy a contar lo que puedes esperar si piensas transcribir a Markdown tus artículos de Blogger:

Para empezar, **html inconsistente**. Los navegadores suelen ser muy tolerantes al HTML mal formateado pero si intentas parsear el artículo con una librería XML, no va a ser fácil.

- etiquetas abiertas no cerradas (y al revés, por ejemplo un `</a>` que no empieza).
- etiquetas no reconocidas (por ejemplo aquella vez que escribiste `i < j` y el editor de blogger autocompletó el tag `< j >`. O cuando escribiste <k> para cursivas y el editor no te dijo nada.
- uso de tags inconsistente. Por ejemplo <br> y <br />, <em> e <i> para cursivas, <b> y <strong>
- formato en bloques div y span. Si cambiaste el color de fondo de algún texto, antes te lo hizo con DIV, pero luego cambió a hacerlo con SPAN.
- formatos vacíos (negritas, cursivas, span, div). El texto original está lleno de `<b></b>` y `<em></em>`. O peor aún mezclas: `<b><br /><em></em></b>`.


Cuando analices el **texto normal** debes interpretar:

- negritas, cursivas
- separación en párrafos
- títulos de sección

Pero también encontrarás otros elementos de formato **no soportados**. Deberás decidir si los eliminas, los sustituyes por otro formato sí soportado o mantienes el formato dejando el tag html tal cual en el fichero markdown.

- subrayado
- colores
- texto alineado a la derecha
- div con formatos varios: fuentes más pequeñas, color de fondo, etc.

Dentro de los párrafos encontrarás **enlaces** de varios tipos:

- a otros posts del blog: deberás sustituirlos por una sintaxis de Jekyll especial.
- a assets (estáticos o ficheros)
- a sitios externos

El elemento más complicado de analizar son las **imágenes**. Tendrás:

- imagenes con ancho estándar (tipo 480px o 200px): puedes hacer una clase CSS para estos tamaños.
- no estandar (181px): ¿las englobas en una clase existente?
- sin ancho (tamaño original)
- con link y sin link. Si la imagen era pequeña Blogger la habrá insertado directamente en el post. Si era mayor, habrá insertado una imagen de menor tamaño con un link asociado a la original.
- con caption y sin caption. Las imágenes con pie de foto Blogger las inserta como una tabla de 2x1. En la fila superior está la imagen y en la inferior el pie.
- Formato en las etiquetas: aplica lo mismo que para el formato de párrafos.
  - Saltos de línea
  - negritas, cursivas
  - etiquetas con links a posts, a externos y a ficheros.

Después tenemos el **texto preformateado**. Bloques de código o no, con fuente de ancho fijo. Lo puedes encontrar:

- bloques de código con el tag `<pre>` ya sea indicando el lenguaje o no.
- formateado en varias líneas dentro de `span nonospace`
- formateado en un bloque con `div monospace`
- líneas individuales cada una con span pero pertenecientes todas al mismo bloque de texto. Deberás identificar ese caso y agruparlas.
- HTML soporta formato (negritas, cursivas, colores) dentro de estos bloques. Markdown no.

Otra estructura fácilmente identificable son las **listas**:

- listas numeradas
- listas sin numerar
- ítems con varios párrafos (Markdown sí lo soporta).
- imágenes dentro de la los elementos de la lista.
- formato de texto en los elementos
- listas anidadas

También es posible que encontremos **texto citado** con `<blockquote>`:

- formato en texto citado
- citado anidado
- blockquote para indentación pero sin formato de cita

Por último hay determinados objetos que no pueden traducirse a Markdown fácilmente como:

- tablas. Aunque Markdown soporta tablas, no soporta celdas extendidas a varias columnas (*colspan*). En ese caso es mejor dejar el HTML tal cual.
- ecuaciones. Tanto *inline* como *display*. Voy a seguir usando Mathjax por tanto esto no cambia.
- objetos insertados. Tales como:
   - videos de youtube
   - hojas de spreadsheet
   - gráficos de spreadsheet

Debes aprender a escribir en Markdown cada uno de esos elementos. Decidir qué hacer con los que no están soportados oficialmente. Después ver de qué manera puedes reconocer cada estructura, identificarla en el HTML y transcribirla. Te voy a contar cómo lo he hecho yo, no porque sea la mejor forma. Pero podría ahorrarte algo de tiempo en el futuro.

Es tentador hacer un *buscar y reemplazar*. Por ejemplo buscar `<b>` y sustituirlo por `**`. Buscar un enlace `<a href=` y sustituirlo por el equivalente en Markdown `[texto](href)`. ¡Es una trampa! Funciona y es muy sencillo con estructuras fácilmente reconocibles. Pero se vuelve complejo muy rápidamente. Enseguida verás que unos cambios afectan a otros y te verás poniendo mas excepciones que reglas. No sigas por ahí.

Es más complicado pero más simple hacerse un ***parser***. Un analizador que identifica componentes del texto y lo transforma a una estructura intermedia. Cada componente luego puede tratarse de manera independiente. Las reglas aplicadas para un componente no afectan a otros. El proceso sería:

- Identificar estructuras reconocibles. Imágenes, listas, texto citado, texto preformateado, ...
- Lo que queda una vez quitadas todas las estructuras son párrafos de texto.
- Algunos componentes se pueden agrupar: múltiples lineas preformateadas hacen un bloque de texto.
- Identificar componentes dentro de estos. Te quedará una estructura más o menos en forma de árbol. Por ejemplo:
  - los párrafos pueden tener enlaces y el texto de estos tener formato. 
  - Las imágenes pueden tener etiquetas y estas a su vez enlaces. 
  - El texto citado puede tener listas y estas enlaces.
- Aplicar reglas particulares dentro de cada componente. Por ejemplo el formato `<b>negritas</b>` dentro de un párrafo se sustituye por `**negritas**`; mientras que el mismo formato dentro de un bloque pre lo eliminaremos.










Proceso:
 - backup local del blog
   - posts
   - bajarse las imágenes
   - bajarse los activos
 - instalar jekyll localmente y familiarizarse con el proceso
   - estructura
   - donde poner los assets
   - donde los posts
   - cómo hacer un css personalizado
   - post de prueba y empezar a trastear
 - ejecutar jekyll blogger importer
 - post-procesar posts
   - markdown a html
   - descripciones
   - retaging 
   - featured posts
 - Personalizar
 - Imagen
   - favicon (https://favicon.io/favicon-generator/)


personalización del tema base
 - iconito rss
 - centrar imágenes
 - centrar vídeos
 - paginar posts
 - siguiente y anterior en el índice
 - siguiente y anterior en el post
 - logo en la esquina superior izquierda
 - lista de posts 
   - resúmen
   - imagen (redimensionar imagen con css)
   - post destacado (bordes redondeados, icono campana)
 - tabla de contenido
   - usando markdown
   - usando plantilla liquid
 - tags
   - página de tags
   - etiqueta de tag
   - tags en los posts
 - javascript personalizado
   - div clickable en lista de posts
   - mathjax en header
   - quitar mensaje de mathjax
   - gestos swipe para pasar página
 - responsive 
   - media querys en css
   - especial pantallas muy anchas (blog de next - https://www.bbvanexttechnologies.com/seguridad-personalizada-en-entornos-resilientes/)
 - seo
   - rss
   - resumen articulo
   - featured image
   - twitter card tags
   - sitemap




metadatos:
 - suprimir datos de blogger de la cabecera
 - cabecera assets
 - cabecera featured
 - cabecera image





dominio personalizado en namecheap
disqus para comentarios


Ejemplo blog con minima:
https://github.com/ouyi/ouyi.github.io/tree/master/_posts
https://ouyi.github.io/










   
   