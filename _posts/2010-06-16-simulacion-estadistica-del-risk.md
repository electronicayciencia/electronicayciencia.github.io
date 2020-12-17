---
assets: /assets/2010/06/simulacion-estadistica-del-risk
image: /assets/2010/06/simulacion-estadistica-del-risk/img/tabla.png
layout: post
tags:
- Estadística
- Matemáticas
title: Simulación estadística del Risk
---

Si juegas al [Risk](http://es.wikipedia.org/wiki/Risk) esta entrada te puede gustar. Si no juegas al Risk pero quieres ver cómo se hace una simulación estadística por ordenador también te sirve. El Risk es un juego de estrategia y suerte. Para quien no lo conozca las batallas se deciden de acuerdo con repetidas tiradas de dados que hacen perder al atacante, al defensor o a ambos 1 o 2 ejércitos en cada una.

Lo que voy a hacer es estimar las probabilidades que tenemos de ganar o perder según el número de ejércitos atacantes y defensores. Se puede razonar analíticamente a partir de las probabilidades de cada tirada. Pero yo personalmente prefiero que el ordenador lo calcule mientras hago otras cosas, y después ya analizaré los resultados.

En una simulación por ordenador hay tres etapas básicas.

1. Definir el algoritmo y programarlo.
1. Analizar los datos obtenidos.
1. Presentar los resultados.

<!--more-->

## Algoritmo y programa

En este caso el algoritmo es sencillamente las reglas del juego.

Lo que vamos a hacer es programar el PC para que juegue un número muy elevado de batallas cambiando el número de ejércitos de atacante y del defensor en cada caso (1 contra 1, 1 contra 2 ... hasta 16 contra 16) y vaya anotando los resultados. Tras un tiempo de cómputo tendremos un número de batallas suficientemente alto de cada caso como para sacar conclusiones estadísticas. A veces se llama a esto *método de Montecarlo*, aunque no lo es estrictamente.

En un principio (año 2002) escribí el programa en BASIC, que no es lo más adecuado, en esta ocasión lo he rescrito en C. Al hacer cálculo por ordenador hay siempre un bucle y una rutina que se repite un número elevado de veces. Se trata de optimizarla todo lo posible para reducir el tiempo de cálculo.

El programa principal se llama *risk.c*. Este anota los resultados en ficheros de texto con las bajas del atacante, bajas del defensor, número de tiradas de dados y el resultado de la batalla. Todo esto en una línea por batalla. hice una simulación de **200.000** batallas por cada caso; esto significa 16 atacantes, por 16 defensores, por 200.000 líneas en cada batalla. O sea 51.200.000 líneas repartidas en 255 ficheros.

Como veis cuando hablamos de simulación estadística hablamos de números grandes. Las batallas se resuelven en 4 tiradas de dados en promedio, así que la rutina que tira los dados se ha ejecutado más de **200 millones** de veces. No es mucho, por eso la importancia de optimizar estas funciones.

## Análisis de los datos

Estas simulaciones siempre vomitan un torrente de datos que es poco práctico. Así que lo primero que haremos será resumirlos en algo que podamos tratar con más facilidad. Un segundo programa, esta vez en Perl llamado *compactadatos.pl* se encargará de eliminar la información redundante.

No nos interesa el orden de las partidas, puesto que no viene determinado por las reglas de juego. Lo que nos interesa es cuantas bajas hay en cada caso, o más concretamente su histograma. Es decir, de las 200.000 veces que se jugó el caso 4 vs. 5 ¿cuantas veces la batalla fue favorable para el atacante y cuantas para el defensor? ¿cuántas veces hubo 1, 2 o 3 bajas? etc.

El resultado de programa son dos ficheros. Uno en modo texto por si queremos exportar esos resultados para tratarlos con otro procedimiento. Y otro en formato *Perl Storable* para cargarlos posteriormente en otro programa en Perl.

## Resultados

Hay que pensar despacio cómo presentar los resultados ya que de ello depende la visibilidad del estudio. No quería complicarme demasiado con esta entrada así que voy a presentaros los resultados en forma de HTML estático. Id a esta dirección: [http://eyciencia.000a.biz/simurisk/](http://eyciencia.000a.biz/simurisk/). Allí encontraréis una tabla como esta:

{% include image.html size="" file="tabla.png" caption="" %}

Los atacantes crecen hacia abajo, mientras que los defensores lo hacen hacia la derecha.

La tabla está dividida en tres zonas. El color rojo indica que hay más de un 75% de probabilidades de que gane el atacante. El color azul lo mismo pero para el defensor. El color cielo aquí es neutro. Fijaos que la diagonal siempre es neutra. Eso significa que a igual número de ejércitos, ningún jugador tiene *significativamente* más probabilidades de ganar que el otro (en el caso 1 vs. 1 un 58% frente a 42% no es significativo).

Además la zona neutra se va ensanchando a medida que aumentan los números. Es algo típico de los sucesos aleatorios, a más ejércitos, más tiradas hay que hacer, luego más incertidumbre en el resultado.

En general tras una tirada pueden pasar tres cosas, hay casos particulares en que no es así cuando alguno de los jugadores tiene sólo un ejército en el territorio.

- El atacante pierde dos ejércitos (nos movemos dos casilla hacia arriba en la tabla).
- El defensor pierde dos ejércitos (dos casillas hacia la izquierda).
- Ambos pierden un ejército (una casilla hacia arriba en diagonal).

Teniendo en cuenta eso, hay casos que son más favorables que otros. Fijaos en el caso de 4 contra 4:

{% include image.html size="" file="6v9.png" caption="" %}

A priori no está decidido. Y sigue sin estarlo si empatan. Pero cuando el atacante o el defensor pierden dos ejércitos la batalla se decanta hacia el contrario y es muy difícil recuperar. Esto sería un caso más o menos justo. Pero mirad el 6 contra 9.

{% include image.html size="" file="4v4.png" caption="" %}

En principio podría ganar cualquiera, pero es claramente desfavorable para el atacante, porque tanto si empata como si pierde disminuyen mucho sus posibilidades. Para el atacante, ganar la primera tirada no le proporciona tanta ventaja como al defensor.

Elegid un caso, por ejemplo 10 atacantes contra 9 defensores. El navegador indica que hay un 65% de probabilidades de ganar (para el atacante) y muestra tres gráficos.

{% include image.html size="big" file="rojo.png" caption="" %}

Estas son las bajas del atacante. Que van desde 0 hasta N-1. Se ha eliminado el caso de N bajas porque si el atacante pierde todos sus ejércitos pierde la batalla. Se debe interpretar como: *si el atacante gana, cuantas bajas espera tener durante la contienda*. aquí vemos que lo más probable es que tengamos 5, 6 ó 7 bajas. No es frecuente tener 1 o 2 bajas cuando luchamos contra 9 defensores, de hecho sólo ocurre en un 2% de los casos. Tampoco esperamos ganar teniendo 8 ó 9 bajas, porque en esas circunstancias lo normal es que perdamos ya que no atacaríamos con los 3 dados sino con 2 o con 1.

{% include image.html size="big" file="azul.png" caption="" %}

Este es el mismo gráfico pero para el defensor. Se debe leer como *en el hipotético caso de que gane el defensor y pierda el atacante, cómo de mermadas quedarán sus tropas.* Aquí vemos cómo el hecho de luchar en inferioridad resulta muy perjudicial, y en caso de que consiga resistir el ataque se esperan 6 ó 7 bajas. Al igual que en el del atacante, no es de esperar que gane con 8 bajas porque en ese caso pasa de defensor con 2 a defender con 1 y lo frecuente es perder.

{% include image.html size="big" file="verde.png" caption="" %}

Este gráfico muestra el número de tiradas de dados. Lo normal es que la batalla dure entre 6 y 9 tiradas. Es matemáticamente imposible que sea inferior a 5.

En la parte inferior de la página hay tres botones. Debemos seleccionar uno en función del resultado de los dados y nos llevará al estado siguiente para mostrarnos sus probabilidades.

Espero que os haya gustado este pequeño estudio. Para los jugadores espero que os ayude a la hora de planificar vuestra estrategia, pero tened siempre en cuenta que en el azar nunca hay nada seguro, y que aún con el 99% de probabilidades de ganar, podríais perder y viceversa.

Os dejo los programas y las páginas HTML para descargar [aqui]({{page.assets | relative_url}}/simurisk.zip).
