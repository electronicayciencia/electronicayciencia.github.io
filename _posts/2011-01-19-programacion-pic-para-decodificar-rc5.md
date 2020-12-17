---
assets: /assets/2011/01/programacion-pic-para-decodificar-rc5
image: /assets/2011/01/programacion-pic-para-decodificar-rc5/img/11011110.grid.png
layout: post
tags:
- Binario
- PIC
title: Programación PIC para decodificar RC5
---

Para decodificar el protocolo RC5 hay dos formas de hacerlo. Una es muestreando el puerto cada cierto tiempo, y comprobando si está a nivel alto o nivel bajo. En función del resultado lo interpretamos.

Esto es un ejemplo de codificación Manchester:

{% include image.html size="big" file="11011110.grid.png" caption="" %}

Hace ya tiempo conté una forma de decodificar el protocolo RC5 utilizando un PIC: [Decodificacion del protocolo RC5 usando un PIC]({{site.baseurl}}{% post_url 2010-04-01-decodificacion-del-protocolo-rc5-usando %}). Por algunos correos que he recibido parece que no terminó de quedar claro, y además prometí dedicarle otra entrada al código C. Sería muy conveniente que repasaras la entrada a la que me refiero, porque esta no es más que una especie de nota aclaratoria.

Para empezar supongamos que nos llega una señal como la de arriba. Las lineas verticales separan los periodos y es más fácil de ver donde empieza y acaba cada símbolo. Recordemos la dos reglas de oro:

