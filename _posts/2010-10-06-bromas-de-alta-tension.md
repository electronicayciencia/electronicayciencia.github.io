---
assets: /assets/2010/10/bromas-de-alta-tension
image: /assets/2010/10/bromas-de-alta-tension/img/shock_broma.jpg
layout: post
tags:
- Circuitos
- Reciclaje
title: Bromas de alta tensión
---

Vamos a hablar en esta entrada de esos típicos aparatos de broma que dan calambre. Todos los habéis visto, un bolígrafo que da corriente, o un puntero láser, un libro, etc. También hay juegos que el perdedor recibe un calambre, por ejemplo en algunas pistolas láser, o juegos de reflejos. Veamos cómo funcionan.

{% include image.html size="" file="shock_broma.jpg" caption="" %}

Antes de nada, no confundirlos con los aparatos de electro-estimulación muscular que se usan en rehabilitación (los llamados TENS). No tiene nada que ver: estos últimos actúan emitiendo una corriente a través de la piel que llega al músculo y lo estimula. Necesitan un pulso con una duración y una forma determinada y unos electrodos apropiados para llegar al músculo sin ser demasiado desagradable.

Sin embargo, ahora queremos que alguien sienta el calambre pero no llegar al músculo (porque sólo es una broma, no queremos electrocutar a nadie, ni causar espasmos, mi paradas cardíacas, ni quemaduras, ni otras cosas malas que hace la electricidad).

## Principio físico

- Primero necesitamos una corriente alterna, o pulsante, de baja frecuencia. Así la sensación será más desagradable pero inofensiva.
- Segundo es suficiente con tensiones muy altas, y de intensidad mientras más baja mejor. Recordad que lo que es peligroso no es la tensión. Lo que pasa es que la piel es como una resistencia, y si aumentan los voltios lo hacen los amperios.
- Tiempo muy limitado. Como decíamos antes si sube la tensión sube la intensidad, pero entonces ¿Como conseguimos alta tensión y baja intensidad a la vez? Pues una manera simple es por ejemplo con picos de muy corta duración. Así la intensidad será muy alta, pero durante un tiempo muy pequeño, y el efecto (que también depende del tiempo que dura) es mínimo.

Hmm... pulsos muy cortos, con tensiones elevadas... si tienes una mínima idea de electromagnetismo inmediatamente te sonará a una bobina. Ya hablamos en otra entrada sobre [transformadores flyback]({{site.baseurl}}{% post_url 2010-06-01-matamoscas-electronico-flyback %}). Y si no la tienes te cuento el tema muy por encima:

Cuando aplicamos tensión a una bobina (un inductor también se llama) crea un campo electromagnético. Y este proceso digamos que es lento, más lento cuanta más inducción (más vueltas) tiene la bobina, lo llamamos L. Se puede describir con esta fórmula:

$$
E = - {d \phi \over dt} = -L \cdot {dI \over dt }
$$

La primera parte viene a decir que la tensión (E) depende de cómo varíe el flujo magnético en el interior (φ). Eso es la [inducción](http://es.wikipedia.org/wiki/Ley_de_Faraday): Un imán gira dentro de una bobina y en los extremos tenemos una tensión eléctrica. Vamos a pasar del [signo negativo](http://aprendeenlinea.udea.edu.co/lms/moodle/mod/resource/view.php?id=11062).

La segunda parte dice que, como el flujo magnético también se puede obtener no con un imán externo, sino haciendo pasar una corriente por la bobina, pues la tensión inducida también depende de cómo cambie esta corriente.

**OJO:** Que la bobina induce tensión cuando la cambia corriente que pasa. Si pasa de no tener corriente a tenerla induce una tensión. Que no solemos notar. Pero si tenía corriente y la quitamos de golpe va a haber un pico de tensión. Por eso cuando usamos un transistor para activar un relé o un motor ponemos un diodo a contracorriente. Porque sabemos que cuando el transistor pase a corte y el relé se desactive, la corriente que circula va a cesar de golpe. Y la bobina va a reaccionar con un pico de tensión, y demás, por el signo menos es tensión inversa. La tensión inversa podría destruir el transistor de control si no hubiera un diodo en paralelo para cortocircuitarla.

Por cierto que la tensión inducida depende de la derivada de la intensidad, o sea del cambio, mientras más rápidamente cambie más voltios se inducen. Pero claro, durante un tiempo más breve. Y cuando digo *rápidamente* no me refiero a la frecuencia, sino a que el interruptor electrónico sea más o menos rápido. Independientemente de que luego repitamos varias veces por segundo.

## Esquema eléctrico

Así que ya sabemos lo que tenemos que hacer para dar calambre, tener una bobina gorda para conectarla y desconectarla, con un interruptor lo más rápido posible, a una frecuencia de varias veces por segundo.

Eso es precisamente lo que lleva el circuito de la foto que he puesto arriba.

{% include image.html size="medium" file="shock_broma_circuito.png" caption="" %}

Para reducir costes al mínimo lo que han hecho es utilizar componentes no estándar, diseñados para este circuito y fabricados en masa. Por ejemplo la bobina no es tan simple, es un autotransformador que sirve también para elevar la tensión de los picos.

Además hay un oscilador, representado por un interruptor. Que es una placa con una gota de resina Epoxy, diseñada para conectar y desconectar con una frecuencia de 150Hz.

Resulta que si medimos la tensión de salida con un tester *True RMS* sólo marca 7V. Claro, eso es el valor medio, RMS. En realidad el valor de pico alcanza fácilmente los miles de voltios y no se puede medir así.

Para medirlo nos basamos en la longitud del arco eléctrico (o sea de la chispa que hace). El aire seco tiene una [rigidez dieléctrica](http://campus.usal.es/%7Eelectricidad/Principal/Circuitos/Diccionario/Diccionario.php?b=id:154) de unos 3MV/m. Quiere decir que si la chispa mide 1m es que tiene una tensión de 3.000.000 de voltios.

Nuestra chispa no llega a más de medio milímetro por lo que suponemos que la tensión de salida puede ser de unos 1000V. Nada mal a partir de tres pilas botón. Y pulsos de 1000V son suficientes para dar un buen susto. Y sin daño porque el tiempo que se necesitaría para dañar el tejido es del orden de minutos, y

se retira la mano antes.
