---
assets: /assets/2010/05/transmisor-protocolo-nec-con-pic
image: /assets/2010/05/transmisor-protocolo-nec-con-pic/img/trace.png
layout: post
tags:
- Binario
- Circuitos
- PIC
title: Transmisor protocolo NEC con PIC
---

En una [entrada anterior]({{site.baseurl}}{% post_url 2010-05-07-receptor-con-pic-para-mandos %}) propusimos un código para programar un microcontrolador PIC y que fuera capaz de recibir y decodificar la señal que emite un mando a distancia que use el protocolo NEC (los más frecuentes hoy día según mi experiencia). Para complementar esa entrada, hoy os voy a proponer una rutina que envía un código NEC simulando ser un mando a distancia.

Las aplicaciones de estos circuitos transmisores son variadas, desde hacernos nuestro propio mando a distancia para algún proyecto hasta apagar *discretamente* el televisor en un bar justo antes del último penalti. También se puede usar para transmisión de datos de manera inalámbrica desde uno o varios sensores, ya que tenemos 32 bits disponibles usaríamos los primeros para indicar un código y el resto para el valor. La velocidad de transferencia sería de unos 15 códigos por segundo. No hay ni que mencionar los las utilidades en domótica que cada uno pueda imaginar, como encender y apagar la TV a determinadas horas, incluso cambiar de canal para aparentar que la casa está habitada mientras estamos de vacaciones; o controlar algún dispositivo por ordenador.

<!--more-->

## Portadora

La rutina es muy sencilla. Aunque hay un punto que merece especial atención: la modulación en 38kHz de la portadora. Lo más cómodo es usar el **módulo PWM** y configurarlo para esa frecuencia. Cuando queramos transmitir ponemos el duty-cycle al 50% y cuando no queramos lo fijamos al 0%. Con el siguiente código preparamos el módulo CCP:

```cpp
setup_ccp1(CCP_PWM);
set_pwm1_duty(0);
setup_timer_2(T2_DIV_BY_1,26,1);
```

Si nuestro PIC funciona a 4MHz significa que Timer2 se incrementa a un ritmo de 1 cada microsegundo. Como no aplicamos prescaler ni postscaler en Timer2, este tardará en llegar a 26 y desbordarse un periodo de 26us. Esto nos da una frecuencia de 38.462kHz, que está un 1.2% por encima de los 38.000kHz que queríamos. Pero si pusiéramos 27 en lugar de 26 tendríamos una frecuencia de 37.037kHz que está un 2.5% por debajo. Podéis probar con ambos, para ver cual de los dos tiene mayor alcance pues depende del receptor usado que tenga **más sensibilidad** en una frecuencia portadora u otra.

## Modulación

Como habíamos dicho, la modulación la haremos conmutando el *duty-cycle* con la instrucción set_pwm1_duty(13). Nota: 13 es la mitad de 26 que habíamos puesto al fijar el Timer2, por tanto tenemos el DC al 50%.

```cpp
void ir_send(unsigned int32 code)
{
 unsigned char i = 0;
 disable_interrupts(GLOBAL); 
 
 // Envío el START
 set_pwm1_duty(13);
 delay_us(9000);
 
 set_pwm1_duty(0);
 delay_us(4500);

 // Voy desgranando el código
 while (i < 32) {
  #bit first = code.31
  
  // Transmitimos un 1
  if (first) {
   set_pwm1_duty(13);
   delay_us(560);
   set_pwm1_duty(0);
   delay_us(1690); 
  }
  
  // Transmitimos un 0
  else {
   set_pwm1_duty(13);
   delay_us(560); 
   set_pwm1_duty(0);
   delay_us(560); 
  }
  
  code <<= 1;
  i++;
 }
 
 // Bit de parada
 set_pwm1_duty(13);
 delay_us(560); 
 set_pwm1_duty(0);
 
 enable_interrupts(GLOBAL);
}
```

