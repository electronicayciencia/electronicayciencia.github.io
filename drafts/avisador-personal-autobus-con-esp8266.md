---
no-title: Avisador personal de autobús con ESP8266
layout: post
assets: /assets/drafts/2021/01/avisador-personal-autobus-con-esp8266
image: /assets/drafts/2021/01/avisador-personal-autobus-con-esp8266/img/esp01s-module-croppped.jpg
featured: false
tags:
  - Circuitos
  - Informática
  - ESP8266
---

Hoy vamos a hablar del **ESP8266**. Un microcontrolador pensado para *IoT*. Repasaremos sus comienzos. Os contaré en qué consiste la arquitectura Xtensa. Montaremos el **entorno ESP-IDF**. Exploraremos el SDK de Espressif haciendo un visor de tiempo de espera para el autobús, con alarma. Aunque serviría para cualquier variable en tiempo real, desde el precio de un activo a la información meteorológica.

{% include image.html file="board-display-cropped.jpg" caption="Avisador de autobuses construido con el módulo ESP-01S. EyC." %}

## Introducción

En 2013, una empresa china llamada Espressif lanzó el microcontrolador ESP8266. Un chip limitado en memoria y periféricos pero barato, con conexión WiFi y fácil de usar.

Poco tiempo después, otra compañía también china dedicada a *Internet of Things* llamada AI-Thinker sacó al mercado un módulo con ESP8266 y los componentes necesarios. Principalmente memoria externa, cuarzo y antena. Lo llamó ESP-01. Incorporó una aplicación con comandos Hayes y lo vendió como **módem WiFi AT para Arduino**. El propósito era conectar con una red inalámbrica de igual modo que usamos módems AT GSM para enviar y recibir SMS desde un micro.

{% include image.html file="esp-01-3d.jpg" caption="Módulo ESP-01S. [Aliexpress](http://aliexpress.com)." %}

