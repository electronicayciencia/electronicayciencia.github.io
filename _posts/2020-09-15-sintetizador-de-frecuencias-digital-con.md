---
assets: /assets/2020/09/sintetizador-de-frecuencias-digital-con
description: Un repaso a los PLL (Phase-Locked Loop) y a mis comienzos con la radio
  y la electrónica.
featured: 'true'
image: /assets/2020/09/sintetizador-de-frecuencias-digital-con/img/HEF4046BP-8649.jpg
layout: post
tags:
- Circuitos
- PIC
- Radio
title: Sintetizador de frecuencias digital con PLL
---

Los **PLL** son una pequeña asignatura pendiente de mis comienzos con la electrónica. Y antes o después debía dedicarles una entrada. Es curioso, después de tantos años, mirar hacia atrás y recordar aquellos tiempos en los que, en esencia, no tenías ni idea de lo que estabas haciendo.

Yo empecé a interesarme por la electrónica a principios de los 90. Había leído en una enciclopedia que un transistor era un componente con tres patillas y servía para amplificar señales. Encontré un juguete o radio rota con componentes de esos, como los de la foto. Corté uno (no sabía soldar), y lo conecté entre los terminales de un altavoz que vete a saber de dónde había salido. Cuando hablé por él no me pareció que mi voz sonara más fuerte. Aquello era frustrante; los libros mienten. Tendría unos diez añitos.

Al poco vinieron las revistas de electrónica, el soldador, y las emisoras; el ordenador tardó algo más. Entre mis primeros proyectos fallidos, un **previo** de recepción que atenuaba la señal en vez de amplificarla. Y un **amplificador** de micrófono que se convirtió -sin quererlo- en un oscilador.

El primer circuito que funcionó como debía fue un generador de baja frecuencia construido con el integrado CD4046. Y de él vengo a hablaros hoy.

