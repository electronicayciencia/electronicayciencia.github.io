---
assets: /assets/2010/06/utilizar-un-microfono-electret
featured: 'true'
image: /assets/2010/06/utilizar-un-microfono-electret/img/conn_electret.png
layout: post
tags:
- Circuitos
- Sensores
title: Utilizar un micrófono electret
---

Habíamos publicado en [esta entrada]({{site.baseurl}}{% post_url 2010-05-28-preamplificador-microfono-electret %}) los pasos a la hora de registrar una señal, concretamente una señal sonora. Habíamos planteado más o menos estos:

1. Crear la señal en las mejores condiciones: adecuar el experimento y el entorno circundante para maximizar la señal útil y minimizar otras señales y el ruido.
1. Captar la señal generada lo mejor posible. Un buen micrófono, con una respuesta adecuada a lo que queremos, tanto en frecuencia como en presión sonora.
1. Transferir la señal utilizando canales poco ruidosos (conductores apantallados).
1. Cuidar la electrónica para no amplificar señales no deseadas.
1. Preparar los filtros y procesado posterior. IMPORTANTE: hay que captar la señal *entera* y después, **sólo después** filtrarla y procesarla. Si primero la procesamos perdemos sin remedio la señal original y con ella matices que más tarde podríamos necesitar.
1. Utilizar un medio de registro de calidad apropiada, ya sea en soporte físico o electrónico.

Vamos a ocuparnos en esta entrada del punto 2: utilizar un micro adecuado y bien preparado. Le prestaremos especial atención a las **cápsulas del tipo electret**, cuya relación calidad/precio es de lo mejorcito del mercado.

<!--more-->

