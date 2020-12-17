---
assets: /assets/2010/09/receptor-coche-rc-de-dos-canales
featured: 'true'
image: /assets/2010/09/receptor-coche-rc-de-dos-canales/img/alzado_placa.JPG
layout: post
tags:
- Circuitos
- Radio
- Reciclaje
title: Receptor coche RC de dos canales
---

Alguien anónimo me dejó un comentario en [esta entrada]({{site.baseurl}}{% post_url 2010-05-04-mando-de-un-coche-teledirigido %}) pidiendo que, ya que había analizado el transmisor, describiera también el receptor. El comentario lo borré, por la falta de cuidado de su redactor, pero la petición me pareció acertada. Un receptor típico de un coche barato *made in China* no tiene mucha miga. Este que os presento es de uno que me costó entre 3 y 4 euros (para quienes les resulte más familiar, unos 4.5 USD).

## Circuitos actuales de RadioControl

Hay tres tipos de coches radiocontrolados de gama baja. Por supuesto no tienen por qué que ser coches, la forma externa puede ser cualquiera. Lo que nos importa es el circuito. Por supuesto hablamos de radiocontrol en 27MHz, hay otros mandos que funcionan con infrarrojos pero de esos no hablaré.

Como digo, en los modelos RC de hoy nos encontramos sólo tres tipos de circuitos. Porque los fabricantes son los mismos y apenas cambian los esquemas. El esquema depende de los canales que tenga el coche. Los **canales** son las acciones independientes que puede realizar.

- **Esquema de un canal:** Estos son los más básicos y sólo tienen un botón en el mando. Son los típicos que nada más encenderlos el coche va hacia adelante. Cuando pulsamos el botón va hacia atrás y al mismo tiempo gira, para seguir avanzando en cuanto soltemos el pulsador. El circuito es muy simple: un transmisor en el mando y un receptor sintonizado en le coche. En cuando el receptor capta la señal del mando conmuta la dirección. A menudo la señal ni siquiera va modulada.

