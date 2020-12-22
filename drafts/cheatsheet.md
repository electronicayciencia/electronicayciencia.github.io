---
title: Cheatsheet
layout: post
assets: /assets/yyyy/mm/slugified-title
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

[datasheet]({{page.assets | relative_url}}/lm2903-n.pdf)

## Elementos externos

### Imágenes

{% include image.html size="small" file="fob_foto.jpg" caption="Llave de acceso RFID a 125kHz. EyC." %}

En las etiquetas de las imágenes se ùede usar markdown pero no se pueden usar variables, por tanto si hay que enlazar a un asset se debe poner la ruta entera.

{% include image.html size="medium" file="detector_de_envolvente.gif" caption="Detector de envolvente. [Wikipedia.](/assets/2019/12/leer-tarjetas-de-acceso-rfid-sin-arduino/C_Simple_envelope_detector.gif)" %}

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