El ESP8266 no era atractivo para los fabricantes occidentales. Los diseñadores ya tenían sus propias soluciones de conectividad WiFi. Toda la documentación estaba en chino. Las primeras versiones del SDK parecían inestables y las herramientas de desarrollo tenían fallos. Tampoco contaba con el certificado de compatibilidad electromagnética ([FCC mark](https://en.wikipedia.org/wiki/FCC_mark)) y cualquier producto comercial basado en ellos debía someterse a un proceso de homologación para venderse en EEUU o Europa. 

Pero a diferencia de otros microcontroladores, el ESP8266 carece de memoria Flash interna. En su lugar tiene un **bootloader**. Hablaremos de él más adelante. Lo que en principio parecía una desventaja hacía al módulo ESP-01 fácilmente **reprogramable**. Pronto se corrió la voz de que se podía sustituir el firmware AT de fábrica por cualquier otro usando nada más que un puerto serie.

¿Un microcontrolador minúsculo, rápido, con conectividad WiFi, que no requiere un programador especial y por poco más de 1 dólar? Tenía un enorme potencial en el mercado de aficionados (*makers*). Sólo había que ponérselo fácil. AI-Thinker había sacado otros modelos de su ESP-01 con más patillas disponibles. **NodeMCU** liberó en 2014 un firmware para programar el ESP8266 en lenguaje Lua. Las tiendas chinas se llenaron de placas de desarrollo con los módulos de AI-Thinker, un regulador de tensión y un conversor USB-Serie como el CP2102. Poco después, NodeMCU comenzó a vender también sus propias placas con el módulo ESP-12 y su firmware Lua preinstalado.

{% include image.html file="mcu-devboard.jpg" caption="Placa de desarrollo ESP8266 basada en un módulo de AI-Thinker. [Amazon](http://www.amazon.es)." %}

Una importante comunidad creció alrededor del ESP8266. Tradujeron al inglés parte de la documentación. Programaron una versión de micropython. Se actualizó el IDE de **Arduino** para soportar las placas existentes. Espressif, al ver que su mercado principal eran los fabricantes de módulos, lanzó los suyos propios ya con certificación FCC. Puso en marcha foros de colaboración, liberó algunas especificaciones y ha ido abriendo progresivamente el código de sus SDK (kit de desarrollo).

El ESP8266 fue revolucionario cuando salió y se puso de moda rápidamente. Cinco años después, los chips de Espressif, especialmente el ESP32 y recientemente el ESP32-S3, son sinónimos de IoT y *AIoT*. Aún no se ven muchos en el mercado electrodoméstico de consumo. En cualquier caso, ponérselo fácil a los aficionados de hoy es asegurarse ventas mañana. Porque los futuros ingenieros acabarán incorporando en sus diseños aquello que conocen.

## El núcleo Xtensa

Según el datasheet, la CPU del ESP8266 es un core Xtensa 106 micro. Xtensa es un modelo de **núcleo RISC** producto de la empresa Tensilica (ahora Cadence Design Systems). Xtensa no es un microcontrolador, es un núcleo suelto que te venden para que lo incorpores en tu integrado si lo necesitas.

Supón que tienes una empresa de componentes y has hecho un **hardware específico** con su correspondiente controlador. Sería muy práctico hacerlo programable para poder actualizar el firmware en el futuro. Podrías usar un microcontrolador ya existente, pero el rendimiento no sería óptimo. Seguro que le faltarán o le sobrarán cosas. Por no decir que ahora tienes dos chips en vez de uno. ¿Contratas a Microchip o Texas Instruments y les pides un micro a medida para ti?

Otra opción es **desarrollarlo** tú en una FPGA por ejemplo. Ponerte a pensar un juego de instrucciones específicas y otras de propósito general. Luego deberás implementar los componentes de la CPU: el ciclo de instrucción (*fetch decode execute*), los registros, la ALU, las interrupciones, modos de trabajo, etc. Hacerte tu propio compilador y tus herramientas de desarrollo para tus instrucciones. Ahora optimízalo para que tenga un **área de silicio** mínima, bajo **consumo** y un precio asequible. Suma el coste de la formación, años de esfuerzo y depuración de errores, etc. Suena muy caro.

O podrías **comprar** esa parte ya hecha y probada. Únicamente lo que es una CPU para incorporarla a tu chip. Con un juego de instrucciones básicas más otras definidas por ti. Los registros que tú quieras, los buses que tú quieras, hardware opcional. Eso es justo lo que Tensilica comercializa: [Tensilica Customizable Processors](https://ip.cadence.com/ipportfolio/tensilica-ip/xtensa-customizable).

> The Xtensa 9 processor, in its smallest configuration, is just 0.024 mm2 with 12 uW/MHz average dynamic power post place & route in 40 LP process technology at 60 MHz.

Por supuesto se venden opciones preconfiguradas. El ESP8266 sería un [Diamond Standard 106Micro](https://ip.cadence.com/news/243/330/Tensilica-Unveils-Diamond-Standard-106Micro-Processor-Smallest-Licensable-32-bit-Core), la configuración más baja de la arquitectura Xtensa 9. El ESP32, su sucesor, utiliza la arquitectura LX6 y los ESP32-S2 y S3 usan LX7.

{% include image.html file="lx6-processor-arch-diagram.png" caption="Arquitectura Tensilica Xtensa LX6 usada por el ESP32. [Cadence](https://www.cadence.com/)." %}

En **azul oscuro** tenemos los componentes básicos, los más importantes son:

- el ciclo de instrucción para 32 bits.
- un juego de instrucciones básico (*ISA: Instruction Set Architecture*). Consta de 80 instrucciones comunes a todos los núcleos de Xtensa. Dicho de otra manera, te servirán las herramientas de desarrollo compatibles y no tendrás que hacerte un compilador especial.
- una unidad aritmético-lógica sencilla de 32 bits.
- soporte de excepciones y control del procesador.

Luego tienes otros componentes configurables. Por ejemplo:

- ¿MAC de 16 bits? (*multiply accumulator*, si no te suena la instrucción MAC, echa un vistazo a la entrada titulada [Tu primer proyecto con DSP]({{site.baseurl}}{% post_url 2020-06-21-tu-primer-proyecto-con-dsp %}))
- ¿Unidad de punto flotante? ¿de precisión simple o doble? Para recordar cosas sobre la FPU lee [La presión atmosférica - BPM280]({{site.baseurl}}{% post_url 2018-10-07-la-presion-atmosferica-bmp280 %}).
- Temporizadores ¿cuantos?
- Periféricos, ¿lo quieres con I2C, SPI, I2S? ¿cuántos de cada? ¿Puerto JTAG para depuración?
- ¿Y bancos de RAM, interrupciones, pipeline, ...?

{% include image.html file="lx6-processor-options.png" caption="Opciones de configuración para la arquitectura Xtensa LX6." %}

También puedes comprar y añadirle cores de DSP. O una Unidad de Gestión de Memoria si quieres ejecutar un Sistema Operativo sofisticado. Su función es traducir direcciones de memoria virtuales a físicas y facilitar protección de memoria, paginación etc. Tienen una compatible con Linux, pero hasta donde yo sé ni el ESP8266 ni el ESP32 la incluyen. Por este motivo no podemos **ejecutar Linux** en estos procesadores pero sí en otros chips de Xtensa: [Linux Xtensa](http://www.linux-xtensa.org/).

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

El hecho de tener WiFi ofrece unas posibilidades muy interesantes. No sólo puede actuar como Access Point o como estación (cliente). Sino que recibe y envía paquetes **802.11 en crudo** (sin procesar). De ahí su uso en **ataques** contra infraestructura WiFi dado que los paquetes de *deautenticación* no van cifrados y se pueden falsificar. El siguiente proyecto usa llamadas al API 802.11 para construir balizas WiFi falsas con nombres aleatorios: [Jeija esp_wifi_80211_tx sample code](https://github.com/Jeija/esp32-80211-tx).

{% include image.html class="small-width" file="rick-roll-beacon.jpg" caption="Access Points falsos simulados por el ESP8266. EyC." %}

## El módulo ESP-01S

Es más sencillo encontrar el ESP8266 formando parte de algún módulo que por separado. Es lógico porque **carece de memoria Flash**, por tanto siempre debe ir acompañado de una memoria externa y un cuarzo. Además de una red de adaptación de impedancias y la antena o conector.

El módulo ESP-01S contiene tan sólo los componentes anteriores. Necesarios para hacer funcionar el chip de Espressif. Aquí podéis ver una fotografía ampliada.

{% include image.html file="esp01s-module-cropped.jpg" caption="Módulo ESP-01S, detalle de los componentes. EyC." %}

He obtenido manualmente el esquema de uno de mis módulos. Algunos valores difieren del esquema oficial proporcionado en el [datasheet]({{page.assets | relative_url}}/ESP8266_01S_Modul_Datenblatt.pdf). Si necesitas ampliarlo, te lo dejo en formato vectorial en este archivo: [ESP01S.svg]({{page.assets | relative_url}}/ESP01S.svg).

{% include image.html file="esp01s-retocado.jpg" caption="Esquema del módulo ESP-01S. EyC." %}

Los condensadores **C1**, **C2** y **C3** sirven para estabilizar la tensión de alimentación en los picos de consumo y cortocircuitar las altas frecuencias, evitando que se propaguen por la alimentación a otras partes del circuito.

**R3** mantiene a positivo la patilla de *reset*. Cuando presionamos el pulsador de **reset** cortocircuitamos a masa esta patilla, **C4** se descarga rápidamente y la tensión en el pin 32 del integrado cae a 0. Al liberar el pulsador, **C4** se carga de nuevo a través de **R3**. Esto se hace para evitar rebotes (*de-bouncing*). Mientras dure la carga, el procesador continuará en estado *reset*. 

**R2**, **R3**, **R4** y **R6** configuran el modo de operación del dispositivo. Lo veremos en el apartado siguiente. Por último, la bobina **L1** junto a **C7** y **C8** llevan la señal de RF hacia la antena. Se trata de una **antena** impresa directamente en la placa y conectada a masa por uno de sus brazos. Es una variante del diseño en "F invertida" y se llama *meandered inverted-F PCB antenna*.

## El bootloader

Nada más activar un microcontrolador, este comienza a ejecutar el programa que lleva grabado. Para cambiar dicho programa necesitamos un programador adecuado. Por ejemplo un programador PICkit para microcontroladores PIC.

Una alternativa más **flexible** es usar un cargador de arranque, conocido en inglés como ***bootloader***. Consiste en sustituir el programa principal por un programa secundario que se ejecuta antes. Cuando alimentemos el micro, se ejecutará dicho bootloader y será él quien cargue el programa principal y le pase el control. Así el programa puede estar en la memoria flash del micro o bien en una flash externa.

No sólo eso, en el bootloader podemos dejar programadas **otras utilidades** aparte de la carga del programa principal; por ejemplo escribir en la memoria flash. Ahora para modificar el programa principal ya no habría necesidad de usar ningún programador, solamente enviar los comandos adecuados al bootloader.

El ESP8266 lleva este método al extremo. El micro no posee memoria flash, su cargador está en una memoria de solo lectura (ROM) y no es modificable -o no sabemos cómo-. De hecho, podríamos decir que el ESP8266 no es programable: es un core Xtensa con radio, memoria RAM y un bootloader.

¿Cómo sabe el cargador si debe ejecutar el programa principal o ponerse a escuchar comandos? Por los **niveles lógicos** en las patillas 13, 14 y 15 (MTDO o GP15, GP2 y GP0). Hay tres patillas, ocho combinaciones, ocho modos de arranque distintos ([ESP8266EX - Frequently Asked Questions](https://www.espressif.com/sites/default/files/documentation/Espressif_FAQ_EN.pdf)).

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

Sólo nos interesan los modos 1 y 3, *Flash Boot*, arranque del programa contenido en la memoria flash y *UART Boot*, escuchar comandos serie. Volviendo al esquema del módulo ESP-01S, arriba, la patilla GPIO15 o MTDO está permanentemente a 0 por resistencia **R6**. GPIO2 está puesta a 1 a través de **R2** y el **LED**. Y GPIO0 está a 1 por **R3**. Para entrar en modo programación usaremos un circuito como este:

{% include image.html class="medium-width" file="programar-esp01.png" caption="" %}

Podríamos omitir **R1**, **R2** y **R3** y **C1** porque nuestro módulo ya incorpora estos componentes. Conectaremos **RX** y **TX** a un conversor USB-Serie. **R4** y **R5** son para limitar la corriente en caso de que alguna de estas patillas este configurada como salida en vez de como entrada.

Si al liberar el pulsador *reset* tenemos presionado *prog* entraremos en modo programación (*UART Boot*); de lo contrario arrancaremos en modo normal.

El bootloader de Espressif entiende comandos [SLIP](https://es.wikipedia.org/wiki/Serial_Line_Internet_Protocol) (*Serial Line Internet Protocol*). La interfaz está documentada en [espressif/esptool](https://github.com/espressif/esptool/wiki/Serial-Protocol). Para interactuar con él nos proporcionan la herramienta **esptool**.

Pero el programa principal tampoco se invoca directamente. En la memoria flash hay un segundo bootloader. Entre otras cosas permite actualizar el firmware remotamente (OTA).

## Entorno de desarrollo

Vamos a programar el ESP8266 según lo indicado por el fabricante, es decir, utilizando el entorno ESP-IDF (lenguaje C). Si prefieres hacerlo en Arduino, micropython, Basic, LUA u otros el procedimiento será distinto y -seguramente- más simple.

El entorno ESP-IDF me ha **sorprendido para bien**. Cuenta con múltiples ejemplos funcionales. Casi todo es código abierto. La pila TCP/IP se basa en [lwip](https://en.wikipedia.org/wiki/LwIP). Incorpora librerías bien conocidas como [cJSON](https://github.com/DaveGamble/cJSON) o [sodium](https://github.com/jedisct1/libsodium). Además de otras que parecen escritas por Espressif como *esp-mqtt* o la de log. En general parece coherente.

Para crear un programa binario capaz de ejecutarse en un microcontrolador necesitamos:

- La **toolchain** específica de la plataforma, Xtensa lx106 en este caso. Comprende el *compilador*, el *linker* (o link-editor), ensamblador, depurador y algunas librerías básicas (como la *librería de C estándar*).
- El **SDK** (Software Development Kit). Ahí van las rutinas propias del dispositivo, o los ficheros de cabeceras si nos las dan ya compiladas. Los drivers, por ejemplo, para acceder a sus periféricos hardware (capa PHY), entradas GPIO, WiFi, SPI o I2C. Suele incluir ejemplos de uso, así como los scripts de compilación y linkado.
- El **entorno de desarrollo** son el resto de programas y herramientas sobre las que se apoyan los componentes anteriores. Digamos *cmake*, *bash*, *python* u *openssl*. A veces también el IDE si va junto como pasa con Arduino o MPLab.

El entorno nativo de desarrollo es Linux con Eclipse. Yo voy a usar Visual Studio Code sabiendo que estará peor integrado. Si trabajas en Linux sólo tendrás que instalar los paquetes necesarios. Si trabajas en Windows, como es mi caso, Espressif ofrece un entorno msys32 (que pesa más de 600Mb comprimido) con el entorno preinstalado.

Desde 2015 el SDK ha pasado por varias versiones y distintos estilos. Es importante tenerlo en cuenta a la hora de mirar en foros ejemplos de proyectos.

[Versión **NONOS**](https://github.com/espressif/ESP8266_NONOS_SDK): Es un SDK simple, lineal. El primero en ser publicado y sobre él están desarrolladas las librerías de Arduino para el ESP8266. Se considera obsoleto desde diciembre de 2019 y recomiendan usar la versión RTOS. Así seria el código para hacer **parpadear un LED** en esta versión.

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

El código del usuario está en la función `user_init`. Se configura el pin como salida usando la macro `PIN_FUNC_SELECT` y con un temporizador  se llama periódicamente a la función de cambio de estado. El pin se activa y desactiva con la macro `GPIO_OUTPUT_SET`.

[Versión **RTOS**](https://github.com/espressif/ESP8266_RTOS_SDK). Se trata de un SDK con el sistema operativo RTOS ([What is An RTOS?](https://www.freertos.org/about-RTOS.html)). Muy sencillo de usar y más con los ejemplos. Hay dos "estilos" de programación según la versión. Al primero llamémosle *pre ESP-IDF* (inferior a 3.0). Se programa de forma parecida a la NonOS. No se recomienda para nuevos desarrollos. El código para hacer parpadear un led sería así:

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

El código del usuario está en la función `user_init`, y la configuración es igual que antes. Solo que esta vez, en lugar de utilizar un temporizador y una subrutina, hacemos un bucle con el retardo de RTOS `vTaskDelay`.

Finalmente tenemos el estilo **ESP-IDF**. Versión 3.0 o superior. Han unificado el estilo de programación con el SDK del ESP32. IDF significa, según Espressif, *IoT Development Framework*. Es la **versión recomendada** y la única disponible para el ESP32. Así haríamos parpadear un LED, aunque el estilo anterior sigue funcionando aquí:

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

Como en el caso anterior, seguimos usando RTOS. Pero el código del usuario ya no está en `user_init` sino en `app_main`. La configuración del puerto se hace con la función `gpio_config` y no con macros; al igual que el estado lógico con `gpio_set_level`.

Las instrucciones para descargar e instalar los componentes están en la web de Espressif: [Get Started - v3.3](https://docs.espressif.com/projects/esp8266-rtos-sdk/en/release-v3.3/get-started/index.html). Te lo describo brevemente. Lo primero es descargar los tres componentes:

- El entorno msys32 (viene con la toolchain para esp32, pero no la del ESP8266)
- La última versión estable del SDK RTOS (ya es estilo ESP-IDF), a día de hoy la versión 3.3. En mi experiencia como principiante es mejor descargar la [última versión estable](https://github.com/espressif/ESP8266_RTOS_SDK/releases) de la SDK RTOS, en lugar de hacer *clone* del repositorio de desarrollo.
- La *toolchain* de Xtensa lx106 para ESP8266 adecuada según la **versión** del SDK, para la RTOS-v3.3 es la v5.2.0. No nos serviría la gcc-8.4.0 por ejemplo.

{% include image.html  file="toolchain-ficheros.png" caption="Entorno de desarrollo, SDK y *toolchain*. EyC." %}

Y seguidamente:

1. Descomprimir el entorno msys32 en algún sitio, da igual.
1. Descomprimir la SDK en algún punto dentro de la jerarquía de directorios msys32, por ejemplo `/opt`. Fijar la variable `IDF_PATH` en `.bashrc` para indicar dónde la hemos puesto.

       export IDF_PATH=/opt/ESP8266_RTOS_SDK

1. Descomprimir la toolchain para lx106 en algún punto dentro de la jerarquía de directorios msys32, por ejemplo `/opt`. Incluir en el path su directorio bin:

       export PATH="$PATH:/opt/xtensa-lx106-elf/bin"

1. Actualizar los paquetes python necesarios:

       python -m pip install --user -r $IDF_PATH/requirements.txt

Con esto ya podemos copiar el ejemplo `hello_world` de la SDK a nuestro home:

       cp -r $IDF_PATH/examples/get-started/hello_world ~

y configurar las opciones -como el puerto serie o la contraseña de la wifi- con `make menuconfig`, compilarlo, etc.

{% include image.html  file="menuconfig.png" caption="La configuración del SDK usa el sistema *kconfig* con *lxdialog*. Un extra para nostálgicos. EyC." %}

## Esquema eléctrico

Usamos los chips de Espressif por su conexión WiFi. Proyectos obvios son leer datos de un sensor local y transmitirlos a un servidor remoto vía Internet; y viceversa, leer datos de Internet y visualizarlos en una pantalla. Nuestro proyecto hoy es del segundo tipo.

Como componente central usaremos el módulo ESP-01S y un LCD de 4x20. Hemos incorporado un buzzer piezoeléctrico para hacer sonar un aviso acústico. Este sería el esquema (aquí en formato vectorial: [ESP-Bus.svg]({{page.assets | relative_url}}/ESP-Bus.svg)).

{% include image.html file="esp-bus-retocado.jpg" caption="Esquema eléctrico del *avisador de autobuses*. EyC." %}

Necesitaremos 5V de alimentación ya que nuestro LCD no funciona a 3.3V. Hay módulos LCD con una pequeña bomba de carga instalada que funcionan a 3.3, pero el nuestro no la lleva. El ESP8266 requiere 3.3V, no pudiendo superar nunca los 3.6V de máximo y con 200mA de corriente en pico. La opción más directa es reducir de 5 a 3.3V usando un regulador lineal. Pero hoy he preferido usar transistores.

Con un sólo transistor no vamos a poder ofrecer 200mA de forma estable. Será mejor usar dos en [configuración **Darlington**](https://es.wikipedia.org/wiki/Transistor_Darlington). Aunque hay una opción mejor, el *par Darlignton complementario* o [configuración **Sziklai**](https://en.wikipedia.org/wiki/Sziklai_pair). Es como el Darlington pero usando un transistor NPN y otro PNP. Como veis en la siguiente simulación, al aumentar el consumo la tensión de salida se mantiene más estable.

{% include image.html file="v_szklai_darlington.png" caption="Tensión a la salida del regulador frente a consumo. Comparación entre las configuraciones Darlington (rojo) y Szklai (verde). EyC." %}

Cuando retiramos el módulo del socket, en ausencia de consumo la tensión podría subir por encima de 3.6V. **R3** está ahí para suministrar un consumo mínimo y que eso no suceda.

Podríamos omitir **C1**, **C2**, **R4** y **R5** porque nuestro módulo ESP-01S ya trae estos componentes. No está previsto recibir comandos vía puerto serie, así que hemos reasignado la patilla RX como salida para la alarma. La salida sí la conservamos para emitir mensajes de depuración.

En cuanto a la salida I2C, no es necesario usar **conversor de tensión** porque es un puerto de colector abierto (*open drain*). Aunque la LCD funciona a 5V, lo único que hará es poner a masa o no la línea de datos. Por tanto sus 5V no alcanzan al integrado. Por otra parte, el controlador del LCD detecta un valor positivo si excede la mitad de la alimentación. Y 3.3V es mayor que 2.5V.

Montar el esquema en una placa SMD es muy sencillo pero prefiero hacer el prototipo con componentes *through hole*.

{% include image.html file="espbus-parts.jpg" caption="Componentes necesarios para construir el avisador. EyC." %}

Así ha quedado una vez soldados los componentes:

{% include image.html file="board-esp01s.jpg" caption="Placa con los componentes montados y módulo ESP-01S. EyC." %}

## El software

Describir todo el programa línea a línea sería largo y aburrido. Como el código está en GitHub, te voy a contar los puntos principales y si quieres preguntarme algo déjame un comentario.

El proyecto completo está en [electronicayciencia/esp8266-learning](https://github.com/electronicayciencia/esp8266-learning). Vamos a dividirlo en partes y comentar lo más relevante.

Leer de un **API online**. Los tiempos de espera están disponibles públicamente en el [portal Opendata de Mobilitylabs](https://mobilitylabs.emtmadrid.es/es/portal/opendata) de EMT Madrid. El mismo que usan las aplicaciones similares para móvil. Para lograrlo tuve que:

- Obtener un ClientId y password del API. Esto fue fácil ya que es un proceso online aunque requiere aprobación manual.
- Conectar a la **wifi** al menos usando usuario y contraseña. Hay un ejemplo en el SDK.
- Conectar con una web **HTTPS**. Hay un ejemplo en el SDK.
- Usar autorización básica. De esto no hay ejemplo, pero se trata de añadir una cabecera.
- Recibir la respuesta en **JSON** e interpretarla usando cJSON. De esto no hay ejemplo. La librería cJSON está bien documentada pero tienes que manejarte bien en *C* o te liarás con los punteros.

Ahora hay que **visualizar** los datos en una pantalla LCD de 4x20 caracteres. Para lo cual:

- El display está conectado por I2C. Si bien el ESP8266 no tiene puerto I2C, lo imita por software. La **librería I2C** es peculiar porque funciona con colas de comandos. Pero hay ejemplos y todo está documentado en la web.
- La LCD se controla a través de un **expansor PCF8574**. Adaptaré mi [librería I2C LCD para Raspberry Pi](https://www.electronicayciencia.com/wPi_soft_lcd/).
- Además del tiempo de espera, quiero mostrar un contador con los segundos desde la última actualización. Debo contar el **tiempo transcurrido**, no hay documentación pero resultó sencillo con `time`.
- Hay varias formas de actualizar unas partes de la LCD sin sobrescribir otras. Yo he usado un **buffer** a modo de memoria de vídeo.

La ejecución del programa consta de tres **tareas paralelas**:

- Una se **conectará al API** y leerá los datos cada pocos segundos. Actualiza la información en el buffer de video.
- Otra **cuenta los segundos** transcurridos desde la última actualización. Actualiza su parte de la memoria de video.
- Una tercera tarea **actualiza la LCD** con los datos del buffer en ese momento. Sólo esta interactúa con el puerto I2C.

También quería hacer sonar un **aviso acústico** si el tiempo de espera es inferior a 5 minutos.

- He generado un tono de 1000Hz usando **PWM**. El ESP8266 no tiene PWM pero lo imita por software. Funciona regular; puedes usarlo con una frecuencia baja siempre que no tengas el ADC activo, ni el sniffer WiFi.
- La alarma se lanzará en una **tarea en segundo plano** para no bloquear el resto del programa mientras suena.

Para terminar, aquí tenemos nuestro avisador:

{% include image.html file="usb-board-display.jpg" caption="" %}

## Referencias

Tensilica

- [Tensilica Customizable Processors](https://ip.cadence.com/ipportfolio/tensilica-ip/xtensa-customizable)
- [Diamond Standard 106Micro](https://ip.cadence.com/news/243/330/Tensilica-Unveils-Diamond-Standard-106Micro-Processor-Smallest-Licensable-32-bit-Core)
- [Brief de la arquitectura Xtensa 9](https://web.archive.org/web/20111114012640/http://www.tensilica.com/uploads/pdf/X9.pdf)
- [Brief de Diamond Standard 106Micro Controller](https://web.archive.org/web/20111114025833/http://www.tensilica.com/uploads/pdf/106Micro.pdf)

Espressif

- [Datasheet de esp8266ex](https://www.espressif.com/sites/default/files/documentation/0a-esp8266ex_datasheet_en.pdf)
- [ESP8266EX - Frequently Asked Questions](https://www.espressif.com/sites/default/files/documentation/Espressif_FAQ_EN.pdf)
- [ESP8266 Get Started - v3.3](https://docs.espressif.com/projects/esp8266-rtos-sdk/en/release-v3.3/get-started/index.html)
- [SDK Versión **NONOS**](https://github.com/espressif/ESP8266_NONOS_SDK)
- [SDK Versión **RTOS**](https://github.com/espressif/ESP8266_RTOS_SDK)
- [espressif/esptool](https://github.com/espressif/esptool/wiki/Serial-Protocol)

Wikipedia

- [FCC mark](https://en.wikipedia.org/wiki/FCC_mark)
- [SLIP](https://es.wikipedia.org/wiki/Serial_Line_Internet_Protocol)
- [lwip](https://en.wikipedia.org/wiki/LwIP)
- [configuración **Darlington**](https://es.wikipedia.org/wiki/Transistor_Darlington)
- [configuración **Sziklai**](https://en.wikipedia.org/wiki/Sziklai_pair)
- [Balun](https://en.wikipedia.org/wiki/Balun)

Repositorios GitHub

- [lib sodium](https://github.com/jedisct1/libsodium)
- [cJSON](https://github.com/DaveGamble/cJSON)
- [Jeija esp_wifi_80211_tx sample code](https://github.com/Jeija/esp32-80211-tx)
- [electronicayciencia/esp8266-learning](https://github.com/electronicayciencia/esp8266-learning)

Varios

- [Linux Xtensa](http://www.linux-xtensa.org/).
- [What is An RTOS?](https://www.freertos.org/about-RTOS.html)
- [portal Opendata de Mobilitylabs EMT Madrid](https://mobilitylabs.emtmadrid.es/es/portal/opendata)
- [datasheet del módulo ESP-01S]({{page.assets | relative_url}}/ESP8266_01S_Modul_Datenblatt.pdf)

Otros artículos y proyectos míos

- [Tu primer proyecto con DSP]({{site.baseurl}}{% post_url 2020-06-21-tu-primer-proyecto-con-dsp %})
- [La presión atmosférica - BPM280]({{site.baseurl}}{% post_url 2018-10-07-la-presion-atmosferica-bmp280 %})
- [librería I2C LCD para Raspberry Pi](https://www.electronicayciencia.com/wPi_soft_lcd/)













