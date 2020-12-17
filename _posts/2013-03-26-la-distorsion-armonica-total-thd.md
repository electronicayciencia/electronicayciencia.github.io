---
assets: /assets/2013/03/la-distorsion-armonica-total-thd
featured: 'true'
image: /assets/2013/03/la-distorsion-armonica-total-thd/img/linea_recta.png
layout: post
tags:
- DSP
- Matemáticas
- Sonido
title: La Distorsión Armónica Total (THD)
---

Cualquier aficionado a la música o a la electrónica conoce lo que es la distorsión. En este artículo hablaremos de la importancia de la no linealidad en la distorsión y de cómo se mide si un amplificador distorsiona más o menos que otro.

Haremos un recorrido empezando por los amplificadores ideales. Llegaremos a los no ideales y ahí encontraremos el desarrollo de Taylor. Veremos qué efecto tienen los términos de orden superior sobre una señal de entrada sinusoidal; primero matemáticamente y luego con un circuito de ejemplo. Compararemos un amplificador bien diseñado con uno mal diseñado y veremos los parámetros que caracterizan un circuito de este tipo, incluida la THD.

No quiero usar matemáticas complicadas en este artículo. Procuraré hacerlo de la forma más básica aunque sea más largo y en ocasiones incorrecto. Si alguna explicación no la pilláis, mirad los gráficos y todo será más fácil de entender. Recordad que haciendo click en una imagen la ampliaréis. Y si queréis verla más grande aún, abridla en una ventana nueva.

<!--more-->

## Funciones lineales y no lineales

Matemáticamente una función lineal es simplemente algo como:

$$
y = k x
$$

que es como decir que *la salida es igual a la entrada multiplicada k veces*. O sea que si la entrada es de una forma, la salida es de la misma forma sólo que más grande. Si entra una onda triangular, sale una onda triangular de mayor amplitud. Si entra una onda sinusoidal, pues a la salida está la misma sinusoide con mayor amplitud **y nada más**. Nada de ruido, ni cambia la fase, ni se recorta la onda. Lo que todos entendemos por un amplificador ideal.

¿Qué tipo de funciones tienen este resultado? Pues las rectas:

{% include image.html size="big" file="linea_recta.png" caption="" %}

Arriba una recta de pendiente -ganancia- 2. A una amplitud de 1 le corresponde 2; a 2, 4 y a 3, 6.

Pero los amplificadores ideales, como todo lo ideal, no existen. La realidad es que "k" casi nunca es una constante. K puede variar dependiendo de muchas cosas, las dos más obvias son:

- Por la **amplitud**: Por ejemplo, si entran 1 mV salen 10 mV (ganancia x10). Pero si entran 2 mV en vez de salir 20 mV salen 19 mV. Hay una pequeña pérdida y k ya no es igual para todas las amplitudes.
- Por la **frecuencia**: Por ejemplo, un amplificador puede tener una ganancia x100 para frecuencias de 1 kHz, pero las de 10 kHz ya sólo las amplifica x50 y las superiores a 20 kHz sólo x2. No todas las frecuencias se amplifican por igual.

Hablaremos del primer caso, que es lo que se llama *distorsión armónica* por lo que veremos ahora. Digamos que en vez de lo de arriba, el amplificador no ideal hace esto otro:

$$
y = f(entrada)
$$

donde *f* es una función que no es una línea recta. Por ejemplo:

{% include image.html size="big" file="linea_curva.png" caption="" %}

En comparación con la anterior, a 1 le corresponde *casi*  2, pero a 2 ya no le corresponde 4 y del 3 mejor no hablar.

