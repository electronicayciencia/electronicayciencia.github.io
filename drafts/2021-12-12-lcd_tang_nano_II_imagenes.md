---
title: Pantalla LCD con Tang Nano parte II. Imágenes.
layout: post
assets: /assets/2021/12/lcd_tang_nano_II_imagenes/
image: /assets/2021/12/lcd_tang_nano_II_imagenes/img/static.gif
featured: false
description: Ejemplo de controlador VGA para FPGA GW1N con Tang Nano. Mostrar imágenes desde la memoria.
tags:
  - Informática
  - FPGA
---


En el artículo anterior [Pantalla LCD con Tang Nano I. Patrones][Electrónica y Ciencia - Pantalla LCD con Tang Nano I. Patrones]) vimos las señales básicas para controlar una pantalla LCD TFT y cómo mostrar algunos patrones. En este artículo vamos a ver cómo proyectar en la pantalla una imagen contenida en la memoria principal.

La pantalla es de 4.3" con una resolución de 480x272 píxeles.

Partimos del esquema anterior.

[foto: h-v-pattern.svg]

Resumido rápidamente. Tenemos un oscilador externo de 24MHz. Lo hacemos pasar por el **PLL** que integra el chip. Con esta frecuencia *movemos* el contador **H**, con el cual generamos los pulsos de **sincronismo horizontal** y también la coordenada X.

Usamos los pulsos de sincronismo horizontal para mover el segundo contador **V**. Con él generaremos la **señal vertical** y la coordenada Y.

Por último teníamos un circuito lógico que asignaba el valor de cada color en función de las coordenadas X e Y.

Sin embargo, ese último bloque (que en el diagrama se llama *color*) es rígido. Con él no podemos mostrar nada más que lo que está programado. Lo que queremos hacer es sustituirlo por una memoria, en este caso una **memoria ROM**.

De esta forma haremos el circuito más flexible. Pues podremos mostrar imágenes diferentes con el mismo hardware, simplemente variando el contenido de la memoria.

El código lo tenéis en [GitHub electronicayciencia/verilog-vga/2-image]. Se divide en 4 proyectos que iremos viendo a los largo del artículo.

- **Image mono**: Mostrar imágenes de 1 bit (monocromática). Servirá para aprender los conceptos básicos como es el uso de la ROM o reducir la resolución.
- **Mono static**: Mostrar ruido en la pantalla. Cambiamos la ROM por memoria RAM y escribimos bytes aleatorios en el *framebuffer*.
- **Image 4c**: Ampliamos a 2 bits de color e imitamos la paleta gráfica de una antigua tarjeta de video CGA.
- **Led counter**: Generamos una imagen de 16 bits de color utilizando texturas. Haremos un contador LED virtual.


## Memoria y modos gráficos

Como hemos anticipado, vamos a usar la **memoria RAM** interna de la propia FPGA. Primero configurada en modo **solo lectura** por facilidad.

Imagínate la memoria como un contenedor con casillas de información. Pueden ser casillas de 1 bit, de 2 bits, de 32 bits, 64 bits, etc. Eso se llama *data width*, (ancho de datos).

Una memoria ROM paralela es simple de usar: tiene un **bus de direcciones** y un **bus de datos**. En el bus de direcciones se pone dónde está el dato que queremos traer, y este aparece por el bus de datos. Ya está.

[foto: mem16lines.svg]

En la GW1N sólo hay 72kb (kilo**bits**) de memoria RAM/ROM. Se queda **muy corta** a la hora de mostrar imágenes en una pantalla de 4.3" -como veremos luego-.

Además existen otras restricciones:

- Puedes acceder a 65536 de esas casillas. Porque el ancho del bus de direcciones (*address depth*) es 16 bits.
- El ancho máximo de datos es 144 bits. No nos importa porque en este artículo vamos a usar 1, 2 y 16 bits.
- El número máximo de bits (*address depth* por *data width* por no puede ser mayor que 73728).

Para abreviar, de esos 72kb tenemos **64k útiles**.

Hemos dicho que hay 16 líneas de dirección. Así que asignaremos 8 líneas para las filas y otras 8 para las columnas. La idea es poner la coordenada Y en los 8 bits más significativos de la dirección y la coordenada X en los otros 8. Por el bus de salida tendremos un bit, 1 o 0 en función de si el píxel está encendido o apagado.

