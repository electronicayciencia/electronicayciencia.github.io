---
assets: /assets/2011/01/adaptador-de-usb-serie
image: /assets/2011/01/adaptador-de-usb-serie/img/BENQ0005.JPG
layout: post
tags:
- Reciclaje
title: Adaptador de USB a Serie
---

La primera entrada de este blog ([Conversor USB - RS232]({{site.baseurl}}{% post_url 2010-03-22-conversor-usb-rs232 %})) la dediqué a contaros cómo hacernos un adaptador sencillo y muy cómodo para conectar un microcontrolador al PC cuando no teníamos puerto serie. Y aún cuando tuviéramos, a mi me resulta mucho más práctico este adaptador que un puerto serie *de verdad*.

Recordemos que nos basamos en un adaptador comercial barato (2.86 USD) y de poca calidad: [http://www.dealextreme.com/details.dx/sku.24799](http://www.dealextreme.com/details.dx/sku.24799). En esta segunda versión voy a aportaros alguna foto con más calidad, para facilitaros el montaje. También quiero explicaros **por qué se hacen los puentes** que se hacen. Y por último voy a añadir un cuarto **cable de alimentación positiva** para alimentar el dispositivo directamente desde el puerto USB.

{% include image.html size="big" file="BENQ0005.JPG" caption="" %}

Aquí tenemos cuatro cables:

- **Positivo** de alimentación +5V (rojo)
- **Transmisión** de datos hacia el PC (blanco)
- **Recepción** de datos desde el PC (naranja)
- **Negativo** de alimentación y masa de la señal, 0V (negro)

Aunque el conector USB también tiene cuatro hilos, la transmisión de datos es muy diferente. Y aunque yo lo he planteado como un adaptador externo, por el precio que tiene bien se podría dejar dentro de algún que otro invento que nos sea práctico. En ocasiones vale más eso que comprar un PL2303 (que es el chip en que se basa) y un cuarzo y montarlo nosotros, con las dificultades para comprarlo (generalmente online), el coste del chip más los gastos de envío, y los problemas que da soldar placas con componentes SMD. Estoy hablando de cacharros para nosotros, claro. A la hora de diseñar algo para la venta hay mejores opciones.

Decía antes que es de mala calidad, pero son detalles que bien nos benefician o que podemos solucionar fácilmente, me explico:

- **Los niveles de salida** no son RS232 (+-12V), sino que son **TTL** (0-5V). Pues bien, eso que para algunos módems no sirve, para nosotros que queremos conectarlo a un microcontrolador, que precisamente usa niveles TTL nos viene de perlas. Porque si llevara un conversor de nivel como el MAX232 tendríamos que quitárselo.
- A veces me he encontrado **soldaduras mal hechas** y pistas cortocircuitadas. Pero el circuito tiene tan pocos componentes que a poco que uno mire se da cuenta.
- El **oscilador es inestable**. No termino de ver el motivo pero en todos los adaptadores de este modelo que he comprado falla el oscilador. De forma que cuando lo conectas, Windows no reconoce el dispositivo y lo da por defectuoso, y Linux no sabe indicar qué has conectado. Una forma fácil y rápida de arreglarlo es colocar una resistencia de 100kohm en paralelo con el cristal, como veréis en las fotos siguientes.

## Montaje

Se trata nada más de que eliminar las clavijas USB y RS232 y conectar sendos cables. Conectar la resistencia de la que hablábamos antes y hacer unos cuantos puentes para el handshake y el conrol de flujo. De qué lineas puentear hablaremos en el apartado siguiente.

{% include image.html size="big" file="puente-1-6-4.png" caption="" %}

{% include image.html size="big" file="puente-7-8.png" caption="" %}

## Handshake y control de flujo

Habréis notado que he puenteado tres lineas por un lado, y dos por otro. En principio no hace falta, porque las aplicaciones que vamos a usar van destinadas a un microcontrolador, no esperan encontrarse un módem. Sin embargo no viene mal un poco del culturilla sobre cómo funcionaba antaño un puerto serie.

Vamos a describir las líneas más importantes que son las que aparecen en un conector DB9, después os contaré cómo es la secuencia para conectar telefónicamente un módem con otro y entenderéis perfectamente qué es lo que el ordenador entiende cuando puenteamos juntas las lineas. Uso un módem porque el propósito original del puerto serie era conectar un módem. Aunque más adelante resultaba idóneo para conectar el ratón no se inventó para eso sino que fue una utilidad posterior.

1. **Data Carrier Detect (DCD)**: Indica que se ha establecido una conexión con el destino, y que estamos preparados para recibir y enviarle datos. Tenemos una portadora. Si la conexión se pierde, por ejemplo el destinatario de la llamada colgara el teléfono, nuestro módem pone inmediatamente a 0 la linea DCD y así el PC entiende que se ha perdido la conexión.
1. **Receive Data (RxD)**: Sirve para que el PC reciba los datos que le envía el módem.
1. **Transmit Data (TxD)**: Sirve para que el PC transmita datos al módem o al dispositivo que esté conectado.
1. **Data Terminal Ready (DTR)**: Cuando iniciamos un programa que va a hacer uso de un aparato conectado al puerto serie, el PC activa la línea DTR preguntando al dispositivo si está listo.
1. Masa. Observad que no existe ninguna línea de alimentación positiva y los circuitos que quisieran alimentarse por el puerto serie (lo cual sólo es posible si consumían poco) debían hacerlo por la línea DTR, lo que es muy poco fiable.
1. **Data Set Ready (DSR)**: Esta línea sirve para que el hardware que hay conectado al puerto indique al PC que está conectado, encendido y listo para usarse.
1. **Request to Send (RTS)**: Como los módems antiguos eran torpes, el PC tenía que avisar antes de enviarles datos, porque si los enviaba antes de que el módem estuviera listo para recibirlos se perdían. Así cuando el PC quiere enviar datos pone a 1 esta línea y espera la confirmación por la siguiente.
1. **Clear to Send (CTS)**: Podríamos traducirlo por *vía libre para enviar* Cuando el módem tiene buffers libres para recibir nuevos datos activa esta línea. O al menos esa era la idea original. Porque con el tiempo la misión de las líneas RTS y CTS cambió ligeramente y pasaron a emplearse de otra manera.
1. **Ring Indicator (RI)**: Si el módem recibe una llamada entrante lo indica al PC poniendo a 1 esta línea. El PC genera una interrupción que recibe el sistema operativo y ejecuta lo que tenga que hacer para aceptar una conexión entrante.

Resumiendo:

- Iniciamos el programa terminal en el PC para marcar un número de teléfono y conectarnos con otro PC. El PC activa la línea **DTR**, y el módem, que está conectado y listo reacciona activando **DSR**.
- El PC quiere enviar los comandos de inicialización y conexión (por lo general comandos Hayes: descolgar y marcar un número) así que activa **RTS** y espera. Como no hay ningún problema para recibir los datos, el módem activa **CTS** y comienza la transmisión del comando.
- El módem descuelga, marca el número de teléfono y espera respuesta. Cuando el otro extremo contesta hay una negociación de velocidades (o no) y nos envía una portadora de datos en señal de que la conexión está operativa. En ese momento se activa la línea **DCD**. Pudiera pasar que al otro extremo de la línea no haya otro módem sino una persona de carne y hueso. En ese caso no se activaría la línea **DCD**.
- Ahora ya hay conexión, se ha completado la primera fase (lo que se llama el **handshake**) y lo que se usa a partir de ahora son las líneas **RTS** y **CTS** (control de flujo por hardware).
- Supongamos que el otro extremo cuelga: la linea **DCD** se va a 0 lógico y nuestro programa terminal nos avisa de que se ha terminado la conexión ([NO CARRIER](http://en.wikipedia.org/wiki/NO_CARRIER) ).
- Y supongamos ahora que los que queremos colgar somos nosotros: damos la orden de terminar la conexión nuestro y en ese momento nuestro PC lleva a cero la línea **DTR**, indicando al módem un mensaje, algo como "ya no estoy listo". El módem lo entiende e interrumpe la llamada.

Entonces ¿qué conseguimos puenteando las líneas 1, 4 y 6 (DCD, DTR y DST)? Pues **falsear el handshake**, de forma que en cuanto el PC esté preparado, le llegue la señal de que el hardware también está preparado y conectado.

El puente entre las líneas 7 y 8 (RTS y CTS) **falsea el control de flujo** por hardware. De forma que en cuanto el PC envíe la señal de que quiere enviar datos, le llegue por el puente que hemos hecho la señal de que el dispositivo también está listo para recibirlos.

¿Os habéis fijado en que el módem en cualquier momento puede pedir al PC que no le mande más datos (llevando a cero CTS) pero el PC no puede decirle que haga una pausa? Esto es así porque no tendría sentido que el PC pidiera al módem que haga una pausa si el otro extremo le sigue enviando datos. Para eso está el **control de flujo por software**, que es una forma de decirle al sistema remoto que estamos saturados y que no envíe nada más hasta nueva orden.

Para otras aplicaciones sí tiene sentido que tanto el PC como el aparato puedan decirse mutuamente que están preparados o no para recibir datos. Para ese caso os decía arriba que la misión de RTS y CTS ha cambiado un poco. Lo que se hace es dejar CTS para lo que estaba, indicarle al PC si el dispositivo conectado puede o no recibir datos en ese momento; y hacer que RTS sea lo mismo pero para el PC, indicándole al aparato si el PC está o no listo para recibir en ese momento.
