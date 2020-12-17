---
assets: /assets/2010/12/dimmer-controlado-por-mando-distancia
image: /assets/2010/12/dimmer-controlado-por-mando-distancia/img/esquema_dimmerIr.png
layout: post
tags:
- Circuitos
- PIC
- Sensores
title: 'Dimmer controlado por mando a distancia: el hardware'
---

A este proyecto le he dedicado otras entradas en el blog. Se trata de diseñar y construir un circuito para regular la **intensidad de luz** de una lámpara utilizando un mando a distancia.

- Para lo cual necesitamos saber cómo recibir e interpretar la señal de un **mando a distancia**. Por ejemplo uno del tipo NEC ([Receptor con PIC para mandos infrarrojos tipo NEC]({{site.baseurl}}{% post_url 2010-05-07-receptor-con-pic-para-mandos %})).
- Además queríamos que la intensidad de luz fuera en **cambios graduales**, con lo que tenemos que tener en cuenta cómo percibimos las variaciones con la vista ([Curva de respuesta del Dimmer IR]({{site.baseurl}}{% post_url 2010-06-23-curva-de-respuesta-del-dimmer-ir %})).
- Y, a su vez, para conseguir esa curva es preciso saber cómo varía la tensión en función de la parte del periodo en la que disparemos el triac ([Valor eficaz de una sinusoidal incompleta]({{site.baseurl}}{% post_url 2010-03-29-valor-eficaz-de-una-sinusoidal %}))
- y cómo reacciona una bombilla ([Característica V/I de una bombilla]({{site.baseurl}}{% post_url 2010-03-27-caracteristica-i-v-de-una-bombilla %})).

Hoy voy a presentaros el hardware. Para que luego sea más fácil entender el software. He aquí el esquema:

{% include image.html size="big" file="esquema_dimmerIr.png" caption="" %}

No difiere mucho de los esquemas que encontraréis en otras páginas. Como cabe esperar el corazón del circuito es el **microcontrolador** que se ve a la derecha. Yo he usado un **12F683** porque es el que tengo para las pruebas pero vosotros podeis usar otros modelos si lo preferís. Para examinar el esquema lo dividimos en cinco partes.

## Microcontrolador

No es necesario escribir mucho sobre esta parte.

Se trata del PIC IC1, es el cerebro y a él van conectadas el resto de elementos. Sí es interesante que tenga bajo consumo para no sobrecargar la fuente de alimentación. También conviene contar con un par de **temporizadores** para hacer más sencilla la rutina de recepción NEC.

## Fuente de alimentación

Si queremos que el circuito sea lo más sencillo posible no podemos contar con una fuente de alimentación completa, ni con transformador ni conmunatada. Además se supone que el consumo va a ser muy bajo así que nos decantamos por una fuente de alimentación **sin transformador**. En inglés se conoce como *Transformerless Power Supply* y encontraréis abundante información y esquemas en Google. Por mi parte os recomiendo esta Nota de Aplicación de Microchip: *[Transformerless Power Supplies: Resistive and Capacitive]({{page.assets | relative_url}}/00954A.pdf)*.

Hablamos de **R1, R4, R5, R7, D1, D2, C1, C2** y **C3**. Vamos a entender brevemente cuál es la función de cada componente.

La tensión de red (220V 50Hz en España) se aplica a los terminales **X1-1** y **X1-2**. **R5** es un fusible que protege al resto por si hubiera un cortocircuito interno.

**C1** es el corazón de esta parte. Se trata de un condensador **de tipo X2**. Eso significa dos cosas, por un lado que está dimensionado para la tensión de red entre 150V y 250V AC. Y por otro que ante un fallo el condensador queda **abierto**. Otros modelos pueden fallar y quedar los terminales **en corto**, aplicando la tensión de red a todo el circuito. Cuando trabajamos con doce voltios nos da igual, pero con 220V hay que cuidar estos detalles o nos podemos llevar una buena hostia. Como dicen en la nota anterior: *"si el condensador queda en corto puede reventar algo... literalmente"*.

