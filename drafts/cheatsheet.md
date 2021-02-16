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

### Listas

- lista
- sin
- numerar

1. lista
1. numerada

### Preformato dentro de listas

Se anteponen 7 espacios los 4 usuales más 3 por cada nivel de lista.

1. Actualizar los paquetes python necesarios:

       python -m pip install --user -r $IDF_PATH/requirements.txt

1. Copiar el ejemplo hello_world de la SDK a nuestro home:

       cp -r /opt/ESP8266_RTOS_SDK/examples/get-started/hello_world ~


### Imágenes dentro de listas

No se puede. Se sustituye el include por html y no se respeta la identación original.


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

{% raw %}
    {post_url 2018-10-07-la-presion-atmosferica-bmp280} | relative_url
{% endraw %}

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

{% include image.html class="medium-width" file="a-cat.png" caption="Un gato. [Asset del post](/assets/drafts/cheatsheet/file1.txt) en el pie de foto." %}

### Vídeos

{% include youtube.html id="dQw4w9WgXcQ" %}


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


## Publicación

Pasos para publicar un draft:

- Mover los assets de /assets/drafts/titulo-del-post a /assets/yyyy/mm/titulo-del-post
- Cambiar en el post las variables assets e image.
- Cambiar la variable no-title por title.
- Mover el post de /drafts/titulo-del-post.md a /_posts/yyyy-mm-dd-titulo-del-post.md
- git add, commit, push


## Referencias a artículos anteriores

```bash
for i in `ls -r`; do
    t=`grep ^title: $i | tr -d '\r\n' | cut -d' ' -f 2-`
    echo "[Electrónica y Ciencia - $t]({{site.baseurl}}{% post_url $i %})"
done
```

