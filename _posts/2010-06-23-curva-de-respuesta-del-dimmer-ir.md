---
assets: /assets/2010/06/curva-de-respuesta-del-dimmer-ir
image: /assets/2010/06/curva-de-respuesta-del-dimmer-ir/img/KallDark12.jpg
layout: post
tags:
- Fisica
- Sensores
title: Curva de respuesta del Dimmer IR
---

Hay varias entradas dedicadas a un proyecto para hacer un regulador de intensidad luminosa controlado (dimmer) por un mando a distancia infrarrojo. El proyecto tiene una parte hardware -pic, fuente de alimentación sin condensador, optotriac y triac-, y otra parte que es software. De la primera parte hablaremos más adelante.

Grosso modo, el software tiene que:

- Recibir la señal de un mando NEC o compatible, ya lo explicamos en [esta entrada]({{site.baseurl}}{% post_url 2010-05-07-receptor-con-pic-para-mandos %}), y modular la intensidad de luz alargando o acortando el tiempo de disparo del triac desde el paso por cero.
- Al variar este tiempo varía el valor eficaz de la tensión, de lo que ya hablamos [aquí]({{site.baseurl}}{% post_url 2010-03-29-valor-eficaz-de-una-sinusoidal %}).
- Y cuando la bombilla recibe esa tensión eficaz luce más o menos, dependiendo de la temperatura del filamento que a su vez influye sobre su resistencia interna. Esto [lo habíamos calculado]({{site.baseurl}}{% post_url 2010-03-27-caracteristica-i-v-de-una-bombilla %}) también.

## Intervalos regulares

Para que las subidas y bajadas de luz sean a intervalos regulares tenemos que compensar los efectos anteriores. Lo hacemos, programamos la interpolación en el PIC... y al probarlo nos sale un bodrio de pelotas. Al principio varía mucho y al final apenas cambia nada. ¿Qué ha pasado? Pues ha pasado que el ojo no es lineal sino que existe una relación entre la luz que recibe y cuánto tiene que variar para notar un cambio apreciable. Tiene lógica, con más luz el ojo reacciona, se adapta y disminuye la entrada, mientras más subamos la luz más se adapta. Por eso notamos más los cambios a intensidades bajas que a intensidades altas. La moraleja es que mientras más subamos la intensidad más grande el salto que debemos dar para el siguiente paso, porque si damos pasos iguales cada vez se notarán menos.

Eso se llama la [*ley de Weber*](http://es.wikipedia.org/wiki/Ley_de_Weber), que acaba diciendo que la respuesta de los sentidos es **logarítmica**. Esta "ley" tiene una historia interesante y de ella hablaré en otra entrada. Para el ojo se cumple muy bien con baja intensidad de luz. Por ejemplo la escala de brillo de las estrellas es logarítmica y da muy buenos resultados. En el siguiente gráfico se ve muy bien ([http://webvision.med.utah.edu/light_dark.html](http://webvision.med.utah.edu/light_dark.html)).

{% include image.html size="big" file="KallDark12.jpg" caption="" %}

Sin embargo aquí Weber no funciona porque trabajamos con luz más fuerte. Nos interesa más otra ley que es la [*ley de Stevens*](http://en.wikipedia.org/wiki/Stevens%27_power_law). Stevens propone que la respuesta no es logarítmica sino **potencial**, se podría decir que la ley de Stevens sustituye a la de Weber. Para el coeficiente debemos hacer varias pruebas y quedarnos con el que más nos guste.

## Cálculos

<iframe frameborder="0" height="300" src="https://spreadsheets.google.com/pub?key=0AjHcMU3xvtO8dDdZSVhpNXZTaFV0Vk45dlluM0todUE&amp;hl=es&amp;single=true&amp;gid=0&amp;output=html&amp;widget=true" width="500"></iframe>

Vamos a explicar las operaciones en **[esta hoja de cálculo](https://spreadsheets.google.com/ccc?key=0AjHcMU3xvtO8dDdZSVhpNXZTaFV0Vk45dlluM0todUE&amp;hl=es)**. Aunque puedes verla aquí arriba te recomiendo que la abras.

En primer lugar el **valor inicial**, columna A. Esta es la variable independiente, sobre la que nosotros actuamos en el programa. Cuando la tensión de red pasa por cero se inicializa TMR0 al valor que tenga esta variable. Y cuando TMR0 se desborda (llega a 255+1) se dispara el triac dejando pasar la corriente hasta que de nuevo pase por cero, momento en que el triac corta.

La frecuencia de reloj es de 4MHz (celda M2), o sea un millón de instrucciones por segundo. TMR0 debería incrementarse en una unidad cada µs, pero como tenemos aplicado un prescaler de 64 (celda M3) lo hace cada 64µs, como aparece en la celda P3.

La **columna B** son los pasos que faltan para llegar desde el valor inicial al desbordamiento. Mientras que la **columna C** es el tiempo en ms que tarda hasta el disparo. Obviamente nunca puede superar los 10ms porque es lo que dura el intervalo entre un paso por cero y el siguiente. Si TMR0 tarda más de 10ms en desbordarse quiere decir que se reiniciará (se le asignará el valor inicial) antes de que le dé tiempo a desbordarse, y por tanto la bombilla permanecerá apagada.

La **D** es la fase de la sinusoide donde se produce el disparo, en fracciones de pi. El semiperíodo va entre 0 y π, porque la onda completa va desde 0 a 2π. No la usamos en más cálculos.

La **columna E** es la tensión eficaz de la sinusoide si la truncamos durante ese tiempo. Uso la expresión que [había calculado antes]({{site.baseurl}}{% post_url 2010-03-29-valor-eficaz-de-una-sinusoidal %}).

La **F** es la potencia de la bombilla, de acuerdo a cómo la calculamos [en esta otra entrada]({{site.baseurl}}{% post_url 2010-03-27-caracteristica-i-v-de-una-bombilla %}). Hay que tener en cuenta que esa caracterización la hicimos para un tipo de bombilla en particular, y que podría no ser válida para otras. Los coeficientes que obtuvimos los he insertado en M9 y M10.

La siguiente **columna F** es la compensación que aplicamos por usar la Ley de Stevens con el coeficiente que hayamos puesto en M12. Esto varía con la bombilla y también con cada persona, así que haced varias pruebas y poned el que más os guste.

Por último **I** es la sensación luminosa expresada en tanto por ciento del máximo que salga. Nos servirá para normalizar el gráfico.

## Curva de respuesta

El resultado es esta curva de respuesta. En el eje X está el **valor inicial del reloj** y en el Y es la sensación luminosa referida al máximo posible.

{% include image.html size="" file="sensacion_luminosa.png" caption="" %}

Fijaos que tiene mucho que ver con la que obtuvimos para la sinusoide. La contribución de la resistencia de la bombilla se nota sobre todo al principio. Y la contribución de Stevens lo que hace es *estirar* hacia arriba la curva. Así la parte del final está más aplastada que la del comienzo. Por lógica tiene que ser así porque ya dijimos que cuanto más intensidad de luz, más se protegen nuestros ojos y más nos cuesta apreciar el cambio.

La parte central tiene la pendiente muy pronunciada, porque es donde más área se concentra en una sinusoide, y un milisegundo de más o de menos en ese tiempo se deja notar mucho en la potencia que entregamos a la bombilla.

*¿Es complicarse mucho para hacer un Dimmer?* Hombre, pues sí, y además teniendo en cuenta que los parámetros cambian con cada bombilla y usuario. Para un aparato comercial claro que no es práctico; sin embargo para un diseño propio yo lo veo interesante.
