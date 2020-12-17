---
assets: /assets/2010/05/preamplificador-microfono-electret
image: /assets/2010/05/preamplificador-microfono-electret/img/alim_dual.png
layout: post
tags:
- Circuitos
- Reciclaje
title: 'Preamplificador micrófono electret: operacional'
---

Viendo las estadísticas del blog me sorprende la cantidad de gente que busca un preamplificador para micrófono. Creo que sería bueno publicar algunas entradas al respecto.

Siempre que necesitemos captar una señal tenemos que cuidar todo el recorrido desde su origen hasta que la registramos. En particular para una señal sonora me refiero a cosas como:

- Un buen **acondicionamiento**, observar las condiciones ideales para generar la señal con el mínimo ruido. Esto incluye por ejemplo una cámara anecoica, o una habitación silenciosa, aislar el sistema de vibraciones mecánicas, etc. Cuando sea posible, utilizando un micrófono direccional impedimos que se capten señales de ruido ambiental. Si captamos ruido en una fase tan temprana será casi imposible eliminarlo luego, así pues buscaremos los medios para que la señal que captemos sea lo más limpia posible.
- Un **micrófono** adecuado. Y no significa *el más caro que haya*. A veces es mejor un micrófono de carbón, otras veces es preferible uno de condensador o un electret. ¿Direccional u omnidireccional? ¿Cual es la impedancia de salida? ¿Y la máxima presión sonora? ¿Preamplificado o no? Si no está bien blindado además podría captar ruido eléctrico que, una vez amplificado, puede enmascarar la señal útil.
- **Conductores blindados**. Hay que poner especial atención a no captar ruido a través de los cables que conectan el micro con el preamplificador, y las distintas etapas entre sí.
- Un **preamplificador** de bajo ruido. Dependiendo del origen de la señal puede que esta sea muy débil y usemos varias etapas amplificadoras en cascada. Es importante minimizar el ruido sobre todo en las primeras para no amplificarlo junto a la señal.
- **Tratamiento posterior**. Ya registremos la señal en un PC o la enviemos a un grabador, amplificador, etc. tal vez tengamos que aplicar distintos filtros. Estos dependen de las características de la señal que nos interese.

En esta entrada hablaré de los preamplificadores, y más concretamente de los basados en operaciones.

<!--more-->

