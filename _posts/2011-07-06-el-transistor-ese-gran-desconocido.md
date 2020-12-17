---
assets: /assets/2011/07/el-transistor-ese-gran-desconocido
image: /assets/2011/07/el-transistor-ese-gran-desconocido/img/fuentev_cir.png
layout: post
tags:
- Circuitos
- Fisica
- Matemáticas
title: 'El transistor, ese gran desconocido: Regulador V-I'
---

El transistor se inventó en el 1947 y desde entonces raro es el circuito en el que no lo usamos, bien sea en como componente individual o en grupo formando un operacional, o un microcontrolador. Sin embargo, a pesar de esta omnipresencia, es un componente poco comprendido en general por nosotros los aficionados. Las ecuaciones que lo definen son complicadas y para simularlo se necesitan modelos con decenas de parámetros sutiles. Fijaos en el modelo SPICE para el 2N2222:

    .model Q2N2222A NPN (IS=14.34F  XTI=3  EG=1.11  VAF= 74.03  BF=255.9
    +NE=1.307  ISE=14.34F  IKF=.2847  XTB=1.5  BR=6.092  NC=2  ISC=0  IKR=0
    +RC=1  CJC=7.306P  MJC=.3416  VJC=.75  FC=.5  CJE=22.01P  MJE=.377
    +VJE=.75  TR=46.91N  TF=411.1P  ITF=.6  VTF=1.7  XTF=3  RB=10)

Y son solo los parámetros para una simulación decente, en un datasheet completo vienen bastantes más. Por suerte para nosotros, para el uso diario hay modelos simplificados y con conocer cuatro relaciones simples nos basta. Pero no caigamos en el error de pensar que eso es todo, el transistor es una maravilla de la física de estado sólido.