**R1** limita la intensidad que pasa por **C1** cuando este se encuentra descargado al suministrar tensión. Y otro elemento de protección es **R4** que garantiza que el condensador no se quede cargado cuando desenchufemos el circuito. Un condensador cargado a **220V** da sustos muy desagradables. Es habitual cuando cargamos condensadores a esas tensiones no dejarlos **cargados**, ya lo vimos también en [esta entrada]({{site.baseurl}}{% post_url 2010-06-01-matamoscas-electronico-flyback %}).

Para la tensión alterna **C1** representa una resistencia, más baja cuanto mayor su capacidad, sólo que a diferencia de una resistencia **C1** no disipa calor (ni consume). El diodo zener **D1** estabiliza la tensión en 5V que nos viene estupendamente para alimentar el PIC. **D2**, **C2** y **C3** forman un rectificador de media onda, que es apropiado sólo para bajos consumos.

Mientras que **C2** es un condensador **electrolítico** que elimina el rizado de alterna, **C3** es un condensador **de poliester**, de menor capacidad pero de reacción mucho **más rápida**. Nos suministrará los picos de corriente necesarios por ejemplo para disparar el optotriac sin afectar al voltaje de alimentación del resto del circuito.

**R7** es un varistor que deriva los picos de la red que excedan cierto voltaje para que no lleguen al circuito. Es opcional aunque muy recomendable.

## Sensor de paso por cero

Una vez tenemos el PIC alimentado necesitamos saber cuando la tensión de red pasa por cero para disparar el triac con un retardo acorde con la energía que queramos.

Mirad el datasheet de un PIC como el 12F683 y fijaos cómo son por dentro las entradas de tipo IO *entrada/salida*:

{% include image.html size="small" file="entrada.png" caption="" %}

La imagen no está sacada del datasheet, sino de esta **Nota de Aplicación** donde viene más simplificado: [Interfacing to AC Power Lines]({{page.assets | relative_url}}/00521c.pdf). El caso es que tienen dos diodos limitadores. Lo que quiere decir que aunque apliquemos 220V directamente al pin del PIC **no se dañará** siempre y cuando limitemos la intensidad. **R2** es una resistencia de un valor muy elevado, suficiente para elevar la tensión hasta nivel alto, pero con una intensidad muy baja para no destruir los diodos. La tensión en el puerto GP2 oscilará entre 0 cuando la tensión de red pase por el semiciclo negativo hasta 5V como máximo en el semiciclo positivo. En cualquiera de las dos transiciones sabemos que la tensión acaba de pasar o va a pasar inmediatamente por cero.

Conviene utilizar una entrada de tipo *Schmitt trigger* (ST) para que la transición sea limpia. De lo contrario los transitorios producidos por el encendido de motores y electrodomésticos pueden causar que el circuito conmute varias veces antes de tiempo y por tanto que no funcione bien.

## Disparador

