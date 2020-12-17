---
assets: /assets/2010/09/sensor-optico-sencillo-con-amplio-rango
featured: 'true'
image: /assets/2010/09/sensor-optico-sencillo-con-amplio-rango/img/esquema.png
layout: post
tags:
- Circuitos
- Fisica
- Optica
- PIC
- Sensores
title: Sensor óptico sencillo con amplio rango dinámico
---

Llevo ya unas cuantas entradas que no publico algo serio de electrónica. Espero que os guste este experimento. Se trata de usar la capacidad parásita de un LED para medir la luz incidente. Aviso de que esta entrada es larga.

Comenzaremos hablando de lo que es el rango dinámico, luego presentaré el esquema del montaje que se va a utilizar y la programación necesaria tanto en el PIC como en el PC. Después haremos un gráfico con los datos recogidos donde se ven distintos fenómenos y finalmente explicaré el principio físico en que se apoya.

## El rango dinámico

Seguramente ya sabéis que es prácticamente imposible encontrar un sensor electrónico que trabaje en toda la gama de valores que los sentidos humanos. Si pensáis por ejemplo en el **tacto**, será difícil encontrar un sensor electrónico capaz de detectar la menor rugosidad en una superficie, y que a la vez pueda soportar varios kilos de peso. O en el **oído** ningún micrófono tan sensible como para detectar la caída de un alfiler puede usarse para escuchar un concierto de rock, porque se saturaría e incluso puede dañarse.

La proporción entre la mínima señal percibida (justo por encima del nivel del ruido de fondo) y la máxima posible (valor de pico) es lo que se llama *rango dinámico*. Si hacemos caso a la Wikipedia en el caso del oído esa proporción es de 100dB, lo que equivale a 10.000.000.000. O sea, la señal más fuerte que podemos oír tendría una potencia que es **diez mil millones** de veces la menor señal audible. Es difícil (y caro) que un micrófono iguale ese rango. Con la vista pasa algo parecido. Sólo que en este caso la relación extremo-extremo es de 90dB, que equivalen a una relación 1:1.000.000.000.

De manera natural eso se consigue usando una especie de Control Automático de Ganancia, pero no siempre. Cuando pasamos de un ambiente ruidoso o luminoso a una estancia oscura y silenciosa necesitamos un tiempo de adaptación. Sin embargo después de haber cargado con unos cuantos kilos no pasamos un tiempo sin tacto. En electrónica también se utiliza un compresor y un control automático de ganancia. Sin embargo el sensor que os presento **no lo necesita** ya que es capaz de cubrir tanto niveles de luminosidad muy altos (sol directo) como muy bajos (oscuridad nocturna).

## Uso de un led como sensor óptico

Que un led se puede usar como fotodiodo no es ninguna novedad. Hay dos formas de hacerlo y ambas empiezan por polarizarlo al revés y medir la corriente inversa.

En un fotodiodo normal, la **intensidad** que circula estando polarizado en inversa es función de la luz que incide sobre él. En la construcción del fotodiodo se ha tenido en cuenta maximizar este efecto, porque esa es la función principal del componente. Sin embargo un LED no está hecho para eso. Igualmente, un LED es un diodo abierto a la luz, y si lo empleamos como fotodiodo también notaremos un incremento de la corriente inversa. Pero es muy leve, y así tal cual no nos va a servir.

La segunda forma es más ingeniosa. Consiste en aprovechar la **capacidad parásita** del dispositivo. Un LED tiene dos patas conductoras. Cuando está polarizado en directa estas patas están *unidas* por una unión semi**conductora**, sin embargo cuando está inversamente polarizado, tales están *separadas* por la misma unión **semi**conductora. Se trata de un resumen rápido, al final del artículo lo explico con un poco más de detalle. El caso es que cuando están separadas se forma una capacidad ridícula, del orden de los picoFaradios.

El truco está en que la corriente inversa que era demasiado leve para detectarla, es suficiente para descargar la capacidad parásita que decíamos antes en un tiempo determinado. Entonces se trata de polarizar el LED en inversa para *cargar* la capacidad, como si fuera un condensador. Y acto seguido cortar la corriente y medir la tensión en las patillas para ver cuanto tarda en descargarse. Como es una capacidad tan pequeña, el tiempo de descarga depende mucho de esa corriente. Y por tanto de la luz que incida.

