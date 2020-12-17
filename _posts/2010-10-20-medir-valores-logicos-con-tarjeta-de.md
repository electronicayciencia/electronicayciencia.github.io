---
assets: /assets/2010/10/medir-valores-logicos-con-tarjeta-de
image: /assets/2010/10/medir-valores-logicos-con-tarjeta-de/img/BENQ0004.JPG
layout: post
tags:
- Sonido
- Reciclaje
title: Medir valores lógicos con tarjeta de sonido
---

Hoy os cuento el primer intento de una prueba que quería hacer desde hace tiempo. Se trata de adaptar una tarjeta de sonido para poder medir también valores de tensión continua. Este es uno de esos experimentos que tienen muchas posibilidades de salir mal, o por lo menos, de no salir tan bien como esperábamos. Las cosas no siempre salen a la primera.

La prueba la he hecho con una tarjeta USB [muy barata](http://www.dealextreme.com/details.dx/sku.22475). Está basada en el chipset [TP6911 de Tenx]({{page.assets | relative_url}}/DS-TP6911_V10.pdf) y sus cualidades de grabación son bastante pobres:

- ADC de 10 bits.
- Frecuencia de muestreo 24kHz
- Mono

Pero más que suficientes para lo que haremos. ¿24kHz es poco? Pues para grabar con calidad de CD no sirve, pero precisamente este experimento va de medir tensión continua o que varía muy lentamente. ¿10bits es poco? Hombre depende, si lo que queremos es medir valores lógicos nos sobran 9.

Con el tamaño de los componentes que tienen estos productos genéricos *made in China* es poco menos que un trabajo de relojería.

{% include image.html size="medium" file="BENQ0004.JPG" caption="" %}

## Configuración de entrada

No voy a meterme en cómo se puede configurar un ADC, Maxim tiene [una buena guía](http://www.maxim-ic.com/app-notes/index.mvp/id/1108). Según el datasheet del TP6911 el circuito debe parecerse a este:

{% include image.html size="medium" file="esquema_TP6911.png" caption="" %}

A la derecha veis la entrada de micrófono. Con la típica configuración para alimentar un [electret]({{site.baseurl}}{% post_url 2010-06-04-utilizar-un-microfono-electret %}).

En teoría lo que queremos hacer es puentear el condensador en serie para que no nos cape la componente continua. Y de paso cargarnos también la resistencia que lleva la alimentación para el micrófono, porque si no la estaríamos midiendo también. Tampoco nos interesan los condensadores en paralelo que puedan estar filtrando ya que estos sólo introducirían demora y artefactos en la medida.

Como podéis ver no estamos haciendo una mejora, sino una mutilación. Estamos eliminando los filtros paso bajo y paso alto que dotan de más o menos calidad a la entrada y es probable que cuando terminemos ya no nos sirva para conectar un micrófono.

Hay un primer problema. La entrada de micro parece ser diferencial. Si la entrada estuviera referida a masa todo sería perfecto, pero no es así. Para esta primera prueba, rápida y poco cuidadosa todo hay que decirlo, opto por ignorar la entrada negativa. Y como era de esperar el rango dinámico se reduce a la mitad. Es decir que en lugar de medir valores simétricos MIN-0-MAX vamos a medir sólo entre MIN y 0.

Hay un segundo problema. El datasheet TP6911 es muy básico. Y aunque he encontrado [tres notas de aplicación](http://www.iamnota.net/hw:tp6911) son prácticamente iguales. Así que lo siento, las pruebas hay que hacerlas por ensayo y error.

Por ejemplo la estructura de la entrada de grabación dicen que es así:

{% include image.html size="medium" file="esquema_rec.png" caption="" %}

Sin embargo no se corresponde con el circuito de la tarjeta. La resistencia no existe y si eliminamos el condensador se supone que no deberíamos tener señal de entrada. Sin embargo la tenemos. Es parecido a trabajar a ciegas. Por suerte este hardware es muy barato.

## Ejemplos

Me hubiera gustado mostraros la captura con el Xoscope. Pero no me deja seleccionar el dispositivo de entrada, y como ya tenía configurada la tarjeta integrada no admite la USB. Nos apañaremos con Audacity y Baudline.

En primer lugar probaremos con un potenciómetro. Observad cómo se produce saturación antes de llegar al mínimo y antes de llegar al 0.

{% include image.html size="big" file="audacity_lento.png" caption="" %}

Ahora vamos a conectar un módulo detector de IR y veremos cómo es una ráfaga infrarroja de un mando a distancia NEC. De estos módulos ya hablamos [en otra entrada]({{site.baseurl}}{% post_url 2010-05-07-receptor-con-pic-para-mandos %}).

{% include image.html size="big" file="audacity_nec.png" caption="" %}

Para terminar vamos a conectar un interruptor a masa. Y veamos lo que ocurre al pulsar. Todos los que hayáis trabajado con pulsadores habréis tenido el problema de los rebotes (bounces). Que consiste en que la pulsación no es limpia sino que abre y cierra varias veces hasta quedar en un estado estable. Por eso hay que incorporar una rutina o unos componentes que eviten contar estos rebotes rápidos como pulsaciones legítimas.

{% include image.html size="" file="cerrar_inter.png" caption="" %}

Así es como se ve la pulsación de un botón. El tiempo entre que se pulsa hasta que queda estable es de aproximadamente 1 milisegundo.

Si necesitáis medir valores digitales por USB este es el procedimiento más sencillo que hay. Otra opción es usar el [conversor USB a puerto serie]({{site.baseurl}}{% post_url 2010-03-22-conversor-usb-rs232 %}) que ya publicamos. Veis que el procedimiento que hemos seguido no es el mejor pero sirve perfectamente para nuestro propósito. Es cuestión de hacer pruebas para mejorar los resultados.
