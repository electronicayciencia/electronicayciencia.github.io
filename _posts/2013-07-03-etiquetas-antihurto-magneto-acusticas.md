---
assets: /assets/2013/07/etiquetas-antihurto-magneto-acusticas
featured: 'true'
image: /assets/2013/07/etiquetas-antihurto-magneto-acusticas/img/Sensormatic-Am-58kHz-Security-Label.jpg
layout: post
tags:
- Circuitos
- Experimentos
- Fisica
- Sonido
title: Cómo funcionan las etiquetas magneto-acústicas (o acustomagnéticas)
---

En esta entrada quiero hablaros de un sistema anti hurtos que casi todos habréis visto. Se utiliza desde hace unos años en muchos establecimientos para productos que antes no contaban con estas medidas de seguridad.

{% include image.html size="" file="Sensormatic-Am-58kHz-Security-Label.jpg" caption="" %}

Se trata de las etiquetas magnetoacústicas (o acustomagnéticas) como las de la imagen. Veremos qué tienen por dentro. Os explicaré cómo funciona todo el sistema (activación/detección/desactivación/reactivación) y, como en este blog nunca nos quedamos en la teoría, también construiremos un pequeño arco anti-hurtos casero para probar todo eso.

Os aviso de que esta va a ser una entrada extensa. Quizá la más extensa de todo el blog. Hablaremos de imanes, fenómenos electromecánicos, de resonancia, de circuitos LC sintonizados, construiremos nuestro arco anti-ladrones y terminaremos programando una interfaz en Perl/TK para filtrar y detectar la señal por medio de técnicas sencillas de Procesado Digital (DSP).

De lo que no hablaremos es de cómo burlar los sistemas.

<!--more-->

## Anti-hurtos

Para los que no estáis familiarizados, la diferencia entre un sistema anti-hurtos y un antirrobo es que el primero alerta de los hurtos mientras ocurren para que un vigilante se se haga cargo de la situación. Mientras que el segundo tiene como misión impedir el robo por si mismo. Una etiqueta de alarma como esta es un anti-hurto. Una cadena y un candado de una moto, un antirrobo.

Hay múltiples razones por las que este sistema es cada vez más popular, entre otras:

- Es **barato** de instalar y de usar. Las etiquetas desechables consiguen al por mayor en tiendas chinas a un precio ridículo. Por eso las utilizan para proteger artículos relativamente baratos, pequeños y abundantes, como pueden ser un trozo de queso o un cepillo de dientes.
- Es **práctico**. Sólo pegar la etiqueta y listo (cuando llevas cien etiquetas empieza a perder la gracia). Pero lo mejor es que no hay que pararse a quitarlas, porque al pasar por caja se desactivan automáticamente. Así ahorra tiempo y reduce las colas. Además las etiquetas se pueden volver a activar de manera sencilla si el artículo es devuelto.
- Y sobre todo, es **discreto**. A veces interesa que se vea bien que el artículo está protegido (tintes, LEDs, cajas de plástico, precintos grandes, cordeles de seguridad...) pero otras veces interesa más esconderlo y así, no sólo no hay que quitarlo, sino que además pasa desapercibido para el ladrón.

Pero ¿cómo funciona?

## Estructura de una etiqueta

Si al verlas os habéis preguntado qué tienen dentro las etiquetas de alarma, la verdad es que al abrirlas decepcionan un poco.

{% include image.html size="" file="Etiqueta1_editada.JPG" caption="" %}

