---
title: Gráficos VGA con FPGA Tang Nano parte III. Texto.
layout: post
assets: /assets/2023/11/lcd_tang_nano_III_texto
image: /assets/2023/11/lcd_tang_nano_III_texto/img/crash_screen.gif
featured: false
description: Nos acercamos a la historia de la informática mientras diseñamos un controlador gráfico modo texto.
tags:
  - Informática
  - FPGA
  - Circuitos
---

En este **tercer** artículo sobre cómo controlar una pantalla VGA con Verilog explicaremos la forma de mostrar letras y textos.

En el **primer artículo**, [Pantalla LCD con Tang Nano I. Patrones]({{site.baseurl}}{% post_url 2021-11-29-lcd_tang_nano_I_patrones %}), vimos cómo generar las señales de sincronismo, y mostrar algunos patrones simples.

En el **segundo artículo**, [Pantalla LCD con Tang Nano parte II. Imágenes]({{site.baseurl}}{% post_url 2021-12-12-lcd_tang_nano_II_imagenes %}), hicimos que la pantalla proyectara imágenes desde una memoria RAM.

El proyecto completo lo tenéis en [verilog-vga part 3](https://github.com/electronicayciencia/verilog-vga/tree/master/3-text).


## Punto de partida

Antes de meternos de lleno en el artículo, hagamos un *punto de situación*.

Como hardware estamos usando la placa de desarrollo [Tang Nano 1k]({{site.baseurl}}{% post_url 2021-07-05-tang_nano_fpga %}) y una pantalla de 4.3" cuya resolución es de 480x272 píxeles.

La señal de reloj, externa, de 24MHz, la rebajamos hasta 9MHz. Y con ella alimentamos el **contador hsync**. Este lleva la cuenta de los 480 píxeles en cada fila. Cuando se completa una fila, genera un pulso para volver a la izquierda y empezar la siguiente.

Cada pulso de **hsync**, además, incrementa un segundo contador en el módulo  **vsync**. Este cuenta las 272 filas. Cuando se recorren todas, envía una señal que hace volver el barrido a la primera fila.

**hsync** y **vsync** también generan la posición actual *X* e *Y*. En el primer artículo, sabiendo esas coordenadas programamos cómo queremos que esté el pixel. Si encendido, apagado, de un color u otro.

{% include image.html file="h-v-pattern.svg" caption="Estos módulos generan las señales de sincronismo. EyC." %}

Cada patrón de la pantalla estaba configurado por hardware. Había una **operación lógica** que relacionaba X e Y con el color del pixel.

{% include image.html file="pat_gradient.jpg" caption="Esta figura está programada en el hardware y no se puede modificar. EyC." %}

Para proyectar una imagen quitamos ese módulo y los sustituimos por una memoria ROM.

Cada posición de **hsync** o **vsync** entonces corresponde a un bit dentro de la memoria. Si el bit es 1 el pixel se encenderá. Y, si es 0, permanecerá apagado. De esta forma, en la pantalla se proyectará la imagen que hayamos programado en la ROM.

Aquí habíamos encontrado un **problema de sincronización**. Porque los pulsos *vsync*, *de* y *hsync* van directos. Pero el valor del pixel tarda un tic de reloj en salir de la ROM.

Tuvimos que compensar esta demora retrasando también las demás líneas que iban a la pantalla. Así la LCD recibe todas las señales correctas al mismo tiempo.

{% include image.html file="h-v-rom-mono-delay-simplified.svg" caption="Esquema necesario para mostrar una imagen. EyC." %}

La memoria del chip es demasiado pequeña como para contener una imagen completa de la pantalla. Pues esta tiene `480x272 = 130560` píxeles y el chip sólo 65536 bits de memoria. Así que fue buscamos trucos, como hacer los píxeles más grandes para reducir la resolución. Hasta que pudimos meter 4 colores imitando las paletas clásicas de una CGA.

Al final, la única forma de llenar la pantalla sin perder resolución fue componer una imagen a base de repetir **patrones** o texturas.

{% include image.html file="led_counter.gif" caption="Imagen formada por los mismos cuatro patrones repetidos. EyC." %}

Usaremos la misma técnica, más elaborada, para proyectar texto.


## Generador de caracteres

Llamamos *generador de caracteres* al circuito que relaciona qué pixeles encender o apagar para formar cada carácter. Cualquier dispositivo que muestra texto necesita este circuito.

{% include image.html file="vfd.jpg" caption="Una pantalla VFD con caracteres de 5x8. EyC." %}

En su versión más sencilla, un generador de caracteres consiste en una memoria, habitualmente de sólo lectura (ROM), donde se guarda una imagen binaria de cada carácter. En función de cuántos caracteres distintos haya, y de su tamaño, el conjunto requerirá más o menos memoria.

Empezaremos por un tamaño de 8x8.

Elegir un tamaño de carácter **potencia de dos** tiene la ventaja de que podemos direccionarlo directamente usando los buses **X** e **Y**, como luego veremos.

{% include image.html class="small-width" file="char8x8.svg" caption="Un carácter de 8x8 píxeles se verá cuadrado y pixelado, pero ocupará sólo 64 bits. EyC." %}

La pantalla mide 480x272. Cabrán, por tanto, 60x34 caracteres de 8x8.

Ahora hay que decidir cuántos símbolos diferentes tendremos disponibles. Cada símbolo cuenta.

Los primeros ordenadores y terminales antiguos, tal vez lo hayas oído alguna vez, sólo trabajaban con **letras mayúsculas**. En el caso de los mainframes de IBM era porque su arquitectura interna tenía sólo **6 bits**. Eso significa que el bus de datos eran **seis cables**.

Con seis bits tienes disponibles 64 valores diferentes. Piensa en quién usaba los ordenadores y para qué: Los **laboratorios** para hacer cálculos en FORTRAN y las grandes empresas americanas, para contabilidad de proveedores y clientes.

Como mínimo necesitas los números de `0-9`, las letras del inglés de la `A-Z` y el espacio (37 símbolos). Ahora elige entre:
- 26 letras más minúsculas, o
- el ampersand `&`, signos ortográficos ingleses `'".,;:!?()`, operadores `<>+-/*=%` y el dólar `$`.

{% include image.html class="medium-width" file="BCD_1401.png" caption="Juego de caracteres BCD de 6 bits IBM 1401. Los caracteres sombreados varían entre versiones. [Wikipedia](https://en.wikipedia.org/wiki/BCD_(character_encoding))." %}

Por supuesto tampoco caben letras acentuadas, caracteres extranjeros, etc.

Usar 7 bits en vez de 6 habría permitido **128 símbolos**. Pero significaba un cable más en todos los buses de datos. Un bit más en cada carácter escrito en cinta magnética, en cada transmisión serie, en cada dataset. Un incremento del 16% en memoria, tiempo y almacenamiento.

El problema era luego imprimirlos. No hablamos ya de los teletipos, es que las impresoras eran como máquinas de escribir. A tambor o a bola, margarita, etc.

Por eso antes los terminales no soportaban minúsculas.

Y por eso, durante muchos años, cuando Linux detectaba un **nombre de usuario** en mayúsculas asumía que tu terminal no soportaba minúsculas:

{% include image.html file="debian_uppercase.png" caption="CONSOLA DE DEBIAN SARGE. EyC." %}

Como curiosidad, esa característica pasó a ser opcional en 2011 cuando añadieron la opción `-U` a [agetty](https://linux.die.net/man/8/agetty):

> Turn on support for detecting an uppercase only terminal. This setting will detect a login name containing only capitals as indicating an uppercase only terminal and turn on some upper to lower case conversions. Note that this has no support for any unicode characters.


Volviendo a nuestro generador. Vamos a empezar reutilizando los **256 caracteres** de 8x8 que venían en la PC-BIOS de IBM.

{% include image.html file="ibm_8x8_grid.png" caption="Los 256 caracteres OEM 8x8." %}

Los caracteres de la **primera mitad** (los primeros 7 bits) son los 127 símbolos ASCII y son estándar, siempre los mismos.

Los de abajo varían según el *codepage*. Estos son [cp437](https://en.wikipedia.org/wiki/Code_page_437), estadounidense estándar, también llamado *OEM* o *ASCII extendido*.

Los españoles usábamos el [cp850](https://en.wikipedia.org/wiki/Code_page_850). Los siguientes comandos te pueden sonar o no, según la edad que tengas:

    MODE CON CODEPAGE PREPARE=((850) C:\DOS\EGA.CPI)
    MODE CON CODEPAGE SELECT=850

Te preguntarás por qué el código ASCII **sólo usa 7 bits** y no los 8.

Pues porque era 1963 y venían del código Baudot de 5 bits. Siete bits eran más que suficientes para estandarizar los teletipos. Además, las comunicaciones de antes no eran tan fiables como las de ahora. A menudo eran por red cableada y con mucho ruido. No había una capa de transporte y un checksum que pillara los errores al momento. Si un bit llegaba mal no había forma de saberlo.

Para hacerlo más robusto, de cada 8 bits sólo se usaban 7 bits. El octavo se dejaba como **bit de paridad**.

Nosotros usaremos los 8 bits.

El *generador de caracteres* será, pues, un *módulo* con tres variables de entrada:
- El número de carácter. Que debe ser de 8 bits, porque tenemos 256 posibilidades.
- La posición horizontal (X), de 3 bits para cubrir las 8 columnas.
- La posición vertical (Y), de 3 bits también, para las 8 filas.

Y como salida tendrá un bit que indicará si el pixel correspondiente debe estar encendido o apagado.

{% include image.html file="256_chars_8x8.svg" caption="Se necesita un bus de direcciones de 14 bits: 8 para indicar qué carácter y 6 para establecer la posición. EyC." %}

Con lógica discreta se extraerían juntos los 8 bits de una fila. Pero en la FPGA lo implementaremos con una memoria ROM de `256 x 8 x 8` posiciones y 1 bit de datos. 16kb en total.

Para las pruebas, asignaremos el selector de caracteres un **valor fijo** `0x61`, correspondiente al carácter `a`.

{% include image.html file="hardwired_text.svg" caption="Diagrama de bloques del generador de texto 8x8 con un valor fijo. EyC." %}

Esto sería un extracto del código en verilog.

```verilog
// Character generator, monochrome, 8x8 font
wire [7:0] charnum = 8'h61;  // always "a"

wire [2:0] x_char  = x[2:0]; // x position inside char
wire [2:0] y_char  = y[2:0]; // y position inside char

// 256 chars, 8 rows, 8 cols => 8+3+3 = 14 bits
wire [13:0] rom_addr = {charnum, y_char, x_char};

rom_font_1bit rom_font_1bit(
    .ad       (rom_addr), // [13:0] address
    .dout     (pxon),     // output is ON/OFF
    .clk      (LCD_CLK),
    .oce      (true),     // output enable
    .ce       (true),     // chip enable
    .reset    (false)
);

assign LCD_R = {5{pxon}};
assign LCD_G = {6{pxon}};
assign LCD_B = {5{pxon}};
```

Como la salida del generador va conectada directamente a todos los pines de color de la LCD, el pixel se verá blanco o negro.

{% include image.html file="hardwired_text_scr.jpg" caption="Todos los caracteres se ven enteros y bien formados. Vamos por buen camino. EyC." %}



## Celdas de texto

Llamaremos **celda** a una posición en la pantalla donde va un carácter.

Guardaremos qué carácter va en cada celda en la **memoria de vídeo**.

Decíamos antes que en nuestra pantalla hay 60x34 celdas de 8x8, y en cada una de ellas habrá un valor entre 0 y 256, 8 bits.

Esa información la podríamos guardar en sólo `60x34x8 = 16320` bits. Pero es más sencillo tratar filas y columnas por separado. Diremos que necesitamos 6 bits para las 60 filas y otros 6 bits para las 34 columnas. Es un desperdicio de memoria, sí, pero ya habrá tiempo de optimizar.

{% include image.html file="cells_pantalla.png" caption="Se necesitan 6 bits para las 60 filas y otros 6 bits para las 34 columnas. EyC." %}

La memoria de vídeo requerirá por tanto de `64*64*8 = 32kb`. Eso es 2 bancos de 16kb.

Los buses de *X* e *Y* eran de 9 bits. Habíamos usado los 3 bits menos significativos para posicionar el **pixel** dentro del carácter. Ahora usaremos los 6 restantes para seleccionar en qué **celda** estamos.

{% include image.html file="text_8x8_nodelay.svg" caption="Diagrama de bloques del generador de texto 8x8 a partir de una ROM. EyC." %}

Incorporamos el nuevo módulo al esquema. Lo alimentamos con las salidas de los bloques *X* e *Y* y su salida irá al generador de caracteres.

```verilog
wire [7:0]  charnum;

wire [5:0]  x_cell     = x[8:3];
wire [5:0]  y_cell     = y[8:3];
wire [11:0] video_addr = {y_cell, x_cell};

videorom_mono_64x64 videorom_mono_64x64(
    .ad    (video_addr), // memory address
    .dout  (charnum),    // output is character number [7:0]
    .clk   (LCD_CLK),
    .oce   (true),       // output enable
    .ce    (true),       // chip enable
    .reset (false)
);
```

Debemos inicializar la ROM con algún texto. Porque de lo contrario no se mostrará ningún mensaje en la pantalla.

Este es el resultado:

{% include image.html file="text_8x8_nodelay.jpg" caption="Hay un problema de sincronización. EyC." %}

Al igual que pasaba con las imágenes y pasa con el generador de caracteres, la ROM de la memoria de video es síncrona. Y, de nuevo, eso significa que tendremos la salida válida **al siguiente tic** de reloj.

Resulta que, para la primera columna de cada celda, al generador de caracteres le estamos pasando el carácter de la celda anterior. Fíjate en este detalle:

{% include image.html file="text_8x8_nodelay_detail.png" caption="La primera columna de cada símbolo es la del símbolo anterior. EyC." %}

La primera columna del guion tiene la parte que le falta a la `y`. La primera columna de los dos puntos es la de la `e` anterior.

Como es el generador de caracteres quien utiliza la salida de la ROM, primero compensamos este retraso en el resto de señales que llegan a él. Es decir, las señales de posición fila/columna dentro del símbolo. De forma que recibiremos la primera columna cuando ya tengamos el símbolo correspondiente a la entrada.

Pondremos un flip-flop para retrasarla un tic de reloj.

```verilog
// Delay a vector 3, 1 clock cycle
module delayvector3_1tic (
    input clk,
    input [2:0] in,
    output reg [2:0] out
);

always @(posedge clk)
    out <= in;

endmodule
```

En lugar de alimentar el generador con las señales **en tiempo**, lo hacemos con su versión retrasada, **delayed**.


```verilog
wire [2:0] x_char = x[2:0];     // x position inside char
wire [2:0] y_char = y[2:0];     // y position inside char
wire [2:0] x_char_delayed;
wire [2:0] y_char_delayed;

delayvector3_1tic delay_xcell(
    .clk  (LCD_CLK),
    .in   (x_char),
    .out  (x_char_delayed)
);

delayvector3_1tic delay_ycell(
    .clk  (LCD_CLK),
    .in   (y_char),
    .out  (y_char_delayed)
);

wire [13:0] rom_addr = {charnum, y_char_delayed, x_char_delayed};
```

Y esto es lo que obtenemos:

{% include image.html file="text_8x8_semidelay.jpg" caption="Aún falla la primera columna. EyC." %}

Es porque ahora la señal del pixel que llega a la LCD lleva dos tics de retraso. Uno debido a la memoria de video y el otro al generador de caracteres. Por tanto es necesario retrasar también el resto de señales que le llegan no uno, sino **dos tics**. Quedando el diseño final de esta manera:

{% include image.html file="text_8x8_delay.svg" caption="Diagrama de bloques del generador de texto 8x8 a partir de una ROM, con el delay corregido. EyC." %}

Ahora el texto se ve correctamente.

{% include image.html file="text_8x8_delay.jpg" caption="Texto de muestra a 8x8. Monty Python and the Holy Grail." %}


## Memoria de video o framebuffer

Al igual que pasaba antes con la letra `a`, mostrar un texto fijo sirve para saber que vamos bien, pero no es práctico.

Debemos sustituir la memoria de video ROM por una RAM. Aquí es donde antes las cosas se volvían caras. Una ROM se puede sustituir por un circuito estático, pero la RAM era muy costosa. Para hacerte una idea, la CGA, el primer adaptador de vídeo a color en el 1981, tenía 16 kilobytes de RAM. En esta FPGA sólo tenemos 8 kilobytes de memoria entre RAM y ROM.

Una RAM normal, además, tiene un pin para decir si vas a escribir datos o a leer. De forma que solo podrías modificar el contenido cuando no se esté leyendo. Es decir, la CPU o quien sea que genere la imagen o el texto debe actuar entre un refresco de la pantalla y el siguiente. Así es como se hacía antes. Después de todo, las CPUs eran tan lentas que el refresco de la pantalla ocupaba buena parte del tiempo de CPU.

Nosotros vamos a usar una **RAM de doble puerto**. Tiene dos canales separados, uno para escribir, y otro para leer. Y ambos se pueden usar a la vez. Puedes poner a un circuito a leer y refrescar continuamente la pantalla, mientras otro escribe y actualiza el contenido.

Para ilustrar esta parte del artículo, he escrito un módulo llamado `demo`. Simplemente escribe la misma frase repetida una y otra vez de forma secuencial. El propio módulo lleva el control de la fila/columna y se encarga de escribir el carácter en la posición de memoria adecuada.

```verilog
// Demo module. Write into character buffer.
demo demo (
    .i_clk      (vsync_timed),
    .o_address  (vram_addr),   // video address to write [11:0]
    .o_data     (vram_data),   // character to write [7:0]
    .o_we       (printable)    // printable character
    .i_ena      (true),        // enable module
);
```

Conectaremos el canal de escritura **A** al módulo *demo*. Mientras por el puerto **B** el generador de caracteres lee contenido y lo proyecta en la pantalla.

```verilog
// Character buffer, mono, 64x64
charbuf_mono_64x64 charbuf_mono_64x64(
    // A port: write <- demo module
    .ada       (vram_addr),  //input [11:0] A address
    .din       (vram_data),  //input [7:0]  Data in
    .clka      (LCD_CLK),    //input clock for A port
    .cea       (printable),  //input clock enable for A
    .reseta    (false),      //input reset for A

    // B port: read -> character ROM
    .adb       (video_addr), //input [11:0] B address
    .dout      (charnum),    //output [7:0] Data out
    .clkb      (LCD_CLK),    //input clock for B port
    .ceb       (true),       //input clock enable for B
    .resetb    (false),      //input reset for B

    // Global
    .oce       (true)        //input Output Clock Enable (not used in bypass mode)
);
```

El texto se mostrará a medida que se va escribiendo.

{% include video.html file="shinning8x8.mp4" caption="Sin tele y sin cerveza Homer pierde la cabeza. EyC." %}


## Caracteres estilizados

Decíamos que los caracteres de 8x8 pixeles se ven cuadrados y feos. Es mejor usar caracteres de 8x16. Es decir, 8 pixeles de ancho igualmente, pero 16 de altura. Lo malo es que, al ser el doble altos, ocupan el doble de memoria.

Apenas cambia la electrónica al pasar de 8x8 a 8x16 porque sigue siendo potencia de 2.

Utilizaremos la fuente clásica de VGA 8x16.

{% include image.html file="vga8_8x16_grid.png" caption="Los caracteres de 8x16 son el doble de grandes, pero se leen mejor." %}

Esta fuente, pero con las celdas separadas horizontalmente un pixel (haciendo ancho 9 en vez de 8), son los caracteres que asociamos a la época del MS-DOS y el ASCII art.

Así como la ROM de caracteres aumenta, la **memoria de video** disminuye. Porque en la pantalla sólo caben la mitad de filas. De 60x34 pasan a 60x17.

{% include image.html file="text_8x16.svg" caption="El cambio solo afecta a la resolución vertical pasando un bit de la memoria de video al generador de caracteres. EyC." %}

Los cambios son mínimos y el resultado es más agradable de leer.

{% include image.html file="text_mono_8x16.jpg" caption="Texto de muestra a 8x16. Miguel de Cervantes." %}

Al haber reducido la memoria de video, pasando de 2 bancos de 16kb a sólo uno, nos quedan 16kb libres.

- Dos bancos (32kb) los tenemos ocupados con la **ROM** de caracteres: `8 x 16 x 256 x 1 = 32kb`
- El tercero con el ***framebuffer***: `64 x 32 x 8 = 16kb`
- El cuarto, de igual tamaño, está **libre** aún.

Lo vamos a usar para **colorear** al texto.


## Colores de 8 bits

Hay muchas posibilidades de asignar colores a 8 bits. En serio, muchas: [List of 8-bit computer hardware graphics](https://en.wikipedia.org/wiki/List_of_8-bit_computer_hardware_graphics).

Imitaremos la paleta clásica de la CGA ([Color Graphics Adapter](https://en.wikipedia.org/wiki/Color_Graphics_Adapter)). Que por retrocompatibilidad se heredó hasta la VGA. Y con la que seguramente estemos más familiarizados.

De los 8 bits, 4 son para el **color de primer plano** y 4 para el **color de fondo**.

De esos cuatro bits, tres controlarán cada uno de los tres colores básicos. Y el cuarto será una señal extra que añade luminosidad (blanco) cuando se activa.

Lo que este bit hacía en realidad era aumentar el voltaje en todos los cañones del rojo, verde y azul. Así que tenemos los mismos 8 colores, dos veces. Unos más oscuros y otros más brillantes.

Num  |   iRGB    |              Color                      |  Hex RGB
----:|:---------:|:---------------------------------------:|:---------:
  0  | `0 0 0 0` | <span style="color:#000000;">███</span> | `00 00 00`
  1  | `0 0 0 1` | <span style="color:#0000aa;">███</span> | `00 00 aa`
  2  | `0 0 1 0` | <span style="color:#00aa00;">███</span> | `00 aa 00`
  3  | `0 0 1 1` | <span style="color:#00aaaa;">███</span> | `00 aa aa`
  4  | `0 1 0 0` | <span style="color:#aa0000;">███</span> | `aa 00 00`
  5  | `0 1 0 1` | <span style="color:#aa00aa;">███</span> | `aa 00 aa`
  6  | `0 1 1 0` | <span style="color:#aaaa00;">███</span> | `aa aa 00`
  7  | `0 1 1 1` | <span style="color:#aaaaaa;">███</span> | `aa aa aa`
  8  | `1 0 0 0` | <span style="color:#555555;">███</span> | `55 55 55`
  9  | `1 0 0 1` | <span style="color:#5555ff;">███</span> | `55 55 ff`
 10  | `1 0 1 0` | <span style="color:#55ff55;">███</span> | `55 ff 55`
 11  | `1 0 1 1` | <span style="color:#55ffff;">███</span> | `55 ff ff`
 12  | `1 1 0 0` | <span style="color:#ff5555;">███</span> | `ff 55 55`
 13  | `1 1 0 1` | <span style="color:#ff55ff;">███</span> | `ff 55 ff`
 14  | `1 1 1 0` | <span style="color:#ffff55;">███</span> | `ff ff 55`
 15  | `1 1 1 1` | <span style="color:#ffffff;">███</span> | `ff ff ff`


El bit del *verde* no enciende el verde al 100% (`ff`) sino sólo a **dos tercios** (`aa`). Lo mismo para el rojo y el azul. El bit *i* añade un tercio a **todos** los colores. Suma `55` a todos. Los iluminados se pondrán al 100% y los apagados se pondrán al 33%.

Lo de los **dos tercios** es una regla que intenta imitar la tonalidad de los monitores IRGB. Se hace así por convenio ([The IBM 5153's True CGA Palette and Color Output](https://int10h.org/blog/2022/06/ibm-5153-color-true-cga-palette/)) aunque no sea del todo fiel.

Para dotar de color a nuestro texto debemos a duplicar el tamaño del *framebuffer*. Ya que ahora, en lugar de guardar 8 bits guardaremos 16: 8 para el carácter y 8 para el color.

Esos 8 bits extra los llevamos a un nuevo módulo que llamamos **color**. Este módulo lo intercalamos entre el generador de caracteres y la LCD. Así cuando el pixel esté encendido no se iluminará en blanco, sino que lo hará en función del atributo de color.

{% include image.html file="text_8x16_color.svg" caption="Diagrama de bloques del generador de texto 8x16 a color. EyC." %}

El funcionamiento del módulo es muy simple. Asignamos a las líneas *IRGB* a los 4 bits **menos significativos** del byte de color (color de primer plano) si el pixel está encendido. Y a los 4 más significativos (color de fondo) si estuviera apagado.

Como no tenemos un monitor iRGB sino una pantalla RGB565 (ver [Pantalla LCD con Tang Nano I. Patrones]({{site.baseurl}}{% post_url 2021-11-29-lcd_tang_nano_I_patrones %})) hay que hacer la conversión.

```verilog
module color (
    input  [7:0] i_attr,   // Color attribute.
    input        i_fg,     // foreground color or background color
    output [4:0] o_red,
    output [5:0] o_green,
    output [4:0] o_blue
);

assign {i,r,g,b} = i_fg ? i_attr[3:0] : i_attr[7:4];

assign o_red   = { r, i, r, i, r };
assign o_green = { g, i, g, i, g, i };
assign o_blue  = { b, i, b, i, b };

endmodule
```

Hacemos una sencilla prueba para ver qué tal funciona:

{% include image.html class="medium-width" file="text_color_nodelay.jpg" caption="Nada sale nunca bien a la primera. EyC." %}

Los caracteres parecen desplazados hacia la derecha. En realidad es el color de fondo quien está desplazado hacia la izquierda.

El generador de **caracteres** y el generador de **color** reciben su entrada al mismo tiempo desde la memoria de vídeo. Uno recibe el símbolo y el otro el atributo de color.

Pero el primero es **síncrono** (pasa por una memoria ROM) mientras que el segundo es **combinacional** (no tiene retardo). Por eso el módulo *color* está generando el color cuando en su entrada aún está presente el último pixel del carácter anterior.

Se puede solucionar de varias formas:

- Registrando la salida del módulo *color*. Lo convertimos en **síncrono** y así tarda un tic de reloj, al igual que el generador de caracteres. Esta es la opción más robusta. Tener un módulo asíncrono cuando todo lo demás es síncrono suele dar problemas a la larga.
- Usando en el *framebuffer* **dos posiciones** de 8 bits en lugar de una de 16. Así leemos primero el carácter y luego el color, en vez de ambos números al mismo tiempo. Esta opción es la más realista, porque en la implementación serían dos bytes separados y no 16 bits juntos.
- Otra opción es, como las veces anteriores, colocar **un retardo** de un tic de reloj en el bus que alimenta el generador de color para que reciba el byte un tic más tarde. Esta es la que más me gusta.

Ahora sí:

{% include image.html file="full_color_text_8x16.jpg" caption="Texto de muestra a 8x16 en color de 8 bits. EyC." %}


## La excepción marrón

Fíjate en el color 6, ese **amarillo oscuro** verduzco. ¿Es feo, verdad? A nadie le gustaba.

Ya desde los primeros monitores CGA, había un circuito especialmente dedicado a cambiar ese color. Esto es parte del esquema de un monitor IBM. He coloreado las líneas IRGB para que las puedas seguir más fácilmente.

{% include image.html file="yellow2brown_sch.png" caption="Sección del esquema de un monitor IBM modelo 5153. [wiki.console5.com](https://wiki.console5.com/tw/images/e/ea/IBM-Color-Display-%285153%29-Composite-Schematic.png)." %}

Fíjate en el transistor **Q206**. Cuando conduce, conecta a masa la señal del **verde** por medio de la resistencia **R252**, reduciéndola.

Aquí tienes un esquema simplificado:

{% include image.html class="large-width" file="yellow2brown.png" caption="Esquema simplificado. [www.worldphaco.com](https://www.worldphaco.com/uploads/FITTING_AN_EGA_CARD_TO_AN_IBM_5155.pdf)." %}

Observa cómo los inversores alimentan la base de **Q206**. El transistor sólo conducirá si todos ellos están en nivel alto. Y esto sólo ocurrirá para la entrada `IRGB = 0110`, o sea el **color 6**.

Reduciendo la potencia de la señal verde, ese amarillo verdoso se torna más como naranja oscuro o marrón. De este modo obtenemos la paleta canónica VGA.

{% include image.html file="vga_canonica.png" caption="Paleta VGA con el marrón. [int10h.org](https://int10h.org/blog/2022/06/ibm-5153-color-true-cga-palette/)." %}

Modificaremos nuestro módulo color para tener en cuenta esta excepción. Cuando el color sea 6, reduciremos el verde de `0xAA` a `0x55`.

```verilog
assign o_red   = { r, i, r, i, r };
assign o_blue  = { b, i, b, i, b };

// Brown exception: reduce green from AA to 55 if the color is 6
assign o_green = {i,r,g,b} != 4'b0110 ? { g, i, g, i, g, i } : 5'b010101;
```


## Texto parpadeante

*Sabes que estás en el Infierno del diseño cuando ves texto parpadeante*, decía Eric S. Raymond en [El infierno HTML](https://www.ibiblio.org/pub/Linux/docs/LuCaS/Otros/html-hell-es.html) ([The HTML Hell Page](http://www.catb.org/~esr/html-hell.html)).

Es de los **años 90**, cuando la gente se hacía sus páginas web a mano (o con editores *WYSIWYG* como Netscape Composer o Frontpage). Páginas con mucha personalidad pero con muy poco estilo. GIFs animados, colores estridentes y, por supuesto, texto parpadeante.

Pero el texto parpadeante no era algo nuevo...

Tener un tono de color más brillante es útil para el primer plano. Permite resaltar el texto como si estuviese en negrita. Pero para el fondo, no. Los caracteres sobre fondo brillante se leen peor. Así que decidieron que el bit *i* no iba a servir para hacer brillar más el fondo.

En su lugar, este bit activaría un circuito cuya misión es cambiar el color de primer plano por el del fondo de manera periódica. Es decir, **texto intermitente**.

Con el objetivo de imitar ese comportamiento, introducimos dos nuevas entradas en nuestro módulo color.

Añadimos una opción de **blink enable** para seleccionar si queremos el parpadeo, o el fondo brillante. En las tarjetas CGA esto también se podía seleccionar modificando registros en el hardware.

Añadimos también la **blinking line**. Un bit que se pondrá a 0 y 1 periódicamente. Esta línea viene de dividir por 16 la frecuencia de refresco vertical.

{% include image.html file="text_8x16_colorblink.svg" caption="Diagrama de bloques del generador de texto 8x16 a color y parpadeante. EyC." %}

Y nuestro resultado final es este:

{% include video.html file="crash_screen.mp4" caption="Si no recuerdas así tu pantalla, es porque no cacharreaste lo suficiente. EyC." %}


## Conclusión

A lo largo de estos tres artículos hemos explorado cómo manejar una pantalla con una FPGA muy sencilla. Y cómo surgen varios modos en función de las **limitaciones**. Limitaciones, por otra parte, sólo de memoria. Porque apenas hemos usado un 7% de los demás recursos.

{% include image.html class="medium-width" file="resource_usage.png" caption="Salvo la memoria, el resto de recursos están sin usar. EyC." %}

Hemos conseguido proyectar texto a color con toda la resolución que da la pantalla. Renunciando, eso sí, a manejar píxeles individuales. Tal vez ahora comprendas mejor porqué las tarjetas gráficas tenían varios **modos de texto** y **modos gráficos**.

Hoy, en cualquier móvil o smartwatch, tenemos infinidad de *fuentes*; de ancho fijo, variable, caligráficas, en negrita, cursiva, con todos los caracteres hasta en chino, a todo color y del tamaño que quieras. Imagínate la complejidad y las **capas de abstracción** que hacen falta hasta llegar ahí.

Lo de ir poniendo **retardos** para que todas las señales lleguen a la vez no lo voy a desarrollar, pero te prometo que es una técnica importantísima. Al final, para la LCD, *parece* como si todo ocurriera en un ciclo de reloj. Fijar las coordenadas, leer de la RAM de video, pasar por la ROM de caracteres, todo el mismo ciclo. Abajo te dejo algún enlace si tienes curiosidad.


## Enlaces para profundizar

Proyecto en Github:

- [GitHub electronicayciencia/verilog-vga](https://github.com/electronicayciencia/verilog-vga)

Sobre FPGA

- [Electrónica y Ciencia - Primeras experiencias con Sipeed Tang Nano]({{site.baseurl}}{% post_url 2021-07-05-tang_nano_fpga %})
- [Electrónica y Ciencia - Pantalla LCD con Tang Nano I. Patrones]({{site.baseurl}}{% post_url 2021-11-29-lcd_tang_nano_I_patrones %})
- [Electrónica y Ciencia - Pantalla LCD con Tang Nano parte II. Imágenes]({{site.baseurl}}{% post_url 2021-12-12-lcd_tang_nano_II_imagenes %})

- [Project F - FPGA Development: Graphics](https://projectf.io/tags/graphics/)
- [The Why and How of Pipelining in FPGAs](https://www.allaboutcircuits.com/technical-articles/why-how-pipelining-in-fpga/)
- [Strategies for pipelining logic](https://zipcpu.com/blog/2017/08/14/strategies-for-pipelining.html)

Caracteres y tipografías

- [BCD (character encoding)](https://en.wikipedia.org/wiki/BCD_(character_encoding))
- [The Oldschool PC Font Resource](https://int10h.org/oldschool-pc-fonts/fontlist/?1#top)
- [vga text mode fonts](https://github.com/viler-int10h/vga-text-mode-fonts)

Colores

- [List of 8-bit computer hardware graphics](https://en.wikipedia.org/wiki/List_of_8-bit_computer_hardware_graphics).
- [The IBM 5153's True CGA Palette and Color Output](https://int10h.org/blog/2022/06/ibm-5153-color-true-cga-palette/)
- [FITTING AN EGA CARD TO AN IBM 5155](https://www.worldphaco.com/uploads/FITTING_AN_EGA_CARD_TO_AN_IBM_5155.pdf)
- [Screen Attributes](http://www.techhelpmanual.com/87-screen_attributes.html)
- [Brown color is weird](https://www.youtube.com/watch?v=wh4aWZRtTwU)

Varios

- [The TTY demystified](https://www.linusakesson.net/programming/tty/)
