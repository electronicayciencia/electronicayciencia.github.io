---
assets: /assets/2011/09/electrocardiograma-y
image: /assets/2011/09/electrocardiograma-y/img/con624.gif
layout: post
tags:
- Circuitos
- DSP
- Experimentos
- Sonido
title: Electrocardiograma y electrorretinograma.
---

Este es un artículo sobre DSP con un trasfondo de electromedicina. En una entrada anterior ya vimos lo que era una transformada de Fourier y cómo se utilizaba. [La Transformada de Fourier no es magia]({{site.baseurl}}{% post_url 2011-08-11-la-transformada-de-fourier-no-es-magia %}). Para entender mejor lo que sigue te recomiendo que la leas si aún no lo has hecho. Hoy vamos a aplicarla para limpiar una señal todo lo que podamos. Pero ¿qué es limpiar? Pues para nosotros es seleccionar, de todo lo que capten nuestros sensores, sólo aquello que nos interesa; eliminando el ruido y otras interferencias.

Este experimento lo hice en el 2006 y consiste en construir un electrocardiógrafo. Pero ya desde el principio os advierto: si bien captar señales eléctricas en el cuerpo es relativamente sencillo, lo difícil es hacerlo **bien**. Y con hacerlo bien quiero decir que lo que registremos sirva para algo. Cuando un cardiólogo interpreta un electro, espera que los electrodos estén puestos siempre en el mismo sitio, que el gel tenga una conductividad determinada, que el circuito aplique unos filtros ya tipificados (homologación), etc. Así que la forma de onda que nosotros vamos a obtener no va a pasar de ser una mera curiosidad electrónica pues no tiene, ni mucho menos, valor médico alguno.

<!--more-->

## El circuito

La primera dificultad que nos encontramos al plantar un conductor en la piel es que el cuerpo es una excelente antena. Capta de todo, pero sobre todo ruido electromagnético. Ya me contaréis cómo vamos a registrar tensiones de microvoltios que vienen del corazón con un ruido de fondo tan fuerte.

