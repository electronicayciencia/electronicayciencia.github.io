---
title: Migrar de Blogger a Jekyll
layout: post
assets: /assets/2020/12/migrar-blogger-jekyll
image: /assets/2020/12/migrar-blogger-jekyll/img/post_html_feo.png
featured: false
tags:
  - Informática
---

Aquí te explico cómo convertí los artículos de HTML a Markdown haciendo un parser y algunas personalizaciones de los estilos y el tema. No puedo darte un programa automático para migrar tu blog, pero puedo contarte cómo lo he hecho yo y quizá ahorrarte trabajo.

Para mí, la migración han sido tres partes:

- **Descargar el blog** a local. Pero no sólo los artículos, eso es lo más fácil, también las imágenes y otros archivos (zip, audios, etc.).
- Aprender cómo funciona Jekyll. **Montar un entorno** local y personalizarlo a tu manera.
- **Convertir el blog** a Markdown e importarlo en Jekyll. Aunque también soporta HTML, pero descubrirás que no queda igual de bien.

## Descarga a local

Hoy día el texto es un medio minoritario frente al video. El tráfico e ingresos que obtiene Google con un canal de YouTube no es ni comparable al que obtiene con un blog. Blogger podría seguir existiendo otros 15 años o podría cerrar mañana mismo por no ser rentable. Cualquiera que tenga una colección de favoritos sabe lo rápido que desparece la información en Internet.

Empecé a pensar cómo tener una copia de mi blog, en local, navegable. No es más que texto, imágenes y algunos archivos comprimidos. Además, un video ocupa varios gigabytes y necesitas una plataforma para servirlo. Pero un blog entero son unos cuantos megabytes y puedes servirlo casi desde cualquier hosting web.

