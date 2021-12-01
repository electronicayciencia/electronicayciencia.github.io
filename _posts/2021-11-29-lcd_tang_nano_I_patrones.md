---
title: Pantalla LCD con Tang Nano I. Patrones
layout: post
assets: /assets/2021/11/lcd_tang_nano_I_patrones/
image: /assets/2021/11/lcd_tang_nano_I_patrones/img/pat_gradient.jpg
featured: false
description: Cómo gobernar una pantalla LCD con una FPGA Tang Nano. Generar las señales de tiempo y mostrar patrones preconfigurados.
tags:
  - Circuitos
  - Informática
  - FPGA
---

¿Sabes cómo enviar imágenes a una pantalla? En este artículo vamos a explorar cómo gobernar un display LCD TFT a bajo nivel. Veremos cómo son las señales de control. Diseñaremos la lógica para generarlas en una FPGA [Tang Nano][Electrónica y Ciencia - Primeras experiencias con Sipeed Tang Nano] y mostraremos algunos patrones preconfigurados.

¿Conoces los vídeos de [Ben Eater - The world’s worst video card?] Yo quería probarlo pero no tengo paciencia para comprar los chips, preparar los cables, montar el circuito y todo eso. En su lugar usaré la Tang Nano. Una placa de desarrollo FPGA minimalista, muy sencilla y programable por USB. Precisamente viene preparada con un conector para LCD VGA estándar de 40 pines. Ya hablé de ella en [Electrónica y Ciencia - Primeras experiencias con Sipeed Tang Nano].

{% include image.html file="tang_nano.png" caption="Placa de desarrollo FPGA Tang Nano. Se aprecia el conector VGA de 40 patillas. Sipeed Studio." %}

## El conector de 40 patillas

Esta es mi pantalla:

{% include image.html class="medium-width" file="lcd_tft_4.3_480x272.jpg" caption="Pantalla LCD TFT 4.3 480x272. Aliexpress." %}

Tiene 4.3", una resolución de 480x272 píxeles y un conector estándar VGA de 40 pines que encaja con el de la placa.

{% include image.html file="40pin.svg" caption="Descripción del patillaje del conector VGA. EyC." %}

De esos 40, sólo los siguientes van a ser importantes para nosotros y los que vamos a usar a lo largo de este artículo:

- Las 8 señales para los colores Rojo, Verde y Azul, **R**, **G** y **B**.
- La señal de reloj **CLK**.
- Las señales de sincronismo vertical y horizontal **VSYNC** y **HSYNC**.
- La señal de *Data Enable* **DE**.

Fíjate que los colores tienen los bits menos significativos unidos entre sí. En principio la pantalla soportaría 8 bits por cada color. Es decir una profundidad de 24 bits. *Color Verdadero* o "16 millones de colores".

Pero esta FPGA viene en un encapsulado QFN48, o sea que sólo tiene 48 patillas. No merece la pena dedicar la mitad de ellas a los colores. Por esta razón han decidido **unir varios** entre sí y dejarlo en `5 + 6 + 5 = 16` bits de color.

Lo de `5+6+5` no es arbitrario, es la manera estándar de expresar una profundidad de **color de 16 bits**. *Color de Alta Densidad*, lo llaman. Permitiría 65k colores distintos.

Muchos programas de edición soportan el modo de color de 16 bit con esta misma representación. Por ejemplo GIMP.

{% include image.html file="gimp_565.png" caption="Diálogo de exportación a BMP en GIMP. Soporta la codificación RGB565. EyC." %}

Imitando a los antiguos tubos de rayos catódicos, la pantalla LCD se recorre de izquierda a derecha línea por línea y de arriba a abajo. Empezando por la esquina superior izquierda y terminando en la esquina inferior derecha.

La señal de reloj **LCD_CLK** digamos que avanza un pixel hacia la derecha. La señal **HSYNC** marca el comienzo de la línea (reinicia el cursor a la izquierda de la pantalla). Y **VSYNC** marca el comienzo de un nuevo *frame* (reinicia el barrido vertical arriba del todo). 


## Señales de sincronismo