{% include image.html size="huge" file="HEF4046BP-8649.jpg" caption="El primer integrado que compré.  
Por el código parece fabricado en 1986. EyC." %}

<!--more-->

## Primer contacto

PLL -decía mi libro- significa *Phase-Locked Loop* o, en español, bucle de enganche de fase. Se trata de un circuito integrado capaz de entregar una señal de igual frecuencia y en fase con otra señal de referencia. Al menos eso entendí yo en el año 94 o 95.

Si bien la definición del libro sonaba razonable, no terminé de encontrarle la utilidad a generar una señal **igual** a otra que ya teníamos. Ni cómo aquello nos permitía construir receptores más baratos y estables. Y, además, por qué hablaban de la fase cuando lo que buscábamos era la frecuencia.

Yo sabía muy poco de integrados. Todo mi conocimiento acerca del **CD4046** (de todos los PLL, en realidad) era que tenía un Oscilador Controlado por Tensión. VCO, en inglés. Lo había aprendido montando un esquema de una revista. A decir verdad ese número había salido como diez años antes. Pero un **radioaficionado** conocido fue tan amable de dejarnos su colección y acabé por fotocopiar varios artículos. Entre ellos, este.

{% include image.html size="huge" file="lx537.jpg" caption="El primer circuito que hice y funcionó.  
Economico Oscillatore di BF (N.E. 086-7)" %}

El CD4046, explican en el artículo, pertenece al grupo de los PLL y contiene en su interior un VCO muy fácil de usar. Sólo necesita una **resistencia** en la patilla 11 y un **condensador** entre las patillas 5 y 6. En función de los valores de estos componentes, el VCO oscilará entre unas frecuencias máxima y mínima dependiendo de la tensión aplicada en la patilla 9. Con el diagrama anterior, el circuito oscila desde 10 Hz hasta 1 MHz en cinco bandas cambiando el condensador.

La resistencia es la que veis en el esquema nombrada como **R5**. Para el condensador usan **C5** a **C10**. Uno para cada banda. A menor capacidad, oscilaciones más rápidas. Con el potenciómetro **R2** se varía la tensión aplicada en la patilla 9. Los demás componentes son accesorios, dotan de estabilidad al circuito, control de volumen, etc.

Diseñar un oscilador es **fácil**. Hasta sin querer. Lo difícil es que funcione justo a la frecuencia que necesitas y, sobre todo, no se mueva de ahí.

Porque el circuito anterior, cuando se le agota la pila, la frecuencia **varía**. Con los cambios de temperatura, varía. Cuando las resistencias y los condensadores envejecen, varía. Según tolerancia de los componentes y la longitud de los cables, varía. Y si tocamos alguna patilla o simplemente nos acercamos mucho... lo has adivinado, también varía.

Por otro lado, construir un oscilador estable no es tan complicado. Ahí tienes por ejemplo los **cuarzos**. Su tolerancia se mide en partes por millón y se hacen para la frecuencia que pidas. Eso sí, son poco prácticos. Porque para cambiar de canal necesitas otro cuarzo.

¿Podríamos proyectar un oscilador tan estable como uno de cuarzo, pero cuya frecuencia varíe fácilmente? Quizá sí. Pero sería complejo y caro. Apropiado tal vez para un laboratorio, no para una radio doméstica.

La solución está en una técnica bien conocida: la **realimentación**. Y así nació un integrado que aprovecha la estabilidad del cuarzo a una frecuencia dada para controlar un oscilador a **otras frecuencias**. Es ahí donde está lo interesante.

A ver, es la aplicación más básica de un PLL. Después resulta que tienen muchas otras aplicaciones, aquí sólo te voy a contar esa. Aunque antes necesito **repasar** una cosa contigo. ¿Sabes cómo funciona un operacional?. En el fondo son muy parecidos.

## Cómo amplifica un operacional

A poco que hayas visto algo de electrónica te sonarán los amplificadores operacionales. Configuración inversora, dos resistencias y marchando.

En la vida real la cosa no es tan simple. Si tu señal es simétrica necesitas alimentación dual. Y, si no la tienes, debes crear una masa virtual hacia la mitad de la alimentación usando un divisor resistivo. Y luego, por supuesto, aislar la entrada y la salida con sendos condensadores. Me llevó varios años entenderlo.

Sin embargo no vamos a empezar por ahí. Empezaremos por esta otra configuración. Mas simple. El seguidor de tensión:

{% include image.html size="medium" file="op_amp_buffer.png" caption="Buffer no inversor o seguidor de tensión. EyC." %}

Cuando, como aficionado, lees sobre este circuito te cuentan cómo la salida es igual a la entrada. Eso es **casi** verdad. Salvo por una *millonésima* parte.

Imagínate el amplificador operacional como dos circuitos juntos: uno que **resta** las dos entradas y otro que **amplifica** la diferencia una barbaridad.

En esta configuración, una entrada la fijamos nosotros y la otra está midiendo directamente cuál es la tensión de salida.

Ahora supón que ponemos **1 voltio** en *Vin*. Como *Vout* (y por tanto la otra entrada) estaban a cero, el amplificador resta y multiplica esa diferencia por **muchiiisimo** (entre cien mil y un millón). La salida subirá hasta su valor máximo. Pero conforme empieza a crecer y se aproxima a 1 V, la **diferencia** entre ambas entradas se hace menor. Si *Vout* llegara a exactamente 1V serían iguales, y la salida valdría 0. Pero eso no va a pasar, porque se llega a una situación estable cuando la salida se queda a una distancia tal de la entrada que ese valor multiplicado por la ganancia nos dé el propio valor de salida.

Como la ganancia ronda el **millón**, una entrada quedará a una millonésima de voltio de la otra. A efectos prácticos sí, diremos que ambas entradas alcanzan el mismo valor, y que por tanto la salida es igual a la entrada. Pero sabemos que no es así, porque si las dos entradas fueran **idénticas**, la salida en realidad **sería cero**.

{% include image.html size="huge" file="entrada-salida-buffer.png" caption="La tensión de salida es casi igual a la de entrada. El casi es la clave. EyC." %}

Un amplificador operacional es un dispositivo que amplifica la diferencia entre sus dos entradas. Si cerramos el bucle amplificará hasta ver en sus dos entradas el mismo valor. Él *quiere* ver sus entradas al **mismo potencial**.

Sigamos. El buffer no es la aplicación más típica de un operacional. Lo normal es usarlo para **amplificar**.

¿Cómo lo conseguimos? *engañando* al circuito. Así:

{% include image.html size="medium" file="op_amp_non_inv_ampl.png" caption="Amplificador no inversor. EyC." %}

Esta vez no conectamos la otra entrada directamente a la salida, sino que lo hacemos a través de un **divisor resistivo**. El amplificador no está midiendo la tensión en la salida, sino sólo una fracción de la misma.

Imagina que **R1** y **R2** valen igual, por ejemplo 1k. En ese caso, la tensión en la entrada inversora será **la mitad** del valor en la salida.

Si ahora ponemos **1 V** en *Vin* como antes, el operacional empezará a amplificar. Cuando la salida llegue a 1 V, en la entrada inversora tan solo habrá 0.5 V. Seguirá amplificando hasta **igualar** ambas entradas. Para cuando eso ocurra, habrá llevado la salida hasta los 2 V. El **doble** de *Vin* (menos una millonésima parte, eso lo obviamos).

No queda ahí la cosa. Si en lugar de por 2, usáramos un divisor por 10 (para lo cual R1 debe ser 9 veces R2) el amplificador situará su salida a 10 veces el nivel de entrada. Consiguiendo así igualar las tensiones de las entradas.

En resumen, como ya sabías -o al menos intuías-, intercalando un **divisor** en el lazo de realimentación, **multiplicaremos** el valor de salida.

Esa es la clave del asunto. Y verás, no pasa sólo con amplificadores, vale para cualquier circuito **realimentado**.

## Cómo trabaja un PLL

Un PLL sirve para incorporarlo a un oscilador y conseguir que se sintonice **él sólo** a la frecuencia deseada. Es más, que corrija automáticamente cualquier desviación.

Volviendo al generador de BF, el esquema del principio, piensa cómo sería tener un *algo* automático ajustando el potenciómetro **R2** continuamente. Dicho automatismo mantendría la frecuencia fija frente a cambios en la tensión de alimentación, temperatura, tolerancias, etc. ¿Te interesa?

Empecemos viendo el equivalente al seguidor de tensión pero con frecuencias.

Aquí también tenemos un circuito para restar. Restar frecuencias, se entiende. Como la comparación se hace en el instante actual, no estamos comparando realmente las frecuencias, sino las fases de las ondas. Por eso a esta etapa la llamamos **comparador de fase**.

¿Cómo se restan dos frecuencias? Depende del chip. El **NE565**, por ejemplo, las multiplica y aplica un filtro paso bajo. En cambio, el **CD4046** presupone señales cuadradas y emplea mecanismos más simples. Uno de ellos es un XOR (comparador tipo I), y el otro un biestable con más cosas (tipo II). Ahora lo veremos.

A la salida del comparador de fase encontraremos una tensión diferente según la fase de las entradas. Por ejemplo, en el comparador de fase tipo II, si las dos fases son **iguales** la salida está a nivel **flotante**. Si una empieza antes que la otra, te da pulsos positivos o negativos según cuál de las dos vaya más rápido.

Lo importante ahora no es cómo funciona por dentro, sino su utilidad práctica. Veamos el montaje más común. Como os decía, el equivalente al *seguidor de tensión*.

{% include image.html size="huge" file="phase_comp_II.png" caption="El equivalente al seguidor de tensión, pero con frecuencias. EyC." %}

El comparador de fase de **tipo II** se comporta como un interruptor de tres posiciones. En este dibujo, la frecuencia **Fref** es más rápida que la del VCO. Por eso la salida del comparador emitirá pulsos **positivos**. Aumentará la **carga** del condensador, y también la **tensión de control** del VCO. Como la frecuencia del oscilador es proporcional a dicha tensión, aumentará con ella. Dicho de otra forma, si el oscilador va más lento que la señal de referencia, el PLL subirá su tensión de control para incrementar la velocidad de oscilación.

Cuando la frecuencia del VCO (*Fin*) se **iguala** con *Fref*, la salida del comparador queda **flotante**; o sea, en estado de **alta impedancia**. Como la impedancia de entrada del VCO también es muy alta, el condensador mantendrá su carga actual y la frecuencia no se moverá de ahí.

Si la oscilación del VCO fuera más rápida que la de referencia, el comparador emitiría pulsos a masa. Descargando el condensador y por tanto bajando la tensión de control y la frecuencia.

Esta *Fref* podríamos generarla con un oscilador muy estable; un **cuarzo** por ejemplo. Y así, aunque nuestro VCO fuera muy básico, vemos como el PLL lo regula automáticamente buscando siempre la frecuencia de entrada.

Decían los libros que *un PLL es un integrado capaz de entregar una señal de igual frecuencia y en fase con otra señal de referencia.* ¿Lo entiendes ahora?

Sí, este esquema tiene su utilidad, igual que el seguidor de tensión de antes. Pero su verdadero potencial se muestra cuando insertamos un **divisor** en el bucle de realimentación.

Un divisor de frecuencia no es tan sencillo como uno resistivo, luego lo veremos, pero es relativamente fácil con electrónica digital.

{% include image.html size="huge" file="phase_comp_II_div.png" caption="Insertando un divisor en el bucle de realimentación, multiplicamos la salida. EyC." %}

Ahora el **comparador** no ve lo que hay a la salida, sino una fracción. Supongamos un divisor por 2. Si en *Fref* ponemos **1 kHz**, cuando el oscilador esté a 1 kHz el comparador sólo va a recibir la **mitad**, 500Hz. Por tanto va a cargar más el condensador. Así hasta conseguir imitar la frecuencia de entrada. Es decir, cuando el VCO llegue exactamente al **doble**, 2 kHz.

Si el divisor fuera por 100, a la salida tendríamos 100 kHz. Y -lo mejor de todo- 100 kHz que serían **tan estables** como el oscilador fijo de referencia.

Variando la razón del divisor es posible generar **múltiplos** de la de referencia y recorrer así una banda a intervalos fijos. Tan sólo debemos escoger una frecuencia de referencia igual a la **separación entre canales** (o submúltiplo de esta).

## Un ejemplo práctico

La **Onda Media** en Europa va desde 522 a 1620 kHz, en canales separados 9 kHz. Es decir, frecuencias 522, 531, 540, ..., 1611 y 1620. Sólo necesitaríamos una frecuencia de referencia de 9 kHz, y un divisor que vaya entre 58 y 180. Así, 9 x 58 nos daría 522 kHz, el límite inferior; y 9 x 180 serían 1620 kHz, el límite superior.

A frecuencias tan bajas no es habitual usar un PLL. Salvo para generar la frecuencia intermedia o para demodular la señal, aplicaciones muy interesantes por otra parte.

La banda de **FM comercial** de 87.5 a 108 MHz también está separada por canales de 50, 100 o 200 kHz según el país.

Pero no hay que irse a frecuencias tan altas. La estabilidad de los osciladores comienza a plantear problemas a partir de los 10 megahercios. Pensemos, por ejemplo, en la **Banda Ciudadana** de 27MHz (CB-27). En España, esta banda va desde 26.965 MHz hasta 27.405 MHz en *40* canales separados 10 kHz.

Una de mis primeras emisoras fue una modesta [*President Wilson*](http://www.rigpix.com/cbfreeband/president_wilson.htm) de segunda mano. Cabe recordar que la marca President tenía distintos modelos de emisoras con nombres de presidentes estadounidenses. Desconozco el criterio para elegir el nombre, pero por ejemplo la President **Harry** o Wilson eran muy sencillas, 40 canales AM y (algunos modelos) FM. Mientras la **President Lincoln** era un equipo muy potente que -en teoría- ni siquiera era apropiado para CB.

{% include image.html size="huge" file="president_wilson.jpg" caption="La President Wilson, una de mis primeras emisoras. [www.rigpix.com](http://www.rigpix.com/cbfreeband/president_wilson.htm)." %}

Si no recuerdo mal, los diseños eran de Uniden (empresa japonesa) y los comercializaban otras marcas como President, Galaxy, Cobra o SuperStar. A veces tal cual, a veces mejorando algunas partes como los filtros.

Los equipos más sencillos no contaban con LCD ni microcontrolador. Tan sólo un **doble display LED** de 7 segmentos donde se mostraba el canal del 01 al 40. Cuando, de pequeño, miraba las tripas siempre me preguntaba cómo podían dar esas 40 frecuencias diferentes con un sólo cuarzo. Un cristal, además, de 10 MHz. ¡Ni siquiera se acercaba a los 27 MHz!

{% include image.html size="huge" file="Uniden-PRO-510XL-1987.JPG" caption="Interior de una Uniden PRO 510XL de 1987. Click para ampliar. www.elektroda.pl" %}

Llevaban un **selector mecánico** de canal. Un encoder de 40 posiciones, parecido a un programador de lavadora. En la imagen es ese componente blanco y verde arriba a la izquierda.

El display LED 7 segmentos iba directamente conectado al selector. Según girabas el mando, se llevaban a masa distintas patillas, encendiendo los leds adecuados para formar el número del canal. Por supuesto olvídate de cambiar el canal desde el micrófono o de escanear automáticamente.

Os lo cuento porque estos equipos utilizaban un **ingenioso** mecanismo para seleccionar las frecuencias.

Justo al lado vemos el chip **SM5124A** de *Nippon Precision Circuits Inc*. Se trata de un PLL especialmente diseñado para esta función. Dentro contiene un **divisor** de entrada que divide la frecuencia de referencia entre 1024 (aproximadamente). Por tanto ese cuarzo de 10.2418 MHz se convierte en 10 kHz y un poco más.

A partir de ahí, obtener la frecuencia deseada sólo es cuestión de multiplicar por el valor adecuado. Una ROM dentro del chip tiene programados los valores de división para cada canal. Por ejemplo para obtener 27.005 MHz (canal 4) inserta un divisor por 2700. El PLL ajustará el VFO hasta llegar a 27.000 MHz (los decimales dan los 5 Hz que faltan). Para obtener 27.405 (canal 40) el divisor es de 2740.

¿Y cómo se selecciona el divisor? Pues fíjate el esquema propuesto por el fabricante ([datasheet]({{page.assets | relative_url}}/SM5124A.pdf)). Lo he simplificado para facilitar la lectura.

{% include image.html size="huge" file="SM5124A_typical.png" caption="Aplicación típica del SM5124A. Datasheet del fabricante." %}

La líneas **P0 a P7** van conectadas en paralelo con ciertos segmentos del display LED. Mirando los **LEDs encendidos**, el chip "ve" el canal mostrado en pantalla y selecciona el divisor correspondiente. En mi opinión ingenioso y un buen ejemplo de *aplicación de nicho*.

Como el SM5124A no incorpora VCO debe usarse con un **oscilador externo**. Si bien este puede ser muy sencillo. Ya se encarga el PLL de monitorizar la salida y ajustar la tensión de referencia para la frecuencia que necesitamos. La imagen siguiente está tomada del esquema de una Uniden 520.

El diagrama original lo obtuve de [www.cbtricks.com]({{page.assets | relative_url}}/uniden_pro_520e_sm_sch.jpg). He hecho una [copia en GitHub]({{page.assets | relative_url}}/uniden_pro_520e_sm_sch.jpg) por si en el futuro deja de estar disponible. Del original he eliminado todo salvo las partes que nos interesan: el PLL y el VCO. Para facilitar la legibilidad he eliminado algunos componentes, tal vez los echéis en falta.

{% include image.html size="huge" file="uniden_pro_520e_vco.jpg" caption="Esquema de la Uniden Pro 520e mostrando sólo el VCO y el PLL. EyC." %}

Las patillas 10 a 17 van a los segmentos LED y le dicen al integrado el canal activo. Entre la 1 y la 2 se conecta el cuarzo de referencia. La patilla 7 es la salida del **detector de fase**. Tras filtrarla con un condensador, aplica la tensión de control al VCO. En esa línea hay un punto de ajuste (Test Point 1).

La tensión aplicada llega hasta el diodo **varicap** en la base del transistor Q702 señalado como **D701** (parece) y regula la frecuencia del oscilador. Este oscilador, como decíamos, puede ser muy sencillo. Pues de estabilizar la frecuencia ya se encarga el PLL. La señal generada vuelve a través de R64 hasta la patilla 9 del integrado. Donde se dividirá y comparará con la de referencia para **cerrar el bucle**.

Este método sirve para recorrer bandas con **canalización fija**. Se puede sintonizar una frecuencia arbitraria usando un divisor fraccionario. Pero esto es tema aparte del que habíamos hablado algo en la entrada titulada [Raspberry Pi como generador de frecuencias]({{site.baseurl}}{% post_url 2017-05-01-raspberry-pi-como-generador-de %}).

## Sintetizador con PIC y PLL

Ha llegado la hora de rescatar aquel **HEF4046BP** (era la versión moderna) que compré hace 25 años y utilizarlo al fin como PLL.

Para poner en práctica las ideas de este artículo programaré un **PIC**. Con él generaré la frecuencia de referencia y también lo usaré como divisor programable. Os pego el esquema y seguidamente lo comentamos:

{% include image.html size="huge" file="esquema_editado.jpg" caption="Sintetizador digital a PLL. Click para ampliar. EyC." %}

El **PIC16F88** tiene un oscilador interno, no necesito usar un **cuarzo**. Lo he configurado para trabajar a 8 MHz, es decir, 2 MIPS. Teniendo esto en cuenta, ajusto el generador de PWM para una frecuencia de 1 kHz y un *duty-cycle* del 50%.

El **código fuente** del programa lo tenéis en GitHub. No lo pego para no alargar el artículo.

- [soft_pic/main.h](https://github.com/electronicayciencia/pll_4046/blob/master/soft_pic/main.h)
- [soft_pic/main.c](https://github.com/electronicayciencia/pll_4046/blob/master/soft_pic/main.c)

Así quedaría montado sobre una protoboard:

{% include image.html size="huge" file="pll_protoboard.jpg" caption="Circuito montado sobre la protoboard. EyC." %}

Funciona de la siguiente manera. La señal cuadrada de 1 kHz sale por la patilla **6** del PIC, llamada **CCP1**, y la inyectamos como señal de referencia en la patilla **14** del 4046.

El VCO interno del PLL se configura con el condensador **C3** y la resistencia **R3**. Los valores no son críticos, y menos aún tratándose de un proyecto sólo para demostrar el uso del integrado. Bastará cualquiera que tengáis a mano. Solo influirá en el rango de frecuencias posibles. Tened en cuenta que si le pedimos una frecuencia mayor o menor que las que pueda generar el VCO con los componentes elegidos, el PLL **no enganchará**. Y si el oscilador puede oscilar muy deprisa pero le fijamos una frecuencia muy baja, tampoco enganchará bien.

La señal generada por el PLL sale de la patilla **4** (VCO_OUT) y la recibimos en **T0CKI** del PIC. Se trata de la entrada del **contador asíncrono** TMR0. Este contador se incrementará en una unidad en cada **flanco de subida** de la patilla T0CKI. Cuando el contador llegue a 256 pulsos generará una **interrupción**.

El truco está en que no es obligatorio inicializar TMR0 a 0, sino que podemos inicializarlo a 255 y la interrupción se generará en el primer pulso que recibamos. O inicializarlo a 245 y se producirá transcurridos 10 pulsos. Este es el fundamento de nuestro divisor.

Un inciso, la entrada asíncrona del PIC puede trabajar muy por encima de la velocidad nominal de reloj. En el artículo llamado [Frecuencímetro para el PC]({{site.baseurl}}{% post_url 2011-07-20-frecuencimetro-para-el-pc %}) lo habíamos usado para medir frecuencias en la banda de 144 MHz.

Es más, ¿te acuerdas de que cuando un operacional estaba funcionando en lazo cerrado la tensión en sus dos entradas era la misma. Bueno pues aquí pasa lo mismo. El PLL se encargará de que estas interrupciones se sucedan con la misma cadencia que la **frecuencia de referencia**, da igual la frecuencia real de salida del VCO. Piénsalo.

Volviendo al tema, con cada interrupción alternaremos el valor de la salida **RA0**. En el primer flanco de subida cambiaremos de 0 a 1, y en el segundo de 1 a 0. Luego un periodo completo de la salida exige dos periodos en la entrada. Estaremos haciendo un **divisor por 2**.

Si inicializamos TMR0 en 250, se producirá la interrupción al quinto pulso y volverá al estado inicial tras 10 pulsos. Sería un divisor por 10. Si cada semiperiodo durase 10 pulsos, sería un divisor por 20. Y así dividimos por cualquier **número par.**

Para hacer una **división impar**, tendríamos que contar diferente número de pulsos en el semiperiodo positivo y en el negativo. Como en esta imagen. Dividimos por 5 haciendo que el semiperiodo positivo dure 2 periodos y el negativo 3. En total 5.

{% include image.html size="huge" file="div_by_5.png" caption="Para dividir entre un número impar los semiperiodos deben ser desiguales. EyC." %}

La frecuencia de entrada señala 5000 Hz (esquina inferior derecha), mientras la de salida es sólo 1000. El duty cycle ya no es del 50%. No importa, porque el PLL se encargará de **ajustar** la oscilación para generar una onda cuadrada centrada lo mejor que pueda en esa frecuencia.

Finalmente, la frecuencia dividida la tomamos de **RA0** y la aplicamos a la entrada del comparador de fase **COMP_IN** (patilla 3 del 4046). Con esto cerramos la **realimentación** del PLL.

Los pulsos del comparador de fase salen por **PC2_OUT**. Los usamos para cargar el condensador **C2** a través de la red formada por **R1** y **R2**. De nuevo los valores no están calculados. No son los más adecuados. Depende del rango de frecuencias con que trabajes te puedes encontrar con que no engancha, engancha pero sólo si ya estaba enganchado de antes, autooscila y cosas así. Los circuitos realimentados luego tienen mucha miga y no es cuestión de explicarlo ahora.

Las patillas **10** y **11** del PIC las conectamos a dos pulsadores. Uno **incrementa** el valor de la división, y el otro lo **decrementa**.

El efecto neto es un sintetizador de frecuencias a intervalos de 1 kHz. Aquí lo vemos en acción. Mira cómo al pulsar los botones, la tensión de control del VCO sube y baja para **ajustarse** a la frecuencia. Y esta siempre son múltiplos de 1 kHz.

{% include youtube.html id="_35BPt36gk4" %}

Espero que os haya gustado. Os dejo los datasheet, imágenes y fuentes en el repositorio [GitHub de electronicayciencia/pll_4046](https://github.com/electronicayciencia/pll_4046).

Enlaces de interés:

- [Basics of Phase Locked Loop Circuits and Frequency Synthesis - w2aew (video - inglés)](https://www.youtube.com/watch?v=SS7z8WsXPMk)
- [Fundamentals of Phase Locked Loops (PLLs) - Analog Devices (inglés)]({{page.assets | relative_url}}/MT-086.pdf)
- [Ask the Applications Engineer: PLL SYNTHESIZERS - Analog Devices (inglés)]({{page.assets | relative_url}}/AN-30.pdf)
- [Nuova Elettronica 086-087 (italiano)]({{page.assets | relative_url}}/086-087_Nuova_Elettronica.pdf)
- [Frequency synthesizer - Wikipedia](https://en.wikipedia.org/wiki/Frequency_synthesizer)

Entradas del blog relacionadas:

- [Demodular AFSK, desde cero]({{site.baseurl}}{% post_url 2017-10-28-demodular-afsk-desde-cero %})
- [Raspberry Pi como generador de frecuencias]({{site.baseurl}}{% post_url 2017-05-01-raspberry-pi-como-generador-de %}).
- [La Distorsión Armónica Total (THD)]({{site.baseurl}}{% post_url 2013-03-26-la-distorsion-armonica-total-thd %})
- [Frecuencímetro para el PC]({{site.baseurl}}{% post_url 2011-07-20-frecuencimetro-para-el-pc %})
