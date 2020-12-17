---
assets: /assets/2010/08/adaptador-smd-de-msop-dip
image: /assets/2010/08/adaptador-smd-de-msop-dip/img/dimensiones_AD8313.png
layout: post
tags:
- Reciclaje
title: Adaptador SMD, de MSOP a DIP
---

Me gustaría hacer unas pruebas con el integrado [AD8313](http://www.analog.com/en/rfif-components/log-ampsdetectors/ad8313/products/product.html) de *Analog Devices*. Lo malo es que el único encapsulado disponible es [MSOP]({{page.assets | relative_url}}/RM_8.pdf). Esto es SMD y de los pequeñitos. Estamos hablando de una pieza de 3x3mm, con unas patillas de 0.30mm de ancho. Por compararlo con algo, el diámetro de una mina de un portaminas común es 0.5mm y un pelo humano cerca de 0.1mm. Como quiero hacer varias pruebas voy a acoplarle un encapsulado más grande para manejarlo mejor, un DIP de 8 patillas por ejemplo. Estas son las dimensiones según el datasheet, en milímetros.

{% include image.html size="big" file="dimensiones_AD8313.png" caption="" %}

El AD8313 es un amplificador logarítmico, vale para hacer un S-meter casero (medidor de [RSSI](http://en.wikipedia.org/wiki/Received_signal_strength_indication)) desde 100MHz a 2.7GHz. Una protoboard no es apropiada para montajes con radiofrecuencia y menos a frecuencias de GHz, pero servirá para hacer unas pruebas.

Existen adaptadores para SMD, pero no los encuentro en una tienda y paso de pedirlos por Internet. Así que me hice uno. La primera idea es mantener la numeración de las patillas. Eso tiene un problema, y es que iba a necesitar pistas muy finas.

{% include image.html size="small" file="pcb1.png" caption="" %}

Como resulta que yo no uso placas fotosensibles sino **transferencia térmica** (y no con papel especial sino con papel de publicidad, algún día escribiré sobre cómo hacer placas PCB de forma sencilla y barata). Con la transferencia se pueden hacer pistas finas, pero no tanto como las de la foto, mantener el patillaje está fuera de mi alcance.

En tal caso más vale optar por el esquema más sencillo. Que es el siguiente:

{% include image.html size="small" file="pcb3.png" caption="" %}

Simplificando el esquema, para que se vean sólo las pistas sería así:

{% include image.html size="small" file="placa_pistas1.png" caption="" %}

A la hora de hacer la placa, tened en cuenta que trabajamos con pistas muy delgadas. Y si nos pasamos de fuerza con la transferencia puede pasar esto:

{% include image.html size="big" file="presion_placa.png" caption="" %}

A la izquierda una impresión un poco pasada pero **todavía útil**. A la derecha una transferencia **inservible** por pasarme de presión con la plancha. Observad cómo las pistas se aplastan y acaban tocándose unas con otras.

Una vez hecha la PCB, soldamos el integrado en la parte central. Y unos trozos de alambre para lo que serían las patillas del DIP. Tener cuidado hacia donde soldáis las patillas (leer al final).

Esas patillas no hay más que montarlas sobre un zócalo y ya tenemos nuestro integrado SMD más manejable para hacer pruebas. Como no tenía zócalos de 8 patas, he cogido uno de 18 y eliminando las dos centrales lo he cortado por la mitad. Hala, dos zócalos de 8 para lo que hagan falta luego.

El resultado es este:

{% include image.html size="medium" file="BENQ0010.JPG" caption="" %}

{% include image.html size="medium" file="BENQ0019.JPG" caption="" %}

En este caso he soldado las patillas de forma que el AD8313 quedara hacia afuera, y **las patillas están invertidas** respecto a como cabría esperar en el esquema de Eagle. Para que quedara conforme al esquema, el SMD debería quedar por debajo. En este caso no me importa porque es para pruebas, pero si para vosotros pudiera ser un problema prestadle atención. De lo contrario pueden quedar reflejadas (la 1 ser en realidad la 4, la 2 ser la 3, etc).

Os dejo los archivos de Eagle, y las plantillas [aquí]({{page.assets | relative_url}}/AdaptadorMSOP.rar). También van unos PDF por si no usáis Eagle.