Los pulsos de sincronía llevan un margen antes y después. Se llaman *Front Porch* y *Back Porch*. Antiguamente era el tiempo que necesitaban los circuitos para posicionar el haz de electrones, ahora... se siguen usando pero son mucho más breves.

Para **HSYNC**, el tiempo se mide en pulsos de reloj (señal **LCD_CLK**).

El datasheet de la pantalla te dirá cuáles son los tiempos mínimos y máximos para los *porchs*. Así como cuánto debe durar el propio pulso de sincronía. Por ejemplo para HSYNC:

Description               | Min | Typ | Max | Unit
-------------------------:|----:|----:|----:|----:
Horizontal display period | 480 | 480 | 480 | CLK
Horizontal front porch    | 2   | 2   | 82  | CLK
Horizontal pulse width    | 2   | 41  | 41  | CLK
Horizontal back porch     | 2   | 2   | 41  | CLK

Como ves, quitando el periodo horizontal (que coincide con el número de píxeles), el resto de tiempos no son críticos. Lo mismo da 2 que 40. A diferencia de los monitores CRT, que requerían unos parámetros exactos, las pantallas LCD son mucho más flexibles.

El datasheet también indicará la polaridad del pulso. En mi caso es un pulso negativo. Es decir que la señal HSYNC será normalmente positiva, salvo durante el pulso que tomará valor cero. 

{% include image.html file="hsync_ena.svg" caption="Diagrama de las señales HSYNC y DE. El LCD responde al flanco de bajada del reloj. EyC." %} 

Cada línea incluye un de *front porch* que dura 2 tics de reloj, 41 de sincronía, otros 2 de *back porch* más los 480 para los 480 píxeles horizontales. En total son **525 pulsos de reloj**.

La señal **Data Enable** (DE) sirve para indicar cuándo damos por terminado el *porch* y comenzamos a mandar datos útiles.

El **refresco vertical** tiene la misma forma que el horizontal. Con la diferencia de que el tiempo ya no se mide en tics de reloj sino en líneas horizontales (H).

El datasheet indica los márgenes y la duración recomendada de la señal de refresco:

Description             | Min | Typ | Max | Unit
-----------------------:|----:|----:|----:|----:
Vertical display period | 272 | 272 | 272 | H
Vertical front porch    |   1 |   2 | 227 | H
Vertical pulse width    |   1 |  10 |  11 | H
Vertical back porch     |   1 |   2 |  11 | H

Tendrá esta forma:

{% include image.html file="vsync_logic.svg" caption="Señales de sincronismo vistas en el analizador lógico. EyC." %}

En total son `272 + 2 + 10 + 2 = 286` líneas. Cada línea tardaba 525 pulsos de reloj. Lo que hace un total de  `286 x 525 = 150150` pulsos para la pantalla completa (un *frame*).

Para conseguir un refresco de **60Hz** (60 *frames* por segundo), nuestra señal de reloj debería tener una frecuencia de `60Hz * 150150 = 9MHz`.

Y, de hecho, eso es precisamente lo que recomienda el *datasheet*:

Description             | Min | Typ | Max | Unit
-----------------------:|----:|----:|----:|----:
LCD clock cycle         | -   |   9 |  15 | MHz


La frecuencia máxima de refresco sería de unos 100Hz. En teoría no hay frecuencia mínima. Aunque en la práctica sí.

Al contrario de -por ejemplo- el papel electrónico, el TFT es una tecnología de **matriz activa**. Eso quiere decir que la polarización necesita un refresco periódico. Sin él va perdiendo fuerza y se desactiva. En esta tecnología los píxeles en reposo son transparentes. Por eso un píxel *muerto* no es aquel que no luce, sino uno que no se apaga.


## Esquema general

Este es el esquema que vamos a seguir para generar las señales de control:

{% include image.html file="h-v-modules.svg" caption="Esquema para generar las señales de control. EyC." %}

Usaremos el cuarzo de 24MHz integrado en la placa. Generaremos la frecuencia necesaria con ayuda del PLL que integra la FPGA.

