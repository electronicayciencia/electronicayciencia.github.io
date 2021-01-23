---
title: Avisador personal de autobús con ESP8266
layout: post
assets: /assets/2021/01/avisador-personal-autobus-con-esp8266
image: /assets/2021/01/avisador-personal-autobus-con-esp8266/img/esp01s-module-cropped.jpg
featured: false
tags:
  - Circuitos
  - Informática
  - ESP8266
---

Hoy vamos a hablar del **ESP8266**, un microcontrolador pensado para IoT. Repasaremos sus comienzos. Os contaré en qué consiste la **arquitectura Xtensa**, cómo funciona un **bootloader** y montaremos el entorno ESP-IDF con **FreeRTOS**. Como proyecto final, leeremos el valor de una variable mediante un **API REST** y lo mostraremos en tiempo real en un LCD.

{% include image.html file="board-display-cropped.jpg" caption="Avisador de autobuses construido con el módulo ESP-01S. EyC." %}

## Introducción

Espressif lanzó el ESP8266 en 2013. Un microcontrolador limitado en memoria y periféricos pero rápido, barato, con conexión WiFi y fácil de usar.

Poco tiempo después, otra compañía también china llamada **AI-Thinker** sacó al mercado un módulo incluyendo el ESP8266 más los componentes necesarios (principalmente memoria externa, cuarzo y antena). Lo llamó ESP-01. Incorporó una aplicación con comandos Hayes y lo vendió como **AT módem WiFi Arduino**. La idea era servir de interfaz con una red inalámbrica, igual que usamos módems GSM a la hora de enviar y recibir SMS desde un micro.

{% include image.html file="esp-01-3d.jpg" caption="Módulo ESP-01S. [Aliexpress](http://aliexpress.com)." %}