Cuando decimos *el micro adecuado*, igual que *[la chispa adecuada](http://www.dailymotion.com/video/x1qxhu_la-chispa-adecuada-heroes-del-silen_music)*, debemos pensar que, de la amplia variedad disponible, conviene usar el que mejor se ajuste a lo que queremos captar. Un micro piezoeléctrico por ejemplo no nos servirá para la voz, pero será nuestra única opción para grabar ultrasonidos. Un micro de carbon responde justo en las frecuencias de la voz, sin embargo su sensibilidad es pobre. Uno de condensador es mejor, pero necesitamos un voltaje extra y un circuito complicado para que funcione.

Lo bueno del micrófono electret es que tiene las ventajas del de condensador, y la electrónica requerida es muy básica. Ventajas:

- Para empezar es barato y fácil de encontrar.
- Buena respuesta en frecuencia en todo el rango audible (casi plana en algunos modelos).
- Está preamplificado internamente luego entrega una señal bastante alta en comparación.
- Es resistente.
- Se alimenta con una tensión de entre 2 y 12V, fácilmente disponible.
- Poco ruidoso.
- Muy sensible.

Sin embargo tiene un par de inconvenientes:

- Saturación a alto volumen. El preamplificador interior se satura cuando recibe una presión sonora alta, por ejemplo si hablamos cerca. Cosa que con otros micrófonos no es tan fácil que pase. Este inconveniente lo solucionaremos con una modificación más adelante.
- Baja respuesta en tonos altos. Esto lo hace inservible para ultrasonidos -al menos las cápsulas habituales-. A veces esto también una ventaja, porque al no captar esas interferencias inaudibles no necesitamos tampoco filtrarlas.

## Direccionalidad

Cuanto más ángulo abarca la recepción más señales captaremos y también más ruido. Si queremos captar una señal concreta y no otras lo mejor es usar un micro direccional. De lo contrario si la señal es débil puede perderse entre el ruido ambiente. Convertir de forma casera un micro omnidireccional en otro direccional es fácil. Claro que no obtendremos los mismos resultados con uno comercial.

Hay dos maneras:

- Blindando todas las direcciones salvo la que nos interesa. Es decir metiendo el micro dentro de *un tubo*. Impedimos que el sonido entre por los laterales y por detrás. Mientras más largo y ancho más potencia sonora captaremos de la dirección en la que apunte. Por la geometría del tubo se producen ecos y resonancias en determinadas frecuencias. No deseamos eso, para evitarlo en lo posible se hacen unos cortes o estrías transversales. Para no captar el soplido del viento se recubre con esponja la entrada del tubo así como parte del interior.

- Añadiendo un reflector. Si ponemos una pantalla por detrás evitamos captar lo que haya a la espalda a la vez que reflejamos lo que provenga del frente y mejoramos su recepción. Habitualmente se usa un reflector que además concentre todo lo reflejado en un punto. Tal propiedad es típica de las parábolas. Al igual que con el tubo, mientras mayor sea el diámetro del reflector, y por tanto su área, mayor [intensidad sonora](http://es.wikipedia.org/wiki/Intensidad_sonora) vamos a captar.

Como siempre dependerá de lo que necesitemos en cada momento. Pero por dar unas cuantas ideas:

- **Un tubo de cartón.** Es lo mejor para captar una señal que se produce relativamente cerca pero en un ambiente ruidoso.
- **Un paraguas.** Perfecto para espacios abiertos, para registrar trinos de pájaros desde lejos sin alterarlos, por ejemplo o también conversaciones lejanas. Incómodo y poco discreto por otro lado. En [esta web](http://www.instructables.com/id/Dollar-Store-Parabolic-Mic/) explican cómo fabricar uno.
- **La tapa de un cubo de basura.** Versión más portatil que el paraguas. También da buenos resultados pero en este caso tendremos que poner nosotros el eje para sujetar el micro.
- **Un embudo.** La típica trompetilla que sustituye al audífono. Da buen resultado en distancias cortas.
- **Una botella.** Mi opción favorita, una botella de plástico sin fondo. Combina lo mejor del receptor parabólico con la direccionalidad del tubo. Sencilla de construir y de llevar. Sin embargo es muy fácil captar ruidos del mismo plástico. En [esta web](http://www.openobject.org/objectsinflux/?p=22) utilizan como reflector el de un flexo.

Todo eso contando, claro, que vamos a usar el micrófono para captar señales en el ambiente **a través del aire**. No es el único modo. Tal vez nos viniera mejor apoyar el micrófono contra un cuerpo sólido para obtener sonidos del interior -como en un fonocardiograma- o que se transmiten a través de él -como terremotos, o conversaciones de otra habitación-. Puede que también queramos oír sonidos que se propagan a través del agua -como un motor de barco, o el sonido de los delfines-. En esos casos habría que pensar en hacer nuestra sonda de otra manera para adaptarla a esas condiciones. Eso ya queda fuera de esta entrada.

## Cómo conectar una cápsula electret

Hay decenas de páginas que explican cómo conectarla. Cuando compras una, a veces trae un papelito con el esquema. En esta imagen se ve bien (encontrada [aquí]({{page.assets | relative_url}}/electret.png)):

{% include image.html size="" file="conn_electret.png" caption="" %}

En realidad un micrófono electret no necesita ningún tipo de alimentación. Lo que ocurre es que los que encontramos en las tiendas son micrófono electret **preamplificados**. Es ese preamplificador interno lo que hay que alimentar, sin él, la salida que entrega el micrófono sería muy pequeña y difícil de manejar. El diagrama superior no está simplificado, el preamplificador es así de sencillo. Consta sencillamente de un FET conectado como *[Common Source](http://en.wikipedia.org/wiki/Common_source)*. Sólo que sin resistencia en la fuente. Esto último puede ser contraproducente, más abajo explico una modificación sencilla si nos trae problemas.

El valor de los componentes no es crítico.

Para el **condensador** se puede usar cualquier capacidad entre 220nF y 220µF, siempre que tengáis en cuenta que actúa como un filtro pasa-altos, y las frecuencias bajas se pueden perder si utilizáis capacidades muy bajas. Esto ya lo explicamos [aquí]({{site.baseurl}}{% post_url 2010-05-28-preamplificador-microfono-electret %}).

En cuanto a la **resistencia**, la ganancia es directamente proporcional a su valor, pero al aumentarla también [aumenta la capacidad interna](http://en.wikipedia.org/wiki/Miller_effect) del FET y limita por arriba la banda pasante. Por otro lado la **impedancia de salida** del micro va a ser igual a esta resistencia, y nos interesa que sea baja. Además cuando esta resistencia es alta, pasa menos tensión por el FET, así que se satura antes. Hay que alcanzar un valor de compromiso. Se suelen usar de entre 470Ω para alimentarlo con 5V y 2.200Ω para hacerlo con 12V. Si dudais, como regla general limitad la corriente a 1mA.

La **tensión de alimentación** no es que tengamos que calcularla, y en la mayoría de casos ni podemos elegirla. Pero debéis tener en cuenta que la tensión máxima que entrega el micro va en función de su alimentación. Es decir con tensiones de 5V el micro se va a saturar a volúmenes más bajos que si lo alimentamos con 12V. Para captar voz o señales muy débiles no será un problema. Pero para grabar otros sonidos más intensos quizá no nos sirva. La tensión máxima ronda los 20V.

## El interior de la cápsula

Decía que el amplificador era solamente un FET. He desmontado una cápsula electret y aquí veis sus partes:

{% include image.html size="" file="BENQ0005.JPG" caption="" %}

- **A.** Cubierta metálica. Protege y aisla el dispositivo.
- **B.** Arandela aislante. Se interpone entre las partes D y E para separarlas eléctricamente.
- **C.** Estructura de plástico. Da forma al interior.
- **D.** Material *electret*. Es una de las placas del condensador. Se trata de un dieléctrico al que se le han incorporado cargas fijas. De esa forma no necesitamos una tensión adicional para alimentar el condensador, sino que utilizamos un material que está cargado de forma permanente. Su marco está en contacto con la cubierta metálica.
- **E.** Placa de metal. La otra placa del condensador. Por su parte de arriba está enfrentada al electret mientras que por abajo conecta con la *puerta* del FET.
- **F.** FET. Es un 2SK596, abajo os dejo el datasheet. Parece que está diseñado en concreto para este uso.
- **G.** Placa de circuito impreso. Ahí van soldados los cables, y también el FET. Observad que el terminal superior corresponde al *drain*, y inferior al *source*. Y este último tiene una pista que va a la carcasa exterior. De ahí deducimos que el FET está configurado como *common source*.

Dijimos que el marco de D (que va a la cubierta y esta a tierra) y E (la *puerta* del FET) están separados por un aislante B. Ahora bien como ningún aislante es perfecto, lo podemos ver como una resistencia de un valor muy muy alto. Entonces pasa una pequeña corriente a su través, que conecta la *puerta* con la tierra. Esa va a ser nuestra tensión de polarización I<sub>G</sub>.

## Adaptación para sonidos muy intensos

El que las cápsulas estén preamplificadas es una ventaja para registrar sonidos débiles, pero son inservibles para sonidos intensos porque el amplificador se satura y entrega una señal distorsionada. No obstante hay varias cosas que podemos hacer si necesitamos usarla para sonidos fuertes. Esta lista va encaminada a reducir la ganancia del FET. Ampliamos el **rango dinámico** a costa de no preamplificar las señales débiles.

1. Aumentar la tensión de alimentación. Con un sonido fuerte la salida del micrófono puede ser fácilmente de 1V. Alimentarlo con 1.5V o 2V es claramente insuficiente en este caso. Hay un límite máximo de 20V que no podemos superar porque el micro dejaría de funcionar correctamente.
1. Disminuir la resistencia en serie. Con un mayor paso de corriente es más difícil que el FET se sature. Como efecto colateral, reducir la resistencia también reduce la ganancia. Por supuesto hay un límite también. Porque el amplificador es muy básico, no tiene resistencia de realimentación ni degeneración del drenador.
1. Modificar la conexión del FET. Se trata de cortar la pista de la parte G que habíamos nombrado antes. Para que el *source* ya no vaya conectado a masa. Así podemos reconectar el FET para que está conectado en **drenador común**, no hay amplificación pero a cambio la zona de trabajo es mucho más lineal. En esta imagen que sigue, obtenida de [http://sound.westhost.com/project58.htm](http://sound.westhost.com/project58.htm), veis a qué me refiero y en la web tenéis más explicaciones.

{% include image.html size="" file="p58-f4a.gif" caption="" %}

Es todo por ahora. Si os ha interesado el tema podéis encontrar mucha más información buscando un poco. En esta página he encontrado un interesante artículo sobre micrófonos [http://sound.westhost.com/articles/microphones.htm](http://sound.westhost.com/articles/microphones.htm).

Aquí el datasheet del [2SK596]({{page.assets | relative_url}}/2sk596.pdf).