1. **Siempre, siempre hay una transición en mitad de un periodo**. Precisamente porque [tiene la señal de reloj incorporada](http://en.wikipedia.org/wiki/Self-clocking_signal). Recordad que es para ayudarnos a sincronizar el reloj del receptor con el del transmisor. Aunque casi nunca se ajusta dinámicamente; simplemente sincronizamos al principio y nos limitamos a dar error si se desincroniza. Aunque ya vimos como se puede ajustar dinámicamente la frecuencia de reloj para decodificar señales tipo [Aiken Biphase]({{site.baseurl}}{% post_url 2010-11-24-decodificar-aiken-biphase-con-perl %}) cuando leímos la banda magnética de las tarjetas de crédito.
1. **Si la transición es hacia arriba (de 0 a 1) se interpreta como un 1, si es hacia abajo, se interpreta como un 0.** Lo que también podría decirse como *si el pulso positivo está a la izquierda del periodo es un 0 y si está a la derecha es un 1*. Mira la imagen de abajo, te ayudará.

{% include image.html size="big" file="rc5.png" caption="" %}

## El programa

No quiero resultar cansino, así que voy a suponer que has leído la entrada anterior, o que la recuerdas y me voy a saltar las explicaciones.

Tenemos la señal de ejemplo de arriba, voy a quitar las líneas divisorias y a numerar las transiciones.

{% include image.html size="big" file="11011110.nogrid.png" caption="" %}

Los números en la parte de arriba son correlativos e indican de qué transición se trata. La línea de abajo corresponde a la interpretación que s ele da a las transiciones. Las marcas de confirmación, que representan bits, están representadas por números grandes, mientras que los número pequeños indican una marcas de continuación.

Pegamos el código y a continuación os explico cómo funciona.

```c
#include "rc5.h"

// 100 tmr1 =~ 200us =~ +- 20% (sobre 889us)
#define TMR1_TOL 100
#define IR_PIN  PIN_A0

/*
 Estados de la máquina:
 0 - Reset
  - Se resetan las variables
 1 - S1 recibido
  - Calculado t
 2 - S2 recibido
  - Calculado t en función de la media
  - Totalmente inicializada.
 3 - Marca de continuidad no recibida
 4 - Marca de continuidad recibida
*/

#define RC5_RESET 0
#define RC5_S1  1
#define RC5_S2  2
#define RC5_DONE 3
#define RC5_MARK 4



unsigned int16 rc5_COMANDO = 0; // S1 y S2.
unsigned int16 rc5_t;
unsigned char rc5_stad = 0;


#int_TIMER1
void  TIMER1_isr(void) 
{
 // Si el ultimo pulso fue hace más de X ms da timeout y resetea la máquina de estados RC5.
 // El prescaler de TMR1 es 2: 2 x 256 x 256 =~ 131 ms.
 // Teoricamente un semiperiodo deben ser (889us) tmr1 = 444.
 rc5_stad = 0; // maquina de estados RC5 reiniciada
}

#int_RA
void  RA_isr(void) 
{
 unsigned int16 int_time;
 unsigned char semiperiodos;

 int_time = get_timer1();
 
 
 semiperiodos = input(IR_PIN); // para limpiar la interrupción
 clear_interrupt(INT_RA);
 semiperiodos = 0;

 
 // Calculamos cuantos semiperiodos dura el lapso de tiempo
 // para ahorrar el cálculo después
 if (rc5_stad > RC5_S1) {
  signed int16 lapso;
  lapso = (signed int16) (rc5_t - int_time);
  
  if (lapso < 0)  lapso = - lapso;
  lapso -= TMR1_TOL;
  
  if (lapso < 0) {
   semiperiodos = 1;
  } 
  else if (lapso < rc5_t) {
   semiperiodos = 2;
  }
  else {
   rc5_stad = RC5_RESET;
   goto END; 
  } 

 } 
 
 // COMENZAR AQUI
 // Es el pulso de start1
 if (rc5_stad == 0) {
  rc5_COMANDO = 0b0000000000000011;
  rc5_stad++;  // maquina iniciada (estado 1)
 }
 
 // es el segundo pulso (marca de continuidad del start1)
 else if (rc5_stad == RC5_S1){
  rc5_t = int_time;
  rc5_stad++;  // primer pulso recibido (estado 2)
 }
 
 // es el tercer pulso (confirmación de start2)
 else if (rc5_stad == RC5_S2) {

  if (semiperiodos != 1) {
   //error("No parece RC5.");
   rc5_stad = 0;
   goto END;
  }
  rc5_t += int_time;
  rc5_t /= 2;  // media entre los dos
  rc5_stad++;  // cálculo del periodo completado (estado 3)
 }
 
 // transición sin marca de continuación
 // se ha invertido el bit
 else if ( semiperiodos == 2 ) {
  // El estado 4 es para esperar la confirmación de continuidad
  // No debería darse el caso
  #bit OLDlastBit = rc5_COMANDO.1
  #bit NEWlastBit = rc5_COMANDO.0
  
  if (rc5_stad == RC5_MARK) {
   //error("Error de protocolo.");
   rc5_stad = 0;
   goto END;
  }
  
  rc5_COMANDO <<= 1;
  NEWlastBit = ~OLDlastBit;
 }
 // se trata de una marca de continuación o una confirmación
 else if ( semiperiodos == 1 ) {
  // es una marca, espero la confirmación
  if (rc5_stad == RC5_DONE) {
   rc5_stad = RC5_MARK;
  }
  // es una confirmación
  // se continua el bit anterior
  else {
   #bit OLDlastBit = rc5_COMANDO.1
   #bit NEWlastBit = rc5_COMANDO.0
   rc5_COMANDO <<= 1;
   NEWlastBit = OLDlastBit;
   
   rc5_stad = RC5_DONE;
  }
 }
 
 else {
  rc5_stad = RC5_RESET; // algún error
 } 

END:
 set_timer1(0);
}




void main()
{

   port_a_pullups(TRUE);
   setup_timer_1(T1_INTERNAL|T1_DIV_BY_2);
   enable_interrupts(INT_TIMER1);
   enable_interrupts(INT_RA);
   enable_interrupts(GLOBAL);
   setup_oscillator(OSC_4MHZ);


 for (;;) {
  if (bit_test (rc5_COMANDO, 7)) {
   rc5_COMANDO = 0; 
  }   
 } 

}
```

El bucle de recepción está en la interrupción RA. Lo primero que hacemos cuando detectamos el cambio del puerto es quedarnos con el valor del timer 1. Ese valor puede ser aleatorio si es la primera transición, pero a partir de la segunda ese valor nos indica el tiempo transcurrido desde el último cambio porque precisamente lo que hacemos como última instrucción al salir de la interrupción es reiniciar timer1. Luego limpiamos la interrupción haciendo un input del puerto; he reutilizado la variable semiperíodos por no definir otra, pero ni que decir tiene que eso no son los semiperíodos.

Hay que tener en cuenta que este programa es sólo para que veais el algoritmo. En la vida real tendríamos que poner una condición para ver si lo que ha cambiado es el pin al que tenemos conectado el sensor o es otro distinto.

Todo gira alrededor de una máquina de estados. El estado inicial es el **estado cero**. Las variables están en sus valores por defecto y el sistema está listo para empezar a recibir un comando.

## Inicialización

Llega la primera transición. Nuestro objetivo ahora es calcular el semiperíodo para cuando lleguen las transiciones de los datos poder saber qué significan. Sabemos, por definición del protocolo, que lo primero que nos va a llegar son dos bit de start y van a ser sendos unos. Mirad la imagen de arriba, son las transiciones 1, 2 y 3 y entre cada una hay un semiperíodo.  Podría calcular la duración del semiperíodo simplemente basándome en la diferencia entre la 1ª y la 2ª. Pero ya que son dos marcas de start es más fiable si calculo la diferencia de tiempos entre la 1 y la 2, y también de la 2 a la 3 y luego hago una media.

Como decíamos, llega la primera transición. Id a la línea 80, donde dice "Comenzar aquí". Estamos en el estado cero, todo reseteado. A lo más que podemos aspirar aquí es a poner los dos unos de start en la variable COMANDO y poco más. Pero lo más importante que hacemos es pasar al **estado uno** y salir reiniciando timer 1 como habíamos dicho.

Llega otra transición, sería la 2ª. Estamos en el **estado uno**. Lo que nos indica que no es la primera y que tenemos otra para calcular cuanto tiempo ha pasado entre ambas. La variable *int_time*, calculada al principio del bucle contiene el valor de timer1, y puesto que lo habíamos reiniciado antes, contiene el tiempo desde la transición anterior, que como sabemos es un semiperíodo.

Notad que cuando hablo de tiempos, no me refiero a segundos, ni a instrucciones, sino a tics del timer1. El tiempo real en segundos dependerá de la velocidad del reloj y de cómo esté configurado el prescaler. En cualquier caso no nos interesa el tiempo real, sino una medida con la que comparar para saber si entre dos transiciones hay una medida (semiperíodo) o dos (un periodo). A cuántos microsegundos equivale es irrelevante.

Calculado el primer semiperíodo avanzamos al **estado dos**. Cuando llega la tercera transición, como el estado es dos, vamos a la línea 58. Ahí comparamos la duración con la variable **rc5_t**, que es la que dice cuanto dura un semiperíodo. Hablaremos luego de cómo funciona la comparación.

Volvemos a la parte del código que controla la máquina de estados, a partir de la línea "Comenzar aquí". En este caso como el estado es dos, aterrizamos en la **línea 92**. Acto seguido miramos si la duración entre las transiciones 2 y 3 es equiparable a la duración entre la 1 y la 2. Porque si no es así puede que hayamos hecho mal la medida. Si son comparables, hacemos la media aritmética y nos quedamos con el resultado. Esa será nuestra variable **rc5_t** para toda la ráfaga que sigue. Pasamos al **estado tres**: inicialización completada. El estado tres también implica *Marca de continuidad no recibida*, que significa que hemos terminado de recibir un bit. Y así es porque los bits de start son unos. Ya podemos empezar a recibir datos de verdad.

## Comparación

Ahora sí vamos a explicar cómo hacemos la comparación, vamos a la línea 58 del código. Tenemos, por un lado la duración de un semiperíodo (recordemos, en pulsos de timer 1) en la variable **rc5_t**; y por el otro, en **int_time** el tiempo desde la última transición. Lo que quiero es comparar ambos valores, dentro de unos márgenes de **tolerancia**, para saber si *int_time* equivale a un periodo, a dos, o a ninguna de las dos cosas.

Si estuviéramos programando en un PC, para saber si int_time es equivalente a rc5_t con una tolerancia del 10% haríamos una comparación tal que así:

    if (int_time > 0.90*rc5_t) && 

       (int_time < 1.10*rc5_t) ...

Pero en un microcontrolador este tipo de cosas conviene evitarlas, principalmente porque los compiladores no suelen estar tan optimizados y malgastan los limitados bits de RAM. Además implícitamente estamos obligando al compilador a:

- Usar aritmética de coma flotante: Que implica cargar unas librerías más que pesadas y nos van a agotar la ROM si es un PIC pequeñito. Tal vez el compilador se diera cuenta de lo que queremos hacer y usara aritmética de punto fijo, pero en ese caso...
- ... forzamos una o varias divisiones. Y las divisiones son las operaciones más lentas, a menos que se trate de dividir por una potencia de dos, que entonces es tan simple como desplazar los bit hacia la derecha. No olvidéis que todo esto se ejecuta dentro de un servicio de interrupción, donde la rapidez y la ligereza son imprescindibles. No podemos permitirnos tener al procesador ocupado atendiendo una interrupción durante mucho tiempo, porque mientras tanto no hace lo que tiene que hacer.

En resumidas cuentas, que siendo esto una rutina para reconocer comandos por mando a distancia, estamos obligados a hacerla lo más compacta y eficiente posible. Lo ideal sería hacerla en ensamblador... eso ya os lo dejo a vosotros jejeje.

Así que recurriré a una vuelta un poco menos evidente, pero que una vez compilada, en comparación es más eficaz.

1. Para empezar sólo se ejecuta esta parte cuando hemos pasado el estado 1, o sea cuando ya tenemos un valor de rc5_t con el que comparar.
1. Definimos una tolerancia fija, **TMR1_TOL**, en este caso de 100 tics de timer1 (vedlo en la linea 4).
1. Definimos una variable temporal, llamada **lapso**, y le asignamos la diferencia entre *int_time* y *rc5_t*. *Lapso* tiende a **0** cuando ambas fueran iguales (un semiperíodo) y tendería a **rc5_t** si es el doble de este valor (dos semiperíodos).
1. Nos interesa sólo el valor absoluto de *lapso*, ya que ahora vamos restarle la tolerancia.
1. Si *lapso* era menor que la tolerancia significa que *int_time* está dentro de los márgenes para ser considerada igual a *rc5_t*, o sea, **un semiperíodo**.
1. Si, por el contrario, *lapso* es mayor que la tolerancia, pero no llega a sobrepasar *rc5_t* diremos que dura **dos semiperíodos**.
1. En el caso que *lapso* fuera mayor que *rc5_t*, implica que *int_time* es mayor que el doble de *rc5_t* más la tolerancia. Significa que nos hemos saltado alguna transición o que el protocolo no es RC5, así que ponemos el **estado cero** para que la máquina de estados se reinicie.

He tenido en cuenta la forma en la que el compilador CCS optimiza. Por ejemplo, las comparaciones con 0 o con un número fijo son más rápidas que las comparaciones con variables, por eso sólo se hace una vez. En general siempre es esí, pero puede depender del compilador. Cuando se realizan operaciones implícitas dentro de la comparación se está utilizando espacio de almacenamiento temporal y da lugar a un código más complejo. Estas son cosas que sólo se ven en el código compilado. Si estáis programando un microcontrolador para un proyecto crítico siempre es bueno repasar el código una vez compilado, sobre todo en ciertas partes "problemáticas" como las comparaciones, y las rutinas que más se ejecutan. Para proyectos profesionales hay herramientas de tipo perfiladores para micros, pero si no disponemos de ellas pues nos toca hacerlo a mano.

## Recepción de los datos

Vale, ahora ya sabemos si el tiempo desde la última transición es (aproximadamente) un semiperíodo o dos. A partir de la línea 106 y de la 122 se aplica el algoritmo que habíamos descrito en la entrada que cito al principio. Y cuando se trata de una marca de confirmación rotamos todos los bit de la variable *rc5_COMANDO* hacia la izquierda y metemos el bit nuevo.

La máquina de estados se pone en el **estado tres** cuando recibimos una marca de confirmación o de cambio. En ambos casos se fija el bit. Mientras el **estado cuatro** es un estado temporal que indica que hemos recibido una marca de continuación, pero aún no hemos recibido la confirmación. Si en este estado la comparación nos devuelve 2 semiperiodos se trata de una sitación que no tiene sentido, así que asignamos el estado 0 y salimos.

## Parada

Hay dos situaciones en que la máquina de estados deja de recibir.

La primera es cuando la comparación de la línea 162 en la función *main* es verdadera. Recordad que *main* se está ejecutando continuamente, siendo interrumpida ocasionalmente cuando cambia el pin del sensor infrarrojo para meter más bit en la variable *rc5_COMANDO*. Pues bien, a medida que vamos metiendo bits por la derecha, los bits de start van avanzando hacia la izquierda. Si yo sé que mi comando tiene 7 bits de largo, voy fijándome en la variable para que en cuando los bits de start alcancen la posición 7ª interpretar el comando completo.

Hay otra situación, y es que la máquina de estados se reinicia automáticamente cuando no se reciben datos por un tiempo. Recordad que la última intrucción de la rutina que examinamos antes es reinicial el contador timer1. Si un comando se corta y llega a la mitad no se reinicia más, y llegará el momento que timer 1 se desborde. Cuando eso ocurre se llega a la rutina en la línea 34, que lo único que hace es poner el estado a cero, para volver a empezar la recepción de nuevo.
