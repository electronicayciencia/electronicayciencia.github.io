---
assets: /assets/2011/02/dimmer-controlado-por-mando-distancia
image: /assets/2011/02/dimmer-controlado-por-mando-distancia/img/interrupciones.png
layout: post
tags:
- Circuitos
- PIC
- Sensores
title: 'Dimmer controlado por mando a distancia: el software'
---

Si no seguís el blog o no recordáis de qué iba este proyecto, hay un resumen en esta entrada donde presentábamos el hardware: [Dimmer controlado por mando a distancia: el hardware]({{site.baseurl}}{% post_url 2010-12-10-dimmer-controlado-por-mando-distancia %}). Os recomiendo que la leáis porque hoy os traigo el software que hay que programar en el micro para hacer funcionar ese hardware.

Empezaremos con una lista de características que nos gustaría que tuviera. Que ya que lo hemos diseñado nosotros y lo vamos a programar, por lo menos que sea como nosotros queramos. Luego recordaremos cómo se regula la luz usando un triac y de ahí entraremos en el software. En lugar del código fuente, que sería extenso, lo explicaremos con ayuda de diagramas.

## Características

Veamos lo que le pediríamos a un Dimmer controlado por infrarrojos:

- Que se puedan memorizar los comandos. No es práctico que los comandos NEC del mando a distancia estén grabados en el código. Porque si mañana queremos utilizar otros botones o incluso otro mando a distancia (siempre que utilice el protocolo NEC) tendríamos que desinstalar el circuito, recompilar el código y volver a grabar el chip y luego volverlo a dejar donde estaba. Por tanto hay que buscar un método para grabar los comandos nuevos, una especie de **modo programación**.
- Que se pueda graduar la luz en pasos. A ser posibles en pasos de igual intensidad luminosa, con los cálculos que hicimos [aqui]({{site.baseurl}}{% post_url 2010-06-23-curva-de-respuesta-del-dimmer-ir %}).
- Que se pueda encender y apagar con el mando a distancia. Y que al encenderse lo haga con la potencia que lo apagamos. Lógicamente para eso tendrá que guardar la potencia anterior en la EEPROM y recuperarla cuando lo encendamos.
- Pero ¿y si perdemos el mando? En ese caso que sea transparente, o sea que cuando lo apaguemos del interruptor de la luz se apague la bombilla (eso es fácil, no queda más remedio porque va en serie) y que cuando lo encendamos, no del mando, sino del interruptor principal se encienda al 100%.
- De nuevo, si perdemos el mando ya no podremos reprogramarlo fácilmente. Así que mejor incorporamos un comando en el propio código que nos sirva de emergencia. Lo mismo se podría hacer con un interruptor, que al pulsarlo entrase en modo programación.
- También estaría bien que el encendido y apagado fuese lentamente, para que no deslumbre si encendemos en plena noche y para que quede más bonito.

Lo que hemos pedido casi parece la carta a los reyes magos, y programar todo eso en el chip va a requerir cierto esfuerzo mental para seguir la ejecución y no perdernos. Podríamos dividir el software en dos partes:

- **Los procesos en segundo plano:** Está claro que tenemos que hacer varias cosas a la vez. Por un lado tenemos que estar pendientes de cuando la tensión pasa por cero para dispara el TRIAC justo un instante después (el tiempo dependerá de la potencia). Mientras tanto tenemos que poder recibir un comando por el sensor del mando a distancia. Sin embargo no es preciso utilizar un sistema multitarea aún, ya que al ser reacciones sencillas, las dos cosas anteriores las manejamos usando interrupciones.
- **El bucle principal:** Es la parte que ejecuta los procesos más elaborados o que más tiempo requieren, como subir o bajar la potencia gradualmente, leer o escribir de la EEPROM, etc. Los procesos en segundo plano (disparados por interrupciones) activan *flags* globales que más adelante (cuando ha terminado la interrupción) *main* interpreta y actúa en consecuencia.

## Disparo del TRIAC

Al final, por muchas vueltas que demos, la función principal del dimmer es regular la intensidad de luz. Vamos a recordar en dos líneas cómo lo hacemos antes de meternos con el software.

