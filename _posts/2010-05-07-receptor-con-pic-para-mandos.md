---
assets: /assets/2010/05/receptor-con-pic-para-mandos
image: /assets/2010/05/receptor-con-pic-para-mandos/img/0_1.png
layout: post
tags:
- Circuitos
- PIC
- Sensores
title: Receptor con PIC para mandos infrarrojos tipo NEC
---

El formato NEC es una de las codificaciones más extendidas en los mandos a distancia de electrodomésticos baratos, sobre todo los de marca *Nisu*: televisores, vídeos, TDT, DVD, minicadenas, etc. En una [entrada anterior]({{site.baseurl}}{% post_url 2010-04-01-decodificacion-del-protocolo-rc5-usando %}) ya hablamos sobre otro protocolo de mando a distancia: el RC5. Leer el formato NEC es mucho más sencillo, pero por otro lado requiere más memoria.

Ahora bien, sin utilizar ningún instrumento u ordenador ¿como distingo un mando NEC de los otros tipos? Hay una prueba sencilla. Tapa el agujero del mando, o placa negra, o led por donde sale la luz y pulsa un botón teníendolo tapado. Al destapar con el botón ya pulsado pueden pasar dos cosas: si la tele obedece la tecla pulsada entonces no es NEC, puede ser RC5 o tal vez tipo Sony o JVC. Pero si la tele no obedece entonces probablemente sea NEC. Y esa es una característica distintiva del protocolo: así como el en RC5 se repite continuamente el código (recordemos que había un bit que cambiaba con cada pulsación de la misma tecla para que el aparato no obedeciese dos veces), en este caso sólo se envía una vez el código  y mientras tenga pulsada la tecla se continúa enviando un comando abreviado que significa "*repetir lo anterior*". Como el código concreto sólo se envía una vez cuando se pulsa, si mientras se enviaba tenías la mano tapando el haz, después al quitar la mano el receptor sólo ve el comando "*repetir*" sin saber cual era el comando original.

Debido a lo anterior da la impresión de que esos mandos no van del todo finos. Y las marcas buenas utilizan formatos que sí repitan el código, tal que si no se recibe a la primera el usuario sólo mantiene la tecla pulsada mientras apunta con el mando a distancia.

<!--more-->

## Rutina de recepción

Como es habitual, se transmite modulando una portadora de entre 36 y 40kHz. Dependiendo de cuando haya señal o no haya interpretamos un 0 o un 1. La información tiene esta forma:

{% include image.html size="small" file="0_1.png" caption="" %}