Este verano (2020) cambiaron el editor de Blogger. Google deshabilitó la opción de volver al editor clásico y forzó el uso del nuevo. El cual, por decirlo suavemente *no estaba listo para el público*. Hubo mucha gente que se quejó y dieron marcha atrás. Por ejemplo: [Google's NEW Blogger interface does not work properly!](https://makingamark.blogspot.com/2020/06/googles-new-almost-default-blogger-work.html),

{% include image.html size="big" file="blogger_editor_bugs.png" caption="Problemas en el foro de soporte de Google relacionados con el nuevo editor." %}

¿La respuesta de Google quienes reportaban un mal funcionamiento? Algo como: *Ahora funciona así. Habernos dado feedback durante el periodo de convivencia en vez de volver directamente al editor viejo.* ([Comunicado](https://support.google.com/blogger/thread/58098347?hl=en)).

Nada que objetar; el gato es suyo y toman las decisiones oportunas en cada momento. Yo seguí dándole vueltas. Pasar el blog a Markdown y guardarlo en local me permitiría:

- Tenerlo guardado en un formato fácilmente legible y editable. Separando el estilo del **contenido**.
- Generar una copia local **navegable** formada sólo por ficheros estáticos sin una base de datos detrás.
- Editar y **versionarlo** más fácilmente, por ejemplo en GitHub.
- Publicar fácilmente ese sitio **estático** en cualquier hosting sencillo. Por ejemplo GitHub Pages.

Lo primero que necesitaba era reunir todos los estáticos: El texto era fácil estaba en Blogger, venía en la copia de seguridad, junto a las plantillas y los comentarios. Las imágenes estaban en el servicio de almacenamiento de Google (como lo llamen ahora). También tengo algunos archivos compartidos en Dropbox y en Google Sites.

Al principio pensé que sería fácil. Hice un script para recorrer la lista de artículos. Crear un directorio por cada uno. Buscar enlaces o imágenes en el HTML y bajármelos al directorio adecuado. Lo llamé [post-saver.sh](https://github.com/electronicayciencia/eyc-backup/blob/master/post-saver.sh).

Al final la cosa fue más complicada de lo que parecía. En **imágenes grandes** Blogger reduce la calidad para optimizar el tiempo de carga de la página. Dejando la original enlazada. En tal caso no es suficiente descargar el archivo `src` del tag `img`. Debemos descargar el archivo del enlace.

Esta sería una imagen de nombre *buffer_circular.png*. Cuyo ancho original es 468px pero en el artículo se muestra reducida a 320px. El enlace original acaba en `.../s1600/buffer_circular.png` mientras el reducido en  `.../s320/buffer_circular.png`. La imagen tiene una etiqueta debajo.

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

En algunos posts antiguos las imágenes insertadas tienen HTML. Por ejemplo este enlace <http://4.bp.blogspot.com/_QF4k-mng6_A/S6eJByqfKZI/AAAAAAAAAAU/PN_WPKeqdz0/s1600-h/Imagen149.jpg>
no contiene una imagen, sino una página web. La `h` de `s1600-h` parece indicar *html*:

```html
<html>
<head>
<title>Imagen149.jpg (image)</title>
<script type="text/javascript">
<!--
if (top.location != self.location) top.location = self.location;
// -->
</script>
</head>
<body bgcolor="#ffffff" text="#000000">
<img src="http://4.bp.blogspot.com/_QF4k-mng6_A/S6eJByqfKZI/AAAAAAAAAAU/PN_WPKeqdz0/s1600/Imagen149.jpg" alt="[Imagen149.jpg]" border=0>
</body>
</html>
```

## Montar el entorno local

Con todo en local llega la hora de servirlo. Jekyll es un generador de sitios estáticos. No es el único. Se trata de un software que lee unos archivos de origen (en HTML o Markdown), les aplica unas plantillas y genera con ellos un directorio conteniendo el sitio web en HTML. Este directorio podríamos publicarlo tal cual en cualquier hosting.

Así es como funciona GitHub Pages. Cuando activamos la publicación de un repositorio, el **pipeline** de GitHub ejecuta Jekyll, construye el sitio web y lo sirve.

Nos vendrá bien replicarlo en local para hacer pruebas. El proceso de instalación está explicado en la documentación oficial:

- [Configurar un sitio de Páginas de GitHub con Jekyll](https://docs.github.com/es/free-pro-team@latest/github/working-with-github-pages/setting-up-a-github-pages-site-with-jekyll)
- [Jekyll Quickstart](https://jekyllrb.com/docs/)

Procura instalar la versión de Jekyll usada por GitHub, no una más reciente. De lo contrario el resultado puede ser distinto: [Dependency versions](https://pages.github.com/versions/)

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

Ahora debes pensar cómo quieres organizar el directorio de estáticos. Yo los quiero agrupados por año, mes y título del post. Por ejemplo `/assets/2012/09/practicas-tpm-virtual`. Y dentro de este, `./img` contendrá las imágenes del post.

La estructura de directorios quedaría así:

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

Antes de continuar trabaja con algunos artículos de prueba. Aprende cómo enlazar otros posts, insertar imágenes, videos, etc.

## De HTML a Markdown

Ya tienes todo lo necesario en local. Funciona. Puedes hacer pruebas y sabes editar. Es hora de cargar las entradas. Tengo una noticia buena y otra mala.

La **buena noticia** es este plugin para convertir las entradas del backup de Blogger en posts de Jekyll con metadatos y todo. Sólo hay que instalar la gema y lanzarlo como se indica en [la documentación](https://import.jekyllrb.com/docs/blogger/):

```shell
$ ruby -r rubygems -e 'require "jekyll-import";
    JekyllImport::Importers::Blogger.run({
      "source"                => "./blog-12-05-2020.xml",
      "no-blogger-info"       => false, # not to leave blogger-URL info (id and old URL) in the front matter
      "replace-internal-link" => false, # replace internal links using the post_url liquid tag.
    })'
```

La **mala noticia** es que te deja los artículos en HTML tal como vienen de Blogger. Es decir, así:

{% include image.html file="post_html_feo.png" caption="Artículo en HTML procedente de Blogger." %}

Querrás convertirlos a Markdown. Buscarás un programa para convertirlo pero ninguno te dará un resultado aceptable. Te planteas reescribirlo todo o hacer un conversor tú mismo.

¿Cómo harías un **conversor de HTML a Markdown**? Tu primera idea podría ser *buscar y reemplazar* determinados signos. Digamos sustituir `<b>` por `**`. Quizá piensas que, si escribir en Markdown es sencillo, transcribir un HTML a Markdown no será tan complicado. Pues **es complicado** precisamente porque HTML es más potente.

- Hay formatos no soportados. Tal como texto de colores, subrayado, alineado a la derecha, con otra tipografía, etc.
- Hay varias maneras de hacer lo mismo. Por ejemplo los estilos pueden aplicarse tanto en el tag como en la plantilla CSS. Los tags `<em>` e `<i>` aunque sean diferentes ambos se traducen por cursivas.
- A lo largo de 10 años el HTML generado por el editor de Blogger ha ido cambiando.

Pronto caerás en la cuenta de que tienes HTML tipo `<a href="enlace">texto</a>` y quieres convertirlo a `[texto](enlace)`. Parece fácil hacerlo con expresiones regulares. ¡No! Es una trampa. Al principio funciona sí, pero se vuelve complejo muy rápidamente. Conforme avances verás cómo las sustituciones que hagas al principio afectarán a las posteriores. Y se hará muy complicado de mantener y depurar. Porque [no puedes parsear HTML con regexp](https://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags?page=1&tab=votes#tab-top).

Solo avanzarás si consigues **aislar las estructuras** y convertirlas por separado. Así puedes aplicar cambios a la etiqueta de una imagen sin afectar a una tabla más abajo en el mismo post.

Al final di con este método:

- buscar en el texto estructuras reconocibles (una imagen, una tabla, una lista, texto citado, etc)
- un vez identificada, guardar el contenido aparte y sustituirla por un *token* (#img-1#, #table-1#, etc) para saber en qué posición iba dentro del artículo.
- procesar la estructura individualmente:
  - buscar otras que pueda tener anidadas (otra lista, formato de texto, enlaces). Aquí es donde todo se vuelve complicado.
  - sustituir lo encontrado por su correspondiente *token* (#link-1#, #ul-1#, ...).
- si no hemos olvidado nada, lo que queda en el artículo una vez quitado todo lo especial debe ser sólo texto. Los agrupamos en párrafos y los tratamos como otra estructura más siguiendo los puntos anteriores.
- recorrer el artículo, ahora compuesto sólo por *tokens*, sustituyendo cada cosa por su representación en Markdown.

{% include image.html file="estructura_intermedia.png" caption="Estructura abstracta de un artículo." %}

Un poco de formalismo. El HTML es una **gramática de tipo II** (con anidación). No se puede procesar con expresiones regulares que -por eso se llaman así- sólo valen para lenguajes regulares (gramática tipo III). Lo que sí puede hacerse es identificar partes usando expresiones regulares y programar un **analizador sintáctico** personalizado. Almacenar las partes interesantes en una variable (a modo de pila) y construir el árbol abstracto. Esa abstracción es común a HTML y Markdown. Sólo debemos transcribirlo. Pensándolo ahora, igual habría sido más fácil usar herramientas tipo ANTLR ([ANother Tool for Language Recognition](https://www.antlr.org/)).

Durante el proceso he encontrado **HTML inconsistente**. Te puede dar problemas con ciertas librerías:

- etiquetas no cerradas (y al revés, por ejemplo un `</a>` que no empieza).
- etiquetas inexistentes (una vez escribí `se<f1>oras` para señalar UTF-8, pero el editor de Blogger autocompletó el tag `<f1>` y puso otro `</f1>` al final de la frase).
- uso de tags inconsistente. Por ejemplo `<br>` y `<br />`, `<em>` e `<i>` para cursivas, `<b>` y `<strong>`.
- formato aplicado tanto con `div` como `span`.
- formatos vacíos (negritas, cursivas, span, div). El texto original está lleno de `<b></b>` y `<em></em>`. O peor aún mezclas: `<b><br /><em></em></b>`.

En cuanto a estructuras, las más reconocibles son las **imágenes**. Las hay de varios tipos:

- imágenes con ancho estándar (tipo 480px o 200px): puedes hacer una clase CSS para estos tamaños.
- imágenes con alto estándar (tipo 480px o 200px): puedes hacer una clase CSS para estos tamaños.
- sin ancho (tamaño original)
- con link y sin link. Si la imagen era pequeña, Blogger la habrá insertado directamente en el post. Si era mayor, habrá insertado una imagen de menor tamaño con un link asociado a la original.
- con *caption* y sin *caption*. Blogger inserta los pies de foto como una tabla de 2x1.

Después tenemos el **texto preformateado**. Bloques -de código o no- con fuente de ancho fijo.

- bloques de código con el tag `<pre>` ya sea indicando el lenguaje o no.
- formateado en varias líneas dentro de `span monospace`
- formateado en un bloque con `div monospace`
- líneas individuales cada una con span pero pertenecientes todas al mismo bloque de texto. Deberás identificar ese caso y agruparlas.
- Además, HTML soporta formato (negritas, cursivas, colores) dentro de estos bloques pero Markdown no. Habrá que suprimirlo.

Otra estructura fácilmente identificable son las **listas**:

- listas numeradas
- listas sin numerar
- ítems con varios párrafos (esto Markdown sí lo soporta).
- imágenes dentro de los elementos de la lista.
- formato de texto en los elementos
- listas anidadas

También es posible que encontremos **texto citado** con `<blockquote>`:

- formato en texto citado
- citado anidado
- incluso blockquote usado para indentar un texto pero sin aplicar formato de cita

Finalmente hay objetos que no tienen traducción directa a Markdown. En tal caso es mejor dejar el HTML.

- tablas. Aunque soporta tablas, no soporta celdas extendidas a varias columnas con *colspan*.
- ecuaciones. Tanto *inline* como *display*.
- iframes: videos de YouTube, hojas cálculo de spreadsheet o gráficos.

Cuando analices el **texto normal** (podría ser la etiqueta de una foto, el texto de un enlace, una cita, un párrafo o un ítem de una lista, entre otros), cabe esperar elementos de **formato soportados** y **no soportados**. Deberás decidir si los eliminas; los sustituyes por otro formato sí soportado; o mantienes el formato dejando el tag HTML tal cual en el fichero Markdown:

- subrayado
- color del texto o de fondo
- texto alineado a la derecha o centrado
- tamaño de la fuente o diferentes tipografías

Entre los **enlaces**, estos pueden ser:

- a otros posts del blog: deberás sustituirlos por una sintaxis de Jekyll especial.
- a assets (estáticos o ficheros): deberás sustituirlos por la ruta donde pusiste los estáticos.
- a sitios externos

Todo esto lo hice en un script de **Perl**: [post_process.pl](https://github.com/electronicayciencia/electronicayciencia.github.io/blob/master/importer/post_process.pl). Cuando no sabes lo que te puedes encontrar por el camino, mejor usar un lenguaje más flexible aunque penalice la legibilidad. Y Perl es el lenguaje más potente para expresiones regulares.

Además, quería usar un **patrón de programación** concreto: la opción `/e`. Vale para hacer una sustitución en una expresión regular; pero no por un string fijo sino por el resultado de ejecutar una función usando como parámetros la parte coincidente de la regexp. Lo cual me permite *tokenizar* el texto de manera muy compacta.

```perl
# <blockquote></blockquote>
$s =~ s{<blockquote[^>]*>(.+?)</blockquote>}{format_blockquote($1)}ge;

# Format lists blocks
$s =~ s{(<ul>.*?</ul>)}{format_list($1, "ul")}ge;
$s =~ s{(<ol>.*?</ol>)}{format_list($1, "ol")}ge;

# HTML tables
$s =~ s{(<table[^>]*>.*?</table>)}{format_table($1)}ge;
```

## Imágenes

No soy especialista en diseño web así que seguramente habré hecho cosas mal. Tal vez tú sepas hacerlo mejor que yo. Si quieres compartirlo deja un comentario.

Quiero que mis imágenes se muestren centradas, con un ancho seleccionado, con pie de foto y enlazadas para que si haces click te te lleve al archivo original. Markdown no soporta nativamente ese formato pero se puede hacer con HTML. Tengo entendido que la forma correcta para el pie de foto es con `figure` y `figcaption`. Así se vincula la etiqueta a la imagen y facilitamos la tarea a los buscadores.

Las plantillas de Jekyll están escritas en *Liquid*. Cada página o post cuenta con una cabecera YAML llamada *Front Matter* donde van los metadatos. La cabecera Front Matter se traduce a variables que luego pueden usarse en las plantillas.

Liquid soporta *includes*. Es más, soporta parámetros en los *includes*. Es más, insertar una imagen con includes es el ejemplo que usan en la [documentación de Jekyll](https://jekyllrb.com/docs/includes/). Acto seguido te dicen que no lo hagas.

> Note that you should avoid using too many includes, as this will slow down the build time of your site. For example, don’t use includes every time you insert an image. (The above technique shows a use case for special images.)

En el directorio *_includes* he creado el fichero `image.html` con este contenido:

{% raw %}
```html
<div class="postimage">
<figure>
  <a href="{{page.assets | relative_url}}/img/{{include.file}}">
  <img 
    src="{{page.assets | relative_url}}/img/{{include.file}}" 
      class="fullwidth {{include.class | default: "original-width"}}"
      alt=""/>
  </a>
  <figcaption>{{ include.caption | markdownify }}</figcaption>
</figure>
</div>
```
{% endraw %}

Tiene tres parámetros -aparte de la variable *assets*, definida en las cabeceras del post-:

- el nombre del **fichero**. Se asume que las imágenes del artículo están todas en la carpeta `/img` de la variable *assets*.
- la etiqueta o **pie de foto**. Para que admita Markdown luego la pasamos por el filtro *markdownify*.
- la clase, generalmente será el **tamaño**. Por defecto asignamos la clase *original-width*. Lo vemos más abajo.

Insertamos una imagen incluyendo el fichero e indicando sus parámetros:

{% raw %}
```html
{% include image.html file="geiger.png" caption="Tubo Geiger-Müller." %}
```
{% endraw %}

Tenía unos requisitos concretos sobre el tamaño de mis imágenes:

- Debe reducirse si es mayor que el ancho indicado, pero nunca agrandarse. Por ejemplo, el tamaño *mediano* son 500 píxeles de ancho. Si la imagen original mide 1000 píxeles, debe mostrarse reducida hasta los 500. Pero si sólo medía 300 no debe agrandarse a 500 sino quedarse en su tamaño natural de 300px.
- El ancho máximo de la imagen no debe superar nunca el ancho del post. Si el ancho *grande* son 700 píxeles pero estás viendo el blog en una pantalla estrecha de ancho menor, debe ignorar esos 700px y reducirse hasta ocupar el 100% del ancho disponible.

No puedo hacerlo con `width` porque también agranda las imágenes más pequeñas. He conseguido hacerlo ajustando el valor de `max-width` en función de un *media query*. No sé si es la forma correcta.

```scss
$img-small-width: 300px;
$img-medium-width: 500px;
$img-large-width: 700px;
$img-x-large-width: 100%;

.small-width {
  max-width: $img-small-width;
  @media (max-width: $img-small-width + 50) {
    max-width: 100%;
  }
}

.medium-width {
  max-width: $img-medium-width;
  @media (max-width: $img-medium-width + 50) {
    max-width: 100%;
  }
}

.large-width {
  max-width: $img-large-width;
  @media (max-width: $img-large-width + 50) {
    max-width: 100%;
  }
}

.x-large-width {
  max-width: $img-x-large-width;
}

.original-width {
  max-width: 100%;
}
```

Imágenes de muestra:

{% include image.html class="small-width" file="pll_protoboard.jpg" caption="Imagen pequeña: 300 pixeles de ancho o 100% del ancho del post." %}

{% include image.html class="medium-width" file="pll_protoboard.jpg" caption="Imagen mediana: 500 pixeles de ancho o 100% del ancho del post." %}

{% include image.html class="large-width" file="pll_protoboard.jpg" caption="Imagen grande: 700 pixeles de ancho o 100% del ancho del post." %}

{% include image.html class="x-large-width" file="pll_protoboard.jpg" caption="Imagen muy grande: 100% del ancho del post." %}

## Vídeos

Al igual que para las imágenes, me he hecho un *include*. Lo he llamado `youtube.html` y usa como parámetro el id del video.

```html
<div class="postvideo">
<iframe 
  src="https://www.youtube.com/embed/{{include.id}}" 
  frameborder="0" 
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
  allowfullscreen>
</iframe>
</div>
```

Así insertaríamos un vídeo:

{% raw %}
```
{% include youtube.html id="BZwuTo7zKM8" %}
```
{% endraw %}

Los vídeos de YouTube embebidos tienen un tamaño fijo. Pero encontré este código CSS que los hace *responsive* manteniendo la relación de aspecto.

```css
.postvideo {
    height: 0;
    overflow: hidden;
    padding-bottom: 56.25%;
    padding-top: 30px;
    position: relative;
    margin-bottom: 1.5rem;
}

.postvideo iframe, .postvideo object, .postvideo embed {
    height: 100%;
    left: 0;
    position: absolute;
    top: 0;
    width: 100%;
}
```

Un vídeo de muestra:

{% include youtube.html id="BZwuTo7zKM8" %}

## Personalización del tema base

Hay infinidad de temas disponibles para Jekyll. Yo he decidido mantener el tema por defecto **minima**. Y personalizarlo. Otros temas pueden incorporar estas y muchas otras cosas. No necesitarás hacerlas a mano. Uno muy completo es [minimal mistakes](https://mmistakes.github.io/minimal-mistakes/).

Para la **tabla de contenidos**, he incluido [jekyll-toc](https://github.com/allejo/jekyll-toc). El texto "Secciones" justo encima (al principio del artículo) lo pongo por CSS. ¿Te has fijado que no lo puedes seleccionar con el ratón?

```scss
/* TOC */
#my_toc::before {
  content: "Secciones";
  line-height: 200%;
  font-weight: bold;
}
```

Pero contar toda la personalización sería muy aburrido. Aquí os dejo una lista de cosas y si te interesa puedes mirar el [repositorio del blog](https://github.com/electronicayciencia/electronicayciencia.github.io). Algunas ideas las he tomado de [Memory Spills - Customizing Jekyll theme](https://ouyi.github.io/post/2017/12/23/jekyll-customization.html).

- En el tema base
  - iconito rss en el menú
  - logo en la esquina superior izquierda
  - página de tags
  - página de archivo
  - fuente de mayor tamaño para pantallas muy anchas
  - quitar mensaje *loading* de MathJax

- En la lista de posts
  - paginado
  - enlaces a siguiente y anterior
  - resumen (extracto)
  - imagen destacada (redimensionar imagen con *object-fit*)
  - post destacado (color de fondo, bordes redondeados, icono campana)
  - clic en cualquier parte del extracto te lleva al artículo
  - pasar página deslizando el dedo
  - tiempo de lectura
  
- En el post
  - enlaces a siguiente y anterior
  - lista de tags e iconos
  - tiempo de lectura

## Borradores

Una cuestión recurrente en los foros de Jekyll es cómo previsualizar un artículo sin publicarlo. La respuesta obvia es con el entorno local del Jekyll. Pero ¿y si queremos hacerlo directamente en GitHub Pages?

Me he creado un directorio especial llamado *drafts* (el nombre da lo mismo puede ser cualquier otro). En la configuración, lo he excluido del sitemap para que Google no lo indexe. Con el `robots.txt` también se puede evitar.

```yaml
defaults:
  - scope:
      path: 'drafts/**'
    values:
      sitemap: false
```

Cualquier post que pongamos en ese directorio, Jekyll lo tratará como una página más y la convertirá a HTML. Sólo debemos asegurarnos de no mostrarlo en el menú de navegación. En el tema *minima* es muy sencillo porque resulta que sólo muestra las páginas con título. Si no tiene título, la omite. Por tanto basta con no rellenar la variable `title` y no se mostrará.

Para acceder al borrador debemos conocer su nombre. Estará bajo /drafts. Por ejemplo: <https://www.electronicayciencia.com/drafts/cheatsheet>. Todo aquel que tenga el enlace podría acceder; útil para compartir la vista previa con varias personas antes de publicarlo.

## Conclusión

La migración no ha sido fácil; las mudanzas nunca lo son. En cualquier caso, he aprendido mucho haciéndolo.

Cuando empecé no conocía los generadores de sitios web estáticos como Jekyll o Hugo. Tampoco Liquid ni el mecanismo con el que GitHub Pages genera los sitios web. No había oído hablar de SCSS ni SASS. tampoco había hecho nunca una web *responsive* usando *media queries* o centrado imágenes con *object-fit*.

Ignoraba cómo funcionan las etiquetas [Open Graph](https://ogp.me/) para compartir una web. Me refiero a las *cards* que muestran las aplicaciones de mensajería tipo WhatsApp o Telegram y las redes sociales como LinkedIn o Twitter cuando compartes un enlace.

{% include image.html class="medium-width" file="card_telegram.png" caption="La descripción e imagen mostradas al compartir se obtienen de las etiquetas Meta [Open Graph](https://ogp.me/) presentes en las cabeceras HTML." %}

Espero que te haya gustado este artículo. No es el camino más cómodo, pero si tienes tiempo y ganas de aprender sobre estos temas te lo recomiendo.
