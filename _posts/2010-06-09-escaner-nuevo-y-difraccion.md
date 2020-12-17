---
assets: /assets/2010/06/escaner-nuevo-y-difraccion
image: /assets/2010/06/escaner-nuevo-y-difraccion/img/BENQ0001.JPG
layout: post
tags:
- Fisica
- Reciclaje
title: Escáner nuevo y difracción
---

El pasado fin de semana los vecinos nos dieron una multifunción vieja. Una [Lexmark X1270](http://www.lexmark.com/lexmark/product/home/972/0,6970,245102346_653293766_783805388_es,00.html?tabId=7). Hay que reconocer que es buena, pero como todas las de tinta, los cartuchos valen una pasta y duran un suspiro. En fin que como impresora no me serviría de mucho. Pero mi ética me prohíbe desguazar cosas que aún funcionan *(excepto los matamoscas de 3€, hola Salva)*, antes la dejo junto a un contenedor.

Sin embargo me llamó la atención que el escáner [es compatible con Linux](http://www.sane-project.org/sane-mfgs.html#Z-LEXMARK), no del todo pero sí más que el que tenía. Mi escáner era un Canon para puerto paralelo que apenas funciona con Linux, y tenía casi diez años. Me propuse aprovechar el escáner de la X1270.

Estas multifunción no son más que una impresora a la que se le ha pegado por encima un escáner. De hecho una vez separados son totalmente independientes, sólo comparten la placa principal (el *cerebro*) donde está la alimentación y la clavija USB.

<!--more-->

Me ha gustado el detalle de la fuente de alimentación. Modular, y de hecho extraíble. La placa principal es de pequeño tamaño. He separado el escáner, y me he quedado con lo necesario para hacerlo funcionar para montarlo sobre el tablero del mueble donde tenía el antiguo. El resto, que corresponde a la base y a la impresora lo tiramos.

Para darle solidez al invento he extraído el conector USB y lo he sustituido por un cable. Lo mismo he hecho con los conectores de alimentación.

En esta imagen veis la fuente (el módulo negro) y la placa principal.

{% include image.html size="" file="BENQ0001.JPG" caption="" %}

Aquí un detalle de cómo se conecta el escáner a la placa principal. Lleva tres conectores. El primero, de 4 cables es solamente la alimentación. De los dos buses planos, el fino va a la botonera: encender/apagar, copia, copia color, etc. El grueso es quien envía y recibe la información del escáner.

{% include image.html size="" file="BENQ0007.JPG" caption="" %}

Bajo la carcasa hay espacio suficiente para alojar la fuente de alimentación y la placa mirad cómo queda ya montado.

{% include image.html size="" file="BENQ0011.JPG" caption="" %}

El escáner funciona perfectamente. El problema que hay es que al no tener la parte de la impresora, no se tiene información sobre el estado del carro ni de los cartuchos, por lo que no se termina la rutina de apagado, y no se apaga con el botón principal. Podéis incorporar un interruptor externo en el cable de la alimentación o bien desenchufarlo.

## Difracción

Como una entrada sólo con fotos del montaje me parece sosa vamos a darle un poco más de contenido. Las impresoras de tinta tienen un carro móvil donde están los cartuchos de impresión. Ese carro tiene un [sensor óptico](http://hackaday.com/2009/11/12/linear-optical-encoder/) para saber dónde se encuentra. Se trata de una tira de plástico transparente con miles de lineas verticales muy finitas. La cinta está fija en la impresora y en el carro hay una luz y un fotodetector. Según el carro avanza va contando cuantas lineas opacas van y así sabe su posición horizontal.

Las lineas son muy finas para verlas a simple vista, pero vamos a averiguar la separación utilizando un láser. Es un experimento de difracción por rendijas múltiples (como el [experimento de Young](http://www.quadernsdigitals.net/datos_web/hemeroteca/r_1/nr_510/a_7082/7082.htm)) similar a una [red de difracción](http://en.wikipedia.org/wiki/Diffraction_grating).

El caso es que si apuntamos con un puntero láser a la rejilla y situamos una pantalla detrás lo que vemos es esto:

{% include image.html size="" file="BENQ0009.JPG" caption="" %}

Los puntos (máximos de interferencia) están separados una distancia *x*, aproximadamente 8,91mm. No es fácil medirlo, así que para obtener mayor precisión lo que se hace es medir la distancia entre dos puntos, entre tres, entre cuatro, etc. y después se calcula una regresión lineal. La pendiente de la recta es la distancia entre puntos. Así minimizamos el error.

Como no tenía mucho tiempo para dedicarle, aquí lo he hecho midiendo esas distancias, dividiendo entre el número de intervalos y calculando la media. No es tan exacto como lo anterior pero servirá.

La separación de los puntos depende de:

- La **longitud de onda** de la luz, que llamaremos *λ*. La conocemos, para un láser rojo es de 650nm.
- La **distancia hasta la pantalla**, que llamaremos *L*. En nuestro experimento será 2,30m.
- La **separación entre las rendijas**. Esto, que lo vamos a llamar *d*, es precisamente lo que queremos saber.

La ecuación para las redes de difracción es

$$
d \sin(\theta_m) = m\lambda
$$

con m el número de máximo (1, 2, ...) ¿demasiado complicado? Vamos a simplificarlo.

Cuando la pantalla esta lejos y los máximos están poco alejados entre sí nos vale con una aproximación *(dicho con propiedad, cuando la densidad de la red es baja, los máximos están cerca unos de otros; si la distancia entre máximos es muy pequeña comparada con la distancia a la pantalla, θ es pequeño, y en esas condiciones es válido aproximar el seno por la tangente que es x/L)*. La distancia entre las líneas será:

$$
d = {\lambda L \over x} = {650 \cdot 10^{-9} \times 2,30 \over 8.91 \cdot 10^{-3}}
$$

lo que nos da una separación de 0.167mm. Que vienen a ser 6 líneas por milímetro. Los cálculos están en [esta hoja](https://spreadsheets.google.com/pub?key=0AjHcMU3xvtO8dGktMUdLVmdVVDVzVHBXd3IwNm9aaFE&amp;hl=es&amp;single=true&amp;gid=0&amp;output=html), en negrita están los datos que tenemos.

Vamos a mirar la cinta a través de un microscopio tipo [cuentahilos](http://buscon.rae.es/draeI/SrvltConsulta?TIPO_BUS=3&amp;LEMA=cuentah%C3%ADlos) para comprobar que eso es verdad.

{% include image.html size="medium" file="BENQ0038.JPG" caption="" %}

La graduación mayor son milímetros. Contamos efectivamente 6 líneas por milímetro.

Si tenemos en cuenta que lo que el encoder detecta es el cambio entre blanco y negro, hay 12 cambios por milímetro, que son 300 intervalos en una sola pulgada. Así pues con el motor sólo se puede obtener una resolución horizontal de 300 [dpi](http://es.wikipedia.org/wiki/Puntos_por_pulgada). Para obtener más resolución aún necesitamos que el cabezal esté dividido en dos salidas de tinta en cada intervalo. Pensad si hay dos salidas de tinta en el mismo intervalo, cómo serán de finas y por qué se atascan y se ensucian con esa facilidad.
