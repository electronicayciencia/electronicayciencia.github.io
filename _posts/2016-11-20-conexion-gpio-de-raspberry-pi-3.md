---
assets: /assets/2016/11/conexion-gpio-de-raspberry-pi-3
image: /assets/2016/11/conexion-gpio-de-raspberry-pi-3/img/300px-Pi-GPIO-header.png
layout: post
tags:
- Informática
- Raspberry
- Sensores
title: Conexión GPIO de Raspberry Pi 3
---

Este verano me compré una Raspberry Pi. ¿Es extraño que alguien que escribe un blog de electrónica no tenga una Raspberry? Tal vez. El caso es que quería contaros mis primeras pruebas centradas en la experimentación con la conexión GPIO.

Si habéis leído otros artículos de este blog dedicados a microcontroladores sabréis que suelo usar PIC. El objetivo de este artículo es reproducir algunas funciones para las usábamos PIC pero usando un dispositivo infinitamente más potente.

Comenzaremos con un repaso básico a lo que es la Raspberry Pi y sus accesorios a modo de introducción. Seguiremos con el manejo básico de los pines I/O usando la shell. Después pasaremos al **PWM** mediante la utilidad **gpio** de **WiringPi** y controlaremos un servo como ejemplo. Finalmente, para probar el **I2C** manejaremos un ADC tipo **PCF8591** por medio de los drivers internos.

{% include image.html size="small" file="300px-Pi-GPIO-header.png" caption="" %}

<!--more-->

## La placa base

Empecemos por un repaso básico. Estos dispositivos se llaman Low Cost Single Board Computers, que quiere decir que es un ordenador completo, de bajo consumo, con características modestas que está contenido en una placa un poco mayor que una tarjeta de crédito. Hay de varias marcas, distintos precios y diseños. El más común es de marca Raspberry. Fue también el primero en tener una acogida masiva. Hay otras marcas como ODroid o Banana Pi, cada uno con sus características y sus precios.

{% include image.html size="big" file="pi_board_pinout.jpg" caption="Placa y conexionado de Raspberry Pi3. [stackexchange](http://raspberrypi.stackexchange.com/questions/40318/raspberry-pi-2-can-gpio-pins-29-40-be-used-gpio-gen-input-output-configurable-in)." %}

La versión 3, que es la que voy a usar, salió en febrero de 2016 y cuenta con WiFi incorporada, Ethernet, varios puertos USB, HDMI y conectores para cámara, display, etc. Está basada en el BCM2837, evolución del BCM2835, un SoC (System on Chip) de Broadcom bien conocido. Un System on Chip no es más que un procesador, GPU y demás funciones integradas en un sólo componente. Se parece mucho a la electrónica de un smartphone. Este modelo es un ARM de 64bits a 1.2GHz, quad core y con 1Gb de RAM.

De la arquitectura no puedo contar mucho, ya que Raspberry no es Open Hardware. Hay disponibles versiones reducidas del esquema eléctrico, pero por hasta la fecha no hay intención de liberar el esquema completo. Por tanto muchos de los resultados se basan en la experimentación.

El chip que controla los puertos USB y la conexión Ethernet es el mismo, un LAN9514 de Microchip, produciendo un cuello de botella. Tened esto en cuenta si planeáis usarlo como NAS. Dado el precio del integrado y el uso general al que se destina el producto me parece una decisión de diseño más que razonable.

Lo importante es que todas las versiones cuentan con una conexión GPIO (General Purpose Input Output) triestado. Es decir salida nivel alto, bajo y alta impedancia -input-, como las de un microcontrolador. Al fin y al cabo son los mismos pines del BCM expuestos para nosotros. Eso sí, importante, funcionan a **3.3v** y no a 5v y carecen de cualquier tipo de **protección**.  No suele haber problema en conectarlas a 5v con una resistencia, pero es algo que el datasheet prohíbe expresamente, así que allá vosotros.

## Accesorios

Lo primero que compraría sería una **caja** apropiada para el uso que estéis pensando. La que yo veo más práctica para experimentar es la Pibow Coupé. Las cajas con este formato permiten acceder fácilmente a todos los conectores con un detalle muy útil: tiene serigrafiada la numeración de los pines. Lo único que no me gusta es que los pines GPIO sobresalen ligeramente de la caja y podrían engancharse con algo.

