---
assets: /assets/2013/04/mezclador-de-frecuencias-con-el
image: /assets/2013/04/mezclador-de-frecuencias-con-el/img/mixer1_sch_t.png
layout: post
tags:
- Circuitos
- Sonido
title: Mezclador de frecuencias con el integrado 4066
---

Hoy describimos un circuito **mezclador** o multiplicador de frecuencias. Un circuito relativamente ignorado por muchos aficionados a la electrónica pero muy importante. Tan importante que es una parte fundamental de casi todos los receptores de radio (incluyendo radios, televisores, conversores de satélite, walkie-talkies, etc): [receptor heterodino](http://ayudaelectronica.com/concepto-receptor-heterodino/) .

La finalidad de estos esquemas es tomar una señal de entrada -cuya portadora estará en una frecuencia elevada- y multiplicarla por una señal proveniente del oscilador local -cuya frecuencia podemos variar fácilmente-. De forma que al multiplicar dos frecuencias, como ya vimos en la entrada anterior [La Distorsión Armónica Total (THD)]({{site.baseurl}}{% post_url 2013-03-26-la-distorsion-armonica-total-thd %}), el resultado son otras dos frecuencias: la suma y diferencia de las anteriores.

Vamos a utilizar este circuito, no para hacer un receptor de RF, sino para un propósito más sencillo: poder captar con la tarjeta de sonido señales por encima de 20KHz que es el límite ultrasónico.

<!--more-->

## El límite ultrasónico

Las tarjetas de sonido convencionales muestrean, como máximo, a 44 o 48kHz. Eso **no** quiere decir que la mayor frecuencia que pueden captar sea de 22kHz. En realidad pueden captar señales de mucha mayor frecuencia, que aparecerán "plegadas" a la mitad de la de muestreo. Si no sabéis de qué hablo consultad *Teorema de Nyquist* y *Efecto aliasing* en este enlace de la Wikipedia: [Frecuencia de muestreo](http://es.wikipedia.org/wiki/Frecuencia_de_muestreo).

Lo que ocurre es que la reconstrucción de la forma de onda que podemos hacer pasado el límite de Nyquist es peor cuanto más nos alejamos. Y para evitar eso mismo todas las tarjetas de sonido incorporan un filtro pasa-bajos que atenúa las frecuencias para las que no está preparada.

Lo que vamos a hacer con este mezclador es llevar las señales de frecuencia superior a nuestra *banda base*, que es audio. Dicho de otra forma, vamos a recoger ultrasonidos. O bueno, no sólo ultrasonidos, porque la banda de frecuencias que podemos explorar dependerá de la frecuencia del oscilador local. Pues se trata simplemente de un receptor por [Conversión Directa](http://www.solred.com.ar/lu6etj/tecnicos/convdir/conv_dir.htm), que es tan antiguo como la radio misma.

Pero de momento este circuito, así tal cual, no es más que un sencillo mezclador para ultrasonidos.

## Esquema eléctrico

Hay varios tipos de mezclador. De hecho casi cualquier cosa menos una resistencia puede convertirse en un mezclador aunque no queramos.

Como lo que queremos es multiplicar dos frecuencias hemos optado por la solución más radical: un interruptor que se abre o se cierra a la frecuencia que decidamos y deja pasar o no la señal de entrada. Más adelante entramos en detalle. Vamos por partes.

El circuito que os presento es el siguiente. He coloreado las partes que lo componen y así será más sencillo seguir la explicación. Haced click en cualquier imagen o abridla en una ventana nueva para verla ampliada.

{% include image.html size="big" file="mixer1_sch_t.png" caption="" %}

Consta de cinco secciones:

- En **violeta**, izquierda arriba, el preamplificador de entrada.
- En **amarillo**, izquierda medio, la alimentación.
- En **verde**, izquierda abajo, el oscilador local.
- En **rojo**, derecha arriba, el mezclador.
- En **azul**, derecha abajo, el amplificador de salida.

Se podría considerar que el amplificador de salida forma parte también del circuito mezclador, pero lo separo por simplicidad.

## Alimentación (amarillo)

La tensión de alimentación se conecta a **SL1**. El circuito funciona sin problemas con tensiones entre los 5 y los 15V. Pero con un inconveniente, y es que la frecuencia dependerá de la tensión. Ya hablaremos de esto más adelante en el apartado dedicado al oscilador.

**R12** y **R13**, junto a **C8** forman una **masa virtual** o **tierra virtual** que nos sirve para alimentar los operacionales con una fuente de tensión simple. Ya vimos estos circuitos en la entrada llamada [Preamplificador micrófono electret: operacional]({{site.baseurl}}{% post_url 2010-05-28-preamplificador-microfono-electret %}).

## Preamplificador de entrada (violeta)

A menudo se utilizan estos circuitos para captar frecuencias ultrasónicas tal como los radares de los murciélagos. Un micrófono electret no sirve para estas frecuencias, por lo que se utiliza un micrófono piezoeléctrico (o un zumbador piezoeléctrico reutilizado como micrófono). Lo peor de los micrófonos piezoeléctricos es que tienen una **impedancia de salida** altísima, del orden de los megaohmios. Y cómo la apliquemos a un preamplificador de baja impedancia se nos va a atenuar tanto que más que amplificar, perderemos señal.

{% include image.html size="big" file="entradanoinversor.png" caption="" %}

En este esquema aparte vemos cómo la impedancia de la fuente Rs y la impedancia de entrada del preamplificador, prácticamente **R4**, forman un divisor resistivo. De manera que si aplicáramos una fuente con una impedancia muy alta, a un preamplificador de muy baja impedancia la señal quedaría tan atenuada que no oiríamos nada. Y por tanto necesitaremos un amplificador con una impedancia de entrada lo más alta posible.

**Nota** para radioaficionados y telecos: En radio la longitud de onda es comparable con la longitud de la línea de transmisión y por tanto debemos adaptar impedancias para transmitir la mayor **potencia** posible hacia o desde la antena. Si no lo hiciéramos así podríamos desde perder señal, y hasta freír el transmisor por estacionarias. Pero en audio no es tan estricto; porque buscamos **maximizar la tensión** a la entrada y no la potencia transferida. Así que lo que se hace es que las entradas tengan impedancias altas (unos 100kΩ) y las salidas impedancias medias (50kΩ) salvo en casos concretos, por ejemplo la salida de un amplificador hacia el altavoz.

Dicho esto, **IC1A** está configurado como **no inversor** lo que nos da una alta impedancia de entrada, sólo limitada por **R4**. Con esta configuración, si conectáramos una fuente con una baja impedancia de salida también funcionaría. Lo malo es que junto al sonido captaremos todo el **ruido de fondo** que se acople ayudado por la alta impedancia de entrada del preamplificador.

**C1** se necesita para adaptar los niveles de tensión dado que la referencia de **IC1A** es la masa virtual, mientras que la señal de entrada la aplicamos con referencia a la masa real del circuito.

Como ya sabéis, la amplificación viene determinada por **R2** y **R3**. En nuestro caso es de 34dB, lo que quiere decir que amplificará 50 veces la entrada.

**R1** está pensada para alimentar un micrófono electret, pero si queremos alimentar cualquier otro circuito desde el conector de entrada, no hay más que sustituirla por un simple puente.

Otro parámetro al que tenemos que prestar especial atención cuando diseñamos un amplificador es el producto [**ganancia - ancho de banda**](https://en.wikipedia.org/wiki/Gain%E2%80%93bandwidth_product). Que no es otra cosa que "a mayor ganancia, menor banda pasante". Es un parámetro típico, aunque no exclusivo, de los circuitos con operacionales.

{% include image.html size="medium" file="gbp.gif" caption="" %}

Aquí los valores de **C1** y **R4** tienen un papel decisivo, pues forman un filtro paso-alto que desplaza el comienzo de la banda pasante hacia frecuencias mayores. Así, en lugar de amplificar frecuencias entre 0 y 10kHz, por ejemplo, amplificaríamos entre 20 y 30kHz que nos interesan más.

Con los valores dados sirve para frecuencias entre los 15kHz y 95kHz.

Tras ser amplificada, la salida se lleva al mezclador.

## Oscilador local (verde)

Para generar la frecuencia local vamos a emplear el VCO del **CD4066**, que en realidad es un [PLL](http://es.wikipedia.org/wiki/Lazo_de_seguimiento_de_fase) pero se utiliza mucho sólo de oscilador. El rango de frecuencias nos dará las frecuencias que podremos explorar con este circuito.

La configuración no es nada complicada: **R11** y **C7** deciden la frecuencia máxima (o la frecuencia central Fo). A continuación, variando la tensión en la patilla 9, se varía la frecuencia de salida entre Fo y 2Fo. Si queremos imponer restricciones en el margen inferior insertaremos una resistencia en serie con la masa del conector **SL5** o bien colocaremos una resistencia a masa en la patilla 12 del integrado. Si no hacemos ninguna de las dos cosas, la frecuencia mínima será próxima a 0... y no queremos eso.

**R11** y **C7** se calculan usando unas tablas que vienen en el datasheet. Por ejemplo, para una resistencia **R11** de 10kohm y una tensión de alimentación de 8 o 9V el valor de **C7** tiene que ser del orden de 1nF. ¿Veis ahora por qué decía antes que la frecuencia depende de la tensión de alimentación?

{% include image.html size="medium" file="calculo_rc.png" caption="" %}

La salida del oscilador será la que controle el mezclador.

## Mezclador (rojo)

Siguiendo lo que dijimos al principio, todo se trata de multiplicar dos señales. Para multiplicarlas, bien podríamos utilizar el segundo orden de cualquier componente no lineal. Pero la forma más directa es la que aplicamos aquí: **un interruptor**.

El integrado **IC2** es un sencillo [CD4066](http://www.natalnet.br/~aroca/afron/CD4066BC.pdf) que contiene 4 interruptores analógicos.

{% include image.html size="medium" file="cd4066.png" caption="" %}

La señal de entrada preamplificada se aplica a la los interruptores C y D. Mientras que la señal del oscilador local que viene de **IC3** la aplicamos a los pines de control que abren o cierran estos interruptores.

En el caso de **IC2C** le aplicamos la señal de control tal cual. Sin embargo a **IC2D** le aplicamos la señal invertida. Luego cuando la señal del VCO está a nivel alto conducirá **IC2C** mientras que cuando pase a nivel bajo lo hará **IC2D**.

¿Qué conseguimos abriendo y cerrando los interruptores? Pues "cortar" la señal cada cierto tiempo. A efectos teóricos la multiplicamos, pero en la práctica lo que está ocurriendo es esto (abrid la imagen en otra ventana para ampliar):

{% include image.html size="big" file="out4kHz_t.png" caption="" %}

Para hacer este gráfico hemos aplicado dos frecuencias separadas por 4kHz. La **diferencia de fase** de ambas señales, **integrada** por los condensadores **C3** y **C6** a la entrada del amplificador de salida, nos da la frecuencia resultante.

## Amplificador de salida (azul)

Tras la conversión, la señal se filtra por los condensadores **C3** y **C6** como ya hemos dicho y se recompone en el último paso del circuito: un amplificador diferencial cuyo núcleo es **IC1B**.

Es el paso lógico puesto que uno de los interruptores conduce durante el semiciclo positivo de la señal de control y el otro durante el negativo. De esta manera recomponemos una señal simétrica.

Recordad que en los amplificadores diferenciales **R5** tiene que ser igual a **R8**, **R6** igual a **R9** y la ganancia viene dada por **R6**/**R5**. Aproximadamente 2.

A la salida de **IC1B** colocamos un **filtro pasa-banda** formado por **R7**, **C4** y **C5**. Este corta a una frecuencia inferior de 350Hz, con la intención de suprimir la tensión continua y el ruido. Y a una frecuencia superior de unos 5kHz para eliminar los residuos de mezclado y la frecuencia imagen. Es bueno que cortemos en una frecuencia relativamente baja ya que, como avisamos al empezar, las tarjetas de sonido pueden captar señales por encima de 20kHz si están mal filtradas y estas causarán interferencias que no podremos separar de la señal real. Esta banda, además, coincide con la máxima sensibilidad de las tarjetas de sonido.

{% include image.html size="big" file="filtrosalida.png" caption="" %}

## Funcionamiento

Lo siguiente es un espectro en el que vemos el circuito sintonizado en 50kHz. La señal del oscilador local Vclk en azul. La amplitud es mucho más de 200mV, se sale del gráfico. Como es de esperar la amplitud a 0Hz no es 0. Porque se tata de una señal cuadrada que oscila entre 0 y 9V. Y por tanto no es simétrica.

Si aplicamos a la entrada una señal de 54kHz, en verde de unos 75mV en la salida obtendremos una frecuencia de 4kHz (en rojo) y con una amplitud un poco mayor gracias al preamplificador de salida.

{% include image.html size="big" file="fft4kHz.png" caption="" %}

Con este circuito ya podemos explorar con la tarjeta de sonido las frecuencias no audibles. Ahora todo depende de lo que conectemos a la entrada:

- Si conectamos una antena de ferrita y una etapa de entrada a FET tendremos un receptor VLF. He intentado recibir la señal [DCF77](http://es.wikipedia.org/wiki/DCF77), que emite en 77.5kHz pero no he podido.
- Si conectamos un micrófono piezoeléctrico será un captador de ultrasonidos.
- Si conectamos una bobina y un circuito LC sintonizado "escucharemos" la resonancia electromagnética al igual que hicimos con la resonancia mecánica en esta otra entrada: [Resonancia mecánica con copas II]({{site.baseurl}}{% post_url 2010-08-25-resonancia-mecanica-con-copas-ii %}).

Una vez terminado, la placa nos queda más o menos así. Digo más o menos porque esta foto es de una versión anterior y he cambiado algunos componentes.

{% include image.html size="medium" file="IMAG0415.jpg" caption="" %}

En [este enlace]({{page.assets | relative_url}}/mixer4066.zip) tenéis algunos archivos interesantes, incluyendo los gráficos y los archivos de Eagle (version 6) para el esquema y la PCB.
