---
assets: /assets/2011/08/rastreador-de-redes-inalambricas
layout: post
tags:
- Informática
- Radio
title: Rastreador de redes inalámbricas
---

Hoy os traigo un artículo breve de programación. Este programa nos ayudará a localizar la fuente de una wifi siempre y cuando tengamos una antena directiva. A modo de radar, el sistema emitirá un tono cada vez que recibamos una baliza de la red seleccionada, y de una frecuencia más alta mientras mayor sea la potencia recibida.

<!--more-->

## Fundamento

Cuando pedimos mostrar la lista de redes inalámbricas al alcance ¿de donde sale tal información? Las redes wireless se pueden configurar para que anuncien o no anuncien el punto del acceso. Por defecto, el punto de acceso (o uno de los nodos si es una red ad-hoc) emite al aire unos paquetes anunciando la red. Se conocen como *balizas* y constan, entre otros datos, el nombre de la red y la MAC del punto de acceso. Normalmente se emiten diez balizas por segundo. Así, cuando pedimos la lista de redes el PC hace un barrido (*scan*) de los 11 canales wifi deteniéndose 0.1 o 0.2 segundos en cada canal para ver qué balizas le llegan. Al cabo de 1 o 2 segundos tenemos la lista completa.

No hace falta decir que sólo podemos hacer el barrido mientras no estamos conectados, porque de lo contrario al cambiar de canal dejaríamos de recibir los paquetes de la red a la que estemos conectados. Cuando optamos por ocultar el punto de acceso le estamos pidiendo al router que pare de enviar balizas. Y ya no aparece en la lista de redes. Pero eso no esconde la red en absoluto. Pues en cuanto haya un usuario conectado, los paquetes que se transfieren cuentan también con los mismos datos que había en la baliza. Esté o no cifrada.

