---
no-title: Avisador personal de autobuses
layout: post
assets: /assets/drafts/2021/01/avisador-personal-autobus
image: /assets/drafts/2021/01/avisador-personal-autobus/img/esp01s-module-croppped.jpg
featured: false
tags:
  - Circuitos
  - Informática
  - ESP8266
---


Hoy vamos a hablar del ESP8266. Un microcontrolador pensado para IoT. Repasaremos sus comienzos. Os contaré en qué consiste la arquitectura Xtensa. Montaremos el entorno ESP-IDF y haremos un proyecto para explorar el SDK de Espressif. Os propongo un visor de tiempos de llegada para el autobús con alarma. Pero serviría para cualquier variable disponible en Internet. Desde el precio de un activo a la información meteorológica.

{% include image.html file="board-display-cropped.jpg" caption="Avisador de autobuses construido con el módulo ESP-01S. EyC." %}

## Introducción

Sobre el ESP8266 se ha escrito mucho. Fue revolucionario cuando salió y se puso rápidamente de moda. Luego fue superado por el ESP32, más potente y con Bluetooth, y el 8266 pasó a un segundo plano.

En 2013, un fabricante chino de microchips llamado Espressif lanzó un microcontrolador. El ESP8266. Un tanto limitado pero barato y con conexión WiFi. Poco tiempo después, otra compañía china dedicada a IoT (*Internet of Things*) llamada AI-Thinker sacó al mercado un módulo con los componentes necesarios para hacer funcionar el ESP8266. Principalmente memoria externa, cuarzo y antena. Lo llamó ESP-01. Incorporó una aplicación con comandos Hayes y lo vendió como **módem WiFi AT para Arduino**. Igual que usamos módems AT GSM para enviar y recibir SMS desde un microcontrolador, este serviría para conectar con una red inalámbrica.

{% include image.html file="esp-01-3d.jpg" caption="Módulo ESP-01S. [Aliexpress](http://aliexpress.com)." %}