{% include image.html size="medium" file="coupe_flotilla.jpg" caption="Caja de acrílico tipo Pibow Coupe, color \"flotilla\"." %}

El **adaptador**, para un uso ocasional sirve perfectamente con un cargador de móvil de 5v. Eso sí, en cuanto queráis conectar un disco duro externo, por ejemplo, se os va a venir abajo. Recomiendan un cargador de 3 amperios, que también os puede servir para cargar un móvil que soporte carga rápida.

¿**Disipador**? No es malo pero tampoco lo necesita. Si queréis ponerlo tened en cuenta que las cajas como la de arriba sólo están preparadas para poner disipador en el chip principal.

El sistema operativo va en una **tarjeta Micro SD**, el tamaño no importa siempre que quepa el sistema operativo y el software que queráis instalar, el mínimo sin entorno gráfico diría que una de 2Gb.

Otros accesorios que considero muy útiles son un latiguillo de **cable de red** Ethernet para conectarla al router o al PC y un conector USB-Serie sobre todo para los que uséis portátil. Veremos por qué más adelante.

También os vendrá bien un juego de cables con conectores **Dupont** para experimentar:

{% include image.html size="medium" file="dupont_wire.jpg" caption="Cable arco-iris con conectores Dupont macho-hembra." %}

A propósito, ¿os habéis fijado que el cable que llaman "arco iris" en realidad tiene los mismos colores que las resistencias?

## Primeros pasos

El único SO que he probado es **Raspbian**, por lo que no puedo recomendaros otro para pruebas. Hay versión con entorno gráfico y versión sin él. Como sólo me conecto por ssh puedo instalar la versión ligera.

Para instalar el sistema operativo basta descomprimirlo y copiar la imagen en una SD. Viene preconfigurada con un cliente dhcp y el demonio Avahi habilitado con el nombre *raspberrypi.local*. Lo cual, si usáis linux, os va permitir acceder a ella con ese nombre por ssh en cuanto la conectéis a la red cableada. ¿Y si uso Windows? Bueno pues Windows no soporta de manera nativa el protocolo mDNS (DNS por multicast) así que no reconocerá el nombre. Podéis mirar en el router para saber qué IP le ha asignado en la red.

Si el SSH no funciona o se estropea por lo que sea, o si no tenemos cable de red y sólo podemos conectarla por wifi nos quedan aún dos opciones para comunicarnos con la Raspberry. Una obvia es conectar un teclado por USB y un monitor HDMI.

La otra, si sólo tenemos portátil y no disponemos de teclado o de monitor HDMI. En ese caso sólo nos queda una opción: la **consola serie**. La versión de raspbian que he probado tiene habilitada la consola serie por defecto. Para eso os recomendaba antes contar con un conector usb-serie. La configuración serie es 115200-8N1.

## Pinout GPIO

El chip **BCM2835** tiene una serie de registros que son los que controlan las entradas y salidas de propósito general (gpio). Por hardware, esos registros se mapean en un rango de memoria accesible por el sistema operativo. De esta forma podemos interactuar con ellos desde nuestro programa.

Habitualmente el acceso a memoria sólo se podría hacer como root, sin embargo hay un driver llamado gpiomem, que se encarga de mapear ese rango concreto de forma que sea accesible por el usuario.

La conexión gpio de este modelo tiene 40pin, con un conector igual al que usaban los discos duros IDE hace tiempo. Venden cables para conectarlos con una protoboard, pero no os lo recomiendo a menos que sólo vayáis a usar la Raspberry para experimentar porque estas clavijas una vez encajadas cuesta mucho quitarlas y se rompen con facilidad. En su lugar es preferible que compréis cables con conectores Dupont hembra-hembra y también macho-hembra.

{% include image.html size="medium" file="GPIO-RP3.png" caption="Disposición de los terminales GPIO. [techgeeks](http://techgeeks.de/). " %}

Entre los 40 terminales contamos con:

- **24 terminales de entrada / salida** de propósito general, con pull up y pull down independientes programables por software.
- Un módulo **UART**, entrada y salida.
- Dos canales **PWM** con DC independiente y dos modos de operación.
- Un bus **I2C**.
- Dos buses **SPI**.

