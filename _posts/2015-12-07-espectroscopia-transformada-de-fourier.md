---
assets: /assets/2015/12/espectroscopia-transformada-de-fourier
featured: 'true'
image: /assets/2015/12/espectroscopia-transformada-de-fourier/img/old_espectrocope.jpg
layout: post
tags:
- Experimentos
- Fisica
- Sonido
- Sensores
title: Espectroscopía mediante Transformada de Fourier
---

Hoy voy a hablar de ondas. Muchos artículos de este blog tienen que ver con las ondas. Y en ellos, en casi todos, tratamos las propiedades temporales de las ondas; la frecuencia esto, la frecuencia lo otro... Este artículo, a diferencia de los anteriores, vamos a basarlo en las propiedades espaciales.

La espectroscopía es una ciencia cuyo objetivo es conocer la composición de una sustancia a través de las ondas que absorbe o que emite (ya sea sonido, luz visible, infrarrojo, ultravioleta, u otras). Para lograrlo el primer paso es obtener las frecuencias más características, su espectro de emisión o de absorción según sea el caso.

Hay dos formas para separar las distintas frecuencias que componen una onda, los métodos directos y los métodos indirectos. Los métodos directos son los que aíslan una determinada frecuencia por medio de algún dispositivo (que se llama monocromador aunque se trate de radiación no visible, tal como infrarrojos). Por ejemplo usando un prisma o una rejilla de difracción para descomponer el haz de luz visible y luego medir la intensidad de luz en cada ángulo. Ese sería un método directo.

{% include image.html size="medium" file="old_espectrocope.jpg" caption="Espectroscopio antiguo. Usa un prisma para dispersar la luz. [Smithsonian](http://americanhistory.si.edu/blog/what-emerging-science-got-public-excited-1860s-spectroscopy)." %}

<!--more-->

Los métodos indirectos consisten en obtener la información de todas las frecuencias al mismo tiempo y separar los componentes con ayuda de un ordenador. Y casi siempre implican una Transformada de Fourier. Un método indirecto sería, como hacemos habitualmente para descomponer sonido, registrar la señal durante un tiempo y después aplicar una FFT para obtener el espectro. Si lo anterior te ha sonado a miedo, te interesará esta otra entrada: [La Transformada de Fourier no es magia]({{site.baseurl}}{% post_url 2011-08-11-la-transformada-de-fourier-no-es-magia %})

El artículo lo voy a dedicar a este otro método; pero antes, es necesario repasar algunos conceptos básicos sobre ondas.

## Propiedades espaciales de una onda

Si tuviste la suerte de estudiar ondas en algún momento te sonará que la amplitud de una **onda plana** venía dada por una formula con este aspecto:

$$
y = \sin(kx - \omega t)
$$

Tal vez nunca lo estudiaste, tal vez usabas otras letras, tal vez usabas el coseno en lugar del seno, o puede que fuera con signo más, o que los términos estén cambiados de orden. Me da igual. Insisto, todo eso son detalles irrelevantes. Lo importante, lo más importante, yo diría *lo único importante* es que se trata de una función armónica con doble dependencia: del tiempo y de la posición. Y lo demás son letras.

{% include image.html size="" file="Wave_packet_-dispersion-.gif" caption="Onda propagándose. Wikipedia." %}

Las constantes de proporcionalidad que multiplican a las variables de las que depende algo periódico son frecuencias. Las frecuencias indican con qué rapidez se repite algo ¿no?

Como norma general la función *sin* se calcula en radianes. Por eso ω se llama *frecuencia angular* en lugar de sólo frecuencia. Y la única diferencia es que va multiplicada por *2π*, que son los radianes que hay en un *loquesea* (en 1 metro, en 1 segundo, etc).