Todos los componentes **activos** son no lineales, habitualmente exponenciales. Pero no sólo los activos también los **pasivos** pueden presentar comportamientos no lineales cuando una unión está oxidada, o en el empalme de dos materiales distintos. Se llama [intermodulación pasiva](http://en.wikipedia.org/wiki/Intermodulation#Passive_Intermodulation_.28PIM.29) y es la causa de que haya interferencias de radio donde menos te lo esperas. Hay casos documentados de gente que dice oir la radio a través de un **implante dental**. Aunque esto último lo intentaron los Cazadores de Mitos y no pudieron reproducirlo en el experimento.

## Series de Taylor

Habitualmente no sabemos la fórmula (expresión analítica) de la curva anterior. O bien es muy difícil de calcular -imposible en muchos casos- o bien depende de tantos factores que no merece la pena. Así que la aproximamos.

Cualquier función suave se puede aproximar alrededor de un punto por un polinomio. La función anterior, sea cual fuera, se podría expresar aproximadamente así, eligiendo unos k adecuados:

$$
y = k_0 + k_1 x + k_2 x^2 + k_3 x^3 + k_4 x^4 + ...
$$

Esta forma de aproximar una función por una serie de potencias de x, se llama **Serie de Taylor**. Por ejemplo mirad esta imagen tomada de la Wikipedia en la que aproximan una exponencial:

{% include image.html size="small" file="taylor_wikipedia.gif" caption="" %}

Si todos los coeficientes k valieran 0 salvo k<sub>1</sub> saldría una función lineal como la recta del principio. k<sub>1</sub>x se llama *término lineal*.

En cuanto a k<sub>0</sub>, es una constante que no depende de la amplitud de la entrada. Quiere decir que incluso sin ninguna señal tendríamos tensión a la salida. Esa nos la quitaríamos poniendo un condensador.

Los amplificadores se diseñan de tal forma que predomina el término lineal, y los términos de mayor orden  serán muy pequeños. El término cuadrático (o *de segundo orden*, el que acompaña a la x al cuadrado) será más pequeño que el anterior, el cúbico (o *de tercer orden*) mucho más pequeño que el cuadrático y así sucesivamente.

Para dejarlo claro: si la ganancia es lineal no hay términos superiores (de segundo o tercer orden). Si la ganancia es "casi" lineal, estos términos serán muy pequeños, y se harán más grandes cuanto más nos desviemos de la línea recta.

## Los armónicos

Cuando multiplicamos un seno (una señal sinusoidal) por una constante, sigue siendo un seno. Cambiará la amplitud, que se hará mayor o menor según si la constante es mayor o menor que 1. Pero la forma y el espectro serán los mismos que al principio: un tono puro.

Si en vez de multiplicar, lo elevamos a una potencia ya no ocurre lo mismo. Vedlo gráficamente:

{% include image.html size="big" file="senxysenx2.png" caption="" %}

Tenemos de nuevo un seno, pero hay algunas diferencias obvias:

- **La amplitud**: Para empezar la amplitud se ha reducido a la mitad, ya no va de -1 a 1 (2 Vpp) sino de 0 a 1 (1 Vpp).
- **El offset**: Antes la componente continua era cero y la oscilación se encontraba centrada, ahora se encuentra desplazada hacia los positivos (+0.5V).
- **La fase**: Ha habido un desplazamiento porque antes empezaba en un paso por cero y ahora la señal empieza en un mínimo.
- **La frecuencia**: Y lo más importante de todo ¡ahora la frecuencia es el doble!

En el espectro de frecuencias lo vemos así. Por ejemplo tenemos una señal de 300 Hz y la elevamos al cuadrado, este es el resultado donde se ve que surge una frecuencia doble y una componente continua:

{% include image.html size="big" file="300al2.png" caption="" %}

Para explicarlo de manera sencilla recurrimos a la siguiente [identidad trigonométrica](http://es.wikipedia.org/wiki/Identidades_trigonom%C3%A9tricas#Paso_de_producto_a_suma):

$$
\sin(x) \sin(y) = {\cos(x - y) - \cos(x + y) \over 2}
$$

Y para el seno **al cuadrado** tendríamos que

$$
\sin^2 x = \sin (x)  \sin (x) = {\cos(x - x) - \cos(x + x) \over 2} = {\cos(0) \over 2} + {cos(2x)\over 2}
$$

puesto que $$\cos(0) = 1$$ resulta

$$
\sin^2(x) = {1 \over 2} + {\cos(2x) \over 2}
$$

ahí tenemos nuestro desplazamiento (el 1/2 inicial), nuestro cambio de fase (el seno cambia a coseno), nuestra merma de amplitud y, sobre todo, el cambio de frecuencia x a 2x.

Para el **cubo** se podría repetir lo anterior y reaparece la frecuencia original y también el **triple**.

{% include image.html size="big" file="300al3.png" caption="" %}

En la **cuarta** aparecen el doble (como en el cuadrado) y también el cuádruple:

{% include image.html size="big" file="300al4.png" caption="" %}

En la **quinta potencia** sale la **original** y los múltiplos **triple** y **quíntuple**.

{% include image.html size="big" file="300al5.png" caption="" %}

En general en las potencias pares aparecen los múltiplos pares de la frecuencia de entrada -f- (0, 2f, 4f, 8f ...) y en las impares los múltiplos impares (f, 3f, 5f, 7f ...). Esos múltiplos de la frecuencia original, como habréis podido intuir ya, son los **armónicos**.

Por eso decimos que cuando la amplificación no es lineal aparecen **armónicos** y este artículo va sobre la distorsión **armónica**. Veamos esto en la práctica.

## Ganancia de un amplificador

Vamos a ver, en la práctica, de dónde sale la distorsión. Tened en cuenta que los resultados y gráficos del Spice están basados en un modelo, que puede estar más o menos simplificado. Este es nuestro circuito:

{% include image.html size="small" file="sch_bc547_600_720mv_1k.png" caption="" %}

El transistor BC547 es un NPN muy utilizado. Lo polarizamos en **emisor común** de la forma más sencilla posible:

- Una fuente de alimentación de 10V colector-emisor.
- Una resistencia limitadora, R1, que calculamos para que la corriente de colector no supere 100mA.
- Una fuente de señal en la base, que podemos variar a voluntad.

Cuando variemos Vin, hará variar la **tensión de salida**:

{% include image.html size="big" file="tension_bc547.png" caption="" %}

Pasamos por las tres zonas características de un transistor bipolar:

- A la izquierda, el valor de Vin es demasiado bajo para activar la unión B-E y el transistor permanece inactivo, en **corte**.
- En el centro, la **región activa**. Como es un amplificador **inversor** la tensión de salida va bajando a medida que incrementamos la de entrada.
- A la derecha, el transistor ya está completamente abierto y la corriente de colector sólo está limitada por la resistencia R1. Ha llegado al valor máximo y apenas va a aumentar por mucho que aumente la corriente de base. Es la región de **saturación**. ¿Véis súbitamente cómo deja de amplificar?

Nos interesa saber cómo varía la **ganancia** durante todo el recorrido anterior. Para eso representamos el cociente entre la tensión de salida y la de entrada.

{% include image.html size="big" file="ganancia_bc547.png" caption="" %}

Decíamos que para que un amplificador no tuviera distorsión la ganancia tendría que ser la misma para todos los valores de entrada. Es evidente que no igual en todo el recorrido. Varía y mucho, luego nuestro amplificador va a distorsionar.

La ganancia también puede variar con la temperatura o con el punto de trabajo... y esto en continua, pues en alterna depende también de la frecuencia; sin contar las capacidades parásitas o el efecto Early... si queréis indagar más sobre efectos no lineales os recomiendo este artículo: [El transistor, ese gran desconocido]({{site.baseurl}}{% post_url 2011-07-06-el-transistor-ese-gran-desconocido %}).

## Salida con distorsión

Aplicamos a la entrada una señal sinusoidal de 1000 Hz, centrada en 660 mV con una amplitud de 60 mV (es decir que irá desde los 600 mV a 720 mV). Según el gráfico anterior la tensión de salida es:

{% include image.html size="big" file="tension_bc547_t.png" caption="" %}

Al menor valor de entrada, 600 mV -línea verde-, le corresponde una tensión de salida de casi 10 V. Es una amplificación de aproximadamente x16 (mirad la gráfica de la ganancia). Al mayor valor de entrada, 720 mV -línea roja- le corresponden 7 V. Una amplificación de algo menos de x10.

Ahora viene lo bueno, si el máximo son 10 V y el mínimo 7 V, el valor medio es 8.5 V. Que debería corresponder con el valor medio de la entrada de 660 mV. Eso es lo que sucedería en un amplificador lineal bien diseñado.

Pero **NO** en este. Al valor medio de la entrada le corresponden 9.5V -línea gris-. Está desplazado porque las amplitudes no se amplifican por igual. Por ese motivo aunque la entrada puede ser una sinusoidal (en rojo), la salida (en verde) podrá ser cualquier cosa:

{% include image.html size="medium" file="out_bc547_600_720mv_1k.png" caption="" %}

Electrónicamente ya hemos visto por qué se ha deformado la onda. Pero matemáticamente se podría explicar de esta forma:

1. La ganancia no era constante sino una función de la amplitud.
1. Cualquier función suave se puede aproximar por una serie de potencias al cuadrado, cubo, etc.
1. La señal de entrada -que era un seno- ha resultado multiplicada por un factor de amplificación y además elevada a distintas potencias.
1. Como ya hemos visto, elevar el seno a una potencia produce frecuencias múltiplos de la original: **armónicos**.
1. Los armónicos presentes a la salida deforman la onda (distorsionan).

Y por supuesto tales frecuencias indeseadas se ven claramente en el espectro:

{% include image.html size="big" file="thd_bc547_600_720mv_1k.png" caption="" %}

## Medida de la distorsión: la THD

La *[Distorsión Armónica Total](http://es.wikipedia.org/wiki/Distorsi%C3%B3n_arm%C3%B3nica)* (DAT o más conocida como **THD** por sus siglas en inglés) es una magnitud que sirve para representar la calidad de un amplificador o de un oscilador. Mide la cantidad de armónicos no deseados presentes en la salida. Es decir si la señal de salida se parece mucho a la de entrada si es un amplificador, o a la que debería ser en caso de un oscilador (sinusoidal, cuadrada, etc).

Se calcula aplicando a la entrada una señal de frecuencia y amplitud conocidas. Se suma la **potencia** de salida de todos los armónicos (basta con los diez primeros) y se divide la suma entre la potencia de salida de la frecuencia fundamental. El resultado se expresa casi siempre en porcentaje pero en ocasiones también podéis verlo en decibelios.

Siempre que se da el dato de la THD, se debe indicar también para qué frecuencia y amplitud de entrada.

Con LTSpice analizamos los diez primeros armónicos del circuito simple -gráfica anterior- y este es el resultado:

```
Fourier components of V(out)
DC component:8.97524

Harmonic        Frequency         Fourier         Normalized
 Number           [Hz]           Component         Component
    1           1.000e+03        1.355e+00        1.000e+00
    2           2.000e+03        4.667e-01        3.445e-01
    3           3.000e+03        1.000e-01        7.381e-02
    4           4.000e+03        2.281e-02        1.684e-02
    5           5.000e+03        1.703e-02        1.257e-02
    6           6.000e+03        1.488e-02        1.098e-02
    7           7.000e+03        6.020e-03        4.443e-03
    8           8.000e+03        8.213e-03        6.062e-03
    9           9.000e+03        7.057e-03        5.209e-03

Total Harmonic Distortion: 35.325777%
```

Quiere decir que, un 35% de la potencia de salida se desperdicia en frecuencias no deseadas, distorsión. De toda la potencia entregada a la salida, sólo el 65% corresponde a la señal que queremos amplificar.  Dicho de otra forma, la señal de salida sólo se parece en un 65% a la de entrada.

Además, tiene una fuerte componente continua, de casi 9V que deberíamos filtrar.

Tomemos ahora un amplificador **bien diseñado** como este preamplificador que viene de ejemplo en el LTSpice (se llama HandFreePreamp por si queréis buscarlo).

{% include image.html size="medium" file="thc_.05_sch.png" caption="" %}

Este esquema me gusta porque da muchas otras especificaciones técnicas que caracterizan un amplificador:

- La **THD**, indicando la frecuencia y la amplitud para la que se mide. En este caso 0.05% para 1 kHz con 0.4 Vpp de amplitud.
- El **consumo** y la tensión de **alimentación**. 1.9 mA. Una batería de 9 V tiene entre 400 y 570 mAh, así que 370 h de duración es aproximado y no para uso continuo.
- La **ganancia** en decibelios, así como la **banda pasante** a -3 dB. Este amplificador tiene una ganancia de 26.4 dB (x20) y se puede usar entre 38 Hz y 12 kHz. Más que suficiente para la voz. Para la música se queda un tanto corto en los agudos.
- La **impedancia de salida** y la frecuencia para la que se refiere. 387 Ω a 1 kHz. Es normal que no proporcionen la potencia de salida. Es un preamplificador, no lo olvidemos, y está pensado para conectarlo a un amplificador final de potencia.
- El **ruido** referido a la entrada. Un parámetro que no suelen darnos. Significa que en un amplificador exactamente igual sólo que sin ruido -ideal-, tendríamos que aplicar un ruido de 1.2 µV a la entrada para tener a la salida el mismo nivel de ruido que tenemos en silencio en el circuito real.
- El número de componentes de cada tipo.

Si hacemos la misma gráfica que con el otro parece que no hay más frecuencias que la de entrada:

{% include image.html size="big" file="thc_.05_lin.png" caption="" %}

Veamos qué sale en el análisis de Fourier:

```
Fourier components of V(out)
DC component:-0.000718343

Harmonic        Frequency         Fourier         Normalized
 Number           [Hz]           Component         Component
    1           1.000e+03        2.017e-01        1.000e+00
    2           2.000e+03        9.592e-05        4.755e-04
    3           3.000e+03        2.369e-05        1.174e-04
    4           4.000e+03        1.868e-05        9.260e-05
    5           5.000e+03        1.495e-05        7.410e-05
    6           6.000e+03        1.245e-05        6.172e-05
    7           7.000e+03        1.067e-05        5.287e-05
    8           8.000e+03        9.325e-06        4.623e-05
    9           9.000e+03        8.283e-06        4.106e-05

Total Harmonic Distortion: 0.051420%
```

La THD es mucho mejor, un 0.05%. Evidentemente el 35% del otro circuito es una barbaridad.

Como cabe esperar, en un amplificador bien diseñado la salida está centrada en cero, y los armónicos no son tan pronunciados como en el otro. En un gráfico con escala lineal como el de arriba no se aprecian pero sí en uno logarítmico. Mirad como el siguiente armónico, que es el tercero, está 25dB por debajo de la fundamental. Su amplitud es unas 20 veces menor.

{% include image.html size="big" file="thc_.05_dB.png" caption="" %}

¿Así que cuanto menos THD mejor es el amplificador? La teoría nos dice que sí, pero...

En la siguiente imagen veis la evolución de la THD a lo largo del tiempo. Esta imagen está tomada de [http://www.nutshellhifi.com/library/tinyamps.html](http://www.nutshellhifi.com/library/tinyamps.html), lectura muy recomendable para todos los interesado en la Alta Fidelidad.

{% include image.html size="big" file="evol_thd_nutshellhifi.gif" caption="" %}

Quitando los amplificadores baratos, la THD últimamente es tan baja que que ha perdido el significado. El oído no aprecia diferencia entre 0.01% y 0.001%. A veces incluso buscamos amplificadores con una THD un poco mayor. Porque una presencia ligera de armónicos y de otras frecuencias da la sensación de un sonido más rico o **más cálido**.

## Mezcla de frecuencias

La música nunca es una sinusoide pura. ¿Qué pasa con la distorsión en este caso?

Bueno, pues al igual que una función suave podía aproximarse por una serie de potencias, una función periódica (como una onda de la forma que sea) puede aproximarse como suma de varios senos (o cosenos). Es lo que se llama Serie de Fourier (ver [La Transformada de Fourier no es magia]({{site.baseurl}}{% post_url 2011-08-11-la-transformada-de-fourier-no-es-magia %})). Y se ve muy bien en esta imagen (tomada de [la Wikipedia](http://es.wikipedia.org/wiki/Serie_de_Fourier)).

{% include image.html size="big" file="fourier_triangular_wikipedia.gif" caption="" %}

Tenemos una señal de entrada compuesta por dos frecuencias. Un tono **a** de 300 Hz y otro tono **b** de 500 Hz.

$$
y = \sin(2 \pi a t) +  \sin(2 \pi a t)
$$

Para no liarnos con los números, simplificamos obviando los factores (no hagáis esto en un examen) y lo escribiremos así:

$$
y = f_a + f_b
$$

Queriendo decir *y está compuesta de un tono **a** y otro **b***. Por favor, estad atentos a los subíndices y tratad de no perderos; son muchos términos pero es sólo sumar y restar.

Cuando la amplificación es perfectamente lineal tenemos esto:

$$
Out = k \times y = k f_a + k f_b
$$

Cada frecuencia se amplifica por su parte, y no hay mayor problema. La forma de la salida es la misma que a la entrada sólo que más grande o más pequeña según k sea mayor o menor que 1. Lo mismo que antes.

{% include image.html size="big" file="300y500.png" caption="" %}

Pero ¿y si la amplificación no es del todo lineal y tiene un pequeño **término cuadrático**?

Pues al igual que antes:

$$
Out = k_0 \times y + k_1 \times y^2
$$

Ahora lo que va al cuadrado no es un seno, sino una suma de dos senos independientes. Y habrá que aplicar la regla del cuadrado de una suma:

$$
(a+b)^2 = a^2 + 2ab + b^2
$$

También vimos que al multiplicar senos de dos frecuencias distintas (ab) se utiliza esta identidad:

$$
\sin(x) \sin(y) = {\cos(x - y) - \cos(x + y) \over 2}
$$

Expresado en frecuencias y sin tener en cuenta las amplitudes ni las fases sería así:

$$
f_a \times f_b = f_{a-b} + f_{a+b}
$$

Cuando elevamos al cuadrado ambas frecuencias son la misma y nos sale:

$$
f_a^2 = f_a \times f_a = f_{a-a} + f_{a+a}
$$

$$
f_a^2 = f_0 + f_{2a}
$$

Como ya vimos antes, al elevar una frecuencia al **cuadrado** el resultado era una componente continua más una frecuencia doble (armónico).

Es decir, suponiendo que k1 y k2 ambas valen 1, para simplificar:

$$
Out = y + y^2 = (f_a + f_b) + (f_a + f_b)^2
$$

Haciendo a parte el cuadrado:

$$
( f_a + f_b )^2 = f_a^2 + f_a f_b + f_b^2
$$

$$
( f_a + f_b )^2 = f_0 + f_{2a} + f_{a+b} + f_{a-b} + f_0 + f_{2b}
$$

En total:

{% include image.html size="" file="eq1.gif" caption="" %}

Los términos de arriba son las mismas frecuencias originales amplificadas. Pero los términos de abajo son armónicos, y frecuencias sumas y restas, estos son los llamados [**productos de intermodulación de segundo orden**](http://en.wikipedia.org/wiki/Intermodulation). Es decir, que entran 300 Hz y 500 Hz pero salen:

```
a   =  300 Hz
b   =  500 Hz 

0   =    0 Hz
2a  =  600 Hz
2b  = 1000 Hz
a-b =  200 Hz
a+b =  800 Hz
```

Visto en el espectro:

{% include image.html size="big" file="300y500_2_t.png" caption="" %}

¿Y si hubiera **términos al cubo** que no se pudieran despreciar?

Pues, de nuevo sin tener en cuenta amplitudes, deberíamos añadir un término a lo anterior:

$$
(f_a + f_b)^3 = f_a^3 + f_a^2 f_b + f_a f_b^2 + f_b^3
$$

Ya vimos cómo frecuencia al cubo resulta en ella misma más el tercer armónico:

{% include image.html size="" file="eq2.gif" caption="" %}

Aplicamos lo mismo para hacer las multiplicaciones intermedias:

{% include image.html size="" file="eq3.gif" caption="" %}

{% include image.html size="" file="eq4.gif" caption="" %}

Luego la señal de salida estará compuesta por todas estas frecuencias:

{% include image.html size="" file="eq5.gif" caption="" %}

Con las frecuencias del ejemplo son:

```
a    =  300Hz
b    =  500Hz 

0    =    0Hz
2a   =  600Hz
2b   = 1000Hz
a-b  =  200Hz
a+b  =  800Hz

3a   =  600Hz
3b   = 1500Hz
2a+b = 1100Hz
2a-b =  100Hz
a+2b = 1300Hz
a-2b =  700Hz
```

Vistas en el espectro, marcados los productos de intermodulación:

{% include image.html size="big" file="300y500_2y3_t.png" caption="" %}

Evidentemente cuanto más peso tengan los términos de orden superior más potencia tendrán estos productos de intermodulación.

## Mezcladores

Pero no toda distorsión es mala. En un amplificador por supuesto que sí, pero en otros circuitos es justo lo contrario: aprovechamos precisamente la no linealidad. ¿Os habéis fijado en que siempre aparece la frecuencia suma y la frecuencia diferencia? Pues eso se puede potenciar, y nos interesa por ejemplo para hacer [receptores de radio](http://es.wikipedia.org/wiki/Receptor_superheterodino). O **demoduladores**.

Hay integrados dedicados exclusivamente a mezclar frecuencias para obtener la diferencia o la suma de ellas. Uno muy conocido es el [NE602]({{page.assets | relative_url}}/SA602A.pdf). Aunque tiene también sus detractores, precisamente por los productos de **tercer orden**: [Why NOT to use the NE602](http://home.tiscali.nl/curious_about/PA1DSP/Articles/why_not_to_use_the_ne602_.doc/index.html)  .

En la siguiente entrada haremos un circuito **mezclador** de frecuencias. Aunque no basado en lo anterior, sino en otro principio diferente también muy interesante.