- **Esquema de dos canales:** Estos tienen tres estados: hacia delante, hacia atrás y parado. Tienen dos pulsadores, uno para avanzar y otro para retroceder que pueden ser independientes o unidos en una palanca. El transmisor es un oscilador que puede emitir dos tonos de frecuencias distintas (250Hz y 1000Hz), ya describimos el funcionamiento en [esta entrada]({{site.baseurl}}{% post_url 2010-05-04-mando-de-un-coche-teledirigido %}). En cuanto al receptor, el esquema suele basarse en el [integrado RX-3](http://www.alldatasheet.com/datasheet-pdf/pdf/156482/SILAN/RX-3.html) de Silan. Ese va a ser el que describamos hoy.

- **Esquema de cinco canales:** Son los coches con funciones de atrás-adelante-turbo e izquierda-derecha. En este caso ya no es cómodo utilizar frecuencias distintas para cada opción, así que se usa modulación digital. Tanto el transmisor como el receptor utilizan integrados dedicados. El TX-2B y el RX-2B respectivamente. No vamos a hablar de ellos hoy.

Por supuesto que hay muchos más esquemas. Pero estos y sus variantes son los más comunes que encontraréis en los bazares. Para la gama media y modelismo, sobre todo en aviones, ya se usan otros circuitos no tan simples.

## Receptor de dos canales

Este es el receptor de un coche RC se dos canales: adelante/atrás y parado en ausencia de señal. Primero veamos la placa para hacernos una idea:

{% include image.html size="" file="alzado_placa.JPG" caption="" %}

{% include image.html size="" file="receptor_componentes.JPG" caption="" %}

{% include image.html size="" file="receptor_pistas.JPG" caption="" %}

Podríamos reproducir el circuito desde las pistas, como [ya hicimos con el emisor]({{site.baseurl}}{% post_url 2010-04-30-obtener-el-esquema-desde-una-placa-de %}). Pero es muy **aburrido**, además en el [datasheet del RX-3](http://www.alldatasheet.com/datasheet-pdf/pdf/156482/SILAN/RX-3.html) viene un esquema propuesto por el fabricante del integrado. Cabe esperar que el nuestro no se aparte demasiado y de hecho es muy parecido, suprimiendo algunos componentes para ahorrar costes.

{% include image.html size="big" file="esquema_RX-3_retocado.png" caption="" %}

He coloreado algunas secciones para que las veáis mejor (clic para ampliar). Veamos cómo funciona.

## Sección A: Etapa de radiofrecuencia.

Parece que se trata de un receptor regenerativo. La realimentación se hace a través de la resistencia de 5.6kΩ. Estos circuitos aplican realimentación positiva casi hasta el punto de ponerse a oscilar con la señal de entrada. Para lo simples que son tienen muy buenas características de sensibilidad y de selectividad. Se conocen desde los primeros tiempos de la radio. La primera patente es del 1914, con válvulas, claro.

La transmisión llega a la antena, pasa por el circuito tanque sintonizado y es amplificada con el transistor. Uno de los diodos del transistor también actúa como detector de AM. Detectando y volviendo a amplificar el tono con que va modulada la portadora. Este tipo de diseños se usaban mucho antes, cuando el coste de los transistores era muy alto. Y eso que costaban menos que las válvulas. Las primeras radios a transistores que salieron anunciaban con orgullo ***6 transistores***. Hoy el mando a distancia que analizamos tiene 7, y el ordenador con que escribo y lees tiene por dentro varios millones de transistores en miniatura.

El tono de audiofrecuencia extraído pasa a la sección B para ser amplificado.

## Sección B: Amplificación de audio.

El integrado RX-3 incorpora dos amplificadores inversores listos para usar. Las patillas exteriores conectan con lo que sería el equivalente a las entradas inversoras.

Las resistencias y condensadores que componen esta sección son las redes de realimentación de ambos amplificadores. El primero de ellos tiene una amplificación de unos 30dB que se reduce muchísimo para frecuencias altas por efecto del condensador de 500pF en paralelo con la resistencia.

La segunda etapa está configurada con una ganancia de 10dB. Todo esto *grosso modo* sin contar las pérdidas por los condensadores de acoplamiento, en serie con las resistencias de entrada, que separan la corriente continua y sólo dejan pasar la alterna.

Toda la etapa amplificadora tiene una ganancia de 40dB. El tono detectado se aplica a la patilla 4 del integrado. Esta es la entrada de señal demodulada. Cuando a esta patilla llegue un tono de 1000Hz se pondrá a nivel alto la patilla 11 -forward- y el coche andará hacia adelante. En cambio cuando llegue un tono de 250Hz se encenderá la patilla 9 -backward- y rodará hacia atrás.

## Sección C: Puente H.

Cuando aplicamos tensión a un motor este gira en una dirección determinada. Si lo que queremos es que gire e un sentido o en otro a voluntad tenemos que usar una disposición especial de transistores para alimentarlo. Este circuito se llama [puente H](http://es.wikipedia.org/wiki/Puente_H_%28electr%C3%B3nica%29).

Cuando el integrado aplica tensión a la patilla 11 -avance- el transistor Q9 pasa a conducción. Con él como una reacción en cascada también conmutan Q11 y Q13, poniendo a masa el terminal izquierdo del motor y suministrando tensión positiva al derecho. Y el motor girará en un sentido.

En cambio, cuando se activa la patilla 8 -retroceso- se activa el transistor Q8 que a su vez activa Q12 y Q10. En están condiciones, el terminal izquierdo del motor recibiría tensión positiva mientras que el derecho se conecta a masa. Justo la situación inversa a la anterior, y el motor girará en sentido contrario.

Hay variantes de este esquema. En el esquema hay 5 transistores NPN y 1 PNP. Sin embargo en la placa que tenemos hay 4 NPN y 2 PNP. Caben múltiples posibilidades pero la idea es la misma.

## Sección D: Alimentación.

Por último, la sección D es la alimentación del circuito. No hay mucho que destacar aquí. Hay componentes que faltan en la placa comercial, por ejemplo el diodo D1, que previene contra inversión de las baterías, se lo han ahorrado. Así como algunos condensadores de filtrado.

Vemos que la parte que alimenta a la etapa A va desacoplada mediante una resistencia de 100Ω y un condensador. Sirve para que ninguna señal residual de RF pueda filtrarse a la línea de alimentación e interferir con el integrado.

En algunos circuitos esta parte no está bien diseñada, y se acopla la RF con la alimentación, también puede pasar por medio de las capacidades parásitas entre las pistas por ejemplo. En muchos casos de comportamiento errático, sobre todo con microcontroladores este es el problema.

## Para terminar

Por si os interesa el tema, hay una página con otros esquemas de este tipo que me ha gustado mucho: [http://talkingelectronics.com/projects/27MHz%20Transmitters/27MHzLinks-2.html](http://talkingelectronics.com/projects/27MHz%20Transmitters/27MHzLinks-2.html)

Y como de costumbre, os dejo los archivos [aquí]({{page.assets | relative_url}}/ReceptorRC_RX-3.rar).