[foto: mem16lines-lines-cols.svg]

La pantalla es de 480x272 pero con 8 bits sólo podemos manejar hasta 256x256. 

Todo eso para una imagen en blanco o negro (nada de grises, blanco o negro).

Si queremos tener algún color debemos agrupar las casillas y que ya no sean de un bit, sino de dos como mínimo. En cuyo caso ya no habrá 65536 de un bit, sino la mitad, 32768 de 2 bits.

Con la mitad de casillas ya no disponemos de 16 bits en la dirección sino de 15. Luego ya no nos sirve lo de asociar 8 y 8 como antes.

[foto: mem15lines-4c.svg]

Dicho de otra forma, aumentar el número de colores supone reducir alguna de las dimensiones, o sacrificar la resolución. En este modo tendríamos una resolución de 256x128. Pero una salida de 2 bits. O sea **4 colores** distintos.

Si seguimos reduciendo tendríamos los siguientes modos:

  Modo   |Resolución HxV | Pixeles | Color
:-------:|:-------------:|:-------:|:------:
Original |  480 x 272    |  130560 | Memoria insuficiente
    1    |  240 x 256    |   61440 | Monocromo (1 bit)
    2    |  240 x 128    |   30720 | 4 colores (2 bit)
    3    |  120 x 128    |   15360 | 16 colores (4 bit)
    4    |  120 x 64     |    7680 | 256 colores (8 bit)
    5    |   60 x 64     |    3840 | 65536 colores (16 bit)

Como ves, resolución y color vienen limitados por la cantidad de memoria de video disponible. Esos 64kb se quedan **muy cortos** para cualquier modo gráfico. Nuestra pantalla de 480x272 tiene 130560 pixeles y no nos da ni siquiera para representar en memoria la imagen completa en blanco y negro.


## En blanco y negro

Empezamos por el modo 1. Monocromático y con la dimensión horizontal reducida.

El diagrama de bloques sería así. Sustituyendo el bloque que controla los colores por la ROM:

[foto: h-v-rom-mono.svg | Diagrama de bloques monocromático (defectuoso). EyC.]

Tal como habíamos adelantado, los 8 bits menos significativos del bus de direcciones de la ROM corresponden a los 8 bits menos significativos de la coordenada X. Y los siguientes 8 bits hasta completar los 16, corresponden a la Y.

```verilog
wire [15:0] rom_addr;
assign rom_addr = {y[7:0], x[7:0]};
```

A continuación instanciamos la ROM de 64k (usando el código que el asistente da como plantilla). Lógicamente tendrá 16 líneas de dirección y un bit de salida.

```verilog
Gowin_pROM ROM(
    .ad        (rom_addr),   //input [15:0] address
    .dout      (rom_out),    //output [0:0] dout
    .clk       (LCD_CLK),    //input clk
    .oce       (true),       //input oce
    .ce        (true),       //input ce
    .reset     (false)       //input reset
);
```

Puedes encontrar chip ROM síncronas y asíncronas. Pero las memorias de la FPGA son casi todas **síncronas** y por tanto necesitan una señal de reloj. La conectaremos al reloj principal. Aunque eso traerá **consecuencias** más adelante.

Como la ROM sólo tiene un bit de salida, tendremos que conectar a él todos los colores de la pantalla. Cuando este bit valga 1 el pixel aparecerá blanco brillante, u cuando valga 0 estará apagado.

```verilog
assign LCD_R = {5{rom_out}};
assign LCD_G = {6{rom_out}};
assign LCD_B = {5{rom_out}};
```

Lo probaremos con una imagen de pruebas monocromática de 240x256. no es nada más que un texto con un marco alrededor. Tal como dijimos en el artículo anterior con los patrones, el **marco** es importante para comprobar el **timing**.

[foto: test_240x256x1.png | Imagen de prueba monocromática de 240x256 píxeles. EyC.]

He generado un fichero de inicialización para cargar la ROM con un programa Python que también os dejo en GitHub.

Sintetizamos, lo cargamos en la FPGA y el resultado es este:

[foto: mono_doble_bottom_time.jpg | Imagen monocromática defectuosa. EyC.]

No esta mal, se ve la imagen pero tiene **tres defectos**:

