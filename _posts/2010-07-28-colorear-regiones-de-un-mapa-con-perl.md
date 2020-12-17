---
assets: /assets/2010/07/colorear-regiones-de-un-mapa-con-perl
image: /assets/2010/07/colorear-regiones-de-un-mapa-con-perl/img/prov_prefijos.png
layout: post
tags:
- Informática
title: Colorear regiones de un mapa con Perl
---

Por razones laborales tenía la necesidad de tomar un mapa de España y colorear las regiones según ciertos parámetros. Hay multitud de herramientas para hacer eso pero no con las propiedades que necesitaba, así que me vi en la necesidad de hacer algo concreto

- Los datos vienen dados por prefijo telefónico.
- Tiene que funcionar en un servidor Linux.
- Además, como se lanza desde un cron, tiene que poder usarse por linea de comandos
- Como se actualiza varias veces al día y el servidor va un poco justo, tiene que ser lo más ligera posible.
- ...y por supuesto, el plazo es para ya mismo.

No puedo publicar la herramienta completa, pero bastará con la idea y un  módulo de Perl de ejemplo.

La mejor forma de colorear un mapa es partir de una **imagen vectorial**, donde cada región es un objeto y se le asigna el color de fondo que corresponda. Pero no encontré ningún mapa vectorial de España por provincias que pudiera reutilizar fácilmente. Varias aplicaciones en java y javascript y en flash. Pero adaptar eso y encontrar la forma de cambiar el color y renderizarlo desde linea de comandos me iba a llevar tiempo. Más tarde encontré un [buen mapa]({{page.assets | relative_url}}/Provinces_of_Spain.svg) en formato SVG -fácil de manipular-, pero ya tenía programada la herramienta.

## Plantilla

Opté por una **solución no tan perfecta**, pero igualmente válida y muy ligera. Lo primero tomé un mapa mudo de España, grandecito y completo, por ejemplo [este]({{page.assets | relative_url}}/Provinces_of_Spain_-Blank_map-.png). La idea es sencilla: primero voy a colorear cada región de un color distinto que la identifique. Y luego, usando ***convert*** (de [ImageMagick](http://www.imagemagick.org/script/index.php), reemplazaré ese color por el que tenga que tener tal región según los datos.

Por simplificar, ya que los datos que tengo van agrupados por prefijo telefónico, he coloreado Madrid con el color #000091, Barcelona con el #000093, La Coruña con #000981 o Valencia y Alicante ambos con el #000096, etc. La numeración telefónica oficial de España la podéis consultar en [este enlace](http://www.cmt.es/cmt_ptl_ext/SelectOption.do?tipo=html&amp;detalles=090027198008a055&amp;nav=norma_buscador) de la CMT: *APÉNDICE. Listado de atribuciones y adjudicaciones vigentes del plan nacional de numeración telefónica*.

Una vez coloreado el mapa que nos servirá de plantilla, queda así:

{% include image.html size="big" file="prov_prefijos.png" caption="" %}

## Gradientes

Sobre esta plantilla, he pegado el gradiente con la escala de color que voy a utilizar. En el código fuente se puede elegir usar un gradiente u otro. En esta página [http://local.wasp.uwa.edu.au/~pbourke/texture_colour/colourramp/](http://local.wasp.uwa.edu.au/%7Epbourke/texture_colour/colourramp/) hay varios ejemplos de gradientes que se pueden usar para visualizar datos. Yo me he quedado con el gradiente 1: azul-(cielo)-verde-(amarillo)-rojo, que creo que es el que mejor representa gráficamente los valores que voy a visualizar.

{% include image.html size="" file="ramp1.gif" caption="" %}

Los gradientes de **tres colores** son apropiados cuando la mayoría de los datos están agrupados en torno a una media central (verde) y se quiere ver cuales son las provincias que se desvían por encima (rojo) o por debajo (azul). En este se han añadido dos colores más en los puntos de unión para que no se pierda luminancia. Comparar con cómo sería un gradiente azul-verde-rojo gradual:

{% include image.html size="" file="16.gif" caption="" %}

Cuando lo normal es un valor límite, ya sea bajo o alto, y se quiere resaltar la desviación hacia el otro extremo se usan **gradientes de dos colores**, como el clásico verde-rojo (para los indicadores), o azul-marrón (altura de los planos). Aunque por estética o legibilidad a veces se incorpora un tercer valor ya sea en el medio, amarillo por ejemplo para dar verde-amarillo-rojo como en un semáforo; o en un extremo, blanco en la altura máxima azul-marrón-blanco, recordando al nivel del mar para la altura cero, y a las nieves perpetuas en las cimas más altas.

Cuando los valores son centrales y no importa hacia qué lado se produce la desviación, se emplea un **gradiente simétrico** como este por ejemplo:

{% include image.html size="" file="07.gif" caption="" %}

En ocasiones, cuando tenemos valores muy distintos en la misma imagen se emplean gradientes de 6 o más colores. Ejemplos típicos son las escalas de calor que evolucionan desde negro a blanco pasando por azul, verde, amarillo y rojo. Hay multitud de modelos.

En la página antes dicha hay varios gradientes con sus archivos .dat, para transformar ese formato a un array de Perl se usa el script *grad2perl.pl* que os incluyo. Luego este gradiente hay que cargarlo en el módulo *ColorUtils.pm* (ver enlace de CPAN). Este no lo incluyo porque es un sólo archivo pm que se puede descargar fácilmente [de CPAN]({{page.assets | relative_url}}/ColorUtils.pm) .

## Uso

Al final del módulo hay un texto POD muy breve explicando cómo se usa. En el código fuente se ha incluido una matriz con los prefijos de España y la población (por si se necesita ponderar los datos).

Para usarlo sólo hay que rellenar un hash con el prefijo telefónico como clave y el dato como valor, además de proporcionar otros datos como el color de fondo, o una etiqueta. El módulo se encarga de llamar a convert, con las instrucciones *opaque* necesarias para sustituir el color de cada provincia por el calculado según el gradiente.

    use mapacolor;>
    >
    my %valores;>
      $valores{prefijo1} = ...>
      $valores{prefijo2} = ...>
    >
    mapacolor::prefs_fill_map_with_gradient( >
      \%valores,                    # hash de valores>
      $outfile,                      # archivo salida>
      'blue_green_red',      # nombre del gradiente>
      0.0,                                # límite inferior del gradiente>
      1,                                    # límite superior del gradiente>
      undef,                            # mapa origen>
      '0a0d0f',                      # color de fondo>
      $anotacion);                # texto de titulo>
    

Después la imagen se guarda en un archivo con formato PNG y se inserta el título (si es preciso) en la esquina superior derecha. El resultado es un mapa como este:

{% include image.html size="big" file="mapacolor_ej1.png" caption="" %}

Os dejo el programita **[aquí]({{page.assets | relative_url}}/mapacolor.zip)** listo para descargar**.**