Lógicamente todas estas funciones se pueden emular también por software en caso necesario, por supuesto con menor rendimiento que con el hardware nativo. Muchas librerías para Raspberry lo incluyen.

Por contra hemos de decir que no tenemos otros extras que incorporan algunos microcontroladores tales como **entradas analógicas** o comparadores accesibles desde el software.

Entrando un poco en detalles tenemos:

**Terminales de +5V**. Van conectados a la alimentación, detrás del fusible térmico de protección. Hay una cosa curiosa y es que pasado el fusible, las pistas de 5V de alimentación y de USB van unidas, por lo que técnicamente podríais alimentar la Raspberry desde el USB o desde GPIO. No se recomienda ya que habréis anulado el fusible de protección y cualquier corto que ocasionéis podría tener graves consecuencias. El fusible es de 2.5A en los modelos modernos (de tipo MF-MSMF250), por lo que restando el consumo de la Raspberry que son unos 600mA, podemos consumir más de 1A de estos pines. Siempre y cuando el adaptador de red lo dé, claro está.

**Terminales de +3.3V**. En las versiones anteriores a la 3 esta tensión la proporcionaba el propio chip por lo que no podía suministrar más de 50mA y eso es lo que leeréis en multitud de foros. Sin embargo en las más modernas se utiliza un conversor conmutado PAM2306, el cual según su datasheet podría proporcionar hasta 1A. Es el mismo conversor al que va conectado el chip así que tened cuidado y no abuséis de él.

**Terminales de GPIO**. Es la conexión para periféricos del BCM.

{% include image.html size="medium" file="raspberry-pi-circuit-gpio-input-pins.png" caption="Equivalente electrónico de un terminal GPIO. [mosaic-industries](http://www.mosaic-industries.com/embedded-systems/microcontroller-projects/raspberry-pi/gpio-pin-electrical-specifications)" %}

En general cada pin se puede configurar individualmente para funcionar como una salida o entrada de alta impedancia, con posibilidad de tener pull-up y pull-down ambas de 50kohm.

La tensión aplicada a una entrada no debería nunca ser superior ni inferior a la tensión de alimentación del integrado. Es decir, debe estar entre 0 y 3.3V. Los diodos que veis apenas llevan corriente y no serán capaces de mitigar una sobretensión en las entradas.

En caso de usar la patilla como salida, tendrá un nivel de entre 0 y 3.3V. Las especificaciones dicen que no debemos exceder los 50mA de **consumo** entre todas las salidas. Se refiere a cuando consumamos corriente de una salida que esté a nivel 1, por ejemplo alimentando un LED con el otro terminal a masa. La restricción no aplica cuando hablamos de nivel 0 y lo que hacemos es **drenar** corriente hacia masa, por ejemplo si el LED estuviera conectado entre el positivo y una salida GPIO. Esto es porque la pista interna del procesador que lleva la tensión positiva de 3.3V es mucho más débil que los mosfets que drenan la corriente hacia masa. La realidad es que estos chips suelen ser bastante resistentes, pero no olvidéis que **carecen de protección**.

Cada patilla, además de I/O puede tener funciones alternativas tal como I2C, UART o PWM.

El primer punto problemático es la numeración. Básicamente hay 3 sistemas:

- El etiquetado que sigue el BCM2837. Es decir los nombres GPIO4, GPIO7, etc. Es el que se indica en la caja Pibow.
- El número de terminal físico del conector de 40 pin.
- La numeración de wiringPi, que usa numeración propia pero a diferencia de las anteriores no varía entre versiones de Raspberry Pi.

{% include image.html size="big" file="gpio1.png" caption="Tabla de equivalencia numeración. [WiringPi](http://wiringpi.com/pins/)." %}

Así pues, tenemos el GPIO7, que en numeración de BCM es el 4, corresponde al pin 7 del conector y lleva la numeración WiringPi 7.

O también tenemos el terminal número 3 del conector, cuyo nombre es SDA. En la revisión 1 de Raspberry fue GPIO0 y en la siguiente versión fue el 2. Mientras que en WiringPi se numera como 8.