- Se ve doble.
- Continúa en la parte de abajo.
- El marco está descuadrado.


## Módulo de retardo

Empecemos por el descuadre. Afecta a todo el lateral izquierdo. Es como si la imagen estuviera desplazada hacia la derecha.

[foto: mono_time_detalle.jpg | La imagen aparece desplazada hacia la derecha. Detalle del margen izquierdo. EyC.]

Se debe a que la memoria ROM es **síncrona**. 

En una ROM asíncrona, pondríamos en el bus de direcciones las coordenadas X e Y y -casi inmediatamente- aparecería el dato en el bus de salida. 

Pero nuestra ROM no funciona así. La dirección sólo surte efecto en el **flanco de subida** del reloj. Es decir, puedes modificar las coordenadas en cualquier momento, pero hasta el siguiente pulso de reloj no se va a enterar.

Una vez entra la dirección, el dato sí está disponible instantes después (este es el modo *bypass*, hay otro modo en el que el dato necesita un segundo pulso de reloj para presentarse en la salida, pero no lo vamos a usar).

[foto: gowin_prom_timing_bypass.png | Diagrama de tiempos para el acceso a la ROM en modo Bypass. GoWin Semiconductor.]

Aún usando el modo *bypass* llevamos **un ciclo de reloj de retraso**. Cuando en la pantalla enviamos la coordenada `fila=0, columna=1` el dato que tenemos disponible no es ese, sino el anterior: `fila=0, columna=0`.

Por esa razón la imagen aparece desplazada hacia la derecha.

Lo podemos solucionar de dos formas, **esperar** o **paralelizar**:

- **Paralelizar** sería pedir a la ROM la posición siguiente vez de la actual. Así, cuando pintemos el próximo píxel, ya tendremos el dato actualizado y correcto.
- **Esperar** es lo más sencillo, consiste en demorar el resto de señales (*hsync*, *vsync*, y *ena*) hasta el próximo ciclo de reloj. Cuando el dato ya esté disponible. Así compensamos el tiempo que tarda la ROM.

Estas dos opciones (esperar o paralelizar) las vamos a encontrar más veces.

Retrasar una señal un ciclo de reloj se consigue haciendo pasar dicha señal por un Flip Flop.

Como hay tres señales que retrasar, construimos un módulo *delay* y lo instanciaremos tres veces:

```verilog
// Delay a signal 1 clock cycle
module delay (
    input clk,
    input in,
    output reg out
);

always @(posedge clk) 
    out <= in;

endmodule
```

Ahora lo interponemos entre las señales que iban directas al LCD:

```verilog
wire hsync_delayed;
wire vsync_delayed;
wire enable_delayed;

delay delay_h(
    .clk  (LCD_CLK),
    .in   (hsync_timed),
    .out  (hsync_delayed)
);

delay delay_v(
    .clk  (LCD_CLK),
    .in   (vsync_timed),
    .out  (vsync_delayed)
);

delay delay_en(
    .clk  (LCD_CLK),
    .in   (enable_timed),
    .out  (enable_delayed)
);

assign LCD_HSYNC = hsync_delayed;
assign LCD_VSYNC = vsync_delayed;
assign LCD_DEN   = enable_delayed;
```

Con esto habremos corregido el retardo, y la imagen comenzará en la columna 0. Como debe ser:

[foto: mono_doble_bottom.jpg | Imagen monocromática de pruebas con timing correcto. EyC.]


## Ajustar la imagen

Como hemos reducido la resolución horizontal hasta dejarla en 240 habrá que **estirar la imagen** para que ocupe toda la pantalla, 480. Eso significa que cada píxel debe ser el doble de ancho. Lo cual, por supuesto, penaliza la relación de aspecto. Pero no tenemos otra opción con tan poca memoria de video.

Para conseguir que cada columna la pinte dos veces **descartamos el bit menos significativo** de la coordenada X. En lugar de componer la posición de la ROM como lo estamos haciendo hasta ahora,

```verilog
assign rom_addr = {y[7:0], x[7:0]};
```

debemos hacerlo así:

```verilog
// Double x pixels 
assign rom_addr = {y[7:0], x[8:1]};
```

Con eso cada columna es el doble de ancha y la imagen ocupa toda la pantalla.

[foto: mono_bottom.jpg | Imagen monocromática de pruebas con la relación de aspecto corregida. EyC.]