El componente clave se llama **[amplificador de instrumentación](http://es.wikipedia.org/wiki/Amplificador_de_instrumentaci%C3%B3n)**. De la Wikipedia:

>  An instrumentation (or instrumentational) amplifier is a type of differential amplifier [...] Additional characteristics include low noise, very high open-loop gain, very high common-mode rejection ratio, and very high input impedances.

Es decir:

- Es un **amplificador diferencial:** es decir, que amplifica sólo la diferencia entre las dos entradas. Es de suponer que el ruido será más o menos el mismo en toda la superficie de la piel, sin embargo la tensión cardiaca es distinta a ambos lados del pecho. Por eso nos interesa el modo diferencial.
- **Bajo ruido:** Nos viene bien, si lo que vamos a medir son microvoltios mientras menos ruido meta el componente más claro se verá.
- **Ganancia elevada:** Muy práctico para medir señales débiles.
- Rechazo muy alto al **modo común:** Cualquier amplificador, por muy diferencial que sea, tiene asimetrías siempre. Y eso hace que no cancele por completo las señales que se aplican por igual a ambas entradas. En un amplificador de instrumentación esas asimetrías están cuidadas al detalle, por eso -entre otras cosas- son mucho más caros que los operacionales de uso común.

El circuito que usé en las pruebas es malísimo e improvisado -de hecho no pasó de la protoboard-. Así que, para preservar mi imagen no lo voy a poner, jeje. Si en otro momento retomo las pruebas con un circuito un poco más elaborado ya publicaré el esquema y la placa para que lo tengáis quien quiera hacerlo en casa. Está basado en este esquema:

{% include image.html size="" file="con624.gif" caption="" %}

En esencia era eso, sólo que sin el filtro basa-bajos a la salida. Precisamente lo que ahora nos interesa es filtrarlo por software.

Bien, ya tenemos nuestro circuito. Los tres electrodos los hacemos soldando monedas en la punta de los cables para tener algo más de superficie. A falta de gel conductor podemos usar agua salada, el viks-vaporub también da buen resultado. Y un poco de esparadrapo para sujetarlos. ¿Cutre? Esperad a las conclusiones.

Conectamos la salida del circuito a la entrada de micrófono de la tarjeta de sonido. Y con nuestro precario montaje lo que captamos es esto:

{% include image.html size="" file="xoscope.png" caption="" %}

## Filtrar el ECG

No está mal, es una primera aproximación. Guardaremos los datos para tratarlos digitalmente a continuación, por ejemplo con Octave. Antes un apunte: tanto Matlab como octave tienen herramientas muy potentes para DSP, no las voy a usar aquí porque lo que quiero con este artículo es que entendáis más o menos lo que hay por debajo de tales funciones. Aunque raramente lo hacemos a mano.

Cargamos los datos en Octave y hacemos una primera preparación.

```matlab
datos = load('datos/pulso3x');
senal = (datos(:,5));
[tiempos, espectro, frecuencias] = ECGpreparar(senal, 44100);

plot(tiempos, senal)
set(gca,'position', [0.035   0.15   0.950   0.750])
grid
axis('tight')
xlabel('Tiempo (s)')
title("Electrocardiograma - sin filtrar")
```

Hemos utilizado aquí un script al que hemos llamado **EGCpreparar**. Sabiendo la frecuencia de muestreo -44100Hz- nos prepara una escala temporal a partir de la longitud de la señal; así podemos ponerla en el eje X cuando hagamos el gráfico. También calcula la transformada de Fourier de la entrada y su correspondiente escala de frecuencias para el gráfico. Este es el script:

```matlab
% Calcula algunas variables en función de la señal de entrada
% para simplificar a la hora de hacer los gráficos.
% Para no complicarnos, tanto el numero de muestras como la frecuencia
% de muestreo deben ser pares.
function [tiempos, espectro, frecuencias] = ECGpreparar (senal, sampl_rate)
 % -- Tiempo --
 t_inicio = 0;
 t_npuntos = numel(senal);
 t_fin = t_npuntos / sampl_rate;

 t_bw    = (t_fin-t_inicio)/t_npuntos;
 tiempos  = [t_inicio:t_bw:t_fin-t_bw];


 % -- Frecuencias --
 espectro  = fft(senal);
 f_npuntos = numel(espectro) / 2;
 f_inicio  = 0;
 f_fin     = sampl_rate/2;

 f_bw  = (f_fin-f_inicio)/f_npuntos;
 frecuencias = [f_inicio:f_bw:f_fin-f_bw];

 % Cortamos la parte simétrica de la FFT
 % Y normalizamos el modulo
 espectro = abs(espectro(1:f_npuntos));
 espectro /= max(espectro);
end
```

Graficamos la forma de la onda. **Como en todas la imágenes de este blog, haced click para ampliar:**

{% include image.html size="" file="ecg_t_sinfiltrar.png" caption="" %}

Y de igual modo el espectro de frecuencias:

```cpp
plot(frecuencias, abs(b)/max(abs(b)))
set(gca,'position', [0.035   0.15   0.950   0.750])
set(gca,'ticklength',[0 0.005])
grid
axis('tight')
axis([0,450])
xlabel('Frecuencia (Hz)')
title("Electrocardiograma - sin filtrar") 
```

{% include image.html size="" file="ecg_f_sinfiltrar.png" caption="" %}

¿Qué destacamos de este espectro?

- Lo más llamativo son los **picos** en 100, 200, 300... en general en los armónicos **pares** de 50Hz pero NO en 50Hz. Podría ser una señal de 50Hz rectificada, o alguna interferencia de 100Hz de un tubo fluorescente o un televisor. A priori tan sólo podemos intuir el origen. Lo que nos interesa es que son picos de una frecuencia muy exacta, y eso nos facilitará el filtrado.
- Predominan las **frecuencias bajas**, por debajo de 50Hz casi todo. Por encima de 100Hz prácticamente no hay nada salvo ruido e interferencias.
- A medida que nos acercamos a 0Hz el espectro tiende también a 0. Eso no debería pasar. Echamos en falta el llamado [1/f noise](http://j.mp/oqfd4R), también conocido como ruido rosa, presente en cualquier sistema electrónico y que aumenta con la inversa de la frecuencia al aproximarse a los 0Hz. ¿Por qué no aparece aquí? Pues porque las tarjetas de sonido incorporan un filtro para eliminar la corriente continua del micrófono. Y este filtro pasa-altos es el que elimina toda la componente espectral de baja frecuencia. Si quisiéramos mejorar la medida deberíamos [eliminar tal filtro]({{site.baseurl}}{% post_url 2010-10-20-medir-valores-logicos-con-tarjeta-de %}). De momento vamos a dejarlo así.

Vamos a purgar la señal operando directamente en el espacio de la frecuencias, sobre todo viene muy bien para eliminar una o varias frecuencias molestas. Para hacerlo en el espacio del tiempo tendríamos que tener un filtro digital, etc. Pero aquí, puesto que tenemos la onda grabada y no existe esa presión de procesarlo en tiempo real no vamos a hacerlo así.

**Primer punto:** picos en frecuencias múltiplos de 50Hz. Nos los cargamos. Como la muestra completa mide 2 segundos exactos (88200 samples) tenemos una resolución de 0.5Hz. Si tenemos en cuenta que el primer valor de la FFT es la continua, el valor correspondiente a 50Hz será el que hace el número 101. Y como la resolución era de 0.5Hz, 50Hz son 100 posiciones. Por tanto en los lugares 101, 201, 301, etc. suprimimos el pico. Lo podíamos suprimir igualándolo directamente a cero, pero es más elegante promediar los valores adyacentes. Si **b** es nuestra FFT:

```matlab
% cancelamos la red y sus armónicos:
for i=101:100:sr/2; % 100 es para este caso, ver texto*
 b(i) = (b(i-1) + b(i+1)) / 2;
end
```

Cuando lo aplicamos, tenemos este espectro:

{% include image.html size="" file="ecg_f_sinarmo.png" caption="" %}

Ahora deshacemos la FFT para obtener la onda resultante. Pero antes, si recordáis la FFT es un vector complejo que tiene esta forma:

```
[f0 f1 f2 f3 ... fN-1 fN fN-1* ... f3* f2* f1*]
```

Donde f0 es la componente continua y fN es la frecuencia de Nyquist, que vale la mitad de la frecuencia de muestreo. El asterisco indica conjugado. Nosotros para hacer el gráfico y las operaciones nos habíamos quedado con la primera parte:

```
[f0 f1 f2 f3 ... fN-1 fN]
```

y ahora tenemos que completarlo. Si no lo hacemos no pasa nada, la forma de la onda que vamos a obtener va a ser la misma sólo que con la mitad de puntos. O sea que perdemos resolución. De todas formas lo suyo es completarla.

```matlab
% reobtenemos la forma de onda filtrada
b = [b ; 0 ; conj(flipdim(b(2:np)))]; % completamos la FFT
c = real(ifft(b)); % nos quedamos sólo la parte real
c = c/max(abs(c)); % normalizamos
```

Y este es el resultado:

{% include image.html size="" file="ecg_t_sinarmo.png" caption="" %}

Mejor que antes; pero francamente aún es una mierda. Hay que filtrar un poco más. Un electro se compone sobre todo de bajas frecuencias. La frecuencia cardiaca viene a estar entre pongamos 50 y 180 latidos por minuto. Esto es entre 1 y 3 Hercios. Realmente el filtro pasa-altos nos la está jugando, pero aunque sea muy tenue aún tenemos que poder ver algo. Vamos a suavizar la onda. Por ejemplo con una [media móvil](http://es.wikipedia.org/wiki/Media_m%C3%B3vil). Bueno, da la casualidad (o quizá no tanta casualidad) de que aplicar una media móvil es un caso particular de un filtro gausiano, y los filtros gausianos en el dominio del tiempo resulta que se traducen en aplicar una campana de Gauss al dominio de la frecuencia.

Si no habéis entendido el párrafo anterior ni a la tercera no pasa nada; es normal, a mi también me pasa. El caso es que como nos interesan las frecuencia bajas pues nos cepillamos las que estén por encima de un umbral. Pero si metemos un tajo en seco a la FFT, cuando vayamos a recuperar la onda hace cosas raras. Para minimizar el efecto lo mejor es cortar de forma progresiva, como en una campana de Gauss. Así:

{% include image.html size="" file="ecg_f_gausiana.png" caption="" %}

Cuando apliquemos esa ventana al espectro todas las frecuencias mayores de unos 75Hz van a quedarse a cero. A efectos prácticos es un filtro pasa-bajos.

```
b = b .* gauss(f',1,0,40);

# filtro gausiano paso bajo
function gauss = gauss(x,a,b,c)
 # a: multiplicador
 # b: media
 # c: anchura
 gauss = a*exp(-(x-b).**2/c**2);
end
```

{% include image.html size="" file="ecg_f_pasabajos.png" caption="" %}

Para aplicar este proceso a varias muestras de datos lo mejor es hacemos un pequeño script en Octave. Lo llamaremos ECGfiltra:

```matlab
function [ c ] = ECGfiltra( a, sr )
 % normalizamos
 a=a/max(abs(a));
 
 % obtenemos la FFT:
 b  = fft(a);       % b es la fft de a
 np = numel(b) / 2; % np numero de puntos;
 b  = b(1:np);      % truncamos la fft
 
 % cancelamos la red y sus armónicos:
 for i=101:100:sr/2; % 100 es para este caso, ver texto*
  b(i) = (b(i-1) + b(i+1)) / 2;
 end
 
 f_bw  = (sr/2 / np);
 f = [0:f_bw:sr/2-f_bw];

 b = b .* gauss(f',1,0,40);
 
 % reobtenemos la forma de onda filtrada
 b = [b ; 0 ; conj(flipdim(b(2:np)))]; % completamos la FFT
 c = real(ifft(b)); % nos quedamos sólo la parte real
 c = c/max(abs(c)); % normalizamos
end

# filtro gausiano paso bajo
function gauss = gauss(x,a,b,c)
 # a: multiplicador
 # b: media
 # c: anchura
 gauss = a*exp(-(x-b).**2/c**2);
end
```

El resultado es algo mejor, y se intuye más o menos la forma de un ECG.

{% include image.html size="" file="ecg_t_pasabajos.png" caption="" %}

Aún queda algo de ruido, pero cada vez es más difícil filtrarlo. Pensad que aunque lo llame *ruido* puede ser una señal legítima, otra cosa es que no sea la que queremos. Pero, por ejemplo, algunas ondulaciones pueden deberse a la respiración u otros movimientos musculares.

Os he explicado la electrónica que interviene en registrar un electro, pero no soy médico y no sabría explicaros más. Si os interesa la interpretación fisiológica os recomiendo este artículo (y el blog en general, me gusta mucho): [El electrocardiograma, ese garabato con picos y curvas](http://perarduaadastra.eu/2010/01/el-electrocardiograma-ese-garabato-con-picos-y-curvas/). Un poco más técnico y para apreciar cómo varía la forma de la onda dependiendo de dónde se coloquen los electrodos (derivaciones) [este otro enlace](http://www.ecglibrary.com/ecghome.html).

Si os fijáis, antes de la caída brusca de la onda Q hay un pequeño pico. Es muy probable que lo hayamos inducido nosotros al filtrar, pues no olvidéis que filtrando lo que hemos hecho no es otra cosa que deformar la onda. Con un gel más conductor y una tarjeta de sonido adaptada, la onda que mediríamos sería más fuerte (mayor relación señal/ruido) y podríamos haber usado otro filtrado menos agresivo.

## El electrorretinograma

El corazón no es el único órgano que genera tensiones fácilmente medibles. En general miles de células despolarizándose al mismo tiempo generan una onda que se puede medir en la piel. El electrorretinograma consiste, como su nombre indica, en medir las señales eléctricas cerca de la retina cuando recibe un estímulo.

El procedimiento es sencillo, como en el electro colocamos dos electrodos, uno en el pómulo cerca del ojo y otro en la sien. Hay varias formas de estimular la retina dependiendo de lo que nos interese comprobar, voy a hacer la más simple: respuesta a un impulso luminoso aislado. Necesitamos un flash de una cámara fotográfica. Se trata de ver qué señales envía nuestro nervio óptico cuando disparamos el flash. El efecto es más notable si reducimos la luz ambiente y dejamos que el ojo se adapte a la oscuridad

{% include image.html size="" file="erg_t_sinfiltrar.png" caption="" %}

Poco nítido; o más bien digamos que no se ve nada. Está claro que la señal está al mismo nivel que el ruido. Formas de mejorar la medida, varias:

- **Acercarnos** a la fuente. Los electrodos que se utilizan para esta prueba suelen apoyarse en el globo ocular o incluso en la córnea. Para haceros una idea visitad [esta página](http://webvision.med.utah.edu/book/the-electroretinogram-erg/the-electroretinogram-clinical-applications/). Es una forma de aumentar la relación señal/ruido. La descarto por motivos obvios.
- Repetir y **promediar**. Al contrario que en el caso anterior del electrocardiograma, en el que queríamos un registro continuo de la actividad del corazón, lo que buscamos en un ERG es una respuesta a un impulso aislado. Este método consiste en aprovechar que el ruido es básicamente aleatorio, mientras que la señal que queremos medir es la misma cada vez. Así que se toman varias medidas (10 por ejemplo) y se promedian. El ruido, que repito es aleatorio, se cancelara pues en promedio vale cero y la señal se realzará distinguiéndose de él. No tengo tantas medidas para hacer la prueba, pero sería interesante hacerlo.
- Obtener el **perfil del ruido**. Como sabemos el momento en que ocurre la estimulación (el disparo del flash) todo lo anterior es ruido. Se puede obtener el espectro de frecuencias que componen el ruido y tratar de eliminarlo restándolo de la señal recibida. Se hace también con la FFT pero es más complicado. Veremos algunos gráficos aunque no lo voy a aplicar.
- Y por último, **filtrar** lo que queramos. El mismo procedimiento que hicimos en la sección anterior.

Vamos a hablar del **perfil del ruido**. Esta es la señal antes de disparar el flash. Se supone que el ojo está adaptado a la oscuridad.

{% include image.html size="" file="erg_t_ruido.png" caption="" %}

Y aquí vemos un detalle más ampliado:

{% include image.html size="" file="erg_t_ruido2.png" caption="" %}

El perfil, lo que nos serviría para construir la máscara del ruido es el módulo de la FFT:

{% include image.html size="" file="erg_f_maskruido.png" caption="" %}

Sin embargo ya os he dicho que **no vamos a aplicar este método**, sino que haremos un filtrado similar al que hicimos antes con el ECG. Si nos quedamos con las frecuencias bajas, apreciamos la forma de onda en su conjunto. Las ondas a y b. De nuevo yo no puedo explicaros a qué corresponden. Si os interesa aquí hay una explicación detallada: [Webvision - The Electroretinogram](http://webvision.med.utah.edu/book/the-electroretinogram-erg/the-electroretinogram-erg/).

{% include image.html size="" file="erg_t_filtrado_ayb.png" caption="" %}

Eso si nos quedamos con las frecuencias bajas. Aunque la respuesta al flash dura mucho más que una décima de segundo. Porque tras el fogonazo seguimos viendo chiribitas, hay un momento de desconcierto... en una palabra *hay actividad*, y en esa gráfica no la apreciamos. Sin embargo mirad lo que pasa si incluimos en la gráfica algunas frecuencias un poco mayores. Esto es lo que sale:

{% include image.html size="" file="erg_t_filtrado_altas.png" caption="" %}

## Conclusión

Espero que os haya gustado este breve paseo por la electrofisiología. Ya habéis podido comprobar lo que os dije: registrar señales eléctricas en el cuerpo es relativamente sencillo, lo que es más complicado es hacerlo en forma que le sirvan a un profesional.

Teníamos una tarjeta de sonido que filtra la entrada, conductores inapropiados, unos electrodos hechos con monedas con poca superficie y sujetos de mala manera con esparadrapo, agua salada en lugar de gel conductor... un montaje de lo más chapucero sin duda. Todo lo anterior son causas de ruido, las interferencias entran por el conductor no apantallado, las frecuencias que queremos las atenúa el filtro de entrada, los electrodos se mueven y hacen mal contacto.

Con todo y con eso, aplicando una sencilla ventana en forma de campana de Gauss sobre el espectro de frecuencias hemos conseguido eliminar la mayor parte del ruido, aún a costa de deformar la onda en algunos puntos. Pero no se puede hacer mucho más cuando la relación señal/ruido es tan baja. Desde luego este no es el mejor método para eliminar interferencias, pero creo que sí sirve para ver el concepto. Sobre filtros digitales hay un applet bastante curioso, [es este](http://www.falstad.com/dfilter/). En general todos los applets de esa página son interesantes.

Os dejo los archivos que he usado para el experimento [aquí]({{page.assets | relative_url}}/ECGyERG.zip). Van las muestras y los scripts de Octave por si alguien quiere hacer pruebas a su manera.

Por último, hace unas semanas me hice una cuenta de Twitter para el blog. Si queréis, [seguidme en Twitter](https://twitter.com/#!/electronicaycie).
