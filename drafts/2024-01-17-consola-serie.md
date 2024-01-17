---
title: Mi propia consola serie y el terminal de Unix
layout: post
assets: /assets/2024/01/consola-serie
image: /assets/2024/01/consola-serie/img/screen_mc.jpg
featured: true
description: Hablaremos de la interfaz de terminal de Unix usando mi propia consola serie. Sistemas, historia y seguridad.
tags:
  - Informática
  - FPGA
  - Linux
---

PuTTY es un *emulador de terminal*. Un programa que *se comporta como* lo hacía en su día una consola serie. Yo me he hecho una. Y te invito a asomarte al pasado conmigo para ver de primera mano cómo era.

Primero te explicaré **mi montaje**. Cuál es el hardware que he utilizado para crearme una consola serie desde cero y cuál es el sistema al que me voy a conectar.

Luego veremos qué es un *teletipo de cristal*. Hablaremos de la disciplina de línea y, si te gusta la **seguridad informática**, hay un par de apartados para ti.

Finalmente nos saldremos del kernel para ir al espacio de usuario. Allí dotaremos a nuestra consola de más **capacidades** hasta conseguir un terminal funcional.


## La consola serie

Para hacer la consola he usado una placa de desarrollo **Tang Nano**. Esta placa cuenta con una FPGA muy sencilla, conector de 40 pines para una pantalla VGA, un LED de tres colores y dos pulsadores. Si te interesa échale un ojo a [Primeras experiencias con Sipeed Tang Nano]({{site.baseurl}}{% post_url 2021-07-05-tang_nano_fpga %}).

{% include image.html file="montaje_front.jpg" caption="Montaje con la Raspberry y el terminal. EyC." %}

Me he decidido por una FPGA y no por un microcontrolador para tener más control nivel de hardware. Quiero saber exactamente lo que hace sin que haya librerías o capas intermedias. Además así puedo hacer que se comporte de forma no estándar a ver qué pasa.