El otro defecto que queda se debe a que tenemos 8 bits para las coordenadas. 8 bits es suficiente para la coordenada X, porque hay 240 columnas. Pero al haber 272 filas, cuando llega a la fila 256 se **da la vuelta** y empieza a pintar de nuevo la 0.

Lo evitamos poniendo a 0 todos los píxeles cuya coordenada Y supera 255.

Llamamos **blackout** al octavo bit de Y (`Y[8]`). Mientras tome el valor 0 pintamos en pantalla lo que venga de la ROM. Pero si vale 1 entonces lo ponemos todo a 0.

```verilog
// Black lines when y > 255
assign blackout = y[8];

assign LCD_R = {5{rom_out & ~blackout}};
assign LCD_G = {6{rom_out & ~blackout}};
assign LCD_B = {5{rom_out & ~blackout}};
```

Eso corrige u oculta el defecto.

[foto: mono.jpg | Imagen monocromática de pruebas correcta. EyC.]

Con todos los cambios, nuestro diagrama se ha complicado un poquito. Quedando de esta manera:

[foto: h-v-rom-mono-right.svg | Diagrama de bloques monocromático corregido. EyC.]



## Memoria RAM

Vamos a presentar la memoria RAM partiendo del diseño anterior.

Las capacidades de la memoria (Block Memory) varían entre FPGA. La nuestra tiene estas posibilidades:

- **pROM** (*Read Only Memory*). Sólo lectura. Es la que **hemos usado** hasta ahora.
- **SPB** (*Single Port Block RAM*). Lectura y escritura. Los datos pueden leerse y modificarse. Seleccionamos una operación u otra por medio del bit "WRE (*Write Enable*)". Pero **no se puede leer y escribir** al mismo tiempo.
- **DPB** (*Dual Port Block RAM*). Tiene dos puertos con capacidad de **leer y escribir simultáneamente**.
- **SDPB** (*Semi Dual Port Block RAM*). Tiene dos puertos con capacidad de operar simultáneamente. Pero el puerto **A sólo escribe** y el **puerto B sólo lee**.

Vamos a sustituir la memoria ROM por memoria SDPB. 

Desde el punto de vista del controlador VGA, el **puerto B se comporta igual que la memoria ROM**. Le pasamos una dirección, un reloj, y una línea de salida. Al siguiente pulso de reloj la dirección tomará efecto y tendremos el dato de esa posición en la línea de salida.

Mientras el controlador lee del puerto B, nosotros escribimos datos por el A. 

El puerto A es lo mismo pero la línea de datos esta vez será de entrada.

```verilog
video_ram video_ram(
    //A port: write
    .ada       (mem_a_addr), //input [15:0] A address
    .din       (mem_a_in),   //input [0:0]  Data in
    .clka      (LCD_CLK),    //input clock for A port
    .cea       (BTN_A),      //input clock enable for A
    .reseta    (false),      //input reset for A

    //B port: read
    .adb       (mem_b_addr), //input [15:0] B address
    .dout      (mem_b_out),  //output [0:0] Data out
    .clkb      (LCD_CLK),    //input clock for B port
    .ceb       (true),       //input clock enable for B
    .resetb    (false),      //input reset for B

    //Global
    .oce       (true)        //input Output Clock Enable (not used in bypass mode)
);
```

La conexión hacia la pantalla se hace igual que antes:

```verilog
assign mem_b_addr = {y[7:0], x[8:1]};

assign LCD_R = {5{mem_b_out}};
assign LCD_G = {6{mem_b_out}};
assign LCD_B = {5{mem_b_out}};
```

El diseño es el mismo que en el apartado anterior, pero ahora podemos modificar la imagen.

¿Qué podemos escribir por el puerto A? Por ejemplo **bits aleatorios**.

Voy a crear un módulo llamado `rand_mem` que tiene dos partes. 

- La primera es un **LFSR de 32 bits**. LFSR significa *Linear Beedback Shift Register* y viene a ser un registro de desplazamiento realimentado. Sirve para generar **valores aleatorios**. 
- La otra es un **contador incremental** que barre, de una en una, todas las 65536 posibles posiciones de memoria RAM.