El resto son **dos contadores**, uno horizontal y otro vertical. El horizontal cuenta pulsos de reloj de la LCD. 

El vertical contará líneas horizontales. Y, atención, porque eso es una **mala práctica** que va a traer consecuencias.

***Primero*** porque las líneas de reloj en las FPGA están optimizadas para minimizar los retardos de propagación. Aquí forzamos al chip a usar una línea normal como reloj de ese contador, en lugar de una línea optimizada de baja latencia. Pero como la frecuencia es muy baja no nos afecta.

***Segundo*** porque no va en fase con el reloj principal, mayor o menor siempre habrá un retardo (*clock skew*). No nos afecta tampoco.

Y ***tercero*** -y este sí que nos afecta-, porque la salida de HSYNC podría no ser limpia. Como veremos a continuación.


## Refresco horizontal

Veamos una manera de implementar la señal *HSYNC* en un módulo de **Verilog**. El código completo lo tenéis en [GitHub electronicayciencia/verilog-vga].

La interfaz sería:

- Entrada para la señal de reloj **i_clk**.
- Salidas de un bit para HSYNC y DE **o_hsync** y **o_hde**.
- Salida de 9 bits para la posición horizontal, y así saber en qué parte de la línea nos encontramos. **o_x**.

Como el área activa son 480 pixeles sólo necesitamos 9 bits para la señal **o_x**. Sin embargo para el contador principal, que llega hasta el 525, necesitamos 10 bits.

```verilog
module hsync (
    input i_clk,
    output o_hsync,
    output o_hde,
    output [8:0] o_x
);
```

Definimos los parámetros de la pantalla:

```verilog
localparam hactive      = 480;
localparam hback_porch  = 2;
localparam hsync_len    = 41;
localparam hfront_porch = 2;
```

A continuación el contador principal. Calculamos `maxcount` para saber cuándo tiene que dar la vuelta.

```verilog
localparam maxcount  = hactive + hfront_porch + hsync_len + hback_porch;

reg [9:0] counter = 0;

always @(posedge i_clk) begin
    if (counter == maxcount - 1)
        counter <= 0;
    else
        counter <= counter + 1'b1;
end
```

Aprovechando que las señales son periódicas, en lugar de empezar a contar por el front porch empezaremos a contar por el primer píxel. Así el rango 0 a 479 se corresponderán con la posición horizontal. Y directamente se lo asignamos.

```verilog
assign o_x = counter[8:0];
```

Calculamos cuándo viene el pulso de sincronismo, y ponemos **o_hsync** a nivel bajo:

```verilog
localparam syncstart = hactive + hfront_porch;
localparam syncend   = syncstart + hsync_len;

assign o_hsync = ~(counter >= syncstart & counter < syncend);
```

Por último **o_de** será *true* mientras estemos dentro de los primeros 480 pixeles.

```verilog
assign o_hde = (counter < hactive);
```

Para comprobar que todo va bien le ponemos un reloj lento y miramos el analizador lógico. Todo parece ir bien. Pero cuando vamos a probar la pantalla llenando todo de un color... pasa esto:

{% include image.html file="bad_vsync.jpg" caption="Fallo en el refresco vertical. EyC." %}


## El módulo HSYNC segundo intento

Una mala práctica no tiene por qué dar un resultado incorrecto. Pero sí hace tu diseño más proclive a fallos. Cuando se combinan varias malas prácticas, el resultado es un diseño que no funciona bien.

Lo primero que hicimos mal fue **usar como reloj de un módulo la salida de otro** en vez de usar el reloj principal. Lo cual no es recomendable, pero tampoco necesariamente malo. Lo segundo fue **hacer pasar un reloj por puertas lógicas**.

{% include image.html file="gated_clock.svg" caption="Una salida combinatoria puede pasar por estados transitorios y no debe usarse como reloj. EyC." %}

Como las puertas lógicas, comparadores, etc, no son síncronos su salida tiene *glitches* (estados transitorios). Y dado que actúa como reloj de otro contador, esos glitches cuentan como *tics* y la señal **VSYNC** va más rápido de lo que debería. Se salta líneas y deja media pantalla sin rellenar.

