---
assets: /assets/2011/05/el-circuito-rlc-serie-oscilaciones
featured: 'true'
image: /assets/2011/05/el-circuito-rlc-serie-oscilaciones/img/VI_C.png
layout: post
tags:
- Circuitos
- Fisica
- Matemáticas
title: 'El circuito RLC serie: oscilaciones amortiguadas'
---

Antes de nada, os quiero pedir disculpas por el parón que ha sufrido el blog lo que va de año. Todos necesitamos un respiro de vez en cuando, y otras aficiones me han comido mucho tiempo.

Para esta ocasión he elegido un artículo doble sobre cómo funciona uno de esos circuitos que parecen sencillos pero que luego no lo son tanto. Voy a hablaros de esos osciladores de FM con un sólo transistor. Seguro que los habéis visto. Muchas veces se presentan como micrófonos espía, o transmisores simples de FM.

Pues bien, para saber cómo van, primero hay que tener muy claro lo que es un oscilador RLC en serie. Y como es costumbre voy a empezar por lo más sencillo para formar una base y poder construir el resto sobre ella. Así que vamos a ver primero cómo se comporta por separado cada componente. Luego, partiendo de nuestra experiencia intuiremos las ecuaciones que los describen. Haremos un desarrollo matemático de cómo esperamos que se comporten estando juntos e iremos viendo con un simulador el resultado.

## La resistencia

Queremos saber la diferencia de potencial en cada elemento. Por empezar en algún sitio, también podríamos hacer las cuentas con la intensidad, va a dar lo mismo. El desarrollo que sigue no pretende en absoluto ser riguroso (aunque es correcto -salvo error- no lo hagas en un examen); mi objetivo es obtener la frecuencia y la amplitud de las oscilaciones utilizando herramientas básicas de matemáticas.

Así que veamos la diferencia de potencial entre los bornes de una resistencia. Esto ya está más que sabido. La Ley de Ohm nos dice que la caída de tensión en una resistencia es proporcional a la intensidad que la atraviesa, y a su valor. Escrito matemáticamente sería algo así:

$$
V = IR
$$

No tiene más misterio (a menos que queramos obtener la R en función de los parámetros microscópicos del hilo como el grosor, el material, etc, que podríamos, pero por hoy nos vale así).

## El condensador

Primero vamos a pensar cómo se comporta un condensador en un circuito. Un par de ejemplos, situamos un condensador...

- A la salida de un rectificador de corriente alterna, para obtener corriente continua.
- En paralelo con una batería en un circuito que maneja cargas instantáneas como un relé.

Cuando ponemos el condensador en una tensión continua, se carga, y ya deja de pasar intensidad a través de él hasta que haya alguna variación en la tensión de entrada. Cuando hay, por ejemplo, una caída de la tensión de alimentación por un exceso de consumo del circuito, el condensador se empieza a descargar y suple durante un instante la alimentación, con lo que el resto del circuito no nota el corte. Diríamos que *el condensador se opone a los cambios de tensión*. Y cuando cambia, intenta **recuperar** el valor que tenía antes.

Es decir, cuando variamos el potencial de un condensador, que en principio está en equilibrio y por el que no fluye ninguna intensidad, empieza a pasar una corriente que es más grande cuanto mayor es el cambio en el potencial, y este efecto es proporcional a la capacidad que tenga el componente. Matemáticamente lo expresaríamos así:

$$
I_C = C {dV_C \over dt}
$$