```verilog
module rand_mem(
    input i_clk,      // clock
    output reg [15:0] o_addr = 0, // memory address to write into
    output o_dat      // data to write
);

reg [31:0] l = 32'h1;
assign o_dat = l[31];

always @(posedge i_clk) begin
    o_addr <= o_addr + 1'b1;

    l <= {l[30:0], l[31] ^ l[21] ^ l[1] ^ l[0]};
end

endmodule
```

Lo instanciamos y conectamos al **puerto A** (sólo escritura).

```verilog
// Write random bits to RAM's port A.
rand_mem rand_mem(
    .o_addr    (mem_a_addr),
    .o_dat     (mem_a_in),
    .i_clk     (LCD_CLK)
);
```

El resultado es ruido blanco, *estática*, o nieve:

[foto: static.webp | La nieve es la representación visual del ruido blanco. EyC.]



## Cuatro colores, CGA

Pasemos del modo monocromático al color.

Vamos a reducir la resolución vertical, al igual que hicimos con la horizontal. En vez de 256 la dejaremos en 128. Ya sólo necesitaremos 7 bits para direccionarla.

Lo cual nos dará un bit más para el color.

[foto: mem15lines-4c.svg]

Tener 2 bit de color significa que podemos mostrar 4 colores distintos. Antes sólo había dos posibilidades: pixel encendido o píxel apagado. Pero ahora un píxel puede tomar 4 valores.

Necesitamos un bloque para traducir los valores 0, 1, 2 y 3 a colores (valores en RGB565). Ese bloque irá conectado entre la salida de la ROM y la entrada de la pantalla.

[foto: h-v-rom-cga.svg]

Vamos a imitar la paleta de colores CGA. CGA fue la primera tarjeta gráfica a color que salió para el mercado de ordenadores domésticos, en 1981. 

Tenía dos paletas principales:

En la primera decidieron **eliminar el color azul**. Dejando sólo dos colores básicos (rojo y verde) es fácil mapearlo a las 4 opciones binarias.

Num  |                                     Color      | Rojo | Verde | Azul 
----:|------------------------------------------------|:----:|:-----:|:----:
 0   | <span style="color:#000000;">█</span> Negro    |      |       |      
 1   | <span style="color:#00ff00;">█</span> Verde    |      |   X   |      
 2   | <span style="color:#ff0000;">█</span> Rojo     |   X  |       |      
 3   | <span style="color:#ffff00;">█</span> Amarillo |   X  |   X   |      


Implementamos la lógica. Componemos una imagen de prueba y este es el resultado: 

[foto: 4c_palette0.jpg]

La paleta alternativa de CGA es igual pero **añadiendo azul**.

Num  |                                     Color      | Rojo | Verde | Azul 
----:|------------------------------------------------|:----:|:-----:|:----:
 0   | <span style="color:#000000;">█</span> Negro    |      |       |      
 1   | <span style="color:#00ffff;">█</span> Cian     |      |   X   |  X   
 2   | <span style="color:#ff00ff;">█</span> Magenta  |   X  |       |  X   
 3   | <span style="color:#ffffff;">█</span> Blanco   |   X  |   X   |  X   


En el módulo hemos previsto una entrada con uno de los pulsadores para seleccionar la paleta alternativa. Si lo presionamos, la imagen cambia a:

[foto: 4c_palette1.jpg]


## Color de 16 bits

Se llama **framebuffer** al espacio de memoria que contiene una copia de la imagen, la cual se mapea tal cual bit a bit en la pantalla.

Si quisiéramos hacer en 16 bits de color lo mismo que hemos hecho para 1 bit y 2 bits, tendríamos que rebajar la resolución hasta los 60x64 píxeles.

Afortunadamente, hay medios de componer una imagen alternativos al *framebuffer*: texturas y sprites. De hecho, es lo que se usaba hasta que la memoria RAM se volvió asequible.

Como ejemplo en este apartado vamos a hacer un **contador LED virtual**. Este es el resultado:

[foto: led_counter.gif]

Veamos cómo hacerlo.

Nuestra FPGA tiene 64k distribuidos en 4 bloques de 16k cada uno. Lo cual significa que podemos guardar 4 imágenes distintas de 32x32 a 16 bit de color. `32 x 32 = 1024` y `1024 x 16 = 16k`.

Las dos primeras imágenes serán de un led encendido y apagado:

[foto: leds.png | small]

