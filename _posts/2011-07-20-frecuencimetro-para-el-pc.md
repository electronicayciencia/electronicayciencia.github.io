---
assets: /assets/2011/07/frecuencimetro-para-el-pc
image: /assets/2011/07/frecuencimetro-para-el-pc/img/interfaz_tk.png
layout: post
tags:
- Circuitos
- Experimentos
- PIC
- Radio
title: Frecuencímetro para el PC
---

Después de un par de artículos más bien teóricos ahora os quiero presentar un **montaje práctico**. Vamos a ver cómo hacer un frecuencímetro que sea lo más **sencillo** posible, pero que sea a la vez útil y preciso.

{% include image.html size="" file="interfaz_tk.png" caption="" %}

Empezaremos viendo una característica poco conocida de los PICs y construiremos un circuito para aprovecharla. En el firmware del PIC haremos que mande el valor por puerto serie al PC utilizando el conversor USB-&gt;RS232. Pero la frecuencia no será exacta, y hará falta calibrarlo. Para terminar escribiremos una pequeña **interfaz en Perl/Tk** para que nos indique la frecuencia.

<!--more-->

## Esquema eléctrico

Cuando hablamos de PICs básicos, suelen funcionar con cuarzos de 4MHz, 12, y los más modernos hasta de 20MHz como máximo. Y creemos que ahí está el límite para todo lo que hagamos con ellos. Sin embargo no es así. El contador **TIMER0** puede funcionar de manera asíncrona, sin depender del reloj principal. Se usa normalmente para contar pulsos externos, pero fijaos lo que dice el datasheet del 12F683:

{% include image.html size="" file="datasheet.png" caption="" %}

Dice que el tiempo de subida es de 10ns y de bajada otros 10ns. En total el periodo más bajo que podría medir es de 20ns, equivalente a **50MHz**. Hasta ahí lo que nos garantiza el fabricante, pero en la práctica depende mucho del chip, yo he llegado a medir frecuencias en la banda de 144MHz con este circuito sin usar ningún divisor externo.

Queremos que el esquema se reduzca a lo mínimo imprescindible. Así que tomaremos la alimentación del mismo puerto USB, y dejaremos para más adelante el acondicionamiento de la entrada.

{% include image.html size="" file="frec_sch.png" caption="" %}

La **entrada** se hace por el conector de la izquierda, que va a través de un condensador al pin 5 (T0CKI). En el conector superior se conecta el [adaptador USB-Serie]({{site.baseurl}}{% post_url 2011-01-12-adaptador-de-usb-serie %}), que ya tiene los **5 voltios** que sirven de alimentación. El conector central sirve para conectar un interruptor por si fuera necesario, por ejemplo para indicar que hemos conectado un prescaler externo.

El resto de componentes son el cuarzo y los dos condensadores que proporcionan la frecuencia de reloj. En otros montajes veréis que uno de los condensadores es **variable**. Se hace porque el cuarzo no es exacto sino que tiene un pequeño error de varias partes por millón. Nosotros haremos la **compensación por software** en el PIC.

El condensador **C3** es muy importante, ya que sirve para filtrar la alimentación. Si no estuviera, al medir frecuencias cercanas a 12MHz -que es la frecuencia de reloj del PIC- este fallaría. Y no sólo eso, si el nivel de entrada es lo suficientemente alto, la frecuencia llegaría al convertidor serie, que también trabaja a 12MHz y el integrado que lleva se reiniciaría continuamente y no podríamos medir nada.

La placa es igualmente sencilla:

{% include image.html size="" file="frec_brd.png" caption="" %}