El ESP8266 no era atractivo para los fabricantes occidentales. Toda la documentación estaba en chino. Las primeras versiones del SDK parecían algo inestables y las herramientas de desarrollo tenían fallos. Además, no contaba con el certificado de compatibilidad electromagnética ([FCC mark](https://en.wikipedia.org/wiki/FCC_mark)) por tanto cualquier producto comercial basado en ellos debía someterse a un proceso de homologación para poder venderlo en EEUU o Europa. Otros fabricantes ya tenían sus propias soluciones de conectividad WiFi.

A diferencia de otros microcontroladores, el ESP8266 carece de memoria Flash interna. En su lugar tiene un **bootloader**. Este programa es el único que está grabado dentro del integrado. El resto está en una memoria Flash externa. El bootloader inicializa el chip, carga el programa contenido en la Flash y lo ejecuta. No sólo eso, también permite leer y escribir la memoria. Eso hacía al módulo ESP-01 fácilmente **reprogramable**. AI-Thinker, con buen criterio, había dejado accesibles las 3 patillas necesarias. Pronto se corrió la voz de que se podía sustituir el firmware AT de fábrica por cualquier otro usando nada más que un puerto serie.

¿Un microcontrolador minúsculo, rápido, con conectividad WiFi, que no requiere un programador especial y por poco más de 1 dólar? Tenía un enorme potencial en el mercado de aficionados. Sólo había que ponérselo fácil. AI-Thinker había sacado otros modelos de su ESP-01 con más patillas disponibles. **NodeMCU** liberó en 2014 un firmware para programar el ESP8266 en lenguaje Lua. Las tiendas chinas se llenaron de placas de desarrollo integrando los módulos de AI-Thinker con conversores USB-Serie como el CP2102. Poco después, NodeMCU comenzó a vender también sus propias placas con el módulo ESP-12 y su firmware Lua instalado.

{% include image.html file="mcu-devboard.jpg" caption="Placa de desarrollo ESP8266 basada en un módulo de AI-Thinker. [Amazon](http://www.amazon.es)." %}

Se formó una importante comunidad alrededor del ESP8266. Tradujeron al inglés la documentación más importante. Programaron una versión de micropython compatible. Se actualizó el IDE de **Arduino** para soportar las placas disponibles. Espressif, al ver que su mercado principal eran los fabricantes de módulos para aficionados, lanzó los suyos propios ya con certificación FCC. Puso en marcha foros de colaboración, liberó algunas especificaciones y ha ido publicando varias versiones de la SDK (kit de desarrollo). 

Cinco años después, los chips de Espressif, especialmente el ESP32 y recientemente el ESP32-S3, son sinónimos de IoT y *AIoT*. Ignoro si están preparados para el mercado electrodoméstico de consumo. En cualquier caso, ponérselo fácil a los aficionados de hoy es asegurarse ventas mañana. Porque los futuros ingenieros acabarán incorporando en sus diseños aquello que conocen.


## El núcleo Xtensa

Según el datasheet, la CPU del ESP8266 es un core LX106 de Xtensa. Xtensa es un modelo de **núcleo RISC** vendido por Tensilica (ahora Cadence Design Systems). Vamos a detenernos un momento a apreciar el grado de abstracción que ha alcanzado la industria de componentes electrónicos.

Eres una empresa que fabrica componentes. Y necesitas un microcontrolador *con algo*. Por ejemplo con transmisor WiFi. O tienes un **hardware específico** y piensas que sería muy práctico tener la capacidad de interpretar en él un juego de instrucciones. O sea, hacerlo programable. Pero tu no fabricas microcontroladores. Podrías contratar a Microchip o Texas Instruments para hacerte un micro incluyendo las instrucciones que quieres para tu hardware. Pero suena muy, muy caro.

Otra opción es **desarrollarlo** tú. Un juego de instrucciones específicas para tu hardware junto a otras de propósito general. Luego tendrías que implementar los componentes de la CPU: el ciclo de instrucción (*fetch decode execute*), los registros, la ALU, las interrupciones, modos de trabajo, etc. Hacerte tu compilador y tus herramientas de desarrollo. Suma el coste de la formación, años de esfuerzo y depuración de errores. También suena muy, muy caro.

O podrías **comprar** esa parte ya hecha y probada. Únicamente lo que es una CPU personalizada. Con un juego de instrucciones básicas y otras definidas por el usuario. Los registros que tú quieras, los buses que tú quieras, hardware opcional. Eso es justo lo que Tensilica comercializa: [Tensilica Customizable Processors](https://ip.cadence.com/ipportfolio/tensilica-ip/xtensa-customizable).

{% include image.html file="lx6-processor-arch-diagram.png" caption="Arquitectura Tensilica Xtensa LX6. [Cadence](https://www.cadence.com/)." %}

Esta es la **arquitectura Tensilica Xtensa LX6**. En la que se basa el ESP8266. El ESP32 ya emplea la LX7. Los bloques en **azul oscuro** son los componentes básicos. Incluyendo:

- el ciclo de instrucción para 32 bits
- un juego de instrucciones básico (*ISA: Instruction Set Architecture*). Son 80 instrucciones RISC comunes a todos los núcleos de Xtensa. Lo que te garantiza es que no necesitarás hacerte un compilador especial y podrás usar herramientas de desarrollo compatibles.
- una unidad aritmético-lógica sencilla de 32 bits.
- soporte de excepciones y control del procesador.

Luego tienes otros componentes que puedes configurar a tu gusto añadir o quitar. Por nombrar algunos:

- ¿MAC de 16 bits? (*multiply accumulator*, si no te suena la instrucción MAC, echa un vistazo a la entrada titulada [Tu primer proyecto con DSP]({{site.baseurl}}{% post_url 2020-06-21-tu-primer-proyecto-con-dsp %}))
- ¿Unidad de punto flotante? ¿precisión simple o doble? Para recordar cosas sobre la FPU lee [La presión atmosférica - BPM280]({{site.baseurl}}{% post_url 2018-10-07-la-presion-atmosferica-bmp280 %}).
- ¿Registros directos para GPIO?
- Temporizadores ¿cuantos?
- ¿Puerto JTAG para depuración?
- Periféricos, ¿lo quieres con I2C, SPI, I2C, etc? ¿cuántos de cada?
- ¿Cuántos bancos de RAM? ¿Cuántas interrupciones, de qué tipo?

Hay un montón de opciones y módulos configurables:

{% include image.html file="lx6-processor-options.png" caption="Opciones de configuración para la arquitectura Xtensa LX6." %}

Para cosas más complejas puedes añadir cores de DSP. O por ejemplo para ejecutar un Sistema Operativo sofisticado necesitarás una Unidad de Gestión de Memoria. Su función es traducir direcciones de memoria virtuales a físicas y facilitar protección de memoria, paginación etc. Tienen una compatible con Linux. Pero hasta donde yo sé ni el ESP8266 ni el ESP32 hasta ahora la incluyen. Por lo que no podemos **ejecutar Linux** en ellos y sí en otros chips de Xtensa.

Te dejo un enlace al datasheet de la arquitectura LX6 por si tienes curiosidad. En la web de Cadence encontrarás las especificaciones para LX7. [Xtensa LX6 Customizable DPU]({{page.assets | relative_url}}/Cadence_Tensillica_Xtensa_LX6_ds.pdf).

El ESP8266 es un core Xtensa estándar de 32-bit a 80 MHz con:

- 64kb de RAM de instrucciones *iRAM*
- 96kb de RAM para datos *dRAM*
- Puerto QSPI para memoria flash externa capaz de direccionar hasta 16 Mb
- Periféricos:
  - Hasta 16 pines GPIO (funciones compartidas con otros periféricos)
  - SPI
  - I2C (sólo intercomunicación en bus interno, por ejemplo para el PLL)
  - Interfaz I2S con DMA
  - 2 UART
  - 1 conversor ADC de 10-bit (hasta 1V máximo)
- Etapa de radio formada por:
  - transceptor de 2.4GHz IEEE 802.11 b/g/n
  - amplificador RF
  - [Balun](https://en.wikipedia.org/wiki/Balun)

{% include image.html file="esp8266ex-blocks.png" caption="Diagrama de bloques del ESP8266EX. [Espressif](https://www.espressif.com/sites/default/files/documentation/0a-esp8266ex_datasheet_en.pdf)." %}

El hecho de tener WiFi ofrece unas posibilidades muy interesantes. Ya sea para conectar a Internet u otras aplicaciones menos ortodoxas. Se pueden recibir y enviar paquetes 802.11 en crudo (sin procesar). Este proyecto usa llamadas al API para construir balizas WiFi de Access Points falsos con nombres inventados: [Jeija esp_wifi_80211_tx sample code](https://github.com/Jeija/esp32-80211-tx).

{% include image.html class="small-width" file="rick-roll-beacon.jpg" caption="" %}


## El módulo ESP-01S

Cuando puedo, prefiero utilizar los componentes por separado en lugar de placas de desarrollo y librerías. Sin embargo, el integrado ESP8266:

- No tiene memoria Flash ni oscilador interno, por tanto siempre va acompañado de una flash externa y un cuarzo.
- Sólo se fabrica en encapsulado QFN de 32 (5 mm x 5 mm). Difícil de soldar. Hasta es más complicado comprarlo suelto que en un módulo.
- Emite RF. Su salida WiFi opera a 2.4GHz y no es práctico trabajar con frecuencias altas en una protoboard.

Voy a usar un módulo ESP-01S que contiene sólo los componentes necesarios para hacer funcionar el chip de Espressif.

{% include image.html file="esp01s-module-cropped.jpg" caption="Módulo ESP-01S, detalle de los componentes. EyC." %}

He obtenido manualmente el esquema de uno de mis módulos. Si necesitáis ampliarlo, os lo dejo en formato vectorial en este archivo: [ESP01S.svg]({{page.assets | relative_url}}/ESP01S.svg). Algunos valores difieren del esquema oficial proporcionado en el [datasheet]({{page.assets | relative_url}}/ESP8266_01S_Modul_Datenblatt.pdf). 

{% include image.html file="esp01s-retocado.jpg" caption="Esquema del módulo ESP-01S. EyC." %}

Los tres elementos principales son el integrado, la memoria flash (en este caso de 1Mb) y el cuarzo. El resto son componentes pasivos. 

El ESP8266 puede requerir hasta 200mA durante la transmisión WiFi. La resistencia de los conductores de alimentación hasta la fuente causa un descenso brusco de la tensión de alimentación cuando hay un aumento significativo del consumo. Los condensadores **C1**, **C2** y **C3** sirven para amortiguar esta caída y también para cortocircuitar picos de alta frecuencia, evitando que viajen por la alimentación y se propaguen a otras partes del circuito.

**R3** mantiene a positivo la patilla de reset. Cuando cortocircuitamos a masa esta patilla, **C4** se descarga rápidamente y la tensión en el pin 32 del integrado cae a 0. Al retirar el cortocircuito, **C4** pasa a cargarse a través de **R3**. Luego la entrada continuará a nivel bajo durante un instante; cumpliendo con el tiempo mínimo que requiere el chip para detectar un reinicio.

**R2**, **R3**, **R4** y **R6** configuran el modo de operación del dispositivo. De esto hablaremos más adelante. El **LED** de GP2 sólo sirve para hacerlo parpadear cuando estamos empezando.

Por último, la bobina **L1** junto a **C7** y **C8** llevan la señal de RF hacia la antena. La **antena** está impresa directamente en la placa y uno de sus brazos va conectado a masa. Este diseño se llama "F invertida", concretamente *meandered inverted-F PCB antenna*. Es un diseño habitual que encontramos también en otros módulos para 2.4GHz. Como el nRF24L01.

{% include image.html file="nrf24l01_module.png" caption="Módulo nRF24L01 con un factor de forma muy similar al ESP01 y mismo tipo de antena. [Sunfounder](http://wiki.sunfounder.cc/index.php?title=NRF24L01_Test_with_Arduino)." %}


## El bootloader

Cuando alimentamos un microcontrolador, comienza a ejecutarse el programa que lleva grabado. Si queremos ejecutar otro programa distinto debemos borrar este y programar el nuestro con las **herramientas específicas** del fabricante o compatibles. Por ejemplo un programador PICkit para microcontroladores PIC. Si no contamos con ellas, no podremos reprogramar el integrado.

Una alternativa más **flexible** es usar un cargador de arranque, conocido en inglés como ***bootloader***. Consiste en sustituir el programa principal por un programa secundario que se ejecuta primero en su lugar. Cuando alimentemos el micro, se ejecutará el programa que lleva grabado, o sea, el bootloader. Desde este cargaremos y pasaremos el control al programa principal, que puede estar en la memoria flash del micro o -si no tiene- en una flash externa.

Si el micro lo permite, además de lanzar el programa principal, en el bootloader podemos dejar programadas **otras utilidades**; tal como fijar opciones de configuración o leer y escribir en la memoria flash. Así podemos modificar el programa principal contenido en ella sin necesidad de usar herramientas especiales, simplemente interactuando con el chip durante el arranque. Una buena idea es cargar temporalmente en la RAM **código arbitrario** y ejecutarlo. Con eso conseguimos la capacidad de ampliar el cargador, añadíendole funciones adicionales en el futuro. Mientras más versátil sea, menos probable es que necesitemos reemplazarlo.

El ESP8266 lleva este método al extremo. El micro no posee memoria flash, su cargador está en una memoria de solo lectura (ROM) y no es modificable -o no sabemos cómo-. De hecho, podríamos decir que el ESP8266 no es programable: es un core Xtensa con radio, memoria RAM y un bootloader.

¿Cómo sabe el cargador si debe ejecutar el programa principal o ponerse a escuchar comandos? Por los **niveles lógicos** en las patillas 13, 14 y 15 (MTDO o GP15, GP2 y GP0). Hay tres patillas, ocho combinaciones, ocho modos de arranque distintos indicados en el documento [ESP8266EX - Frequently Asked Questions](https://www.espressif.com/sites/default/files/documentation/Espressif_FAQ_EN.pdf).

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

Sólo nos interesan los modos 1 y 3, *Flash Boot*, arranque del programa contenido en la memoria flash y *UART Boot*, escuchar comandos serie. Del resto no he encontrado documentación. Escogeremos entre uno y otro variando el nivel lógico en la entrada GP0 durante el arranque.

Volviendo al esquema del módulo ESP-01S, arriba, la patilla GPIO15 o MTDO está permanentemente a 0 por resistencia **R6**. GPIO2 está puesta a 1 a través de **R2** y el **LED**. Y GPIO0 está a 1 por **R3**. Para entrar en modo programación usaremos un circuito como este:

{% include image.html class="medium-width" file="programar-esp01.png" caption="" %}

Nuestro módulo ya incorpora las resistencias de pull-up **R1**, **R2** y **R3**; también podemos omitir **C1**. **RX** y **TX** lo conectaremos a un conversor USB-Serie. Por defecto, las patillas TX y RX del chip están configuradas como salida y entrada respectivamente. Pero se pueden configurar de otra manera por software y de hecho lo haremos. Si el conversor USB-Serie intenta transmitir un valor a una patilla que está, a su vez, configurada como salida podría producirse un cortocircuito y dañar el integrado. **R4** y **R5** limitan la corriente en este caso.

Si al liberar el pulsador *reset* tenemos presionado *prog* entraremos en modo programación (*UART Boot*); de lo contrario arrancaremos en modo normal.

El bootloader de Espressif entiende comandos [SLIP](https://es.wikipedia.org/wiki/Serial_Line_Internet_Protocol) (*Serial Line Internet Protocol*). La interfaz está documentada en [espressif/esptool](https://github.com/espressif/esptool/wiki/Serial-Protocol). Para interactuar con él nos proporcionan la herramienta **esptool**.

El programa principal tampoco se carga directamente. En la memoria flash hay otro bootloader. Entre otras cosas permite actualizar el firmware remotamente (OTA).


## Entorno de desarrollo

Vamos a programar el ESP8266 según lo indicado por el fabricante, es decir, utilizando el entorno ESP-IDF (lenguaje C). Si prefieres hacerlo en Arduino, micropython, Basic, LUA u otros el procedimiento será distinto y -seguramente- más simple.

El entorno ESP-IDF me ha **sorprendido para bien**. Cuenta con múltiples ejemplos funcionales. Casi todo es código abierto. La pila TCP/IP se basa en [lwip](https://en.wikipedia.org/wiki/LwIP). Incorpora librerías bien conocidas como [cJSON](https://github.com/DaveGamble/cJSON) o [sodium](https://github.com/jedisct1/libsodium). Además de otras que parecen escritas por Espressif como *esp-mqtt* o la de log. En general parece coherente.

Para crear un programa binario capaz de ejecutarse en un microcontrolador necesitamos:

- La **toolchain** específica de la plataforma, Xtensa lx106 en este caso. Comprende el *compilador*, el *linker* (o link-editor), ensamblador, depurador y algunas librerías básicas (como la *librería de C estándar*).
- El **SDK** (Software Development Kit). Ahí van las rutinas propias del dispositivo, o los ficheros de cabeceras si nos las dan ya compiladas. Los drivers, por ejemplo, para acceder a sus periféricos hardware (capa PHY), entradas GPIO, WiFi, SPI o I2C. Suele incluir ejemplos de uso, así como los scripts de compilación y linkado.
- El **entorno de desarrollo** son el resto de programas y herramientas sobre las que se apoyan los componentes anteriores. Digamos *cmake*, *bash*, *python* u *openssl*. A veces también el IDE si va junto como pasa con Arduino o MPLab.

El entorno nativo de desarrollo es Linux con Eclipse. Yo voy a usar Visual Studio Code sabiendo que estará peor integrado. Si trabajas en Linux sólo tendrás que instalar los paquetes necesarios. Si trabajas en Windows, como es mi caso, Espressif ofrece un entorno msys32 (que pesa más de 600Mb comprimido) con el entorno preinstalado.

Desde 2015 el SDK ha pasado por varias versiones y distintos estilos. Es importante tenerlo en cuenta a la hora de mirar en foros ejemplos de proyectos.

- [Versión **NONOS**](https://github.com/espressif/ESP8266_NONOS_SDK): Es un SDK simple, lineal. El primero en ser publicado y sobre él están desarrolladas las librerías de Arduino para el ESP8266. Se considera obsoleto desde diciembre de 2019 y recomiendan usar la versión RTOS.
- [Versión **RTOS**](https://github.com/espressif/ESP8266_RTOS_SDK). Se trata de un SDK con el sistema operativo RTOS integrado. Hay dos "estilos" de programación:
  - Estilo *pre ESP-IDF*: Versión inferior a 3.0. Tiene una forma de programación similar a la NonOS. No se recomienda para nuevos desarrollos.
  - Estilo **ESP-IDF**: Versión 3.0 o superior. Han unificado el estilo de programación entre ESP8266 y ESP32. IDF significa, según Espressif, *IoT Development Framework*. Es la versión recomendada y la única disponible para el ESP32.

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

Podríamos omitir **C1**, **C2**, **R4** y **R5** porque nuestro módulo ESP-01S ya trae estos componentes. No está previsto recibir comandos vía puerto serie, así que hemos reasignado la patilla RX como salida para la alarma. La salida UART sí la conservamos para emitir registros de depuración.

Montar el esquema en una placa SMD es muy sencillo pero prefiero hacer el prototipo con componentes *through hole*.

{% include image.html file="espbus-parts.jpg" caption="Componentes listos para soldar. EyC." %}

Así ha quedado una vez soldados los componentes:

{% include image.html file="board-esp01s.jpg" caption="Placa con los componentes y módulo ESP-01S. EyC." %}


## El software

Describir todo el programa línea a línea sería largo aburrido. Tampoco pretendo resumir en un artículo la documentación de Espressif. Como el código está en GitHub, te voy a contar los puntos principales y si quieres preguntarme algo me dejas un comentario.

Podemos dividir el proyecto en varias partes:

- Leer de un **API online** los tiempos de espera de una línea de autobuses en determinada parada. Eso requiere:
  - Conectar a la **wifi** al menos usando usuario y contraseña. WPS preferible.
  - Conectar con una web **HTTPS** usando autorización básica.
  - Recibir la respuesta en **JSON** e interpretarla usando cJSON.
- **Visualizarlos** en una pantalla LCD de 4x20 caracteres.
  - La pantalla usa **I2C**. El ESP8266 no tiene puerto I2C, lo imita por software.
  - La LCD no se controla directamente sino a través de un **expansor PCF8574**. Reutilizaré mi [librería I2C LCD para Raspberry Pi](https://www.electronicayciencia.com/wPi_soft_lcd/) adaptándola para este chip.
- Mantener la información actualizada **periódicamente**.
  - Necesito saber cómo lanzar varias **tareas en paralelo** en RTOS.
  - Para actualizar unas partes de la LCD sin sobrescribir otras reservaré **buffer** a modo de memoria de vídeo.
- Hacer sonar un **aviso acústico** si el tiempo es inferior a 5 minutos.
  - Usare **PWM**. El ESP8266 no tiene PWM pero lo imita por software (siempre que no tengas el ADC activo, ni el sniffer WiFi y para una frecuencia suficientemente baja).
  - Además habrá que lanzar la **tarea en segundo plano** para que no se bloquee la LCD mientras suena la alarma.





[electronicayciencia/esp8266-learning](https://github.com/electronicayciencia/esp8266-learning)

completa, muchos componenetes, cjson, log, libsodium, 

rtos


## Notas borrador


{% include image.html file="esp01s-module-cropped.jpg" caption="" %}
[Xtensa LX6 Customizable DPU]({{page.assets | relative_url}}/Cadence_Tensillica_Xtensa_LX6_ds.pdf).
[La presión atmosférica - BPM280]({{site.baseurl}}{% post_url 2018-10-07-la-presion-atmosferica-bmp280 %}).




presentación esp8266
 - no tiene flash. Se vende en modulos con flash + cuarzo + chip + componentes RF (+ led), esquema
 - esp01 para modem at com wifi
 - deja enviar y recibir paquetes wifi arbitrarios
 
 - bootloader en rom (no se puede modificar o no dicen cómo, lee los pines gpio15, 0 y 2 escoge el modo de arranque, se comunica mediante slip, permite leer/escribir flash, cargar código etc.)
 - segunda etapa en flash (lanza programa, u ota si es preciso)
 - flash contiene:
  - nv storage
  - bootloader
  - programa
  - otras cosas


esquema
 - complementary feedback pair, also known as a Sziklai pair
 - relacion 1:3 para el regulador
 - para pullup resistencias de las que no sé para que usar
 - no problema en I2C +5V porque pullup sólo el master, no los esclavos.

montar entorno de desarrollo:
 - toolkit: compilador, link editor, debugger, etc.
 - sdk: librería de c estandar, funciones core hardware (ejemplo 802.1), drivers de periféricos, bootloader, etc.
 - sdk versiones: nonOS (deprecated, en esta se basa arduino), RTOS antigua (pre-1.6) y esp-idf. Dentro de esp-idf, version 3.3 estable y última versión.
 - herramienta para flash, incluido en sdk

 - platformIO entorno alternativo, versión sdk antigua, no permite menuconfig.
 - esp-idf usa eclipse. config con vscode en windows al menos los includes.


descripción del programa:
 cosas que saber:
  - programar el chip y uso básico de gpio (ejemplo blinky)
  - uart, para depuración (ESP_LOG, ejemplo en SDK)
  - conexión a la wifi (ejemplo en sdk)
  - cliente http, cliente https (ejemplo en SDK)
  - cJSON para manejo de la respuesta (no ejemplo, pero lib incluida en SDK).
  - i2c para control de LCD (ejemplo I2C, mi propia librería LCD con expansor de puertos)
  - rtos combinar tareas (ejemplo en SDK)
   
 tareas principales (múltiples formas, esta es una)
  - refresco lcd
  - mantenimiento del tiempo transcurrido
  - contacto con api, mantenimiento de los autobuses próximos y alertado.
   
 bugs:
  - algunos bugs al flash o al compilar, pero pueden deberse a versión antigua.
















Pasos para publicar un draft:
 - Mover los assets de /assets/drafts/titulo-del-post a /assets/yyyy/mm/titulo-del-post
 - Cambiar en el post las variables assets e image.
 - Cambiar la variable no-title por title.
 - Mover el post de /drafts/titulo-del-post.md a /_posts/yyyy-mm-dd-titulo-del-post.md
 - git add, commit, push


