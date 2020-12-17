---
assets: /assets/2010/06/matamoscas-electronico-flyback
image: /assets/2010/06/matamoscas-electronico-flyback/img/friemosquitos.png
layout: post
tags:
- Circuitos
- Reciclaje
title: 'Matamoscas eléctrónico: flyback'
---

Hace unas semanas pedí por correo un aparato poco común en España, o por lo menos yo no lo he visto nunca. El caso es que lo pedí por curiosidad y porque costaba 4€. Se trata de un [matamoscas electrónico](http://www.1freeaday.com/page.php?file=product&amp;id=10006731), y se supone que fríe a los insectos con una descarga. Es parecido una raqueta de tenis, pero tiene tres niveles de malla. Las dos mallas exteriores tiene unos huecos grandes para permitir el paso del bicho hacia la malla interior, que es de un mallado mucho más tupido. En cuanto la víctima toca ambas mallas recibe una descarga de más de 600V.

La pregunta es ¿cómo obtiene 600V si se alimenta con dos pilas de 1.5V? Creo que no tardé ni diez minutos en desmontarlo. Veamos cómo funciona.

<!--more-->

No es el único ejemplo de circuitos que obtienen alta tensión a partir de pilas, pensad en el circuito del flash de una cámara de fotos, la fuente de alta tensión para retroiluminación, el tubo fluorescente de un alumbrado de emergencia, una televisión portátil, un encendedor electrónico, un táser, etc.

Hay varios métodos para elevar la tensión de una batería hasta los 600V. En este caso se utiliza lo que se llama un **flyback**.

## El transformador flyback

Un transformador normal se diseña para que la transferencia de energía desde el primario al secundario sea óptima. Eso nos garantiza un buen rendimiento. Y esto se hace pensando en que la corriente que aplicamos al primario es sinusoidal pura, como lo es la tensión de 220V / 50Hz (110V / 60Hz) que tenemos en casa, y también los 30kV de los cables de media y alta tensión.

Si alimentamos un transformador normal con una onda que no es pura, por ejemplo una onda cuadrada, esta tiene armónicos; frecuencias espurias más allá de los 50Hz para las que no está diseñado, y se traduce en pérdidas y calor. Pero lo que es peor, tiene cambios bruscos de 0 al 100% de golpe y viceversa.

Un **flyback** está precisamente diseñado para funcionar en esas condiciones. No está optimizado para transferir energía sino para acumular un campo magnético muy fuerte en su núcleo. Se trata de alimentar el primario a golpes, crear el campo magnético y de repente cortar la corriente lo más rápido posible para que se induzca un campo enorme y se transfiera al secundario.

Como el campo magnético es más fuerte cuanto más rápido sea el cambio de la corriente, el resultado es que en el secundario pueden inducirse **miles de voltios**. Aún cuando la tensión en el primario sea pequeña, lo que importa es el cambio brusco.

No quiero extenderme en esto, podéis encontrar **más información** en los enlaces del final.

## El circuito

Tengo que reconocer, por loco que parezca, que me hizo *cierta ilusión* descubrir que el circuito del matamoscas es un viejo conocido. Algo similar a si te encontraras con una sabia persona que sólo conoces de oídas. Este circuito sabes que existe, porque lo has leído en libros, pero también sabes que es *tan antiguo como la propia electrónica*, porque fue de los primeros osciladores que se utilizaron. Es uno de estos circuitos que sorprenden por su simplicidad, como aficionado lo has construido para experimentar, pero nunca esperas encontrarlo en un invento comercial.

El esquema es el siguiente:

{% include image.html size="big" file="friemosquitos.png" caption="" %}

    R1: 470Ω
    R2: 470Ω
    R3: 15MΩ
    C1: 270nF
    D1: LED rojo
    D2: (ver texto)*
    Q1: 2SD1616
    T1: (ver texto)*

Se trata nada más (y nada menos) que de un oscilador de bloqueo ([*blocking oscillator*](http://en.wikipedia.org/wiki/Blocking_oscillator)), o más bien una ligera modificación de este. Es el circuito típico para excitar un flyback.

1. El transistor Q1 está en principio apagado.
1. Cuando se pulsa el interruptor la corriente circula desde la batería hacia la resistencia R2, atraviesa la bobina de feedback y llega hasta la base del transistor.
1. Q1 con el colector en negativo y la base en positivo se activa y conduce, y al conducir mete corriente al primario.
1. La corriente inducida en el primario genera una tensión en el secundario, que aprovecharemos después. Pero a la vez induce corriente de signo contrario en el devanado de realimentación *feedback*.
1. Tal corriente inducida llega a la base de Q1, apagándolo inmediatamente.
1. Q1 se apaga y corta la alimentación al primario.
1. Tal corte de alimentación induce de nuevo sendas corrientes de signo contrario en el secundario y en la realimentación.
1. La corriente inducida en el feedback llega a la base de Q1 y lo activa. Llegando de nuevo al paso 3.
1. Este ciclo de repite una y otra vez hasta que se libera el pulsador.

Como las oscilaciones se suceden a la frecuencia de resonancia natural del transformador el rendimiento es relativamente bueno. En cuanto al transistor, tiene que aguantar un pico de tensión inversa en su base bastante elevado, y algunos modelos se fríen al poco tiempo. Esa es la característica principal, por lo demás es bueno que tenga un tiempo de *fall-off* lo más corto posible y por supuesto que soporte la corriente E-C requerida por el primario.

La tensión inducida en el secundario se recoge por medio del **diodo D2**. Cuya referencia no es legible, pero supongo que se trata de un rectificador rápido capaz de aguantar más de 1000V de tensión inversa. Un simple 1N4001 o un 4148 sirven igualmente, aunque si es posible usaremos rectificadores diseñados para trabajar con alta frecuencia. Este diodo actúa como paso de un sólo sentido para cargar el condensador C1 e impedir que se descargue.

Una vez cargado, el condensador puede ser peligroso durante semanas. Para evitar eso está la resistencia **R3**. Cuando desactivamos el circuito, C1 se descarga lentamente a través de ella hasta perder su potencial en unos segundos.

Por último, R1 y D1 sirven para indicar que el circuito está en funcionamiento.

En los terminales de C1 se llega fácilmente a los 600V, un condensador de 270nF cargado a esa tensión ofrece una sacudida *inocua* (no siempre) pero muy desagradable. Para un insecto de pequeño tamaño como una mosca, un mosquito y en general pequeños voladores resulta fatal.

## Peligrosidad de una descarga

Os puedo asegurar que si sentís una descarga no querréis repetir. Sin embargo para los humanos, por dolorosa que sea la sensación, **no implica daño** permanente en los tejidos. La energía que acumula C1 es pequeña; eso significa que recibiremos 600V durante un tiempo muy corto, cortísimo. Tal energía se puede calcular así:

$$
W_C = {1 \over 2} C V^2
$$

donde *C* es la capacidad y *V* la tensión. Para nuestro matamoscas (270nF, 600V) esa energía acumulada es de 0.05J aproximadamente. Muy poca para causar algún daño a menos que se aplique de forma muy localizada.

En cambio, el flash de una cámara fotográfica tiene un condensador de 250µF que se carga nada menos que a 300V. Eso son 11.25J acumulados, suficiente para que acabéis con una tirita en el dedo. Fijaos además que la energía crece con el cuadrado de la tensión, el flyback de un televisor arroja **30.000V**. Por poca energía que pueda acumular el condensador que forman pantalla y masa, la ostia os puede llevar a urgencias.

Así que mucho cuidado al desmontar cámaras con flash, televisores y otros aparatos que trabajen por dentro con tensiones elevadas. Ya sabéis que el que funcionen con pilas o baterías no es ninguna garantía, tener siempre a mano alguna herramienta para cortocircuitar los condensadores sospechosos y mucho ojo dónde tocáis.

Por último, las bromas y juegos que implican descargas tienen [este mismo principio]({{site.baseurl}}{% post_url 2010-10-06-bromas-de-alta-tension %}), pero al no utilizar condensador no suponen el peligro anterior.

Os dejo estos enlaces donde podéis encontrar información sobre flybacks, hay muchos más buscando un poco en Internet.

[http://madlabs.info/flyback.shtml](http://madlabs.info/flyback.shtml)

[http://www.powerlabs.org/flybackdriver.htm](http://www.powerlabs.org/flybackdriver.htm)

Los archivos utilizados para hacer esta entrada están disponibles en [este enlace]({{page.assets | relative_url}}/friemosquitos.rar).