Sí, es un jaleo sobre todo en nuestros primeros proyectos. Cuando utilicéis código de ejemplo de alguna página debéis estar atentos a la numeración que siguen porque será vuestra principal **fuente de errores**.

## I/O directo

La forma más sencilla de activar y desactivar un puerto, o de leer el estado es utilizando el acceso a la memoria que nos expone gpiomem en forma de sistema de ficheros bajo la jerarquía /sys/class/gpio.

Dependiendo de la distribución de linux y su configuración podremos hacer este procedimiento como usuario o necesitaremos ser root.

Lo primero que haremos es "exportar" la patilla que queramos manejar. Así por ejemplo si queremos utilizar la GPIO11 (llamada *SCLK*, que corresponde al terminal número 23, y al WiringPi 14) ejecutaremos el comando:

```
echo 11 > /sys/class/gpio/export
```

Si ahora listamos el directorio /sys/class/gpio nos habrá creado un subdirectorio llamado /sys/class/gpio/gpio11. Si queremos que GPIO11 actúe como una entrada usaremos

```
echo in > /sys/class/gpio/gpio11/direction
```

Y leeremos su valor reflejado en el fichero value:

```
$ cat /sys/class/gpio11/value
0
```

Mientras que si queremos que sea una salida, usaremos

```
echo out > /sys/class/gpio/gpio11/direction
```

y escribiremos el valor donde antes lo leíamos:

```
echo 1 > /sys/class/gpio/gpio11/value
```

## I/O básico con ayuda de gpio

El método anterior es muy sencillo para probar aunque está bastante limitado. No se puede activar la resistencia de *pull up* o *pull down* por hardware, por ejemplo.