Aunque veréis muchos esquemas que utilizan un triac de baja corriente de disparo (*[Logic level and sensitive gate triacs](http://www.nxp.com/documents/application_note/FS067.pdf)*) aquí he usado un circuito clásico de triac-optotriac. Es cuestión de gustos, a mi personalmente no me gusta excitar directamente el triac con el micro, y menos aún cuando la fuente no está aislada eléctricamente como sí lo estaría si usásemos una fuente con transformador. Creo en el aislamiento galvánico y los optoacopladores me parecen la mejor opción; pero esto, repito, es solamente mi opinión personal y no quiero decir que de la otra forma no sea igual de válido.

En cuanto al optotriac, hay dos tipos: con detección de paso por cero y sin ella.

En lo que tienen detección de cruce por cero los más comunes son los modelos MOC30XY, donde X indica la máxima tensión nominal:

    MOC 3041 -> 400V
    MOC 3061 -> 600V
    MOC 3081 -> 800V

y la Y indica la corriente que necesita el LED para garantizar el disparo:

    MOC 3040 -> 30mA (no existen todos los modelos)
    MOC 3041 -> 15mA
    MOC 3042 -> 10mA
    MOC 3043 ->   5mA

Aunque en el esquema está puesto como tal, **no nos interesa** un optotriac con detección de paso por cero. Pues no nos permitiría hacer el disparo cuando nosotros queramos. Así que será mejor emplear otros integrados como el MOC3020 o el MOC3030 que no incorporan esa característica. Los primeros son muy importantes para hacer una intermitencia o en general un control de encendido/apagado (por tiempo, por temperatura, etc) pero no precisamente un dimmer.

Además como el disparo lo vamos a hacer con un microcontrolador no es preciso que sea del modelo sensible (los acabados en 3) porque lo que haremos será enviar un **pulso muy breve**, que será suficiente para encender el triac pero al durar muy poco tiempo no agotará el condensador de la fuente de alimentación. La cosa sería muy distinta si en lugar de un PIC hiciésemos una intermitencia utilizando un *timer* como por ejemplo un 555 que deja la salida a nivel alto durante todo el periodo que dure la luz encendida.

El TRIAC puede ser cualquiera siempre y cuando soporte la tensión de la red y la carga que vayáis a usar. En este caso al ser una lámpara la carga es resistiva pura, pero si queréis controlar un motor tened cuidado que la cosa se vuelve compleja.

## Conectores auxiliares

Son dos, el primero, indicado como SL1 es a donde va conectado el módulo receptor de **infrarrojos** (hemos hablado de él en otras entradas), y será el que reciba la señal del mando.

Para terminar he incorporado un conector externo que no he usado pero podría venir bien por ejemplo para conectar un LED y que el dimmer se regule automáticamente con la luz ambiente. Mirad esta entrada para ver como se hace un **sensor** utilizando un simple LED: [Sensor óptico sencillo con amplio rango dinámico]({{site.baseurl}}{% post_url 2010-09-08-sensor-optico-sencillo-con-amplio-rango %}). En su momento yo usaba esta patilla para depuración conectándola al puerto serie.

Lo bueno de usar microcontroladores es que el circuito es muy simple y siempre se puede ampliar por software. Así que si os sobra un puerto no lo dejéis sin conectar porque el día de mañana se os puede ocurrir una utilidad para él. Si ya tenéis el conector sólo os hace falta reprogramar el chip y no tenéis que hacer otra placa.

## Montaje

Esta es la PCB con las pistas vistas por el lado de cobre:

{% include image.html size="medium" file="pistas1.png" caption="" %}

{% include image.html size="medium" file="pistas2.png" caption="" %}

Y así es como quedaría el circuito ya montado:

{% include image.html size="big" file="BENQ0008.JPG" caption="" %}

Observad que el condensador **C1** no es de **47nF** sino de **100nF**. En realidad con un consumo tan bajo no es crítico, eso sí cuanta mayor capacidad más margen de maniobra tendremos.

## Conexión del circuito

La tensión de red va conectada a la clema gris de la izquierda. El terminal del **centro es común**, el de **abajo es la entrada** de la tensión y el de **arriba es la salida** hacia la bombilla.

A la derecha está el conector de tres pines a donde va conectado el módulo IR. Se hace así para que el circuito pueda estar **escondido** y tan sólo quede expuesto el receptor.

Se trata de un circuito lo suficientemente pequeño como para que quepa dentro del plafón o de la caja de registro más cercana.

Por último os dejo los esquemas (para Eagle), las imágenes y un PDF con las pistas en [este enlace]({{page.assets | relative_url}}/dimmerIR_hw.rar).

El software está publicado [en esta entrada]({{site.baseurl}}{% post_url 2011-02-02-dimmer-controlado-por-mando-distancia %}).
