---
assets: /assets/2010/09/termometro-para-disoluciones
image: /assets/2010/09/termometro-para-disoluciones/img/termoboli.png
layout: post
tags:
- Circuitos
- Reciclaje
title: Termómetro para disoluciones
---

Lo que os presento en esta entrada es un trabajo de bricolaje más que un circuito. Se trata de un termómetro o, para ser más precisos, una *sonda termométrica* para medir la temperatura de una disolución. Hay experimentos en que tenemos que controlar la temperatura mientras removemos, por ejemplo que no sobrepase los 10ºC. Y a veces queremos saber la temperatura en un punto concreto, por ejemplo para ver cómo aumenta al añadir un ácido. En esta entrada voy a hablar de cómo hacer una "varilla-termómetro" para cuando haga falta.

Partimos de un **bolígrafo viejo**, y nos quedamos sólo con el cuerpo cilíndrico. Es importante que sea de plástico, pues si el bolígrafo tiene partes metálicas puede reaccionar con los productos químicos en disolución. Siendo de plástico es difícil que reaccione más que con algunos disolventes orgánicos. Dentro del cilindro metemos un LM35 o un integrado similar, como el TMP35/36 de Analog Devices, y algo de electrónica para acondicionarlo.

## Parte electrónica

Tanto el LM35 como el TMP35 dan en su salida un voltaje proporcional a la temperatura en grados centígrados, que se puede medir utilizando un voltímetro. Están calibrados para ofrecer 10mV/ºC así pues mediríamos 250mV para una temperatura de 25ºC 100mV para 10ºC.

El TMP35 también permite medir temperaturas negativas aunque para eso habría que usar una fuente simétrica. Sin embargo el TMP35 no está recomendado para menos de 10ºC, pudiéndose usar en su lugar el TMP36. El TMP36 es similar al TMP35 pero añade un offset de 500mV para poder medir temperaturas menores a 0ºC sin necesidad de una tensión negativa. Eso significa que para 25ºC en lugar de medir 250mV medimos 750mV, y por tanto a 0ºC en lugar de medir en teoría los 0mV que corresponden al TMP35, medimos 500mV. Y así sucesivamente. La tensión es fácilmente legible una vez te acostumbras a restar mentalmente 500mV.

Por otro lado el margen de alimentación para el LM35 llega hasta los 30V, sin embargo para el TMP35 la tensión máxima es de 7V. Para no depender tanto de la alimentación y del integrado que usemos vamos a incluir un pequeño circuito con un **zener** para rebajar la tensión hasta, digamos, unos 5V.

No pongo el esquema eléctrico, porque es fácil verlo sobre las pistas de la placa.

{% include image.html size="" file="termoboli.png" caption="" %}

He soldado un par de condensadores cerámicos para darle estabilidad. Todos los componentes van soldados por el lado de cobre. Tenéis dos opciones, o usáis componentes SMD o usáis componentes normales y recortáis las patillas. Por ejemplo una resistencia de 1/8W tiene un tamaño similar a una SMD grande.

Es imprescindible que el circuito quepa en el cuerpo del bolígrafo. Limad los bordes de la placa si fuera necesario.

## Construcción

Una vez hemos soldado los componentes y hemos comprobado que el circuito entra dentro del bolígrafo, soldamos el sensor TM35. El cable de alimentación y lectura tiene que tener tres conductores: la masa que es común, el positivo y el de salida. También lo soldamos a la placa.

Luego alojamos el sensor en el extremo del bolígrafo, para lo que (dependiendo de la forma) habremos tenido que cortar el borde. Lo sellamos con pegamento termofusible, o silicona líquida al gusto para hacerlo estanco.

{% include image.html size="" file="BENQ0032.JPG" caption="" %}

Finalmente **sellamos** también el extremo por donde sale el cable de alimentación, importante que quede también estanco. De lo contrario entraría agua cuando lo lavemos y el circuito funcionará de manera errática.

{% include image.html size="" file="BENQ0025.JPG" caption="" %}

Una vez terminado, soldad por ejemplo un clip para pilas de 9V y podréis leer la temperatura con cualquier voltímetro. El consumo es muy pequeño y con que la pila esté apenas cargada os servirá.

## Para terminar

Esta entrada pretende servir de idea básica, que por supuesto aún se puede elaborar mucho más. Todo depende de la imaginación y las necesidades del diseñador.

Por otra parte, si habéis usado termofusible tened en cuenta que, como su nombre indica, se funde. Así que tened cuidado con la **temperatura máxima** que puede resistir. Si habéis empleado silicona el plástico también tiene un límite, dependiendo del tipo de plástico que sea puede resistir más o menos hasta 100ºC sin deformarse, pero no mucho más allá.

Ya que no nos va a servir para altas temperaturas, es más práctico usar un TMP36 así también podremos medir temperaturas bajo cero, por ejemplo las que se alcanzan en un congelador.
