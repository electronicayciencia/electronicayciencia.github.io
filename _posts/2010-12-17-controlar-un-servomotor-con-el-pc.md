---
assets: /assets/2010/12/controlar-un-servomotor-con-el-pc
image: /assets/2010/12/controlar-un-servomotor-con-el-pc/img/pulsos_wikipedia.png
layout: post
tags:
- PIC
- Sensores
title: Controlar un servomotor con el PC
---

Supongo que muchos estaréis familiarizados con los servos. No es mi caso. Por unas cosas u otras nunca me he dedicado al modelismo ni a la robótica así que para mí estos motores como si no existieran. Sin embargo hace unas semanas vi uno barato en [DealExtreme](http://www.dealextreme.com/details.dx/sku.12832) y pensé que algún día puedo necesitarlo. Y para entonces mejor saber cómo se usa. Así que esta primera prueba no va a ser nada elaborado, solamente un servo, un PIC, y un PC para dar las órdenes.

He utilizado el modelo TowerPro MG995. Según dicen, y he podido comprobar, tiene sus ventajas y sus inconvenientes.

## Ventajas

- Es barato. O relativamente barato comparado con otros modelos.
- Potente. Tiene bastante torque.
- Engranajes metálicos.

## Inconvenientes

- Tiene una zona muerta muy estrecha, y le cuesta quedarse quieto.
- Los engranajes metálicos lo hacen lento y con inercia, por lo que a veces se pasa y tiene que retroceder.
- Con la inercia que tiene consume mucho al arrancar (más de 1A) y mete mucho ruido en la alimentación. Así que si no desacopláis bien el micro se os va a reiniciar.
- Es muy sensible a las caídas de tensión aunque sean breves. Cuando lo alimentamos con 5V hay ocasiones que la electrónica interna se reinicia y el motor se mueve sólo.

En [esta página](http://es.wikipedia.org/wiki/Servomotor_de_modelismo) de la Wikipedia se explica cómo se controla y en [esta otra](http://www.geology.smu.edu/%7Edpa-www/robo/servo/servohac.htm) explican cómo funcionan interiormente. Hay cientos de páginas por toda Internet, de aficionados a la robótica sobre todo, que tienen mucha información.

Como ya os he dicho nunca había manejado un servo y no tenía muy claro cómo son los pulsos que hay que enviar. Según la Wikipedia es así:

{% include image.html size="medium" file="pulsos_wikipedia.png" caption="" %}

Pero los valores de 1ms y 2ms son orientativos y dependen del modelo de servo. Y como yo no he podido encontrar el datasheet del MG995 pues me he preparado un PIC para probar con varios.

## Programa del PIC

Como de costumbre usaremos un 12F683 y un programita en C que podéis compilar con el compilador de CCS. Y por si no lo tenéis también os dejo al final del artículo un enlace al código fuente y al fichero compilado.

Utilizaremos el puerto serie para la transmisión, si vuestro ordenador ya no tiene puerto serie necesitaréis un conversor USB-RS232. [Como este]({{site.baseurl}}{% post_url 2010-03-22-conversor-usb-rs232 %}).

Tras presentar una cabecera se queda esperando comandos. Los comandos constan de una letra y un número. La letra puede ser **p** si queremos cambiar el **periodo** u **o** si queremos cambiar la **duración del pulso**. El número que sigue son los microsegundos de duración.

Si por ejemplo queremos cambiar el tiempo del pulso a 1ms, que son 1000us pondremos

    o1000

Tal que así:

    Prueba de servo.
    Escribe oXXXX para variar el tiempo On
    o pXXXX para variar el periodo
    
    >o1000
    Ton = 1000
    Periodo = 200000
    >p15000
    Ton = 1000
    Periodo = 200000
    >

Variar el periodo no debería infuir en la posición del servo, pero es útil para hacer pruebas.

Varias cosas en cuanto a este código:

Utilizamos un Timer para gestionar el pulso. Habría sido más fácil con un bucle y un par de delays, pero no podríamos hacer nada más mientras tanto. Usando un timer nos quitamos el problema del bucle principal y lo delegamos a la interrupción. Y si luego más adelante quisiéramos manejar más de un servo con el mismo PIC ya tenemos un paso avanzado.

He rescrito la función **atol**. Mi versión es menos potente que la que trae el compilador en sus librerías pero también ocupa menos espacio en memoria. No necesito convertir números hexadecimales ni negativos en este programa.

También he pasado de **gets** por dos motivos. El primero es que no tiene límite de caracteres, y se puede cargar otras cosas de la memoria si escribo una cadena demasiado larga. Tampoco me preocupa mucho porque sólo son pruebas lo que estoy haciendo. Pero el motivo principal es que **get_string** tiene eco remoto. Eso quiere decir que en el PC verás en el terminal lo que tecleas mientras escribes. Cosa que gets no hace.

```c
/*****************************************************************************/
/*   Primera prueba de servos.
/*   Recibe los parámetros desde el PC para ver cuales son los que
/*   mejor se ajustan al motor.
/*
/*   14/12/2010
/*****************************************************************************/

#include "prueba1.h"
// Prefiero get_string() en input.c a gets() de stdlib.h
// porque se le puede poner un límite de caracteres
// y además tiene echo remoto (se ve lo que envías mientras escribes)
#include <input.c>


short activo =     0;   // indica si el pin está activo
                        // si lo hiciera con una instruccion bit
                        // no podría cambiarlo en el #define fácilmente
long Ton     =  1000;   // tiempo de duración del pulso (us)
long Periodo = 20000;   // duracion del periodo (us)

long atol(char *);

#int_TIMER1
void  TIMER1_isr(void) 
{
 /* Lo activamos y plantamos la interrupción
    para que se desactive al rato 
    Los valores de offset estan calculados con el simulador */
 if (!activo) {
  activo = 1;
  output_high(PIN_Servo);
  set_timer1(65535 - Ton + 60);
 }
 else {
  activo = 0;
  output_low(PIN_Servo);
  set_timer1(65535 - Periodo + Ton + 65);
 }
}



void main()
{
 setup_oscillator(OSC_4MHZ);
 
    setup_adc_ports(NO_ANALOGS|VSS_VDD);
 setup_adc(ADC_OFF);
 
 /* Timer1 con resolución de 1us,
    desbordamiento en 65.535ms a 4MHz */
 setup_timer_1(T1_INTERNAL|T1_DIV_BY_1);

 printf("Prueba de servo.\r\n");
 printf("  Escribe oXXXX para variar el tiempo On\r\n");
 printf("  o pXXXX para variar el periodo\r\n");

 enable_interrupts(INT_TIMER1);
 enable_interrupts(GLOBAL);


 for(;;) {
  char string[10];
  char var;
  long valor;

  get_string(string, sizeof(string));
  //strcpy(string,"o1234"); (DEBUG)
  var   = string[0];
  valor = atol(string+1);
  
  if (valor <= 0) {
   puts("Valor no valido.");
  }
  else { 
   if (var == 'o') {
    if (valor > Periodo) {
     puts("Valor no permitido pata Ton.");
    } 
    else { 
     Ton = valor;
    }
   }
   else if (var == 'p') {
    Periodo = valor;
   }
   else {
    puts("Comando no reconocido."); 
   }
   
   printf("\nTon = %Lu\r\n", Ton);
   printf("Periodo = %Lu\r\n", Periodo);
  }
 } 
}


/* Versión reducida de atol:
   Esta versión sólo trabaja con positivos y en decimal.
   Y para cadenas de hasta 256 caracteres. */
long atol(char *s)
{
 long result;
 char indice;
 char c;

 indice = 0;
 result = 0;
 
 c = s[indice];
 while (c >= '0' && c <= '9') {
   result = 10*result + (c - '0');
   indice++;
   c = s[indice];
 }

 return(result);
}
```

Por si teneis curiosidad, el fichero *prueba1.h* es así

```c
#include <12F683.h>

#device adc=16

#FUSES NOWDT                  //No Watch Dog Timer
#FUSES INTRC_IO               //Internal RC Osc, no CLKOUT
#FUSES NOCPD                  //No EE protection
#FUSES NOPROTECT              //Code not protected from reading
#FUSES NOMCLR                 //Master Clear pin used for I/O
#FUSES NOPUT                  //No Power Up Timer
#FUSES NOBROWNOUT             //No brownout reset
#FUSES IESO                   //Internal External Switch Over mode enabled
#FUSES FCMEN                  //Fail-safe clock monitor enabled

#define PIN_Servo   PIN_A2 // Salida para el servo
#define PIN_SrTX    PIN_A0 // TX serie para conectar al PC
#define PIN_SrRX    PIN_A1 // RX serie para conectar al PC

#use delay(clock=4000000)
#use rs232(baud=9600,INVERT,DISABLE_INTS,parity=E,xmit=PIN_SrTX,rcv=PIN_SrRX,bits=8)
```

## Salida del PIC

Vamos a usar la tarjeta de sonido que nos curramos en otra entrada ([Medir valores lógicos con una tarjeta de sonido]({{site.baseurl}}{% post_url 2010-10-20-medir-valores-logicos-con-tarjeta-de %})) para ver cómo son los pulsos que genera el programa y cómo cambian cuando tecleamos los comandos.

{% include image.html size="big" file="servo_pulsos.png" caption="" %}

La imagen es una captura de pantalla del Audacity. En la primera pista vemos pulsos de 500us con un periodo de 30ms. En la segunda el periodo es el mismo pero los pulsos son de 2.5ms (los hemos cambiado enviando el comando *o2500*) y en la tercera mantenemos la duración del pulso pero el periodo cambia a 20ms (comando *p20000*).

Fijaos que aquí se aprecia muy bien el [efecto de Gibbs](http://en.wikipedia.org/wiki/Gibbs_phenomenon) del que ya habíamos hablado en otro artículo debido al filtrado de las altas frecuencias. Se ve mucho porque hay una resistencia de 1k en serie con la entrada de la tarjeta y porque la frecuencia de muestreo de esta última es baja. A mayor corriente menos se nota la oscilación. Pero la corriente de salida del PIC es finita.

## Resultado

En este servo, el cable marrón va a masa, el rojo a positivo y el naranja es la señal de posición.

Los valores del periodo válidos van desde los 5ms a más de 35ms (que es el tope que se puede probar con el programa anterior, porque Timer1 se desborda).

En cuanto la de duración del pulso he visto que va entre 0.5ms y 2.5ms. Por debajo de 0.5ms el servo se coloca en posiciones aleatorias. Por encima de 2.5ms permanece en la posición de 180º sin moverse.

    <0.5ms ->     ?   (indeterminado)
     0.5ms ->     0º
     1.0ms ->   45º
     1.5ms ->   90º (centro)
     2.0ms -> 135º
     2.5ms -> 180º
    >2.5ms -> 180º (inmóvil)

A partir de ahí basta extrapolar para saber cuánto tiene que durar el pulso para situar el motor en la posición que queramos. Luego habrá que tener en cuenta la velocidad de giro.

Esto es todo por ahora. Os dejo el enlace a los archivos [aquí]({{page.assets | relative_url}}/servo_t1yt2.rar).
