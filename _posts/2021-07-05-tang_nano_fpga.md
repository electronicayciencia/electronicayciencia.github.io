---
title: Primeras experiencias con Sipeed Tang Nano
layout: post
assets: /assets/2021/07/tang_nano_fpga/
image: /assets/2021/07/tang_nano_fpga/img/featured.png
featured: false
description: Revisamos la placa de desarrollo FPGA Tang Nano con GW1N-1. Primeros circuitos en Verilog y errores de principiante.
tags:
  - Binario
  - Circuitos
  - Informática
---

¿Sabes cómo diseñan, prueban y depuran esos modernos chips con **millones de transistores**? En realidad se programan. ¿Te suena *infraestructura como código*? Pues en los 80 ya se habían inventado los lenguajes de descripción de hardware (*transistores como código*). En este artículo te quiero contar mis primeras experiencias con la placa de desarrollo **FPGA** más **sencilla** a la venta: **Tang Nano**.

Tenía ganas de probar una FPGA. Sí, tal vez para ti representan un amargo recuerdo de oscuras prácticas en alguna asignatura ya superada; con la que **aún sueñas** a veces. Pero yo sólo las conocía de oídas. 

{% include image.html file="tang-nano.png" caption="Sipeed Tang Nano FPGA Board Powered by GW1N-1 FPGA. [seeedstudio.com](https://www.seeedstudio.com/Sipeed-Tang-Nano-FPGA-board-powered-by-GW1N-1-FPGA-p-4304.html)" %}

## Introducción

Las FPGA son los chips más **inútiles** que vas a encontrar. No *sirven* para nada. Un **microcontrolador** al menos interpreta instrucciones; y tiene cierto hardware, interactúa con otros componentes. Lo programas -digamos- para leer un sensor por I2C y enviar el resultado cada cinco segundos por puerto serie a una UART. Es sencillo. Una FPGA no *tiene* I2C, ni UART, ni temporizadores, ni mucho menos interpreta un programa.

Sin embargo, son también unos chips tremendamente **versátiles**. Con ellos puedes implementar **cualquier circuito digital**. Como por ejemplo... una UART, un bus I2C. Todos los temporizadores que necesites. Incluso una CPU entera... o varias, si te caben. 

A diferencia de otros chips, las FPGA no tienen un propósito. Son como una protoboard. De hecho, su nicho principal está en prototipado (ASIC), actividades de alta velocidad (aceleración por hardware) y proyectos con muchas entradas y salidas (procesamiento paralelo). 

Pocas son las ventajas que ofrece una FPGA -para un aficionado- frente a un microcontrolador. No obstante, son muy interesantes si te gusta el diseño digital.

Se venden placas de demostración con la FPGA de turno junto a displays LED 7 segmentos, pulsadores, interruptores y toda clase de clavijas: puerto VGA, HDMI, USB, Ethernet, jacks, etc. Algunas cuentan con su propio manual de prácticas. Valen entre 70 y 150€. Dependiendo del hardware de la placa y las especificaciones del chip. 

{% include image.html file="altera_bundle.png" caption="Placa de desarrollo FPGA, programador JTAG y cables. Piswords Store - AliExpress" %}

Puedes encontrar modelos antiguos más baratos. Igualmente válidos pero incompatibles con la última versión de las herramientas, por ejemplo. Los fabricantes más conocidos son Intel, Xilinx o Lattice.

## Tang Nano

Es una placa de desarrollo súper básica. Su factor de forma recuerda a un DIP ancho de 40 pines. Se programa por USB, algo poco común. Es compatible con protoboard. Y ahora cuesta unos **6 dólares** (el año pasado menos de 5).

Cuenta con:

- FPGA GW1N-1 de *Gowin Semiconductor*.
- Chip CH552 haciendo de conversor JTAG-USB
- Oscilador de cuarzo a 24MHz (en realidad es para el CH552 pero también está conectado a una entrada de la FPGA así que puedes usarlo como reloj externo).
- Un LED tricolor, dos pulsadores y conector display VGA estándar de 40 patillas.