Un [TRIAC](http://www.unicrom.com/Tut_triac.asp) es un dispositivo electrónico con tres patillas. Una de ellas es la puerta y las otras dos actúan de interruptor. Cuando metemos tensión en la puerta, pasa corriente entre los dos terminales principales siempre y cuando entre estos dos haya un mínimo de diferencia de potencial. Y se queda conduciendo mientras siga habiendo esa tensión por encima del mínimo, aunque hayamos desconectado la puerta.

En este caso hemos utilizado un optotriac para aislar el micro de la alta tensión (es recomendable cuando además tenemos una fuente de alimentación sin transformador, y una patilla directamente a la red para ver cuando pasa por cero). Lo malo del optotriac es que tiene por dentro un LED que hay que alimentar, y que puede consumir desde 5mA en algunas versiones, hasta 20mA en otros modelos. Y la fuente que teníamos iba justita para alimentar el micro, no nos sobran 15mA para alimentar el LED de continuo.

Afortunadamente no es un problema mayor, ya que habíamos dicho que una vez disparado el TRIAC este conducirá hasta que la tensión alterna pase por cero. Así que lo que vamos a hacer es:

1. Detectar el paso por cero.
1. Poner a contar un cronómetro (que va a ser TIMER0) durante un tiempo determinado. Si queremos más luz dispararemos antes, si queremos menos luz esperaremos un poco antes del disparo.
1. Disparar el TRIAC.
1. Poner a contar el mismo cronómetro de antes, pero esta vez contaremos un tiempo fijo, de algunos microsegundos. Suficiente para que el TRIAC pase a conducción.
1. Desactivar el LED del optotriac. Que no tiene ningún efecto porque el TRIAC ya está conduciendo, hasta el próximo paso por cero.

Así, mandando pulsos breves al LED en cada transición no agotamos la fuente y el micro sigue funcionando. ¿Y cómo sabemos el momento en que hay que encender el TRIAC después de cada paso por cero para obtener el brillo deseado? Pues con la variable **tmr0_ticks**. Es la variable más importante del programa y tendremos especial cuidado con ella. Pero antes, volvamos al proceso de disparo. Todo eso sucede en las rutinas de las interrupciones. Veámoslo más de cerca.

## Servicios de atención a las interrupciones

Este es un diagrama de flujo muy simplificado de las tareas en segundo plano.

{% include image.html size="big" file="interrupciones.png" caption="" %}

Hay tres eventos que queremos capturar:

- Un **cambio en los pines** de entrada, que puede ser en dos patas distintas: Si se trata de la pata que va conectada al **sensor infrarrojo** significa que estamos recibiendo una señal del mando a distancia. Y va a la máquina de estados que interpreta la codificación NEC como habíamos explicado en [esta entrada]({{site.baseurl}}{% post_url 2010-05-07-receptor-con-pic-para-mandos %}). La otra opción es que sea el pin de **Zero Crossing** y nos indica un cambio de polaridad en la corriente alterna que alimenta la bombilla. Cuando eso pasa el TRIAC se apaga; y tenemos que volverlo a encender pasado un breve retardo que, como hemos dicho, va en función del brillo que queramos.
- Un **desbordamiento de TIMER1**, que significa que no hemos recibido más señales en el sensor de infrarrojos. Lo que hacemos es reiniciar la máquina de estados NEC por si se hubiera quedado un comando a medias.
- Un **desbordamiento de TIMER0**. Es el evento más importante de todos, junto con el detectar el paso por cero. En el apartado anterior hemos descrito el algoritmo. Cuando detectamos el paso por cero, habíamos programado el TIMER0 para que se desbordara según el valor de la variable **tmr0_ticks**. Entonces al desbordarse TIMER0 hay dos posibilidades. Si el TRIAC estaba apagado lo encendemos y programamos el TIMER0 para que se desborde al cabo de unos pocos microsegundos. Se desbordará. Llegaremos a la misma interrupción y en esta caso el TRIAC estará encendido. Lo apagamos y desactivamos la interrupción de TIMER0, a la espera de que otro paso por cero la vuelva a activar repitiendo el ciclo.

## Llamadas a funciones

Aquí tenemos un gráfico simplificado de llamadas:

{% include image.html size="big" file="call_graph.png" caption="" %}

Hay una función que es **main**. Main tiene un bucle que se encarga de ver cuando hay un comando NEC listo y actúa llamando a la función comando que corresponda. La potencia va de 0% a 100%.

Las funciones de color verde son **comandos** que llegan por el mando a distancia:

- **sube_pow:** Incrementa la potencia (el brillo) en 20 unidades. Por tanto tenemos 6 posibles niveles: luz apagada (0%), 20%, 40%, 60%, 80% y luz totalmente encendida (100%).
- **baja_pow:** Igual que la anterior pero baja la intensidad luminosa en lugar de subirla.
- **on_off_pow:** Apaga la luz o la encente, recuperando el brillo de la última vez. Está claro que tiene que llamar a las funciones que trabajan con la EEPROM para para almacenar el último valor y recargarlo más tarde.
- **aprender_IR:** Uno de los comandos es el modo programación, donde podemos pulsar botones del mando y asociarlos a los diferentes comandos. Para ello los tenemos que escribir en la EEPROM.
- **set_pow:** Sin embargo ninguna de estas funciones modifica la potencia directamente, sino que llaman a una función que se llama *set_pow* para hacer la transición. *set_pow* tiene además un parámetro para indicarle si queremos que el cambio se haga inmediatamente o de forma gradual.
- **pow2ticks:** Pero ni siquiera *set_pow* juega con la variable **tmr0_ticks**. Es otra función *pow2ticks* quien hace una conversión entre el valor en tanto por ciento se la potencia y el valor que tiene que asignarle a tmr0_ticks para que los desbordamientos de TIMER0 den como resultado esa potencia. En *pow2ticks* hay una tabla de conversión, en la variable *valores* que da los valores de la variable en incrementos del 5%. Con esos valores hacemos una interpolación lineal para calcular los intermedios. ¿De donde hemos sacado esos números? Pues de aquí: [Curva de respuesta del Dimmer IR]({{site.baseurl}}{% post_url 2010-06-23-curva-de-respuesta-del-dimmer-ir %}). Nos quedamos con el valor de la columna *inicio reloj* para una sensación del 5%, 10% etc. Si sois observadores veréis que los números no coinciden, y es sencillamente porque los cálculos no son perfectos y la sensación luminosa depende también del tamaño de la habitación, tipo de pintura y color de las paredes, altura y forma de la lámpara, etc. Ni siquiera dos personas perciben la misma sensación igual cantidad de luz. Así que al final lo terminé adaptando a ojo.

Una vez que *pow2ticks* actualiza el valor de *tmr0_ticks* ese valor entra en los procesos de segundo plano (las interrupciones que habíamos visto antes) y la potencia cambia inmediatamente.

No obstante *main* llama de forma excepcional directamente a *set_pow*. ¿Por qué llama por su cuenta a una función que sólo deberían llamar los comandos? Es algo que ocurre durante el arranque, cuando pulsamos el interruptor de la luz. Como el circuito no se había apagado con el mando (no estaba en stand-by sino apagado del interruptor) main asume una situación excepcional (por ejemplo que no tenemos el mando a mano), así que conecta la bombilla a plena potencia. Igualmente al arrancar lee los códigos NEC asociados a comandos y los carga para que cuando llegue uno sepa interpretarlo.

## Modo de empleo

Bien, pues ya tenemos nuestro circuito montado, y os he dado una buena paliza contándoos cómo va el software. Lo habéis programado y lo vamos a probar.

La primera parte es tediosa. Pero más abajo os confieso por qué no me he molestado en depurarla.

Lo primero que deberíais hacer es tomar un mando a distancia distinto del que pensáis utilizar. Tenemos que captar un código de ese mando que nos servirá de código maestro. Por si se corrompen los datos en la EEPROM o se rompe el mando bueno, por ejemplo. Para captar el código correspondiente hay dos formas, o bien montáis en un momento el circuito receptor que hay en [esta entrada]({{site.baseurl}}{% post_url 2010-05-07-receptor-con-pic-para-mandos %}); o bien os vais al archivo *main.h*, ponéis el código en modo depuración descomentando la última línea y recompiláis. Si hacéis esto montad el PIC en una protoboard porque no es recomendable conectarlo al puerto USB y a la tensión de red al mismo tiempo. Os recuerdo que para conectar el PIC al puerto PC, si no tenéis puerto serie podéis utilizar este [conversor]({{site.baseurl}}{% post_url 2011-01-12-adaptador-de-usb-serie %}).

Una vez que tengamos el código maestro, lo ponemos en la variable *IR_CODE_MASTER* de main.h y recompilamos. Para recompilar es imprescindible tener el compilador CCS.

Programamos el PIC y lo montamos en la placa. Enchufamos la bombilla y la tensión a la clema. Asumo que habéis hecho todo tipo de comprobaciones de que todo está en su sitio, que tenéis un fusible intercalado y cierta experiencia trabajando con media tensión. Una sacudida de 220V no es lo mismo que un corto de 5V, la tensión de red no se anda con bromas.

Ahora tomad el mando que pensáis usar y el maestro. Cuando pulséis la tecla maestra, la función aprender_IR llamará a set_pow y hará parpadear la bombilla indicando que estamos en modo programación. Ahora id pulsando teclas en el mando en el siguiente orden:

1. Encender / apagar
1. Bajar potencia
1. Subir potencia

tras introducir cada comando la bombilla debe parpadear indicando que ha reconocido la pulsación. Una vez introducidos los tres comandos parpadea dos veces y se apaga. Ahora ya tenemos el PIC listo para funcionar.

## Conclusión

Os decía antes que la puesta en marcha es un lío. Y se podía haber simplificado simplemente poniendo un interruptor que al pulsarlo entrase en modo programación. Podéis hacerlo, os lo dejo a vosotros. La verdad es que tras tenerlo instalado unos meses no me ha terminado de convencer. Porque al tener la luz baja se observa un leve parpadeo y un ligero zumbido de alterna. Próximamente quiero proyectar un dimmer, esta vez basado en MOSFET, con una frecuencia de conmutación mucho más alta que espero que solucione esos defectos. Para eso hay que rectificar previamente la tensión, lo que permite más carga en la fuente de alimentación, entre otras cosas. Hay que olvidarse de la fase del disparo y pensar en PWM.

En definitiva, como experimento, cada una de las entradas del proyecto [DimmerIR](http://electronicayciencia.blogspot.com/search/label/DimmerIR) me ha enseñado cosas y me ha dado la experiencia necesaria para ahondar en este tipo de proyectos. Espero que, tanto si os habéis animado a construir el circuito, como si sólo lo habéis seguido por encima os haya aportado ideas que os sirvan para vuestros futuros proyectos.

Os dejo el software en [este enlace]({{page.assets | relative_url}}/DimmerIR_sw.rar). Y si tenéis cualquier duda escribid un comentario.
