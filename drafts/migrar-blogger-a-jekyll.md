---
no-title: Migrar de blogger a Jekyll
layout: post
assets: /assets/drafts/migrar-blogger-jekyll
image: /assets/drafts/migrar-blogger-jekyll/img/featured.jpg
featured: false
tags:
  - Informática
---

En esta entrada explico cómo hice la migración de Blogger a Jekyll. Me descargué los artículos y estáticos de blogger a local. Convertí los posts de HTML a Markdown y personalicé el tema de Jekyll. No ha sido fácil pero creo que ha valido la pena.

Si vienes buscando un programa automático para migrar tu blog, lo siento. No tengo un programa listo para usar. Te voy a enseñar los que usé yo tal vez pueda ahorrarte algo de tiempo.

La migración tiene tres partes:

- **Descargar el blog** a local. Pero no sólo los artículos, eso es lo más fácil, también las imágenes y otros archivos (zip, audios, etc).
- **Montar el entorno** Jekyll local y aprender a usarlo. Personalizarlo a tu manera.
- **Convertir el blog** a Markdown e importarlo en Jekyll. Aunque también soporta HTML, pero descubrirás que no queda igual de bien.

## Descarga a local

¿Cuántas páginas o canales habituales estarán disponibles el año que viene? ¿Y dentro de 5 años? ¿10 años? Cualquiera que tenga una colección de favoritos sabe lo rápido que desparece la información en internet. El texto es un medio minoritario frente al video. Y el tráfico e ingresos que obtiene Google con un canal de YouTube no es ni comparable al que obtiene con un blog. Blogger podría existir otros 15 años más o podría cerrar mañana mismo porque ya no es rentable. 

Mi blog no es gran cosa pero es mío. No quiero perderlo. Además, mientras un video ocupa varios gigabytes y necesitas una plataforma para servirlo; un blog entero son unos cuantos megabytes y puedes guardarlo a local y servirlo casi desde cualquier hosting web. Y eso es justamente lo que voy a hacer.

