---
no-title: Los borradores no deben tener definida la variable título
layout: post
assets: /assets/drafts/cheatsheet
image: /assets/yyyy/mm/slugified-title/img/featured.jpg
featured: false
tags:
  - Binario
  - Circuitos
  - DSP
  - Estadística
  - Experimentos
  - Fisica
  - Informática
  - Matemáticas
  - Optica
  - PIC
  - Radio
  - Raspberry
  - Reciclaje
  - Sensores
  - Sonido
---

Esta página no aparece en el menú de navegación porque no tiene título. 
Tampoco aparece en el *sitemap* porque `/drafts/**` está excluido en la configuración. 
Para llegar a ella utiliza este enlace: `/drafts/cheatsheet.html`.

## Formato

Texto normal. El primer párrafo será lo que se use como resúmen en la portada.

*Cursiva*

**Negrita**

Salto  
de linea.

- lista
- sin
- numerar

1. lista
1. numerada

### Ecuación display

$$
LC = \frac{1}{(2\pi f)^2}
$$

### Ecuación inline

Demostración de que $\alpha = 2\pi\beta$.

## Links

### Link externo

[Mifare](https://en.wikipedia.org/wiki/MIFARE)

### Link a otro post

Hay que usar `site.baseurl` porque la sintaxis

    post_url 2018-10-07-la-presion-atmosferica-bmp280} | relative_url

da error. En jekyll 4.0.0, post_url ya tiene incorporado relative_url.

[Las oscilaciones amortiguadas]({{site.baseurl}}{% post_url 2011-05-18-el-circuito-rlc-serie-oscilaciones %})

### Link a un asset no imagen

[datasheet]({{page.assets | relative_url}}/file1.txt)

## Elementos externos

### Imágenes

{% include image.html class="small-width" file="a-cat.png" caption="Un gato pequeño. Foto de Google." %}
{% include image.html class="medium-width" file="a-cat.png" caption="Un gato mediano. Foto de Google." %}
{% include image.html class="large-width" file="a-cat.png" caption="Un gato grande. Foto de Google." %}
{% include image.html class="x-large-width" file="a-cat.png" caption="Un gato extra grande. Foto de Google." %}
{% include image.html file="a-cat.png" caption="Un gato a tamaño natural, máximo 100% del ancho de la pantalla. Foto de Google." %}

Las imágenes no se amplian, o bien se reducen o se muestran a tamaño natural.

{% include image.html class="small-width" file="mouse_400x400.jpg" caption="Un raton pequeño. Foto de Google." %}
{% include image.html class="medium-width" file="mouse_400x400.jpg" caption="Un raton mediano. Foto de Google." %}
{% include image.html class="large-width" file="mouse_400x400.jpg" caption="Un raton grande. Foto de Google." %}
{% include image.html class="x-large-width" file="mouse_400x400.jpg" caption="Un raton extra grande. Foto de Google." %}
{% include image.html file="mouse_400x400.jpg" caption="Un raton al 100%. Foto de Google." %}

En las etiquetas de las imágenes se puede usar markdown pero no se pueden usar variables, por tanto si hay que enlazar a un asset se debe poner la ruta entera.

{% include image.html class="medium" file="a-cat.png" caption="Un gato. [Asset del post](/assets/drafts/cheatsheet/file1.txt)" %}

### Videos

{% include youtube.html id="FsU0CnQ5dLw" %}


## Preformato

### Inline

Buscamos por ejemplo `telnet`.

### Bloque de texto delimitado

```
               115                7666
         --------- -------------------
         0111 0011 0001 1101 1111 0010
Mensaje: 0111 0011 0001 1101 1111 0010 1
```

### Bloque de código delimitado

```xml
<ParameterValueStruct>
    <Name>Device.DeviceInfo.HardwareVersion</Name>
    <Value xsi:type="xsd:string">1.00</Value>
</ParameterValueStruct>
```

### Líneas preformateadas

    Device.IP.Diagnostics.IPPing.DataBlockSize: 64
    Device.IP.Diagnostics.IPPing.DiagnosticsState: Requested
    Device.IP.Diagnostics.IPPing.DSCP: 0
    Device.IP.Diagnostics.IPPing.Host: 22.30.425.202
    Device.IP.Diagnostics.IPPing.NumberOfRepetitions: 4