Podéis ver una explicación más extensa del protocolo en [esta web](http://www.sbprojects.com/knowledge/ir/nec.htm) o en [este enlace](http://www2.renesas.com/faq/en/mi_com/f_com_remo.html). La imagen anterior es desde el punto de vista del led. Pero nosotros vamos a utilizar un módulo detector cuya salida es un nivel 1 en ausencia de portadora, y se va a 0 cuando detecta la señal. Así que lo que vamos a ver es esa misma imagen pero invertida:

{% include image.html size="small" file="0_1_inv.PNG" caption="" %}

A la vista de lo anterior, lo que voy a usar para distinguir el 0 del 1 es el lapso entre dos **transiciones hacia 0V**. Si transcurren 1125us lo que se transmitió fue un **0**, si transcurren 2250us entonces se tratará de un **1**.

Para tener cierta tolerancia no voy a exigir que tales intervalos sean exactos; puesto que su punto medio es **1687us** la transición que supere ese umbral será considerada un 1, la que esté por debajo un 0. También fijaré una duración máxima y otra mínima y toda señal que exceda esos intervalos será considerada un error de recepción. Para el tiempo máximo usaré el doble del intervalo medio (que es la suma de la duración del 0 y el 1): **3375us**. Para el mínimo usaré la mitad del intervalo medio (que corresponde con 2/3 de la duración del 0): **843us**.  Entonces ignoramos por completo todas las transiciones que sean de 0 a 5V (subidas) y para cada transición de bajado que detectemos comprobamos el tiempo que pasó desde la anterior:

- Si fue **menor de 843us**: demasiado bajo para ser un 0. Error.
- Si fue **entre 843 y 1687us**: se trata de un 0. Bit correcto.
- Si fue **entre 1687 y 3375us**: se trata de un 1. Bit correcto.
- Su **supera los 3375us**: demasiado tiempo para ser un 1. Error.

Sirva este código como ejemplo:

```c
#include "device.h"
/**********************************************************
Receptor de infrarrojos con protocolo NEC.
Por Reinoso G. 28/04/2010
Dominio público.

Esta rutina usa un puerto para el receptor y otro para
transmitir por puerto serie al PC. Ver device.h.

Está basada completamente en interrupciones por lo que
no detiene la ejecución del programa. Cuando se recibe un codigo
el estado IR_Estado cambia a 32 (que son los bits recibidos)
y entonces queda disponible y se puede leer el comando.

Se ocupa la interrupción Timer1 que se usa para reiniciar el
estado del receptor tras un tiempo sin datos. La TMR0 queda libre
por si hiciera falta para otros menesteres. Los datos del puerto
se reciben vía interrupción de cambio de estado.

Está preparada para un PIC12F386 pero se puede adaptar sin
mucha complicación.
************************************************************/

// Estados del autómata
#define IR_RESET    0
#define IR_INHIBIDO 127
#define IR_COMPLETO 32

// T0 = 1125us =  562 tics de TMR1
// T1 = 2250us = 1125 tics de TMR1
// Media = (T0+T1)/2 = 1687us = 843 tics de TMR1
// MAX y MIN son límites arbitrarios para detección de errores.
// AVERA es la media.
// 
// Si MIN_T < lapso < AVERA   =>  0
// Si AVERA < lapso < MAX_T   =>  1
// En otro caso: error.
#define IR_MIN_T 400
#define IR_MAX_T 1500
#define IR_AVERA 843

unsigned char IR_Estado = IR_RESET;
unsigned int32 IR_comando;

short last_port_IR = 0;

#int_TIMER1
void  TIMER1_isr(void) 
{
 // No borrará un comando que se haya recibido bien
 if (IR_Estado != IR_INHIBIDO && IR_Estado != IR_COMPLETO) {
  IR_Estado = IR_RESET;
  IR_comando = 0;
 }
}

#int_RA
void  RA_isr(void) 
{
 short port_IR; // Estado del pin receptor IR

 // No usar input_a() aqui porque cambia a lectura
 // todos los pines del puerto.
 port_IR = input(PIN_IR);

 /* La interrupción la ha generado el modulo IR */
 // La Transición debe ser hacia 0, si es hacia 1 no hacemos nada
 if (last_port_IR && !port_IR && (IR_Estado != IR_INHIBIDO)){
  unsigned int16 lapso;
  lapso = get_timer1();

  if (lapso > IR_MAX_T || lapso < IR_MIN_T) {
   // ERROR o inicialización
   IR_Estado = IR_RESET;
   IR_comando = 0;
  } 
  else if (lapso < IR_AVERA) {
   // Es un 0
   IR_comando <<= 1;
   bit_clear(IR_comando,0); // opcional
   IR_Estado++;
  } 
  else if (lapso > IR_AVERA) {
   // Es un 1
   IR_comando <<= 1;
   bit_set(IR_comando,0); // opcional
   IR_Estado++;
  } 
  set_timer1(0);
 }

    last_port_IR = port_IR;
 clear_interrupt(INT_RA);
}

////////////////// M A I N /////////////////////////////////////

void main()
{
   /****************** INICIALIZAR **********************/
   setup_oscillator(OSC_4MHZ);
   IR_Estado = IR_RESET;
   
   // Deshabilitamos periféricos
   port_a_pullups(FALSE);
   setup_adc_ports(NO_ANALOGS|VSS_VDD);
   setup_adc(ADC_OFF);
   setup_ccp1(CCP_OFF);
   
   // Timer 1 controla el receptor IR.
   setup_timer_1(T1_INTERNAL|T1_DIV_BY_2);


   enable_interrupts(INT_TIMER1);  // reset estado IR
   enable_interrupts(INT_RA);  // RX pulso IR
   enable_interrupts(GLOBAL);
   
   printf ("-- Preparado para recibir --\n");
   /****************** BUCLE PRINCIPAL **********************/
 for (;;) {

  if (IR_Estado == IR_COMPLETO) {
   /* Se han recibido 32 bits de comando IR */
   IR_Estado = IR_INHIBIDO;
   printf("Comando recibido: %LX\n", IR_comando);
   
   /* Reseteamos la máquina de estados */
   IR_comando = 0;
   IR_Estado = IR_RESET;
  }
 }
}
```

El trabajo se desarrolla en la interrupción de cambio de estado RA_isr. Cuando una entrada del puerto A cambia de nivel lógico se llama a esta interrupción. Entonces nos aseguramos de que

- a) la patilla que ha cambiado es en la que está conectada al receptor de infrarrojos *PIN_IR*
- b) que sea una transición de bajada y no de subida.