Como electrónicos no nos interesa tanto el modelo matemático como sus consecuencias. Así que lo que vamos a hacer es coger un simulador y plantear algunos circuitos simples para ver lo que pasa. Usaré el LTSpice, que es gratuito. Si no lo conocéis, echadle un vistazo: [LT Spice](http://www.linear.com/designtools/software/). Los diagramas que hace no son vistosos, pero para análisis es muy cómodo y potente.

## Regulador de tensión

{% include image.html size="big" file="fuentev_cir.png" caption="" %}

Empezaremos por una fuente de tensión. Que es un circuito muy sencillo para empezar. Tomamos el transistor y alimentamos la base con una tensión fija. En el circuito de la izquierda la tensión la obtenemos de un diodo zener. En el de la derecha, por simplificar, conecto una referencia de voltaje. Cuando el transistor trabaja en la zona activa, la tensión en el emisor es igual a la de base menos la caída base-emisor, que viene a estar entre 0.6 y 0.7 voltios. Matemáticamente

$$
V_E = V_B - V_{BE}
$$

por eso elegimos el zener de 4.6V.

Aunque en realidad eso tampoco es así. La caída de tensión en la unión base-emisor depende:

- De la corriente de base.
- De la tensión colector-emisor para una intensidad de colector fija.
- Y de la temperatura.

Más información [aquí](http://hyperphysics.phy-astr.gsu.edu/hbase/solids/basemit.html#c1). La dependencia con la temperatura de usa mucho para hacer sensores. Aunque no es nada lineal sale más barato que una resistencia NTC. De manera gráfica:

{% include image.html size="" file="basemit.gif" caption="" %}

Como no hay manera de controlarlo, asumimos una caída de tensión de 0.6 voltios y ya está. Al fin y al cabo un regulador que varía con la temperatura y con la carga no es muy estable, así que por una diferencia de medio voltio arriba o abajo no nos vamos a morir. Si la carga fuera muy crítica utilizaríamos otro circuito.

Como decíamos, la tensión en el emisor es más o menos constante. Vamos a hacer la prueba. Conectamos una resistencia que varía antes 100 y 2000Ω y medimos la tensión en sus extremos y la intensidad que la atraviesa:

{% include image.html size="big" file="fuentev_plot.png" caption="" %}

Vemos como a medida que la resistencia aumenta pasa menos corriente por ella, sin embargo la tensión es más o menos la misma siempre. Va desde 3.83V para una intensidad de 38.3mA (100Ω de resistencia) hasta 3.91V cuando la intensidad es de 1.95mA (2000Ω).

## Regulador de intensidad

Por la ley de ohm sabemos que, para una resistencia dada, la intensidad es proporcional a la tensión. Eso lo podemos aprovechar para construir una fuente de corriente constante. Cogemos el regulador de antes y ponemos de carga una resistencia fija. Como la tensión era siempre la misma, por esa resistencia pasará siempre una intensidad concreta. Y además es independiente de la tensión de alimentación, así que podemos variar la tensión de colector sin alterar el circuito. Pues ya está:

{% include image.html size="small" file="fuentei_cir.png" caption="" %}

En el circuito de arriba la caída base-emisor es de aproximadamente 0.837V (medido en la simulación). Así que la tensión en el emisor es de

$$
V_E = V_B - V_{BE} = 2V - 0.837V = 1.16V
$$

La resistencia de emisor esta vez es fija y vale 100ohm, pasarán por ella $${1.16V \over 100\Omega} = 11.6mA$$ . De esos 11.6mA la gran parte vendrá del colector, salvo una mínima parte que viene de la base. ¿Cuanta corriente pasa por la base? Pues es fácil de calcular a partir de la ganancia en corriente $$\beta$$ del transistor. El transistor ideal del ltspice tiene una ganancia de 101:

$$
I_B = {I_E \over \beta} = {11.63mA \over 101} = 115\mu A
$$

Así que la corriente de colector vendrá a ser de 11.5mA. Lo normal es que el cálculo de arriba no se haga, y se desprecie la corriente de base en comparación con la de colector. Y terminemos diciendo que por el emisor para la misma corriente que por el colector, no es cierto del todo, pero casi.

Entonces por el colector van a pasar 11.5mA. ¿Independiente de la carga que le pongamos no? Vamos a probar con una carga de 1Ω y la iremos subiendo hasta por ejemplo 500. Se supone que el transistor mantendrá la corriente en 11.5mA durante todo el recorrido.

{% include image.html size="big" file="fuentei_plot.png" caption="" %}

¡Funciona! A medida que aumenta la resistencia, el transistor le mete más tensión para que la intensidad no varíe. ¿Cómo lo hace? Pues cuando aumentamos la resistencia de colector, en el transistor desciende la tensión emisor-colector. Así cae menor voltaje en el transistor y más en la resistencia.

Pero... un momento. No puede durar siempre, porque llegará un momento en que la tensión colector-emisor llegue a cero. El transistor no genera nada, es sólo un grifo que deja pasar más o menos. Y cuando está abierto por completo, ya no deja pasar más.

Lo que va a pasar es esto:

{% include image.html size="big" file="fuentei_plotsatvce.png" caption="" %}

La tensión Vce comienza siendo muy alta, porque al principio con una resistencia baja la caída de tensión en el transistor tiene que ser grande para no exceder la intensidad. Pero a medida que aumenta la resistencia, el transistor se abre y va dejando pasar más... hasta que la tensión Vce llega a un valor mínimo. Es la tensión de saturación, que en un modelo ideal es prácticamente 0.

Está claro que la intensidad ya no se va a mantener constante:

{% include image.html size="big" file="fuentei_plotsat.png" caption="" %}

A partir de 750Ω más o menos la intensidad comienza a decaer. Sin embargo se mantiene la tensión porque la unión base-colector está ahora polarizada en directa. Y es como si fuera un diodo. De echo la tensión se estabiliza en

$$
V_R = V - V_2 - V_{BC}
$$

Se ve bien en este gráfico:

{% include image.html size="big" file="fuentei_plotbeta.png" caption="" %}

La línea roja es la ganancia en corriente (beta) del transistor. Durante la zona activa se mantiene en un valor constante (fijaos en eso) igual a 100, que es la ganancia del transistor ideal. Y en cuanto entramos en la zona de saturación se va a 0.

¿Constante...? Oye, ¿no te parece raro que la ganancia sea constante a lo largo de toda la fase activa? Podría ser, pero no, es una consecuencia de haber tomado el transistor ideal.

## Componente reactivo

Bien, hasta aquí la parte aburrida de repaso. Ahora vamos a coger nuestra fuente de intensidad y en lugar de aplicarle una resistencia le vamos a conectar una bobina. Recordemos que la bobina se opone a los cambios de corriente. Lo vimos en la entrada anterior: [El circuito RLC serie: oscilaciones amortiguadas]({{site.baseurl}}{% post_url 2011-05-18-el-circuito-rlc-serie-oscilaciones %}).

{% include image.html size="small" file="fuente_L_cir.png" caption="" %}

Así pensando un poco esperamos que al principio oponga una resistencia muy grande, tendiendo a infinito. Con una resistencia muy grande el transistor estaba saturado, y lo que le aplicaba era una tensión constante. Sabíamos que la ecuación de una bobina era:

$$
v = L\frac{di}{dt}
$$

la v la sabemos, la aplica el transistor. Si despejamos la i:

$$
i = \frac{1}{L} \int v dt
$$

Entonces con una tensión constante,

$$
i = cte \cdot t
$$

o sea, que la intensidad va a crecer en línea recta mientras el transistor esté saturado. En el momento en que la resistencia de la bobina decrezca hasta cierto valor entraremos en la zona activa. Ahí lo que se mantiene constante es la intensidad. Pero la bobina sólo reacciona a los cambios de corriente ¿qué pasará ahora que no hay cambios de corriente? Pues se supone que actuará como si no estuviera, resistencia prácticamente nula.

Veamos si estamos en lo cierto:

{% include image.html size="big" file="fuente_L_plot.png" caption="" %}

En efecto, la V es continua al principio, mientras la I crece linealmente. En cuanto la I alcanza la corriente de saturación (los 11.5mA) se queda ahí y no crece más. Al no haber más cambio en la intensidad la bobina no ofrece resistencia alguna, y la tensión en sus extremos cae a 0.

Vamos a dibujar ahora la relación entre la tensión y la corriente que atraviesa la bobina, lo que sería la resistencia, para ver cómo evoluciona en el tiempo.

{% include image.html size="big" file="R_de_L.png" caption="" %}

Al principio es muy grande, luego va bajando... y llega un momento en que cae de golpe a cero.

{% include image.html size="big" file="R_de_L_zoom.png" caption="" %}

Pero... ¿Un ángulo recto? Está claro que ni de coña. En la naturaleza las cosas no son así. Es porque el transistor es ideal, luego vamos a ver qué pasa de verdad.

## Efecto Early

Decíamos antes que lo de la ganancia constante era porque habíamos cogido un transistor ideal. Vamos a coger otro, por ejemplo un 2N2222.

{% include image.html size="small" file="fuente_noideal_cir.png" caption="" %}

Vamos a graficar de nuevo la ganancia en corriente, como hicimos antes:

{% include image.html size="big" file="early.png" caption="" %}

Curioso ¿no? Ahora la ganancia ya no es constante, sino que hace pendiente. Es el [efecto Early](http://en.wikipedia.org/wiki/Early_effect). Para entender por qué ocurre debemos fijarnos en la diferencia de potencial base-colector. Antes habíamos hablado de ella en la etapa de saturación, que está polarizada en directa con una caída similar a la de un diodo. Pero en la fase activa tiene un efecto importante: resulta que a medida que aumenta la polarización inversa, la frontera entre la unión N del colector y P de la base de amplía. Como en un diodo normal. Por eso se llama también [Modulación del ancho de la base](http://ecee.colorado.edu/~bart/book/book/chapter5/ch5_4.htm#5_4_1). Una imagen para ilustrarlo:

{% include image.html size="big" file="unionpn.jpg" caption="" %}

La imagen es de esta página *[An Inside Look at Light Emitting Diodes (LEDs)](http://www.sas.org/tcs/weeklyIssues_2009/2009-01-02/feature1/index.html)*. Habla sobre todo de LEDs, pero también de diodos en general. Os recomiendo que la miréis.

El caso es que cuando un diodo se polariza en directa (aplicando tensión positiva al ánodo y negativa al cátodo) la frontera se estrecha y permite un paso fácil de la corriente. En cambio si lo polarizamos al revés, la frontera se ensancha e impide el paso. Pues lo mismo pasa con la unión base-colector. Una base más estrecha repercute en una mayor ganancia (las razones son muy técnicas como para meterme ahora con ellas). Por eso al principio, que es cuando la polarización inversa base-colector es mayor, tenemos una ganancia grande; mientras que al final, cuando la polarización es más suave, la ganancia se hace más pequeña. Hasta que, llegando a la saturación, la polarización inversa desaparece y la unión queda polarizada en directa, en ese momento la ganancia ya tiende definitivamente a cero.

## Capacidad parásita

Decíamos antes que ese corte súbito de la resistencia en una bobina no era normal. Y no lo es. Vamos a ver qué pasa cuando la conectamos a un transistor un poco más "real".

{% include image.html size="small" file="fuenteVIL_noideal_cir.png" caption="" %}

Ya vimos en la entrada anterior, sobre oscilaciones amortiguadas, que la bobina actúa como una masa que tiene inercia. Y que cuando le cambiamos la corriente no reacciona al momento sino que siempre se pasa un poquito. ¡Y eso es justamente lo que hace también en este caso!

{% include image.html size="big" file="fuenteVIL_noideal_plot.png" caption="" %}

Lo que antes era un ángulo recto se ha convertido en una oscilación amortiguada.

{% include image.html size="big" file="vL_osci_grande.png" caption="" %}

Ya vimos que eso sólo pasa en un circuito RLC y sin embargo no vemos ningún condensador por ahí. No hace falta decir que se trata de la capacidad parásita de la unión BC en el transistor. La vamos a calcular y esperamos que nos dé del orden de picofaradios.

Como sabemos el valor de la inductancia, vamos a usar la ecuaciones que explicamos al hablar de [oscilaciones amortiguadas]({{site.baseurl}}{% post_url 2011-05-18-el-circuito-rlc-serie-oscilaciones %}). Solo que las aplicaremos al la tensión en la bobina en lugar de a la intensidad por simplificar.

Habíamos visto que el voltaje en un momento dado venía dado por:

$$
V(t) = V_0 e^{-\frac{R}{2L} t } \cos (\omega t)
$$

con

$$
\omega = \sqrt{\frac{1}{LC}-\left(\frac{R}{2L}\right)^2}
$$

donde $$V_0$$ es la amplitud inicial y R, L y C los valores de los componentes.

De momento vamos a calcular la resistencia. La L la sabemos, vale 100mH o sea 0,1H. Partimos del gráfico y nos quedamos con lo que valen los picos -máximos y mínimos-. En los picos el coseno vale 1 o -1, así que tomamos el valor absoluto y nos quitamos el signo.

$$
V_{max}(t) = V_0 e^{-\frac{R}{2L} t }
$$

Para eliminar la dependencia con $$V_0$$ dividimos la amplitud de un pico entre la del anterior y le llamamos k, por ejemplo:

$$
k=\frac{V_{max2}}{V_{max1}} = \frac{V_0 e^{-\frac{R}{2L} t_2 }}{V_0 e^{-\frac{R}{2L} t_1 }}
$$

$$
k=e^{-\frac{R}{2L}(t_2-t_1)}
$$

y de ahí, tomando el logaritmo neperiano despejamos la resistencia:

$$
R = -\frac{2L\ln(k)}{t_2-t_1}
$$

Una vez que tenemos la resistencia, utilizamos la expresión de antes para la frecuencia angular y despejamos la capacidad:

$$
C = \frac{1}{L\left(\omega^2 - \frac{R^2}{4L^2}\right)}
$$

Aunque nos falta saber el valor de $$\omega$$. Sin embargo lo calculamos también a partir del tiempo entre picos. La diferencia entre dos máximos o dos mínimos consecutivos es un periodo (T). Como aquí tenemos máximos y mínimos, la diferencia entre dos picos consecutivos es un semiperiodo ( $$\frac{T}{2}$$ ).

Puesto que

$$
\omega = \frac{2\pi}{T}
$$

ahora nos queda

$$
\omega = \frac{\pi}{t_2-t_1}
$$

He plasmado esas ecuaciones en [esta hoja de cálculo](https://spreadsheets.google.com/spreadsheet/ccc?key=0AjHcMU3xvtO8dG5vNHhrTHZxUnJwTU5FOVZreHZRVHc&amp;hl=es) para varios picos, excluyendo el primero. Como no da lo mismo para todos los picos, al final hago la media. Se podría haber hecho una regresión, pero no merece la pena meterme ya en más berenjenales:

<iframe frameborder="0" height="200" src="https://spreadsheets0.google.com/spreadsheet/pub?hl=es&amp;hl=es&amp;key=0AjHcMU3xvtO8dG5vNHhrTHZxUnJwTU5FOVZreHZRVHc&amp;single=true&amp;gid=0&amp;output=html&amp;widget=true" width="610"></iframe>

El resultado es 81kΩ en promedio para la resistencia entre el colector y la base, y 4pF para la capacidad parásita.

Y ahora representaremos, en valor absoluto, los valores que nos da el ltspice y los nuestros propios calculados a partir de la R y C que nos han salido, a ver cuánto se aproximan:

{% include image.html size="big" file="osci_compa.png" caption="" %}

La aproximación es más o menos buena. Era de esperar porque la capacidad parásita no es constante sino que va variando a medida que cambia la tensión Vcb.

Estos fenómenos que acabamos de ver son importantes en general para profundizar un poco en cómo funciona un transistor, y en particular para entender el oscilador del que hablábamos en la pasada entrada. Espero no haberos aburrido mucho.