Cuando quiera que el LED aparezca encendido, utilizaré la ROM donde tengo la imagen con el LED encendido. Si quiero que salga apagado, usaré la otra.

Para las dos imágenes restantes he buscado **texturas enlosables** que sirvan de decoración de fondo. Enlosable, repetible o *tileable* significa que puedes repetirla una al lado de otra y no se nota el corte.

Voy a escoger un par de texturas de, por ejemplo, **Minecraft**. Digamos *Stone Brick* y *Mossy Cobblestone*.

Ahora sólo es cuestión de rellenar la pantalla a base de cuadrados de 32x32.

Lo siguiente es un paso crucial, sobre todo para el artículo siguiente, cuando hablemos del **texto**.

A cada cuadrado de 32x32 le llamaremos una **celda**. Dividiremos las coordenadas X e Y en dos partes. Los 5 bits menos significativos `x[4:0]` o `y[4:0]` señalan posiciones dentro de la celda. Mientras los otros bits `x[8:5]` e `y[8:5]` señalan líneas o columnas completas.

Con la posición **intra-celda** barremos la imagen de 32x32 dentro de memoria ROM. Y con la posición **extra-celda** sabremos cuál de las imágenes corresponde.

```verilog
// work with 32x32 blocks (cells)
// bits 0-4 set the inner cell position, bit 5-8 set the cell number
wire [3:0] x = i_x[8:5];
wire [3:0] y = i_y[8:5];
wire [9:0] rom_addr = {i_y[4:0], i_x[4:0]}; // 32x32=1024
```

Después sólo es cuestión de elegir qué bloque pintamos en función de si es el fondo, fondo alternativo, un led encendido o un led apagado.

```verilog
always @(*) begin

    // leds are in line 3
    if (y == 3 & x >= 1 & x <= 13)
        rgb <= status[13-x] ? rom_on_out : rom_off_out;

    // alternate texture in lines 0,1 and > 4
    else if ( y < 2 | y > 4)
        rgb <= rom_texture1_out;

    // default texture elsewhere
    else
        rgb <= rom_texture0_out;

end
```


Esta técnica se puede extender de varias formas:

- girando o volteando las texturas aparenta más de las que realmente son.
- Si reducimos a 16x16, podemos almacenar cuatro veces más, 16 texturas a 16 bits de color.
- Si aún no hay bastante memoria se puede reducir el número de colores a 8 bit (256 colores) o incluso a 4 bits (16 colores). El **texto**, de hecho, no es más que cuadrados de 8x8 con la imagen monocromática de un símbolo.

La siguiente imagen de Final Fantasy está compuesta por 16 texturas y dos *sprites*. Las texturas son de 16x16 a 16 colores (1024 bits).

[foto: ff_tile.png]


## Conclusión

En este artículo hemos visto como proyectar imágenes en una pantalla LCD. 

Teniendo en cuenta las limitaciones de memoria hemos determinado los modos gráficos disponibles.

Hemos aprendido a usar un bloque IP BRAM en modo ROM, lo hemos inicializado con una imagen de prueba monocromática y la hemos mostrado por pantalla. Hemos corregido los defectos reduciendo la resolución, retrasando otras señales y ocultando partes de la imagen.

Después hemos aprendido a usar un módulo IP BRAM en modo *Semi Dual Port*. Hemos rellenado la memoria con bits aleatorios para proyectar ruido blanco.

Hemos imitado una tarjeta gráfica CGA mostrando una imagen en 4 colores, con dos paletas gráficas.

Para componer una imagen a color de 16 bits hemos rellenado la pantalla usando 4 texturas de 32x32. Aplicándolo a un contador LED virtual.

En el próximo artículo, veremos técnicas para mostrar texto.

## Enlaces para profundizar







[Electrónica y Ciencia - Pantalla LCD con Tang Nano I. Patrones]({{site.baseurl}}{% post_url 2021-11-29-lcd_tang_nano_I_patrones %})
[The 8-Bit Guy - CGA Graphics - Not as bad as you thought!]: https://www.youtube.com/watch?v=niKblgZupOc

[GitHub electronicayciencia/verilog-vga]: https://github.com/electronicayciencia/verilog-vga
[GitHub electronicayciencia/verilog-vga/2-image]: https://github.com/electronicayciencia/verilog-vga/tree/master/2-image



