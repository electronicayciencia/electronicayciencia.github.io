---
assets: /assets/2010/04/preamplificador-para-microfono
image: /assets/2010/04/preamplificador-para-microfono/img/BENQ0013.JPG
layout: post
tags:
- Circuitos
- Reciclaje
- Sensores
title: Preamplificador para micrófono multimedia
---

Actualización: Este es un preamplificador de baja calidad a transistores que tiene puntos flojos. Si buscas preamplificar un micrófono de una manera más sencilla tal vez te interesa [esta otra entrada]({{site.baseurl}}{% post_url 2010-05-28-preamplificador-microfono-electret %}).

Sigo utilizando el viejo micrófono que venía con el primer PC multimedia que compré. Consta de una capsula electret con un preamplificador en la base del micro. Aunque si ponemos atención a las conexiones resulta que la señal pasa directamente del micro al jack, el preamplificador está puenteado y no se usa. Supongo que antaño cuando las tarjetas de sonido sólo tenían entrada micro mono, el tercer hilo era una alimentación de 5V que serviría para el amplificador. Hoy en día ambos canales tienen una tensión de entre 3V y 5V que sólo sirven para alimentar el micrófono. De hecho si conecto el amplificador a un canal libre irremediablemente los canales se acoplan y la señal se distorsiona por falta de alimentación.

El circuito en cuestión es este:

{% include image.html size="small" file="BENQ0013.JPG" caption="" %}

## Análisis del circuito

Me gustaría analizarlo por encima. Os pongo el esquema obtenido siguiendo la placa:

{% include image.html size="big" file="ampli_antes.png" caption="" %}

Es un diseño bastante sencillo. Tiene cuatro terminales: entrada para el micro, salida a la tarjeta de sonido, alimentación y masa.

C1 y C4 se encargan de filtrar la alimentación. La resistencia R6 y C3 es la forma estándar de conectar una capsula electret. C3 y C2 se encargan del acoplamiento en alterna de la entrada y la salida.

El transistor Q1, junto a sus resistencias de polarización, está configurado como un amplificador clase A, en emisor común. Mientras Q2 actúa como colector común, que no amplifica nada pero proporciona una baja impedancia de salida óptima para aplicarla a la entrada de Micrófono de la tarjeta de sonido.

La idea es buena, pero adolece de algunos fallos típicos de los circuitos baratos.

- Para empezar los **condensadores de entrada y salida** tienen un valor muy bajo de sólo 10nF. Para una frecuencia de [440Hz](http://es.wikipedia.org/wiki/La_440) suponen una impedancia de 3600ohm. Con una capacidad tan baja, se nota mucho la atenuación de los tonos graves frente a los agudos, produciendo el típico *sonido a lata* característico de las cosas *made in china*. Podríamos ampliar un poco la capacidad, 10uF serán suficientes. Pero necesitamos electrolíticos. En grandes tiradas, pasar de los electrolíticos y usar cerámicos supone un ahorro importante a costa de sacrificar la calidad, pero en un micrófono barato de PC esto último es secundario.

- Hay un fallo más grave en la **polarización del emisor de Q1**. Está bien polarizado para continua, pero a menos que conectemos un condensador en paralelo con R1 apenas conseguiremos amplificar las señales alternas. Un condensador de 10uF funcionará bien, aunque lo recomendable sería de 100uF en adelante.

- **Acoplamiento capacitivo entre etapas**. En este caso es opcional porque la siguiente etapa es un seguidor de emisor y sólo amplifica en corriente. Si tuviéramos una etapa amplificadora de tensión tendríamos que conectar un condensador para filtrar la componente continua, de lo contrario la saturaríamos. Como hemos dicho en este caso no es necesario.

- **Polarización de la base de Q1**. Esto último no es un fallo, pero colocar una resistencia entre la base de Q1 y tierra mejoraría la estabilidad térmica del circuito. Para lo que vamos a hacer no es fundamental.

Vamos a arreglar los fallos 1 y 2. El esquema quedaría como sigue:

{% include image.html size="big" file="ampli_despues.png" caption="" %}

El espacio libre que hay por encima del circuito es muy limitado. Por suerte tenía algunos electrolíticos en miniatura que desoldé de una lectora de CDROM. En esta imagen vemos el circuito una vez modificado.

{% include image.html size="small" file="BENQ0017.JPG" caption="" %}

La tensión de alimentación puede ir desde los 3 a los 5V, para alimentarlo con 9 o 12 habría que recalcular algunas resistencias. Este circuito amplifica entre 50 y 100 veces la señal de entrada. Es difícil de determinar pues, al no tener el emisor degenerado, depende de la resistencia intrínseca del transistor. Si quisiéramos atenuar un poco la ganancia basta conectar una resistencia justo antes del emisor de Q1, digamos R7 de 220ohm. La ganancia sería aproximadamente R5/R7 = 2200/220 = 10 veces.