El detonante ha sido el nuevo editor de Blogger. A mediados de año (2020) Google deshabilitó la opción de volver al editor clásico de y forzó el uso del nuevo. Podríamos decir que *no estaba bien pulido*. No es sólo resistencia al cambio, es un sentimiento generalizado. Por ejemplo: [Google's NEW Blogger interface does not work properly!](https://makingamark.blogspot.com/2020/06/googles-new-almost-default-blogger-work.html), 

{% include image.html size="medium" file="blogger_editor_bugs.png" caption="Problemas en el foro de soporte de Google acerca del nuevo editor." %}

¿La respuesta de Google? Más o menos esta: *Ahora funciona así. Habernos dado feedback durante el periodo de convivencia en vez de volver directamente al editor viejo.* ([Comunicado](https://support.google.com/blogger/thread/58098347?hl=en)). Nada que objetar; el gato es suyo y toman las decisiones oportunas en cada momento. 

Pasar el blog a Markdown y guardarlo en local me permitiría:

- Tenerlo guardado en un formato fácilmente legible y editable. Separando el estilo del **contenido**. Algo que el HTML de Blogger ya veremos que no hace.
- Editar y **versionarlo** más fácilmente, por ejemplo en GitHub.
- Generar una copia local **navegable** formada sólo por ficheros estáticos sin una base de datos detrás.
- Publicar fácilmente ese sitio **estático** en cualquier hosting sencillo. Por ejemplo GitHub Pages.

Lo primero es reunir todos los estáticos (Jekyll los llama *assets* -activos-) de tu blog. Para el texto basta con descargar una copia de seguridad. Contendrá los artículos junto a las plantillas y comentarios.

Luego las imágenes. Si las tienes alojadas en Blogger debes saber que todas forman parte del mismo álbum. Para agruparlas por post puedes hacer dos cosas:

- Bajarte todas las imágenes juntas y después separarlas por ejemplo por la fecha.
- Buscar los tags IMG de los artículos y descargarlas una a una.

Yo opté por la segunda opción. Hice un script para recorrer todos los enlaces de imágenes en los artículos y me bajé a local los archivos. Mi script es bastante malo porque no sabía nada de lo siguiente, si tienes curiosidad está aquí: [post-saver.sh](https://github.com/electronicayciencia/eyc-backup/blob/master/post-saver.sh). 

En **imágenes grandes** Blogger reduce la calidad para optimizar el tiempo de carga de la página. Dejando la original enlazada. En tal caso no es suficiente descargar el archivo `src` del tag `img`. Debemos descargar el `href` del enlace. 

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

El resto de archivos estáticos dependerá de tu blog en concreto. GitHub no es la mejor plataforma para alojar estáticos de todas formas. Para una pocas fotos y algunos archivos de poco tamaño puede servir.

## Montar el entorno local

Jekyll es un generador de sitios estáticos. No es el único. Se trata de un software que lee unos archivos de origen, les aplica unas plantillas y genera con ellos un directorio conteniendo el sitio web. Este directorio se llama *_site* y podríamos publicarlo en cualquier hosting.

Cuando activamos GitHub Pages, el **pipeline** de GitHub ejecuta Jekyll sobre nuestro repositorio en cada *push*, construye el directorio *_site* y lo sirve. No es preciso subir el sitio web ya generado salvo que queramos hacer algo que no hace GitHub. Tal como usar plugins o una versión distinta de Jekyll por ejemplo.

Las plantillas están escritas en *Liquid*. Cada página o post cuenta con una cabecera YAML llamada *Front Matter* donde van los metadatos. La cabecera Front Matter se traduce a variables que pueden usarse en las plantillas de Liquid.

El proceso de instalación está bien explicado en la documentación oficial:

- [Configurar un sitio de Páginas de GitHub con Jekyll](https://docs.github.com/es/free-pro-team@latest/github/working-with-github-pages/setting-up-a-github-pages-site-with-jekyll)
- [Jekyll Quickstart](https://jekyllrb.com/docs/)

Procura instalar la versión de Jekyll usada por GitHub, no una más reciente. De lo contrario el resultado puede ser distinto.

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

Ahora debes pensar cómo quieres organizar el directorio local. Yo quiero los estáticos agrupados por año, mes y título del post. Esta sería mi estructura:

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

Antes de continuar trabaja con algunos artículos de prueba. Aprende cómo enlazar otros posts, insertar imágenes, videos, etc. No te preocupes por ahora del aspecto general de la web.

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

Querrás convertirlos a Markdown. Buscarás un conversor de HTML a Markdown pero ninguno te dará un resultado aceptable. Yo en mi blog apenas uso formatos raros. Casi todo es texto, **negritas**, *cursivas*, imágenes insertadas, y algún video. Quizá piensas que, si escribir en Markdown es sencillo, transcribir un HTML a Markdown no será tan complicado. 

Pues **es complicado** precisamente porque HTML es más potente. Markdown sólo admite un subconjunto del formato HTML. Consecuencias:

- Habrá formatos no soportados en Markdown. Por ejemplo texto de colores, tachado, subrayado, alineado a la derecha, con otra tipografía, etc. 
- En HTML hay varias maneras de hacer lo mismo. Por ejemplo los estilos pueden aplicarse tanto en el tag como en la plantilla CSS. Los tags `<em>` e `<i>` aunque sean diferentes ambos se traducen por cursivas. 
- Blogger no sólo usa HTML para el contenido, también lo usa como parte del estilo. Es más, a lo largo de 10 años el HTML generado por el editor de Blogger ha ido cambiando.

¿Cómo harías un **conversor de HTML a Markdown**? Tal vez tu primera idea sea *buscar y reemplazar* determinados signos. Por ejemplo buscar `<b>` y sustituirlo por `**`. 

Pronto caerás en la cuenta de que tienes HTML tipo `<a href="enlace">texo</a>` y quieres convertirlo a `[texto](enlace)`. Parece fácil hacerlo con *expresiones regulares*. Pero [no puedes parsear HTML con regexp](https://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags?page=1&tab=votes#tab-top).

¡Es una trampa! Al principio funciona sí, pero se vuelve complejo muy rápidamente. Conforme avances verás cómo las sustituciones que hagas al principio afectarán a las posteriores. Y se hará muy complicado de mantener y depurar. No sigas por ahí. Puedes hacerlo sí consigues **aislar las estructuras** para convertirlas por separado. Así puedes aplicar cambios a la etiqueta de una imagen sin afectar a una tabla HTML, por ejemplo.

El método que yo he usado es este:

- buscar en el texto estructuras reconocibles (una imagen, una tabla, una lista, texto citado, etc)
- un vez identificada, guardar el contenido aparte y sustituirla por un *token* (#img-1#, #table-1#, etc) para saber donde iba.
- procesar la estructura buscando otras que pueda tener, a su vez, anidada (otra lista, formato de texto, enlaces). Aquí es donde todo se vuelve complicado.
- sustituir lo encontrado por su correspondiente *token* (#link-1#, #ul-1#, ...).
- lo que queda en el artículo una vez quitado todo lo especial debe ser sólo texto. Agrupar en párrafos y tratarlos como otra estructura más como en los puntos anteriores.
- recorrer el artículo, ahora sólo compuesto de *tokens* sustituyendo cada token por su representación en Markdown.

[imagen: texto estructuras]

Poníendonos *formales*, el HTML es una gramática de tipo II (con anidación). No se puede procesar con expresiones regulares que -por eso se llaman así- sólo valen para leguajes regulares (tipo III). Por tanto he programado un **analizador sintáctico** rudimentario para identificar partes usando expresiones regulares, meterlas en una memoria (a modo de stack) y construir el árbol abstracto. Luego lo he volcado en Markdown. Pensándolo ahora, tal vez habría sido más fácil usar herramientas tipo ANTLR [(ANother Tool for Language Recognition)](https://www.antlr.org/). Pero no lo sabía.

Durante el proceso he encontrado **HTML inconsistente**. Te puede dar problemas con algunas librerías:

- etiquetas abiertas no cerradas (y al revés, por ejemplo un `</a>` que no empieza).
- etiquetas inexistentes (recuerda aquella vez que escribiste `se<f1>oras` y el editor de blogger autocompletó el tag `<f1>` y puso otro `</f1>` al final de la frase).
- uso de tags inconsistente. Por ejemplo `<br>` y `<br />`, `<em>` e `<i>` para cursivas, `<b>` y `<strong>`.
- formato en bloques tanto `div` como `span`. Si cambiaste el color de fondo de algún texto, antes te lo hizo con DIV, pero luego cambió a hacerlo con SPAN.
- formatos vacíos (negritas, cursivas, span, div). El texto original está lleno de `<b></b>` y `<em></em>`. O peor aún mezclas: `<b><br /><em></em></b>`.

En cuanto a estructuras, las más reconocibles son las **imágenes**. Las hay de varios tipos:

- imágenes con ancho estándar (tipo 480px o 200px): puedes hacer una clase CSS para estos tamaños.
- no estándar (p.ej. 281px): ¿las englobas en una clase existente?
- sin ancho (tamaño original)
- con link y sin link. Si la imagen era pequeña Blogger la habrá insertado directamente en el post. Si era mayor, habrá insertado una imagen de menor tamaño con un link asociado a la original.
- con *caption* y sin *caption*. Blogger inserta los pies de foto como una tabla de 2x1.

Después tenemos el **texto preformateado**. Bloques -de código o no- con fuente de ancho fijo.

- bloques de código con el tag `<pre>` ya sea indicando el lenguaje o no.
- formateado en varias líneas dentro de `span nonospace`
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
- y también blockquote para indentar texto pero sin aplicar formato de cita

Finalamente hay objetos que no tienen traducción Markdown:

- tablas. Aunque soporta tablas, no soporta celdas extendidas a varias columnas (*colspan*). En ese caso es mejor dejar el HTML tal cual.
- ecuaciones. Tanto *inline* como *display*. Voy a seguir usando Mathjax por tanto esto no cambia.
- objetos insertados. Tales como:
   - videos de youtube
   - hojas de spreadsheet
   - gráficos de spreadsheet

Técnicamente, cada estructura puede cualquier otra dentro, aunque no es lo habitual en nuestro caso. Por ejemplo la etiqueta de una imagen puede tener partes en negrita o un enlace, pero no tendrá una imagen dentro. Habrá elementos que puedan formar parte de otros, y elementos que no. Un ítem de una lista puede tener varios párrafos, pero no esperamos que contenga una cita.

Cuando analices el **texto normal** (el texto normal puede ser la etiqueta de una foto, el texto de un enlace, una cita, un párrafo o un ítem de una lista, entre otros), cabe esperar elementos de **formato soportados**:

- enlaces
- negrita
- cursiva

Así como otros **no soportados**. Deberás decidir si los eliminas, los sustituyes por otro formato sí soportado o mantienes el formato dejando el tag HTML tal cual en el fichero Markdown.

- subrayado
- tachado
- color del texto o de fondo
- texto alineado a la derecha o centrado
- tamaño de la fuente o diferente tipografía

Entre los **enlaces**, pueden ser:

- a otros posts del blog: deberás sustituirlos por una sintaxis de Jekyll especial.
- a assets (estáticos o ficheros)
- a sitios externos

Todo esto lo hice en un script de Perl: [post_process.pl](https://github.com/electronicayciencia/pruebas-blog/blob/main/importer/post_process.pl). Lo hice e
n Perl porque, si bien no es el lenguaje más legible, es lo más potente que conozco para expresiones regulares y me daba la flexibilidad que necesitaba cuando no sabía lo que me iba a encontrar.

Además, quería usar un **patrón de programación** concreto: la opción `/e`. Permite sustituir una expresión regular no por un string fijo sino por el resultado de ejecutar una función. Lo cual me permite *tokenizar* el texto de manera muy compacta.

```perl
	# <blockquote></blockquote>
	$s =~ s{<blockquote[^>]*>(.+?)</blockquote>}{format_blockquote($1)}ge;
	
	# Format unordered list blocks
	$s =~ s{(<ul>.*?</ul>)}{format_list($1, "ul")}ge;
	
	# Format unordered list blocks
	$s =~ s{(<ol>.*?</ol>)}{format_list($1, "ol")}ge;

	# convert span monospaced into pre blocks
	$s =~ s{<div[^>]*monospace[^>]*>(.*?)</div>}{format_monospace($1, "div")}ge;
	$s =~ s{<span[^>]*monospace[^>]*>(.*?)</span>}{format_monospace($1, "span")}ge;

	# Equations
	$s =~ s{\\\[(.*?)\\\]}{format_equation($1, "display")}ge;

	# HTML tables
	$s =~ s{(<table[^>]*>.*?</table>)}{format_table($1)}ge;
```

## Personalización del tema base

Un tema consiste en una colección de plantillas (*layouts*) y estilos (*css*). Puedes copiar cualquiera de estos componentes y hacer cambios sobre él.

Hay infinidad de temas disponibles para Jekyll. Yo he decidido mantener el tema por defecto **minima** porque me parece muy limpio. Y sobre él he hecho algunas personalizaciones. Si usas otro tema puede incorporar estas y muchas otras cosas. Uno muy completo es [minimal mistakes](https://mmistakes.github.io/minimal-mistakes/).

Para muchas personalizaciones me he basado en [Memory Spills - 
Customizing Jekyll theme](https://ouyi.github.io/post/2017/12/23/jekyll-customization.html).

Como contar toda la personalización sería muy aburrido, sólo contaré algunos temas sueltos. El resto está en el [repositorio del blog](https://github.com/electronicayciencia/electronicayciencia.github.io).

Necesito cargar en **cabeceras** cuatro cosas:

- El script de [MathJax](https://www.mathjax.org/) y las opciones (importante el `messageStyle: "none"`).
- Los iconos de [Font Awsome](https://fontawesome.com/) para las etiquetas, destacados y RSS. Lo he insertado desde la CDN de Bootstrap pero creo que esa no es la forma más actual.
- El script para gestos de [swiped-events](https://github.com/john-doherty/swiped-events). Así en dispositivos móviles se puede avanzar la paginación desplazando el dedo.
- El favicon. Mi tema básico no lo añade por defecto.

La cabecera personalizada queda así:

```html
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    jax: ["input/TeX", "output/HTML-CSS"],
	messageStyle: "none",
    tex2jax: {
      inlineMath: [ ['$', '$'], ["\\(", "\\)"] ],
      displayMath: [ ['$$', '$$'], ["\\[", "\\]"] ],
      processEscapes: true,
      skipTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']
    }
  });
</script>

<script type="text/javascript" async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML"></script>

<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" crossorigin="anonymous">

<script type="text/javascript" async src="{{ "/assets/swiped-events.min.js" | relative_url}}"></script>

<link rel="shortcut icon" href="{{ site.favicon | relative_url}}">
```

Para la **tabla de contenidos**, he utilizado [jekyll-toc](https://github.com/allejo/jekyll-toc). Una plantilla de liquid para construir la TOC sin plugins. El texto `Secciones` justo encima lo pongo por CSS. ¿Te has fijado en que no lo puedes seleccionar con el ratón?

```css
/* TOC */
#my_toc::before {
  content: "Secciones";
  margin-left: -$spacing-unit;
  line-height: 200%;
  font-weight: bold;
  @include relative-font-size(1.25);
  @include media-query($on-laptop) {
    @include relative-font-size(1.125);
  }
}
```

Los videos de YouTube por defecto tienen el tamaño fijo. Encontré este código CSS para hacerlos *responsive* manteniendo la relación de aspecto.

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

En los posts he incluido anotaciones ***front matter*** adicionales para usarlas en las plantillas. `assets` indica dónde están los estáticos. Las imágenes estarán en el directorio `/img` relativo a `assets`. `featured` indica si se mostrará ese post como destacado.

```yaml
assets: /assets/2019/12/leer-tarjetas-de-acceso-rfid-sin-arduino
featured: 'true'
```

El siguiente código JavaScript es el encargado de pasar páginas deslizando el dedo por la pantalla.

```javascript
<script language="javascript">
  nextpage = document.querySelector('link[rel="next"]');
  prevpage = document.querySelector('link[rel="prev"]');

  if (nextpage) {
    document.addEventListener('swiped-left', function(e) {
      location.href = nextpage.href;
    });
  }
  
  if (prevpage) {
    document.addEventListener('swiped-right', function(e) {
      location.href = prevpage.href;
    });
  }
</script>
```



```css
.teaser-image-frame {
  width: 200px;
  height: 150px;
  overflow: hidden;
  float: left;
  margin-right: 1rem;
  margin-bottom: 0.5rem;
}

.teaser-image-frame img {
  object-fit: cover;
  width: inherit;
  height: inherit;
  border-radius: 4px;
}
```



```scss
@media (min-width: 2000px) {
  .teaser-image-frame { 
    width: 300px;
    height: 225px;
  }
  .wrapper {
    max-width: -webkit-calc(#{$content-width}*1.5 - (#{$spacing-unit} * 2));
    max-width:         calc(#{$content-width}*1.5 - (#{$spacing-unit} * 2));
  }
  html {
    font-size: 1.5em;
  }
}
```

```scss
//$base-font-size: 16px;
$base-font-size: 1rem;
```

personalización del tema base
 - iconito rss en el menú
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





dominio personalizado en namecheap
disqus para comentarios


Ejemplo blog con minima:
https://github.com/ouyi/ouyi.github.io/tree/master/_posts
https://ouyi.github.io/





Algunos artículos para ti, que te entretengas mientras aprendes algo o sacas alguna idea util. Otros, para mi.






   
   