No voy a explicar lo que es un amplificador operacional, si no lo conocéis podéis mirarlo en la [Wikipedia](http://es.wikipedia.org/wiki/Amplificador_operacional) y en alguno de los enlaces externos de tal página.

## Alimentación dual y simple

Primero explicaré cómo se hace la alimentación. Muchas veces para simplificar el diagrama se omite esta parte. Los amplificadores operacionales en general funcionan con tensión dual. Es decir, para alimentarlos tenemos que tener *0*, *+V* y *-V*. Sería algo así:

{% include image.html size="" file="alim_dual.png" caption="" %}

Pero a menudo sólo tenemos una fuente de **alimentación sencilla**, *0*, y *+V*, como una pila. Cuando medimos tensiones siempre fijamos un punto de referencia y puesto que lo que medimos son *diferencias de potencial* el 0 es un punto arbitrario, depende de donde pongamos la punta negra del polímetro medimos una tensión u otra.

El truco para usar operacionales en circuitos que no disponen de tensión dual es crear una *tierra artificial*. Usando un divisor resistivo con dos resistencias de igual valor el nodo intermedio estará justo a la mitad de la tensión de alimentación.

Suponed que tenemos una batería de 9V. Ponemos nuestra referencia, la punta negativa del polímetro, en el borne negativo. Medimos 0V en el hilo negativo, normal, no hay diferencia de potencial entre nuestra referencia y ella misma. Medimos 4.5V en el punto medio, y 9V en el borne positivo de la pila. Ahora cambiamos nuestra referencia y situamos la punta negativa en el punto intermedio. Mediremos -4.5V en el borne negativo de la pila, 0V en el punto de unión y +4.5 en el superior.

{% include image.html size="" file="masa_virtual.png" caption="" %}

Esa será la tensión de referencia que vea el operacional. Cuando usemos una pila de 9V este creerá que lo estamos alimentando con una tensión dual de ±4.5V. El valor de las resistencias no es crítico pues las entradas apenas requieren corriente, basta con que haya una tensión estable. A veces se añaden dos **condensadores** de pequeña capacidad en paralelo con las resistencias, su función es absorber cualquier transitorio; normalmente se pueden eliminar sin problema, y sólo son precisos cuando la alimentación es especialmente ruidosa, como por ejemplo en un coche. Su valor tampoco es crítico, del orden de nanofaradios.

Otra opción para nuestra tierra artificial es usar otro operacional con las entradas unidas. El amplificador de la imagen tiene ambas entradas al **mismo potencial** luego su salida debe ser 0V (con un mínimo *offset*). Pero el operacional cuenta con que está alimentado con tensión dual, su salida será 0 referido a esta tensión dual. Realmente la salida será tal que haya el mismo potencial entre esta y la tensión positiva de alimentación, que entre esta y la tensión negativa. En la práctica eso es justo la mitad de la tensión de alimentación, que es lo que queríamos.

{% include image.html size="small" file="masa_virtual_b.png" caption="" %}

El problema de usar la tierra artificial para la entrada no inversora, es que no está al mismo potencial que la **tierra real**, la que conectamos a la tierra de otros circuitos a la entrada o la salida (como el micrófono o la tarjeta de sonido). En el circuito anterior la tierra artificial (punto medio del divisor) estaba 4.5V por encima de la tierra real (polo negativo de la pila). Es preciso eliminar la componente continua a la entrada y a la salida y dejar sólo la señal alterna. Eso se consigue interponiendo un condensador y se llama **acoplamiento en alterna**.

{% include image.html size="big" file="ac_coupling.png" caption="" %}

El valor de estos condensadores determinará la frecuencia mínima que puede amplificar nuestro circuito, pues actúan como **filtro paso alto**. Si tienen muy poca capacidad las frecuencias bajas serán muy atenuadas. Si son demasiado grandes tendrán pérdidas importantes y tampoco queremos eso. Se suele usar un valor de entre 100nF y 10µF.

## Amplificador inversor

Este tipo de preamplificador es el más utilizado para conectar un micro electret. Es muy fácil de construir. Sus propiedades vienen descritas en muchos sitios, [aquí](http://www.electronicafacil.net/tutoriales/AMPLIFICADOR-INVERSOR.php) por ejemplo.

{% include image.html size="small" file="inversor_crudo.png" caption="" %}

En este esquema podéis ver un típico amplificador inversor de ganancia  Rf / Rin. Si queremos una ganancia muy elevada tenemos dos opciones:

1. Subir la **ganancia de la etapa**. Significa disminuir Rin y aumentar Rf tanto tomo necesitemos. Es muy sencillo de hacer pero las desventajas son múltiples: disminución de la impedancia de entrada, aumento del ruido electrónico (crece con la ganancia), disminución de la banda pasante y es posible que aparezcan autooscilaciones.
1. Añadir otra etapa. Podemos conseguir elevadas ganancias utilizando dos o más etapas **en cascada**. Nos libramos de los inconvenientes anteriores pero a cambio tenemos mayor consumo, un esquema más complicado y una dificultad añadida que es ajustar cada etapa para que no sature a la siguiente.

Se recomienda utilizar un sólo operacional para ganancias menores a ×20 y dos o más etapas de ahí en adelante. Rara vez necesitaremos preamplificar tanto una señal sonora.

{% include image.html size="" file="buffer.png" caption="" %}

En algunos casos se utiliza un [**buffer**](http://es.wikipedia.org/wiki/Amplificador_operacional#Seguidor), que es un amplificador de ganancia 1, es decir no amplifica nada. Su misión es adaptar la impedancia, pues presenta una alta impedancia de entrada, útil para tomar la señal del micro; y una baja impedancia de salida, que puede aplicarse a las siguientes etapas.

## Respuesta en frecuencia

La banda de frecuencias en las que podemos usar nuestro amplificador la perfilan tres factores:

- La resistencia **R1**. Que determina la impedancia de entrada.
- El condensador **C1**. Que junto con la impedancia de entrada forma un filtro pasa-altos. Recortando efectivamente la componente continua, pero también las frecuencias por debajo de la *frecuencia de corte*.
- El **slew-rate** del integrado. Los operacionales incorporan una compensación interna para evitar que oscilen espontáneamente cuando trabajan con mucha ganancia. Esa limitación restringe la velocidad con la que puede variar la tensión de salida, e impone por tanto una frecuencia máxima de trabajo. Esta dependerá de la ganancia y de la amplitud de la señal de entrada.

Así pues tenemos un filtro pasa-altos *(de primer orden)* en la entrada y uno pasa bajos a la salida. Vamos a tomar el circuito siguiente y lo simularemos para obtener un [diagrama de bode](http://es.wikipedia.org/wiki/Diagrama_de_Bode).

{% include image.html size="medium" file="inversor_parabode.png" caption="" %}

Siendo estos los valores:

    R1 =  10k
    R2 = 100k
    C1 = 220nF
    IC = OP90

El OP90 es un operacional caro especialmente adaptado para operar con **poca alimentación**, en nuestro proyecto podemos usar otro de propósito general más barato como el uA741 o el TL081.

{% include image.html size="big" file="bode1.png" caption="" %}

El gráfico está dividido en tres colores. En la zona verde la ganancia es ×10 (o bien 20dB), R2/R1. Hacia la izquierda encontramos la [frecuencia de corte](http://es.wikipedia.org/wiki/Filtro_paso_alto) del filtro C1/R1. Esta comienza cuando la ganancia ya es **3dB menor que a esperada**, en este gráfico está en 72Hz, zona amarilla. A partir de ahí hacia abajo comienza una pendiente de -20dB por década. Hasta llegar a la zona roja que comienza en 7.2Hz. Aquí ya no sólo no hay amplificación alguna, sino que el circuito **atenúa** las frecuencias inferiores. Por la parte derecha las altas frecuencias empiezan decaer a los 27kHz, frecuencia de corte superior, zona amarilla. Es más que suficiente si tenéis en cuenta que no oímos tonos por encima de 20kHz

## Circuito práctico

Después de todo lo anterior, para finalizar os dejo con un ejemplo de preamplificador sencillo para micrófono usando operacionales. He coloreado de rojo la tensión positiva, de negro la *tensión negativa*, en azul lo que sería la tierra artificial y de verde la ruta de la señal.

{% include image.html size="big" file="inversor_ejemplo.png" caption="" %}

    Ganancia: ×10 (20dB)
    Frecuencia de corte inferior: 3Hz

R3 y R4 forman nuestra tierra artificial, que está a la mitad de la tensión de alimentación. R5 es la resistencia de polarización del micrófono electret mientras que C1 y R1 forman un filtro para suprimir la componente continua proveniente de aquel. R2 es la resistencia de realimentación, que determina la ganancia junto a R1. Si necesitáis aumentar o disminuir la ganancia podéis sustituir R2 por un potenciómetro de 200k por ejemplo, mejor que colocar un potenciómetro de volumen a la entrada.

Si necesitáis más amplificación lo mejor es encadenar otra etapa igual a continuación, así tendréis ×100 (40dB). El **LM358** y el **TL082** se usan mucho para esto pues en el mismo encapsulado contienen dos operacionales. Otra opción es cambiar el valor de R2 para que valga 50 ó 100 veces R1.

Siempre que uséis un operacional tenéis que atender a:

- La **tensión de alimentación**. Con fuentes duales no hay problema, pero a la hora de usar fuentes simples recordad que para el operacional es como si se dividiera la tensión por la mitad. Y puede para que no alcance la mínima tensión que recomienda el fabricante. Además mientras menor sea la alimentación, menor la salida, y más fácil es que distorsione la señal.
- El **factor de ruido**. Importantísimo si queremos captar sonidos débiles. El LM358 y el LM741 por ejemplo son muy ruidosos en comparación con el el TL081.
- La **banda pasante**. Hay amplificadores que son más lentos que otros pero a cambio tienen otras propiedades deseables, como baja tensión de alimentación o nivel de ruido. Necesitamos alcanzar un compromiso entre lo que necesitamos por una parte y por otra. Los *datasheets* más habituales se encuentran sin problemas en Internet.

Sin duda me dejo muchas cosas, pero como introducción creo que ya está bien. Iremos aclarando algunos puntos en otras entradas, y como siempre os animo a buscar en Internet lo que no entendáis, todo esto está explicado en mil sitios.