- Comenzamos emitiendo una **ráfaga de 9ms** que sirve para que el receptor se prepare y ajuste su control de ganancia.
- Tras esto una **pausa de 4.5ms**.
- Ahora vamos desgranando el código binario. Para el **1** se transmite un pulso de 560us seguido de una pausa de 1690us.
- Para el **0** se transmite un pulso de 560us de duración igual que el anterior, pero a continuación se hace una pausa más corta, que dura otros 560us.
- Finalmente se transmite un **pulso de parada** que cierra la transmisión. Este último pulso es necesario para que el receptor sepa si la pausa tras el último bit es de 560 o de 1690us, y pueda deducir si se trataba de un 0 o de un 1 respectivamente.

## Uso de la función

Para llamar a la función es suficiente con pasarle un argumento de 32bits que será lo que se transmita. Por ejemplo si hemos capturado con [el receptor]({{site.baseurl}}{% post_url 2010-05-07-receptor-con-pic-para-mandos %}) el código de encendido/apagado del televisor y es *20DF10EF* lo podemos transmitir de esta manera:

```c
#define IR_CODE_TV_ON   0x20DF10EFL

ir_send(IR_CODE_TV_ON);
```

el código 20DF10EF se escribe en **binario** como *0010 0000 1101 1111 0001 0000 1110 1111* (32 bits, 32 unos y ceros). Si monitorizamos GP2 en el analizador lógico de MPLAB veremos la siguiente ráfaga:

{% include image.html size="big" file="trace.png" caption="" %}

se aprecia el pulso de start, la duración de los 1 y los 0 y el bit de parada. Pero recordemos que lo que modulamos es una portadora de 38kHz, así que si hacemos zoom apreciamos esta frecuencia:

{% include image.html size="big" file="trace_zoom.png" caption="" %}

## Conexionado

Una de las preguntas más frecuentes es si necesitamos un transistor para encender y apagar el LED IR o si por el contrario será suficiente con la capacidad de salida del PIC. ¿Hay que poner alguna resistencia en serie? Para aclararlo es preciso calcular el tiempo promedio que permanece encendido el LED durante el envío de un código.

{% include image.html size="small" file="conexionado.png" caption="" %}

Vamos a tomar el supuesto de que el código sea **todo ceros**, puesto que la pausa para los 1 es más larga, un pulso que sea todo ceros tiene más energía por unidad de tiempo. Digamos que *no deja descansar el LED*. En este pulso durará 9000us + 4500us + 32*1120 + 560 = 49900us, de todo ese tiempo, sólo estará activo el pulso inicial de 9000us y los 32 pulsos de 560 más el de parada, en total 27480us. Pero recordemos que la portadora tiene un 50% de *duty-cycle*, por lo que el tiempo que realmente está encendido es la mitad: 13740us. Esto es un 28% del tiempo total. Y para el código que más potencia transmite.

Hagamos los cálculos para un código que esté compuesto **sólo de unos**. En es caso, el tiempo invertido en la transmisión es: 9000us + 4500us + 32*2250us + 560us = 86060us. Y el tiempo que permanece encendido es el mismo que antes, 13740us, porque sólo varían las pausas. Esto es un 16%.

Como no hay razones para suponer que los códigos van a estar formados por todo unos o por todo ceros, haremos la media de los dos casos. *En promedio el LED recibe un 22% de la energía durante el tiempo que está encendido.* Y eso suponiendo que emita continuamente, cosa que no se suele hacer, pues se transmite el código, una pausa y a continuación sólo el comando de repetición, que es mucho más breve. En cualquier caso si alimentamos el PIC con 5 voltios, el 22% supone 1.1V, un valor aceptable para el LED.

Como conclusión no es preciso usar un transistor ni una resistencia cuando se conecta el LED al PIC. Conseguimos el máximo alcance a costa de reducir muy ligeramente el tiempo de vida. Si acaso quisiera usarse una resistencia limitadora para **proteger** tanto al PIC como al LED debería usarse un valor bajo, alrededor de 100ohm, para no rebajar demasiado el alcance del transmisor.

Os dejo el código fuente y el fichero .hex en [este enlace]({{page.assets | relative_url}}/emisorNEC.rar).