La siguiente manera más sencilla es utilizando la interfaz por línea de comandos de [WiringPi gpio](http://wiringpi.com/the-gpio-utility/). En Raspbian basta instalar el paquete llamado wiringpi. Incluye la línea de comandos y también las cabeceras C que usaremos en otros artículos. Hay más librerías, pero de momento los ejemplos los haremos con WiringPi.

La idea es tener una herramienta por linea de comandos, que sin programar nos permita hacer uso de ciertas características avanzadas de GPIO, tal como pull up/down, detección de flanco de subida/bajada, i2c, spi, etc.

Veamos cómo se haría para encender y apagar un LED a intervalos regulares (el programa equivalente a [Hello World](http://helloworldcollection.de/) pero en electrónica). Sería fijar un pin como salida, ponerlo a 1, esperar un momento, ponerlo a 0, esperar un momento y repetir.

```cpp
gpio mode 25 out

while (true)
do 
 gpio write 25 0
 sleep 0.5
 gpio write 25 1
 sleep 0.5
done
```

En el ejemplo hemos elegido el pin 25, que equivale al 26 según la numeración del BCM, que también es la GPIO26 (aunque en algunos sitios también aparece como GPIO25) y que en el conector físico es el pin número 37.

Leer el estado es igual de fácil, fijando la patilla como entrada y configurando el pull up o pull down:

```
$ gpio mode 25 in
$ gpio mode 25 up
$ gpio read 25
1

$ gpio mode 25 down
$ gpio read 25
0
```

Quizá una de las características más útiles es leer el estado de toda la interfaz GPIO y mostrarlo en forma de tabla; además nos sirve como tabla de equivalencia entre las diferentes numeraciones:

{% include image.html size="big" file="gpio_readall.png" caption="Tabla de equivalencia obtenida al ejecutar gpio readall." %}

## PWM

El siguiente experimento es controlar un servo. Como sabéis, un servo es simplemente un motor con unos engranajes reductores y un control de posición integrado. El modelo que vamos a controlar es el TowerPro MG995, que ya usamos otra entrada anterior: [Controlar un servomotor con el PC]({{site.baseurl}}{% post_url 2010-12-17-controlar-un-servomotor-con-el-pc %}).

{% include image.html size="medium" file="prod_560163449c7bf.jpg" caption="Servo para RC modelo TowerPro MG995." %}

Habíamos visto que para este servo se deben mandar impulsos de entre 1 y 2 ms, con una frecuencia de 50Hz. Siendo 1.5ms el pulso para que el servo se sitúe en la posición central, 1ms equivale a -60º y 2ms a 60º. Hay otros servos que giran 90º pero este se indica que sólo 60.

{% include image.html size="medium" file="servo_datasheet.png" caption="Forma de onda indicada en el datasheet del servo." %}

Se puede hacer de dos formas, por software haciendo un bucle, o por hardware usando el módulo de PWM.

En el caso de Raspberry, hacerlo por software es sencillo porque, a diferencia de un microcontrolador, dispone de threads. Es decir, hilos de ejecución paralelos. De forma que podemos lanzar un thread con el bucle de impulsos y otro con el programa principal. En un microcontrolador generalmente no se puede hacer eso, y tener un bucle software encargado solamente de los impulsos dificulta luego el resto del programa.

Para nuestro ejemplo lo haremos por PWM, que una vez aprendemos a usarlo es muy sencillo. El BCM2835 tiene dos canales de PWM, los llamaremos PWM0 y PWM1, cada uno se puedo conectar a ciertas patillas del integrado, pero no todas están en la conexión GPIO. Los puertos que tenemos a nuestra disposición en la Raspberry Pi 3 para PWM son los siguientes:

Canal **PWM0**:

- BCM 12 (pin físico 32, WiringPi 26)

- BCM 18 (pin físico 12, WiringPi 1)

Canal **PWM1**:

- BCM 13 (pin físico 33, WiringPi 23)

- BCM 19 (pin físico 35, WiringPi 24)

El módulo PWM tiene funciones avanzadas como salida balanceada o serialización de hasta 32 palabras de 16 bit. La serialización no la vamos a usar por ahora, pero el **modo balanceado** sí es conveniente que lo conozcáis.

Imaginad que queremos un Duty Cycle del 50%. En un PWM normal esto significa que la salida va a estar a nivel lógico 1 durante la mitad del periodo seguido, y a 0 durante la otra mitad. A este modo, el datasheet del BCM lo llama "**mark-space**". Sin embargo esto podría no ser óptimo en algunos casos, así que se implementa un algoritmo para mantener a 1 o a 0 la salida pero no durante medio periodo seguido, sino a impulsos distribuidos uniformemente. A este modo de operación lo llama balanceado. La conmutación se hace a alta frecuencia (MHz) y nos garantiza que en promedio va a estar a nivel alto el porcentaje de tiempo acordado, pero a base de impulsos distribuidos uniformemente.

Para nuestro servo necesitamos el modo mark-space. El modo balanceado es una idea muy buena pero no nos es útil en esta ocasión.

El módulo de PWM toma la frecuencia de reloj de un oscilador interno que trabaja a 19.2MHz. Hay tres parámetros para  configurarlo:

- El número de ticks de reloj que constituyen un impulso (parámetro **pwmc** o PWM Clock). Actúa como divisor de la frecuencia de reloj y su valor debe estar comprendido entre 1 y 4096.
- El número de impulsos que tiene un ciclo, rango (**pwmr**). Debe ser mayor que 0.
- El número de impulsos que la salida está a nivel alto durante cada ciclo (**pwm**). Estará comprendido entre 0 y el parámetro anterior pwmr.

En una modulación PWM tenemos siempre dos grados de libertad: la frecuencia y el duty-cycle; o bien el tiempo en nivel alto y el tiempo en nivel bajo. Aquí tenemos tres variables para dos grados de libertad, lo cual significa que hay dos variables que no son independientes, están ligadas. En este caso son lógicamente pwmr y pwmc, las dos conjuntamente determinan la frecuencia de trabajo.

¿Por qué tenemos dos variables que hacen lo mismo? Pues porque casi siempre están restringidas a valores pequeños. Si pwmr tuviera un valor máximo de 4096, entonces tendríamos que jugar con pwmc para dividir la frecuencia de reloj de manera que el valor para pwmr cayera dentro del rango permitido.

Tal vez en modelos anteriores de Raspberry pwmr estuviera limitada, por las pruebas que he hecho en este modelo no. La única limitación es que el registro es de 32 bit, así que su máximo es tan alto que en la práctica no es necesario usar pwmc. Si lo hacemos es por nuestra comodidad.

Por ejemplo si quisiésemos un **periodo de 5s**, con un tiempo alto de 250ms, se haría de la siguiente forma:

1. Fijamos **pwmc** a 2 (por algún motivo, cuando pwmc es 1 no funciona, así que el valor mínimo en la práctica es 2).
1. Con **pwmc** en 2, el contador se incrementa cada 2/19.2 = 0.104 us. Porque la frecuencia interna del reloj es 19.2MHz.
1. 5 segundos son 5.000.000us, por tanto el periodo **pwmr** debe ser 5 000 000/0.104 = 48 000 000.
1. El tiempo en nivel alto queremos que sean 250ms, que son 250000us, por tanto el valor del **pwm** será 250000/0.104 = 2 400 000.

{% include image.html size="big" file="pwm_5seg.png" caption="PWM configurado para un periodo de 5s y un tiempo on de 250ms." %}

Según indica el datasheet, el registro de Rango PWM es de 32 bit, suponemos que sin signo. Eso nos daría un **máximo de 7.45 minutos** cuando pwmc=2. Con una precisión de 0.1us. Mucho más que suficiente para cualquier aplicación.

Ahora vamos a controlar el servo. Haremos un procedimiento similar, aunque para simplificar los cálculos vamos a fijar pwmc=19. Como la frecuencia era de 19.2, al dividirla por 19 tenemos un pulso cada 1us aproximadamente.

La frecuencia para el servo era 50Hz, esto es 20ms de periodo, así pues pwmr=20000.

Si los tiempos para nivel alto están entre 1 y 2ms, el valor permitido para pwm está entre 1000 y 2000 respectivamente. Siendo el centro pwm = 1500.

El siguiente programa en bash hace que el servo gire en un sentido y después en el opuesto.

```cpp
#!/bin/bash

gpio mode 1 pwm    # Patilla BCM 18
gpio pwm-ms        # Modo mark-space
gpio pwmc 19       # 1 pulso ~ 1us aprox.
gpio pwmr 20000    # Periodo 20ms (50Hz)

MAX=2000           # +60 grados
MIN=1000           # -60 grados

WAIT=0.05          # Actualización 20 veces/seg
INC=20             # Incrementos de 20us cada vez

while true
do
 for i in `seq $MIN $INC $MAX`
 do
  gpio pwm 1 $i
  sleep $WAIT
 done

 for i in `seq $MAX -$INC $MIN`
 do
  gpio pwm 1 $i
  sleep $WAIT
 done
done
```

Para terminar con este apartado, decir que los dos canales de PWM0 y PWM1 comparten tanto la variable **pwmc** como **pwmr**, pero los valores de duty-cycle son independientes.

## I2C

Otra de las funciones de un microcontrolador es interactuar con periféricos serie. Raspberry tiene módulos hardware para I2C y para SPI. En este artículo vamos a explicar cómo se realiza la comunicación I2C.

Dispositivos I2C típicos son las memorias EEPROM serie 24xx, por ejemplo 24LC128. Sin embargo no vamos a utilizarla en este ejemplo porque, como veremos luego, requiere de una transmisión que no podemos hacer directamente con las utilidades de línea de comandos.

En su lugar he optado por conectar un módulo ya montado con el integrado **PCF8591**.

El PCF8591 es, como su datasheet indica, un dispositivo de adquisición de datos en un solo chip con interfaz I2C. Tiene 4 entradas analógicas de 8 bit, lo cual nos vendrá muy bien para suplir la carencia analógica de Raspberry. También tiene una salida DAC. Venden módulos con este integrado ya soldados y serigrafiados como el de la foto y son muy populares.

{% include image.html size="medium" file="PCF8591.jpg" caption="Modulo de pruebas con PCF8591. Se vende ya montado." %}

El módulo que encontraréis viene configurado con los siguientes canales:

- Canal 0: **NTC** (resistencia dependiente de la temperatura, con coeficiente negativo)
- Canal 1: **LDR** (resistencia dependiente de la luz, con coeficiente negativo)
- Canal 2: **entrada** **libre**
- Canal 3: **Potenciómetro** (trimmer en la placa ajustable manualmente)

Los canales se pueden desconectar del sensor por defecto mediante unos jumpers y la entrada queda libre para lo que queramos conectar. Además, la salida analógica DAC va conectada a un LED verde cuyo brillo varía dependiendo de la tensión que seleccionemos.

No voy contaros en detalle cómo funciona el protocolo I2C aunque si os interesa os invito a que veáis este video, mucho más ilustrativo que un tutorial:

{% include youtube.html id="8ZYMrcHm91s" %}

Para la práctica usaremos las herramientas del paquete i2c-tools, está en la paquetería de Raspbian.

El hardware I2C de la Raspberry requiere de un driver del kernel que tendremos que cargar previamente. Generalmente está habilitado por defecto, pero por si acaso verificadlo siguiendo las instrucciones de este enlace: [Configuring I2C | Adafruit's Raspberry Pi Lesson 4. GPIO Setup](https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-i2c).

Ahora ejecutaremos la utilidad i2cdetect para comprobar que efectivamente tenemos un bus I2C habilitado:

```
pi@raspberrypi:~$ i2cdetect -l
i2c-1   i2c             3f804000.i2c                            I2C adapter
```

Conectamos el módulo PCF8591 teniendo en cuenta que la línea de datos SDA va conectada a la patilla BCM 2, pin físico número 3, llamado SDA1_I2C en el pinout del principio. Y la línea de reloj va conectada a la SCL1_I2C, BCM 3, pin físico 5.

Todos los dispositivos I2C tienen un identificador de 7 bit, que se compone de una parte fija de 4 bit (1001 en el caso del PCF8591) y otra parte programable de 3 bit. El 8º bit indica el tipo de operación: 1 para lectura, 0 para escritura.

{% include image.html size="big" file="i2c_addressbyte.png" caption="Formato del primer byte I2C. Datasheet PCF8591." %}

La parte programable de 3 bit normalmente se fija conectando patillas del integrado a Vcc o a masa. Eso nos permite poder identificar hasta 8 integrados que compartan bus con la misma parte fija.

Cuando un chip recibe su identificador responde llevando la linea de datos a nivel bajo (señal de acknowledge). La herramienta i2cdetect explora todo el espacio de direcciones de 7 bit y muestra para cuales de ellas se ha recibido respuesta:

```
pi@raspberrypi:~$ i2cdetect -y 1
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- 48 -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
```

En este caso ha recibido **respuesta** para la dirección **48h**, equivalente en binario a 1001000; la dirección fija 1001 y las tres lineas programables puestas a 0. Ya sabemos que la comunicación de la Raspberry Pi con el dispositivo está funcionando, ahora estudiemos el datasheet en busca de comandos para enviar.

Las tramas I2C suelen tener la misma estructura:

- Se envía una la señal de **Start**. Que consiste en llevar la línea de datos a nivel bajo mientras la linea de reloj sigue en nivel alto. Esto es excepcional, porque todos los cambios de la linea de datos se hacen siempre estando la linea de reloj en nivel bajo.
- A continuación se trasmiten 7 bits con el **direccionamiento**, indicando el dispositivo al que se dirige la transmisión, más un octavo bit que indicará el tipo de **operación**: 1 para operaciones de lectura y 0 para escritura.
- El chip reconoce la dirección y contesta llevando a 0 la linea de datos en el siguiente pulso de reloj.
- Si es una operación de escritura, se transmite un **comando** formado por uno o varios bytes, estos serán específicos del chip con el que estemos trabajando. La trama puede tener tantos bytes como sean necesarios, por ejemplo si estamos escribiendo una página entera de memoria.
- Si se tratara de una operación de lectura el **máster** llevaría la linea de reloj alternativamente a valor alto y bajo leyendo por la linea de datos un flujo de bytes. Igualmente puede ser una respuesta de 1 o varios bytes dependiendo del comando que hayamos lanzado.
- Para terminar se lanza una señal **Stop**, definida como la inversa de la señal Start, es decir se libera lleva la linea de datos y por tanto se va a nivel alto mientras el reloj permanece en nivel alto. Cualquier dispositivo que lea esta señal da por finalizada la transmisión y vuelve a estar listo para recibir otro comando.

{% include image.html size="big" file="i2c_start_stop.png" caption="Condiciones de Start y Stop I2C. Dathasset PCF8591." %}

Las herramientas i2cset e i2cget nos dan la posibilidad de hacer operaciones simples.

**i2cset**: Transmite la marca de start; el byte de dirección con el último bit a 0 (escritura); a continuación envía todos los bytes que le digamos; y termina con la marca de stop.

**i2cget**: Transmite la marca de start; el byte de dirección con el último bit a 1 (lectura); a continuación envía un byte, que se supone que sería la dirección donde leer; recibe un byte o una palabra; y finalmente termina enviando una marca de stop.

Como veis la operación es sencilla pero sólo cubre unos casos muy concretos. Por ejemplo, en una operación de lectura de una memoria **EEPROM** serie tipo 24LCxxx hay que enviar dos bytes de posición. Cosa que no es posible con i2cget.

Sin embargo como la operación del PCF8591 es sumamente simple no hay problema. Para leer el ADC, según su datasheet, el procedimiento es el siguiente:

1. Mandar la **marca de start**, y el byte de dirección con el último bit a 0, escritura.
1. Mandar un **byte de control** indicando: el canal que vamos a leer; si después de ese vamos a leer el siguiente canal; si las entradas son diferenciales o independientes; si vamos a activar la salida DAC. Debajo tenéis el diagrama extraído del datasheet para que veáis lo que significa cada bit del byte de control.
1. Terminar la transmisión con una marca de **stop**.
1. Lanzar una operación de **lectura**. Los sucesivos bytes recibidos son las lecturas del ADC. El primer resultado no es una lectura actual, sino la última lectura que tenía almacenada el chip.

{% include image.html size="medium" file="pcf8591_control.png" caption="Contenido del byte de control. Datasheet PCF8591." %}

La primera parte podemos conseguirla con i2cget. Nos dirigimos al chip en el bus 1 (el único que hay) con la dirección 0x48, y le enviamos el control 0x01 (canal 1, la LDR por ejemplo):

    i2cset -y 1 0x48 0x01

La segunda parte hay que hacerla separada, porque i2cget no permite leer varios bytes seguidos. Así que leemos primero la última lectura almacenada en el chip, aunque no nos sirva para nada, porque sólo al leerla es cuando se inicia la siguiente conversión que es la que queremos:

    pi@raspberrypi:~$ i2cget -y 1 0x48
    0x3b

En este momento nos ha devuelto el valor de la última conversión que tenía almacenada. Y ahora comienza la conversión actual. Volvemos a lanzar el comando tras unos instantes para darle tiempo a terminar:

    pi@raspberrypi:~$ i2cget -y 1 0x48
    0xcc

Este sería el valor actual recién medido.

El siguiente script realiza una medida en el canal que le pasemos como primer argumento (0, 1, 2 o 3):

```cpp
#!/bin/bash

# Canal 0: NTC
# Canal 1: LDR
# Canal 2: entrada libre
# Canal 3: Potenciómetro
CHAN=$1
ADDR=0x48


i2cset -y 1 $ADDR $CHAN   # selecciona ch1
sleep 0.01

val=`i2cget -y 1 $ADDR`   # inicia conversión, la ignoramos
val=`i2cget -y 1 $ADDR`   # devuelve valor

printf "%d\n" $val        # convertir a decimal
```

La última parte del artículo será aprovechar la salida **DAC**. Si recordáis el diagrama anterior para el byte de control, hay que poner a 1 el bit 7 para que se active la salida analógica. Una vez activemos este bit, todos los bytes que enviemos detrás serán interpretados como valores de la salida DAC. El último valor que fijemos seguirá

Por ejemplo el siguiente comando fija la salida a su valor medio. Primero enviamos la dirección, luego el byte de control con el bit 7 a 1 y a continuación el valor que queramos entre 0 y 255, en este caso la mitad. Como veis los valores pueden indicarse tanto en hexadecimal como en decimal.

    i2cset -y 1 0x48 0x40 128

Hasta aquí la primera parte de las pruebas. El siguiente artículo lo dedicaremos a leer un sensor de temperatura con interfaz **1-Wire** de Maxim-Dallas, esta vez en C y con todo detalle. Espero que os haya servido y gracias por leer hasta el final.

Los archivos, imágenes, y datasheets más importantes los tenéis en este enlace: [Ficheros.]({{page.assets | relative_url}}/raspberryintro.zip)