Decíamos antes que la tecnología TFT necesita un refresco periódico o si no los pixeles se **desactivan**. Ya ves cómo la parte de la pantalla que no recibe refresco se termina quedando blanca. 

Ahora, si esto fuera un diseño profesional, o un ejemplo de libro, descartaríamos usar HSYNC como reloj de VSYNC y pasaríamos a manejar ambos contadores con el reloj principal. 

Pero en vez de eso vamos **registrar o_hsync** (declararla como registro y actualizarla de forma síncrona). Así eliminamos los glitches.

{% include image.html file="hsync_reg.svg" caption="Eliminamos los glitches de o_hsync pasando a actualizarla de manera síncrona. EyC." %}


```verilog
always @(posedge i_clk) begin
    if (counter == maxcount - 1)
        counter <= 0;
    else
        counter <= counter + 1'b1;

    o_hsync <= ~(counter >= syncstart & counter < syncend);
end

assign o_x   = counter[8:0];
assign o_hde = (counter < hactive);
```

¡Ahora funciona! Se rellena toda la pantalla.

{% include image.html file="filled_hsync.jpg" caption="Refrescos vertical y horizontal correctos. EyC." %}

La cosa es que **o_hsync** lleva un tick de retraso respecto a **o_x** y a **o_hde**. Porque mientras una se actualiza con cada pulso de reloj, las otras lo hacen inmediatamente. Por tanto la señal de **hsync** está desincronizada.

{% include image.html file="hsync_delay.svg" caption="La señal HSYNC (síncrona) está retrasada respecto a DE (asíncrona). EyC." %}

No supone un problema. Los márgenes laterales en vez de ser 2 y 2 pues son 3 y 1. Incumplimos el tiempo mínimo de *back porch*, que era 2. Aún así el LCD lo tolera bien.

O tal vez sí. En el futuro podría convertirse en un *corner case* difícil de cazar. Mejor **sincronizar** todas las salidas por si acaso.

{% include image.html file="hsync_reg_all.svg" caption="Todas las señales llevan el mismo retraso y están sincronizadas entre sí. EyC." %}

El módulo hsync finalmente quedaría así:

```verilog
module hsync (
    input  i_clk,
    output reg o_hsync,
    output reg o_hde,
    output reg [8:0] o_x
);

localparam hactive      = 480;
localparam hback_porch  = 2;
localparam hsync_len    = 41;
localparam hfront_porch = 2;

localparam maxcount  = hactive + hfront_porch + hsync_len + hback_porch;
localparam syncstart = hactive + hfront_porch;
localparam syncend   = syncstart + hsync_len;

reg [9:0] counter = 0;

always @(posedge i_clk) begin
    if (counter == maxcount - 1)
        counter <= 0;
    else
        counter <= counter + 1'b1;

    o_hsync <= ~(counter >= syncstart & counter < syncend);
    o_x     <= counter[8:0];
    o_hde   <= (counter < hactive);
end

endmodule
```

Esta es la señal de salida:

{% include image.html file="hsync_logic.svg" caption="Todas las señales llevan el mismo retraso y están sincronizadas entre sí. EyC." %}


El módulo **vsync** es como **hsync** pero cambiando los parámetros numéricos. Es, de hecho, tan igual que podríamos simplemente instanciar el mismo hsync con otros parámetros.

```verilog
localparam vactive      = 272;
localparam vback_porch  = 2;
localparam vsync_len    = 10;
localparam vfront_porch = 2;
```


## Frecuencia de reloj con PLL

Nuestra pantalla recomienda usar 9MHz. La generaremos a partir del cuarzo externo de 24MHz.

Usaremos un módulo IP de PLL. IP significa *Intellectual Property*. Son módulos de terceras partes; en este caso nos los provee el fabricante, pero también podríamos haberlo comprarlo. Su contenido suele estar cifrado y para nosotros es una caja negra con unas entradas, unas salidas, unos parámetros y documentación.

Hay módulos *hardware* que sirven para hacer uso de hardware específico dentro del dispositivo. Como este del PLL, RAM, ROM, DSP, etc. Y los hay *software* que sirven para implementar un bloque a partir del hardware disponible. Como una UART, un puerto I2C, hasta una CPU completa.