Pensemos en esa ecuación, la intensidad es la derivada de la tensión... ¿Y si le metemos una señal senoidal, de una frecuencia que queramos? Ojo, que utilizar una senoidal no es por capricho, es importante porque [hay un teorema](http://en.wikipedia.org/wiki/Fourier_series) que dice que cualquier señal periódica, de la forma que sea, al final es una suma de señales senoidales. Pues eso, le aplicamos una onda al condensador:

$$
V = V_0 \cos (\omega t)
$$

V0 es una constante, de hecho es la amplitud de la onda. Lo que nos interesa ahora es la forma, no su valor. La derivada del coseno es el seno cambiado de signo:

$$
I = {dV \over dt } =  - V_0 \omega \sin (\omega t)
$$

Pero por la forma periódica de las funciones seno y coseno, se demuestra que:

$$
- \sin(\alpha) = \sin(-\alpha) = \cos(\alpha +  90^\circ)
$$

Y utilizando esto nos sale:

$$
I = V_0 \omega \cos (\omega t + 90^\circ)
$$

O sea que la intensidad, está adelantada 90º respecto a la tensión. No significa que el condensador sea un adivino que sabe en cuánto va a estar la tensión para poner la intensidad en ese valor un momento antes. Hablamos de señales que se repiten, y lo mismo se puede decir que está adelantada 90º como que está retrasada 270º. Son sólo formas de hablar. Fijaos en esta gráfica, los picos en la I suceden un tiempo antes que los de la V. Ese tiempo es un cuarto del periodo total, lo que es justamente 90 grados.

{% include image.html size="big" file="VI_C.png" caption="" %}

Podéis hacer click en los gráficos para verlos más grandes.

Volviendo a lo de antes, tenemos la intensidad en función de la tensión, pero para dejarlo parecido a como lo hemos hecho antes con la resistencia me interesa lo contrario, la tensión en función de la intensidad. Así que despejo la V. Como es una derivada tendré que integrar, y la C (que es constante) pasa dividiendo sin más:

$$
V_C = {1 \over C} \int I_C\,dt
$$

Esta expresión es un poco fea pero no os preocupéis, que nos la vamos a quitar de encima rápidamente.

El artículo de la wikipedia en español es muy breve, pero el de la wikipedia inglesa está bastante bien: [RC circuit](http://en.wikipedia.org/wiki/RC_circuit).

## La bobina

Seguro que hemos oído alguna vez que una bobina en serie es parecida a un condensador en paralelo, en relación a que ambos dejan pasar las bajas frecuencias y filtran los ruidos en la línea de alimentación. Con una cierta experiencia en electrónica esto ya nos sugiere que la ecuación va a ser muy parecida a la del condensador, sólo que cambiando tensión por intensidad.

Supongamos que tenemos una bobina y le aplicamos 5 voltios de una batería. Cuando pasan unos segundos llegamos a un estado estacionario, donde la corriente que pasa sólo la limita su resistencia interna; porque está hecha de cobre y el cobre tiene resistencia. Ahora llegamos y duplicamos la tensión, le metemos 10 voltios; y como la resistencia interna sigue siendo la misma, tendrá que pasar el doble de intensidad. Y se supone que mediríamos el doble de tensión, por la ley de Ohm. Pero resulta que no es instantáneo. Al medir, durante unos instantes la tensión es mucho mayor de lo que esperaríamos según la ley de Ohm. Se debe a que la intensidad que recorre una bobina no puede cambiar de golpe, *la bobina es un dispositivo que se opone a los cambios de intensidad*. Diríamos que tiene cierta **inercia**.

Lo mismo pasa cuando desconectamos la tensión. Esta cae a cero, pero la bobina intenta mantener la intensidad a toda cosa. Con lo que se genera un pico de tensión. Se dice que la bobina genera una tensión inducida de tal sentido que se opone al cambio que la produce. Es la llamada *fuerza contra-electromotriz* y es la que aprovechamos [para dar calambre]({{site.baseurl}}{% post_url 2010-10-06-bromas-de-alta-tension %}), pero también es causante de que pongamos un [diodo en paralelo]({{site.baseurl}}{% post_url 2010-04-18-control-de-velocidad-por-pwm %}) con un relé cuando lo activamos mediante un transistor y de que nos tengamos que quebrar la cabeza para controlar un motor [con un TRIAC]({{site.baseurl}}{% post_url 2010-12-10-dimmer-controlado-por-mando-distancia %}). De lo contrario esa tensión auto-inducida va a quemar el transistor de salida o va a alterar el TRIAC haciendo que permanezca encendido siempre.

Luego la caída de potencial en una bobina es proporcional al cambio en la tensión y, claro está, al valor de su inductancia.

$$
V_L = L {dI_L \over dt}
$$

Por eso se dice que hay un desfase entre la tensión y la intensidad, igual que con el condensador pero con signo contrario.

Ahora vemos lo que pasa cuando le aplicamos una una senoidal:

{% include image.html size="big" file="VI_L.png" caption="" %}

Sí, los picos en la V ocurren antes que en la I. Decimos que la corriente va retrasada respecto a la tensión, o bien que la tensión se adelanta respecto a la intensidad. Como son señales periódicas lo mismo nos da.

Os dejo este enlace a la wikipedia, lo mismo que para el condensador, por si os interesa verlo con más detalle: [RL circuit](http://en.wikipedia.org/wiki/RL_circuit).

## El circuito RLC en serie

Este artículo, tiene un doble propósito. Además de hacer un desarrollo para que veáis cómo funciona un oscilador, quiero que seáis conscientes de una de las cosas más fascinantes de la ciencia: cómo dos fenómenos, completamente distintos en apariencia, que superficialmente nada tienen que ver el uno con el otro, se describen con la misma ecuación. Porque, en el fondo, son lo mismo.

En este caso hablamos de un circuito RLC, pero también podríamos hablar de un muelle con una pesa. Totalmente distintos en apariencia. Por debajo son iguales: osciladores armónicos. Ambos tienen una variable *(la velocidad, la posición)*, un elemento que fuerza a que esa variable se quede en el centro como está *(un condensador, un muelle)*  y un elemento que tiene inercia *(la bobina, la pesa)*, y hace que esa variable no se centre nunca en la posición de reposo sino que pase de largo en un sentido y otro, o sea que oscile. He aquí una muestra del poder de abstracción que dota a las matemáticas de su potencia, y las hace ser la herramienta que son.

## Desarrollo matemático

Decíamos antes que no voy a ser del todo formal, pero si pongo algo que es claramente erróneo por favor dejad un comentario.

Partimos de las ecuaciones que hemos justificado antes. Fijaos que no las hemos deducido, simplemente os he puesto la ecuación y os he dado una justificación más o menos buena para convenceros de que así tiene que ser.

La resistencia es nuestra fuerza de rozamiento que amortigua las oscilaciones. Decíamos que es lineal, que cuando crece la tensión crece la corriente y viceversa.

$$
V_R = RI
$$

Para el condensador, nuestra fuerza recuperadora, habíamos obtenido esta ecuación:

$$
V_C = {1 \over C} \int I\,dt
$$

Y para la bobina, nuestra inercia:

$$
V_L = L {dI \over dt}
$$

Esto que voy a hacer normalmente se hace con la carga, pero la carga almacenada en una bobina es un concepto difícil de imaginar, así que voy a hacerlo con la intensidad.

{% include image.html size="small" file="rlc.png" caption="" %}

Tenemos este circuito RLC serie, sin fuentes de alimentación externas. Se trata de una malla cerrada y por primera ley de Kirchoff o [Ley de Tensiones de Kirchoff](http://es.wikipedia.org/wiki/Leyes_de_Kirchhoff_de_circuitos_el%C3%A9ctricos#Ley_de_tensiones_de_Kirchhoff) la suma de todas las tensiones debe ser cero.

$$
V_L+V_R+V_C = 0
$$

Sustituyendo cada tensión por su valor:

$$
L {dI \over dt} + RI + {1 \over C} \int I\,dt = 0
$$

Esa ecuación es *fea*, sobre todo por la integral, eso la afea un montón. Así que vamos a derivar todo para quitarla:

$$
L {d^2I \over dt^2} + R {dI \over dt} + {1 \over C} I = 0
$$

Esto es una ecuación diferencial lineal de segundo orden. Y para resolverla hay varias formas. Como ya sé lo que va a salir, para no complicarme voy a proponer una solución genérica y la amoldaremos según el caso. La solución tendrá que ser necesariamente de la forma

$$
I = A e^{Bt}
$$

y sus derivadas:

$$
{dI \over dt} = ABe^ {Bt}
$$

y

$$
{ d^2I \over dt^2 } = AB ^ 2 e ^ {Bt}
$$

A y B son dos coeficientes que tendremos que ajustar. A priori no exigiremos que sean reales o complejos, ya veremos lo que sale. Sustituimos, pues, en la ecuación esa solución genérica:

$$
L AB^2e^{Bt} + R ABe^{Bt} + {1 \over C} A e^{Bt} = 0
$$

Ahora simplificamos: el término $A e^{Bt}$  aparece multiplicando en todos los sumandos, así que podemos dividir por él la ecuación. Claro que para eso tenemos que exigir que A no sea 0, porque la exponencial sólo se haría cero para $t \rightarrow \infty$ . De paso dividimos todo por L para que la forma que queda sea más fácil de reconocer.

$$
B^2 + {R \over L} B + {1 \over LC} = 0
$$

Sí, es una ecuación de segundo grado, corriente y moliente. Y se resuelve con la conocida fórmula:

$$
x = \frac{-b \pm \sqrt {b^2-4ac}}{2a}
$$

sólo que aquí $x=B$ , $a=1$ , $b = {R \over L}$  y $c = {1 \over LC}$ . Así que nos queda:

$$
B = \frac{-{R \over L} \pm \sqrt {{ "{{" }}R^2\over L^2} - {4 \over LC}}}{2}
$$

Cómo se comporte el circuito ahora depende del valor que tome esto de aquí abajo:

$$
{R^2\over L^2} - {4 \over LC}
$$

¿Por qué? Pues veamos algunas posibilidades.

## Caso ideal: R = 0

Vale muy bien, si quitamos la resistencia, lo mismo que si quitamos el rozamiento, nos queda un oscilador armónico ideal. A ver qué raíces tiene la ecuación de antes cuando damos a R el valor 0.

$$
B = \frac{-{0 \over L} \pm \sqrt {{ "{{" }}0^2\over L^2} - {4 \over LC}}}{2}
$$