No voy a explicar el proyecto con detalle. Tan sólo te daré unas pinceladas para que puedas seguir el artículo. El código *verilog* completo está en GitHub: [verilog-vga/4-serterm](https://github.com/electronicayciencia/verilog-vga/tree/master/4-serterm).

{% include image.html file="montaje_back.jpg" caption="Circuitos del terminal. Placa Tang Nano y CH9350L. EyC." %}

La pantalla, de 4.3 pulgadas, tiene una resolución de 480x272 pixeles; lo cual me da **60 columnas y 17 líneas** en caracteres de 8x16.

Para el teclado, tengo que usar uno USB. Un teclado USB se puede manejar desde la FPGA, pero es más simple usar un pequeño conversor basado en el chip CH9350L *USB-to-UART*.

{% include image.html file="CH9350L_board.png" caption="Conversor de teclado / ratón USB a señales serie. EyC." %}

Este chip se encarga de controlar el teclado USB por un lado, y por el otro tiene una interfaz serie. Cuando detecta que pulsamos o soltamos  teclas nos envía una secuencia indicando las teclas pulsadas y si había o no algún modificador activo.

Las teclas físicas, los botones de un teclado USB están numerados. Cuando pulsemos la tecla `A`, el chip CH9350L nos hará llegar el código `04`. La `B` será el `05`, la tecla *return* es el `28` o la *barra espaciadora* el `2C`. El listado completo lo tenéis en [HID Usage Tables for Universal Serial Bus (USB)](https://usb.org/sites/default/files/hut1_3_0.pdf) sección *Keyboard/Keypad Page (0x07)*.

Supongamos que nos llega el código 04. Que corresponde a la tecla `A`. Entonces nos fijaremos en si está pulsada alguna tecla modificadora.

- Si no hay nada más pulsado, nuestro terminal enviará el carácter ASCII **a minúscula**, `0x61` en hexadecimal.
- Si está pulsada la tecla **shift** entonces enviaremos la **a mayúscula**, `0x41` en hexadecimal.
- Si estuviera pulsada la tecla **control** mandaremos el código `0x01` como si fuera el carácter **`^A`**.

Para simplificar, nuestro terminal sólo puede enviar **un carácter** ASCII por cada tecla, o por cada combinación de modificador + tecla. Los terminales estándar envían **secuencias de escape** ([ANSI escape code](https://en.wikipedia.org/wiki/ANSI_escape_code)) porque no hay un carácter ASCII por cada posible combinación de tecla + modificadores.

No soportamos teclas de función, ni *"Av Pág"* o *"Re Pág"*, *Inicio*, *Fin*, etc. Tampoco tenemos teclas muertas así que no podremos poner tildes. No está implementada la repetición de las teclas al tenerlas pulsadas, ni el bloqueo de mayúsculas... todas esas cosas no son automáticas, las gestiona también la consola serie.

Eso en cuanto a la **transmisión** de datos, del terminal al ordenador. Hablemos de la **recepción**.

En el artículo anterior [Gráficos VGA con FPGA Tang Nano parte III]({{site.baseurl}}{% post_url 2023-11-10-lcd_tang_nano_III_texto %}) ya te enseñé a mostrar **texto**. Usaré la versión **monocromo**. Sin color. Sólo que, en vez de blanco o gris, le he puesto un tono verde simulando un terminal antiguo de fósforo.

Al motor de texto tenemos que añadirle una **UART** para comunicarnos con el ordenador y un **módulo de control**. El módulo de control recibe el carácter desde la UART y lo anota en la RAM de vídeo.

{% include image.html file="serterm_glass.svg" caption="Esquema para la recepción y visualización de caracteres. EyC." %}

Incluyendo la parte del teclado, el esquema quedaría así.

{% include image.html file="serterm.svg" caption="Esquema para la recepción y transmisión de caracteres. EyC." %}

El módulo **cursor** tan solo compara la posición de memoria a la que apunta *control* y la que está pintando el motor de texto. Cuando ambas  coinciden, activa una señal para que esa celda se dibuje en video inverso.




## Raspberry

Usaré una **Raspberry Pi3** porque prefiero un ordenador con **Linux** que cuente con una **UART** de verdad.

La Raspberry Pi3 tiene dos UARTs hardware ([BCM2835 ARM Peripherals](https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf)): una mini y otra completa. La **mini** esta pensada para usarse como consola serie. Pero no me sirve porque no soporta bit de paridad, ni tampoco detecta la señal *break*.

Pero la UART **completa (PL011)** se utiliza para manejar el módulo Bluetooth. Así qué primero debemos deshabilitarlo con estas líneas en el fichero `/boot/config.txt`:

```
dtoverlay=disable-bt
enable_uart=1
```

También podríamos haber forzado a utilizar la mini-uart con el módulo Bluetooth poniendo `dtoverlay=miniuart-bt`, pero no se recomienda. Es preferible deshabilitarlo si no lo vamos a usar.

En el siguiente arranque `/dev/serial0` apuntará a `/dev/ttyAMA0`, que es la principal.

```
/dev/serial0 -> ttyAMA0
/dev/serial1 -> ttyS0
```

La tenemos disponible en los pines 8 y 10 del conector GPIO.

{% include image.html file="raspberry.jpg" caption="Raspberry Pi3 con el conector serie. EyC." %}

Lo siguiente que he hecho es modificar el **arranque** `/boot/cmdline.txt` incluyendo lo siguiente:

```
console=serial0,38400 TERM=dumb
```

Así redirigimos la consola de Linux a la salida serie. Lo del terminal *dumb* lo vamos a ver más adelante.

También he activado un **terminal** en este mismo puerto serie. Basta incluir en el fichero `/etc/inittab` esta línea:

```
T0:23:respawn:/sbin/getty 38400 ttyAMA0 dumb
```

y después ejecutar `init q` para que coja los cambios.

Sí, por supuesto que he instalado **init**. No voy a escribir un artículo sobre terminales retro con **systemd**.


## La transmisión serie

Ahora veamos cómo es una transmisión serie.

Consiste en un sólo cable más la masa, que actúa como referencia de tensión. Aunque suelen ser 3 cables: masa, transmisión y recepción.

El estándar RS-232 dice que el *nivel alto* son -12V y el *bajo* +12V. Pero aquí usaremos niveles lógicos **CMOS** de 0 y 3.3V.

En reposo, la línea estará a **nivel alto**. Se hace así para detectar fácilmente un cable cortado.

La transmisión comienza cuando tiramos la línea a nivel bajo durante el tiempo que dura un bit. Este es el **bit de inicio**, y sirve para preparar el receptor.

{% include image.html file="1000_bauds_8-N-1.svg" caption="Ejemplo de transmisión serie a 1000 baudios. EyC." %}

A continuación, se mandan uno a uno los 7 bits (si es ASCII) u 8 bits (ASCII extendido) que componen el carácter. A intervalos regulares según la velocidad de transmisión, y empezando por el menos significativo. Opcionalmente puede incluirse un bit de paridad al final.

Tras el último bit, se pone la línea a nivel **alto** durante un tiempo que puede ser lo que dura uno o dos bits. Esto se llama **bit de parada**. Y así se queda hasta la siguiente transmisión.

Los bits de inicio y de parada tienen **signo contrario**. Es para detectar averías en el transmisor o en la línea. Si se queda con una tensión constante, siempre fallará el inicio o la parada. Evitando que se interprete como un flujo continuo de unos o de ceros.

Cuando la línea se queda abajo durante más del tiempo que dura un carácter se produce un **error**. Acuérdate, luego volveremos sobre esto.



## El teletipo

Hay algunas cosas que se entienden mejor teniendo en cuenta los antecedentes. Déjame que te cuente cómo empezó todo...

Un teletipo era una máquina de escribir automática. Recibía señales a través de un cable e iba escribiendo el mensaje. Y al revés también, los caracteres que tecleabas se enviaban al destino.

Todo vino de la idea de aprovechar mejor las costosísimas líneas telegráficas.

Imagina mediados del siglo XIX. La electricidad había sido una atracción de feria hasta hacía unos años (la ley de Ohm es de 1832).

El telégrafo de Morse y su código supusieron una revolución para la época. Todo el mundo era consciente del potencial del invento y ansiaban mejorarlo.

Algunos inventores se centraron en poder usar la misma línea para transmitir más de un mensaje simultáneamente. Se inventó lo que se conoce como *Telegrafía Armónica*: un método de **multiplexación por frecuencia** en el que cada mensaje iba codificado en una portadora de distinta frecuencia. Esta tecnología evolucionó para convertirse en el **Teléfono**.

Otros, la mayoría, dedicaron sus esfuerzos automatizar el telégrafo. Querían **quitarse al telegrafista** para aumentar la velocidad de transmisión. Pero el código morse tiene un problema de base: sus símbolos son de **diferente duración**.

Morse diseñó su código pensando en que los caracteres más frecuentes (como la *e* o la *i*) fuesen más breves, y por tanto más rápidos de transmitir, que los menos frecuentes. Eso supone una ventaja para un ser humano, pero es muy complicado de automatizar con una máquina electromecánica de la época.

En 1874 Baudot propuso utilizar un código alternativo que también pudiera transmitirse por una línea telegráfica de la época. Cada carácter estaría formado por 5 símbolos de igual duración. El símbolo sería 1 o 0 según hubiera paso de corriente por la línea o no. Patentó una máquina que transmitiría secuencialmente el estado de 5 pulsadores y otra los recibía formando el carácter.

Lo llamó *telégrafo multiplexado*. Esa fue la **primera** transmisión serie de 5 bits. Y estamos a finales del siglo XIX.

Por eso al número de símbolos por segundo en una comunicación lo llamamos *baudio*.

{% include image.html file="Clavier_Baudot.jpg" caption="Telégrafo multiplexado (piano de Baudot). El precursor de las comunicaciones serie. [Fuente](https://en.wikipedia.org/wiki/Baudot_code#/media/File:Clavier_Baudot.jpg)." %}


Con los años el *piano de Baudot* se convirtió en una máquina de escribir automática. Una virguería electromecánica. Usaban una versión modificada del código Baudot para enviar y recibir mensajes por un hilo telegráfico mucho más rápido de lo que lo haría un humano. Y no hacía falta telegrafista, podía usarlas cualquiera que supera mecanografiar.

{% include image.html file="International_Telegraph_Alphabet_2_brightened.jpg" caption="Código de 5 bits de Baudot. [Fuente](https://en.wikipedia.org/wiki/File:International_Telegraph_Alphabet_2_brightened.jpg)." %}

Además, ni siquiera era necesario ya el mecanógrafo. Porque el mensaje primero se troquelaba en una **cinta perforada** de papel. Y cuando se tenían listos varios mensajes, el rollo de cinta se transmitía a toda velocidad hacia el otro extremo.

{% include image.html file="Baudot_Tape.jpg" caption="Cinta perforada con el cóodigo Baudot. [Fuente](https://en.wikipedia.org/wiki/Baudot_code#/media/File:Baudot_Tape.JPG)." %}

Cuando los ordenadores salieron del laboratorio para convertirse en una herramienta de uso empresarial, el teletipo **ya estaba allí**. Y desde entonces ha sido la principal vía de **comunicación interactiva** entre el operador humano y la máquina.

Por el camino, el código de Baudot fue reemplazado por ASCII de 7 bits o EBCDIC. La velocidad de transmisión se ha multiplicado por más de un millón. Y los sistemas son hoy muchísimo más sofisticados. Pero **tu ordenador**, en lo más profundo del sistema operativo, **sigue hablando con un teletipo**.

{% include image.html file="asr33.jpg" caption="Automatic Send and Receiver modelo 33 (ASR33). Uno de los teletipos más populares. A 110 baudios y sólo mayúsculas. [Fuente](https://wiki.theretrowagon.com/wiki/File:ASR33.jpg)." %}


## El teletipo de cristal

Se llamó teletipo de cristal (*glass teletype*) a los primeros terminales serie que mostraban el texto en una pantalla de **rayos catódicos** en lugar de papel.

Estaban hechos con lógica discreta. Y su funcionalidad era muy limitada.

Pero también lo eran los ordenadores y las líneas de la época. Imitaban lo que podía hacer un teletipo: escribir en la posición del cursor los caracteres a medida que van llegando por la linea serie.

Cuando topemos con el margen derecho bajamos una línea y seguimos por la parte izquierda. Esto se llama *automargin*.

¿Y cuando se llene la pantalla? Pues o desplazamos el texto hacia arriba como hace el papel, o borramos la pantalla completa y empezamos desde arriba.

Nuestra consola serie sólo puede hacer eso ahora mismo. No sabe nada más.

Al conectarla a la Raspberry esto es lo que vemos:

{% include image.html file="init_control_crlf.jpg" caption="Mensajes de inicio del sistema operativo. Sin procesar. EyC." %}

Los símbolos raros son **caracteres de control**.

Los caracteres de control son aquellos que están por debajo del número 32. El ordenador te los envía para que tu terminal haga algo con ellos. No para que los muestre por pantalla.

En concreto estos dos son:

- El símbolo `♪` es el carácter 13. Se llama **Carriage Return** (CR). Al recibir el carácter *CR* tu terminal debe llevar el cursor a la **primera columna** de la línea donde está. Porque eso es lo que hacían los teletipos. También lo puedes ver como `0x0d`, `^M` o `\r`.
- El símbolo `◙` es el carácter 10. Se llama **Line Feed** (LF). Se espera que cuando tu terminal reciba el carácter *LF* el cursor **baje una línea**. Puedes verlo representado como `0x0a` en hexadecimal, `^J` en notación *caret*, o también `\n`.

¿Por qué dos caracteres? Porque en las máquinas de escribir eran dos acciones separadas, en el código de Baudot eran dos caracteres separados y en los teletipos eran también dos caracteres separados.

Se llama *carro* a la plataforma móvil donde se carga el papel. Es una pieza que se desplaza hacia la izquierda a medida que escribes y, cuando llega al margen derecho, toca una campanita. Entonces empujas una palanca y sube el papel y, si empujas más, devuelves el carro a la derecha del todo.

{% include video.html file="typewriter_360p.mp4" caption="¿Ves? Son don pasos. Primero sube el papel y luego vuelve el carro. [Fuente]( https://gifs.com/gif/how-to-use-a-typewriter-3lmJOp)." %}

Linux te envía el carácter *CR* seguido de *LF* para ir al comienzo de la línea siguiente.

Interpretemos esos caracteres tal como se espera:

{% include image.html file="init_lines.jpg" caption="Mensajes de inicio del sistema operativo interpretando los caracteres *CR* y *LF*. EyC." %}

Vale... pero antes hemos dicho que cada tecla del teclado manda un carácter ASCII al ordenador. ¿Que pasa cuando pulso la **tecla return**? El terminal necesita ambos, *CR* y *LF* para escribir bien las líneas. 

¿Cual de los dos se debe mandar?

{% include image.html file="git_lftocrlf.png" caption="El mundo está lleno de software deseando cambiarte un LF por un CRLF y al revés. EyC." %}


## La disciplina de línea

Cuando la consola serie envía un carácter llega al al ordenador y lo recoge la UART. Esta se lo envía al *driver de terminal*. El driver es **parte del kernel** y está muy en contacto con el hardware de la UART. Dentro del driver de terminal (recuerda que seguimos en el kernel) hay un código que se llama **disciplina de línea**. Procesa los caracteres que van llegando ([n_tty.c](https://github.com/torvalds/linux/blob/master/drivers/tty/n_tty.c)).

Se encarga de cosas como:

- Guardar en un **buffer** temporal la entrada donde puedes corregirla antes de enviarla al programa receptor.
- A la llegada, convertir el carácter **CR** (`^M`) en **LF** (`^J`) que es el que Linux necesita para procesar la orden.
- Generar **señales** para el control de los procesos (por ejemplo `Ctrl+C` se gestiona en esta capa).
- Hacer **eco** de los caracteres recibidos.
- Poner el ^ delante de los caracteres de control.
- A la salida, traducir el **LF** de Linux a **CRLF** para que el terminal pueda interpretarlo correctamente.

El terminal y la disciplina de línea se configuran con el comando [`stty`](https://man7.org/linux/man-pages/man1/stty.1.html).

Como te decía antes, cuando pulsas *return*, tu teclado normalmente mandará *CR*. Pero el carácter de fin de línea en Unix no es *CR*, sino *LF*. Esta capa se encarga de cambiarlo al vuelo.

Puedes desactivarlo con `stty -icrnl`. Pero entonces Linux **no va a reconocer** tu tecla return como fin del comando:

{% include image.html file="stty_icrnl.jpg" caption="Linux no reconoce *CR* (`^M`) como fin del comando. Pero eso es lo que tu teclado envía. EyC." %}

Por cierto, cuando te pase eso utiliza `Ctrl+J` que es el **fin de línea** *de verdad*.

El **eco** de caracteres también se hace aquí. Todos los caracteres recibidos se retransmiten de vuelta. Así el usuario puede ver lo que ha llegado.

Se puede desactivar con `stty -echo`. Se hace cuando un programa te pide la **contraseña** sin que aparezca en la pantalla.

Todo esto lo puedes ver en el [manual de `termios`](https://man7.org/linux/man-pages/man3/termios.3.html).

El **modo canónico** del terminal significa que al programa final no le llegan caracteres individuales, sino la línea completa. Esta capa se guarda todos los caracteres en un buffer temporal hasta que llega el fin de linea. Entonces lo envía todo juntos a `bash`, `cat` o el proceso que sea.

Lo puedes ver fácilmente con el comando `cat`. Escribes algo, **borras** un par de letras y pulsas *enter*. A `cat` sólo le va a llegar lo que ha quedado en el buffer, pero no lo que has borrado. A eso se llama *cooked mode*. Por supuesto también se puede desactivar. Pero es más para hackers.

De todas formas, como editor es muy simple. Únicamente puedes borrar caracteres o palabras para corregirlos. Pero nada más. No te puedes mover por la línea, ni recuperar comandos anteriores, ni autocompletar. Todo eso lo hace *readline*, ya lo veremos.

Con el carácter de **borrado** tenemos un caso parecido al del retorno de carro. ¿Te acuerdas cuando te he contado que antes se escribía el mensaje en una cinta de papel perforada?

{% include image.html file="stty_borrar.jpg" caption="Secuencia de borrado *backspace-space-backspace*. EyC." %}

¿Cómo corriges un carácter ya **troquelado**? Una vez perforado no se puede borrar. Así que se **tachaba**. Se troquelaban todos los demás agujeros dejándolo en cinco unos: `11111`. Se determinó que eso indicaría un carácter no válido. Cuando el ASCII de 7 bit sustituyó al código *Baudot* acordamos que `1111111` (`7f`) fuese también el equivalente a *borrar*.

El ASR33 tenía una tecla de *rub-out* para tachar todos los agujeros. Así que, cuando te equivocabas, retrocedías la cinta mediante un botón especial, y pulsabas la tecla *rub-out* que generaba el carácter `7f`. Tachando el anterior.

Por eso el carácter ASCII 127 (`7f`) se llama *DELETE*.

Pero en los terminales de pantalla ya no es necesario tachar un carácter equivocado, basta sustituirlo por un **espacio** en blanco. Para ello le tienes que decir al terminal que retroceda el cursor una posición hasta donde está la letra equivocada, escriba un espacio en blanco en su lugar, y vuelva a retroceder una posición para quedarse donde estaba.

Eso se logra mandando un carácter de control que se llama **retroceso** (*backspace*). Es el carácter `08` y tiene el símbolo `◘`.

Ahora ya sabes por qué hay dos caracteres que sirven para lo mismo: *backspace* (`^H`) y *delete* (`^?`).

{% include image.html file="putty_delete.png" caption="Uno de los dos sirve para borrar. El otro incordia. EyC." %}

Algunos sistemas reconocen tanto `^?` como `^H`. Unix sólo uno o el otro. Así pues debes configurar con `stty` qué manda tu terminal cuando en el teclado pulsas la tecla **retroceso**.

```
$ stty erase ^H
```

Por cierto, `stty` admite cualquier carácter. Puedes probar `stty erase ^M` a ver qué pasa.

El **control de procesos** es otra de las funciones de esta capa. Por ejemplo, si le llega `Ctrl+C` enviará la señal **SIGINT** a todos los procesos de la sesión en primer plano.

En resumen, estos son los caracteres de control especiales que reconoce **a la entrada** la disciplina de línea:

 Opción | Char |  Acción
:------:|:----:|:----------------
`intr`  | `^C` |  Envía señal SIGINT
`susp`  | `^Z` |  Envía señal SIGTSTP (Stop typed at terminal)
`quit`  | `^\` |  Envía señal SIGQUIT
`stop`  | `^S` |  XOFF (suspende la salida de texto)
`start` | `^Q` |  XON (reanuda la salida de texto)
`eol`   | `^@` |  Termina la linea actual
`eof`   | `^D` |  Termina la entrada actual (si no hay caracteres hace que *read* devuelva 0 y se interpreta como fin de fichero)
`erase` | `^H` |  Borrar carácter (envía la secuencia *backspace-space-backspace*)
`werase`| `^W` |  Borrar palabra
`kill`  | `^U` |  Descartar toda la linea actual
`lnext` | `^V` |  Escape (no interpretar el siguiente carácter de control)
-       | `^J` |  LF (puede traducirse a CR)
-       | `^M` |  CR (puede traducirse a LF)


**A la salida** también hará un pequeño **postproceso**. ¿Recuerdas que el final de línea en Unix era sólamente el carácter LF (`\n`)?

Pues si tan sólo recibimos el carácter *LF*, el cursor no volverá a la primera columna y se verá todo escalonado. Para que se vea bien necesitamos el *CR*. Por esa razón la *disciplina de línea* **convierte** artificialmente cualquier *LF* saliente en *CRLF*.

Se puede desactivar, por supuesto:

{% include image.html file="stty_opost.jpg" caption="El fin de linea en Linux es sólo *LF*. Así es como se ve al natural. EyC." %}

Por cierto, si quieres experimentar con `stty` es mejor que desactives *readline* por ejemplo con `bash --noediting`.


## El terminal tonto

La comunicación terminal-ordenador va en ambos sentidos. Mediante el carácter de control ASCII `03` (`Ctrl+C`) el terminal le dice al ordenador que interrumpa el proceso en primer plano. Y mediante el carácter `0a` el ordenador le dice al terminal que baje el cursor.

Lo mismo que hay caracteres especiales que el ordenador reconoce y actúa, hay caracteres de control que nuestro terminal debe reconocer. Hasta el momento van:

Código | Nombre | Acción
:-----:|:------:|:-----------
`0x00` | NUL    | *Padding*: relleno (no hace nada)
`0x07` | BEL    | *Bell*: parpadea pantalla (campana acústica)
`0x08` | BS     | *BackSpace*: retrocede cursor
`0x09` | TAB    | *Tabulador*: mueve el cursor a la siguiente posición múltiplo de 8
`0x0a` | LF     | *Line Feed*: Baja el cursor y hace scroll si es preciso
`0x0d` | CR     | *Carriage Return*: mueve el cursor a la primera columna

Claro que en este terminal sólo funcionan los programas simples en modo texto.

Cualquier programa a pantalla completa nos va a requerir más cosas:

```console
pi@raspberrypi:~$ vim
E437: Terminal capability "cm" required
-- More --
```

Pero, te voy a decir, tampoco se echaba de menos.

Ten en cuenta lo **lento** que iba todo. Los terminales se hicieron más sofisticados a medida que las comunicaciones mejoraban.

¿Has visto *Wargames*, la película? ¿Te acuerdas de estos adaptadores telefónicos?

{% include image.html file="wargames-02.jpg" caption="Adaptador para que tu ordenador llame por teléfono. [Fuente](https://pc-museum.com/046-imsai8080/wargames.htm)." %}

Esos cacharros, que ya estaban desfasados en el momento de rodar la película, daban una velocidad de transferencia máxima de entre 100 y 300 baudios.


{% include video.html file="login_150.mp4" caption="Así es un *login* a 150 baudios. EyC." %}

Durante mucho tiempo, el único editor usable fue `ed`, [el editor de texto estándar](http://www.escomposlinux.org/humor/linux/ed) (original: [Ed, man! !man ed](https://www.gnu.org/fun/jokes/ed-msg.html)).

> When I log into my Xenix system with my 110 baud teletype, both vi and Emacs are just too damn slow.

No exagera.

Así es `vim` a 1200 baudios (10 veces más rápido). 1200 baudios era una velocidad respetable a principios de los 90, en España.

{% include video.html file="vi_1200.mp4" caption="Vi a 1200 baudios. EyC." %}

Pues imagínatelo a 110, 10 veces más lento. No te quedaba otra que editar con `ed`:

{% include video.html file="ed_150.mp4" caption="Duplicando la velocidad del terminal con ed a 150 baudios. EyC." %}

**Ed** evolucionó a **ex**. Más tarde **ex** incorporó un modo más visual a pantalla completa al que llamó **vi**. Finalmente **vi** se convirtió en **vim** y ya nadie se acuerda de **ex** ni de **ed**.

Salvo que trabajes mucho en línea de comandos o hagas scripts. En cuyo caso habrás usado **sed**. **Sed** es la versión *streaming* de **ed**.

¿Ves por qué los comandos básicos de Unix tienen muy poquitas letras? cd, cp, ls, mv, id, rm, cat...

Pero también había **juegos**. ¿Has oído hablar de las aventuras *gráficas*? Se llaman así para distinguirlas de las **aventuras conversacionales**. El sistema de juego iba con texto y comandos. Tú le decías al programa en qué dirección querías ir (*n, s, e, w*) y él te iba diciendo lo que encontrabas. También le decías acciones como *take* esto o aquello, *use*, etc.

Por supuesto el mapa, si no venía con el juego, te lo hacías tú en la cabeza o en papel.

El primer juego de aventura fue [Colossal Cave](https://es.wikipedia.org/wiki/Colossal_Cave_Adventure). La primera versión fue escrita en Fortran en 1976.

{% include video.html file="colossal_cave_150.mp4" caption="Te daba tiempo de pensar. EyC." %}


## Break, SysRq y SAK

Decíamos antes que *cuando la línea se queda abajo durante más del tiempo que dura un carácter se produce un error*. Ese error se llama **break**. Y es muy importante.

{% include image.html file="break_1000_bauds_8-N-1.svg" caption="Condición de break. No tiene una duración concreta. EyC." %}

Antes los terminales tenían una tecla especial para generar tal condición. Y los teclados modernos la han heredado: [Break Key - Wikipedia](https://en.wikipedia.org/wiki/Break_key).

Si está habilitado, mediante la condición *break* invocamos a [**magic SysRq**](https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html).

*Magic SysRq* es un mecanismo que actúa a nivel de **kernel** y sirve para recuperar parte del control cuando el sistema no responde. Podemos hacer cosas como aumentar el nivel de log del kernel, sincronizar el disco, volcar los registros de la CPU o reiniciar.

Se puede llamar desde una **consola local** con la combinación de teclas `ALT-SysRq-<command key>`. Pero para eso tienes que tener acceso físico al servidor. En cuyo caso también podrías haberle dado al reset sin más.

O desde una **conexión remota**. Entras por SSH y haces
```
echo b > /proc/sysrq-trigger
```
y se reinicia sin más.

¡Pero para eso tienes que ser **root**!

Si embargo, a través de una **conexión serie** (que podía ser telefónica) basta con enviar una condición break y fíjate:

{% include image.html file="sysrq_help.jpg" caption="Ayuda de SysRq. Mira que aún no hemos iniciado sesión. EyC." %}

Aún estamos en el login. Es independiente de los privilegios del usuario. Tener activo *magic SysRq* en estas condiciones era una **brecha de seguridad** enorme. Porque cualquiera podía llegar y tirar el servidor.

No obstante, además de *SysRq*, el driver de terminal nos ofrece otra acción muy interesante para la condición *break*. Una que sirve justamente para **aumentar la seguridad**.

Imagina que estás en una Universidad. En los años 80-90. Hay una sala con varios terminales de ordenador. Los alumnos reservan hora y hacen uso de ellos por turnos. Tú has reservado. Llegas y tu terminal está libre. Te sientas frente a él y enciendes el monitor:

{% include image.html file="pseudologin.jpg" caption="*Login* te pide credenciales. EyC." %}

Introduces tus credenciales pero, en vez de dejarte entrar, aparece un error:

{% include image.html file="pseudologin_error.jpg" caption="Pues resulta que no era *login* quien te pedía credenciales. EyC." %}

¿Te suena a **phishing**? Estos ataques *modernos* tienen ya 50 años...

Quien estuvo sentado antes que tú, en ese mismo terminal, dejó puesto un programa imitando la pantalla de *login*. Cuando pusiste tus credenciales, las guardó y te mostró un error para despistar.

La función **SAK** (*Secure Access Key*) se inventó precisamente para prevenir esto.

Hay que activarla así (en `/etc/rc.local`):

```
setserial /dev/ttyAMA0 sak
```

Una vez habilitada, se invoca con *break* (si también tienes activo *magic sysreq*, entonces serán dos *break* seguidos).

Cuando el driver de terminal recibe la señal *break* localiza aquellos procesos que:
- su sesión está asociada a este terminal o
- utilizan este terminal como entrada / salida.

Y los mata. A todos. Con *SIGKILL*.

La sesión finaliza. **Init** volverá a lanzar el proceso `getty`. Mostrándote una pantalla de login que, ahora sí, puedes estar **seguro** viene del sistema operativo. Y no de un hacker.

Fíjate en el escenario anterior al pulsar *SAK*.

{% include video.html file="pseudologin_sak.mp4" caption="SAK matará cualquier proceso corriendo en esa terminal. EyC." %}

¿Alguna vez has tenido que presionar *Ctrl+Alt+Supr* antes de poner usuario y contraseña en un **Windows** corporativo? Tiene la misma función. Ningún programa de usuario puede capturar esa secuencia, así te aseguras de que quien te pide credenciales es realmente el sistema operativo.

{% include image.html file="windows_sak.jpg" caption="*Secure Access Key* en Windows. Porque algunos compañeros tienen muy mala idea. EyC." %}



## Stty para hackers

Siguiendo con la **seguridad**, hay un escenario donde conocer `stty` resulta especialmente práctico: *hacking*.

Los *pentesters* deberían hablarse más con los administradores de sistemas. Ambos aprenderían mucho.

Hay una técnica que se llama **remote code execution**. Va de aprovechar un fallo de un programa para hacer que que ejecute algo que no estaba programado. Generalmente acabas haciendo que lance un intérprete de comandos, una *shell*, porque así tienes acceso a la máquina con los mismos privilegios que el usuario con el que corría el programa vulnerable.

Pero el programa original normalmente es un *demonio*, es decir desconectado del terminal. Así que esa shell empieza pero **no tiene terminal**.

Es limitante porque, aparte de que hay muchos programas que requieren TTY (como su, vim, o cualquier programa a pantalla completa), tampoco ves el *prompt*, ni los mensajes de error; si algo se queda pillado no puedes usar Ctrl+C, no funciona el autocompletado y el histórico de comandos, ni puedes editar, etc.

Verás. Te lo voy a enseñar. Levanto en la **Raspberry** una shell directamente desde el proceso `init`, escuchando en el puerto 1234:

```
N0:23:respawn:/usr/bin/nc.traditional -lvp 1234 -e /bin/sh
```

Me voy a conectar desde una Ubuntu usando *Netcat* y ejecutaré algunos comandos.

{% include image.html file="h_notatty.gif" caption="Bash no está en modo interactivo. EyC." %}

En esa captura quiero que **observes** lo siguiente:
- No te muestra *prompt*. Los comandos que escribo yo se ven igual que las respuestas.
- No te autocompleta con tab (*hostn* está incompleto).
- No te muestra los mensajes de error (fíjate en el comando `hostn`, que no existe).
- La respuesta al comando `tty` es que no estamos en ningún terminal (o pseudoterminal).
- Cuando presiono `Ctrl+C` para salir del `sleep`, en realidad termina mi propio proceso netcat y me devuelve al prompt de mi máquina local *ubuntu*.

Para arreglarlo hay que diferenciar dos cosas:
- Por un lado necesitas iniciar un terminal en el extremo remoto.
- Y por el otro necesitas que la *disciplina de línea* de tu propio terminal no te estorbe.

La primera se solía solucionar con `script` o con el comando `unbuffer` de *expect*. Aunque últimamente se ha puesto de moda hacerlo con Python:

```console
python -c 'import pty; pty.spawn("/bin/sh")'
```

Yo lo haría con **`script`**. Te explico por qué. Las máquinas vulnerables a menudo son viejas y podrían no tienen Python3. En cambio `script` es parte del paquete [util-linux](https://en.wikipedia.org/wiki/Util-linux). El mismo en el que vienen `kill`, `mount` o el mismísimo `login`. Lo vais a tener ahí prácticamente garantizado.

Basta usar `script /dev/null` para que no escriba ningún fichero. Iniciará `/bin/sh`. O bien `script -c /bin/bash /dev/null` para usar una shell concreta.

{% include image.html file="h_script.gif" caption="*Script* crea un pseudoterminal. EyC." %}

De esa captura tienes que fijarte en que **hemos arreglado** algunas cosas:

- Tras lanzar el comando `script` nos aparece el *prompt* de root `#`.
- Ya sí muestra que estamos en una terminal (/dev/pts/1).
- El error de comando incorrecto ahora sí aparece.

Pero otras **siguen fallando**:

- Los comandos salen repetidos. La primera vez sobre la línea de comandos y la segunda vez justo debajo.
- El tabulador no autocompleta el comando `hostn`.
- Al hacer Ctrl+C no se interrumpa el `sleep` sino nuestro *netcat*.

Cuando iniciamos *script*, crea un terminal para nosotros donde lanza un *sh*. Este terminal tiene su propia disciplina de línea. Así que ahora tenemos **dos terminales**, el de nuestra máquina local y el remoto.

El **primer fallo** se debe a los dos ***echo***. Según tecleamos vemos aparecer la letras porque nuestro terminal nos las devuelve, pero no las enviará al otro extremo hasta que pulsemos *enter* (debido al **modo canónico**). Y cuando llegan al terminal remoto, que también tiene el echo activado, las envía de vuelta. Por eso cada comando se ve doble. Debemos desactivar el echo en nuestro terminal con `stty -echo`.

Por el mismo motivo no funciona el completar con tabulador. Debido al **modo canónico** tu terminal no le envía ningunas entrada a *netcat* hasta que pulsas **enter**. ¿Por qué en mi terminal local sí funciona el autocompletado? Pues porque **tu** bash desactiva el modo canónico de **tu** terminal. El bash remoto lo desactiva en **su** terminal remoto, pero no puede hacer nada con **tu** terminal local. Debes desactivarlo tú a mano con `stty raw`.

El *Ctrl+C* lo está interpretando **tu terminal** local. Por eso interrumpe tu *netcat*. Si quieres terminar procesos remotos, debes pedirle que no lo interprete y lo transmita. Esto se hace con `stty -isig`. Pero, cuidado, una vez lo desactives `Ctrl+C` o `Ctrl+Z` **dejarán de funcionar** localmente. Y tendrás que matar *netcat* de otra manera.

Estas opciones es mejor ponerlas cuando ya tenemos bash corriendo en un terminal en el otro extremo. Se puede hacer con `stty -F` desde otra consola local. Pero yo lo haría dejando el proceso en suspenso:

Con el *netcat* parado, lanzamos en local el comando `stty -isig -echo raw`. Después nos traemos el proceso a primer plano con `fg` y, para cuando termine, hacemos `stty sane`.

{% include image.html file="h_raw.gif" caption="Una shell *netcat* que no tiene nada que envidiar a *telnet* o *ssh*. EyC." %}

Ahora ya **sí funciona** el `Ctrl+C`, el autocompletado, las flechas y todo. Te lo demuestro lanzando `vim` o `Midnight Commander`.

Eso sí, debes decirle al sistema remoto tu **tipo de terminal** local y sus dimensiones. *Telnet* y *ssh* tienen un mecanismo para decírselo pero *netcat* no; así que no puede saberlo si tú no se lo indicas.


## Terminfo

Te decía antes que para experimentar con `stty` tenías que lanzar bash con la opción `bash --noediting`.

Porque Bash utiliza una librería que se llama **readline**.

*Readline* es la librería que te permite **editar la línea de comandos**, moverte por ella, insertar caracteres en cualquier posición, recuperar comandos anteriores, autocompletar con tab y todo eso. La que mueve el cursor al principio con `Ctrl+a`, al comando anterior con `Ctrl+p`, un carácter a la izquierda con `Ctrl+b` y a la derecha con `Ctrl+f`, etc.

Por cierto, ¿sabes de donde vienen esas teclas?

De [**Emacs**](https://www.gnu.org/software/emacs/refcards/pdf/refcard.pdf). Sí, el *editor* emacs.

Por eso si tu terminal envía `Ctrl+p` (ASCII `0x10`) al pulsar la **flecha izquierda** funcionan bien muchos programas como *bash*, *dialog / whiptail*, *mc*, *emacs*. Pero `vi`, por ejemplo, no.

Ya que hablamos de *readline*, en el fichero de configuración (`/etc/inputrc`) **te recomiendo** descomentar las líneas *alternate mappings for "page up" and "page down" to search the history*.

```
# /etc/inputrc - global inputrc for libreadline

# alternate mappings for "page up" and "page down" to search the history
# "\e[5~": history-search-backward
# "\e[6~": history-search-forward
```

En algunas distribuciones como RedHat o SuSE viene activo por defecto. Pero no en Debian y derivados.

Sirve para buscar en el histórico comandos que **empiezan** por lo que ya llevas escrito. De forma que si pones `cat` y vas pulsando `page up` te saldrán todos los ficheros de los que hayas hecho `cat`. A mí me parece más práctico que la búsqueda con `Ctrl+r`.

Por debajo, *readline* se apoya en **terminfo**.

A lo largo de los años, ha habido **tantísimos terminales** y con posibilidades tan dispares, que Unix tiene una **base de datos** sólo para saber cómo interactuar con cada uno. Bueno, en realidad no tiene una, tiene **dos**: *termcap* (obsoleta) y *terminfo*.

Funcionan como **librerías**. Es decir, un programa puede decidir usar *termcap* (si es muy antiguo), usar *terminfo*, o no usar ninguna de las dos. Un programa a pantalla completa probablemente usará **ncurses** que, por debajo, es un cliente de *terminfo*.

Le indican al programa **qué puede hacer** el terminal del usuario: *¿tiene colores? ¿tiene caracteres gráficos? ¿puede hacer scroll? ¿scroll hacia arriba y también hacia abajo? ¿línea a línea o varias a la vez? ¿y scroll horizontal? ¿puede limpiar la pantalla o no? ¿y posicionar el cursor?*

Las funciones se llaman **capacidades**. La lista de capacidades soportadas por *terminfo* viene en el manual y es **enorme**: [terminfo(5) - Linux manual page](https://man7.org/linux/man-pages/man5/terminfo.5.html). Cada modelo de terminal tiene su fichero de configuración donde se listan todas sus capacidades y cómo se invocan.

Supón que estás programando algo y, en un momento dado, necesitas **borrar la pantalla**.

Algo normal hoy, pero no tan común antaño, cuando la "pantalla" podía ser perfectamente una máquina de escribir. Esa capacidad se llama **clear** y cada dispositivo tiene su forma de pedírselo. Así que *Terminfo*, basándose en la variable de entorno `TERM`, buscará su fichero de configuración y mira si viene la capacidad *clear*.

El comando `tput` sirve para generar manualmente la secuencia que corresponda a una capacidad.

Un ejemplo: las consolas de Sun Microsystems limpiaban su pantalla al recibir el carácter de control llamado *Form Feed* (`0x0c`). El mismo que se usa para cambiar de página en una impresora.

```
$ TERM=sun tput clear | hd
00000000  0c                                 |.|
```

En cambio, los terminales que usamos hoy en día casi todos son compatibles con el estándar ANSI y no utilizan caracteres sueltos sino **secuencias de escape**. 

```
$ TERM=ansi tput clear | hd
00000000  1b 5b 48 1b 5b 4a                  |.[H.[J|
```

El carácter *Escape* (`1b` o `^[`) indica al terminal que lo que viene a continuación es una orden, no un texto. Las *secuencias de escape* empiezan por el carácter de control `1b`, seguido de `[`. Formando lo que se llama *Control Sequence Introducer* (`^[[`). ver [ANSI escape code](https://en.wikipedia.org/wiki/ANSI_escape_code).

Si tu terminal fuese un teletipo, que **no puede** borrar la pantalla, *terminfo* no genera nada y en su lugar devuelve **error**.

```
$ TERM=tty33 tput clear | hd
$
```

El terminal más básico que hay en la base de datos es **dumb**:

```
$ infocmp dumb
dumb|80-column dumb tty,
        am,
        cols#80,
        bel=^G, cr=\r, cud1=\n, ind=\n,
```

Verás que es muy parecido a nuestro terminal ahora mismo:

- **am**: (automargin) cuando el texto llega al final de la pantalla, continúa automáticamente en la siguiente línea.
- **ind**: estando en la última fila, el terminal hace scroll cuando recibe un `\n`.
- **bel**: emite un pitido cuando recibe el carácter `0x07` o `^G`. Nosotros en vez de un pitido hacemos un parpadeo de la pantalla.
- **cr**: el retorno de carro, situar el cursor al principio de la línea actual, se hace con `\r`.
- **cud1**: cursor down, bajar el cursor una linea, se hace con `\n`.

Fíjate que este modelo no soporta **borrar la pantalla**. El comando `clear` no funciona y `tput clear` sale con error:

```console
pi@raspberrypi:~$ TERM=dumb
pi@raspberrypi:~$ clear
pi@raspberrypi:~$ tput clear
pi@raspberrypi:~$ echo $?
2
pi@raspberrypi:~$
```


## El terminal eyc

Voy a completar mi terminal dotándolo de algunas capacidades extra como son:

- Borrar la pantalla.
- Mover el cursor una posición arriba.
- Mover el cursor una posición a la derecha.
- Posicionar el cursor.

Una vez implementadas, tendremos que escribir nuestro propio fichero de *terminfo*.

```
eyc|Electronica y ciencia Text terminal,
  am,
  cols#60,
  lines#17,
  cr=^M, bel=^G, ind=^J,
  clear=^L,
  it#8,ht=^I,
  cub1=^H, cud1=^J, cuu1=^R, cuf1=^S,
  cup=^T%p1%' '%+%c%p2%' '%+%c,
  home=^T  ,
  smso=^N, rmso=^O, msgr,
  rev=^N, sgr0=^O, sgr@,
  acsc=+\020\,\021-\036.\0370\333l\332m\300k\277j\331q\304x\263u\264t\303n\305v\301w\302O\333a\261o\337s\334,
```

Lo compilamos:

```console
$ sudo tic -ts eyc.inf
1 entries written to /etc/terminfo
```

Cambiamos la línea de `agetty` para indicar que el terminal serie es de tipo *eyc*:

```
T0:23:respawn:/sbin/getty 38400 ttyAMA0 eyc
```

**Tack** es la utilidad que se usaba para probar los terminales:

{% include image.html file="screen_tack_cux1.jpg" caption="Probando las capacidades de mover cursor. EyC." %}

Con estas capacidades ya estamos listos para ejecutar programas a **pantalla completa**.

Y podemos jugar a cosas que no sean sólo puro texto.

{% include video.html file="ahorcado_150.mp4" caption="¿Nostálgico? Prueba el *ahorcado* a 150 baudios. EyC." %}

Aprovechando que tenemos caracteres de 8 bit, le hemos añadido también gráficos:

{% include image.html file="screen_tack_acs.jpg" caption="Prueba del juego alternativo de caracteres (gráficos). EyC." %}

Y falta un último detalle: **destacar texto**.

El **video inverso** sólo nos ocupará un bit más en la memoria y hará que los programas queden mucho más vistosos.

{% include image.html file="screen_mc.jpg" caption="Mi consola ya es capaz de visualizar aplicaciones complejas. EyC." %}



## Conclusión

Quedan muchas cosas por contar pero lo dejamos aquí.

El **código fuente** del proyecto lo tienes en Github: [verilog-vga/4-serterm](https://github.com/electronicayciencia/verilog-vga/tree/master/4-serterm). Nuestro terminal funciona correctamente a 38400 baudios. A 115200 también, pero necesita *padding* en el scroll.

Hemos visto cómo hacer una **consola serie** completamente nueva. Partiendo de sus **capacidades básicas** hasta algunas más sofisticadas. Hemos aprendido a configurarla desde cero en el sistema operativo. Y hemos explorado las **capas** que conforman la **interfaz de terminal**, algunas heredadas de los primeros Unix.

Con esto termina el recorrido de primera mano por las entrañas de Linux. Seguro que cualquier día, mientras trabajas en la línea de comandos, te vendrá a la cabeza algo de lo que has leído aquí.



## Enlaces

Artículos relacionados:

- [Electrónica y Ciencia - Gráficos VGA con FPGA Tang Nano parte III. Texto]({{site.baseurl}}{% post_url 2023-11-10-lcd_tang_nano_III_texto %})
- [Electrónica y Ciencia - Primeras experiencias con Sipeed Tang Nano]({{site.baseurl}}{% post_url 2021-07-05-tang_nano_fpga %})
- [Electrónica y Ciencia - Demodular AFSK, desde cero]({{site.baseurl}}{% post_url 2017-10-28-demodular-afsk-desde-cero %})
- [Electrónica y Ciencia - Transmisor y receptor digital de ultrasonidos]({{site.baseurl}}{% post_url 2018-03-30-transmisor-y-receptor-digital-de %})

Terminales:

- [Linux terminals, tty, pty and shell](https://dev.to/napicella/linux-terminals-tty-pty-and-shell-192e)
- [Funcionamiento de terminales en UNIX](https://www.uco.es/servicios/informatica/sistemas/doc_ccc/terminales.html)
- [termios(3) - Linux manual page](https://man7.org/linux/man-pages/man3/termios.3.html)
- [terminfo(5) - Linux manual page](https://man7.org/linux/man-pages/man5/terminfo.5.html)

Seguridad:

- [A Blast From the Past: Executing Code in Terminal Emulators via Escape Sequences](https://www.proteansec.com/linux/blast-past-executing-code-terminal-emulators-via-escape-sequences/)
- [Terminal Escape injection](https://vipulvyas.medium.com/terminal-escape-injection-7504d0abc58c)
- [From Terminal Output to Arbitrary Remote Code Execution](https://blog.solidsnail.com/posts/2023-08-28-iterm2-rce)
- [Upgrading Simple Shells to Fully Interactive TTYs](https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/)
- [Linux Magic System Request Key Hacks](https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html)

FPGA:

- [Proyecto completo: verilog-vga/4-serterm](https://github.com/electronicayciencia/verilog-vga/tree/master/4-serterm).
- [UART usada en este proyecto](https://github.com/alexforencich/verilog-uart)
- [How AXI4-Stream Works](https://docs.xilinx.com/r/en-US/ug1399-vitis-hls/How-AXI4-Stream-Works)
- [How the AXI-style ready/valid handshake works](https://vhdlwhiz.com/how-the-axi-style-ready-valid-handshake-works/)