- [Electrónica y Ciencia - Descifrando la configuración del Sagemcom F@ST 5657]({{site.baseurl}}{% post_url 2021-02-14-descifrar-configuracion-sagemcom-fast5657.md %})
- [Electrónica y Ciencia - Avisador personal de autobús con ESP8266]({{site.baseurl}}{% post_url 2021-01-09-avisador-personal-autobus-con-esp8266.md %})
- [Electrónica y Ciencia - Migrar de Blogger a Jekyll]({{site.baseurl}}{% post_url 2020-12-28-migrar-blogger-a-jekyll.md %})
- [Electrónica y Ciencia - Obteniendo la PLOAM password de un router F@ST 5657]({{site.baseurl}}{% post_url 2020-10-26-obteniendo-ploam-password-fast-5657.md %})
- [Electrónica y Ciencia - Sintetizador de frecuencias digital con PLL]({{site.baseurl}}{% post_url 2020-09-15-sintetizador-de-frecuencias-digital-con.md %})
- [Electrónica y Ciencia - Prácticas con TPM virtual]({{site.baseurl}}{% post_url 2020-09-02-practicas-tpm-virtual.md %})
- [Electrónica y Ciencia - Tu primer proyecto con DSP]({{site.baseurl}}{% post_url 2020-06-21-tu-primer-proyecto-con-dsp.md %})
- [Electrónica y Ciencia - Clonar un RFID con tu propio hardware]({{site.baseurl}}{% post_url 2020-02-23-clonar-un-rfid-con-tu-propio-hardware.md %})
- [Electrónica y Ciencia - Leer tarjetas de acceso RFID, sin Arduino]({{site.baseurl}}{% post_url 2019-12-15-leer-tarjetas-de-acceso-rfid-sin-arduino.md %})
- [Electrónica y Ciencia - Un contador radiactivo... de mentira]({{site.baseurl}}{% post_url 2019-07-08-un-contador-radiactivo-de-mentira.md %})
- [Electrónica y Ciencia - La presión atmosférica, BMP280]({{site.baseurl}}{% post_url 2018-10-07-la-presion-atmosferica-bmp280.md %})
- [Electrónica y Ciencia - Transmisor y receptor digital de ultrasonidos]({{site.baseurl}}{% post_url 2018-03-30-transmisor-y-receptor-digital-de.md %})
- [Electrónica y Ciencia - Describiendo un protocolo desconocido]({{site.baseurl}}{% post_url 2017-12-25-describiendo-un-protocolo-desconocido.md %})
- [Electrónica y Ciencia - Demodular AFSK, desde cero]({{site.baseurl}}{% post_url 2017-10-28-demodular-afsk-desde-cero.md %})
- [Electrónica y Ciencia - Enfriadores evaporativos - Psicrometría]({{site.baseurl}}{% post_url 2017-08-13-enfriadores-evaporativos-psicrometria.md %})
- [Electrónica y Ciencia - Luz paralela]({{site.baseurl}}{% post_url 2017-08-02-luz-paralela.md %})
- [Electrónica y Ciencia - Raspberry Pi como generador de frecuencias]({{site.baseurl}}{% post_url 2017-05-01-raspberry-pi-como-generador-de.md %})
- [Electrónica y Ciencia - El bus I2C a bajo nivel]({{site.baseurl}}{% post_url 2017-02-25-el-bus-i2c-bajo-nivel.md %})
- [Electrónica y Ciencia - El bus 1-Wire a bajo nivel - DS1820]({{site.baseurl}}{% post_url 2016-12-04-el-bus-1-wire-bajo-nivel.md %})
- [Electrónica y Ciencia - Conexión GPIO de Raspberry Pi 3]({{site.baseurl}}{% post_url 2016-11-20-conexion-gpio-de-raspberry-pi-3.md %})
- [Electrónica y Ciencia - Espectroscopía mediante Transformada de Fourier]({{site.baseurl}}{% post_url 2015-12-07-espectroscopia-transformada-de-fourier.md %})
- [Electrónica y Ciencia - Medir distancias con un ratón de bola]({{site.baseurl}}{% post_url 2015-07-16-medir-distancias-con-un-raton-de-bola.md %})
- [Electrónica y Ciencia - Los dominios de la entropía]({{site.baseurl}}{% post_url 2015-03-12-los-dominios-de-la-entropia.md %})
- [Electrónica y Ciencia - Cómo funcionan las etiquetas magneto-acústicas (o acustomagnéticas)]({{site.baseurl}}{% post_url 2013-07-03-etiquetas-antihurto-magneto-acusticas.md %})
- [Electrónica y Ciencia - Mezclador de frecuencias con el integrado 4066]({{site.baseurl}}{% post_url 2013-04-22-mezclador-de-frecuencias-con-el.md %})
- [Electrónica y Ciencia - La Distorsión Armónica Total (THD)]({{site.baseurl}}{% post_url 2013-03-26-la-distorsion-armonica-total-thd.md %})
- [Electrónica y Ciencia - Reparación de un cd-radio-casete]({{site.baseurl}}{% post_url 2013-01-04-reparacion-de-un-cd-radio-casete.md %})
- [Electrónica y Ciencia - Análisis de las distribuciones de voto en Filmaffinity]({{site.baseurl}}{% post_url 2012-08-28-un-analisis-de-cine.md %})
- [Electrónica y Ciencia - Convolución de dos imágenes: Homógrafos UTF]({{site.baseurl}}{% post_url 2012-05-05-convolucion-de-dos-imagenes-homografos.md %})
- [Electrónica y Ciencia - Estadística de los exámenes tipo test]({{site.baseurl}}{% post_url 2011-09-27-estadistica-de-los-examenes-tipo-test.md %})
- [Electrónica y Ciencia - Electrocardiograma y electrorretinograma.]({{site.baseurl}}{% post_url 2011-09-07-electrocardiograma-y.md %})
- [Electrónica y Ciencia - La Transformada de Fourier no es magia]({{site.baseurl}}{% post_url 2011-08-11-la-transformada-de-fourier-no-es-magia.md %})
- [Electrónica y Ciencia - Rastreador de redes inalámbricas]({{site.baseurl}}{% post_url 2011-08-03-rastreador-de-redes-inalambricas.md %})
- [Electrónica y Ciencia - Frecuencímetro para el PC]({{site.baseurl}}{% post_url 2011-07-20-frecuencimetro-para-el-pc.md %})
- [Electrónica y Ciencia - El transistor, ese gran desconocido: Regulador V-I]({{site.baseurl}}{% post_url 2011-07-06-el-transistor-ese-gran-desconocido.md %})
- [Electrónica y Ciencia - El circuito RLC serie: oscilaciones amortiguadas]({{site.baseurl}}{% post_url 2011-05-18-el-circuito-rlc-serie-oscilaciones.md %})
- [Electrónica y Ciencia - Dimmer controlado por mando a distancia: el software]({{site.baseurl}}{% post_url 2011-02-02-dimmer-controlado-por-mando-distancia.md %})
- [Electrónica y Ciencia - Programación PIC para decodificar RC5]({{site.baseurl}}{% post_url 2011-01-19-programacion-pic-para-decodificar-rc5.md %})
- [Electrónica y Ciencia - Adaptador de USB a Serie]({{site.baseurl}}{% post_url 2011-01-12-adaptador-de-usb-serie.md %})
- [Electrónica y Ciencia - Controlar un servomotor con el PC]({{site.baseurl}}{% post_url 2010-12-17-controlar-un-servomotor-con-el-pc.md %})
- [Electrónica y Ciencia - 'Dimmer controlado por mando a distancia: el hardware']({{site.baseurl}}{% post_url 2010-12-10-dimmer-controlado-por-mando-distancia.md %})
- [Electrónica y Ciencia - Decodificar Aiken Biphase con Perl]({{site.baseurl}}{% post_url 2010-11-24-decodificar-aiken-biphase-con-perl.md %})
- [Electrónica y Ciencia - Contraseña dinámica para acceder al PC de casa]({{site.baseurl}}{% post_url 2010-11-17-contrasena-dinamica-para-acceder-al-pc.md %})
- [Electrónica y Ciencia - Transmitir información usando el mando de un coche teledirigido]({{site.baseurl}}{% post_url 2010-10-27-transmitir-informacion-usando-el-mando.md %})
- [Electrónica y Ciencia - Medir valores lógicos con tarjeta de sonido]({{site.baseurl}}{% post_url 2010-10-20-medir-valores-logicos-con-tarjeta-de.md %})
- [Electrónica y Ciencia - La subasta americana]({{site.baseurl}}{% post_url 2010-10-13-la-subasta-americana.md %})
- [Electrónica y Ciencia - Bromas de alta tensión]({{site.baseurl}}{% post_url 2010-10-06-bromas-de-alta-tension.md %})
- [Electrónica y Ciencia - Termómetro para disoluciones]({{site.baseurl}}{% post_url 2010-09-29-termometro-para-disoluciones.md %})
- [Electrónica y Ciencia - Inferencia estadística II: Introducción a los test de hipótesis]({{site.baseurl}}{% post_url 2010-09-22-inferencia-estadistica-ii-introduccion.md %})
- [Electrónica y Ciencia - ¿Vierten la tinta adrede las impresoras de inyección?]({{site.baseurl}}{% post_url 2010-09-20-vierten-la-tinta-adrede-las-impresoras.md %})
- [Electrónica y Ciencia - Receptor coche RC de dos canales]({{site.baseurl}}{% post_url 2010-09-15-receptor-coche-rc-de-dos-canales.md %})
- [Electrónica y Ciencia - Sensor óptico sencillo con amplio rango dinámico]({{site.baseurl}}{% post_url 2010-09-08-sensor-optico-sencillo-con-amplio-rango.md %})
- [Electrónica y Ciencia - Inferencia estadística: capacidad de una cucharilla]({{site.baseurl}}{% post_url 2010-09-01-inferencia-estadistica-capacidad-de-una.md %})
- [Electrónica y Ciencia - Resonancia mecánica con copas II]({{site.baseurl}}{% post_url 2010-08-25-resonancia-mecanica-con-copas-ii.md %})
- [Electrónica y Ciencia - Configurar un ratón serie en un Linux moderno]({{site.baseurl}}{% post_url 2010-08-18-configurar-un-raton-serie-en-un-linux.md %})
- [Electrónica y Ciencia - Síntesis de cloroformo a partir de productos de limpieza: estequiometría]({{site.baseurl}}{% post_url 2010-08-11-sintesis-de-cloroformo-partir-de.md %})
- [Electrónica y Ciencia - Adaptador SMD, de MSOP a DIP]({{site.baseurl}}{% post_url 2010-08-04-adaptador-smd-de-msop-dip.md %})
- [Electrónica y Ciencia - Colorear regiones de un mapa con Perl]({{site.baseurl}}{% post_url 2010-07-28-colorear-regiones-de-un-mapa-con-perl.md %})
- [Electrónica y Ciencia - Termostato para estufa de incubación casera]({{site.baseurl}}{% post_url 2010-07-21-termostato-para-estufa-de-incubacion.md %})
- [Electrónica y Ciencia - Espectroscopía casera con DVD]({{site.baseurl}}{% post_url 2010-07-14-espectroscopia-casera-con-dvd.md %})
- [Electrónica y Ciencia - Difraccion en un DVD]({{site.baseurl}}{% post_url 2010-07-07-difraccion-en-un-dvd.md %})
- [Electrónica y Ciencia - Generador de personajes ficticios en Perl]({{site.baseurl}}{% post_url 2010-06-30-generador-de-personajes-ficticios-en.md %})
- [Electrónica y Ciencia - Curva de respuesta del Dimmer IR]({{site.baseurl}}{% post_url 2010-06-23-curva-de-respuesta-del-dimmer-ir.md %})
- [Electrónica y Ciencia - Simulación estadística del Risk]({{site.baseurl}}{% post_url 2010-06-16-simulacion-estadistica-del-risk.md %})
- [Electrónica y Ciencia - Escáner nuevo y difracción]({{site.baseurl}}{% post_url 2010-06-09-escaner-nuevo-y-difraccion.md %})
- [Electrónica y Ciencia - Utilizar un micrófono electret]({{site.baseurl}}{% post_url 2010-06-04-utilizar-un-microfono-electret.md %})
- [Electrónica y Ciencia - Matamoscas eléctrónico: flyback]({{site.baseurl}}{% post_url 2010-06-01-matamoscas-electronico-flyback.md %})
- [Electrónica y Ciencia - Preamplificador micrófono electret: operacional]({{site.baseurl}}{% post_url 2010-05-28-preamplificador-microfono-electret.md %})
- [Electrónica y Ciencia - Convertir palabras en números (II)]({{site.baseurl}}{% post_url 2010-05-24-convertir-palabras-en-numeros-ii.md %})
- [Electrónica y Ciencia - Convertir palabras en números (I)]({{site.baseurl}}{% post_url 2010-05-21-convertir-palabras-en-numeros-i.md %})
- [Electrónica y Ciencia - Transmisor protocolo NEC con PIC]({{site.baseurl}}{% post_url 2010-05-17-transmisor-protocolo-nec-con-pic.md %})
- [Electrónica y Ciencia - Criptoanálisis del cifrado XOR simple]({{site.baseurl}}{% post_url 2010-05-11-criptoanalisis-del-cifrado-xor-simple.md %})
- [Electrónica y Ciencia - Receptor con PIC para mandos infrarrojos tipo NEC]({{site.baseurl}}{% post_url 2010-05-07-receptor-con-pic-para-mandos.md %})
- [Electrónica y Ciencia - Mando de un coche teledirigido]({{site.baseurl}}{% post_url 2010-05-04-mando-de-un-coche-teledirigido.md %})
- [Electrónica y Ciencia - Obtener el esquema desde una placa de circuito impreso]({{site.baseurl}}{% post_url 2010-04-30-obtener-el-esquema-desde-una-placa-de.md %})
- [Electrónica y Ciencia - Multivibrador astable a transistores: explicación]({{site.baseurl}}{% post_url 2010-04-27-multivibrador-astable-transistores.md %})
- [Electrónica y Ciencia - Preamplificador para micrófono multimedia]({{site.baseurl}}{% post_url 2010-04-21-preamplificador-para-microfono.md %})
- [Electrónica y Ciencia - Control de velocidad por PWM]({{site.baseurl}}{% post_url 2010-04-18-control-de-velocidad-por-pwm.md %})
- [Electrónica y Ciencia - Comparar matrices en Perl]({{site.baseurl}}{% post_url 2010-04-13-comparar-matrices-en-perl.md %})
- [Electrónica y Ciencia - Espectroscopía casera con copas]({{site.baseurl}}{% post_url 2010-04-12-espectroscopia-casera-con-copas.md %})
- [Electrónica y Ciencia - Descifrar las contraseñas guardadas de Opera]({{site.baseurl}}{% post_url 2010-04-08-descifrar-las-contrasenas-guardadas-de.md %})
- [Electrónica y Ciencia - Reutilizar el motor de un lector CDROM]({{site.baseurl}}{% post_url 2010-04-05-reutilizar-el-motor-de-un-lector-cdrom.md %})
- [Electrónica y Ciencia - Decodificacion del protocolo RC5 usando un PIC]({{site.baseurl}}{% post_url 2010-04-01-decodificacion-del-protocolo-rc5-usando.md %})
- [Electrónica y Ciencia - Valor eficaz de una sinusoidal incompleta]({{site.baseurl}}{% post_url 2010-03-29-valor-eficaz-de-una-sinusoidal.md %})
- [Electrónica y Ciencia - Característica V/I de una bombilla]({{site.baseurl}}{% post_url 2010-03-27-caracteristica-i-v-de-una-bombilla.md %})
- [Electrónica y Ciencia - Watchdog para PC con alarma]({{site.baseurl}}{% post_url 2010-03-23-watchdog-para-pc-con-alarma.md %})
- [Electrónica y Ciencia - Conversor USB - RS232]({{site.baseurl}}{% post_url 2010-03-22-conversor-usb-rs232.md %})