$$
B = \frac{ \pm \sqrt { - {4 \over LC}}}{2}
$$

$$
B = \pm {1 \over \sqrt {LC}} i
$$

Parece que B sale un número imaginario puro. Así que lo sustituimos en la solución que habíamos puesto al principio:

$$
I(t) = A e^{i{1 \over  \sqrt {LC}} t}
$$

Recordad que tenemos que quedarnos sólo con la parte real de esa ecuación, que será un seno o un coseno. Es un resultado lógico. Una oscilación pura, sin más efectos. La intensidad sube y baja con el tiempo.

{% include image.html size="big" file="rlc_spice_PI.png" caption="" %}

Para ver cuánto vale A tomamos la expresión de antes cuando $t=0$ , aprovechando que cualquier número elevado a 0 vale 1.

$$
I(t=0) = A e^{i{1 \over  \sqrt {LC}} 0} = A
$$

Claro, A es el valor de la intensidad en el instante inicial. Ojo, aquí hay un poco de miga, porque si digo que A vale cero, entonces la intensidad en cualquier momento valdría 0 y no habría oscilación. En la realidad la intensidad inicial puede ser cero pero el condensador estar cargado a tope así que cuando lo conectamos sí que oscila. Pero es que A no es tan simple, porque A también es complejo, y como complejo tiene dos componentes. Veamos cómo funciona esto:

$$
A=a+bi
$$

$$
I(t) =  \Re (A e^{iBt}) = \Re \left((a+bi)(\cos Bt +i \sin Bt)\right)
$$

$$
I(t) = \Re (a \cos Bt + a i \sin Bt + bi \cos Bt - b \sin Bt)
$$

$$
I(t) = a \cos Bt - b \sin Bt
$$

Sustituyendo el valor que habíamos obtenido para B:

$$
I(t) = a \cos {1 \over  \sqrt {LC}}t - b \sin {1 \over  \sqrt {LC}}t
$$

Ahora sí. Si A vale cero, completamente 0 (o sea que tanto a como b valgan cero a la vez) entonces no hay oscilación ninguna. Pero en cualquier otro caso sí. Si hubiéramos expresado A en coordenadas polares, en lugar de salirnos un seno y un coseno nos habría salido sólo un coseno más un ángulo: es la fase inicial.

Y la frecuencia de oscilación es justamente $\omega_0 = {1 \over  \sqrt {LC}}$ .

¿Por qué le llamo $\omega_0$  con el subíndice 0? Pues para indicar que es el caso ideal, porque en la siguiente parte la frecuencia variará.

{% include image.html size="big" file="rlc_spice_0ohm.png" caption="" %}

## Oscilador sobre-amortiguado

El primero que vamos a suponer es el caso en que tenemos una resistencia muy grande, o una inductancia muy pequeña. Si la resistencia es grande comparada con la inductancia, la energía se disipa en seguida en forma de calor. Y si la inductancia es muy pequeña en relación a la resistencia hay muy poquita energía de partida. En ambas situaciones se pierde la energía tan rápidamente que no llega siquiera a ocurrir una sola oscilación.

Fijaos, físicamente pasa esto:

{% include image.html size="big" file="rlc_spice_220ohm.png" caption="" %}

Matemáticamente por debajo, en la ecuación de movimiento que vimos antes está actuando la diferencia que hay dentro de la raíz cuadrada:

$$
{R^2\over L^2} - {4 \over LC}
$$

Lo que está ocurriendo es que $\frac{R^2}{L^2}$  se está haciendo mayor que $\frac{4}{LC}$ . Y el radicando  se vuelve positivo. La raíz de un número negativo sale un número complejo, con la solución de senos y cosenos que vimos antes; pero la raíz de un número positivo es real, no hay parte imaginaria, no hay exponencial compleja: no hay oscilación. Tan sólo hay una exponencial real que decae rápidamente.

