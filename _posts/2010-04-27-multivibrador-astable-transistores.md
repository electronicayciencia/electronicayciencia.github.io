---
assets: /assets/2010/04/multivibrador-astable-transistores
image: /assets/2010/04/multivibrador-astable-transistores/img/astable_npn.png
layout: post
tags:
- Circuitos
- Sonido
title: 'Multivibrador astable a transistores: explicación'
---

El astable con dos transistores NPN es de los primeros circuitos que se estudian cuando se habla de transistores en conmutación. Como su esquema es tan simple, es de esas cosas pequeñas que te crees que las entiendes, hasta que te das cuenta de que tú también habrías colocado [los condensadores del revés](http://www.electro-tech-online.com/electronic-projects-design-ideas-reviews/103591-transistor-astable-multivibrator-problem.html). Voy a explicar despacio cómo funciona, y veréis que aunque parece sencillo su funcionamiento es interesante.

{% include image.html size="small" file="astable_npn.png" caption="" %}

<!--more-->

## Estado 1: Q1 conduce, Q2 en corte

Un astable tiene dos estados, y ambos son inestables, de forma que el circuito alterna continuamente uno con otro. Empecemos por el estado 1. Al contrario de otras explicaciones que veréis, yo no voy a partir de cuando se aplica tensión. Mejor os cuento cómo está el circuito justo al empezar el estado 1, como si acabara de conmutar desde el estado 2. De momento tendréis que creerme estas condiciones iniciales, pero al final del artículo entenderéis por qué.

Al comienzo del estado 1:

- Q1 está en conducción.
- Q2 está en corte.
- C1 está cargado positivamente con un potencial de Vcc - 0.7.
- C2 está cargado negativamente (el terminal + está a menos tensión que el -) con un potencial de -0.7V.

Como Q2 está en corte vamos a considerar que no pasa corriente por sus terminales. Así imaginariamente sacamos Q2 del circuito. Como Q1 está en conducción, su unión Base-Emisor es como un diodo polarizado en directo (sustituimos esta unión por un diodo); y al estar saturado suponemos que la pérdida de tensión Emisor-Colector es mínima (sustituiremos esta por un conductor).

Recoloquemos los componentes para verlo más claro.

{% include image.html size="small" file="astable_estado1.png" caption="" %}

C2 va a cargarse a través de R4 y la base de Q1. Así pues C2, que empezó con -0.7V va a cargarse hasta Vcc-0.7V (no llega a Vcc porque 0.7V es la caída de tensión B-E de Q1). Y además esta carga será muy rápida porque R1 y R4 serán de un valor muy bajo comparadas con R2 y R3.

Mientras tanto C1, que partía con Vcc-0.7 voltios positivos, ahora está conectado del revés. Así que empieza a descargarse (o a cargarse negativamente, da igual) a través de R2. Esta carga será más lenta. Desde los Vcc-0.7 hasta... en teoría hasta -V (pongo el menos para indicar que está invertido), pero no va a llegar ahí. Porque cuando C1 alcanza los -0.7V, su terminal + está a masa y el - tiene ya 0.7V, y este último está conectado a la base de Q2. ¿Qué pasa cuando cuando a un NPN le aplicamos a su base 0.7 voltios más que a su emisor?

La tensión BE de Q2 es 0.7 más o menos, mientras la tensión en la base esté por debajo de ese valor no va a conducir. En el momento en que se alcanza esa tensión ya sí conduce. La base de Q2 queda polarizada a través de R2.

Recordemos que a estas alturas C2 se había cargado completamente hasta Vcc-0.7. Pues cuando Q2 pasa a conducción **conecta a masa el terminal +** de C2, mientras el - sigue aplicado a la base de Q1. Es como si se aplicara el condensador, invertido, a Q1. La base de Q1 recibe de golpe -(Vcc-0.7) que lo lleva inmediatamente al corte. Pudiendo incluso provocar una *ruptura de la unión por avalancha*. En estas condiciones entramos al estado 2.

## Estado 2: Q1 en corte, Q2 conduce

Tal como hicimos para el estado 1, vamos a describir las condiciones iniciales del estado 2. Que son las del párrafo anterior.

Al comienzo del estado 2:

- Q1 está en corte.
- Q2 está en conducción.
- C1 está cargado negativamente con un potencial de -0.7V.
- C2 está cargado positivamente con un potencial de Vcc - 0.7.

Haciendo lo mismo que antes, vamos a eliminar Q1 del circuito y vamos a sustituir Q2 por un diodo y un puente:

{% include image.html size="small" file="astable_estado2.png" caption="" %}

Vemos que C1 va a ir desde -0.7V hasta los Vcc-0.7V, rápidamente pues R1 es pequeña.

C2 va a (des)cargarse lentamente a través de R3 desde los Vcc-0.7V hasta los -Vcc, **¡MENTIRA!** sólo va a llegar hasta -0.7V. Porque cuando llegue ahí Q1 va a conducir, va a llevar a masa el + de C1 y va a aplicar a la base de Q2 toda la carga de C1 invertida, llevándolo al corte. Y provocando el estado 1 de nuevo.

Vemos que cuando eso pase tendremos:

- Q1 está en conducción.
- Q2 está en corte.
- C1 está cargado positivamente con un potencial de Vcc - 0.7V.
- C2 está cargado negativamente con un potencial de -0.7V.

Que son justamente las condiciones iniciales que dimos para el estado 1. Así el ciclo se repite indefinidamente.

{% include image.html size="medium" file="condensadores.png" caption="" %}

## Calcular los componentes

Para empezar, nos interesa que los condensadores se cargen por R1 y R4 más rápidamente de lo que se descargan por R2 o R3. Porque cuando ocurra la transición queremos que el otro ya esté cargado. Así que R1 &lt; R2 y R4 &lt; R3. Por simplicidad haremos R1 = R4. Pero no nos interesa que la corriente que fluye Emisor-Colector durante la carga queme los transistores. Dependidiendo de la tensión de alimentación, un valor entre 100ohm y 1k estaría bien. Recordad cumplir las condiciones anteriores.

El tiempo que tarda en conmutar del estado 1 al estado 2 viene dado por lo que le lleva a C1 descargase desde los Vcc-0.7V hasta los -0.7V. Lo hace a través de R2, y usando la [ecuación de carga de un condensador](http://www.electronicafacil.net/tutoriales/Carga-descarga-condensador.html) tenemos:

$$
V = V(t) = E + (V_0 - E)e^{-\frac{t}{RC}}
$$

Donde:

- **Tensión inicial**: V0 = Vcc-0.7
- **Tensión en bornes**: E = - Vcc
- **Tensión final**: V = -0.7

$$
t = RC \ln \left(\frac{V_0 - E}{V - E}\right)
$$

$$
t = RC \ln \left( \frac{2 V_{cc} - 0.7}{V_{cc} - 0.7}\right) \simeq RC \ln(2)
$$

Este último valor es el que suele darse habitualmente. La aproximación tiene un margen de error que es menor cuanto mayor sea la tensión de alimentación. Con 5V el error es de un 10%, como es del mismo orden que la tolerancia de los componentes se admite tal aproximación.

## Límites

- **Transistores**: Cuando el transistor que estaba en corte pasa a conducir, aplica a la base del otro una tensión negativa de -(Vcc-0.7V). La *tensión inversa de ruptura* de la unión BE viene a ser -5 voltios. Si alimentamos este circuito con más de 5V fácilmente la superaríamos. Para evitar esto a veces se colocan dos diodos en la base de Q1 y Q2 que permitan la carga pero impidan que circule corriente en sentido inverso.

- **Condensadores**: Para un cerámico o uno de poliester no hay problema, pero en un electrolítico invertir los terminales para cargarlo del revés puede destruirlo. Si bien es cierto que aquí sólo se llegan a cargar invertidos hasta los 0.7V.

- **Tiempo**: El tiempo viene determinado por la capacidad de C1 y C2 así como por R2 y R3. Mientras más altos sean estos valores más durará cada estado. Pero si usamos unos condensadores demasiado grandes, puede que tengan demasiadas pérdidas y el circuito no empiece a oscilar. Igualmente para las resistencias, si aumentamos demasiado el valor de R2 por ejemplo, puede que no pase corriente bastante para polarizar la base de Q2 una vez se alcance la tensión de disparo. Si no puede llevarlo a conducción, no se alcanzará nunca el estado 2. Si se necesitan retardos mayores se puede optar por transistores darlington, aunque dado el coste de los condensadores de la capacidad necesaria es mejor optar por otros temporizadores como el NE555 o el [CD4060](http://www.google.com/search?q=cd4060+timer).

- **Frecuencia**: Así como hay un límite superior del periodo, también hay un límite inferior. Puede pasar que queramos un periodo tan bajo que usemos condensadores y resistencias muy pequeños. Entonces al conectar el circuito se cargarán ambos casi al instante, para dos los transistores. Así el circuito queda en un estado estable y no oscila. Por no hablar de que a esas frecuencias si oscilara sería muy inestable, variando la frecuencia sólo con acercar o alejar la mano. Si queremos frecuencias de MHz tendremos que usar otros osciladores, a ser posible sintonizados por un cristal de cuarzo.

## Fijar el estado inicial

Si el circuito es perfectamente simétrico no oscilará, porque está equilibrado. Pero eso nunca pasa porque los componentes tienen tolerancias e imperfecciones. No hay dos resistencias del mismo valor ni dos transistores con la misma ganancia. Son estas diferencias las que rompen la simetría y el circuito empieza a oscilar.

Pero son diferencias microscópicas y dependen de tantos factores que no las podemos controlar: temperatura, carga residual de los condensadores, longitud de las patillas, soldaduras, grosor de las pistas de cobre, etc. Así que nunca sabemos de qué lado empezará.

Para hacer que siempre empiece del mismo lado tenemos que romper nosotros la simetría para favorecer un transistor frente al otro. Lo más sencillo es alterar el valor de los componentes para que un condensador se cargue antes que el otro. Lo malo es que el *Duty Cycle* (la fracción entre el tiempo en off y el tiempo en on) nunca será del 50%, porque al favorecer nosotros una de las posiciones, los ciclos de carga y descarga ya no durarán lo mismo.

La única forma de hacer que ambos ciclos duren lo mismo (salvo pequeñas diferencias) y que siempre empiece por el mismo sitio es forzándolo nosotros: en lugar de poner el interruptor en la alimentación, ponerlo en la base de algún transistor.

Nada más alimentar el circuito llegará a un estado que dependerá de dónde hayamos puesto el interruptor. Y no hará nada más, porque esta incompleto. Cuando pulsemos el interruptor el circuito oscilará partiendo de ese estado inicial que siempre será el mismo. La desventaja es que siempre habrá un consumo de corriente aunque el interruptor esté apagado.