La idea es buena, vamos a perfeccionarla:

- En primer lugar utilizaremos un microcontrolador. No sólo porque es la forma más simple de hacerlo sino porque tiene las propiedades que necesitamos.
- Por ejemplo para medir la tensión sin descargar una capacidad tan pequeña, necesitamos una impedancia de entrada altísima. Las entradas tipo CMOS de cualquier micro serán perfectas. Mejores que las de tecnología TTL.
- También necesitamos que el umbral esté bien definido para que no haya oscilaciones al medir. Después de todo sólo necesitamos saber la entrada está a nivel alto o a nivel bajo, no queremos saber qué tensión concreta tiene. Conviene aprovechar las entradas de tipo [Schmitt Trigger](http://es.wikipedia.org/wiki/Disparador_Schmitt) si las hubiera.
- Por último los tiempos de descarga pueden ser desde algunos microsegundos a varios minutos dependiendo de la iluminación y del LED concreto. De nuevo cualquier micro nos sirve para medir estos tiempos.

Un vicio habitual es que una vez se conocen y se aprenden a usar los microcontroladores, se deja de pensar en circuitos analógicos que podrían ser igual o más sencillos. He visto tirar de PICs en temporizadores que se  harían fácilmente con [un par de transistores]({{site.baseurl}}{% post_url 2010-04-27-multivibrador-astable-transistores %}) o con [integrados comunes]({{site.baseurl}}{% post_url 2010-03-23-watchdog-para-pc-con-alarma %}). Antes de poneros a programar es una buena costumbre pensar si está justificado, bien por tiempo de diseño, bien por precio, o por simplicidad o por capacidad escalado. Aunque después de todo, como el circuito va a ser para nosotros lo haremos como nos dé la gana.

## Esquema eléctrico

Para las pruebas he usado un PIC12F683. Se podría hacer con cualquier otro modelo más básico ya que no usamos ninguna función avanzada.

{% include image.html size="medium" file="esquema.png" caption="" %}

Esta es la configuración de los pines:

<table><tbody><tr><th>Pin</th><th>Puerto</th><th>I/O</th><th>Función</th></tr><tr><td>7</td><td>GP0</td><td>O</td><td>TX serie (9600,8,E,1)</td></tr><tr><td>6</td><td>GP1</td><td>O</td><td>LED o Altavoz</td></tr><tr><td>5</td><td>GP2</td><td>I</td><td>LED sensor</td></tr><tr><td>3</td><td>GP4</td><td>ADC</td><td>LDR, opcional</td></tr></tbody></table>

He preparado dos versiones del programa. En la primera se va alternando la salida del puerto GP1 cada vez que se descarga el sensor. Si conectamos un LED a ese puerto lo veremos parpadear más lentamente en la oscuridad y más rápido cuando le dé la luz. Cuando la intermitencia sea demasiado rápida para verla, mejor conectamos un altavoz y así oiremos el tono.

En la segunda versión se hace una medida cada segundo y se transfiere la información al PC utilizando una conexión serie, gracias a [este adaptador]({{site.baseurl}}{% post_url 2010-03-22-conversor-usb-rs232 %}) RS232-USB.

El LED conectado al GP2 es el sensor, y va polarizado en inversa. Yo he obtenido muy buenos resultados usando un led infrarrojo. Pero lo mejor es coger la primera versión del programa y probar varios LEDs.

Hay una entrada analógica prevista para una LDR, por si se quiere comparar, pero no está implementado en el código.

La resistencia de 1k puesta en serie con el LED limita la corriente inversa. La tensión de ruptura inversa de los LED comunes anda por los 5V, por eso se dañan fácilmente si se conectan del revés sin cuidado.

Para que no me ocupe toda la página inicial pongo un enlace de *Seguir leyendo*. Si por ahora te interesa pincha debajo.

<!--more-->

## Programación del micro

La programación del PIC no podía ser más sencilla. Pego un extracto de la segunda versión (la que transmite los datos por el puerto serie) y lo explico.

```c
// Tiempo entre medidas consecutivas, en ms
#define delay_medidas 1000
// Tiempo en us para cargar la capacidad parasita
#define delay_carga 15

#define PIN_Sensor  PIN_A2  // INPUT led, es el único que tiene entrada tipo ST
#define PIN_SrTX    PIN_A0  // TX serie para conectar al PC
#define PIN_LED     PIN_A1  // salida para un led, no confundir con el led sensor

#use rs232(baud=9600,INVERT,DISABLE_INTS,parity=E,xmit=PIN_SrTX,rcv=PIN_SrTX,bits=8)

[...]

void main()
{
 unsigned int32 contador;
 
 setup_timer_0(RTCC_INTERNAL|RTCC_DIV_1);
 setup_oscillator(OSC_8MHZ);
 port_a_pullups(FALSE);

 for (;;) {
  contador = 0;
  
  // cargar el led sensor y reiniciar el contador
  output_high (PIN_Sensor);
  delay_us(delay_carga);
  
  // poner el pin en modo INPUT y comenzar a contar
  // hasta que se apague
  while (input(PIN_Sensor))
   contador++; 
  
  // Lo máximo son 4294967295, 10 dígitos.
  // El paquete que se envía es del tipo: (0000000000)\n
  printf("(%010Lu)\n", contador);
  delay_ms(delay_medidas);
 }
}
```

Como hemos dicho, se trata de cargar la capacidad parásita del led, y luego pasar esa patilla a modo entrada. Incrementamos el contador mientras siga dando un estado ALTO, porque la capacidad no se ha descargado lo suficiente. En cuanto ocurra la transición mandamos el valor al PC y esperamos un segundo para hacer la siguiente medida.

*contador* se incrementa dentro de un bucle que incluye comprobar el puerto. En el MPSIM averiguamos que cada iteración requiere 15 instrucciones en ensamblador (se ve rápidamente con el *stopwatch*). Cada instrucción del PIC se ejecuta en 4 ciclos del reloj, y como este funciona a 8MHz se ejecutan 2 millones de instrucciones por segundo. Entonces el contador se incrementa cada 7.5µs.

El tiempo de descarga puede llegar a varios segundos, o minutos. Si *contador* fuera una variable entera de 16 bits, cuyo valor máximo sin signo es 65535, tendríamos un máximo de 0.5 segundos. Medio segundo es muy poco, necesitamos 32 bits. Con 32 bits el máximo valor es 4.294.967.295, que nos da para casi 9 horas. Es demasiado, sí, pero con 16 bits ya habéis visto que se nos quedaba corto.

Observad una cosa, ¿recordáis que habíamos hablado de que el rango dinámico de la vista es de aproximadamente 1.000.000.000? Pues es del orden de la variable *contador*. Con 32 bits tendríamos para un rango de 96dB, mientras que con 16 para sólo 48. El que 16 bits se queden cortos y necesitemos 32 es una buena señal. El rango en dB se calcula así, siendo **b** la longitud en bits:

$$
10\cdot\log_{10}(2^{b}-1)
$$

## Programación del PC

Ahora que tenemos un circuito que envía datos periódicamente al PC, tendremos que recogerlos. He optado por hacer el programa en Perl. El módulo [Device::SerialPort]({{page.assets | relative_url}}/SerialPort.pm) que podéis encontrar en CPAN es muy fácil de usar y además funciona tanto en Linux como en Windows.

El [adaptador]({{site.baseurl}}{% post_url 2010-03-22-conversor-usb-rs232 %}) que hemos usado se conecta al USB y, en Linux, crea un dispositivo serie de nombre */dev/ttyUSB?*. Nosotros tenemos que leer del puerto hasta encontrar una cadena con el formato *(xxxxxxxxxx)* que son los paquetes que transmite el detector.

Cuando nos llegue extraemos el valor, comprobamos que es válido y lo imprimimos por pantalla acompañado del *timestamp* (marca horaria). El listado del código es una cosa así:

```perl
#!/usr/bin/perl 
#===============================================================================
#  DESCRIPTION:  Recoge los datos del sensor USB y los acompaña del timestamp.
#                gtkterm --port /dev/ttyUSB0  --speed 9600 --parity even
#===============================================================================

use strict;
use warnings;

use Device::SerialPort 0.12;
use Time::HiRes qw /sleep/;
$| = 1;

my $PORT = "/dev/ttyUSB0";

my $s_port = Device::SerialPort->new ($PORT) 
 || die "Can't Open $PORT: $!";
$s_port->baudrate(9600);
$s_port->parity("even");
$s_port->databits(8);
$s_port->handshake("none");
$s_port->write_settings;

$s_port->purge_all();
$s_port->purge_rx;

while(1) {
 my ($count_in, $string_in) = $s_port->read(255);
 next if $count_in > 15;

 sleep 0.1;
 next unless $string_in ne "";

 my ($valor) = $string_in =~ /\((\d+)\)/;
 next unless $valor;

 print time."\t".$valor."\n";
}
```

## Durante el anochecer

La salida o la puesta de son los momentos apropiados para probar el invento. En unas horas se pasa de máxima luminosidad a oscuridad. Y nos permiten barrer todo el rango de valores posibles. Eso sí, tenemos que cuidar que el ángulo de detección sea pequeño. El LED de por sí ya es bastante direccional, pero le ayudaremos colocándolo dentro de un cilindro opaco para que las luces de la ciudad nos afecten lo menos posible.

Recogemos los datos en el PC y los graficamos. Hay que transformar los datos recogidos, para pasar del número del *contador* a segundos o milisegundos. Y puesto que en algunas zonas el ruido es grande, he optado por graficar también una curva de interpolación. Los datos están en color VERDE. Y la interpolación en ROJO.

Se podría haber hecho la transformación en el micro, y suavizar los datos haciendo por ejemplo tres medidas en un segundo y devolviendo la media de las tres. Así filtramos mucho ruido. Pero [ya dijimos]({{site.baseurl}}{% post_url 2010-05-28-preamplificador-microfono-electret %}) que siempre conviene recoger los datos en crudo y hacer el procesado posterior teniendo guardados los originales. Si hago el procesado en el micro pierdo las medidas reales. Por no mencionar que el PC tiene mucha más potencia y herramientas pensadas precisamente para eso.

Durante la puesta de Sol, entre las 19:00 y las 19:30 la luz da directamente contra la ventana, lo que provoca ese pico de luminosidad comparado con la luz durante la noche. Como sabemos que el tiempo de descarga aumenta cuando se oscurece y disminuye con la luz, graficaremos la inversa de este, así un tiempo muy pequeño indicará mucha luz. Como en este gráfico:

{% include image.html size="big" file="an_20100830_lineal.png" caption="" %}

Sin embargo por la diferencia de escala tan grande que hay entre unas medidas y otras, no podemos ver apenas detalles a partir de las 21:00. En estos casos es útil recurrir a la escala logarítmica. No paséis por alto que el eje Y crece hacia abajo, porque a mayor luminosidad menor tiempo de descarga.

{% include image.html size="big" file="an_20100830_completo.png" caption="" %}

Aquí el pico anterior se ve mucho más reducido, y ya sí apreciamos otros detalles. Por ejemplo a partir de las 19:00 hemos dicho que el Sol incide directamente contra el sensor, y se ve como va bajando la intensidad luminosa. Sin embargo es cuando el Sol está próximo al horizonte, a partir de las 20:30, cuando desaparece rápidamente. En cuestión de 45 minutos ya se ha hecho casi de noche.

En ese intervalo se ve ruido en torno a las 20:30 - 20:50. Probablemente sea debido a la influencia de la atmósfera, tal vez por la contaminación. A medida que el Sol se va poniendo, los rayos tienen que atravesar una capa de atmósfera mayor. Y experimentan distintas dispersiones. Ese es el motivo de que veamos el cielo azul durante el día, pero rojo o anaranjado durante la salida y la puesta. Por ejemplo a las 21:00 hay un ligero cambio en la tendencia. Un aficionado a la astronomía puede daros más detalles.

A partir de las 21:30 ya ha oscurecido lo suficiente y se encienden las farolas. Se nota a partir de esa hora un incremento del ruido. Podría pensarse que es por el parpadeo a 50Hz que tienen las lámparas, pero nuestras medidas son demasiado lentas para captarlo. A estos niveles de luz cada medida puede durar más de un segundo. La causa es otra: el ruido eléctrico que emiten. Como nuestro sensor es de tipo capacitivo y no estaba blindado el ruido electromagnético influye mucho en las medidas. Por eso, [los micrófonos electrec]({{site.baseurl}}{% post_url 2010-06-04-utilizar-un-microfono-electret %}) van dentro de una cápsula metálica.

A partir de las 22:15 algunos vecinos encienden las luces de las terrazas exteriores. Aunque el sensor está mirando hacia arriba, parte de la luz se refleja, es prueba de la contaminación lumínica. Ese aumento de la iluminación del cielo nocturno lo capta el sensor, y se ve un ligero incremento a partir de la hora de cenar.

Ya habéis visto que tenemos sensibilidad tanto en niveles altos como en niveles bajos. Si calculáis la inversa del tiempo de descarga, teniendo en cuenta que está en milisegundos, sabréis la frecuencia en la versión primera del código. Empieza en 1000Hz, crece rápidamente hasta hacerse casi inaudible y luego desciende por debajo de 1Hz.

## Sensibilidad a la luz

Para terminar el experimento. Vamos a ver qué pasa si damos la luz de la habitación en cuya ventana tenemos puesto el sensor. Recordemos que está rodeado de un tubo de cartón y apuntando hacia el cielo. ¿Se notará en la medida? Este es el gráfico:

{% include image.html size="big" file="detalle_luces_ventana.png" caption="" %}

A las 22:55 comienzo a probar con la lámpara de interior y con un flexo de escritorio. Es resultado es claro. Cualquier leve cambio en la iluminación ambiente, ya sea de dia o de noche, lo puede captar el sensor sin ningún problema. Claro está, siempre que el cambio sea proporcional al valor actual. Igual que los sentidos humanos. Es lógico que, durante un concierto, no escuchemos un susurro; al igual que es difícil ver la pantalla del móvil a plena luz del día. En alguna entrada tengo intención de hablar de la ley de Weber y de Stevens, ya anticipamos algo al diseñar la [curva de respuesta de un dimmer]({{site.baseurl}}{% post_url 2010-06-23-curva-de-respuesta-del-dimmer-ir %}).

## Valores máximos y mínimos

¿Os habéis fijado en cuál es la magnitud que depende de la luminosidad? No es la tensión de salida, como en un micrófono. Sino el tiempo. El tiempo es fácil de medir en cantidades pequeñas y grandes. Cualquier microcontrolador mide microsegundos, hasta nanosegundos con una frecuencia de reloj suficientemente alta, y podría medir horas. Cubrimos sin problemas desde 10<sup>-6</sup>s a 10<sup>3</sup>s.

Si tuviéramos que medir el voltaje, tendríamos que tener un circuito tan sensible como para medir **microvoltios**, sin contar el ruido, y que igualmente midiera miles de voltios en la misma escala. Claro que nada nos impide diseñar un sensor que dé 0V en la oscuridad y 5V en el máximo de luminosidad, y así medimos todo el rango con el mismo circuito. Pero eso es precisamente lo que decíamos al principio: comprimir el rango dinámico.

La pregunta que se nos viene a la cabeza es ¿cual es el rango completo, desde el máximo hasta el mínimo? Es evidente que no es el del gráfico, porque ahí influye la iluminación nocturna.

- **Máxima iluminación**: Mientras más luz aplicamos, antes se descarga del LED. En principio, el máximo viene dado por lo rápido que podamos medir el tiempo de descarga. Con 8MHz de reloj, habíamos visto que el mínimo tiempo eran 7.5µs, y cuando el Sol daba directamente llegábamos a ese máximo. En cambio si usáramos un reloj de 100Mhz, esos 7.5µs se convierten en 600ns. También podemos usar otro tipo de LED, menos sensible a la luz.
- **Oscuridad**: En el lado opuesto, ¿cuánto tardará en descargarse el LED en ausencia completa de luz? Pues la respuesta es que depende del material y de la temperatura (sí, de la temperatura, por el ruido térmico). Y por supuesto del ruido eléctrico de los alrededores.

Como curiosidad, he medido el sensor en la oscuridad más completa que he podido conseguir. Eso implica envuelto en tela negra, dentro de un cajón, de noche con la luz apagada y la persiana cerrada. El valor más alto que registrado ronda los 5000000, equivalente a unos 37 segundos. En comparación, la iluminación nocturna, que da 4 segundos como máximo (ver gráfico logarítmico de arriba), es 10 veces superior.

He probado y estando oscuro detecta luces tan tenues como un mechero, o la luz del móvil. El problema es que midiendo en la oscuridad los tiempos se disparan por encima de los 30 segundos. Y eso reduce el tipo de usos que se le pueden dar.

## ¿Por qué pasa?

Para saber cuál es la causa de todo lo que hemos desarrollado en esta entrada hay que entender primero cómo funciona un diodo. En [esta página](http://www.electronics-tutorials.ws/diode/diode_3.html) tienen algunos tutoriales interesantes, y he cogido un par de imágenes que me vienen bien para explicar lo siguiente. Supongo que ya sabéis cómo funciona un diodo y por qué conduce en un sentido sí y en el otro no.

Este es por dentro el diodo en estado de reposo, o sea sin que le apliquemos ningún potencial:

{% include image.html size="small" file="diode13.gif" caption="" %}

Ahora vamos a aplicarle un potencial inverso. Digamos que los *portadores de carga* (electrones y huecos) se apiñan atraídos por el potencial a los lados del material. Si ahora quitamos la batería (cortamos el potencial sin juntar las patillas) se habrá quedado un campo eléctrico. Es el principio de un condensador.

{% include image.html size="small" file="diode6.gif" caption="" %}

Si medimos inmediatamente, habrá la misma tensión que habíamos aplicado al principio. Y lentamente se irá descargando para llegar a la imagen primera. Cuando los portadores estén otra vez distribuidos ya no habrá campo eléctrico ni por tanto tensión en las patillas. Estará descargado.

Los portadores no se mueven sólos por el semiconductor, necesitan obtener energía de algún sitio para volverse a colocar como al principio. Esta energía la obtienen de tres formas:

- **Calor**: como el material está a una cierta temperatura los portadores se mueven aleatoriamente, y se difunden por el material hasta llegar a la posición neutra. Para observaciones de precisión como experimentos astronómicos, o de física de partículas, es habitual tener que enfriar los detectores para que el ruido térmico del sensor no estropee las medidas que buscamos.
- **Campo externo:** Ya lo hemos dicho antes. Un sensor que usa el método capacitivo es muy sensible a los cambios en el campo electrostático que lo rodea. Es una especie de antena. Por eso conviene blindarlos.
- **Radiación externa**: Esta es la que nos interesa. Un fotón puede *empujar* a los portadores. Además, si la energía de la luz incidente es igual o mayor que la emitida por el diodo, puede arrancar electrones y generar una corriente, igual que en una célula fotoeléctrica. Es la causa principial de la corriente, sin embargo en esta aplicación no es estrictamente necesario.

Cuando parte de los portadores se han redistribuido y el potencial entre las placas decrece, llega un momento en que la entrada del PIC (recordad que es de tipo Schmitt) comnuta a nivel bajo. En ese momento paramos el contador y transmitimos el dato. Luego a aplicar tensión inversa durante unos microsegundos para recargar el LED. Y así de forma cíclica.

## Conclusiones

Hemos visto cómo aprovechar una característica parásita para utilizar un dispositivo electrónico de forma distinta a la prevista.

Así utilizado, el tiempo de medición depende de la cantidad de luz. Con poca luz diríamos que es un dispositivo muy lento. No se puede usar para intercambiar información, tal como usaríamos un fotodiodo. Sin embargo sí puede ser muy útil como fotómetro, porque cubre todo el rango de iluminación posible.

También hemos aprendido a medir capacidades con un PIC. Este método nos puede servir más adelante en otros proyectos.

Como siempre, os dejo los archivos [en esta dirección]({{page.assets | relative_url}}/sensorled.rar). Van las dos versiones del programa para el micro (sonido, y transmisor de datos) y el recolector de datos en Perl. Así como los datos recogidos durante el experimento.