La especificación completa aquí: [Sipeed Tang Nano FPGA Board Powered by GW1N-1 FPGA](https://www.seeedstudio.com/Sipeed-Tang-Nano-FPGA-board-powered-by-GW1N-1-FPGA-p-4304.html).

{% include image.html file="Tang_Nano_detalle.jpg" caption="Detalle de la FPGA GW1N-1. EyC." %}

*GOWIN Semiconductor* es un fabricante chino poco conocido en el mercado occidental. Por suerte, la documentación y el software están disponibles en inglés. No tengo experiencia con otras marcas y no puedo decirte si este chip es mejor o peor que otros. Lo más notable es el encapsulado. Hasta ahora era raro encontrar FPGA de sólo 48 pines y menos aún en un paquete QFN.

El **modelo GW1N-1**, el más sencillo de la familia GW1N. Y esta es la más básica de la **gama LittleBee®**. Chips compactos, de poco consumo y bajo coste especialmente pensados para dispositivos portátiles. Dispone de 1152 LUTs, 864 FlipFlops, PLL, oscilador interno y memoria flash. No tiene, por ejemplo, capacidad DSP ni le cabe un *softcore*. [Familia LittleBee® - Gowin Semiconductor ](https://www.gowinsemi.com/en/product/detail/2/).

{% include image.html file="tabla-familia-gw1n.png" caption="Familia LittleBee®. [Gowin Semiconductor ](https://www.gowinsemi.com/en/product/detail/2/)" %}

La toolchain de Gowin se puede descargar desde su página web. Pesa algo más de **150Mb** (250Mb la versión con Synplify Pro, pero no te va hacer falta). Es un IDE muy simple con el software de síntesis, programador y algunos accesorios. La suite es gratuita aunque requiere **licencia**. 

Para ahorrarte el trámite de solicitarla, Sipeed Studio proporciona un servidor flotante de licencias. Aquí hay instrucciones detalladas: [Tang Nano Getting Started - install the ide](http://tangnano.sipeed.com/en/get_started/install-the-ide.html). Básicamente consiste en configurar la siguiente IP cuando el programa lo solicite:

```
For Gowin ide: 45.33.107.56 in the pop-up box, IDE port: 10559.
For Synplify Pro: setx LM_LICENSE_FILE 27020@45.33.107.56
```

## Cómo funcionan

Yo tenía entendido que las FPGA tenían montones de puertas lógicas OR y AND y tú las combinabas haciendo el circuito que quisieras. Resulta que no. Dichos dispositivos existían, efectivamente, pero se llamaban PLA: [Programmable logic array](https://en.wikipedia.org/wiki/Programmable_logic_array).

{% include image.html file="pla.png" caption="Programmable logic array. Wikipedia." %}

Las FPGA siguen otro esquema diferente. Se componen de bloques lógicos universales y bloques de enrutado universales.

Un bloque lógico universal -**CLB** (Configurable Logic Block) o Gowin las llama CFU (*Configurable Function Unit*)- puede emular cualquier elemento digital. Dentro hay un **FlipFlop**, una puerta lógica universal (**LUT**), una pequeña **ALU** y un multiplexor (**mux**). Tú decides qué función le asignas en tu circuito.

{% include image.html file="FPGA_cell_example.png" caption="Representación simplificada de un Bloque Lógico Universal. (LUT – Lookup table, FA – Full adder, DFF – D-type flip-flop). [Wikipedia](https://en.wikipedia.org/wiki/Field-programmable_gate_array)." %}

- La **puerta lógica universal** te sirve para hacer circuitos **combinacionales**. Te permite emular puertas de hasta 4 entradas -ahora veremos cómo-.
- El **Flip Flop** permite crear circuitos **secuenciales**. Lo puedes configurar asíncrono o síncrono. Con Set y Reset, con detección de flanco de subida o de bajada, etc.
- La **ALU de un bit** más acarreo puede sumar, restar, incrementar, decrementar o multiplicar, o comparar dos números. Es útil para hacer contadores, operaciones aritméticas y comparaciones.
- Con el **multiplexor** puedes seleccionar flujos diferentes en función de una condición. Es un *if*.

También tienen unos bloques configurables de entrada/salida (**IOB**). Se puede seleccionar el nivel de tensión, histéresis, tipo de señal (si es diferencial, por ejemplo)...

Todo interconectado mediante interruptores programables. Así decidimos qué se conecta con qué:

{% include image.html file="fpga_routing.png" caption="Enrutado FPGA (Configurable **Routing** Unit). [Wikipedia](https://en.wikipedia.org/wiki/Logic_block)." %}

Al final es como una **protoboard digital**, con sus conexiones de entrada/salida, sus cables (rutas) internos, y miles de componentes lógicos para usarlos a tu criterio.

Te puede sonar raro el concepto de *puerta lógica universal* pero es de lo más simple. Al final una puerta lógica de 2 entradas tiene 4 posibilidades, una de 3 tiene 8 posibilidades y así. Sólo hay que decirle qué salida queremos en cada estado. Y eso lo hacemos con un vector de 4, 8, 16 bits o los que sean según las posibilidades de entrada. 

El circuito mira el vector y sabe qué salida corresponde en función del valor de las entradas. Por eso se llaman *Look-Up Table* o LUT. Las hay de 1 entrada, 2, 4... y luego se pueden encadenar y combinar entre sí.

{% include image.html file="lut2_truth_table.png" caption="Gowin Configurable Function Unit (CFU). GoWin UG288." %}

Por ejemplo instanciamos esta puerta, la primera entrada (número 0) va al cable **a**, la segunda va al **b** y la salida al cable **o**. El vector de inicialización es 8h.

```verilog
LUT2 my_gate (
    .F(o),
    .I0(a),
    .I1(b) 
);
defparam my_gate.INIT=4'h8;
```

En binario, 8 se escribe `1000`. La salida valdrá 1 sólo cuando **I0** e **I1** ambas sean 1. Es decir, eso es una puerta **AND**. Cambiando el vector a `1110` haríamos una **OR**. Y **XOR** sería `0110`.

Este proceso de bajo nivel, donde vamos poniendo de qué tipo es cada puerta se llama **gate level**. 

Se puede diseñar un circuito a base de poner transistores o puertas lógicas individuales, pero lo normal es irnos a un nivel un poco más abstracto, **register-transfer level**.


## Configurar la FPGA

Los micros se *programan*, las FPGA se *configuran*. Este proceso tiene dos fases principalmente.

Lo primero es describir la interacción entre los componentes. Se usan Lenguajes de Descripción de Hardware (HDL). Los más importantes y los que todas las *toolchains* soportan son **VHDL** y **Verilog**. Yo miré ejemplos de uno, ejemplos del otro y me quedé con el que mejor entendí de primeras: Verilog.

Escribes la lógica, dónde va a haber datos (*register*) y las conexiones que mueven esos datos (*register transfer*). Un compilador interpreta lo que quieres decir y deduce las puertas, flip-flops, etc. necesarios para implementar tu lógica (*gate level*).

La traducción del *register transfer level* a *gate level* se llama **síntesis**.

Después le dices por qué patilla **física** del chip entra cada señal o sale. También puedes ubicar **físicamente** los bloques dentro del chip. Por ejemplo si los quieres contiguos para alguna operación crítica en tiempos. Eso son las *physical constraints*. 

Esta fase -más física- se llama **place & route**. Tras ella se genera el *bitstream*. Ese es el fichero que luego enviaremos al dispositivo.

{% include image.html file="Synthesis_gowin.jpg" caption="Fases del proceso de diseño. Gowin semiconductor." %}

Entre tanto puedes simularlo y depurarlo. El IDE de Gowin no incorpora simulador ni *debugger*. Pero trae una librería de componentes que puedes importar y compilar en un simulador externo, tipo **Multisim**.

Verilog en sí no es complicado. Los circuitos digitales sí lo son. Puedes aprender las *keywords* y las estructuras principales de Verilog en pocas horas. Pero necesitarás mucho más tiempo hasta poder hacer algo que funcione tal como lo habías pensado.

Hay muchos manuales y videos describiendo los **primeros pasos**:

- [First Steps with the Tang Nano FPGA Development Board - bananatronics.org](https://www.bananatronics.org/first-steps-with-the-tang-nano-fpga-development-board/)
- [Tang Nano User - xess.com](https://xess.com/tang_nano_user/docs/_site/)
- [EXAMPLE Lighting tutorial - sipeed.com](http://tangnano.sipeed.com/en/examples/1_led.html)

Déjame hablarte de los ***segundos pasos***.


## El circuito más sencillo

Te presento un circuito ideal para familiarizarte con las herramientas, fases del desarrollo y el poco hardware que tiene la Tang Nano. El circuito más sencillo de todos: **un cable**.

Tenemos dos botones y un led tricolor. Pues vamos a conectar con un cable uno de los botones a uno de los LEDs.

En Verilog, lo expresamos así:

```verilog 
module led (input btn, output led);

    assign led = btn;

endmodule
```

> **btn** es una entrada, **led** es una salida. El valor de la salida es igual al de la entrada. 

Con esas instrucciones, la fase de **síntesis** generará el siguiente "circuito":

{% include image.html file="esq_wire.png" caption="El *circuito* más sencillo de todos. EyC" %}

En la fase *place & route* debemos asociar **btn** y **led** a patillas físicas. Eso se hace con la herramienta *floor planner*. 

A continuación una plantilla para que veas las conexiones más claramente. Abajo están los pulsadores y los led. Ignora los pines con el signo de advertencia, es porque tienen doble función, no le des importancia por ahora.

{% include image.html file="floor-planner-editado.svg" caption="Plantilla para facilitar la fase de *place&route*. EyC" %}

El botón **A** está conectado a la patilla **15**, y el botón **B** a la **14**. Por lo tanto, si quieres que al pulsar el botón A se encienda el led rojo, **btn** será la patilla 15 y **led** será la 18.


## Un circuito combinacional

Tu primer circuito seguramente sea uno combinacional. Además, aunque el ejemplo anterior funciona correctamente, lleva a engaño. Porque los pulsadores cierran a masa. Es decir, que cuando los pulsas están poniendo un **0 lógico**, no un 1. El LED, por otra parte, va conectado a positivo. O sea que está **invertido** y luce cuando hay un 0 lógico.

Este ejemplo te ayudará a **separar** el estado interno del valor en entrada/salida. Haremos una **puerta lógica XOR**.

El LED, que normalmente está apagado, se debe encender al pulsar un botón o el otro; pero volverse a apagar si pulsamos ambos. Dicha operación es un XOR y se representa por '^'.

```verilog 
module led (input btn_a, btn_b,
            output led_r);

    assign led_r = btn_a ^ btn_b;

endmodule
```

Sin embargo, no funciona. Por lo que hemos explicado antes: los pulsadores y el LED están invertidos. Hay que invertir los valores si queremos que funcione como una puerta XOR normal.

Diferenciar entre **entradas/salidas** y **variables** de estado siempre facilita la lectura. Asignaremos el prefijo **i_** a las entradas y **o_** a las salidas. En este ejemplo el valor de **btn_a** (estado) es justamente el opuesto a **i_btn_a** (entrada).

```verilog 
module led (input i_btn_a, i_btn_b,
            output o_led_r);

    assign btn_a = ~i_btn_a;
    assign btn_b = ~i_btn_b;

    assign led_r = btn_a ^ btn_b;

    assign o_led_r = ~led_r;

endmodule
```

La síntesis habrá generado este esquema que ya sí funciona como esperamos.

{% include image.html file="esq_led_xor.png" caption="Esquema del circuito anterior: LED XOR. EyC" %}

Bueno, no es del todo cierto. Ese esquema no es el de verdad. La síntesis hace ciertas optimizaciones. Aquí ha jugado con los inversores. Se los ha quitado y ha inferido directamente una puerta **XNOR**, que funcionalmente es lo mismo. Por eso a veces se dice que *los inversores son gratis* en una FPGA.

La síntesis *interpreta* el código en Verilog y deduce el esquema. Es común seguir ciertos patrones; de lo contrario fallará, o -peor aún- generará esquemas realmente enrevesados.

En cuanto al **orden** de las asignaciones, **da igual**. Son cables. Habrá los mismos cables ya los pongas más arriba o más abajo en el código.

Otra prueba, un poco menos simple:

- Cuando se pulse el **botón A**, encender sólo el LED **rojo**.
- Cuando se pulse el **botón B**, encender sólo el LED **verde**.
- Cuando **ambos** botones están pulsados, encender sólo el LED **azul**

Si eres programador habrás pensado en una condición *if*:

```c
if (btn_a and not btn_b)
    led_r = 1
    led_g = 0
    led_b = 0
else if (btn_b and not btn_a)
...
```

Te pasará mucho sobre todo al principio. Aquí no hay *ifs*. No hay una CPU que tome un camino u otro en función de si una variable es verdadera o falsa. Aunque la evaluación `btn_a and not btn_b` sigue siendo igual: `led_r = btn_a & ~btn_b`.

```verilog 
module led (input i_btn_a, i_btn_b,
            output o_led_r, o_led_g, o_led_b);

    // Buttons and LED are negative logic
    assign btn_a = ~i_btn_a;
    assign btn_b = ~i_btn_b;
    
    assign o_led_r = ~led_r;
    assign o_led_g = ~led_g;
    assign o_led_b = ~led_b;

    // Behaviour
    assign led_r = btn_a & ~btn_b;
    assign led_g = ~btn_a & btn_b;
    assign led_b = btn_a & btn_b;

endmodule
```

Estaríamos construyendo dentro de la FPGA este circuito.

{% include image.html file="esq_led_tricolor.png" caption="Esquema del circuito anterior: LED tricolor con puertas. EyC" %}

Todos los `assign` del código se traducen en cables, se quedan ahí formando parte del circuito. De hecho eso nos lleva a uno de los **problemas** más habituales cuando empiezas.


## Doble driver

Cuando piensas en el típico ejemplo de hacer parpadear un LED, imaginas algo así:

```verilog
wire out;       // defino un pin de salida
assign out = 1; // lo pongo a uno

#100ms          // espero 100ms (mirar cómo se hace un sleep)

assign out = 0; // lo pongo a 0
```

Tu primer impulso es mirar cómo se hace un `sleep` y un bucle. Las respuestas te sorprenden un poco. Es igual, está todo mal.

Cuando indicaste `out = 1` conectaste a **Vcc** el cable llamado **out**. Si luego asignas **out** a **0**, estás conectándolo  también a **Gnd**. ¿Quieres conectar una señal a **Vcc** y a **Gnd** a la vez?

> ERROR (EX2000) : Net 'out' is constantly driven from multiple places.

Los cables (*net*) llevan la señal de una salida (su *driver*) a una o varias entradas. No puedes conectar dos *drivers* al mismo cable porque si tienen valores distintos provocarías un cortocircuito interno.

*Oye, esto es de perogrullo* -me dirás. Sin embargo más adelante estarás tentado de manejar la misma señal desde **dos bloques `always`**. Lo intentarás... y te fallará. Y caerás en la cuenta de que has intentado cortocircuitar las salidas de dos *flips-flops*.


## Un circuito secuencial

Tu siguiente paso será un circuito secuencial. Uno básico. Un pulsador que alterna el estado de un LED. Lo pulsas y se enciende, lo vuelves a pulsar y se apaga.

No se puede hacer sólo con puertas y cables. Necesitas mantener un estado interno, una variable. En Verilog las variables se llaman **registros**, y se implementan por debajo con *flip-flops*.

Un *flip-flop toggle* se construye alimentando la entrada con el valor negado de su propia salida. Así:

{% include image.html file="esq_toggle.png" caption="Esquema del circuito anterior: LED toggle. EyC" %}

En Verilog se describiría del siguiente modo:

```verilog 
module led (input i_btn,
            output o_led);

    reg led = 0;            // variable "led" is a register
    assign o_led = led;     // output "led" matches variable "led"

    always @(negedge i_btn) // on falling edge of the input "btn"
        led <= ~led;        // variable led is inverted

endmodule
```

Ese **always** con *negedge* o *posedge* casi siempre infiere un **Flip Flop** (o varios). Lo que hay tras la arroba se llama *sensitivity list*. De ahí y del contenido se deduce cuál es la línea de reloj, el flanco de activación, el valor inicial, si el reset es síncrono o asíncrono y demás posibilidades.

A diferencia del ejemplo anterior, donde sólo había cables y puertas reaccionando al valor de las entradas, ahora tenemos variables. Memoria, estado interno... llámalo como quieras. Con variables sí tiene sentido asignar valores siguiendo un orden. Aquí entra el operador `<=`. Diremos que `=` es para lógica combinacional; y `<=` para lógica secuencial.

Siguiendo con el ejemplo en el *floor planning* indicamos que **i_btn** es la patilla **15** (botón A). Y eso causará un **warning** en la fase *place and route*.

> WARN  (PR1014) : Generic routing resource will be used to clock signal 'i_btn_d' by the specified constraint. And then it may lead to the excessive delay or skew

Las FPGA tienen rutas especiales de **baja latencia** para las señales de reloj. La síntesis ha detectado que *i_btn* actúa como *clock* del flip-flop. Pero está conectada a una línea normal de I/O. Parte del aprendizaje es saber diferenciar los avisos que puedes ignorar en tu diseño de los que no.

Lo programamos, probamos el circuito y... no. **No funciona**.

Unas veces queda encendido y otras apagado. Parece aleatorio. ¿Es del código? ¿hay algo mal que no ves?

Y de pronto te acuerdas: el **rebote** del pulsador ¡Es eso!

Pues no.

Mira el esquema de la Tang Nano:

{% include image.html file="debounce_buttons.png" caption="Detalle del esquema de Tang Nano donde se aprecia el *debouncer* de los pulsadores. EyC" %}

¿Ves **C30** y **C31**? Son *debouncers*. Cuando presionas, el pulsador cortocircuita su condensador y lo descarga inmediatamente. Cuando lo sueltas se carga lentamente a través de la resistencia.


## Histéresis

El *debouncer* con condensadores es eficaz pero tiene un efecto secundario. Convierte una señal en origen **digital** como es un pulsador, en una señal **continua**: la tensión en los extremos de un condensador. Las FPGA son chips muy rápidos. Les afecta mucho el **ruido**.

Al soltar el pulsador, la tensión en el pin de entrada va subiendo poco a poco. Cuando llega justo a umbral de disparo, el ruido la hace subir y bajar muy rápidamente. Cada vez que el flip-flop detecta un flanco negativo activa o desactiva el LED. Al mismo tiempo, el propio consumo del LED hace caer ligeramente la tensión. **C20** y **C21** no reaccionan suficientemente rápido y las perturbaciones se propagan por **R19** y **R20** hasta la entrada de la FPGA.

{% include image.html file="switch_led_feedback.png" caption="Forma de onda en el pin 15 de la FPGA (CH1) y estado de la salida (CH2). EyC" %}

La realimentación sólo dura unos instantes pero su resultado es impredecible.

Vista la causa, se soluciona fácilmente configurando la **histéresis** de esa entrada.

{% include image.html file="iocst.png" caption="Cuando se trabaja con señales continuas (no discretas) es preciso configurar la *histéresis*. EyC" %}


## Contadores

Ahora en vez de interactuar manualmente, queremos que sea automático. La GW1N tiene oscilador interno, pero usaremos la señal cuadrada de 24MHz dada por el cristal de cuarzo y aplicada en la patilla 35.

Un led que parpadea es el *hello world* en el mundo de los microcontroladores. Si bien aquí no tenemos una función `sleep`, hacer una intermitencia es muy sencillo.

Sólo es un oscilador lento. Para conseguir un oscilador lento a partir de uno rápido basta con **dividirlo**. Si dividimos la señal de 24MHz por 2 son 12MHz; por 4, 6MHz; por 8, 3MHz y así.

{% include image.html file="clock_div.png" caption="División de una señal de reloj para obtener frecuencias menores. EyC" %}

Este ejemplo tan básico es un patrón que vas a ver en multitud de situaciones. Creamos un contador de 32 bits y lo incrementamos en cada ciclo de reloj. 

```verilog
module blink (input i_clk, output o_led);

    reg [31:0] counter = 0;      // always initialize registers
    assign o_led = counter[24];  // output is bit 24

    always @(posedge i_clk)
        counter <= counter + 1;

endmodule
```

La entrada **i_clk** es la frecuencia original, el bit 0 cambiará en cada flanco de subida, o sea dividida por 2. El bit 3 por 4... y así el bit $n$ dividida por $2^{n+1}$.

El circuito resultante será más o menos así:

{% include image.html file="esq_led_blink.png" caption="Esquema del circuito anterior: LED intermitente. EyC" %}

La salida **o_led** es un cable que podemos conectar al bit que queramos. Conectándolo al bit 24 tendremos un parpadeo de 0.7 veces por segundo. Y conectándolo al 23 el doble: 1.4 veces por segundo.

Ya tenemos nuestro LED que parpadea a una frecuencia visible.

Sí, pero... ¿una vez por segundo?

Es parecido. Sólo que esta vez en vez usamos el contador para contar. En lugar de conectar el LED en un bit concreto, vamos evaluando el valor en cada ciclo y cuando alcance un número precalculado invertimos la salida. Y lo reiniciamos a cero.

Si el reloj va a 24MHz, cuando la cuenta alcance 11.999.999 habrán pasado 0.5s (pongamos 12e6 para redondear). En ese momento cambiamos la salida y reiniciamos el contador.

```verilog 
module blink (
    input i_clk,             // clock: 24MHz
    output reg o_led = 0     // this time o_led is a registered output
);

    reg [31:0] counter = 0;

    always @(posedge i_clk) begin
        counter <= counter + 1'b1;

        if (counter == 12e6) begin
            o_led <= ~o_led;  // toggle output
            counter <= 0;     // reset to zero
        end 
    end

endmodule
```

Nos habrá generado un circuito un poco más complejo:

{% include image.html file="esq_led_blink_1s.png" caption="Esquema del circuito anterior: LED intermitente a intervalos de 1 segundo. EyC" %}

Hay dos flip-flop. Uno que se llama **o_led** (porque es una salida de tipo register). Y otro *flip-flop ancho* de 32 bit llamado **counter**. Ambos reaccionan a la misma señal de reloj. En el flanco de subida de **i_clk** tomarán el valor existente en su entrada.

El valor de cada registro se decide en función del estado actual usando unos multiplexores. Para **counter** puede ser el valor actual de *counter* incrementado en 1 unidad, o puede ser 0. Y para **o_led** puede ser el valor actual o su inverso.

Los multiplexores están controlados por el comparador. Así, cuando se detecte el valor esperado en **counter**, se activará su salida y en el siguiente ciclo de reloj **counter** se reiniciará y **o_led** cambiará de estado.

Esta es una descripción alternativa del mismo circuito:

```verilog 
reg [31:0] counter = 0;

assign got_max_count = (counter == 12e6);

always @(posedge i_clk)
    counter <= got_max_count ? 0 : counter + 1'b1;

always @(posedge i_clk)
    o_led <= got_max_count ? ~o_led : o_led;
```

El resultado es idéntico. Pero ahora le hemos puesto nombre al cable que conecta la salida del comparador con los multiplexores: se llama **got_max_count**.

## Dual edge

Un código Verilog sirve para dos cosas: **simulación** o **síntesis**. Si es sólo para simularlo puedes programar lo que te dé la gana: retardos, bucles, etc. Por ejemplo en un *testbench*.

Si es para síntesis la cosa está más restringida. Ya que ese código debe poderse expresar con los componentes físicos disponibles en tu dispositivo. Por ejemplo, un contador que se incremente tanto en el **flanco de subida** como en el de **bajada**:

```verilog
always @(posedge btn_a or negedge btn_a)
    count <= count + 1
```

Es técnicamente correcto, pero no sirve. Porque tu FPGA dispone de flip-flops sensibles al flanco de subida o de bajada, pero **no a ambos**.

> ERROR (EX3534) : Assignment under multiple single edges is not supported for synthesis.

¿Y así? Así ya no da error:

```verilog
always @(posedge (btn_a | ~btn_a))
    count <= count + 1
```

No da error, cierto. ¿Pero sabes lo que va a pasar? Que la síntesis te lo va a optimizar. Una señal o su negada **es siempre *verdadero***. Así que te va a plantar un flip-flip con la señal de reloj puesta fija a **Vcc**.

¿Entonces no se puede? Claro que se puede. Pero sabiendo el circuito apropiado.

{% include image.html file="esq_dual_edge_counter.png" caption="Contador sensible a ambos flancos de la señal. EyC" %}

Aquí tenemos dos contadores, uno sensible al flanco de subida y otro al de bajada (ese inversor en realidad no existe, está por claridad). La entrada de ambos es común y consiste en el valor de salida más uno. La salida va en función del valor del reloj.

En el flanco de subida se activa el contador de arriba, y se actualiza al valor de la salida incrementado. También se activa el *mux* y presenta a la salida el valor de dicho contador. En el flanco de bajada se actualizará el inferior y ese es el valor que se presentará en la salida.

Se consigue con este código:

```verilog 
module dual_edge_counter (
    input i_clk, 
    output [3:0] o_count
);

    wire [3:0] next = o_count + 1'b1;

    reg [3:0] poscnt;
    reg [3:0] negcnt;

    always @(posedge i_clk) poscnt <= next;
    always @(negedge i_clk) negcnt <= next;

    assign o_count = i_clk ? poscnt : negcnt;

endmodule
``` 

**Imagínate el circuito antes de programarlo. Si ni tú mismo sabes qué quieres obtener, es muy posible que el sintetizador tampoco.**


## Patrones habituales

Cuidado con lo que pones en la *sensitivity list*.

Por ejemplo, así tendremos un flip-flop cuya señal de reloj es **i_clk** y cuyo reset síncrono es **i_reset**.

```verilog
always @(posedge i_clk or posedge i_reset) begin
    if (i_reset)
        count <= 0;
    else
        count <= count + 1'b1;
end
```

El bloque se activa en cada flanco de subida de **i_clk** o de **i_reset**. Miramos el valor de **i_reset**. Si está a true es porque habrá llegado un pulso de esa línea y volvemos a cero. Si **i_reset** estaba a cero, lo que habrá activado el bloque habrá sido un pulso de reloj, por tanto incrementamos el contador.

Ahora hacemos un ligero cambio. En vez de comparar **i_reset**, comparamos **i_clk**. Siguiendo el mismo razonamiento. Si **i_clk** es positivo ha sido un pulso de reloj, y si no lo que ha habido es un reset.

```verilog
always @(posedge i_clk or posedge i_reset) begin
    if (i_clk)
        count <= count + 1'b1;
    else
        count <= 0;
end
```

Este segundo código sintetizará algo bastante más enrevesado y difícil de entender. 

Y tú dirás ¡es lo mismo! Pero no, en el primer caso, el contador volverá a cero en cuanto se active **i_reset**. En el segundo sólo lo hará si **i_clk** está abajo cuando se active **i_reset**.

Los casos límite que en programación son indiferentes aquí generan cosas muy distintas.

Por otro lado, la síntesis espera ciertos **patrones**. Cosas que como programador piensas que deberían dar igual, cambian o incluso fallan al sintetizar.

Por ejemplo un condicional dentro de la condición de reset. Esto funciona, aunque el circuito resultante es complicado:

```verilog 
always @(posedge i_clk or posedge reset) begin
    if (reset) begin
        if (something) begin
          ...
```

Si juntas las dos condiciones en una sola línea, ya no sintetiza:

```verilog 
always @(posedge i_clk or posedge reset) begin
    if (reset & something) begin
       ...
```

> ERROR (EX3833) : If-condition does not match any sensitivity list edge

Cuando no sabes qué significa un error, la mejor forma de aprender los patrones comunes es usando ejemplos ya hechos y modificándolos.

Lo que querías hacer probablemente habría sido más fácil escrito así:

```verilog 
wire reset_signal = reset & something;

always @(posedge i_clk or posedge reset_signal) begin
    if (reset_signal) begin
       ...
```

## Siguientes pasos

La placa cuenta con un conector de 40 pines para LCD estándar. Le puedes conectar cualquier pantalla y experimentar con las señales VGA. Aún sin LCD se pueden hacer muchas prácticas sencillas añadiendo un poco de hardware. Como un display LED.

{% include image.html file="Tang_Nano_7seg.jpg" caption="Tang Nano en una protoboard con un display LED de 7 segmentos. EyC" %}

A estas alturas posiblemente necesites un simulador/depurador. El más famoso es **Modelsim**. El IDE de Gowin no lo incluye, pero puedes usar otra versión. En el IDE viene una librería con los componentes del chip y los módulos IP (propietarios) de Gowin, basta compilarla e importarla en el simulador.

Pronto descubrirás los **glitches** de las LUT. No voy a entrar en ello. De momento evita hacer pasar la señal de reloj por puertas lógicas.

Otro experimento sencillo es transmitir **datos serie**. Ya sabes hacer un registro de varios bits, un contador y un temporizador. No te costará nada hacer una UART para transmisión. Por supuesto no tienes que implementarla desde cero si no quieres. Hay módulos de Verilog libres en GitHub. También el propio fabricante facilita un módulo en el IDE, aunque en mi poca experiencia me ha parecido difícil de usar.

{% include image.html file="uart_multiple_logic.png" caption="UART que envía una cadena periódicamente. EyC" %}

A partir de aquí la cosa se complica. ¿Transmitir una cadena en vez de caracteres fijos?

Pues esa cadena puede ser fija y estar en memoria, en cuyo caso necesitarás una **memoria** (que puedes implementar a base de puertas o usar la **BRAM** del chip); y una **máquina de estados** que vaya incrementando la dirección de memoria, se traiga el byte, lo transfiera a la UART, espere, etc.

Pero también puede ser un string variable que venga de otro circuito en la FPGA, un contador, por ejemplo. Con lo cual te encontrarás una parte del circuito generando datos a una velocidad diferente del que los transmite. Empezarán los problemas de **clock domain crossing**, necesitarás instanciar un **buffer FIFO**. Al poco leerás sobre la **metaestabilidad** y los *constraints* de tiempo...

La Tang Nano es una placa FPGA sencilla, pero perfectamente válida. Útil en proyectos pequeños o como complemento. Para profundizar imagino que habrá otras plataformas más adecuadas. Como primera toma de contacto con la que aprender los fundamentos o satisfacer tu curiosidad, a mí me ha convencido.


## Referencias y enlaces 

Para empezar:

- [Sipeed Tang Nano FPGA Board Powered by GW1N-1 FPGA](https://www.seeedstudio.com/Sipeed-Tang-Nano-FPGA-board-powered-by-GW1N-1-FPGA-p-4304.html).
- [Tang Nano Document - speed](http://tangnano.sipeed.com/en/)
- [Tang nano Schematic - sipeed](http://dl.sipeed.com/TANG/Nano/HDK/Tang-NANO-2704(Schematic).pdf)
- [First Steps with the Tang Nano FPGA Development Board - bananatronics.org](https://www.bananatronics.org/first-steps-with-the-tang-nano-fpga-development-board/)
- [Tang Nano User - xess.com](https://xess.com/tang_nano_user/docs/_site/)
- [EEVblog #496 - What Is An FPGA? - YouTube](https://www.youtube.com/watch?v=gUsHwi4M4xE)

Para continuar:

- [Verilog Tutorial for Beginners - chipverify.com](https://www.chipverify.com/verilog/verilog-tutorial)
- [FPGA designs with Verilog - readthedocs.io](https://verilogguide.readthedocs.io/en/latest/index.html)
- [Where FPGAs are fun - fpga4fun.com](https://www.fpga4fun.com/)
- [Canal de Ben Eater - YouTube](https://www.youtube.com/c/BenEater)

Para profundizar:

- [FPGA Prototyping by Verilog Examples - Pong P. Chu - Wiley Online Library](https://onlinelibrary.wiley.com/doi/book/10.1002/9780470374283)
- [LittleBee® - Gowin Semiconductor](https://www.gowinsemi.com/en/product/detail/2/)
- [Documentación del dispositivo (requiere registro) - Gowin Semiconductor](https://www.gowinsemi.com/en/)
  - [DS100, GW1N series of FPGA Products Datasheet]({{page.assets | relative_url}}/DS100-2.4.3E_GW1N series of FPGA Products Data Sheet.pdf)
  - [UG288, Gowin Configurable Function Unit (CFU)]({{page.assets | relative_url}}/UG288-1.09E_Gowin Configurable Function Unit (CFU) User Guide.pdf)
  - [UG289, Gowin Programmable IO (GPIO)]({{page.assets | relative_url}}/UG289-1.7E_Gowin Programmable IO (GPIO) User Guide.pdf)
- [CH552T firmware for enable uart](https://qiita.com/ciniml/items/05ac7fd2515ceed3f88d)

Otros artículos relacionados:

- [Electrónica y Ciencia - Transmisor y receptor digital de ultrasonidos]({{site.baseurl}}{% post_url 2018-03-30-transmisor-y-receptor-digital-de %})
- [Electrónica y Ciencia - Avisador personal de autobús con ESP8266]({{site.baseurl}}{% post_url 2021-01-09-avisador-personal-autobus-con-esp8266 %})
- [Electrónica y Ciencia - Tu primer proyecto con DSP]({{site.baseurl}}{% post_url 2020-06-21-tu-primer-proyecto-con-dsp %})