El programa *airodump-ng*, de la suite [Aircrack](http://www.aircrack-ng.org/doku.php?id=airodump-ng), nos da la información necesaria y ya se encarga de comunicarse con los drivers de la tarjeta wifi. El formato de salida es algo así:

    CH  9 ][ Elapsed: 1 min ][ 2007-04-26 17:41 ][ WPA handshake: 00:14:6C:7E:40:80>
    BSSID              PWR RXQ  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID>
    00:09:5B:1C:AA:1D   -51  16       10        0    0  11  54.  OPN              NETGEAR>
    00:14:6C:7A:41:81   -64 100       57       14    1   9  11e  WEP  WEP         bigbear>

Lo que a nosotros nos interesa es esta parte:

     00:09:5B:1C:AA:1D   -51  16       10

- Lo primero es la MAC del punto de acceso.
- Luego viene la potencia de la señal recibida, en dBm.
- Lo siguiente es un parámetro que airodump llama *calidad de recepción*. Que no es más que el porcentaje de paquetes recibidos correctamente en los últimos 10 segundos. Salvo que no haya más redes inalámbricas alrededor y estemos a una distancia óptima del emisor es difícil alcanzar siempre el 100%. En cuanto haya alguna interferencia es inevitable que algún paquete se reciba mal. Pero es un buen indicador.
- Y por último el número de balizas recibidas. Si está configurado por defecto ya hemos dicho que mandará a un ritmo de 10 por segundos.

Da otros datos interesantes, pero que no vamos a utilizar en este artículo. Vamos a ver el código fuente.

## Código

Como viene siendo habitual lo he programado en Perl. Os pego el código y debajo lo comentamos.

```perl
#!/usr/bin/perl -w
use strict;

$| = 1;

my $BSSID  = "00:12:18:DE:1E:83"; # Identificador del punto de acceso
my $iface  = "wlan1";  # interface
my $ch     = 10;       # número de canal

# ------------------------------------------------------------
my $BcPS   = 10;       # balizas por segundo
my $BeepOn = 0.3;      # fracción del beep y del silencio

# En funcion de lo anterior, calculamos la duración del tono
my $duracion = $BeepOn * 1/$BcPS * 1000;

# f_min =  300Hz para -80db: frecuencia mínima para la potencia más baja
# f_max = 1000Hz para -40db: frecuencia máxima para la mayor potencia
my ($P_min, $F_min) = (-80, 300);
my ($P_max, $F_max) = (-40, 1000);
# ------------------------------------------------------------

# Preparamos la consola para enviarle tonos (casi siempre
# hace falta ser root).
open my $consoleFH, "> /dev/console"
 or die "No puedo abrir la consola: $!: Prueba como root.\n";

my ($pow, $rxq, $beac, $beac_old);
$beac = $beac_old = 0;

open my $airodump, "airodump-ng $iface -c $ch --bssid $BSSID 2>&1 |";

while (<$airodump>) {

 # Parseamos la línea, nos quedamos con la potencia
 # la calidad de recepción y el número de balizas.
 /^\s+$BSSID\s+(-\d+)\s+(\d+)\s+(\d+)/ or next;
 ($pow, $rxq, $beac) = ($1,$2,$3);
 
 # Comprobamos que se haya recibido alguna baliza más.
 next if $beac == $beac_old;
 $beac_old = $beac;
 
 # Calculamos la frecuencia sabiendo la potencia.
 my $frecuencia = ($F_max-$F_min)/(-$P_max)*($pow-$P_min)+$F_min;
 $frecuencia > $F_max and $frecuencia = $F_max;
 $frecuencia < $F_min and $frecuencia = $F_min;

 tono($frecuencia, $duracion);

 printf "\rBSSID: %s    Potencia: %ddB    Balizas recibidas: %d (%d%%).",
  $BSSID, $pow, $beac, $rxq;
}

# Llama a la ioctl KDMKTONE sobre $consoleFH para generar un tono de duración 
# determinada. Para no abrir /dev/console varias veces por segundo se espera 
# que ya esté abierta en el la variable global $consoleFH.
# Frecuencia en Hz, duración en ms.
sub tono {
 my ($frecuencia, $duracion) = @_;
 my $timerfreq = 1193181.8181; # Frecuencia teorica del timer 8254.
 my $KDMKTONE = 0x4B30; #/usr/include/linux/kd.h

 $frecuencia = int($timerfreq / $frecuencia);
 $duracion   = $duracion; # La docu dice que esto tb iria en ticks ¿?
 my $arg = ($duracion << 16) + $frecuencia;

 ioctl($consoleFH, $KDMKTONE, $arg);
}
```

De las líneas **6** a **8** configuramos qué red queremos seguir. Entre las líneas **11** y **20** programamos otros parámetros internos del programa, como son la frecuencia a potencia máxima y a potencia mínima. O el número de balizas que se esperan por segundo.

La línea **12** es el porcentaje del tiempo que suena el beep, varía entre 0 y 1. Si ponemos 1 y esperamos diez balizas por segundo sonará durante toda la décima de segundo que hay entre una baliza y la siguiente. A medida que bajamos sonará menos tiempo.

Una vez definidos los parámetros, el bucle principal es bien sencillo:

- Capturamos la salida de airodump.
- Con una expresión regular filtramos la salida a la vez que obtenemos los datos que necesitamos (potencia, calidad de recepción y balizas recibidas). Línea **37**.
- Comprobamos si hemos recibido alguna baliza, comparando el número que teníamos en la anterior iteración (línea **41**).
- Si hemos recibido alguna, calculamos la frecuencia en función de la potencia. Línea **45**. Hay que tener en cuenta que las potencias son negativas.
- En caso de recibirse con más o menos potencia de la esperada, acotamos la frecuencia.
- Emitimos una señal acústica. Línea **49**, ver más abajo.
- Y por último mostramos por pantalla los datos. Línea **51**. Notad el carácter \r al comienzo y la ausencia de \n al final. Lo que hace que se escriba siempre en la misma línea. Como la longitud del mensaje es siempre creciente no es necesario poner en blanco la línea antes de escribir la siguiente.

## La función *tono*

Hay dos cosas importantes que aprender de este programa. Una, el cómo utilizar la salida de un programa para interpretarla y hacer cosas con ella. Eso lo conseguimos con la llamada a *open* de la línea **31**. Notad la redirección de stderr a stdout para capturarlo todo.

Y la otra es cómo hacer sonar el altavoz. Os cuento, hay dos maneras de emitir sonidos:

- Utilizando /dev/dsp o /dev/audio. Abrimos el dispositivo, le configuramos la frecuencia de muestreo y el tipo de samples que vamos a enviar. O mejor aún, cargar algún módulo de CPAN que nos lo haga. Como por ejemplo [Audio::DSP]({{page.assets | relative_url}}/DSP.pm) o [Audio::OSS]({{page.assets | relative_url}}/OSS.pm). Nos generamos nuestra sinusoide de la frecuencia que queramos y ya tenemos un tono. Es un método estupendo para hacer un generador de funciones, o reproducir un archivo de audio. Sin embargo da problemas para generar tonos discontinuos, breves y sobre todo en tiempo real, como los que necesitamos.
- Aunque tampoco hay que complicarse tanto. Para lo que queremos basta con utilizar el altavoz interno de la placa base, lo que siempre se ha llamado *system bell*. Aunque ahora también lo controle la tarjeta de sonido. Y tiene la ventaja de que son llamadas no bloqueantes y prácticamente en tiempo real.

En Linux, el altavoz del sistema es un dispositivo que pertenece a la consola y se controla con dos llamadas *ioctl*. Mirad lo que dice la [Guía de Programación]({{page.assets | relative_url}}/lpg-0.4.pdf) :

> **7.1 Programming the internal speaker**
> 
> Believe it or not, your PC speaker is part of the Linux console and thus a character device. Therefore, ioctl() requests exist to manipulate it. For the internal speaker the following 2 requests exist:
> 
> 1. **KDMKTONE**
> Generates a beep for a specified time using the kernel timer.
> 
> Example: ioctl (fd, KDMKTONE,(long) argument).
> 
> 2. **KIOCSOUND**
> Generates an endless beep or stops a currently sounding beep.
> 
> Example: ioctl(fd,KIOCSOUND,(int) tone).
> 
> The argument consists of the tone value in the low word and the duration in the high word. The tone value is not the frequency. The PC mainboard timer 8254 is clocked at 1.19 MHz and so it's 1190000/frequency. The duration is measured in timer ticks. Both ioctl calls return immediately so you can this way produce beeps without blocking the program.
> KDMKTONE should be used for warning signals because you don't have to worry about stopping the tone.
> KIOCSOUND can be used to play melodies as demonstrated in the example program splay (please send more .sng files to me). To stop the beep you have to use the tone value 0.

Tal guía, a propósito, data del año 1995-1996. Y como nota curiosa, en la sección siguiente cuando habla de programar una tarjeta de sonido, el autor cierra el apartado tal que así:

> You are right if you guessed that you use ioctl() to manipulate these devices. The ioctl() requests are defined in &lt; linux/soundcard.h &gt; and begin with SNDCTL.
> 
> Since I don’t own a soundcard someone else has to continue here
> Sven van der Meer v0.3.3, 19 Jan 1995

A lo que íbamos. Según dice la guía, a nosotros lo que nos conviene es la llamada *KDMKTONE* para generar un tono de una duración determinada y continuar el programa. Que al final es lo que queremos hacer, que pite con cada baliza wifi que llegue.

Si miramos el manual de Perl, para llamar a una ioctl tendríamos que cargar primero las definiciones así:

     require "sys/ioctl.ph";

Sin embargo tanto en xubuntu como en Backtrack 5 no da más que problemas. Así que he terminado mirando a mano el número de la llamada. Nos vamos al directorio "/usr/include/linux" y ahí buscamos con *grep* la llamada KDMKTONE. Línea **62**.

Lo de los ticks es curioso, resulta que en la placa base hay un temporizador -o más bien había, recordad que esto data de los primeros PC y ha cambiado muchísimo, la mayoría de las cosas se mantienen sólo por compatibilidad hacia atrás-. Pero permitidme que siga hablando en presente. Pues en la placa base hay un temporizador/contador, que suele ser un chip del tipo [8254 de Intel](http://en.wikipedia.org/wiki/Intel_8253). Ese chip oscila teóricamente a 1193181.8181Hz. ¿Por qué esa frecuencia? Pues tiene que ver con el estándar NTSC de las primeras gráficas a color (CGA). La información completa está en la página de la Wikipedia que os he enlazado antes.

Para hacer sonar el altavoz a una determinada frecuencia lo que hace e sistema operativo es programar el temporizador para que cuente un número de ticks. Cuando la cuenta llega a ese número se invierte la salida y vuelve a empezar a contar desde cero otra vez. Cuando ha programado el timer envía una señal a la BIOS para que conecte la salida del temporizador al altavoz interno. Luego si queremos que suene a 100Hz tendremos que saber a cuántos ticks corresponden con el 8254 oscilando a -aproximadamente- 1.19MHz. Por eso dividimos en la línea **64**.

La duración, a pesar de que en la guía de arriba dice que también tiene que ser en ticks del contador, la podemos pasar en milisegundos.

En la línea 66 componemos el argumento para la llamada, recordad que los bits inferiores son la frecuencia (o más bien el número de ticks que tiene que contar el chip hasta invertir la salida) y los inferiores la frecuencia. Tened cuidado con esto, en muchos libros lo vais a ver escrito al revés. Por último hacemos la llamada que queríamos y ya está.

## Modo de empleo

Tendréis que ejecutar airodump primeramente para identificar qué BSSID vais a seguir y en qué canal está. Introducís estos datos en el programa y lo ejecutáis. Cada vez que nos llegue una baliza de esa red pitará el altavoz. Pitará más a menudo cuantos más paquetes recibamos y la frecuencia del tono será mayor cuanto más fuerte se reciba la señal.

Algunas consideraciones: Si veis que no suena, tal vez tengáis silenciado el canal *beep* en vuestra tarjeta de sonido. Si no tenéis tal canal puede que no esté soportado. En una VMWare no he conseguido que suene, pero si probáis con una live os funcionará perfectamente..
