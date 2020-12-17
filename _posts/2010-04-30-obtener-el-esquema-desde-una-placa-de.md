---
assets: /assets/2010/04/obtener-el-esquema-desde-una-placa-de
image: /assets/2010/04/obtener-el-esquema-desde-una-placa-de/img/BENQ0020.JPG
layout: post
tags:
- Circuitos
- Reciclaje
title: Obtener el esquema desde una placa de circuito impreso
---

Pasar de una PCB al esquema es siempre un coñazo, lo hagas como lo hagas. Además es fácil equivocarse y acabar liado con un circuito que no tira ni para atrás. Por eso os quiero presentar un método sistemático que os servirá de guía para no perder el hilo. Para los expertos, lo que vamos buscando es reconstruir el *netlist*.

{% include image.html size="small" file="BENQ0020.JPG" caption="" %}

Tengo un sencillo transmisor de un coche de juguete y voy a dibujar el esquema para analizarlo en una próxima entrada. Como la placa es pequeña, con componentes habituales y de una sola cara me servirá de ejemplo.

<!--more-->

- Lo primero que tenéis que hacer es **numerar las pistas** de la placa. A veces, por el tamaño, es más fácil hacerlo sobre una fotografía que sobre la misma placa.

{% include image.html size="small" file="pistas_numeradas.png" caption="" %}

- Ahora **numerad los componentes**. Es habitual que la referencia venga serigrafiada en la placa. Pero si no es así lo necesitamos para poder identificarlos: R1, R2 ... Incluid también los conectores externos.

- Con esto podéis **construir una tabla**, o una hoja de cálculo, en la que las filas serán los componentes y cada columna será una pista de la placa. El objetivo es reconstruir un archivo tipo *netlist* para después llevarlo al esquema. Algo parecido a este **ejemplo** *(click en la imagen para ampliar)*:

{% include image.html size="big" file="ejemplo_pistas.png" caption="" %}

- Tomad un componente, y **marcad en la tabla** a qué pistas está conectado. Si los terminales no tienen una función podéis poner una X, como en las resistencias. Si la tienen anotaremos qué terminal es, por ejemplo A o K para un diodo, E, B o C para un transistor.

- En la última columna de la derecha anotaremos **el valor** del componente o su referencia.

- Fijaos en que hay una penúltima columna que cuenta cuántos terminales tiene conectados cada componente. Huelga decir que **tiene que coincidir** con los que tiene realmente.

- Asimismo en la última fila contaremos cuantas **conexiones** nos han salido **para cada pista**. El mismo número tenemos que contar en la placa. Si algún dato no nos cuadra no queda otra que revisar los componentes que hemos conectado a esa pista.

- **Resaltar las pistas** de alimentación y masa es una buena idea.

Una vez tengamos la tabla completa es hora de llevarlo al esquema. Hay varios caminos, sería muy interesante escribir el *netlist* e importarlo en algún programa de captura de esquemas. Pero generalmente sólo valen para pasar del esquema al PCB y no permiten lo contrario. Así que toca hacerlo a mano.

1. En primer lugar plantamos los **componentes**.
1. A continuación plantamos **símbolos de alimentación y masa** y conectamos los pines que vayan a estas pistas. Nos facilitará la orientación (masa hacia abajo, positivo arriba generalmente) evitando que tengamos que rotar los componentes más adelante. Es posible que el programa nos fuerce a que la pista de masa sea la número 0, no pasa nada siempre que lo tengamos en cuenta de ahora en adelante.
1. En las pistas que tengan 2 conexiones, unimos los componentes directamente.
1. Para las que tengan 3 o 4 plantamos nodos y vamos conectando ahí. Hay que prestar especial atención al **nombrar los componentes y las pistas** *(net name)* para que coincidan con nuestra tabla. El programa debe permitirnos esto.
1. Las pistas que tengan más de 4 uniones hay que pararse a pensar cómo las dibujamos.
1. Finalmente habrá que **recolocar** algunos componentes. Aquí cuenta la experiencia de cada uno, pero también los esquemas que tengamos vistos. Mientras más circuitos conozcamos más fácil será **identificar los patrones**. La colocación de los componentes es la parte más difícil porque hay que romperse la cabeza y, si identificamos una configuración concreta (tal como un oscilador astable en este caso por ejemplo) intentar presentarla de la manera habitual. Si acabamos con un esquema embrollado donde no se distinguen las partes, no nos servirá para nada. Recordad que una regla importante es que se distingan fácilmente las partes del circuito.

{% include image.html size="big" file="circuito.png" caption="" %}

El circuito lo comentaremos en días posteriores.

## El formato *netlist*

Por último, si queremos estar completamente seguros de que hemos dibujado bien el esquema, tenemos la opción de exportar el fichero *netlist* y compararlo con la tabla que hemos hecho al principio. Lógicamente deben coincidir.

Un archivo *netlist* *(o netfile)* no es más que un archivo de texto que indica los componentes y a qué red va cada terminal. O sea lo mismo que hemos hecho con la tabla, sólo que menos legible. Cada programa usa su propio formato, pero la idea es la misma. Un ejemplo:

    rR1 5  0     100
    rR2 11 0     1200
    qQ1 4  6  5  2SC945
    dD1 0  VSS   1N4148

La primera columna es el tipo de componente y su identificador. Siguen las pistas a donde va conectado teniendo en cuenta la numeración de los terminales (depende de cada encapsulado). A continuación se pueden indicar notas como el valor o el modelo concreto.

Fijaos como la pista de masa, que nosotros habíamos llamado 2 (o Gnd), el programa nos la ha forzado a 0, la 8 aparece como Vcc y la 13 como Vss.
