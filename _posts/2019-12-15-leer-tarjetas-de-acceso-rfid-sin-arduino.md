---
assets: /assets/2019/12/leer-tarjetas-de-acceso-rfid-sin-arduino
featured: 'true'
image: /assets/2019/12/leer-tarjetas-de-acceso-rfid-sin-arduino/img/fob_foto.jpg
layout: post
tags:
- Binario
- Circuitos
- Fisica
- Radio
title: Leer tarjetas de acceso RFID, sin Arduino
---

Hoy comenzaremos hablando de osciladores, palos de bambú y géiseres y terminaremos hablando de seguridad física. Porque ¿sabes que las cocinas de inducción, los cargadores inalámbricos y algunos antirrobos se basan en el mismo principio que los tornos de entrada al trabajo?

Vamos a ver cómo funcionan las tarjetas identificativas de proximidad de baja frecuencia -comúnmente llamadas RFID-. Pero antes de llegar hasta ahí, recorreremos un camino para entenderlo mejor. Hoy os traigo *experimentos con bobinas*.

Empezaremos por construir un oscilador muy sencillo, al que añadiremos un buffer y una etapa de salida a transistores. Con él excitaremos un circuito resonante LC y haremos algunas pruebas. Por último, leeremos un dispositivo RFID y, como *bonus track*, decodificaremos el protocolo de una tarjeta no estándar usando ingeniería inversa digital.

En su día ya dedicamos un artículo a [Las oscilaciones amortiguadas]({{site.baseurl}}{% post_url 2011-05-18-el-circuito-rlc-serie-oscilaciones %}). Este lo vamos a dedicar a las oscilaciones forzadas y uno de sus usos más habituales en nuestro día a día.

{% include image.html size="small" file="fob_foto.jpg" caption="Llave de acceso RFID a 125kHz. EyC." %}

<!--more-->

## El oscilador

Lo primero que necesitamos es un oscilador. ¿Podríamos haber usado un generador de funciones? Sí, por supuesto, pero este es un blog de electrónica a bajo nivel. Para leer una tarjeta RFID también se puede usar un lector con un Arduino o una Raspberry y dejarnos de historias.

Como decía, para hacer el oscilador quería un circuito muy sencillo y fácil de construir. Hay muchas opciones. En esta ocasión he optado por un oscilador de **relajación** usando comparadores LM393 ([datasheet]({{page.assets | relative_url}}/lm2903-n.pdf)). Se trata de un comparador muy habitual y, si miráis el datasheet, su tiempo de respuesta es de 300ns, así que nos servirá para oscilar hasta pasado el MHz si hiciera falta.