{% include image.html file="gowinip.png" caption="Colección de módulos IP proporcionados por el fabricante. EyC." %}


Si quieres saber cómo actúa un PLL para generar una frecuencia partiendo de otra, lo tienes en [Electrónica y Ciencia - Sintetizador de frecuencias digital con PLL].

Muy brevemente, es un dispositivo con un oscilador y dos entradas, en una recibe una frecuencia base y la otra actúa de realimentación. Igual que un Operacional ajusta su salida para que en ambas entradas haya la misma tensión, un PLL ajusta el oscilador para que en ambas entradas haya **la misma frecuencia**. 

El PLL de la GW1N tiene varios divisores digitales:

- uno a la **entrada** para dividir la frecuencia proveniente del cristal de cuarzo externo.
- otro en la **realimentación**, cuyo efecto en la práctica es multiplicar la frecuencia de salida del PLL.
- y otro a la **salida** para ajustar la frecuencia final. Este sólo puede ser par.

{% include image.html file="pll9.svg" caption="Configuración del PLL para obtener 9MHz partiendo de 24MHz. EyC." %}

Convertir 24MHz en 9 es multiplicar por 3/8. Es decir, fijamos a 8 el divisor de entrada. Lo cual nos deja en 3MHz. Y luego ponemos a 3 es divisor de realimentación. Después sólo hay que poner 3 en el divisor de realimentación para forzar el PLL a multiplicar por tres la frecuencia de entrada. Con eso obtenemos los 9MHz.

En este caso no ha hecho falta el divisor de salida.

Obtener 10MHz ya no es tan fácil. Una forma sería elevar los 24MHz hasta 100MHz y dividir la salida por 10.

{% include image.html file="pll10.svg" caption="Configuración del PLL para obtener 10MHz partiendo de 24MHz. EyC." %}

No se puede conseguir cualquier frecuencia pero sí nos da bastante flexibilidad.


## Módulo TOP

Vamos a llamar TOP al módulo de más alto nivel donde instanciaremos los demás siguiendo el esquema que habíamos propuesto.

En TOP recibiremos la señal de reloj del cuarzo y de él saldrán las señales para el LCD: los colores, sincronismo, reloj y *Data Enable*.

```verilog
module top (
    input XTAL_IN,       // 24 MHz
    output [4:0] LCD_R,
    output [5:0] LCD_G,
    output [4:0] LCD_B,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output LCD_CLK,
    output LCD_DEN
);
```

Empezamos por el PLL:

```verilog
Gowin_rPLL pll(
    .clkin     (XTAL_IN),      // input clkin 24MHz
    .clkout    (),             // output clkout
    .clkoutd   (LCD_CLK)       // divided output clock
);
```

A continuación el oscilador horizontal. Además definimos un bus para la posición horizontal **x**, y una línea para la señal *enable* horizontal **hde**.

```verilog
wire [8:0] x;
wire hde;

hsync hsync(
    .i_clk     (LCD_CLK),    // counter clock
    .o_hsync   (LCD_HSYNC),  // horizontal sync pulse
    .o_hde     (hde),        // horizontal signal in active zone
    .o_x       (x)           // x pixel position
);
```

Su reloj será el mismo que usa la LCD, LCD_CLK y los pulsos de salida irán directamente a **LCD_HSYNC**.

Seguimos con oscilador vertical cuyo reloj será precisamente LCD_HSYNC.

```verilog
wire [8:0] y;
wire vde;

vsync vsync(
    .i_clk     (LCD_HSYNC),  // counter clock
    .o_vsync   (LCD_VSYNC),  // vertical sync pulse
    .o_vde     (vde),        // vertical signal in active zone
    .o_y       (y)           // y pixel position
);
```

Para crear la señal **LCD_DEN** hacemos un *AND* de **vde** y **hde**.

```verilog
assign LCD_DEN = hde & vde;
```

Asignamos un valor fijo a todos los colores para ver si funciona.