## Amortiguamiento crítico

Así que cuando $\frac{R^2}{L^2} &gt; \frac{4}{LC}$  no oscila, y cuando es menor pues sí. Entonces tiene que haber un punto de inflexión, un punto intermedio entre una condición y otra. Según vamos ajustando los valores para que el circuito esté un poco más libre llegamos a un punto en que

$$
{R^2\over L^2} = {4 \over LC}
$$

Esa situación se llama amortiguamiento crítico. Y en un gráfico se ve así:

{% include image.html size="big" file="rlc_spice_63ohm.png" caption="" %}

Tiene la propiedad de que la energía decae más rápido que en los otros casos. ¿Y para qué sirve? Pues para detener las oscilaciones en el menor tiempo posible. Si hablamos de un oscilador mecánico nos referimos a, por ejemplo, los amortiguadores de los coches. ¿Verdad que no nos interesa que después de pillar un bache el coche bote arriba y abajo durante un rato? Pero por otro lado no podemos hacerlos rígidos, porque entonces no amortiguan nada.

Lo mismo, en un oscilador eléctrico lo empleamos para eliminar las oscilaciones no deseadas, ¿os acordáis del [efecto de Gibbs](http://en.wikipedia.org/wiki/Gibbs_phenomenon) que habíamos visto en [esta entrada]({{site.baseurl}}{% post_url 2010-12-17-controlar-un-servomotor-con-el-pc %})?

## Oscilador sub-amortiguado

Y por fin el caso que nos interesa más: hay oscilación, pero decae porque también hay resistencia.

$$
{R^2\over L^2} < {4 \over LC}
$$

La raíz cuadrada sale compleja, decíamos, así que el resultado tendrá una parte real y otra imaginaria. O sea, un número de la forma *a+bi*. ¿no? Ojo que ahora no hablamos ya de A sino de B.

$$
B = \frac{-{R \over L} \pm \sqrt {{ "{{" }}R^2\over L^2} - {4 \over LC}}}{2} = a+bi
$$

Según habíamos puesto de condición, lo que hay dentro de la raíz es negativo, así que le doy la vuelta y saco *i* fuera de la raíz (es una forma de hablar).

$$
B = \frac{-{R \over L} \pm i \sqrt { {4 \over LC} - {R^2\over L^2}}}{2} = a+bi
$$

Separando ahora la parte real de la parte imaginaria nos queda:

$$
a = - {R \over {2L}}
$$

$$
b = \frac{ \pm  \sqrt { {4 \over LC} - {R^2\over L^2}}}{2} = \pm \sqrt { {1 \over LC} - {R^2\over {4L^2}}}
$$

Como el signo no es más que la fase inicial, me voy a quedar con la parte positiva por simplicidad. Volvemos si os parece a la solución para la intensidad que habíamos propuesto al principio:

$$
I = A e^{Bt}
$$

Y sustituimos lo que nos ha salido para B. La A es quien contiene, como en el caso ideal, las condiciones iniciales del sistema. No voy a volver a hacer el desarrollo porque sale igual que antes.

$$
I = A e^{Bt} = A e^{(a+ib)t}
$$

$$
I = A  \, e^{at} \,  e^{ibt}
$$

Sustituimos primero lo que vale a, y vemos qué sale.

$$
I = A \, e^{-{R \over {2L}}t} \, e^{ibt}
$$

Fijaos, nos sale la amplitud inicial, A; una exponencial compleja, que es el término que oscila; y, en el medio, una exponencial negativa. Si recordamos, $e^{-\infty} = 0$ . Lo que significa que a medida que avance el tiempo ese término del medio será cada vez más pequeño, hasta que acabe por desaparecer. Como va multiplicando al resto de la expresión, modifica la amplitud de las oscilaciones. Ahí tenemos nuestras oscilaciones amortiguadas.

El cuánto duran va a depender del término $\frac{R}{2L}$ , curiosamente aquí vemos que el condensador no afecta para nada al tiempo que está oscilando. Nos va a ser útil después, cuando ampliemos la frecuencia sin variar el tiempo total.

Mirad en este gráfico como la oscilación pierde amplitud en con el tiempo.

{% include image.html size="big" file="rlc_spice_10ohm.png" caption="" %}

Y aquí variando el condensador. La amplitud al final es la misma en ambos casos.