A propósito, los osciladores de relajación se llaman así porque van acumulando tensión lentamente hasta que se desahogan. Ejemplos típicos son los géiseres, o la fuente esa japonesa con un [ palo hueco de bambú que sube y baja](https://en.wikipedia.org/wiki/Shishi-odoshi) (*Shishi-odoshi*). Al principio están en un estado en el que acumulan energía (presión, agua o carga eléctrica). Con el tiempo se va incrementando la tensión hasta que -en un momento dado- superan cierto umbral y descargan. La descarga suele ser rápida y tras ella vuelven a su estado anterior.

{% include image.html size="" file="Shishi-odoshi.jpg" caption="El Shishi-odoshi es el ejemplo típico de oscilador de relajación. [Wikipedia.](https://en.wikipedia.org/wiki/Shishi-odoshi) " %}

A estas alturas ya todos sabéis cómo funciona un comparador. Tiene dos entradas y una salida. Está continuamente comprobando cuál de las dos entradas está a mayor voltaje. Si gana la entrada inversora (signo -), la salida del conmutador está a nivel bajo; conectada a masa. Mientras que si gana la entrada no inversora (signo +), la salida queda **flotante**. No positiva, porque la salida del **LM393** es de colector abierto. O sea, o conecta a negativo o no. Pero no puede suministrar corriente, sólo puede drenarla.

Con un comparador se puede hacer un oscilador de relajación siguiendo este esquema:

{% include image.html size="medium" file="osci1.png" caption="Oscilador de relajación construido con un comparador LM393. EyC." %}

La tensión en la entrada no inversora es fija y viene determinada por el divisor resistivo que forman **R1** y **R2**. Como ambas tienen el mismo valor, la tensión en la unión será la mitad de la de alimentación (2.5V).

Mientras la no inversora está fija a 2.5V, con la entrada inversora medimos la tensión presente en el condensador **C1**. Al comienzo, **C1** está descargado, luego en dicha entrada la tensión es prácticamente 0. Gana la entrada no inversora (que estaba a 2.5V) y por tanto la salida está flotante. **C1** comienza a cargarse a través de **R4** en serie con **R5**. Cuando la tensión en **C1** alcanza la presente en el divisor resistivo, el **LM393** conmuta la salida a nivel bajo. Entonces **C1** se descarga a masa, pero ahora **R4** no pinta nada, sólo a través de **R5**.

Recordad que en un oscilador de relajación la carga y la descarga se hacen por vías diferentes y una es más lenta que la otra.

Cuando la tensión en **C1** ha bajado lo suficiente como para estar por debajo de la que hay en la entrada no inversora, el comparador conmuta y deja la salida flotante de nuevo; volviendo al estado inicial y el ciclo de carga/descarga se repite.

Ese es el principio básico. Sin embargo así sólo llegaríamos a un estado en que **C1** está justo en el límite y **U1** estaría todo el rato activándose y desactivándose. No habría oscilación útil. Pero para eso está **R3**.

**R3** afecta a la entrada no inversora. (*Inciso: realimentación en la entrada no inversora significa realimentación positiva, y realimentación positiva casi siempre significa oscilador*). Hace que cuando la salida es negativa la tensión de conmutación sea más baja que cuando la salida es positiva. Así pues, cuando **C1** se ha cargado lo suficiente como para alcanzar el umbral, **U1** conmuta su salida a masa, el condensador comienza a descargar y a la vez se ha fijado un nuevo umbral inferior para conmutar de nuevo a positivo. Nunca se alcanza un estado estable. En su lugar, la tensión en **C1** oscila entre los umbrales inferior y superior.

Los valores de los componentes no son críticos pero sí conviene tener presentes algunas cosillas como:

- **R1** y **R2** deben ser más o menos iguales y tener un valor lo suficientemente alto como para no consumir demasiada corriente.
- **R4** debe ser muy bajo comparado con **R5**, así los tiempos de carga y descarga de **C1** serán similares (aunque nunca iguales) y el duty-cycle próximo al 50%.
- Pero teniendo cuidado. Porque la corriente máxima que puede drenar el comparador son 20mA. Luego **R4** debe ser lo bastante alto como para que por la salida del comparador no se derive una corriente mayor.
- La frecuencia vendrá determinada principalmente por la constante RC de **R5** y **C1**.

Aquí una simulación, en verde está la salida del comparador y en azul la carga y descarga del condensador:

{% include image.html size="small" file="osci1_oscill.png" caption="Simulación del circuito anterior. EyC." %}

¿Qué pasa si queremos conectar algo a la salida? Pues **C1** que se descarga más rápido porque ahora hay otro circuito consumiendo de él. Necesitaremos desacoplar la salida, y para eso se utiliza un *buffer*:

{% include image.html size="medium" file="osci1buffer.png" caption="Oscilador y etapa de salida tipo buffer. EyC." %}

Este segundo comparador tiene una de sus entradas a tensión fija por el divisor resistivo. Su salida dependerá de la tensión presente en la otra entrada. También he incluido a **C2** como condensador de desacople de alimentación.

Pero excitar una bobina no es como encender un LED. Las bobinas se oponen a los cambios de corriente, tienen *inercia*. Piensa en una bobina grande como en algo que *pesa* mucho. Te cuesta empujarla y una vez empieza a moverse luego le cuesta frenarla.

Recuerda que el comparador sólo puede con 20mA y sólo drenar, ni siquiera puede suministrar corriente. Para protegerlo vamos a terminar el circuito con una etapa de salida push-pull. Esta configuración permite tanto suministrar como drenar corriente. Ya la habíamos usado antes en: [Cómo funcionan las etiquetas magneto-acústicas]({{site.baseurl}}{% post_url 2013-07-03-etiquetas-antihurto-magneto-acusticas %}).

{% include image.html size="big" file="osci1bufferpushpull.png" caption="Oscilador con salida push-pull. EyC." %}

Cuando la salida de **U2** esté a nivel flotante, apenas circula corriente por **R8**, por tanto no cae tensión en ella y en la base de **Q1** está presente una tensión próxima a la de alimentación, 5V. En su emisor habrá 0 voltios. **Q1** es NPN, luego conduce cuando su base está 0.7V por encima de su emisor, ahora conduce mucho. Mientras, en el colector de **Q2** están presentes los 5V de alimentación menos la caída colector-emisor de **Q1**, aproximadamente 0.7V.

En **D1** caen unos 0.7V, y en **D2** otros 0.7. Por tanto la base de **Q2** está a la misma tensión que su emisor menos los 0.7V de **Q1**. **Q2** es PNP, conduce cuando su base está a 0.7V por debajo de su emisor. Ahora está justo al límite para empezar a conducir.

Cuando la salida de **U2** pasa a nivel bajo, la situación es justo la contraria. **Q2** se pone a conducir, y **Q1** se encuentra justo en el límite. El resultado es que **Q1** y **Q2** conducen semiciclos alternos de corriente hacia y desde la carga sin zonas muertas entre ellos. Se llama amplificador de *clase AB*.

{% include image.html size="medium" file="osci1bufferpushpull_oscill.png" caption="En un amplificador AB cada transistor conduce un semiciclo completo. EyC." %}

## Medir bobinas con un osciloscopio

Si no tienes medidor para la inductancia, una forma alternativa es medir variables que sí puedas medir con tu medidor y que se vean afectadas por la inductancia. Eso se denomina *medida indirecta.*

Por ejemplo, podrías medir la intensidad de pico en alterna y relacionarla con la reactancia inductiva a esa frecuencia. O podrías medir la respuesta escalón con una resistencia y ajustarla a una exponencial.

El método que voy a usar yo consiste en conectarla a un condensador conocido, formando un **circuito LC**, y dejarlo oscilar. Podemos deducir la inductancia dada la frecuencia de las oscilaciones.

Si antes decíamos que una bobina tiene *inercia* -porque se opone a los cambios de corriente- entonces un condensador es como una goma elástica: intenta compensar los cambios estirándose y encogiéndose. Juntos forman un circuito que oscila igual que una goma con un peso en su extremo.

La frecuencia de la oscilación está relacionada con la inductancia L y con la capacidad C de acuerdo con esta expresión:

$$
LC = \frac{1}{(2\pi f)^2}
$$

*(Es la misma fórmula que para un muelle y un peso, pero cambiando el peso por L y la inversa de la fuerza del muelle por C).*

Ajustamos nuestro oscilador a una frecuencia relativamente baja 5 o 10kHz por ejemplo. Midiendo la tensión en la bobina en el osciloscopio aparece esta señal:

{% include image.html size="big" file="10periodos.png" caption="Contamos los periodos para determinar la frecuencia de oscilación. EyC." %}

Eso se llama respuesta escalón. Es una oscilación armónica amortiguada cuya frecuencia es la frecuencia **natural** de oscilación. Medimos el periodo con el osciloscopio y lo apuntamos. Para mayor precisión, también podemos medir dos o diez periodos en lugar de uno sólo y multiplicar.

Con una medida ya tendríamos suficiente para calcular la L, pero el condensador puede estar mal y no tener la capacidad que dice tener, o podríamos habernos equivocado al contar los periodos, por ejemplo. Lo mejor es probar varios condensadores de distinta capacidad y apuntar las frecuencias. Calculamos la L en cada caso y hacemos la media o -si nos ponemos serios- una [regresión lineal](https://www.graphpad.com/quickcalcs/linear2/).

{% include image.html size="medium" file="condensadores.jpg" caption="Podríamos determinar el valor de la inductancia midiendo con  
varios condensadores y haciendo después una regresión lineal. EyC" %}

Resumiendo: mi bobina es de **940 ± 20 μH**. Despreciando la resistencia (30Ω), la capacidad parásita de los transistores, el efecto de carga de las sondas y el osciloscopio, la propia capacidad de la bobina y otros errores de medida.

## Resonancia

Haber medido así la inductancia tiene un motivo: enseñaros que despreciando otros factores, la frecuencia de oscilación libre es la *frecuencia de resonancia*. Alimentar un circuito LC con una corriente alterna es como empujar un columpio. Si lo haces al tuntún apenas se moverá y te costará mucho; pero si lo empujas a la misma frecuencia que oscila él cuando lo dejas, entonces con cada oscilación la amplitud crece.

Y al igual que sucede en un columpio, la amplitud llega a un máximo según la fuerza de empuje y el rozamiento.

Ahora recuerda que la **impedancia** de la bobina tiene dos partes: una buena y otra mala.

La mala es la **resistencia** ohmmica y se debe al material. Disipa la energía en forma de calor y las oscilaciones se apagan antes. La podemos medir con un tester normal y está ahí siempre. La causa la resistencia del hilo de cobre, y esta depende de su longitud y su grosor.

En nuestra analogía con el columpio, la fuerza sería la tensión aplicada por la etapa de salida del oscilador, y el rozamiento sería la resistencia de la bobina.

La parte buena es la **reactancia** inductiva y se debe a su forma. Se opone a los cambios de corriente y por tanto sólo existe en alterna. No disipa energía sino que la acumula y aumenta el factor de calidad del circuito haciendo que las oscilaciones duren más tiempo. Crece con la frecuencia y con la inductancia, esta a su vez depende del área y del número de espiras. Por eso hacemos las bobinas anchas, con muchas espiras y con cobre a ser posible grueso que tiene menos resistencia por metro.

Ahora ocurre un fenómeno curioso. En resonancia, y sólo en resonancia, la reactancia de la bobina se anula con la del condensador y sólo queda su resistencia. La intensidad que atraviesa el circuito está limitada únicamente por las resistencias de la bobina y de la etapa de salida.

La bobina anterior con 940μH tenía 30Ω de resistencia. La de la etapa de salida mínimo otros 10Ω debido a **R9** y **R10**, unos 40Ω en total. La intensidad en picos se calcula dividiendo los 5V de alimentación entre los 40Ω, 125mA.

Pero si la resonancia de nuestro circuito está en los 100kHz, por ejemplo, la impedancia de la bobina a esa frecuencia no serían los 30Ω de antes, sino más de **600Ω** por la reactancia. Aunque la intensidad seguirán siendo los 125mA ya calculados. Sin embargo la ley de Ohm dice que para que por una resistencia de 600Ω circulen 125mA, la tensión en sus extremos debe ser **75V**.

¿Y eso es de verdad o es un artificio matemático? ¿No teníamos sólo 5V? ¿De donde salen los 75? Los 75V son de verdad y se pueden medir. Igual que la energía de un columpio supera la fuerza con que lo empujaste. Las bobinas molan. En un circuito LC serie sintonizado a la frecuencia de resonancia, la tensión en los bornes de la bobina es **máxima**. Y aquí *máxima* significa sorprendentemente alta.

Aquí tenemos la tensión en la unión de **Q1** y **Q2** (en verde) y la tensión en la bobina (amarillo). Fijaos en la escala de esta última: 20 V/div y la amplitud pico a pico es 80V.

{% include image.html size="big" file="resonancia_push_pull.png" caption="En los extremos de la bobina se miden  
tensiones mucho mayores que la de alimentación. EyC." %}

Depende de la inductancia y de la frecuencia. A mayor frecuencia, capacidades más pequeñas y mayor tensión en los extremos de la bobina, pudiendo llegar a millones de voltios. Es el fundamento de la [Bobina de Tesla](https://es.wikipedia.org/wiki/Bobina_de_Tesla).

El máximo teórico no se alcanza nunca por las pérdidas, y porque excitamos el circuito con una onda cuadrada en vez de senoidal. Pero cuidado con el osciloscopio porque con una alimentación de 5V la amplitud supera fácilmente los 100.

En este clip podéis apreciar la el fenómeno de resonancia con una capacidad pequeña. A medida que nos acercamos a la frecuencia de oscilación natural, la amplitud crece. La resonancia tiene un margen muy estrecho porque el factor de calidad es alto. Y la tensión pico a pico en resonancia supera los 100Vpp.

{% include youtube.html id="FsU0CnQ5dLw" %}

## Detector de envolvente

Para medir fácilmente la tensión en la bobina conectaremos un *detector de envolvente*. Sólo tiene tres componentes: un diodo detector, un condensador y una resistencia. Os sonará el esquema de las radios AM.

{% include image.html size="medium" file="detector_de_envolvente.gif" caption="Detector de envolvente. [Wikipedia.](/assets/2019/12/leer-tarjetas-de-acceso-rfid-sin-arduino/C_Simple_envelope_detector.gif)" %}

El diodo es fácil: un **1N4148**. Salvo que nos vayamos a frecuencias muy altas, a voltajes muy bajos o a corrientes altas siempre será el 1N4148.

La resistencia es fácil también: alta pero no muy alta. Porque, como va en paralelo, si la ponemos baja se comerá mucha señal de salida y podría sacar de resonancia a la bobina emisora. Pero si la ponemos muy alta, el condensador se quedará cargado, ya que la corriente no puede retornar por el diodo y no tiene otro sitio donde ir. El circuito será muy lento y no reflejará a tiempo las variaciones de amplitud.

Para el condensador recurrimos a la constante de tiempo RC y luego ya afinaremos si es preciso. Durante la fase de carga, la resistencia forma un divisor resistivo con la fuente. Si R es alta, como hemos dicho, la podemos despreciar y decir que sólo nos afecta la impedancia de salida de la fuente.

La descarga de **C** sí se hace sobre **R**. Ya sabéis que la carga y descarga son exponenciales. En una constante RC la carga cae hasta el 36% de su valor inicial. Con 100kΩ y 10nF ese periodo es de 1ms. Como os digo son valores iniciales, después habrá que ajustarlos.

Este sería el esquema completo:

{% include image.html size="big" file="circuito_completo.png" caption="Esquema completo incluyendo el demodulador. Click para ampliar. EyC." %}

Para **R12** hemos usando un trimmer en lugar de una resistencia fija, así nos servirá también para reducir la tensión. Como si fuera un control de volumen. La salida del detector la enviamos a otro comparador LM393 llamado **U3**. De nuevo tomamos como referencia la mitad de la tensión de alimentación usando **R12** y **R13** como divisor resistivo. Para **R14** probaremos varios valores, 220k funciona bien. U3 admite configuración inversora o no inversora según lo que queramos hacer después con la señal.

Para el siguiente clip de vídeo hemos construido un circuito resonante con otra bobina y un condensador acorde. Cuando lo acercamos al emisor, el circuito resuena y absorbe energía. Lo cual se traduce en una bajada de la amplitud. El comparador lo detecta y enciende el LED. Cuando anulamos el condensador, el receptor sale de resonancia, las oscilaciones recuperan su amplitud y el LED vuelve a apagarse.

{% include youtube.html id="1gnATd2bHBo" %}

Se podría decir que el LED se enciende cuando hay algo que está absorbiendo la energía, o que altera la oscilación de alguna forma. Ahora ya sabes por qué las **cocinas** de inducción detectan si tienes puesto algo al fuego.

Lo más llamativo es que el receptor, además de alimentarse de la corriente inducida, puede enviar información al transmisor entrando y saliendo de resonancia.

Esta interacción se llama Comunicación de Campo Cercano (NFC). Si bien los dispositivos comercializados como NFC o *contactless* operan a 13.56MHz (HF), hay un caso donde aún lo vemos en LF.

## Tarjetas identificativas de proximidad pasivas de baja frecuencia

Hasta ahora nos hemos limitado a la **capa física**. El receptor puede inducir una condición que el emisor puede detectar. Es suficiente para transmitir información. Ahora debemos definir una codificación de bits, un protocolo y -finalmente- un mensaje formado por unos campos.

Al título. Lo de **tarjetas** tiene poco que explicar, a veces son tarjetas, a veces llaveros, a veces pegatinas y a veces chips subcutáneos.

{% include image.html size="medium" file="tres_tarjetas.jpg" caption="Dispositivos RFID. EyC." %}

Las tarjetas **identificativas** suelen ser de sólo lectura, y se limitan a transmitir un código. Desde que las arrimas al sensor hasta que las alejas, todo el rato están transmitiendo ese código en bucle. Cuando se activan o desactivan, en realidad ingresamos el código en una base de datos para conceder o denegar el acceso. Pero en la tarjeta no se cambia nada.

Su función principal es identificar al portador ante un control de acceso. Como haría una llave o una huella dactilar. El lector simplemente envía el identificador de la tarjeta junto a su propio código de sensor a un ordenador. Este consulta la base de datos donde consta si dicho identificador tiene permitido el paso o no.

De **proximidad** significa que el lector puede inferir el código sin necesidad de entrar en contacto con él. Lo cual es cómodo para no sacar la tarjeta de la cartera; y aún más útil para leer un chip subcutáneo de identificación animal.

Las tarjetas **pasivas** son aquellas que se alimentan directamente del campo que emite el lector. Lógicamente son de corto alcance. También las hay activas, llevan una pila y su rango es mayor, pero no es el caso.

El principio físico, lo de modular el campo emitido por el emisor, es válido para cualquier frecuencia. Los dispositivos NFC típicos como el móvil o la tarjeta de crédito operan en 13.56MHz, esto sería HF. Hay otros en UHF. Pero los que nos ocupan operan a 125kHz, es decir LF (recuerda: LF va 30 a 300kHz).

Vamos a probar con esta tarjeta:

{% include image.html size="medium" file="fermax_foto.png" caption="Tarjeta de acceso típica a 125kHz. EyC." %}

Ajustamos la frecuencia a **125kHz** conectamos el osciloscopio para ver la señal. Arriba está la envolvente (acoplada en AC) y abajo la onda cuadrada tras pasar por el comparador.

{% include image.html size="big" file="fermax_scope.png" caption="Señal emitida por la tarjeta. EyC." %}

En el siguiente vídeo vemos cómo al acercar una tarjeta a nuestra bobina, obtenemos una señal modulada en amplitud. Con el detector de envolvente la demodulamos y, finalmente, con el comparador la convertimos en una onda cuadrada. La primera tarjeta y el llavero se comportan de forma parecida, sin embargo hay una segunda tarjeta cuyo protocolo aún nos es **desconocido**.

{% include youtube.html id="ESkHm3ysuzg" %}

## El protocolo EM4100

El chip EM4100 se ha convertido en un estándar habitual. Su protocolo consta en el datasheet y puede utilizar varias codificaciones, la más común es Manchester. En la codificación Manchester siempre hay una transición en cada bit. De arriba a abajo o de abajo a arriba, pero siempre la hay.

Lo llevamos al analizador lógico:

{% include image.html size="big" file="fermax_logic.png" caption="Señal digital interpretada por el analizador lógico. EyC." %}

Y estos son los bits. Es el mismo mensaje repetido en bucle.

{% include image.html size="big" file="fermax_unosyceros.png" caption="Las tarjetas RFID repiten en bucle el mensaje. EyC." %}

Conocemos el protocolo porque lo describe el datasheet. Empieza por nueve unos seguidos, luego vienen 10 grupos de 5 bits (siendo el quinto un bit de paridad de los otros 4). A continuación 4 bits más como paridad de cada columna y finalmente un bit de stop.

{% include image.html size="big" file="em4100_bits.png" caption="Campos de un mensaje EM4100. EyC." %}

Nuestro mensaje en binario es:

```
1111111110000000011000001010010111010011001001111100011001010110
```

Una vez decodificado queda:

```
Cabecera: 111111111
Versión 1:     0000 0 -> 0
Versión 2:     0001 1 -> 1
Datos 1:       0000 0 -> 0
Datos 2:       1010 0 -> A
Datos 3:       1011 1 -> B
Datos 4:       0100 1 -> 4
Datos 5:       1001 0 -> 9
Datos 6:       0111 1 -> 7
Datos 7:       1000 1 -> 8
Datos 8:       1001 0 -> 9
Par + Stop:    1011 0

Versión: 01 
Datos:   0AB49789
```

Es decir, esta tarjeta corresponde al código **0AB49789**. No encuentro la relación con la numeración impresa en la tarjeta.

Vamos a hacer otra prueba con un llavero. Fijaos en que tiene grabado por fuera el código **6869636**:

{% include image.html size="small" file="fob_foto.jpg" caption="Llavero RFID. EyC." %}

En el osciloscopio nos aparece una señal más débil porque el diámetro de la bobina es menor que el de la tarjeta.

{% include image.html size="big" file="fob_scope.png" caption="Señal transmitida por el llavero y convertida en onda cuadrada. EyC." %}

Obtenemos la siguiente ristra de bits:

```
1111111110001101111000000000001100100011101100101100010100110110
```

Lo decodificamos igual que antes:

```
111111111
     0001 1 -> 1
     0111 1 -> 7
     0000 0 -> 0
     0000 0 -> 0
     0110 0 -> 6
     1000 1 -> 8
     1101 1 -> D
     0010 1 -> 2
     1000 1 -> 8
     0100 1 -> 4
   
     1011 0

Versión: 0x17
Datos:   0x0068D284 -> 6869636
```

El código transmitido es **0x0068D284**. Ese número pasado a decimal es justamente el **6869636** grabado en él.

## Tarjeta desconocida

Ahora vamos a probar con esta otra tarjeta:

{% include image.html size="medium" file="hid_foto.png" caption="Otra tarjeta de acceso a 125kHz. EyC." %}

En lugar de la señal modulada que veíamos antes, ahora tenemos una señal de otra forma:

{% include image.html size="big" file="hid_scope1.png" caption="Señal al osciloscopio. No se parece a las anteriores. EyC." %}

Si la ampliamos un poco:

{% include image.html size="medium" file="hid_scope2.png" caption="Modulación de la tarjeta ampliada. EyC." %}

No parece ni Manchester ni nada conocido. El comparador ya no nos sirve, el analizador lógico tampoco.

Pasamos a control **manual**. ¿Os acordáis cuando tomamos una señal que no sabíamos qué era y la fuimos desgranando capa por capa? [Describiendo un protocolo desconocido]({{site.baseurl}}{% post_url 2017-12-25-describiendo-un-protocolo-desconocido %}).

La señal dura a nivel alto 4 o 5 períodos y luego desciende otros tantos. Pongamos en total 10 periodos. La portadora son 125kHz, luego eso nos da una frecuencia de unos 12kHz. Está dentro del rango que podríamos analizar con la tarjeta de sonido.

Lo grabamos y abrimos en Audacity:

{% include image.html size="big" file="hid_audacity.png" caption="La señal transmitida por la tarjeta está en el rango audible. EyC." %}

Tiene pinta de ser **dos** frecuencias distintas. Es decir una señal **FSK**. Ese patrón lo hemos visto antes, por ejemplo cuando decodificamos la señal del Tren-Tierra en [Demodular AFSK, desde cero]({{site.baseurl}}{% post_url 2017-10-28-demodular-afsk-desde-cero %}).

Las dos frecuencias podrían ser 14kHz y 17.5kHz. No importa la frecuencia exacta porque para demodularla vamos a aplicar un filtro **paso bajo**. Así la frecuencia alta se atenuará más que la frecuencia baja. Después identificaremos la duración del mínimo periodo en alto o en bajo y segmentaremos en partes iguales.

{% include image.html size="big" file="hid_LH.png" caption="Análisis manual del mensaje. Click para ampliar. EyC." %}

Nos da el siguiente mensaje:

```
LLLLHHHLHLHLHLHLHLHLHHLLHLHLHLHLHLHLHLHLHLHHLLHLHHLHLHLLHLHHLHLLHLHLHHLHLHLLHHLHLHLHLHLLHLHHLLHHLLLL
```

¿Cómo sé que el mensaje empieza y acaba ahí? Porque es llamativo ver tantas L seguidas. Salvo al principio y al final, en el resto del mensaje no aparecen más de dos H o dos L seguidas.

Además de señalarnos el principio y final, también significa que la codificación tiene al menos una transición por periodo. Si nos fijamos en que hay más cambios que letras seguidas, nos lleva una vez más a **Manchester**.

Como siempre, empezamos por buscar los **ceros**. Si no funciona ya cambiaremos. Hay más transiciones de L a H que al revés. Luego supondremos que una transición de L a H es un 0, y una transición de H a L es un 1.

Podría ser otro código de línea, o incluso no ser Manchester. A ver qué sale:

```
000000010000000000100111001100011101111100101
```

En este punto nos imaginamos que los números impresos en la tarjeta guardan alguna relación con el mensaje. Podría no ser así, pero es una suposición para avanzar en el análisis. Estos son los dígitos impresos junto con su equivalente en binario:

```
00007666 -> 0001 1101 1111 0010
     115 -> 0111 0011
```

Bueno pues resulta que ¡sí encontramos esas secuencias de bits! Por tanto la hipótesis que hemos hecho debía ser **correcta**: modulación FSK y código de línea Manchester:

```
                                        115                7666
                                  --------- -------------------
                                  0111 0011 0001 1101 1111 0010
Mensaje: 0000 0001 0000 0000 0010 0111 0011 0001 1101 1111 0010 1
```

El mensaje empieza por 0x01002, no sabemos aún qué significa, tal vez el código de fabricante. A continuación contiene el primer dígito y luego el segundo. Y termina con lo que quizá sea un bit de stop.

¿Por qué esa tarjeta se desmarca del estándar utilizando un protocolo propietario?

No puede ser por fiabilidad. Transmitir un mensaje codificado en FSK por medio de una codificación ASK de la portadora parece más enrevesado que fiable. En velocidad tampoco se gana nada. Siendo malpensado, me inclino por que es un protocolo propietario para venderte sus propios lectores y tarjetas incompatibles con el resto.

Pero **no** es por eso.

Buscando por el principio del mensaje 0x01002 y por la marca -HID- llegamos a esta documentación: [Understanding Card Data Formats - Wiegand™ Format](https://www.hidglobal.com/sites/default/files/hid-understanding_card_data_formats-wp-en.pdf).

¡Es por compatibilidad! Lo que tenemos ante nosotros es un *dinosaurio* comparado con el EM4100. El formato **Wiegand** es un estándar muy anterior, lleva en el control de acceso desde hace 40 años. Muy difundido en la industria.

Las tarjetas Wiegand fueron de las primeras tarjetas de acceso. En lugar de banda magnética, llevaban el número codificado en unos hilos magnéticos que se leen por [efecto Wiegand](https://en.wikipedia.org/wiki/Wiegand_effect). No se podían reprogramar ni tampoco borrar fácilmente. En definitiva, aptas para uso industrial.

{% include image.html size="big" file="Wiegand-wiring.png" caption="El código de las tarjetas Wiegand está grabado en hilos magnéticos en su interior.  
[Hacking HID with Wiegand Protocol Vulnerability](https://www.getkisi.com/blog/hid-keycard-readers-hacked-using-wiegand-protocol-vulnerability)" %}

Y aunque estas ya no se usan, el formato Wiegand continúa vigente hoy día en muchos controles de acceso. En muchos sitios lo que se ha cambiado han sido los lectores y las tarjetas que ahora usan tecnología RFID. Pero la interfaz -y por tanto el resto del sistema- son los mismos desde los años 80 con escasas modificaciones.

Un mensaje Wiegand consta de **26 bits**. El primer bit es un bit de paridad de los 13 primeros bits. Luego vienen 8 bits del llamado *Factory Code* (código de empresa). Le siguen 16 bits del *Card Number*. Y el último es un bit de paridad de los últimos 13 bits. Así:

{% include image.html size="big" file="hid_wiegand_format.png" caption="Formato de un mensaje Wiegand.  
[Understanding Card Data Formats - HID Global](https://www.hidglobal.com/sites/default/files/hid-understanding_card_data_formats-wp-en.pdf)" %}

El mensaje anterior sería:

```
    0x0801              P FC=115   CN=7666          Q
000 0000 1000 0000 0001 0 01110011 0001110111110010 1
```

El comienzo (0x801) podría ser el identificador del fabricante o versión de la tarjeta. P y Q son los bits de paridad.

Pero hay una diferencia crucial entre las tarjetas de efecto Wiegand reales y las RFID. Mientras que las primeras eran muy **difíciles de construir** en casa -de falsificar-, las RFID se pueden clonar con un poco de ingenio. [AVR RFID Multipass](https://www.nycresistor.com/2012/12/27/rfid-multipass/). Ni en la tarjeta ni en los lectores hay nada que pueda evitarlo.

En conclusión, la comunicación unidireccional conlleva mensajes estáticos, breves y repetidos en bucle, siendo sencillos de imitar por un atacante. Por eso esta tecnología está en desuso en favor de las tarjetas NFC de HF (13.56MHz). Operar a mayor frecuencia permite una velocidad de transferencia mayor y más potencia para la alimentación.

La comunicación con las tarjetas NFC modernas es bidireccional. Los mensajes ya no son estáticos sino desafío-respuesta (como en una tarjeta monedero de chip). Muchas versiones como [Mifare](https://en.wikipedia.org/wiki/MIFARE) incorporan criptografía fuerte, lo cual las hace muy difíciles de falsificar.