Y la **k**, pues es otra frecuencia. Pero en lugar de ser una frecuencia temporal, es una *frecuencia espacial*. Cuando se empezaba a experimentar con esto se le llamó número de onda (*wavenumber* en inglés). Si pudiéramos parar el tiempo y medir en varios puntos a lo largo del espacio, el número de onda indicaría cuántas veces por metro se completa el ciclo, o cuántas longitudes de onda hay en un metro. O en 2π radianes si nos referimos al número de onda angular. Esto último es lo que se representa con la letra k.

Así funciona la propagación de una onda de sonido en el aire (es un gif animado, hay varios en el artículo, lo aviso por si tienes desactivadas las animaciones):

{% include image.html size="big" file="longipatm.gif" caption="Onda de presión. [ISVR, U. of Southampton](http://resource.isvr.soton.ac.uk/spcg/tutorial/tutorial/Tutorial_files/Web-basics-sound.htm)." %}

Para medir la frecuencia temporal nos fijamos continuamente en el mismo punto. Como por ejemplo en el inicio. La onda sube y baja a un ritmo constante. Eso es la frecuencia temporal, si es lineal f o ν; si es frecuencia angular ω.

Para la frecuencia espacial imaginad que paramos la animación y medimos la amplitud a lo largo de todo el eje. La onda se repite periódicamente, sólo que esta vez **el periodo es la longitud de onda**.

El inverso del periodo espacial (longitud de onda) será la frecuencia espacial o número de onda (representado por ṽ). Ese mismo número multiplicado por 2π sería k que es el que va a la fórmula.

Una explicación rápida y un tanto apresurada, lo sé. No hay que recordarlo, sólo tenerlo presente para cuando llegue el experimento. Para terminar este repaso aquí tenéis una equivalencia entre las variables que hacen referencia al espacio y al tiempo:

<table><tbody><tr><th colspan="2">Tiempo</th><th colspan="2">Espacio</th></tr><tr><th>Símbolo</th><th>Nombre</th><th>Nombre</th><th>Símbolo</th></tr><tr><td>τ o T</td><td>Periodo (s)</td><td>Longitud de onda (m)</td><td>λ</td></tr><tr><td>ν ó f = 1/T</td><td>Frecuencia (s<sup>-1</sup>)</td><td>Número de onda (m<sup>-1</sup>)</td><td>ṽ = 1/λ</td></tr><tr><td>ω = 2π f</td><td>Frec. angular (s<sup>-1</sup>)</td><td>Número de onda (m<sup>-1</sup>)</td><td>k = 2π ṽ</td></tr></tbody></table>

Todo esto se vuelve mas interesante cuando el tiempo se trata como otra dimensión más, entonces  se habla de ondas en cuatro dimensiones, del espacio-tiempo... Claro que se hace sólo para ondas electromagnéticas, se llama *Formulación covariante del electromagnetismo* y digamos que no me cabe en este margen.

## Espectroscopía de Fourier

Volviendo a lo que decíamos antes, para obtener las frecuencias que componen un espectro hay dos métodos. Uno, aislar cada frecuencia por separado con un monocromador -sí, se le llama monocromador aunque hablemos de radiación no visible y por tanto no tenga "color"-. O dos, medir todas las frecuencias juntas y luego descomponer lo que sale con una transformada de Fourier.

Como podéis imaginar, lo segundo es relativamente reciente. Más que nada porque, antes de la invención del ordenador, era muy complicado registrar una señal analógica y aplicar una transformada. Fue con la llegada de los ordenadores y de la electrónica digital cuando este método se empezó a utilizar en serio.

Espectroscopía de Fourier con ondas de sonido la hacemos habitualmente. Pensadlo, un micrófono recoge todas las frecuencias al mismo tiempo, un ADC las muestrea a 48kHz y posteriormente con una FFT obtenemos el espectro de la señal. Y funciona estupendamente para ondas cuya frecuencia esté por debajo de la mitad de la frecuencia de muestreo.