{% include image.html size="big" file="rlc_spice_10ohm_100nF.png" caption="" %}

Y ahora que sabemos la duración, vamos a ver la frecuencia. ¿Os acordáis del caso ideal? La habíamos llamado $\omega_0$  y valía $\omega_0 = {1 \over  \sqrt {LC}}$ , o también puede decirse

$$
\omega_0^2 = {1 \over  {LC}}
$$

La frecuencia que nos ha salido ahora, con resistencia, se corresponde con lo que había llamado antes 'b'. Porque es la que afecta a la exponencial imaginaria. Ahora que sé que es la frecuencia, le voy a cambiar el nombre y en vez de llamarlo 'b' voy a llamarlo por su nombre: $\omega$ .

$$
\omega = \sqrt { {1 \over LC} - {R^2\over {4L^2}}}
$$

De lo que hay dentro de la raíz, la primera parte era nuestra frecuencia natural de oscilación libre, $\omega_0^2$ . Y lo otro... lo otro es el cuadrado de $\frac{R}{2L}$ . ¿No os recuerda a nada? ¡Es justamente la 'a' de antes, el rozamiento! Bueno vale, la 'a' era negativa antes, pero el cuadrado de un número negativo es positivo igualmente. Y ya que estamos, no se le llama 'a' sino $\alpha$ . Así que la frecuencia cambia:

$$
\omega = \sqrt {\omega_0^2 - \alpha^2}
$$

Tiene sentido. Al aumentar la resistencia la frecuencia se hace menor. *Le cuesta* avanzar. Por otra parte, si quitamos la resistencia, $\alpha$  se hace 0, y recuperamos la frecuencia del **oscilador libre**.

¿Y qué pasa cuando $\alpha$  se hace muy grande y justamente iguala a $\omega_0$  de forma que la raíz vale cero? Pues pasa el **amortiguamiento crítico**. Y si la supera, y el radicando se vuelve negativo, la frecuencia de oscilación sería *imaginaria*. Pues eso, que nos la imaginamos, porque no oscila nada: estamos en régimen **sobre-amortiguado**.

## Envolventes

Lo que os decía antes es aumentar la frecuencia (reduciendo el condensador) para que se junten las crestas y veáis gráficamente cómo la amplitud decae siguiendo una exponencial.

Este es el caso sub-amortiguado.

{% include image.html size="big" file="rlc_spice_10ohm_100pF.png" caption="" %}

Este es el amortiguamiento crítico. Veis que las oscilaciones se paran más o menos en el mismo tiempo que el caso de baja frecuencia.

{% include image.html size="big" file="rlc_spice_63ohm_100pF.png" caption="" %}

Y este es el sobre-amortiguado:

{% include image.html size="big" file="rlc_spice_220ohm_100pF.png" caption="" %}

Vaya, era demasiado bonito. Algo no cuadra. Porque en el de antes tardaba mucho en decaer, más que en el crítico, sin embargo aquí decae en seguida. Pero tiene explicación porque antes el circuito no oscilaba en los últimos dos casos y en estos ejemplos oscila en todos. La comparación es válida en el sub-amortiguado y en el crítico. Pero ya deja de ser válida y se hace muy evidente en el sobre-amortiguado.

## Oscilaciones forzadas

Y hemos llegado al final. Y después de toda esta teoría, este artículo ¿a dónde nos ha llevado?

Pues nos hemos quedado a las puertas de saber cómo funciona un sencillo transmisor de FM como los que hay en [esta página](http://yoreparo.com/foros/radiocomunicaciones/transmisores-de-fm-sencillos-t211744.html). ¿Podría habéroslo contado sin más en plan teoría de circuitos? Pues sí, claro, sin duda. Un par de ecuaciones, una transformada y sale. Personalmente, como pasa con muchas cosas, creo que hay una diferencia abismal entre **describir** cómo funciona un circuito y **entender**  internamente qué pasa. No hay tiempo en la vida para entender con detalle todas las cosas que conocemos cómo funcionan. Por eso estaré satisfecho si puedo aportar un granito de arena ayudándoos a entender bien cómo trabaja un oscilador de ese tipo. Y para eso hay que tener muy claro primero cómo funciona un oscilador RLC en serie.

En la próxima entrada describiré el oscilador continuando desde aquí. Después de todo ya que tenemos el oscilador,  y hemos comprendido por qué se para, sólo hay que conseguir que no se pare, y meterle energía a intervalos regulares para **contrarrestar el amortiguamiento**.