```verilog
assign LCD_R = 5'b00100;
assign LCD_G = 6'b011000;
assign LCD_B = 5'b00100;
```

El resultado debería ser una pantalla con el color elegido. Como antes.


## Patrones

Lo siguiente será dibujar algo, es decir variar el color de un pixel en función de la posición **x** e **y**. 

Se trata de tomar el diseño que ya tenemos y agregarle algo que lea X e Y y fije los colores RGB.

{% include image.html file="h-v-pattern.svg" caption="Configuración del PLL para obtener 10MHz partiendo de 24MHz. EyC." %}

El primer dibujo obligatorio es un marco en el borde de la pantalla. Es obligatorio porque sirve para comprobar que el *timing es correcto*

Primero definimos una señal **pixel iluminado**, llamada **on**. Y le asignaremos un valor alto cuando la coordenada X o la Y adquieran valores extremos.

```verilog
wire on = (x == 0) | (x == 479) | (y == 0) | (y == 271);
```

Simplemente asignamos el bit más significativo de cada pixel a la línea de `on`.

```verilog
assign R = {on, 4'b0};
assign G = {on, 5'b0};
assign B = {on, 4'b0};
```

En la pantalla debe dibujarse un marco blanco. Si no es así, si faltara alguna línea o estuviera desplazada, significaría que algo está mal.

{% include image.html file="pat_edge.jpg" caption="Dibujar un marco en el extremo de la pantalla sirve para descartar problemas de tiempo. EyC." %}

Jugando con la señal de **on** se pueden hacer patrones variados, por ejemplo un **XOR** de las coordenadas resulta en un tablero de ajedrez. 

```verilog
wire on = ~i_x[3] ^ i_y[3];
```

En este caso cada cuadro mide 8x8 pixeles porque lo hacemos con el tercer bit.

{% include image.html file="pat_checkboard.jpg" caption="Patrón en tablero de ajedrez de 8x8. EyC." %}

Para terminar, unas bandas de colores.

El color depende de la coordenada vertical, mientras que la intensidad (los bits de ese color) depende de la horizontal.

```verilog
assign R = x[8:4] & { 5 {y[7]} };
assign G = x[8:3] & { 6 {y[6]} };
assign B = x[8:4] & { 5 {y[5]} };
```

{% include image.html file="pat_gradient.jpg" caption="Patrón en bandas de 3 colores puros y su combinación. EyC." %}


## Conclusión

Hemos visto las señales de control adecuadas para manejar un display LCD. Hemos propuesto una forma de generarlas. Hemos corregido los fallos más habituales. Hemos visto cómo instanciar un módulo IP para PLL. Lo hemos probado mostrando varios patrones previamente configurados en el hardware.

En el próximo artículo veremos cómo hacer aparecer una imagen previamente cargada en la memoria.

Os dejo el código del proyecto en [GitHub electronicayciencia/verilog-vga].


## Enlaces para profundizar

- [GitHub electronicayciencia/verilog-vga]
- [RGB LCD example - Sipeed]
- [Ben Eater - The world’s worst video card?]
- [Gisselquist Technology - Building a video controller: it's just a pair of counters]
- [Electrónica y Ciencia - Primeras experiencias con Sipeed Tang Nano]
- [Electrónica y Ciencia - Sintetizador de frecuencias digital con PLL]





[GitHub electronicayciencia/verilog-vga]: https://github.com/electronicayciencia/verilog-vga
[RGB LCD example - Sipeed]: https://tangnano.sipeed.com/en/examples/2_lcd.html
[Ben Eater - The world’s worst video card?]: https://eater.net/vga 
[Gisselquist Technology - Building a video controller: it's just a pair of counters]:  https://zipcpu.com/blog/2018/11/29/llvga.html
[Electrónica y Ciencia - Primeras experiencias con Sipeed Tang Nano]: {{site.baseurl}}{% post_url 2021-07-05-tang_nano_fpga %}
[Electrónica y Ciencia - Sintetizador de frecuencias digital con PLL]: {{site.baseurl}}{% post_url 2020-09-15-sintetizador-de-frecuencias-digital-con %}