Para frecuencias más altas la cosa ya se complica. La radiación infrarroja la encontramos a partir de 300GHz. No hay fotodetectores tan rápidos como para captar una oscilación de semejante frecuencia. Pero es que aunque los hubiera, los ADC más rápidos del mercado no sobrepasan los [5GSPS (Giga Samples Per Second](http://www.ti.com/product/lm97600)). Serán muy buenos para muestrear, como mucho, microondas. Pero no sirven para aplicar el mismo proceso a infrarrojos o luz visible.

Y sin embargo una técnica muy empleada es la llamada **FTIR (Fourier Transform Infrared Spectroscopy)**. Cabe preguntarse, ¿cómo aplicas la FFT a una señal que oscila tan rápidamente que no puedes muestrear varias veces en un periodo?

{% include image.html size="medium" file="ftir.jpg" caption="Espectroscopio FTIR comercial. [andersonmaterials.com](http://www.andersonmaterials.com/ftir.html)" %}

Aquí es donde viene la genialidad del método. Todo el rato hablamos de "periodo" refiriéndonos al periodo temporal, a la duración en segundos de un ciclo. Pero la variable temporal es demasiado rápida para medirla. Vamos a cambiar de perspectiva, y tratar de medir la onda en su dependencia espacial.

Con la tecnología actual medir distancias pequeñas es fácil. Y para dejar la onda "estática" podemos recurrir a un interferómetro. En los espectroscopios de verdad se utiliza generalmente un interferómetro de Michelson. Consiste en que el haz de luz que viene de la fuente se divide en dos y se hace interferir consigo mismo. Es el mismo tipo de interferómetro que usaron Michelson y Morley en 1887 para medir la velocidad de arrastre del "viento del ether" y que, lógicamente, no pudieron medir. Dando lugar a una serie de elucubraciones que años más tarde recopiló Einstein en su Relatividad Especial.

{% include image.html size="big" file="michelson_fft_spec.gif" caption="Interferómetro de Michelson con un brazo movil. [Wolfram](http://scienceworld.wolfram.com/physics/FourierTransformSpectrometer.html)." %}

En un espectroscopio uno de los espejos es móvil. Un detalle: en realidad, por motivos prácticos, no son espejos sino retroreflectores, reflectores de esquina o catadióptricos. De ese modo uno de los rayos recorre siempre un camino fijo, mientras que el camino del otro rayo se varía moviendo el espejo. El resultado es que la interferencia sigue una sucesión de máximos y mínimos dependiendo de la posición del espejo móvil.

Hay vídeos en Youtube donde se aprecia muy bien el fenómeno. En este por ejemplo, [Michelson Interferometer &amp; Path Variations](https://www.youtube.com/watch?v=87pPoGuLSuw&amp;t=1m10s). Por si en el futuro retiran el vídeo o cambia el enlace os dejo un GIF animado con unos segundos para que veáis a lo que me refiero:

{% include image.html size="big" file="michelson_path_variations_lowres.gif" caption="Anillos de interferencia en un interferómetro de Michelson. [Youtube](https://www.youtube.com/watch?v=87pPoGuLSuw&amp;t=1m10s)." %}

Cuando el operador mueve el tornillo micrométrico (a la derecha de la imagen), varia la longitud de uno de los brazos, y los anillos de interferencia se desplazan hacia afuera o hacia adentro. Si medimos la luz en el centro, por ejemplo, detectaremos una sucesión de máximos y mínimos. La distancia entre los anillos depende de la longitud de onda de la luz. Con un láser verde, de longitud de onda más corta que el rojo del vídeo, estarían más juntos.

## Los experimentos con sonido

Por si no habéis leído otras entradas del blog, me empeño en ilustrar experimentos con ondas sonoras. Es un hobby. En esta ocasión vamos a medir la frecuencia de un sonido utilizando su variable espacial, y no cómo habitualmente lo hacemos, con su variable temporal.

En lugar de un interferómetro de Michelson, que es poco práctico para ondas sonoras, utilizaré una forma de interferencia más sencilla: las ondas estacionarias dentro de un tubo de longitud variable. Lo que viene a ser muy parecido a un [tubo de Kundt](https://es.wikipedia.org/wiki/Tubo_de_Kundt).

{% include image.html size="big" file="montaje.png" caption="Esquema del montaje. EyC." %}

Se trata de un tubo de aproximadamente un metro de longitud. En un extremo he acoplado un altavoz y un micrófono. Y en el otro, un pistón. El pistón va conectado a un hilo que pasa por el rodillo de un ratón que me servirá como sensor de desplazamiento, tal como habíamos visto en la entrada anterior llamada *[Medir distancias con un ratón de bola]({{site.baseurl}}{% post_url 2015-07-16-medir-distancias-con-un-raton-de-bola %})*.

Ya se puede intuir que instrumento no es de precisión, pero servirá. El funcionamiento es sencillo: por el altavoz generamos un tono, que será nuestra fuente. La onda viaja por el interior del tubo, rebota en el émbolo y vuelve hacia el micrófono. En la posición del micrófono se superpondrán dos ondas: la onda incidente que viene del altavoz justo detrás, y la onda reflejada que ha viajado por el tubo una cierta distancia y ha vuelto. Cuando el sonido de vuelta esté en fase con el que sale del altavoz, habrá una interferencia constructiva y el volumen captado por el micrófono será máximo. Si las ondas incidente y reflejada están en oposición de fase, se anularán y la presión sonora será mucho menor.

Por tanto cabe esperar que, a medida que desplazo el émbolo a lo largo del tubo, habrá unas posiciones en que el micrófono captará un máximo y otras donde captará un mínimo. Y así es. Este es un gráfico del volumen frente a la distancia recorrida por el émbolo cuando generamos por el altavoz una frecuencia de 4kHz:

{% include image.html size="big" file="interf_4kHz_picos.png" caption="Cuenta de máximos en un interferograma. EyC." %}

Contemos los picos. Salen 20 en una distancia de unos 85cm. Haciendo una regla de tres son 23.5 picos por metro. Las ondas estacionarias, por su naturaleza, generan los máximos cada media longitud de onda, por lo que los 23.5 hay que dividirlos entre dos, para obtener los periodos por metro. 11.76 picos/metro o directamente 11.76 m<sup>-1</sup> porque el "pico" no es una unidad del SI.

De lo que hay que darse cuenta ahora es de que 11.76 es precisamente **el número de onda** (el lineal, no el angular) de la frecuencia. De hecho, para 4000Hz, y una velocidad de propagación en el aire de 343m/s el número de onda resulta:

$$
\tilde\nu = \frac{1}{\lambda} = \frac{1}{ \frac{v}{f}} = \frac{f}{v}
$$

$$
\tilde\nu = \frac{4000s^{-1}}{343m/s} = 11.66m^{-1}
$$

Pero salta a la vista que el resultado no es ninguna sinusoidal. Para desglosar qué otras frecuencias componen el interferograma es para lo que debemos realizar una Trasformada de Fourier.

Las Transformadas pasan de un dominio a su recíproco. Decimos que pasamos *del dominio del tiempo* al dominio del inverso del tiempo, es decir, al dominio *de la frecuencia*. De la misma manera podríamos decir que pasaremos del *dominio del espacio* al *dominio de número de onda*.

Obviamente convertir el número de onda a frecuencia en Hercios es trivial sabiendo la velocidad de propagación, pero eso lo dejaremos para el último paso. De momento trabajemos con las variables espaciales.

## El software de captación

Antes de realizar más medidas voy a explicaros cómo es el software de captación que he utilizado. Se trata de un programita en Perl con tres hilos de ejecución.

En el flujo principal se monitoriza el valor de la variable desplazamiento y cuando este cambia se anota en un log su valor y el volumen en ese punto.

```perl
my $Y_old = $Y;
while (1) {
 if ($Y > 200 and $Y > $Y_old+5) {
  my $logline = sprintf("%.3f\t%d\t%.3f\n", time, $Y, $S);
  print $logline;
  print $logfh $logline;
  $Y_old = $Y;
 }

 if ($Y < $Y_old) {
   ordered_exit();
 }

 sleep 0.0005;
}
```

Es un bucle que se ejecuta cada 0.5 milisegundos y comprueba si la variable **Y** se ha movido más de 5 ticks. Hay 145 ticks de ratón por cada centímetro. Así que cada tick de ratón equivale a unos 0.07mm, luego si tenemos en cuenta lo anterior se toma un registro cada 0.35mm.

Además se dejan 200 ticks de margen al inicio. Y se detiene la ejecución en cuanto se detecta que los ticks bajan en lugar de subir. Este paso es muy importante, debido a que el registro debe ser una sucesión siempre creciente para cuando luego interpolemos.

Hay otros dos hilos. Un primer hilo va leyendo las posiciones del ratón y mantiene actualizada la variable *desplazamiento*, **$Y**. Este proceso ya lo explicamos con detalle en la entrada anterior [Medir distancias con un ratón de bola]({{site.baseurl}}{% post_url 2015-07-16-medir-distancias-con-un-raton-de-bola %}):

```perl
sub update_mouse_loop {
 my $options  = shift;
 my $polltime = 0.0005; # segundoss,  intervalo entre lecturas del ratón
 my $EV_REL   = 0x02;
 my $REL_Y    = 0x01;

 my $device = Linux::Input->new("/dev/input/event" . $options->{id_event});

 while (1) {
  foreach my $ev ($device->poll($polltime)) {
   $ev->{type} == $EV_REL and $ev->{code} == $REL_Y and $Y += $ev->{value};
  }
 }
}
```

Y un segundo hilo que va registrando el volumen y mantiene actualizada la variable *volumen*, **$S**.

```perl
sub update_slevel_loop {
 my $options    = shift;
 my $alpha      = $options->{alpha};

 $ENV{AUDIODRIVER} = "alsa";
 open my $sox, "-|",  "rec -q -D -c 1 -r 48000 --buffer 32 -b 32 -t raw -" or die;
 
 while ( (read ($sox, my $buf, 4*1024)) != 0 ) {
  # Valor medio, calculado a partir de un rectificador de onda completa
  $S = $alpha * abs($_) + (1-$alpha) * $S for unpack("i*", $buf);
 }
}
```

Si os fijáis en el programa, lo que hace es utilizar SOX para leer el micrófono. Aquí viene una parte que puede resultar algo confusa. En realidad yo no quiero, o mejor dicho no necesito usar la tarjeta de sonido en este experimento. Todo lo que necesito es un medidor de intensidad sonora en un punto.

El circuito que podría medir eso es un rectificador y un filtro, como el que se usa en los receptores de AM:

{% include image.html size="medium" file="am_diode_detector.png" caption="Detector de envolvente. EyC." %}

Sin embargo resulta más sencillo emular el circuito por software. De tal manera que muestreamos el sonido para después rectificarlo y filtrarlo usando conceptos de DSP. Esto se hace en la línea

```
$S = $alpha * abs($_) + (1-$alpha) * $S
```

Siendo $_ el valor de la muestra actual, primero se rectifica usando un rectificador de onda completa -el equivalente a tomar valor absoluto-. Y posteriormente se filtra o se integra usando una media móvil exponencial -que es el equivalente a un filtro RC-.

El resultado es un programa que no detecta la onda sonora en sí (las oscilaciones) sino su volumen medio, que es lo que nos interesa. El listado completo está, junto con el resto de ficheros, al final de la entrada.

Este es un ejemplo de fichero de log. La primera columna es la hora, en formato timestamp con milisegundos, no lo usaremos pero ahí está; la segunda el desplazamiento, que como podéis ver se inicia en 200; y la tercera el volumen. El volumen es un entero de 32bit con signo -si bien aquí son todos positivos por el proceso de rectificación ya explicado-, y por tanto el máximo está en 2<sup>31</sup>-1. Realmente ese dato no nos va a hacer falta.

```
1448661040.765 203 248284564.669
1448661040.789 214 228428344.989
1448661040.813 224 180159817.924
1448661040.838 233 151104225.416
1448661040.859 243 115368864.229
1448661040.883 253 70275983.637
...
```

## Tratamiento matemático

Una vez tenemos el fichero de log, lo cargamos en Matlab o en Octave para procesarlo.

```matlab
a = load(fichero);
n = length(a);   % número de muestras

t = a(:,1);      % tiempo (s)
t = t - t(1);    % tiempo relativo

x = a(:,2);      % posición del ratón (ticks)
x = (x / 145.1) / 100; % posición (m)
x = x - x(1);    % posición relativa

y = a(:,3);      % volumen sonoro (s/u)
y = y/max(y);    % volumen (%)
y = y - mean(y); % eliminar DC
```

Lo primero es cargar el fichero y separar las variables para el cálculo posterior:

- **El tiempo** no lo vamos a utilizar, pero por si acaso le llamamos *t* y lo convertimos a tiempo relativo restándole t<sub>0</sub>.
- **La posición** del ratón la llamamos *x* y la hacemos relativa respecto del punto inicial. También la convertimos de ticks de ratón a metros utilizando el ya mencionado factor de 145.1 ticks por centímetro.
- Para **el volumen**, lo llamaremos *y* y lo normalizaremos dividiendo por el valor máximo, sea cual sea este. Dado que todos los valores eran positivos, la media de todos será mayor que cero y saldrá un pico muy fuerte cuando hagamos la FFT en la frecuencia 0. Así que lo que hacemos es poner un condensador en serie para bloquear la corriente continua. O su equivalente en DSP que es restar el valor medio.

Hemos intentado recoger los datos en promedio cada 0.35mm. Sin embargo, debido a cómo se leen los eventos del ratón, puede que los puntos no estén equiespaciados, sino que unos están cada 0.5mm y otros cada 0.2mm. Eso supone un problema para el próximo paso, ya que el algoritmo de la Transformada Rápida de Fourier (FFT) asume que los datos están equiespaciados, y por eso se hace necesario un paso previo.

```matlab
% Homogeneizar los puntos x/y interpolando
% Es necesario porque la FFT asume un SR uniforme.
xi = linspace(min(x), max(x), n);
yi = interp1(x,y,xi);
```

Lo que hacemos es construir un vector de puntos uniformemente espaciados entre el primer y el último valor del vector de posición. Con tantos puntos como tenga el vector original. Le llamamos x<sub>i</sub> (x interpolado). Acto seguido inperpolamos la variable del volumen en los puntos de x<sub>i</sub> y le llamamos y<sub>i</sub> (y interpolado).

A partir de ahora, en los cálculos posteriores usaremos x<sub>i</sub> e y<sub>i</sub> en lugar de x e i.

Lo siguiente es hacer la FFT:

```matlab
% Obtener el espectro de frecuencias espaciales
yi = blackman(n)'.*yi;
s  = abs(fft(yi)).^2;
s  = s(1:(n-1)/2); % sólo f positivas
```

Antes de hacer la FFT, aplicamos una ventana a las medidas. ¿Por qué? Pues porque el inicio y el final son cortes bruscos en puntos arbitrarios del periodo, y eso a la FFT le sienta fatal. Además la frecuencia no tiene por qué coincidir exactamente con alguno de los puntos que devuelve la FFT.

La ventana realza los picos haciendo que sean más fáciles de apreciar. Hay muchas distintas, cada una con sus pros y sus contras. Hay algunas líneas generales para elegir la ventana apropiada, pero salvo que tengas necesidades concretas lo mejor es ir probando y elegir la que más te guste.

A este proceso a veces se le llama *apodización*. Como no estoy analizando transitorios, ni diseñando un filtro, ni midiendo la amplitud ni nada especial, uso una ventana de Blackman porque es sencilla y aquí da buen resultado.

Al vector de potencias espectrales le llamaré *s*. Ya sabemos de otras veces que el primer elemento corresponde a la frecuencia 0 (continua, o valor medio de la señal). Del segundo hasta la mitad son las frecuencias positivas; y en adelante hasta el final la reflexión especular. Como no nos interesa la fase de la señal, nos quedamos sólo con la primera mitad y el resto lo descarto.

La primera frecuencia es 0. ¿Y la última? Pues la última, es la frecuencia de Nyquist, equivalente a la mitad de la frecuencia de muestreo. En sonido, si muestreamos a 44000Hz, la mayor frecuencia que puede salir en el espectro es 22000Hz. Con este razonamiento calculamos el eje de las frecuencias, sólo que esta vez las frecuencias son números de onda.

```matlab
% Calcular el eje de frecuencias espaciales
v = 343; % velocidad de propagación (m/s)

klin_SR = n / max(xi); % frecuencia de muestreo
klin = linspace(0, klin_SR/2, length(s));
f = (v * klin)/2;      % /2 por ser ondas estacionarias
```

Al igual que la frecuencia de muestreo se puede calcular dividiendo cuántas muestras se toman en un tiempo dado, el *número de onda de muestreo* **klim_SR** se obtiene dividiendo el número de muestras **n** entre la distancia (el máximo de x es la distancia recorrida).

Y de la misma forma que la frecuencia límite es la mitad de la de muestreo, el número de ondas máximo es la mitad de el de muestreo. Por eso construimos un vector klin, de números de onda lineales, entre 0 y klin_SR/2 que tenga tantos puntos como intervalos de frecuencia nos han salido.

Es un método para calcular el eje de frecuencias; no es formal por lo que no recomendaría que lo pongáis en un examen, pero funciona estupendamente -varía un poquito, eso sí, si el número de puntos n es par o impar-.

El vector *klin* de número de onda ya podría servirnos por sí mismo, y de hecho en espectroscopía es habitual expresar las frecuencias como número de onda. En sonido sería bastante raro y por eso vamos a transformarlo a frecuencias temporales (Hz) multiplicando por la velocidad de propagación v, 343 m/s.

Finalmente, como ya habíamos visto antes, las ondas estacionarias dan dos máximos en cada longitud de onda y de ahí el dividir todos los valores entre 2.

El vector resultante, **f**, ya sirve para hacer gráficos:

```matlab
% Gráfico superior: posición/volumen
subplot(2,1,1);
plot(x,y);
...

% Gráfico inferior: frecuencia lineal/volumen
subplot(2,1,2);
plot(f/1000, s);
...
```

En el gráfico superior representamos el volumen frente al desplazamiento. Es lo que se llama **interferograma**, porque las medidas se obtienen como resultado de la interferencia.

En el gráfico inferior representamos el espectro de frecuencias del interferograma. De ahí el nombre de la técnica *Espectroscopía mediante Transformada de Fourier*.

## Resultados

Veamos el resultado para la señal de 4000Hz de la que hablábamos antes, puedes hacer click para ampliar, o click con el botón central para abrir las imágenes en otra pestaña aparte:

{% include image.html size="big" file="interf_4kHz.png" caption="Resultados para una frecuencia de 4kHz. Click para ampliar. EyC." %}

Además del pico en 4kHz, clavado, se aprecian algunos armónicos en 8, 12 y un pelín en 16kHz. Y no debería ser así, porque la fuente era una sinusoidal pura.

Se trata sin duda de una imperfección, un artificio del instrumento de medida. Resulta que un tubo de una longitud concreta resuena para una frecuencia concreta, pero también para sus armónicos. De ahí que aparezcan con bastante intensidad en el gráfico. Es debido a que estamos usando una cavidad resonante en vez de un interferómetro de verdad.

Pero obviemos por un momento las imperfecciones y apreciemos la belleza de calcular la frecuencia de una onda a través de sus propiedades espaciales y no de su periodo.

Subamos la frecuencia hasta 15kHz:

{% include image.html size="big" file="interf_15kHz.png" caption="Resultados para una frecuencia de 15kHz. Click para ampliar. EyC. " %}

Aquí se aprecia el pico de 15kHz y, algo muy especial, un segundo armónico en 30kHz. La tarjeta de sonido con la que captaba la onda muestrea como mucho a 48kHz; por lo que la máxima frecuencia que podría arrojar es 24kHz, y sin embargo aquí vemos claramente un pico en 30.

Una vez más, la frecuencia de muestreo de la tarjeta no la usamos para derivar la frecuencia sino nada más que para calcular el volumen recibido, y por eso no es un límite.

¿Y cuáles son los límites del instrumento?

- La **frecuencia máxima** viene dada por la resolución espacial. Es decir, mientras más juntas tomemos las medidas mayor número de onda podremos medir, y por tanto mayores frecuencias.
- La **resolución en frecuencia** viene dada por la longitud de tubo. Sí la longitud. Un tubo más largo permitirá más recorrido del émbolo, más periodos registrados y por tanto mayor precisión luego en la transformada.
- En cuanto al **ruido**, es muy interesante. Por un lado ya sabéis que hay dispositivos que generan más ruido mientras más fuerte es la señal. Pensad en un fotodetector. Si midíeramos frecuencia por frecuencia, en las frecuencias predominantes, que son las que buscamos, el resultado tendría más ruido que en los espacios vacíos. Pero con esta técnica, como medimos todas las frecuencias a la vez, el ruido se divide y se consigue una mejor relación señal/ruido. Se le llama ventaja de Fellgett porque fue el primero en observar y publicar tal cosa en su tesis doctoral.
- En cuanto al **ruido**, segunda parte. Si bien la ventaja de Fellgett puede suponer un impedimento en algunos casos (el ejemplo más simple es midiendo espectros de absorción), la Espectroscopía de Fourier tiene otras ventajas: por ejemplo las medidas son rápidas, y el paso muy fácil de graduar, con lo que si tenemos tiempo se pueden tomar varias medidas y promediar los resultados.

Y, ya que hemos visto que salen armónicos donde no deben, ¿qué pasa si a la entrada pongo dos frecuencias juntas?

Por ejemplo en este caso mezclamos 4kHz y 11kHz? Esperamos ver dos picos de 4 y 11kHz pero...

{% include image.html size="big" file="interf_4_11.png" caption="Resultados para una frecuencia de 4+11kHz. Click para ampliar. EyC. " %}

Ya habíamos visto en esta otra entrada lo que pasa al introducir dos frecuencias en un sistema no lineal: [La Distorsión Armónica Total (THD)]({{site.baseurl}}{% post_url 2013-03-26-la-distorsion-armonica-total-thd %}). Y lo podemos observar de nuevo en este resultado.

Están presentes:

- El pico de 4kHz, correspondiente a una de las señales de entrada.
- El pico de 11kHz, correspondiente a la otra de las frecuencias de entrada.
- Un primer armónico de 4kHz en 8kHz.
- Un primer y segundo armónicos de 11kHz en 22 y 33kHz respectivamente.
- Otros picos correspondientes a la suma y la resta de estas frecuencias, como 19kHz (11+8) o 3kHz (11-8).

Por ahora lo dejaremos aquí.

Buscando documentación para el artículo me he encontrado este trabajo y aunque no es una referencia como tal, sí creo que vale la pena mencionarlo para los que tengáis más interés en el tema: [unizar.es - TAD de Jesus Cortes Rodicio.pdf](http://www.unizar.es/departamentos/fisica_aplicada/tads/TAD%20de%20Jesus%20Cortes%20Rodicio.pdf)

Espero que os haya gustado esta aproximación poco convencional a las ondas sonoras. Encontraréis los ficheros de esta entrada, el software en Perl, ficheros de Octave, logs e imágenes en este enlace: [FT_espectrosonido.zip]({{page.assets | relative_url}}/FT_espectrosonido.zip)
