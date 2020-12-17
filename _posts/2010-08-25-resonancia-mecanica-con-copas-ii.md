---
assets: /assets/2010/08/resonancia-mecanica-con-copas-ii
featured: 'true'
image: /assets/2010/08/resonancia-mecanica-con-copas-ii/img/pulso.png
layout: post
tags:
- DSP
- Experimentos
- Fisica
- Sonido
title: Resonancia mecánica con copas II
---

En [esta entrada]({{site.baseurl}}{% post_url 2010-04-12-espectroscopia-casera-con-copas %}) de hace un tiempo, ya habíamos mostrado cómo se comporta un sistema resonante dentro de un campo oscilatorio. Lo que pasa es que en lugar de usar un campo magnético y un [circuito resonante](http://es.wikipedia.org/wiki/Circuito_LC), habíamos usado oscilaciones mecánicas (sonido) y copas como resonadores. Esta entrada es una especie de continuación de aquella por lo que os recomiendo que la leáis también.

Ya habíamos visto antes cómo, ante una vibración de la frecuencia adecuada, la copa absorbe energía y se pone a vibrar también. Eso es típico en cualquier resonador, ya sea una copa, un circuito LC sintonizado, o un cristal de cuarzo tallado adecuadamente.

## Estímulo

Para verlo mejor, en lugar de un sonido continuo vamos a emplear uno intermitente. Como en un sonar: emitimos u pulso, escuchamos el eco, emitimos, escuchamos. No obstante no podemos cortar bruscamente el principio y el final del pulso sonoro, porque cualquier cambio repentino en la señal tendría componentes en muchas frecuencias y estropea en resultado. Así que hay que suavizarlo. Dependiendo de la forma de la envolvente los bordes del pulso tendrán un espectro más ensanchado o menos. Pero también depende de cómo hagamos la transformada, la ventana que usemos, el número de puntos, etc. Así que no vamos a complicarlo mucho.

Además, en lugar de usar un pulso de una sola frecuencia, vamos a combinar tres frecuencias y emitirlas al mismo tiempo:

- **1404Hz**: resonancia de la segunda copa
- **1068Hz**: resonancia de la primera copa
- **512Hz**: arbitraria, servirá de control

Este es el aspecto de nuestra señal:

{% include image.html size="big" file="pulso.png" caption="" %}

Como veis son tres sinusoides sumadas y hemos hecho una aparición y desvanecimiento graduales. Nada especial. El resto del tiempo es silencio. Lo reproducimos en bucle cada 320ms y esto es lo que capta el micrófono:

{% include image.html size="small" file="pulsos.png" caption="" %}

Vemos perfectamente el periodo, de 320ms con silencios incluidos. Las tres frecuencias son 512Hz a la izquierda, 1068Hz en el centro y de 1404Hz a la derecha. El centro del pulso se ve limpio porque la suma de sinusoides no está alterada, en los extremos se ve un espectro ensanchado y borroso debido al motivo que hemos dicho antes. También de aprecian ruidos de fondo.

## Resonancia

Eso es sólo con el micrófono y el altavoz, veamos lo que pasa cuando intercalo una copa, no voy a decir cual, porque resulta evidente:

{% include image.html size="" file="alternando_detalle.png" caption="" %}

Sólo se ve afectada la frecuencia 1404Hz, correspondiente al segundo sistema resonante. Tal como sabíamos la copa absorbe energía y se pone a vibrar en su frecuencia de resonancia, mientras que *ignora* el resto de frecuencias.

Veamos lo que ocurre si alternamos una copa y la otra entre micrófono y altavoz:

{% include image.html size="" file="alternando_ancha.png" caption="" %}

Se puede apreciar perfectamente qué copa está puesta en cada momento pues al ser sistemas resonantes muy buenos sólo absorben energía y vibran en una, o varias, frecuencias concretas. Dos cosas que podemos observar aquí, una es que la frecuencia de control de 512Hz no se altera. Y dos, para eso he ensanchado la imagen, es que la segunda copa no resuena exactamente en la frecuencia del pulso sino en una frecuencia ligeramente más baja (más a la izquierda). Por eso el efecto es bastante menor que en la copa del centro. Aquí se ve claramente la diferencia entre la frecuencia del pulso y de resonancia:

{% include image.html size="" file="desfase_copa2_1394_1404.png" caption="" %}

Las oscilaciones la copa 2 ocurren en 1394Hz y no en 1404Hz como esperábamos. Por otro lado, viendo ahora la copa 1, es claro que la energía tiende a concentrarse en torno a la frecuencia de resonancia. Ved cómo se estrecha el pulso de 1068 cuando interponemos la copa 1:

{% include image.html size="" file="centrado_de_frecuencia.png" caption="" %}

Aún no estando perfectamente centrada, no está tan desplazada como la anterior, y el efecto se nota mucho más. El desplazamiento de la frecuencia se deberá seguramente a que tenía cogidas las copas para ir alternándolas. Es un buen ejemplo de cómo afectan las fuerzas externas, produciendo un desplazamiento en frecuencia o alterando el tiempo de relajación. Es precisamente en lo que se basa la Resonancia Magnética Nuclear.

## Absorción de energía

Hemos usado varias veces la expresión *absorbe energía y vibra*. Pensad lo que significa:

- Cuando a un oscilador amortiguado (que es lo que es en realidad un sistema resonante) se le aplica una fuerza en su frecuencia de resonancia, este la absorbe. Extrayendo energía del campo oscilante.
- Cuando la fuerza desaparece, el sistema continúa oscilando durante el tiempo que tarde en perder la energía absorbida (generalmente en forma de disipación por calor).

Es decir que si metemos la copa 1 en el campo debemos observar una atenuación justo en la frecuencia de resonancia momento antes de ponerse a vibrar. Lo habíamos visto en la otra entrada, pero aquí lo tenemos más claro:

{% include image.html size="medium" file="absorcion.png" caption="" %}

Se aprecia que mientras las frecuencias derecha e izquierda no notan apenas la introducción de la copa, sí se atenúa la recepción de la frecuencia central.

Pues bien, esta disminución de la intensidad que tanto cuesta ver en un sistema mecánico es mucho más pronunciado con un **oscilador electromagnético** y se puede medir sin problemas. Ese es el principio de funcionamiento de cosas tan variadas como:

- **Un sistema antirrobo**: No hablo de los modernos que usan RFID, sino de los antiguos que constan de un emisor y un receptor enfrentados. La intensidad que ve el receptor es constante mientras que no se interponga un objeto que resuene en la frecuencia acordada. Cuando entre emisor y receptor pasa un objeto resonante absorbe parte de la energía del campo. Esta disminución brusca la detecta inmediatamente el receptor que se pone a pitar como loco.

- **Un sistema de control de trenes**: concretamente el [sistema INDUSI](http://www.sh1.org/eisenbahn/rindusi2.htm). La locomotora cuenta con tres osciladores a 500Hz, 1000Hz y 2000Hz. Sobre la vía hay osciladores que resuenan a cada una de esas frecuencias o no, dependiendo del estado de la señal. Cuando el tren pasa sobre una baliza que resuena en 2000Hz, por ejemplo, se detecta una alteración en ese oscilador de cabina. Concretamente, una señal de 2000Hz significa que el tren está rebasando una señal de parada y el sistema activaría automáticamente el freno de emergencia.

- **Resonancia Magnética**: En este caso no nos interesa la disminución del campo, sino la vibración posterior. La [resonancia magnética](http://webs2002.uab.es/vicente_aige/reso1.htm) se basa en enviar un pulso oscilante para excitar los protones desapareados de un núcleo atómico y luego escuchar cómo se produce la relajación. Este *eco* es distinto dependiendo de tipo de átomo, y de la materia que lo rodea. Interpretando digitalmente esa información se pueden distinguir tejidos, órganos, etc. que luego se presentan en una pantalla.

Os dejo los archivos [aquí]({{page.assets | relative_url}}/resonancia_pulsante.rar) por si queréis hacer más pruebas.

- **copa_tipo_1.wav**: respuesta a impulso de la primera copa para determinar sus frecuencias.
- **copa_tipo_2.wav**: respuesta a impulso de la segunda copa.
- **tonos_1068_1404_512.wav**: Pulso de esas tres frecuencias combinadas.
- **sin_copa.dat**: Intensidad media de un pulso recibido sin copa intermedia.
- **con_copa.dat**: Intensidad media de un pulso con una de las frecuencias atenuada.
