---
no-title: Migrar de blogger a Jekyll
layout: post
assets: /assets/drafts/migrar-blogger-jekyll
image: /assets/drafts/migrar-blogger-jekyll/img/featured.jpg
featured: false
tags:
  - Informática
---

En esta entrada explico cómo hice la migración de Blogger a Jekyll. Me descargué los artículos y estáticos de Blogger a local. Convertí los posts de HTML a Markdown y personalicé el tema de Jekyll. No ha sido fácil pero creo que ha valido la pena.

Si vienes buscando un programa automático para migrar tu blog, lo siento. No tengo un programa listo para usar. Te voy a enseñar los que usé yo tal vez pueda ahorrarte algo de tiempo.

La migración tiene tres partes:

- **Descargar el blog** a local. Pero no sólo los artículos, eso es lo más fácil, también las imágenes y otros archivos (zip, audios, etc.).
- **Montar el entorno** Jekyll local y aprender a usarlo. Personalizarlo a tu manera.
- **Convertir el blog** a Markdown e importarlo en Jekyll. Aunque también soporta HTML, pero descubrirás que no queda igual de bien.

## Descarga a local

¿Cuántas páginas o canales habituales estarán disponibles el año que viene? ¿Y dentro de 5 años? ¿10 años? Cualquiera que tenga una colección de favoritos sabe lo rápido que desparece la información en internet. El texto es un medio minoritario frente al video. Y el tráfico e ingresos que obtiene Google con un canal de YouTube no es ni comparable al que obtiene con un blog. Blogger podría existir otros 15 años más o podría cerrar mañana mismo porque ya no es rentable. 

Mi blog no es gran cosa pero es mío. No quiero perderlo. Además, mientras un video ocupa varios gigabytes y necesitas una plataforma para servirlo; un blog entero son unos cuantos megabytes y puedes guardarlo a local y servirlo casi desde cualquier hosting web. Y eso es justamente lo que voy a hacer.