El ESP8266 no era atractivo para los **fabricantes occidentales**. Los diseñadores ya tenían sus propias soluciones de conectividad WiFi. Toda la documentación estaba en chino. Las primeras versiones del SDK parecían inestables y las herramientas de desarrollo tenían fallos. Tampoco contaba con el certificado de compatibilidad electromagnética ([FCC mark](https://en.wikipedia.org/wiki/FCC_mark)) y cualquier producto comercial basado en ellos debía someterse a un proceso de homologación para venderse en EEUU o Europa. 

Sin embargo, a diferencia de otros microcontroladores, carece de memoria Flash interna. No se puede grabar en él ningún programa. Cualquier código debe estar almacenado en una memoria flash accesoria y cargarse a través de un **bootloader**. Por otra parte, mediante el bootloader de Espressif, se podía modificar la memoria usando un puerto serie. Lo que en principio era una carencia, lo convertía en un chip muy versátil. Pronto se corrió la voz de que el módulo ESP-01 era **reprogramable**.

¿Un microcontrolador minúsculo, rápido, con conectividad WiFi, que no requiere un programador especial y por poco más de 1 dólar? Tal vez los profesionales eran reticentes, pero tenía un enorme potencial en el mercado de **aficionados (*makers*)**. Sólo había que ponérselo fácil. AI-Thinker había sacado otros modelos de su ESP-01 con más patillas disponibles. **NodeMCU** liberó en 2014 un firmware para programar el ESP8266 en lenguaje **Lua** y diseñó una placa de desarrollo. Las tiendas chinas se llenaron de clones de NodeMCU y otros modelos de placas. Todas con módulos de AI-Thinker o similares, un regulador de tensión y un conversor USB-Serie. Algunos modelos integraban pantallas OLED, cámaras o cargadores de baterías. NodeMCU comenzó a vender también sus propias placas con el módulo ESP-12 y su firmware Lua preinstalado.

{% include image.html file="mcu-devboard.jpg" caption="Placa de desarrollo ESP8266 basada en un módulo de AI-Thinker. [Amazon](http://www.amazon.es)." %}

Una importante **comunidad** creció alrededor del ESP8266. Tradujeron al inglés parte de la documentación. Programaron una versión de micropython. Se actualizaron la librería y el IDE de **Arduino** para soportar el chip y hardware existentes. Espressif lanzó sus propios módulos. Puso en marcha foros de colaboración, liberó algunas especificaciones y ha ido abriendo progresivamente el código de sus SDK (kits de desarrollo).

El ESP8266 fue revolucionario cuando salió y se puso de moda rápidamente. En 2016 Espressif lanzó el **ESP-32**, superando ampliamente el ESP8266. Luego vino el ESP32-S2. Y recientemente ha aparecido el [ESP32-S3](https://www.espressif.com/en/news/ESP32_S3). Aún no se ven abiertamente en el mercado electrodoméstico de consumo. En cualquier caso, ponérselo fácil a los aficionados de hoy es asegurarse ventas mañana. Porque los futuros ingenieros acabarán incorporando en sus diseños aquello que conocen.

## El núcleo Xtensa

Según el datasheet, la **CPU** del ESP8266 es un core *Xtensa Diamond Standard 106 micro*. Xtensa es un modelo de **núcleo RISC** producto de la empresa Tensilica (ahora Cadence Design Systems). Xtensa no es un microcontrolador, es un núcleo suelto que te venden para que lo incorpores en tu integrado si lo necesitas.

Supón que tienes una empresa de componentes y has hecho un **hardware específico** con su correspondiente controlador. Sería muy práctico hacerlo programable para poder actualizar el firmware en el futuro. Podrías usar un microcontrolador ya existente, pero el rendimiento no sería óptimo. Seguro que le faltarán o le sobrarán cosas. Por no decir que ahora tienes dos chips en vez de uno. ¿Contratas a Motorola, Intel o AMD y les pides un **micro a medida** para ti? Si eres muy grande, podría ser una opción.

Otra opción es **desarrollarlo en una FPGA** o un ASIC, por ejemplo. Ponerte a pensar un juego de instrucciones de propósito general junto a tus **instrucciones específicas**. Luego deberás implementar los componentes de la CPU: el ciclo de instrucción (*fetch decode execute*), los registros, la ALU, las interrupciones, etc. Hacerte tu propio compilador y tus herramientas de desarrollo para tus instrucciones. Ahora **optimízalo** para minimizar el área de silicio, el consumo y el precio. Es una inversión muy grande.

O podrías dedicarte a tu hardware y **comprar sólo la CPU** hecha y probada. Lista para incorporarla a tu chip. Con un juego de instrucciones básicas más otras definidas por ti. Los registros que tú quieras, las interrupciones que tú quieras y optimizarlo a tu medida. Eso es justo lo que comercializa Tensilica: [Tensilica Customizable Processors](https://ip.cadence.com/ipportfolio/tensilica-ip/xtensa-customizable).

> By selecting and configuring pre-defined elements of the architecture and by inventing completely new instructions and hardware execution units, your Xtensa processor can deliver performance levels that are orders of magnitude more efficient than other 32-bit processors. And you can do this in a fraction of the time it takes to develop and verify an RTL-based solution.

El ESP8266 sería un [Diamond Standard 106Micro](https://ip.cadence.com/news/243/330/Tensilica-Unveils-Diamond-Standard-106Micro-Processor-Smallest-Licensable-32-bit-Core), la configuración más baja y de menor consumo de la arquitectura Xtensa 9.

> The Xtensa 9 processor, in its smallest configuration, is just 0.024 mm2 with 12 uW/MHz average dynamic power post place & route in 40 LP process technology at 60 MHz.

Este diagrama no es del ESP8266, corresponde a la arquitectura LX6 utilizada por el ESP-32. Si bien, para lo que nos interesa ahora, las diferencias no son relevantes:

{% include image.html file="lx6-processor-arch-diagram.png" caption="Arquitectura Tensilica Xtensa LX6 usada por el ESP32. [Cadence](https://www.cadence.com/)." %}

En **azul oscuro** tenemos los componentes básicos, los más importantes son:

- el ciclo de instrucción para 32 bits.
- un juego de instrucciones básico (*ISA: Instruction Set Architecture*). Consta de 80 instrucciones comunes a todos los núcleos de Xtensa. Dicho de otra manera, te valen las herramientas de desarrollo compatibles con Xtensa y no tendrás que hacerte un compilador especial.
- una unidad aritmético-lógica sencilla de 32 bits.
- soporte de excepciones y control del procesador.

Luego tienes otros componentes configurables. Por ejemplo:

- ¿MAC de 16 bits? (MAC viene de *multiply accumulator*, si no te suena la instrucción MAC, echa un vistazo a la entrada titulada [Tu primer proyecto con DSP]({{site.baseurl}}{% post_url 2020-06-21-tu-primer-proyecto-con-dsp %}))
- ¿Unidad de punto flotante? ¿de precisión simple o doble? Para recordar cosas sobre la FPU lee [La presión atmosférica - BPM280]({{site.baseurl}}{% post_url 2018-10-07-la-presion-atmosferica-bmp280 %}).
- Temporizadores ¿cuantos?
- Periféricos, ¿lo quieres con I2C, SPI, I2S? ¿cuántos de cada? ¿Y puerto JTAG para depuración?
- ¿Cuántos bancos de RAM, tipos de interrupciones, pipeline, etc.?

{% include image.html file="lx6-processor-options.png" caption="Opciones de configuración para la arquitectura Xtensa LX6." %}

Puedes comprar y añadirle cores de DSP, salidas de audio o video, incluso una **Unidad de Gestión de Memoria** (MMU) en caso de ejecutar un Sistema Operativo sofisticado. Su función es traducir direcciones de memoria virtuales a físicas y facilitar protección de memoria, paginación etc. Tienen una compatible con Linux, ni el ESP8266 ni el ESP32 la integran. Por esa razón aún habiendo [versión de Linux para Xtensa](http://www.linux-xtensa.org/) no podemos ejecutar **Linux** en estos procesadores.

El ESP8266 es un core [Diamond Standard 106Micro](https://web.archive.org/web/20111114025833/http://www.tensilica.com/uploads/pdf/106Micro.pdf) Xtensa 9 con:

- 64kb de RAM de instrucciones (*iRAM*)
- 96kb de RAM de datos (*dRAM*)
- Puerto QSPI para memoria flash externa capaz de direccionar hasta 16 Mb
- Periféricos:
  - 16 pines GPIO (funciones compartidas con otros periféricos)
  - SPI
  - I2C (sólo para intercomunicación en el bus interno, por ejemplo el PLL). No usable.
  - Interfaz I2S con DMA
  - 2 UART
  - 1 conversor ADC de 10-bit (hasta 1V máximo)
- Etapa de radio formada por:
  - transceptor de 2.4GHz IEEE 802.11 b/g/n
  - amplificador RF
  - [Balun](https://en.wikipedia.org/wiki/Balun)

{% include image.html file="esp8266ex-blocks.png" caption="Diagrama de bloques del ESP8266EX. [Espressif](https://www.espressif.com/sites/default/files/documentation/0a-esp8266ex_datasheet_en.pdf)." %}

La conectividad WiFi ofrece unas posibilidades muy interesantes. No sólo puede actuar como Access Point o como estación (cliente). Sino que recibe y envía **paquetes 802.11 en crudo** (sin procesar). De ahí su uso en **ataques** contra infraestructura WiFi. Los paquetes de *deautenticación*, por ejemplo, no van cifrados y se pueden falsificar. Puedes dejar a los clientes sin servicio simulando peticiones de desconexión del Access Point a todas las estaciones conectadas. 

Como muestra, el siguiente proyecto usa llamadas al API 802.11 para emitir **falsas balizas WiFi** con nombres aleatorios: [Jeija esp_wifi_80211_tx sample code](https://github.com/Jeija/esp32-80211-tx).

{% include image.html class="small-width" file="rick-roll-beacon.jpg" caption="Access Points falsos simulados por el ESP8266. EyC." %}

## El módulo ESP-01S

Es más sencillo encontrar el ESP8266 formando parte de algún módulo que por separado. Tiene lógica pues **carece de memoria Flash**, por tanto siempre debe ir acompañado de una memoria externa y un cuarzo. Además de la antena o conector WiFi y la red de adaptación de impedancias.

El módulo ESP-01S contiene tan sólo dichos componentes. Aquí podéis ver una fotografía ampliada. El cuadrado de la izquierda es el ESP8266EX, a su derecha está la memoria y sobre ambos en el centro está el cuarzo a 26MHz. El resto son condensadores y resistencias principalmente.

{% include image.html file="esp01s-module-cropped.jpg" caption="Módulo ESP-01S, detalle de los componentes. EyC." %}

En mi módulo algunos valores son diferentes del esquema oficial ([datasheet del ESP-01S]({{page.assets | relative_url}}/ESP8266_01S_Modul_Datenblatt.pdf)).

{% include image.html file="esp01s-retocado.jpg" caption="Esquema del módulo ESP-01S. EyC." %}

Los condensadores **C1**, **C2** y **C3** sirven para estabilizar la tensión durante los picos de consumo elevado, también cortocircuitan a masa las altas frecuencias, evitando que se propaguen por la alimentación hacía otras partes del circuito. 

**R3** mantiene a positivo la patilla de *reset*. Mientras **C4** constituye un mecanismo anti-rebotes (*de-bouncing*). **R2**, **R3**, **R4** y **R6** configuran el modo de operación del dispositivo. Lo veremos en el apartado siguiente. 

Por último, la bobina **L1** junto a **C7** y **C8** llevan la señal de RF hacia la antena. Se trata de una **antena** impresa directamente en la placa y conectada a masa por uno de sus brazos. Es una variante del diseño en "F invertida" y se llama *meandered inverted-F PCB antenna*.

## El bootloader

Nada más activar un microcontrolador, este comienza a ejecutar el programa que lleva grabado. Para cambiar dicho programa necesitamos un programador especial. Por ejemplo un programador PICkit si se trata de microcontroladores PIC.

Una opción más **flexible** es usar un cargador de arranque, conocido en inglés como ***bootloader***. Consiste en sustituir el programa principal por un programa secundario que se ejecuta primero. Cuando alimentemos el micro, ejecutará este bootloader y será él quien arranque  el programa principal; que puede estar en la flash del micro o en una memoria externa.

No sólo eso, en el bootloader podemos dejar programadas otras utilidades; sin ir más lejos, **leer y escribir en la memoria flash**. Ahora ya no necesitamos ningún programador especial para alterar su contenido, basta enviar los comandos adecuados al bootloader.

El ESP8266 lleva este método al extremo. El micro no posee memoria flash, su cargador está en una memoria de solo lectura (ROM) y no es modificable -o no sabemos cómo-. Eso es bueno, porque tampoco podemos *romperlo* por accidente. De hecho, podríamos decir que el ESP8266 no es programable: es un core Xtensa con radio, memoria RAM **y un bootloader**.

### Modos de inicio

¿Cómo sabe el cargador si debe ejecutar el programa principal o ponerse a escuchar comandos? Por los **niveles lógicos** de las patillas 13, 14 y 15 (MTDO o GP15, GP2 y GP0). Hay tres patillas, ocho combinaciones, ocho modos de arranque distintos ([ESP8266EX - Frequently Asked Questions](https://www.espressif.com/sites/default/files/documentation/Espressif_FAQ_EN.pdf)).

3-Bit Value [GPIO15, GPIO0, GPIO2] | Boot Mode
-----------------------------------|----------------------
7 / [1，1，1]                        | SDIO HighSpeed V2 IO
6 / [1，1，0]                        | SDIO LowSpeed V1 IO
5 / [1，0，1]                        | SDIO HighSpeed V1 IO
4 / [1，0，0]                        | SDIO LowSpeed V2 IO
**3 / [0，1，1]**                    | **Flash Boot**
2 / [0，1，0]                        | Jump Boot
**1 / [0，0，1]**                    | **UART Boot**
0 / [0，0，0]                        | Remapping

Sólo nos interesan los modos 1 y 3:

- **Flash Boot**, arranque del programa contenido en la memoria flash y 
- **UART Boot**, escuchar comandos serie. 

Volviendo al esquema del módulo ESP-01S, arriba, la patilla GPIO15 o MTDO está permanentemente a 0 por resistencia **R6**. GPIO2 está puesta a 1 a través de **R2** y el **LED**. Y GPIO0 está a 1 vía **R3**. Para entrar en modo programación usaremos un circuito como este:

{% include image.html class="medium-width" file="programar-esp01.png" caption="" %}

Conectaremos **RX** y **TX** a un conversor USB-Serie. **R1**, **R2**, **R3** y **C1** se pueden omitir. Nuestro módulo ya incorpora tales componentes. **R4** y **R5** limitan la corriente por si alguna de estas dos patillas estuviera configurada como salida en vez de como entrada, provocando un cortocircuito. Para entrar en **modo programación** sólo debemos pulsar brevemente *reset* mientras tenemos presionado *prog*; de lo contrario arrancaremos en modo normal.

Espressif nos proporciona la herramienta **esptool** para interactuar con el bootloader. La interfaz está documentada en [espressif/esptool](https://github.com/espressif/esptool/wiki/Serial-Protocol). Se trata de comandos [SLIP](https://es.wikipedia.org/wiki/Serial_Line_Internet_Protocol) (*Serial Line Internet Protocol*) con multitud de opciones.

Aún así, el programa principal tampoco se ejecuta directamente. Pues en la memoria flash hay un segundo bootloader que nos permite, entre otras cosas, actualizar el firmware remotamente (OTA).

## Entorno de desarrollo

Vamos a programar el ESP8266 según propone el fabricante: con el **entorno ESP-IDF en lenguaje C**. Si prefieres hacerlo en Arduino, micropython, Basic, LUA u otros el procedimiento será distinto.

El entorno ESP-IDF me ha **sorprendido para bien**. Casi todo es código abierto, salvo algunas partes binarias. La pila TCP/IP se basa en [lwip](https://en.wikipedia.org/wiki/LwIP). Incorpora librerías bien conocidas como [cJSON](https://github.com/DaveGamble/cJSON) o [sodium](https://github.com/jedisct1/libsodium). Además de otras que parecen escritas por Espressif como *esp-mqtt*. En general, el estilo de programación parece **coherente** y cuenta con múltiples ejemplos funcionales.

Crear un programa binario capaz de ejecutarse en un microcontrolador requiere de:

- La **toolchain** específica de la plataforma: Xtensa 106 en este caso. La han llamado *lx106*. Comprende el *compilador*, el *linker* (o link-editor), ensamblador, depurador y algunas librerías básicas (como la *librería de C estándar*).
- El **SDK** (Software Development Kit). Ahí van las rutinas propias del dispositivo o sus ficheros de cabeceras si están ya compiladas. Los drivers para acceder a sus periféricos hardware (capa PHY): entradas GPIO, WiFi, SPI o I2C. Así como scripts de compilación y linkado. Suele incluir ejemplos de uso.
- El **entorno de desarrollo** es el ecosistema de programas y herramientas sobre el que se apoyan los componentes anteriores. Digamos *cmake*, *bash*, *python*, etc. A veces va todo junto integrado en un IDE, como pasa con Arduino o MPLab.

El entorno nativo de desarrollo es Linux con Eclipse. Yo voy a usar Windows con **Visual Studio Code** sabiendo que estará peor integrado. Si trabajas en Linux sólo tendrás que instalar los paquetes necesarios. Si trabajas en Windows, como es mi caso, Espressif te ofrece un entorno msys32 (que pesa más de 600Mb comprimido) con los paquetes preinstalados.

Desde 2014 el SDK ha pasado por **varias versiones** y distintos estilos. Es importante tenerlo en cuenta a la hora de buscar en foros ejemplos de uso. Estas son las tres más importantes.

### Versión NonOS

La primera versión fue la [**versión NONOS**](https://github.com/espressif/ESP8266_NONOS_SDK). Es un SDK simple, lineal. El primero en ser publicado. Sobre él están desarrolladas las librerías de Arduino para el ESP8266. Se considera **obsoleto** desde diciembre de 2019 y [recomiendan usar la versión RTOS](https://github.com/espressif/ESP8266_NONOS_SDK/issues/229).

> Support Policy for ESP8266 NonOS (Starting from December 2019)
> - We will not add any new features to the ESP8266 NonOS SDK.
> - We will only fix critical bugs in the ESP8266 NonOS SDK.
> - It is suggested that the ESP8266_RTOS_SDK, instead of ESP8266 NonOS SDK, be used for your projects.

Este sería el típico programa para hacer **parpadear un LED** -el equivalente a un *hello world*- en la versión NONOS: El código del usuario se escribe en la función `user_init`. Configuramos el pin como salida usando la macro `PIN_FUNC_SELECT`. Y llamamos periódicamente a la función de cambio de estado por medio de un temporizador.

```c
void blinky(void *arg)
{
    static uint8_t state = 0;
    state ^= 1;
    if (state) {
        GPIO_OUTPUT_SET(2, 1);
    } else {
        GPIO_OUTPUT_SET(2, 0);
    }
}

void ICACHE_FLASH_ATTR user_init(void) {
    PIN_FUNC_SELECT(PERIPHS_IO_MUX_GPIO2_U, FUNC_GPIO2);
    os_timer_disarm(&ptimer);
    os_timer_setfn(&ptimer, (os_timer_func_t *)blinky, NULL);
    os_timer_arm(&ptimer, 500, 1);
}
```

### Versión RTOS

La [**versión RTOS**](https://github.com/espressif/ESP8266_RTOS_SDK) se trata de un SDK con el **sistema operativo FreeRTOS** ([What is An RTOS?](https://www.freertos.org/about-RTOS.html)) ya integrado. Al principio puede parecer más complicado, pero después resulta muy práctico. Nuestro programa ahora es una tarea más y comparte recursos con otras tareas internas como la conexión wifi o la pila TCP/IP: [System Tasks](https://docs.espressif.com/projects/esp8266-rtos-sdk/en/latest/api-guides/system-tasks.html).

Según la versión, podemos ver en el SDK RTOS "estilos" de programación. El primero, **pre ESP-IDF** no se recomienda para nuevos desarrollos. El programa sería similar al anterior, salvo que en lugar de utilizar un temporizador empleamos funciones de RTOS; `vTaskDelay`, por ejemplo, espera una pausa.

```c
void user_init(void) {
    PIN_FUNC_SELECT(PERIPHS_IO_MUX_GPIO2_U, FUNC_GPIO2);
    
    while(true) {
        GPIO_OUTPUT_SET(2, 0);
        vTaskDelay(500/portTICK_RATE_MS);
        GPIO_OUTPUT_SET(2, 1);
        vTaskDelay(500/portTICK_RATE_MS);
    }
}
```

### Versión ESP-IDF

Por último tenemos el **estilo ESP-IDF** dentro del SDK RTOS. IDF significa, según Espressif, *IoT Development Framework*. Es la **versión recomendada** y la única disponible para el ESP32. Aunque seguimos usando RTOS, hay algunas **diferencias**. El código del usuario ya no está en `user_init` sino en `app_main`; la configuración de puertos ya no se hace con macros sino usando funciones y estructuras.

```c
void app_main()
{
    gpio_config_t io_conf;
    io_conf.pin_bit_mask = GPIO_Pin_2;
    io_conf.mode = GPIO_MODE_OUTPUT;
    gpio_config(&io_conf);

    while(true) {
        gpio_set_level(GPIO_NUM_2, 1);
        vTaskDelay(500/portTICK_PERIOD_MS);
        gpio_set_level(GPIO_NUM_2, 0);
        vTaskDelay(500/portTICK_PERIOD_MS);
    }
}
```

### Instalación

Las instrucciones de instalación y enlaces están en la web de Espressif [Get Started - v3.3](https://docs.espressif.com/projects/esp8266-rtos-sdk/en/release-v3.3/get-started/index.html). Lo primero es descargar los tres componentes:

- El **entorno msys32** (incluye la toolchain para esp32, pero no la del ESP8266 que habremos de instalar aparte)
- La **última versión estable del SDK RTOS** (ya es estilo ESP-IDF), a día de hoy la versión 3.3. En mi experiencia como principiante es mejor descargar la [última versión estable](https://github.com/espressif/ESP8266_RTOS_SDK/releases) de la SDK RTOS, en lugar de hacer *clone* del repositorio de desarrollo.
- La **toolchain** de Xtensa lx106 acorde a la **versión** del SDK. Para la RTOS-v3.3 es la v5.2.0. No nos serviría la gcc-8.4.0 por ejemplo.

{% include image.html  file="toolchain-ficheros.png" caption="Entorno de desarrollo, SDK y *toolchain*. EyC." %}

A continuación, brevemente:

1. Descomprimir el **entorno msys32** en algún sitio, da igual.
1. Descomprimir la **SDK** en algún punto dentro de la jerarquía de directorios msys32, por ejemplo `/opt`. Fijar la **variable `IDF_PATH`** en `.bashrc` para indicar dónde la hemos puesto.

       export IDF_PATH=/opt/ESP8266_RTOS_SDK

1. Descomprimir la **toolchain lx106** en algún punto dentro de la jerarquía de directorios msys32, por ejemplo `/opt`. Incluir **en el path** su directorio bin:

       export PATH="$PATH:/opt/xtensa-lx106-elf/bin"

1. Por último, actualizar los paquetes python necesarios:

       python -m pip install --user -r $IDF_PATH/requirements.txt

Ahora podemos probar si funciona copiando el ejemplo `hello_world` de la SDK a nuestro home:

       cp -r $IDF_PATH/examples/get-started/hello_world ~

e intentar compilarlo con `make menuconfig`, `make`, `make flash`.

{% include image.html  file="menuconfig.png" caption="El SDK emplea el sistema *kconfig* con *lxdialog*. Un extra para nostálgicos. EyC." %}

## Esquema eléctrico

Usamos los chips de Espressif por su **conexión WiFi**. Proyectos obvios son leer datos de un sensor local y transmitirlos a un servidor remoto vía Internet; y viceversa, leer datos de Internet y visualizarlos en una pantalla. Nuestro proyecto hoy es del segundo tipo.

Los componentes principales son el módulo ESP-01S, un LCD de 4x20 como visor y un buzzer piezoeléctrico para hacer sonar un aviso acústico. Tanto el módulo ESP-01S como el visor LCD integran casi toda la electrónica. El esquema eléctrico se limita a acondicionarlos.

{% include image.html file="esp-bus-retocado.jpg" caption="Esquema eléctrico del *avisador de autobuses*. EyC." %}

Necesitaremos 5V de alimentación ya que nuestro **LCD no funciona a 3.3V**. Hay módulos LCD con una pequeña bomba de carga instalada que funcionan a 3.3, pero el nuestro no la lleva. 

El **ESP8266 requiere 3.3V**, no pudiendo superar nunca los 3.6V de máximo, con picos de 200mA. Suele usarse un regulador lineal o conmutado de 3.3V. Pero mi forma de ver la electrónica no consiste en **comprar y juntar piezas** como un juego de Lego; sino en resolver un problema aprendiendo a usar los componentes de que dispones. Como el objetivo no es maximizar la duración de la batería (de serlo no usaríamos el ESP-01S ni un LCD retroiluminado), he optado por transistores y un divisor resistivo. 

Es inviable regular **200mA** de forma estable con un divisor y un transistor. Podríamos usar dos transistores en [**configuración Darlington**](https://es.wikipedia.org/wiki/Transistor_Darlington). O mejor aún, un *par Darlignton complementario* o [**configuración Sziklai**](https://en.wikipedia.org/wiki/Sziklai_pair). Es como el Darlington pero usando **un transistor NPN y otro PNP**. En este gráfico veis la comparación entre ambas configuraciones y cómo la tensión de salida se mantiene más estable en esta última.

{% include image.html file="v_szklai_darlington.png" caption="Tensión a la salida del regulador frente a consumo. Comparación entre las configuraciones Darlington (rojo) y Szklai (verde). EyC." %}

En ausencia de consumo, cuando retiramos el módulo de su socket, la tensión podría superar los 3.6V. Lo evitamos haciendo circular una mínima corriente a través de **R3**.

**C1**, **C2**, **R4** y **R5** son redundantes porque nuestro módulo ESP-01S ya incorpora estos componentes. 

No está previsto recibir comandos vía puerto serie, así que hemos **reasignado la patilla RX** como salida para la alarma. La salida **TX** sí la conservamos para emitir mensajes de depuración.

En cuanto al puerto I2C, no es necesario usar **conversor de tensión** porque I2C es un puerto de **colector abierto** (*open drain*). Eso significa que, aunque la LCD funciona a 5V, lo único que hará es poner a masa o no la línea de datos. Por tanto sus 5V no alcanzan nunca al integrado. Por otra parte, el controlador I2C del LCD detectará un valor positivo si excede la mitad de la tensión de alimentación. Y en este caso, 3.3V es mayor que 2.5V.

Montar el esquema en una placa SMD es muy sencillo pero prefiero hacer el prototipo con componentes *through hole*.

{% include image.html file="espbus-parts.jpg" caption="Componentes necesarios para construir el avisador. EyC." %}

Así ha quedado una vez soldados los componentes:

{% include image.html file="board-esp01s.jpg" caption="Placa con los componentes montados y módulo ESP-01S. EyC." %}

## El software

Describir todo el programa línea por línea sería largo y aburrido. El proyecto completo está en [electronicayciencia/esp8266-learning](https://github.com/electronicayciencia/esp8266-learning/tree/main/esp_bus). Vamos a dividirlo en partes y comentar lo más relevante. Si quieres preguntarme algo concreto déjame **un comentario**.

Lo primero, leer de un **API online**. Los tiempos de espera están disponibles públicamente en el [portal Opendata de Mobilitylabs](https://mobilitylabs.emtmadrid.es/es/portal/opendata) de EMT Madrid. El mismo que usan otras aplicaciones similares para móvil. Lo cual implica:

- Obtener un **ClientId y password** de consumo. Esto fue fácil ya que es un proceso online aunque requiere aprobación manual.
- Conectar a la **wifi** usando usuario y contraseña. Hay un ejemplo en el SDK.
- Conectar con una web **HTTPS**. Hay un ejemplo en el SDK. Cuidado con los certificados.
- Usar autorización básica. De esto no hay ejemplo, pero se trata de añadir una cabecera.
- Recibir la respuesta en **JSON** e interpretarla usando cJSON. De esto no hay ejemplo pero la librería cJSON está bien documentada. Eso sí, necesitas manejarte bien en *C* o te liarás con los punteros. Lo mejor es probar esa parte en otro programa fuera del ESP.

Ahora hay que **visualizar** los datos en una pantalla LCD de 4x20 caracteres.

- El display está conectado por I2C. Si bien el ESP8266 no tiene puerto I2C, lo imita por software. La **librería I2C** es peculiar porque funciona con colas de comandos. Pero hay ejemplos y todo está documentado en la web.
- La LCD se controla a través de un **expansor PCF8574**. No es difícil adaptar mi [librería I2C LCD para Raspberry Pi](https://www.electronicayciencia.com/wPi_soft_lcd/) al ESP8266.
- Además del tiempo de espera, quiero mostrar un **contador con los segundos** desde la última actualización. Eso es contar el tiempo transcurrido, no hay documentación pero resultó sencillo con `time`.
- Hay varias formas de actualizar unas partes de la LCD sin sobrescribir otras. Yo he usado un **buffer** a modo de **memoria de vídeo**.

La ejecución del programa consta de tres tareas paralelas:

- Una tarea se **conecta al API** y lee los datos cada pocos segundos. Formatea la información y actualiza los campos en el buffer de video.
- Otra **cuenta los segundos** transcurridos desde la última actualización. Formatea el dato y actualiza su parte de la memoria de video.
- Una tercera tarea **actualiza la LCD** con los datos presentes en el buffer en cada momento. Sólo esta función interactúa con el puerto I2C.

También quería hacer sonar un **aviso acústico** si el tiempo de espera es inferior a 5 minutos:

- He generado un tono de **1000Hz por medio del PWM**. El ESP8266 no tiene PWM pero lo imita por software. **Funciona regular**; puedes usarlo con una frecuencia baja siempre y cuando no tengas el ADC activo, ni el sniffer WiFi.
- Lanzamos la alarma dentro de una **tarea en segundo plano** para no bloquear el resto del programa mientras suena.

Algunas posibles mejoras podrían ser usar WPS a la hora de conectar con la WiFi; en lugar de usuario y password en el código. O también un servidor HTTP para modificar la configuración: cambiar de línea, parada, contraseña del API, tiempos de alarma, etc.

{% include image.html file="usb-board-display.jpg" caption="Avisador montado y conectado a un *power-bank*." %}

## Troubleshooting

Déjame contarte un par de problemas surgidos mientras hacía el proyecto. Como pasa muchas veces, la solución es obvia cuando la sabes. Pero en su momento me llevaron más tiempo del que me hubiera gustado.

### Primer problema

Tras portar la [librería wPi_soft_lcd](https://www.electronicayciencia.com/wPi_soft_lcd/) de wiringPi a ESP-IDF, en las primeras pruebas **el módulo LCD se ilumina, la luz se enciende y se apaga cuando se lo ordenamos por I2C, pero no muestra ningún carácter, se queda en blanco.**

1. Tengo unos LED conectados a las líneas de I2C para ver cuándo hay señal. Podrían interferir, los quito. No funciona.
1. Saco el analizador lógico para mirar la transmisión. La señal parece correcta. Pero el mensaje es largo y mirándolo a ojo es fácil pasar por alto un error. Probemos otra cosa.
1. El LCD podría estar estropeado. Lo conecto a la Raspberry y lanzo el [ejemplo 20x04 de wPi_soft_lcd](https://www.electronicayciencia.com/wPi_soft_lcd/#example_20x4c). El ejemplo sí funciona. No es problema de la pantalla.
1. Puede que los datos enviados sean incorrectos. Modifico el programa en el ESP para escribir [en formato i2cli](https://www.electronicayciencia.com/wPi_soft_i2c/#i2clic) los mismos comandos que transmitiría por I2C.
1. Reproduzco en la Raspberry tales comandos. **Funciona.** Luego la trasmisión es correcta y el LCD va bien.
1. Podría ser la alimentación. Desconecto el LCD de la alimentación a 5V y lo conecto a una patilla de 3.3v. Lanzo de nuevo el ejemplo: esta vez no funciona.

Ese era el problema: los módulos LCD requieren una tensión de 5V y yo no lo sabía. [Converting 5v LCDs to 3.3v](https://www.element14.com/community/groups/roadtest/blog/2019/06/15/converting-5v-lcds-to-33v).

### Segundo problema

Cuando por fin consigo mostrar algo en la pantalla, resulta que **empieza a dar errores la wifi y no conecta**.

1. Podría ser de la WiFi de pruebas. Cambio a la red principal, pero falla también.
1. Reinicio el *router*: sigue fallando.
1. Tal vez el consumo del LCD sumado al del ESP8266 sea demasiado para el conversor USB-Serie. Quito la pantalla. Funciona. Va a ser eso.
1. Añado un condensador más grande para mitigar la caída de tensión en picos. Vuelve a fallar.
1. Desconecto el positivo del LCD, pero dejo el negativo. Ahora la pantalla no está consumiendo nada: falla también. No va a ser del consumo.
1. Quito también el negativo. Ahora funciona. No tiene sentido.

El problema era que tenía los cables del LCD demasiado cerca de la antena WiFi en la protoboard. Moviéndolos a otra posición funciona correctamente. La antena siempre debe quedar lo más libre posible, pues tener partes metálicas cercanas a ella reduce mucho su rendimiento.

## Referencias

Tensilica/Cadence

- [Tensilica Customizable Processors](https://ip.cadence.com/ipportfolio/tensilica-ip/xtensa-customizable)
- [Diamond Standard 106Micro](https://ip.cadence.com/news/243/330/Tensilica-Unveils-Diamond-Standard-106Micro-Processor-Smallest-Licensable-32-bit-Core)
- [Brief de la arquitectura Xtensa 9](https://web.archive.org/web/20111114012640/http://www.tensilica.com/uploads/pdf/X9.pdf)
- [Brief de Diamond Standard 106Micro Controller](https://web.archive.org/web/20111114025833/http://www.tensilica.com/uploads/pdf/106Micro.pdf)

Espressif

- [Datasheet de esp8266ex](https://www.espressif.com/sites/default/files/documentation/0a-esp8266ex_datasheet_en.pdf)
- [ESP8266EX - Frequently Asked Questions](https://www.espressif.com/sites/default/files/documentation/Espressif_FAQ_EN.pdf)
- [SDK Versión **NONOS**](https://github.com/espressif/ESP8266_NONOS_SDK)
- [SDK Versión **RTOS**](https://github.com/espressif/ESP8266_RTOS_SDK)
- [ESP8266 Get Started - v3.3](https://docs.espressif.com/projects/esp8266-rtos-sdk/en/release-v3.3/get-started/index.html)
- [System Tasks](https://docs.espressif.com/projects/esp8266-rtos-sdk/en/latest/api-guides/system-tasks.html)
- [espressif/esptool Serial-Protocol](https://github.com/espressif/esptool/wiki/Serial-Protocol)
- [Announcing ESP32-S3 for AIoT Applications](https://www.espressif.com/en/news/ESP32_S3)

Wikipedia

- [FCC mark](https://en.wikipedia.org/wiki/FCC_mark)
- [SLIP](https://es.wikipedia.org/wiki/Serial_Line_Internet_Protocol)
- [lwip](https://en.wikipedia.org/wiki/LwIP)
- [Configuración **Darlington**](https://es.wikipedia.org/wiki/Transistor_Darlington)
- [Configuración **Sziklai**](https://en.wikipedia.org/wiki/Sziklai_pair)
- [Balun](https://en.wikipedia.org/wiki/Balun)

Repositorios GitHub

- [libsodium](https://github.com/jedisct1/libsodium)
- [cJSON](https://github.com/DaveGamble/cJSON)
- [Jeija esp_wifi_80211_tx sample code](https://github.com/Jeija/esp32-80211-tx)
- [NodeMCU 3.0.0 - A Lua based firmware for ESP8266 WiFi SOC](https://github.com/nodemcu/nodemcu-firmware)

Varios

- [Linux Xtensa](http://www.linux-xtensa.org/).
- [What is An RTOS?](https://www.freertos.org/about-RTOS.html)
- [datasheet del módulo ESP-01S]({{page.assets | relative_url}}/ESP8266_01S_Modul_Datenblatt.pdf)
- [Getting Started with the ESP8266](https://medium.com/@aallan/getting-started-with-the-esp8266-270e30feb4d1)
- [How to directly program an inexpensive ESP8266 Wifi Module - hackaday.com](https://hackaday.com/2015/03/18/how-to-directly-program-an-inexpensive-esp8266-wifi-module/)
- [Portal Opendata de Mobilitylabs EMT Madrid](https://mobilitylabs.emtmadrid.es/es/portal/opendata)
- [Nodemcu, la popular placa de desarrollo con ESP8266](https://www.luisllamas.es/esp8266-nodemcu/)

Artículos y proyectos propios

- [La presión atmosférica - BPM280]({{site.baseurl}}{% post_url 2018-10-07-la-presion-atmosferica-bmp280 %})
- [Tu primer proyecto con DSP]({{site.baseurl}}{% post_url 2020-06-21-tu-primer-proyecto-con-dsp %})
- [librería I2C LCD para Raspberry Pi](https://www.electronicayciencia.com/wPi_soft_lcd/)
- [electronicayciencia/esp8266-learning](https://github.com/electronicayciencia/esp8266-learning)