Al final del artículo os dejo los ficheros, los podéis abrir con la versión Freeware de [Eagle](http://www.cadsoftusa.com/) (Windows y Linux), por ejemplo.

Una vez montada así es como quedaría, con las conexiones que se indican:

{% include image.html size="" file="conexiones.jpg" caption="" %}

## Firmware

¿Cómo determinar la frecuencia a partir de los **pulsos** que llegan a TIMER0? Pues hay varias formas:

- En primer lugar, se puede determinar el **periodo** de tiempo que transcurre entre dos impulsos consecutivos. Esta aproximación es la mejor para frecuencias bajas, pero no sirve cuando vamos subiendo.
- Otra opción es medir el tiempo que pasa por cada **10, 100 o 1000 pulsos**, etc. Es una evolución de la anterior. Tiene el problema de que es un poco más compleja de programar, pero la podemos hacer tan precisa como queramos a costa de medidas más lentas.
- Y por último, también podemos cronometrar un tiempo fijo, pongamos 100 o 200ms y contar **cuantos pulsos** se reciben en ese tiempo. Es la más práctica y va a ser la que usemos. A mayor tiempo de medida más precisión. Pero menos velocidad de respuesta. Usaremos 100ms que ya veremos que nos da una precisión de 10Hz y 10 medidas por segundo.

El contador TIMER0 es de 8 bits, eso significa que sólo puede contar hasta 255. El caso es que cuando llega el pulso 256 se desborda, emite una interrupción y vuelve a cero. Se le puede acoplar un prescaler de 8 bits también, para que cada vez que se desborde aumente en uno, eso es lo que hacemos en la línea 38.

El contador TIMER1 es de 16 bits, pero es más **lento** y no nos sirve. Y además lo vamos a usar de cronómetro.

Muy por encima los pasos son estos:

- Leer velocidad del cuarzo definida por el usuario.
- Fijar Timer1 para que dispare a los 100ms.
- Contar impulsos durante ese tiempo.
- Enviar el resultado al PC.
- Repetir el ciclo.

Veamos el código fuente y debajo lo comentamos:

```c
#include <12F683.h>
#device adc=8

#FUSES NOWDT                  //No Watch Dog Timer
//#FUSES INTRC_IO               //Internal RC Osc, no CLKOUT
#FUSES HS
#FUSES NOCPD                  //No EE protection
#FUSES NOPROTECT              //Code not protected from reading
#FUSES NOMCLR                 //Master Clear pin used for I/O
#FUSES NOPUT                  //No Power Up Timer
#FUSES NOBROWNOUT             //No brownout reset
#FUSES NOIESO                 //Internal External Switch Over mode disabled
#FUSES FCMEN                  //Fail-safe clock monitor enabled

#define PIN_SrTX  PIN_A0
#define PIN_SrRX  PIN_A1
#define PIN_T0    PIN_A2
#define PIN_Presc PIN_A3
// reservamos el 4 y el 5 para conectar un cuarzo.

#use delay(clock=12000000)
#use rs232(baud=9600,INVERT,DISABLE_INTS,parity=E,xmit=PIN_SrTX,rcv=PIN_SrRX,bits=8)  

typedef struct {
 int desb;
 long resto;
} cal_t;

void sample_freq (cal_t);
int  read_t0_presc (void);
int  atoi (char *);
cal_t calc_calib(int32);
int32 read_ee_reloj(void);
```

```cpp
/*
*  Frecuencímetro sencillo para el PC.
*  El T_rise de T0 es de 10-15ns asi que la frecuencia máxima que
*  podemos medir es de 35-50MHz.
*
*  Se usa TMR0 porque el TMR1 aunque es de 32 bits parece que sólo
*  se recomienda hasta los 16MHz.
*
*  Reinoso G.   26-12-2010
*/
#include <frec1.h>

int t0_msb;    // desb de T0, a 50MHz durante 100ms sólo se llega a 76.
int midiendo;  // desb de T1, amplia el rango de T1 contando desbordamientos


#int_TIMER0
void  TIMER0_isr(void) 
{
 t0_msb++;
}

#int_TIMER1
void  TIMER1_isr(void) 
{
 midiendo--;
}




void main()
{
 cal_t calib;
 int32 reloj;

 setup_adc_ports(NO_ANALOGS);
 setup_timer_0(RTCC_EXT_L_TO_H|T0_DIV_256);
 setup_timer_1(T1_INTERNAL|T1_DIV_BY_1);
 enable_interrupts(GLOBAL);

 /* Iniciando... */
 puts("Frecuencimetro. v.6/1/2011");

 /* Leer la frecuencia exacta del cuarzo:
  Para la transmision serie una leve diferencia no importa mucho
  por eso en el #use delay ponemos la frecuencia nominal.
  Pero la lectura del frecuencimetro exige una calibracion
  precisa. Por eso almacenamos la frecuencia exacta.
 */
 reloj = read_ee_reloj();

 printf("Reloj a: %luHz\r\n", reloj);

 /* Calcular los parámetros de calibración */
 calib = calc_calib(reloj);



 for(;;) {
  int32 frec;
  
  sample_freq(calib);

  frec = t0_msb;           // desbordamientos de t0
  frec<<=8;
  frec += get_timer0();    // valor de t0 al terminar
  frec<<=8;
  frec += read_t0_presc(); // valor del prescaler

  // transmitir al PC x10
  printf("F:%lu\r\n", 10*frec);
 } // for
} // main

/* Realiza una medida de frecuencia
   - Pone a cero el timer0 (reinicia el prescaler tambien)
   - Pone a cero el contador global (t0_msb)
   - Pone el pin T0 como entrada para que cuente
   - Espera el retardo correspondiente (desbordamientos de T1)
   - Pone el pin T0 como salida para que no cuente
   Para reducir los errores de comienzo/final de la medida sería
   interesante que el contador corriera libremente y anotáramos sólo
   la posición antes de empezar el retardo y despues de terminarlo.
   Pero es dificil hacer eso y leer el prescaler bien al mismo tiempo.
   En principio las medidas son de 100ms, eso da una resolución de 10Hz.
*/
void sample_freq (cal_t calib) {
 output_low(PIN_T0);

 setup_timer_0(RTCC_EXT_L_TO_H|T0_DIV_256);
 enable_interrupts(INT_TIMER0);
 t0_msb = 0;
 set_timer0(0);

 /* En cuanto midiendo sea 0 paramos. */
 set_timer1(0);
 enable_interrupts(INT_TIMER1);
 midiendo = calib.desb;
 set_timer1(calib.resto);

 input(PIN_T0);
 while(midiendo);
 output_low(PIN_T0);
}


/* Lee el prescaler:
   - El prescaler no se puede leer directamente por software
   así que lo que hay que hacer es incrementar T0 de manera controlada
   hasta que se desborde. Restando los pulsos que hemos necesitado para que
   se desborde y sabiendo que desborda a los 256 sabemos en cuanto estaba.
   - Ponemos el puerto a 0 como salida y vamos cambiando el flanco T0SE
   en cada cambio de LtoH(0) a HtoL(1) se incrementará en 1 el prescaler.
   Podría no funcionar en el simulador.
   - Como ya hemos leído el valor de T0 y del T0_msb nos da igual si se
   pierden.
*/
int read_t0_presc (void) {
 #byte OPTION_REG = 0x81
 #bit  T0SE       = OPTION_REG.4
 int impulsos;
 int t0_old;

 t0_old = get_timer0();
 output_low(PIN_T0);
 
 impulsos = 0;
 while(t0_old == get_timer0()) {
  T0SE = 0;
  T0SE = 1;
  impulsos++;
 }
 
 impulsos = 255-impulsos;
 impulsos++;
 return impulsos;
}

/* Calculamos cuantos desbordamientos tiene que hacer TMR1 y cual seria
   el resto para que con la frecuencia indicada del cuarzo se consigan
   precisamente 100ms. */
cal_t calc_calib(int32 reloj) {
 cal_t calib;
 
 reloj /= 40; // entre 4 (instr/ciclo) y entre 10 (0.1s = 100ms)
 reloj -= 60; // 60 ciclos hasta que sale del while
 calib.desb  = reloj / 65536 + 1;
 calib.resto = 65536 - (reloj % 65536);

 return calib;
}

/* Lee de la EEPROM el valor exacto de la frecuencia de oscilación
   Este valor debe ser introducido por el usuario en formato Big Endian */
int32 read_ee_reloj(void) {
 int32 reloj = 0;
 int i;
 for(i=0; i<4; i++) {
  reloj <<= 8;
  reloj += read_eeprom(i);
 }
 
 // Si el usuario no ha definido el reloj, uso 12MHz por defecto.
 if (reloj == 0xFFFFFFFF) {
  reloj = 12000000;
 }
 return reloj;
}
```

Empezaremos por la función principal *main*, línea 37. Tras definir variables configuramos algunos parámetros: no necesitamos ADC, y en el timer 0 queremos el prescaler de 256. Seleccionamos ese prescaler porque es el más alto que hay. Cuando contemos los pulsos ocurrirá que cada 256 se desbordará el prescaler, y timer0 se incrementará en 1; cada 256 incrementos de timer0 se desbordará causando una interrupción (linea 18) que lo que hace es incrementar la variable *t0_msb*. Luego para sumar el total de impulsos tendremos en cuenta el valor de *t0_msb* de Timer0 y del prescaler. Pero no nos adelantemos.

Durante la etapa de calibración (ver más abajo) hemos determinado la frecuencia exacta de oscilación del cuarzo y la hemos metido en la EEPROM. Aunque la primera vez aún no lo habremos hecho, en ese caso la línea 166 seleccionará una frecuencia predeterminada de 12MHz. Una vez leída la frecuencia de oscilación, la rutina *calc_calib* calcula en cuánto hay que fijar Timer1 y cuántas veces tiene que desbordarse para completar **100ms** exactos. Esta información se almacena en la estructura *calib*. Hace falta un poco de simulación previa en el MPLAB para ajustarlo del todo, pues el compilador de código C introduce instrucciones que a priori no conocemos.

Ahora en la línea 60 comienza el bucle principal. Contar pulsos, interpretarlos y mandarlos al PC.

Del conteo se encarga la rutina *sample_freq*, la cual recibe la los cálculos de calibración necesarios para 100ms. Lo primero que hacemos es llevar el pin de Timer0 a **nivel bajo**, evitando que se incremente mientras hacemos los preparativos. Preparamos el TIMER0, y lo reiniciamos. Preparamos también Timer1 y activamos su interrupción. En cada desbordamiento del TIMER1 se decrementará en uno la variable ***midiendo***. Cuando esta variable llegue a 0 significará que han transcurrido 100ms exactos. Abrimos el pin de Timer0 fijándolo cono **entrada** y esperamos a que *midiendo* llegue a 0. Inmediatamente después volvemos a llevar el pin a **nivel bajo** para no contar más pulsos.

La función *sample_freq* no devuelve ningún valor. Pero deja al micro en un estado del que podemos obtener toda la información necesaria. Vamos a la línea 65: leemos cuántos desbordamientos ha tenido Timer0. Luego leemos el valor del propio Timer0, que siempre será inferior a 255. Y por último obtenemos el valor del prescaler por hardware, que también será inferior a 255.

No existe ninguna función que nos permita leer en cuánto se ha quedado el prescaler. Pero sí que hay una forma documentada para hacerlo. Lo vemos en la función *read_t0_presc*. Consiste en mantener el pin Timer0 a nivel bajo e ir alternando el bit **T0SE**. El bit T0SE selecciona si vamos a contar el flanco de subida o de bajada. Cada vez que seleccionemos que vamos a contar el flanco de bajada, como el pin ya está a nivel bajo se contará un pulso. Solo tenemos ir cambiando el bit hasta que Timer0 se incremente. Eso nos indicará que el prescaler ha dado un vuelta. Y por tanto no hay más que saber cuántas veces hemos alternado el flag y descontarlo de 255. Ese será el número por el que iba el prescaler cuando dejamos de contar en *sample_freq*.

Así que ahora que tenemos los tres datos hay que combinarlos:

- Cada posición del prescaler vale por uno.
- Cada incremento del Timer0 vale por 256. Pues se incrementa cuando el prescaler da una vuelta completa.
- Cada desbordamiento de Timer0 (*t0_msb*) vale por 65536 (256x256). Pues se incrementa cuando Timer0 da una vuelta completa.

Sumando todo resulta cuántos pulsos se han recibido en 100ms, que es la décima parte de un segundo. Cuando multiplicamos esa cantidad por 10 obtenemos el número de pulsos por segundo, o sea, la frecuencia.

Sin embargo esa frecuencia no será exacta, tendrá un error que depende de varios factores.

## Calibración

Como ya decíamos antes el número que sale no es la frecuencia exacta. Hay errores, por ejemplo:

- **Error de entrada:** Cuando empezamos a contar, o cuando terminamos de hacerlo en *sample_freq* siempre hay un periodo que queda cortado. Ese pulso que no llega a entrar no se cuenta. Es un error de 10Hz hacia abajo. Sería de un pulso (1Hz), pero como luego multiplicamos por 10 para obtener la frecuencia acaba siendo de 10Hz.
- **Precisión según tiempo de medida:** Si medimos cada 100ms, como mucho podremos alcanzar una precisión de decenas de Hz. Para obtener una precisión mayor tendríamos que medir durante más tiempo. Por ejemplo durante un segundo completo, o más aún. Sin embargo en un frecuencímetro hasta 50MHz, 10Hz arriba o abajo no suponen un sacrificio a cambio de una respuesta más rápida.
- **Tiempo de corte:** Vale, cronometramos 100ms y ordenamos parar de contar. Pero esa orden lleva un tiempo hasta que se cumple. Con un cuarzo de 12MHz el PIC ejecuta 3 millones de instrucciones por segundo o sea que pasan 0.33us entre una instrucción y otra. Más luego el tiempo que tarda interiormente el dispositivo en llevar el pin a nivel lógico 0.
- **Tolerancia del cuarzo:** Esta es la fuente de error más importante y que trataremos de minimizar. Los cristales de cuarzo no resuenan en una frecuencia exacta sino que tienen una cierta tolerancia. Si el cuarzo va más deprisa o más despacio en lugar de contar 100ms exactos contaremos 102ms o 98ms. Y eso va a repercutir en cuántos pulsos lleguen y por tanto en la frecuencia medida.

Para paliar el problema hemos previsto que el usuario pueda introducir en la EEPROM el valor exacto de la frecuencia del cuarzo, y el software cronometrará los 100ms basándose en ese valor. La tolerancia de los cristales de cuarzo se mide en partes por millón (ppm). Significa que a mayor frecuencia, mayor es la incertidumbre. Por eso los relojes usan cuarzos de 32kHz, porque aparte de ser más baratos y más pequeños, también son más exactos que los de mayor frecuencia.

¿Y cómo sabemos cual es la frecuencia exacta de resonancia del cuarzo? Bueno pues para empezar **depende de la temperatura**. Así que nunca vamos a cancelar el error por completo, pero sí que podemos reducirlo. Hay dos métodos para averiguarlo.

*Primer método: indirecto.*

Para esta forma de calibrarlo necesitamos alguna referencia. Por ejemplo un oscilador de frecuencia conocida. Si eres radioaficionado y tienes un transmisor de onda corta sintonizado por PLL estás de suerte. También serviría otro frecuencímetro con el que comparar.

- Hay que poner el generador en una frecuencia conocida y conectar el frecuencímetro. Como aún no tenemos ninguna interfaz con el PC conectaremos un terminal serie. A mi me gusta en Linux el **gtkterm**. Nos dará un valor aproximado a la frecuencia que esperamos.
- Dividiremos el valor de referencia entre el valor obtenido. Así sabremos la desviación.
- Multiplicaremos lo que nos dé por la frecuencia nominal de cuarzo y eso nos dará la frecuencia de oscilación real.
- Pasaremos el número a hexadecimal para grabarlo en la EEPROM del PIC.

Veámoslo con un **ejemplo**:

Supongamos que tenemos un oscilador de referencia en 15.000.000Hz. Y nuestro frecuencímetro indica 14.999.169. Con un cristal de cuarzo de, en teoría, 12MHz.

La frecuencia de oscilación real del cuarzo es:

$$
\frac{15.000.000}{14.999.169} \times 12.000.000 \simeq 12.000.665Hz
$$

Observad que el valor medido está en el denominador. Lo normal es que estuviera en el numerador, pero en este caso mientras más deprisa va el cuarzo antes se pasan los 100ms para el PIC y menos pulsos cuenta. Así que la regla de tres para este caso es **inversa**: a mayor velocidad de reloj, menor es la frecuencia indicada y viceversa.

Ahora expresamos 12000665 en hexadecimal -8 lugares que completamos con 0 a la izquierda-, nos da ***00B71D99***, y ese es el valor que almacenamos en la EEPROM:

{% include image.html size="" file="eeprom_12000665.png" caption="" %}

Esta forma de almacenar un número binario, en **orden natural** de lectura con el bit más significativo a la izquierda, se denomina *big endian*. Si lo hubiéramos invertido grabando primero los bits menos significativos sería un formato *little endian*. Este último formato es muy práctico a la hora se hacer operaciones matemáticas porque siempre comenzamos por las unidades más pequeñas, entre otras ventajas. Es el formato que usa Intel y en general la plataforma x86. Para más información (en particular la etimología del término es muy pintoresca) visitad la [wikipedia: Endianness](http://en.wikipedia.org/wiki/Endianness).

Como curiosidad, hemos visto que el cuarzo va 665Hz más deprisa de lo que debería. Lo cual supone un error de:

$$
\frac{665}{12.000.000} \times 1.000.000 = 55ppm
$$

Como vemos un minúsculo error de 55ppm se **multiplica por 10** y nos causaría una variación de 550 Hz en la frecuencia del cuarzo. El error aumenta en las frecuencias altas, y es menor en las bajas.

*Segundo método, directo.*

Si no contáramos con un transmisor tal vez sí tengamos a mano un **receptor** de onda corta en banda lateral única (**SSB**). Pues aquí tenemos otra forma de medir la frecuencia de oscilación de un cuarzo.

Se trata simplemente de sintonizar la frecuencia nominal estando en AM. Debe captarse la señal. Ahora seleccionamos USB o LSB. En uno de los dos modos no oiremos nada, pero en el otro escucharemos un **tono audible**. Ese tono no es ni más ni menos que la diferencia entre el oscilador interno del receptor y la señal del cuarzo -lo que se llama *batido*-. Lo oiremos en LSB si el cuarzo resuena por debajo de la frecuencia sintonizada, y en USB si resuena por encima.

Mediremos la frecuencia del tono capturándola mediante un micrófono conectado a la tarjeta de sonido. Y luego utilizaremos *Baudline* o cualquier programa de tratamiento de audio.

**Ejemplo**: si tenemos un cuarzo de 12MHz, sintonizamos nuestro receptor en 12MHz. En LSB no escuchamos nada, pero en USB se oye un pitido continuo que resulta ser de 330Hz. El cuarzo resuena entonces 330Hz por encima de la frecuencia sintonizada, es decir en 12000330Hz.

Otro método más avanzado sería tener un osciloscopio, un generador de funciones digital u otro equipamiento de laboratorio. Si no contáis con un transmisor sintonizado, un frecuencímetro, o por lo menos un receptor que os sirva de referencia no vais a poder calibrarlo. **Al final del artículo** se proponen otros dos métodos alternativos.

Tened también en cuenta que la exactitud será siempre menor, o como mucho igual a la del aparato que toméis de referencia. Si lo calibráis de acuerdo a un equipo no demasiado bueno, cuya frecuencia no será tampoco exacta, la calibración no será buena. Sobre trazabilidad se podría hablar mucho, pero considerad que este frecuencímetro que os propongo **no es** **un instrumento de alta precisión**. Así que si no tenéis nada a mano con qué calibrarlo no pasa nada.

## Interfaz

Y para darle un buen remate, nada mejor que una interfaz. Aunque sea sencilla siempre estará mejor acabado que si tenemos que conectar el terminal serie. Y además el PC puede hacer algunos cálculos útiles como una media de los últimos valores o un redondeo con la precisión que queramos.

Como tampoco queremos dedicarle más tiempo del necesario elegiremos un lenguaje con el que ya estamos familiarizados, en mi caso Perl. Por la sencillez del programa habría sido igual de fácil escribirlo en Python, en Java, o incluso Tcl/Tk.

Elegiremos una **tipografía** con un aire electrónico que nos guste, por ejemplo esta que se llama [Led Board]({{page.assets | relative_url}}/led-board.font) (literalmente *pantalla led*). Y más concretamente su variedad inversa.

{% include image.html size="" file="led_board.png" caption="" %}

El código que os pego está hecho rápidamente y de forma descuidada. Aunque es plenamente funcional, sin duda podréis mejorarlo. Por ejemplo añadiendo el cambio automático de escala.

```perl
#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  interfaz1.pl
#
#        USAGE:  ./interfaz1.pl  
#
#  DESCRIPTION:  Interfaz para el frecuencímetro 1.
#                Recoge los datos por el puerto serie (o el conversor USB) y los
#                presenta.
#
# REQUIREMENTS:  ---
#       AUTHOR:  Reinoso Guzman 
#      VERSION:  1.0
#      CREATED:  07/01/11 00:53:21
#===============================================================================

use strict;
use warnings;

use Tk;
use Device::SerialPort;

$| = 1;

# Abrir el puerto
my $PORT      = "/dev/ttyUSB0";
my $s_port = Device::SerialPort->new ($PORT) || die "Can't Open $PORT: $!";
$s_port->baudrate(9600);
$s_port->parity("none");
$s_port->databits(8);
$s_port->handshake("none");
$s_port->write_settings;
$s_port->purge_all();
$s_port->purge_rx;
open( DEV, "<$PORT" ) || die "Error abriendo $PORT: $_\n";

# Crear la interfaz
my $freq_txt = " No Conectado";
my $mw=tkinit;
$mw->title("Frecuencimetro");
my $freq_lbl = $mw->Label(
 -textvariable => \$freq_txt,
 -font         => "LEDBOARDREVERSED 20",
 -anchor       => 'e',
 -foreground   => 'green',
 -background   => 'black');
$freq_lbl->pack(-expand => 1);
$mw->fileevent(\*DEV, 'readable', [\&update_freq, $freq_lbl]);
$mw->withdraw; # avoid the jumping window bug (perlmonks)
$mw->Popup;    # centrar la ventana

# Si nos pasamos un segundo sin recibir, mostramos "no conectado"
$SIG{ALRM} = sub { $freq_txt = " No Conectado"; };
alarm 1;
MainLoop;



# Rutina para actualizar la frecuencia
sub update_freq {
 alarm 1;
 my $linea = <DEV>;
 
 # Error si no se pudo leer (hemos desconectado el USB)
 if (not $linea) {
  die "Error de lectura: USB desconectado.\n";
 };

 my ($valor) = $linea =~ /F:(\d+)/;
 if (not defined $valor) {
  $freq_txt = "      0.0 kHz";
  return;
 };

 # Redondeo
 $valor = int($valor/100 + 0.5); # Redondeo hasta 100Hz
 $valor = $valor / 10;   # Decimales a partir de kHz
 
 # Lo quitamos si es cero (menos de 100Hz).
 if ($valor <= 0) {
  $freq_txt = "      0.0 kHz";
  return;
 };

 # Hasta 100Hz, que es un lugar decimal
 $valor = sprintf("%.1f", $valor);
 # Expresarlo con separador de miles
 # (esta linea es de 'Mastering regular expressions')
 1 while ($valor =~ s/^(-?\d+)(\d{3})/$1 $2/);

 $freq_txt = sprintf("% 13s", "$valor kHz");
}
```

Lo primero es cargar los dos módulos que hacen todo el trabajo, líneas 21 y 22. *Device::SerialPort*, como su nombre indica, nos servirá para interactuar con el puerto serie (aunque sea virtual) creado por el adaptador USB. Mientras que *Tk*, nos proporcionará una interfaz gráfica con ventanas práctica y fácil de manejar.

De la línea 27 a la 36 abrimos el puerto serie '/dev/ttyUSB0'. Podría ser distinto en otros PC.

En las líneas 38 a 51 nos dedicamos a inicializar la librería gráfica y a describir la interfaz. Será una ventana con título *Frecuencímetro*. Dentro sólo tendrá una **etiqueta**, con la tipografía *Led Board* que os enseñé antes, en color verde y fondo negro de tamaño 20 puntos. Notad que en la línea 43 **asignamos el valor de la etiqueta a una variable**. Sirve para que la etiqueta refleje el nuevo valor automáticamente cada vez que cambiemos *freq_txt* sin necesidad de llamar a ninguna función.

La línea 49 es crucial, vigila el fichero que hemos abierto para el puerto serie. Significa que en cuanto haya disponible nuevos datos, se va a llamar a la función **update_freq** para que actualice el valor que se muestra en la etiqueta.

En la línea 54 definimos un temporizador de **1 segundo**. Que, si os fijáis, se reinicia al principio de cada llamada a la función *update_freq*. Se supone que el frecuencímetro envía una lectura diez veces por segundo, realmente un poco menos si contamos tiempos intermedios. Y cada vez que llega una lectura nueva se invoca a la función. En cuando dejamos de recibir nuevos datos ya no se llama más a *update_freq*, con lo que no se reinicia el cronómetro. Al cabo de un segundo sin recibir saltará la alarma mostrando el error *No conectado*.

Ya dentro de la función *update_freq* el proceso es sencillo. Recogemos e interpretamos la línea recibida. Según habíamos programado en el PIC todas las lecturas de frecuencia vendrían precedidas por *F:*. Lo hacemos así por si en el futuro queremos incorporar otras medidas, por ejemplo el **periodo**, o la **potencia** recibida. De momento nos quedamos con el número que sigue a la F, que será la frecuencia (línea 70).

Redondeamos hasta las centenas de hercio. Y actualizamos la etiqueta. Si fuera necesario también podríamos hacer alguna operación, como la media de los tres últimos valores, o multiplicar por una constante, por ejemplo. Y para terminar, en la línea 90 situamos el carácter separador de miles -en este caso un espacio-. La **expresión regular** nos servirá para otras ocasiones.

{% include image.html size="" file="tk_144625.png" caption="" %}

Finalmente puede ocurrir que lo que leamos del fichero no sea un dato sino un ***EOF***. En la línea 66 comprobamos eso, y si es así significa que hemos **desconectado el adaptador** USB: indicamos el error y terminamos el programa.

## Conclusiones

Ya habéis visto que no es demasiado complicado hacer un frecuencímetro. Un microcontrolador, saber programarlo y un PC. Ni siquiera es imprescindible la interfaz gráfica. En otros proyectos utilizan una LCD o varios display LED de 7 segmentos.

La **frecuencia máxima** ya hemos dicho antes que depende del PIC, no del modelo concreto sino del propio dispositivo. En la práctica ronda los **100MHz**. Si queremos medir más tendríamos que conectar un prescaler.

Una carencia importantísima de nuestro esquema es la ausencia total de **acondicionamiento de entrada**. Necesitaríamos como mínimo que:

- La **impedancia** de entrada sea de 50Ω si queremos medir equipos de RF con esta impedancia de salida. O lo más alta posible en otro caso.
- **Limite la potencia** de entrada. Si no, podríamos destruir el PIC al medir señales demasiado fuertes.
- **Amplifique**. Generalmente lo que vamos a medir serán señales débiles. Así que es muy importante diseñar una etapa pre-amplificadora que pueda trabajar a la mayor frecuencia que nos permitan los medios que tengamos. De lo contrario parte de los impulsos no se contarán, y mediremos una frecuencia menor de la real, o nada en absoluto.
- De manera opcional, podríamos contar con un prescaler que **divida por 4 o por 8**. Así podríamos medir hasta 400MHz. Con un par de estos divisores en cascada alcanzamos fácilmente los Gigahercios. Por ejemplo mirad [este circuito](http://hem.passagen.se/communication/frcpll.html).

El proyecto llamado [50MHz Frequency Meter](http://home.exetel.com.au/marknac/50MHz-Frequency-Meter.htm) tiene un esquema interesante que bien nos puede servir como base. Además nos propone otros métodos de calibración también muy buenos:

> The completed 50MHz Frequency Meter can be calibrated against the 15.625kHz line oscillator frequency in a colour TV set. Fortunately, you don't need to remove the back of the set to do this. Instead, all you have to do is connect a long insulated wire lead to the input socket and dangle it near the back of the TV set.

> If you require greater accuracy, the unit can be calibrated against the standard 4.43MHz colour burst frequency that's transmitted with TV signals. The best place to access this frequency is right at the colour burst crystal inside a colour TV set. This crystal will usually operate at 8.8672375MHz (ie, twice the colour burst frequency), although some sets use a 4.43361875MHz crystal.

El **código fuente, fotos y esquemas** para Eagle los podéis bajar de [este enlace]({{page.assets | relative_url}}/Frecuencimetro.zip).