El detonante ha sido el nuevo editor de Blogger. A mediados de año (2020) Google deshabilitó la opción de volver al editor clásico de y forzó el uso del nuevo. Podríamos decir que *no estaba bien pulido*. No es sólo resistencia al cambio, es un sentimiento generalizado. Por ejemplo: [Google's NEW Blogger interface does not work properly!](https://makingamark.blogspot.com/2020/06/googles-new-almost-default-blogger-work.html), 

{% include image.html size="big" file="blogger_editor_bugs.png" caption="Problemas en el foro de soporte de Google acerca del nuevo editor." %}

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

- Habrá formatos no soportados en Markdown. Por ejemplo texto de colores, subrayado, alineado a la derecha, con otra tipografía, etc. 
- En HTML hay varias maneras de hacer lo mismo. Por ejemplo los estilos pueden aplicarse tanto en el tag como en la plantilla CSS. Los tags `<em>` e `<i>` aunque sean diferentes ambos se traducen por cursivas. 
- Blogger no sólo usa HTML para el contenido, también lo usa como parte del estilo. Es más, a lo largo de 10 años el HTML generado por el editor de Blogger ha ido cambiando.

¿Cómo harías un **conversor de HTML a Markdown**? Tal vez tu primera idea sea *buscar y reemplazar* determinados signos. Pongamos buscar `<b>` y sustituirlo por `**`. 

Pronto caerás en la cuenta de que tienes HTML tipo `<a href="enlace">texo</a>` y quieres convertirlo a `[texto](enlace)`. Parece fácil hacerlo con expresiones regulares. ¡Es una trampa! Al principio funciona sí, pero se vuelve complejo muy rápidamente. Conforme avances verás cómo las sustituciones que hagas al principio afectarán a las posteriores. Y se hará muy complicado de mantener y depurar. Porque [no puedes parsear HTML con regexp](https://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags?page=1&tab=votes#tab-top).

No sigas por ahí. Solo avanzarás si consigues **aislar las estructuras** y convertirlas por separado. Así puedes aplicar cambios a la etiqueta de una imagen sin afectar a una tabla HTML, por ejemplo. El método que yo he usado es este:

- buscar en el texto estructuras reconocibles (una imagen, una tabla, una lista, texto citado, etc)
- un vez identificada, guardar el contenido aparte y sustituirla por un *token* (#img-1#, #table-1#, etc) para saber donde iba.
- procesar la estructura buscando otras que pueda tener, a su vez, anidada (otra lista, formato de texto, enlaces). Aquí es donde todo se vuelve complicado.
- sustituir lo encontrado por su correspondiente *token* (#link-1#, #ul-1#, ...).
- lo que queda en el artículo una vez quitado todo lo especial debe ser sólo texto. Agrupar en párrafos y tratarlos como otra estructura más como en los puntos anteriores.
- recorrer el artículo, ahora sólo compuesto de *tokens* sustituyendo cada token por su representación en Markdown.

{% include image.html file="estructura_intermedia.png" caption="Estructura abstracta de un artículo." %}

Siendo formales, el HTML es una **gramática de tipo II** (con anidación). No se puede procesar con expresiones regulares que -por eso se llaman así- sólo valen para leguajes regulares (gramática tipo III). Lo que sí puede hacerse es identificar partes usando expresiones regulares y programar un **analizador sintáctico** rudimentario. Almacenar las partes interesantes en una variable (a modo de stack) y construir el árbol abstracto. Luego lo he volcado en Markdown. Pensándolo ahora, tal vez habría sido más fácil usar herramientas tipo ANTLR ([ANother Tool for Language Recognition](https://www.antlr.org/)).

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

Finalmente hay objetos que no tienen traducción Markdown:

- tablas. Aunque soporta tablas, no soporta celdas extendidas a varias columnas con *colspan*. En ese caso es mejor dejar el HTML tal cual.
- ecuaciones. Tanto *inline* como *display*. Voy a seguir usando MathJax por tanto esto no cambia.
- objetos insertados. Tales como:
   - videos de YouTube
   - hojas de spreadsheet
   - gráficos de spreadsheet

Técnicamente, cada estructura puede cualquier otra dentro, aunque no es lo habitual en nuestro caso. Por ejemplo la etiqueta de una imagen puede tener partes en negrita o un enlace, pero no tendrá una imagen dentro. Habrá elementos que puedan formar parte de otros, y elementos que no. Un ítem de una lista puede tener varios párrafos, pero no esperamos que contenga una cita.

Cuando analices el **texto normal** (el texto normal puede ser la etiqueta de una foto, el texto de un enlace, una cita, un párrafo o un ítem de una lista, entre otros), cabe esperar elementos de **formato soportados**:

- enlaces
- negrita
- cursiva

Así como otros **no soportados**. Deberás decidir si los eliminas, los sustituyes por otro formato sí soportado o mantienes el formato dejando el tag HTML tal cual en el fichero Markdown.

- subrayado
- color del texto o de fondo
- texto alineado a la derecha o centrado
- tamaño de la fuente o diferente tipografía

Entre los **enlaces**, pueden ser:

- a otros posts del blog: deberás sustituirlos por una sintaxis de Jekyll especial.
- a assets (estáticos o ficheros)
- a sitios externos

Todo esto lo hice en un script de **Perl**: [post_process.pl](https://github.com/electronicayciencia/electronicayciencia.github.io/blob/master/importer/post_process.pl). Perl es el lenguaje más potente que hay para expresiones regulares. Cuando no sabes lo que te puedes encontrar por el camino, mejor usar un lenguaje más flexible aunque penalice la legibilidad.

Además, quería usar un **patrón de programación** concreto: la opción `/e`. Vale para hacer una sustitución en una expresión regular; pero no por un string fijo sino por el resultado de ejecutar una función usando como parámetros la parte coincidente de la regexp. Lo cual me permite *tokenizar* el texto de manera muy compacta.

```perl
# <blockquote></blockquote>
$s =~ s{<blockquote[^>]*>(.+?)</blockquote>}{format_blockquote($1)}ge;

# Format unordered list blocks
$s =~ s{(<ul>.*?</ul>)}{format_list($1, "ul")}ge;

# Format unordered list blocks
$s =~ s{(<ol>.*?</ol>)}{format_list($1, "ol")}ge;

# HTML tables
$s =~ s{(<table[^>]*>.*?</table>)}{format_table($1)}ge;
```

## Imágenes

Tal vez tú sepas hacer esto mejor que yo; el diseño web no es mi especialidad. Si quieres compartir cómo lo habrías hecho, deja un comentario.

Quiero que mis imágenes se muestren centradas, con un ancho seleccionado, con pie de foto y enlazadas para que si haces click te te lleve al archivo original. Markdown no soporta nativamente ese formato pero se puede hacer con HTML. Tengo entendido que la forma correcta para el pie de foto es con `figure` y `figcaption`. Así se vincula la etiqueta a la imagen y facilitamos la tarea a los buscadores.

Las plantillas de Liquid soportan *includes*. Es más, soportan parámetros en los *includes*. De hecho, insertar una imagen es el ejemplo que usan en la [documentación de Jekyll](https://jekyllrb.com/docs/includes/) para ilustrar los includes. Acto seguido te dice que no lo hagas:

> Note that you should avoid using too many includes, as this will slow down the build time of your site. For example, don’t use includes every time you insert an image. (The above technique shows a use case for special images.)

He creado dentro *_includes* un fichero llamado `image.html` con este contenido:

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

Además de la variable *assets*, definida en el post, tiene tres parámetros:

- el nombre del **fichero**. Se asume que las imágenes del artículo están todas en la carpeta `/img` de la variable *assets*.
- la etiqueta o **pie de foto**. Para que admita Markdown luego la pasamos por el filtro *markdownify*.
- la clase, generalmente será el **tamaño**. Por defecto asignamos la clase *original-width*.

Para insertar una imagen en el post hay que incluir el fichero indicando los parámetros:

{% raw %}
```html
{% include image.html file="geiger.png" caption="Tubo Geiger-Müller." %}
```
{% endraw %}

En cuanto al tamaño de las imágenes, tenía unos requisitos concretos:

- Debe reducirse si es mayor que el ancho indicado, pero nunca agrandarse. Por ejemplo, el tamaño *mediano* son 500 píxeles de ancho. Si la imagen original mide 1000 píxeles, debe mostrarse reducida hasta los 500. Pero si sólo medía 300 no debe agrandarse a 500 sino quedarse en su tamaño natural de 300px.
- El ancho máximo de la imagen no debe superar el ancho del post. Si el ancho *grande* son 700 píxeles pero estás viendo el blog en una pantalla estrecha de ancho menor, debe ignorar esos 700px y reducirse hasta ocupar el 100% del ancho disponible.

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

## Videos

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

Así insertaría un vídeo:

{% raw %}
```
{% include youtube.html id="BZwuTo7zKM8" %}
```
{% endraw %}

Los vídeos de YouTube embebidos tienen un tamaño fijo. Pero encontré este código CSS para hacerlos *responsive* manteniendo la relación de aspecto.

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

Una muestra de vídeo:

{% include youtube.html id="BZwuTo7zKM8" %}


## Personalización del tema base

Hay infinidad de temas disponibles para Jekyll. Yo he decidido mantener el tema por defecto **minima**. Y sobre él he hecho algunas personalizaciones. Si usas otro tema puede incorporar estas y muchas otras cosas. Uno muy completo es [minimal mistakes](https://mmistakes.github.io/minimal-mistakes/).

Para la **tabla de contenidos**, he utilizado [jekyll-toc](https://github.com/allejo/jekyll-toc). El texto "Secciones" justo encima (al principio del artículo) lo pongo por CSS. ¿Te has fijado que no lo puedes seleccionar con el ratón?

```scss
/* TOC */
#my_toc::before {
  content: "Secciones";
  line-height: 200%;
  font-weight: bold;
}
```

Sería muy aburrido contar toda la personalización. aquí os dejo una lista de cosas y si te interesa puedes mirar el [repositorio del blog](https://github.com/electronicayciencia/electronicayciencia.github.io). Algunas ideas las he tomado de [Memory Spills - 
Customizing Jekyll theme](https://ouyi.github.io/post/2017/12/23/jekyll-customization.html). 

- En el tema base
  - iconito rss en el menú
  - logo en la esquina superior izquierda
  - página de tags
  - fuente de mayor tamaño para pantallas muy anchas
  - quitar mensaje *loading* de Mathjax

- En la lista de posts 
  - paginado
  - enlaces a siguiente y anterior
  - resumen (extracto)
  - imagen destacada (redimensionar imagen con *object-fit*)
  - post destacado (color de fondo, bordes redondeados, icono campana)
  - clic en cualquier parte del extracto te lleva al artículo
  - pasar página deslizando el dedo
  
- En el post
  - enlaces a siguiente y anterior
  - lista de tags e iconos

## Borradores

Una cuestión recurrente es cómo previsualizar un artículo sin publicarlo. La respuesta obvia es con el entorno local del Jekyll. Pero ¿y si queremos hacerlo directamente en GitHub?

Yo me he creado un directorio especial llamado *drafts* (podía hacerle puesto cualquier otro nombre). Y, en la configuración de Jekyll, lo he excluido de del sitemap para que Google no lo indexe. Podría haber hecho lo mismo con una entrada en `robots.txt`.

```yaml
defaults:
  - scope:
      path: 'drafts/**'
    values:
      sitemap: false
```

Cualquier post que pongamos en ese directorio, Jekyll lo tratará como una página más y la convertirá a HTML. Sólo debemos hacer que no se muestre en el menú de navegación.

En el tema *minima* es muy sencillo: sólo muestra las páginas que contienen título. Por tanto basta con no rellenar la variable `title`.

Para acceder al borrador se debe ir directamente a la ruta /drafts conociendo el nombre. Por ejemplo: <https://www.electronicayciencia.com/drafts/cheatsheet>

## Conclusión

La migración no ha sido fácil; las mudanzas nunca lo son. 

Cuando empecé había olvidado los tipos de gramáticas formales y lo aburrido que era hacer un parser. No conocía los generadores de web estáticas como Jekyll o Hugo. Tampoco Liquid ni el mecanismo con el que GitHub Pages genera los sitios web. No había oído hablar de SCSS ni SASS. Ni sabía hacer una web *responsive* usando *media queries* o centrar imágenes usando *object-fit*. 

Ignoraba cómo funcionan las etiquetas [Open Graph](https://ogp.me/) para compartir una web. Me refiero a las *cards* que muestran las aplicaciones de mensajería como WhatsApp o Telegram y las redes sociales como LinkedIn o Twitter cuando compartes un enlace.

{% include image.html class="medium-width" file="card_telegram.png" caption="La descripción y la imagen mostradas al compartir se obtienen de las etiquetas Meta [Open Graph](https://ogp.me/)." %}

Espero que te haga gustado este artículo sobre cómo he construido mi blog en Jekyll. No es el camino cómodo, pero si tienes tiempo y ganas de aprender sobre Web te lo recomiendo.