Y hacemos las comprobaciones de tiempo. En caso de recibir el bit correctamente actualizamos la variable *IR_comando* e incrementamos el contador *IR_Estado*. Esta variable nos servirá como **contador de bits recibidos** y como estado del autómata. Cuando este contador llegue a 32 nos indicará que lo que tenemos almacenado en la variable IR_Comando es ya un código completo. En caso de error volvemos a cero el estado y el comando, así descartamos lo que lleváramos.

**Timer1** nos está sirviendo de *timeout* para el caso que un código se cortara por la mitad. Cada vez que recibimos un bit ponemos a cero TMR1. Si la recepción se corta TMR1 se desbordará y la máquina de estados se pondrá de nuevo a 0. Previamente se hace una comprobación para no borrar un comando que se hubiera recibido correctamente pero no se hubiera leído aún.

Durante el bucle principal se comprueba *IR_Estado* en busca de un comando. En caso de una correcta recepción este vale 32 (*IR_COMPLETO*). Si es así leemos el comando de la variable *IR_comando* y realizamos la acción correspondiente. Tras esto tenemos que poner el autómata a recibir poniendo *IR_Estado* a valor 0.  El valor *IR_INHIBIDO* no es imprescindible usarlo, pero se puede indicar por claridad. Cuando el estado es 32 la recepción está inhibida igualmente.

## Simulación en MPLAB

Una vez escrita la rutina viene bien simularla con MPLAB para ver si funciona o no. Para eso necesitamos un **archivo de estímulos** que reproduzca lo que se recibiría desde el modulo receptor de IR. Hay varias formas de hacerlo, pero si queremos ser realistas, tener en cuenta las tolerancias de tiempo, etc. una forma de hacerlo es conectar el receptor a la tarjeta de sonido. Yo utilizo este esquema, con el potenciómetro se puede regular el volumen de los impulsos.

{% include image.html size="medium" file="esquema+tarjeta.PNG" caption="" %}

Lo que recibimos es un tren de pulsos. Os recomiendo utilizar el programa Xoscope, que además de visualizar la señal nos permite grabar en un fichero las muestras. En la imagen siguiente vemos un gráfico de la señal recibida en rojo y su interpretación digital en azul. Os adjunto una utilidad sencilla en Perl para leer un fichero con las muestras guardado por Xoscope y generar un fichero de estímulos SBS para MPLAB. El programita se llama **dat2sbs.pl** y os lo incluyo junto a otros ficheros al final de la entrada. Únicamente tendréis que editar el código para poner vuestra frecuencia de muestreo y a los cuantos milisegundos queréis que se inicie la transmisión.

## Interpretación del código recibido

{% include image.html size="" file="esquema_pic.png" caption="" %}

Tras programar el PIC con el código hex que os adjunto lo conectamos al puerto serie del PC con un montaje como el de la figura. Para esto resulta especialmente práctico el proyecto que os presenté [anteriormente]({{site.baseurl}}{% post_url 2010-03-22-conversor-usb-rs232 %}). Y ya estamos preparados para recibir los códigos.

{% include image.html size="big" file="receptorNEC_gtkterm.png" caption="" %}

La interpretación del código es como sigue:

    00FD96A5 -> 00000000 (   0) -> Código aparato (extendido)
                11111101 (253) -> Código aparato (general)
                10011010 (154) -> Comando (botón pulsado)
                01100101 (---) -> Comando invertido (verificación)
    
    00FD4AB5 -> 00000000 (   0) -> Código aparato (extendido)
                11111101 (253) -> Código aparato (general)
                01001010 ( 74) -> Comando (botón pulsado)
                10110101 (---) -> Comando invertido (verificación)

Como veis, dentro de cada código el comando se transmite dos veces. Una vez normal y la siguiente invertido (cambiando los 1 por 0). Se hace así como comprobación de errores. Al recibir el código se debería comprobar si el comando invertido coincide con la última parte del código, y si no coincide es debido a algún error y descartarlo. En esta rutina no he incorporado ese mecanismo por simplicidad.

{% include image.html size="big" file="tren_de_pulsos_desglosado.png" caption="" %}

En [este enlace]({{page.assets | relative_url}}/receptorNEC.rar) os dejo los ficheros utilizados:

- Código en C y cabeceras.
- Imágenes.
- Ejemplo de estímulos SBS para pruebas.
- Utilidad dat2sbs.
- Ejemplo de fichero dat guardado por Xoscope.