Esta figura consta en la patente [US6359563](http://www.google.com/patents/US6359563) del 2002, para que os hagáis una idea de cómo está montado en 3D.

{% include image.html size="" file="US06359563-20020319-D00000.jpg" caption="" %}

El **número 1** es el plástico protector.

El **número 2** son dos tiras de idéntica longitud y composición. Durante la fabricación se toman dos segmentos contiguos, cortados de la misma cinta, para asegurarse de que sus propiedades son lo más parecidas posibles. El material es una aleación especial, que si os interesa está bien descrita en la patente.

El **número 3** no es más que un separador de plástico.

El **número 4** es una tira de material ferromagnético, es decir *imantable*. Y sirve para alterar el campo magnético que rodea a las tiras de aleación.

Existe una propiedad física que se llama [**magnetostricción**](https://es.wikipedia.org/wiki/Magnetostricci%C3%B3n) y consiste en que un material se estira y se encoge cuando está inmerso en un campo magnético alterno. Naturalmente son movimientos microscópicos e invisibles. La próxima vez que paséis cerca de un transformador tal vez oigáis un zumbido. Aunque sabemos que no tienen ninguna pieza móvil, los transformadores mal sujetos vibran al paso de la corriente alterna. Es por la magnetostricción del núcleo, que hace que se estire y se encoja microscópicamente cincuenta veces por segundo. Como la vibración es muy pequeña, se nota más en los transformadores grandes.

Bueno pues la aleación de la que hablábamos tiene esa misma característica pero potenciada. No sólo eso, además las tiras están cortadas con un largo y un ancho calculados para que, de la misma forma que una cuerda de guitarra, vibren a una frecuencia exacta.

Y ¿a qué frecuencia vibran? pues depende de cómo esté la placa ferromagnética. Si está imantada las tiras **resonadoras** vibran a 58kHz. Y si no está imantada vibranrán a otra frecuencia, pero para el caso ya no nos importa.

El límite de audición llega hasta 20kHz por lo que la frecuencia de 58kHz es ultrasónica.

## La resonancia magnetoacústica

No es la primera vez que hablamos en este blog de fenómenos de resonancia. Por favor, leed estas dos entradas si no lo habéis hecho para tener presente un ejemplo más cercano y muy visual de lo que vamos a hacer a continuación:

- [Espectroscopía casera con copas]({{site.baseurl}}{% post_url 2010-04-12-espectroscopia-casera-con-copas %})
- [Resonancia mecánica con copas II]({{site.baseurl}}{% post_url 2010-08-25-resonancia-mecanica-con-copas-ii %})

En estas dos entradas empleábamos sonido audible, y copas normales. Lo que viene después es exactamente el mismo fenómeno pero con campos magnéticos y frecuencias ultrasónicas. Parece muy abstracto, pero en realidad es algo muy típico.

Según lo que hemos visto en las entradas anteriores, cuando aplicamos un estímulo de una frecuencia dada a algo que resuena en esa misma frecuencia, el objeto se pone a vibrar y esta vibración continúa un tiempo después de terminar el impulso.

Ejemplos todos los que queráis: una copa, un muelle, una cuerda de guitarra, un poste tras darle una patada... en unos casos el movimiento dura más y en otros menos. Pero la frecuencia de vibración no depende de la fuerza del estímulo sólo depende de las propiedades físicas del sistema (longitud, dureza, material, etc).

Por tanto, aplicamos un campo magnético de 58kHz a una etiqueta. Este campo magnético induce un movimiento en las placas resonadoras. Si la placa polarizadora está imantada, se produce resonancia y vibran a esta frecuencia de 58kHz, escuchándose un eco tras apagar el campo magnético. Si está desimantada no hay eco.

De fábrica las etiquetas están activadas: la placa polarizadora está imantada, y la frecuencia de resonancia es próxima a 58kHz. Al pasar por caja, una antena integrada en los lectores de códigos de barras más frecuentes ([como estas](http://www.sensormatic.com/Products/EAS/LabelDeactivators/ScanMaxProFamily/ScanMaxProFamily_home.aspx)) emite un breve pulso magnético de 58kHz y escucha. Si oye un eco magnético tras el pulso significa que hay una etiqueta próxima. En cuanto lee el código de barras comienza el proceso de desactivado. La pequeña antena emite un pulso magnético de baja frecuencia para desmagnetizar la placa polarizadora. A continuación vuelve a emitir un pulso a 58kHz, escucha. Si no oye eco da por desactivada la alarma, si lo oye intenta desactivamente de nuevo. Todo esto ocurre en fracciones de segundo mientras el precio aparece en el lector.

A la salida de la tienda hay una antena transmisora y otra receptora. La antena transmisora está continuamente emitiendo pulsos magnéticos de 58kHz a razón de 100 pulsos por segundo. Mientras que la antena receptora está escuchando esos pulsos.

Cuando una etiqueta que ha pasado por caja, desactivada, se coloca entre las dos antenas no ocurre nada. Porque al estar el polarizador desimantado no hay resonancia, el campo no le afecta.

Si pasamos con una etiqueta sin desactivar, esta absorve energía del campo magnético, resuena en 58kHz y emitirá un eco magnético tras cada pulso. Este eco lo captará la antena receptora que inmediatamente hará sonar la alarma.

Y así es como funciona. Hasta aquí la parte divulgativa; pero como os decía al empezar la entrada, el objetivo de este blog no es sólo divulgativo sino técnico. No nos conformamos con explicar por encima  cómo funcionaría algo, hay cientos de sitios que ya te lo explican. Vamos a llevar esa teoría a la práctica y ver cómo funciona realmente.

## Un arco casero

Tendremos que hacernos un arco anti-hurto casero. Conectarlo al ordenador y registrar lo que ocurra.

Lo primero que necesitamos es una bobina. Esta va a ser la antena que radiará los pulsos magnéticos para excitar las etiquetas.

Sabemos que para trasferir la máxima potencia a la bobina hay que adaptar la impedancia. De manera que la bobina, compensada con un condensador, parezca ser una carga resistiva pura para el transistor de salida. Dicho de otra manera hay que formar un circuito resonante a la salida, compensando la reactancia inductiva con un condensador apropiado.

Como la bobina la tenemos que construir nosotros, es más fácil elegir primero el condensador y acto seguido hacernos una bobina que tenga la misma reactancia inductiva para que se compensen entre sí.

¿Qué capacidad elegimos?

En teoría podríamos elegir la capacidad que queramos. Sabiendo que inductancia y  capacidad son inversas una de la otra, cuanto más alta sea la capacidad menos vueltas necesitará la bobina y viceversa: cuanto menor sea la capacidad más grande tendrá que ser la bobina.

Así pues, escogemos un condensador grande y una bobina pequeña que será lo más sencillo de hacer. ¿No? **Primer error**.

Una bobina demasiado pequeña apenas generará campo magnético y lo que es peor, el [factor de calidad (Q)](https://es.wikipedia.org/wiki/Factor_de_calidad) será muy bajo. Un Q alto implica que el circuito resuena muy bien para, y sólo para la frecuencia concreta con un margen muy estrecho. Un Q muy bajo en cambio, significa que "resuena" por igual para todas las frecuencias, para ninguna en realidad. Luego ya sabemos que la capacidad tiene que ser cuanto más baja mejor, para que la bobina sea mayor y más eficaz.

Elegimos un condensador de 10nF, y calculamos la inductancia que resulta ser de 766uH. Según estas páginas *[Air core inductance calculator (multilayer, circular)](http://coil32.narod.ru/calc/multi_layer-en.html)*  y *[Inductance Calculations: Rectangular Loop](http://www.technick.net/public/code/cp_dpage.php?aiocp_dp=util_inductance_rectangle)*  necesitaremos una bobina que tenga unas 60 vueltas.

Esos parámetros nos proporcionan 6kHz de ancho de banda para variar la frecuencia principal si lo necesitamos.

{% include image.html size="" file="excel_rlc_amort.PNG" caption="" %}

Siguiente punto, el grosor del hilo. Lo más sencillo y más fácil de conseguir es hilo de cobre finito. Pero, **segundo error** ¡no demasiado fino! Un hilo demasiado fino presentará mucha resistencia, y bajará el factor Q por debajo del límite de oscilación. O sea, la bobina tendrá tanta resistencia que en menos de un ciclo toda la energía que pudiera almacenar el condensador se disipará en calor. En Wikipedia hay una tabla de resistividad frente a sección: [Calibre de alambre estadounidense](https://es.wikipedia.org/wiki/Calibre_de_alambre_estadounidense)

Para terminar de complicar los cálculos, la resistencia influye también en la frecuencia central. De esto ya habíamos hablado antes en [El circuito RLC serie: oscilaciones amortiguadas]({{site.baseurl}}{% post_url 2011-05-18-el-circuito-rlc-serie-oscilaciones %}). Aquí podemos ver para una frecuencia, capacidad y resistenca del bobinado cuál debe ser la inductancia teórica (sin amortiguamiento) y cuál debe ser teniendo en cuenta este.

{% include image.html size="" file="excel_rlc_wd.PNG" caption="" %}

Como siempre, los Excel los tenéis al final de la entrada. Y casi todas las imágenes las podéis ampliar abriéndolas en otra ventana del navegador.

Recuperando un poco de hilo de cobre de un viejo transformador, y haciendo algunos cálculos fabricamos la que será nuestra bobina emisora:

{% include image.html size="" file="IMAG0446-1-1.jpg" caption="" %}

Aunque no es estrictamente necesario, vendrá bien ajustarla una vez conectada al circuito quitando alguna que otra vuelta hasta maximizar la tensión en los extremos.

## Circuito del emisor

Ahora que ya tenemos la bobina, necesitamos hacernos nuestro propio excitador. Sabemos que tiene que emitir de 10 a 100 pulsos por segundo con una frecuencia de 58kHz. Aunque nos gustaría que fuese ajustable dentro de un pequeño rango y así buscar la resonancia óptima.

El circuito que os propongo como véis es viejo y clásico, consiste en un doble temporizador 555 y una etapa de salida push-pull:

{% include image.html size="" file="TX58kHz_vi_papel.png" caption="" %}

El primer temporizador, **IC1A**, es el que oscila 100 veces por segundo para modular los pulsos. Está configurado como astable. Pero hemos insertado el diodo **D1** en paralelo con **R2**. Conseguimos así que el condensador se cargue a través de **R1** pero se descargue a través de **R2**, y logramos un duty-cycle inferior al 50%. Con la configuración habitual de un 555 sería imposible. Para más información visitad [555 and 556 Timer Circuits](http://electronicsclub.info/555timer.htm#astable).

{% include image.html size="" file="excel_dcl50.PNG" caption="" %}

El segundo temporizador, **IC1B**, oscila sobre los 58kHz. **R9** es un trimmer multivueltas cuyo objetivo es ajustar con precisión la frecuencia de salida. Está configurado como astable también, pero en este caso **C3** se carga y se descarga por el mismo camino: a través de las resistencias **R3** y **R9** en serie. Lo cual nos asegura un DC lo más próximo al 50%. Para maximizar la potencia de salida es imprescindible que esté el mismo tiempo con nivel alto que con nivel bajo.

{% include image.html size="" file="excel_dc50.PNG" caption="" %}

La salida de **IC1A** se conecta a la patilla reset de **IC1B**. De tal forma que cuando **IC1A** pasa a nivel alto **IC1B** se activa y genera la frecuencia de 58kHz. Y cuando **IC1A** pasa a nivel bajo, el oscilador se apaga y la salida queda en silencio.

La función del puente **JP1** es permitirnos escoger la forma de la salida. Si queremos generar una onda continua de 58kHz o pulsante. Es muy útil a la hora de medir la frecuencia con un frecuencímetro. Si activamos la modulación, y la portadora se vuelve intermitente, será muy difícil determinar la frecuencia exacta del oscilador.

La señal en la patilla de salida de **IC1B** se aplica a la base de **T2**. **T1** y **T3** forman la etapa de salida. Es una configuración básica de salida en [push-pull](https://es.wikipedia.org/wiki/Salida_push-pull). Y es muy conveniente para suministrar pero también drenar corriente de un circuito. En este caso del circuito resonante que forman la bobina (**COIL**) y **C4**. Al fin y al cabo es el esquema que recomienda Microchip para excitar un RFID de 125kHz en su Application Note [microID® 125 kHz RFID System Design Guide]({{page.assets | relative_url}}/51115f.pdf).

Sin embargo hay una cosa más. Nuestra placa no sólo genera una frecuencia de 58kHz. Sino que como hemos vito la corta en seco a intervalos regulares. Cortar la alimentación a una bobina es algo que no le sienta nada bien, de hecho le sienta fatal. Y reacciona al igual que cuando intentamos parar en seco un columpio: nos golpea con toda su inercia. En una bobina tenemos que parar el pico de tensión inversa, que es mayor cuanto mayor sea la inductancia. Con la bobina que hemos construido puede llegar a los 72 voltios.

{% include image.html size="" file="sin_zener.jpg" caption="" %}

La función del diodo zener D5 es precisamente cortar toda tensión en bornes del circuito resonante que sobrepase la alimentación. Así matamos dos pájaros de un tiro: protegemos los transistores de salida y frenamos la oscilación en poco tiempo.

{% include image.html size="" file="con_zener.jpg" caption="" %}

Para ser sincero, no es la mejor solución. Si quisiéramos frenar el circuito en el menor tiempo posible tendríamos que recurrir al amortiguamiento crítico. Para más información leed esta entrada: [El circuito RLC serie: oscilaciones amortiguadas]({{site.baseurl}}{% post_url 2011-05-18-el-circuito-rlc-serie-oscilaciones %})

Aquí tenéis una foto de la placa ya terminada. Al final del artículo os incluyo los esquemas en formato Eagle 5.11.

{% include image.html size="" file="IMAG0463.jpg" caption="" %}

## Receptor

En cuanto a la recepción, ya hemos dicho que quiero ver la señal de 58kHz en el PC para trabajar con ella después. Ya me gustaría tener una tarjeta de adquisición de datos, pero he de conformarme con la tarjeta de sonido que a duras penas alcanza los 20kHz.

Afortunadamente ya teníamos listo el circuito que necesitamos: el **mezclador de frecuencias** *(parezco Doraemon)* que hicimos en la entrada anterior [Mezclador de frecuencias con el integrado 4066]({{site.baseurl}}{% post_url 2013-04-22-mezclador-de-frecuencias-con-el %}). Este dispositivo nos permitirá transformar la señal de 58kHz, rebajando su frecuencia hasta convertirla en audible dentro de los márgenes de nuestra tarjeta de sonido.

Como antena utilizaremos otra bobina similar a la primera. Esta ya no es crítica, porque en la entrada del receptor no vamos a adaptar impedancias. No nos importa por esta vez sacrificar parte de la recepción.

Ya tenemos completo nuestro arco anti-hurtos casero y tiene buena pinta. Ahora esperemos que funcione.

{% include image.html size="" file="IMAG0469.jpg" caption="" %}

## Visualizar el eco

Colocamos las antenas enfrentadas a una distancia de 20cm una de otra. Encendemos el receptor y lo conectamos a la entrada de la tarjeta de sonido. Encendemos transmisor. Con el puente **JP1** seleccionamos la posición de *onda continua*. Movemos el dial hasta que recibamos la portadora claramente entre 3 y 5kHz.

Cambiamos el interruptor a pulsante y ajustamos ganancia y volumen. Recibimos una señal como esta:

{% include image.html size="" file="pulsosin.jpg" caption="" %}

Tomamos una etiqueta adhesiva, generalmente cualquier etiqueta sirve porque tienen la mala costumbre de no desactivarse del todo. La interponemos entre las dos antenas, más próxima a la antena receptora. Y ¡este es el efecto!

{% include image.html size="" file="pulsofuerares.jpg" caption="" %}

Eh, pues vaya mierda ¿no?

Bueno, puede ser por dos cosas:

- La etiqueta está desactivada. Así que trataremos de activarla como luego describiré más adelante.
- Está fuera de resonancia, que es lo más probable.

Ya lo explicamos en la entrada sobre circuitos resonantes, si queremos que un sistema resuene durante más tiempo y nos de tiempo a detectarlo, tiene que tener un buen factor de calidad Q. Y el sistema sólo resuena a una frecuencia muy concreta, con un margen estrechísimo.

Así que giramos lentamente el trimmer hasta que el eco sea máximo:

{% include image.html size="" file="pulsocon.jpg" caption="" %}

¡Esto está mejor! Es un efecto muy vistoso cómo los pulsos se prolongan al pasar con una etiqueta activada y sólo cuando está activada. Cuando el efecto es máximo la onda pulsante acaba por convertirse en continua. Exactamente igual que ocurría en la entrada [Espectroscopía casera con copas]({{site.baseurl}}{% post_url 2010-04-12-espectroscopia-casera-con-copas %})

{% include image.html size="" file="sin_y_con.png" caption="" %}

En la imagen anterior la frecuencia del transmisor y la del eco coinciden, por eso el efecto es grande. En el primer intento pasó esto otro:

{% include image.html size="" file="desplazado.png" caption="" %}

Prestad atención sólo a la señal más intensa, de la izquierda. Las frecuencias de la derecha son debidas a la saturación. El pulso principal está en 4125 Hz. O bueno, en realidad estará por los 58 kHz, pero recordad que hemos desplazado la frecuencia para que sea audible. El eco en cambio ronda los 2500 Hz. Como las dos frecuencias no coinciden el efecto es débil.

Además, decíamos que la frecuencia de resonancia variaba según estuviera magnetizada la placa polarizadora. Pues fijaos cómo la frecuencia del eco (eje horizontal) se aleja de la de los pulsos (línea vertical gruesa) cuando acerco y alejo un imán:

{% include image.html size="" file="acercoiman.png" caption="" %}

## Activación y desactivación

Las etiquetas sólo responden al campo magnético de 58kHz cuando la placa polarizadora está imantada, decimos entonces que está activada. Y si está desimantada no hay respuesta. Así que sólo tenemos que imantar y desimantar el metal.

Es un proceso sencillo pero que tiene su técnica. Por ejemplo, este vídeo: [Cómo imantar/magnetizar y desimantar/desmagnetizar un destornillador](https://www.youtube.com/watch?v=JRiSIXBV-aw). Para imantarlo hay que pasar el imán varias veces a corta distancia (tocando incluso).

Los metales ferromagnéticos (imantables) están formados por *dominios magnéticos* independientes. Que son como pequeños imanes en su interior. Al principio estos dominios están orientados al azar, y la magnetización resultante es cero, porque se anulan entre sí. Pero cuando acercamos un imán potente, lo que hacemos es orientar los dominios magnéticos. Haciendo que en lugar de anularse mutuamente, sumen sus fuerzas. Es cuando se manifiesta el magnetismo.

{% include image.html size="" file="Dominios.png" caption="" %}

Para desimantarlo hay que volver a colocar los dominios de forma aleatoria. O simplemente colocar la mitad para un lado y la mitad para el otro. Eso es lo que conseguimos cuando arrimamos el imán y lo alejamos rápidamente sin tocar. El truco está en hacerlo rápidamente. De esa forma sólo unos pocos dominios magnéticos se afectarán debido a la histéresis magnética.

Es lo mismo que si lo arrimamos y lo alejamos a un solenoide por el que pasa corriente alterna. En cada ciclo sólo unos pocos dominios se orientan siguiendo el campo; varios ciclos después prácticamente están orientados al azar. Precisamente así es como los sistemas comerciales desmagnetizan las etiquetas: con un pulso alterno y decreciente, que dura milisegundos.

Si estáis leyendo esto con la esperanza de que os diga cómo desactivarlas para robar, os lo diré: coged una tijera y cortarlas por la mitad. Ya está, no hay resonador que resista eso.

Como curiosidad, si apretáis con el dedo el lado blando aprisionáis las placas resonadoras. Recordad que todo esto se basa en una vibración mecánica. Si las sujetáis ya no hay vibración, no hay alarma.

## Detección

Una vez que hemos visto la señal en el PC, y que sabemos activarlas y desactivarlas, vamos a imaginar de qué manera detectaríamos la presencia de una etiqueta para disparar la alarma.

Estos son los algoritmos que a mi se han ocurrido, pues desconozco los algoritmos que se usan en aparatos comerciales. El software lo voy a hacer en Perl/Tk aprovechando la tarjeta de sonido, pero estas mismas técnicas se implementan sin problema en cualquier chip DSP.

*Primera versión: señal rectificada*

Si los pulsos con eco duran más que los pulsos sin eco, quiere decir que al rectificar la señal, habrá un incremento del valor cuando pongamos una etiqueta.

Sin entrar en detalles, la técnica para rectificar una señal por software es esta:

1. Multiplicar por una constante: que viene a ser como amplificar la señal de entrada.
1. Tomar el valor absoluto: que es como rectificarla usando un puente de diodos ideal.
1. Aplicar un filtro paso bajo en forma de media móvil exponencial. Que es, en esencia, un condensador para eliminar la alta frecuencia. Suena complicado, pero programarlo es sencillo.

```cpp
# Procesado de la señal
$x = $ampl*$x;  # amplificador
$x = abs($x);   # rectificador
$v = $v + $alpha * ($x - $v); # condensador de filtrado

$v > $v_max and $last_alarm = $t;
```

Ampl es el número de veces que amplificamos la señal. V es una variable que se modifica con cada muestra (esta es la que hace la media exponencial) y alpha es un factor que dice cuánto filtramos.

Si *alpha* es muy grande, quiere decir que los valores influyen más en la variable V. La media móvil se ajustará a la forma de la curva. Sería equivalente a utilizar un condensador de filtrado muy pequeño, con un gran rizado a la salida.

Si *alpha* es pequeño, los siguientes valores siguientes modifican poco la variable V. Es semejante a tener un condensador de filtrado grande. La salida es más limpia pero en este caso el problema es que cuando la señal sube o baja tarda demasiado en reaccionar.

Este tipo de filtros se llaman **IIR** (Infinite Impulse Response). Si os pica la curiosidad, en este artículo se explica cuál es la equivalencia entre el valor de *alpha* y la constante de tiempo de un condensador: [IIR](http://www.idsc.ethz.ch/Courses/signals_and_systems/lectureNotes10.pdf).

Rectificada y filtrada nuestra entrada, obtenemos estos valores:

{% include image.html size="" file="softv1.png" caption="" %}

Las partes más altas se producen cuando coloco una etiqueta activada entre las antenas. Es suficiente fijar un umbral *v_max* a partir del cual se dispare la alarma.

Este es nuestro software en reposo. La barra superior indica la amplitud actual de la señal recibida y filtrada. Con el potenciómetro modificamos el umbral máximo de disparo.

{% include image.html size="" file="detector_reposo.png" caption="" %}

En cuanto pasamos con la etiqueta sin desactivar la amplitud asciende, supera el máximo y suena un pitido:

{% include image.html size="" file="detector_disparado.png" caption="" %}

Entre el verde y el rojo, hay una zona amarilla que es de *incertidumbre*. La  señal es muy alta para provenir de pulsos normales, pero no tan alta como para detectar claramente una etiqueta activada. Puede ser simplemente ruido, puede ser una etiqueta activa pero defectuosa o puede que no se haya desactivado bien al pasar por caja y por tanto resuene a una frecuencia diferente a la principal con menos intensidad.

Se trata de una medida indirecta, que necesita una etiqueta claramente activa o inactiva, una señal muy fuerte y varios pulsos con eco seguidos para hacer subir el nivel por encima del disparo. Un valor de *alpha* de **0.0002** dispararía la alarma al cabo de, aproximadamente, una décima de segundo.

Tiene una tasa de falsos negativos relativamente alta. La gente podría llevarse cosas sin que la alarma saltara.

*Segunda versión: temporizar la duración*

Este otro algoritmo mide directamente la duración del eco. Se basa en lo siguiente:

1. Multiplicar por una constante: que viene a ser como amplificar la señal de entrada.
1. Restar el valor de la muestra inmediatamente anterior. Esto sería equivalente a un filtro paso alto. Pues eliminará las variaciones de baja frecuencia (lentas) en las que dos muestras consecutivas son muy parecidas y se quedará sólo con las altas frecuencias. Este se´ria un filtro de tipo **FIR** (Finite Impulse Response).
1. Tomar el valor absoluto. Rectificar, igual que antes.
1. Calcular el tiempo que pasa desde que se recibe el primer pico (comienzo del pulso) hasta que pasa un tiempo sin recibir más desde que se recibió el último (fin del pulso).

Con la diferencia entre los tiempos de comienzo y fin del pulso se decide si se trataba de un pulso plano (corto), o si por el contrario había alguna señal tras él (eco).

{% include image.html size="" file="softv2.png" caption="" %}

La línea horizontal es el **squelch**. Un punto a partir del cual decimos que es ruido de fondo y no lo tenemos en cuenta.

El algoritmo es un poco más complicado. No lo pego aquí pero lo tenéis disponible al final de la entrada. Es más rápido detectando, pero también más sensible al ruido y a las etiquetas mal desactivadas. Da muchos falsos positivos en ese sentido.

## Mejoras

¿Qué es peor un falso positivo o un falso negativo? ¿Es peor que alguien se lleve algo sin pagar, o que esté sonando continuamente?

Los falsos negativos hacen perder dinero al establecimiento. Merman la utilidad del dispositivo de seguridad que se vuelve poco eficaz a la hora de impedir hurtos. Por el contrario, las falsas alarmas irritan a los consumidores y hacen perder tiempo a los cajeros y a los vigilantes de seguridad. Los clientes perciben el dispositivo como algo molesto e inútil. Al final se trata de llegar a un compromiso que nunca es fácil.

Comercialmente es un campo aún abierto. Los fabricantes se esmeran en diseñar dispositivos anti-hurto más sensibles y difíciles de engañar, a la par que más fiables.

Si la salida es ancha no se puede poner una antena a cada lado porque la señal sería un débil para detectarla. Así que se ponen varias antenas. Por ejemplo una transmisora central y dos receptoras a los lados. Si es muy ancha hay que colocar varios pares RX/TX. Pero resulta que la antena transmisora de un establecimiento cercano podría interferir con la nuestra. Dando falsos positivos.

Lo que se hace a veces es dejar un tiempo entre los pulsos que no sea siempre el mismo como hemos hecho sino espaciarlos de forma aleatoria. Así cuando recibimos un eco sabemos si se corresponde con el pulso que envió nuestra antena o no.

Hay aparatos que emiten ruido en una frecuencia cercana 58kHz con la intención de saturar el receptor y sabotear el sistema. Es lo que se conoce como *jammer* o inhibidor. Esto dejaría a la tienda temporalmente indefensa ante un ladrón. A través de diversas técnicas de Procesamiento Digital, se vigilan no sólo los ecos sino también los pulsos, los espacios, frecuencia y duración de estos, o el decaimiento en la amplitud. Así, hay sistemas menos vulnerables a las interferencias y son capaces detectar el inhibidor y dar la alarma igualmente.

Espero que os haya resultado un tema interesante. Para terminar os dejo varios ficheros.

[Fichero básico]({{page.assets | relative_url}}/EAS_Antirrobo_basico.zip)

- Excel para el cálculo del circuito resonante.
- Excel para el cálculo de los temporizadores 555.
- Esquema del circuito transmisor en formato Eagle 5.11.
- Esquema para LTspice.
- Software de detección en Perl/Tk.
- Patente original en PDF.

[Fichero imágenes]({{page.assets | relative_url}}/EAS_Antirrobo_imag.zip)

- Imágenes y fotografías del proceso.
- Fuente de las imágenes compuestas en formato Gimp.

[Fichero sonido]({{page.assets | relative_url}}/EAS_Antirrobo_wav.zip)

- Capturas de sonido usadas en el artículo.

{% include image.html size="" file="IMAG0465.jpg" caption="" %}
