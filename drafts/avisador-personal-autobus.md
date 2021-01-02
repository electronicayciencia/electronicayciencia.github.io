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


Hoy vamos a hablar del ESP8266. Un microcontrolador pensado para IoT. Repasaremos los comienzos de este integrado. Os contaré en qué consiste la arquitectura Xtensa. Y construiremos un pequeño proyecto para explorar el SDK del fabricante ESP-IDF.

Os propongo un visor con alarma de tiempos de llegada para el autobús. Se trata de leer los tiempos de llegada desde el API al igual que haría una aplicación móvil. Y mostrarlo en una LCD de 4x20. Aunque variando el origen de datos podríamos mostrar cualquier variable disponible en Internet. Desde el precio de un activo a la información meteorológica.

{% include image.html class="medium-width" file="board-display-cropped.jpg" caption="Avisador de autobuses construido con el módulo ESP-01." %}

## Breve resumen histórico

En 2013, un fabricante chino de microchips llamado Espressif lanzó un microcontrolador. El ESP8266. Un tanto limitado pero barato y con conexión WiFi. Poco tiempo después, otra compañía china dedicada a IoT (*Internet of Things*) llamada AI-Thinker sacó al mercado un módulo con los componentes necesarios para hacer funcionar el ESP8266. Principalmente memoria externa, cuarzo y antena. Lo llamó ESP-01. Incorporó una aplicación con comandos Hayes y lo vendió como **módem WiFi AT para Arduino**. Igual que usamos módems AT GSM para enviar y recibir SMS desde un microcontrolador, este serviría para conectar con una red inalámbrica.

{% include image.html class="medium-width" file="esp-01-3d.jpg" caption="Módulo ESP-01S. fuente: <http://aliexpress.com>." %}

El ESP8266 no era atractivo para los fabricantes occidentales. Toda la documentación estaba en chino. Las primeras versiones del SDK parecían algo inestables y las herramientas de desarrollo tenían fallos. Además, no contaba con el certificado de compatibilidad electromagnética ([FCC mark](https://en.wikipedia.org/wiki/FCC_mark)) por tanto cualquier producto comercial basado en ellos debía someterse a un proceso de homologación para poder venderlo en EEUU o Europa. Otros fabricantes ya tenían sus propias soluciones de conectividad WiFi.

A diferencia de otros microcontroladores, el ESP8266 carece de memoria Flash interna. En su lugar tiene un **bootloader**. Este programa es el único que está grabado dentro del integrado. El resto está en una memoria Flash externa. El bootloader inicializa el chip, carga el programa contenido en la Flash y lo ejecuta. No sólo eso, también permite leer y escribir la memoria. Eso hacía al módulo ESP-01 fácilmente **reprogramable**. AI-Thinker, con buen criterio, había dejado accesibles las 3 patillas necesarias. Pronto se corrió la voz de que se podía sustituir el firmware AT de fábrica por cualquier otro usando nada más que un puerto serie.

¿Un microcontrolador minúsculo, rápido, con conectividad WiFi, que no requiere un programador especial y por poco más de 1 dólar? Tenía un enorme potencial en el mercado de aficionados. Sólo había que ponérselo fácil. AI-Thinker había sacado otros modelos de su ESP-01 con más patillas disponibles. **NodeMCU** liberó en 2014 un firmware para programar el ESP8266 en lenguaje Lua. Las tiendas chinas se llenaron de placas de desarrollo integrando los módulos de AI-Thinker con conversores USB-Serie como el CP2102. Poco después, NodeMCU comenzó a vender también sus propias placas con el módulo ESP-12 y su firmware Lua instalado.

[imagen: mcu-devboard.jpg Placa de desarrollo basada en un módulo ESP8266. Fuente: Amazon.es]

Se formó una importante comunidad alrededor del ESP8266. Tradujeron al inglés la documentación más importante. Programaron una versión de micropython compatible. Se actualizó el IDE de **Arduino** para soportar las placas disponibles. Espressif, al ver que su mercado principal eran fabricantes de módulos para aficionados, lanzó los suyos propios ya con certificación FCC. Puso en marcha foros de colaboración, liberó algunas especificaciones y ha ido publicando varias versiones de la SDK (kit de desarrollo). 

Cinco años después, los chips de Espressif, especialmente el ESP32 y recientemente el ESP32-S3, son sinónimos de IoT y *AIoT*. Ignoro si están preparados para el mercado electrodoméstico de consumo. En cualquier caso, ponérselo fácil a los aficionados de hoy es asegurarse ventas mañana. Porque los futuros ingenieros acabarán incorporando en sus diseños aquello que conocen.


## El núcleo Xtensa

Según el datasheet, la CPU del ESP8266 es un core LX106 de Xtensa. Xtensa es un modelo de **núcleo RISC** vendido por Tensilica (ahora Cadence Design Systems). Vamos a detenernos un momento a apreciar el grado de abstracción que ha alcanzado la industria de componentes electrónicos.

Eres una empresa que fabrica componentes. Y necesitas un microcontrolador *con algo*. Por ejemplo con transmisor WiFi. O tienes un **hardware específico** y piensas que sería muy práctico tener la capacidad de interpretar en él un juego de instrucciones. O sea, hacerlo programable. Pero tu no fabricas microcontroladores. Podrías contratar a Microchip o Texas Instruments para hacerte un micro incluyendo las instrucciones que quieres para tu hardware. Pero suena muy, muy caro.

Otra opción **desarrollarlo** tú. Un juego de instrucciones específicas para tu hardware junto a otras de propósito general. Luego tendrías que implementar los componentes de la CPU: el ciclo de instrucción (*fetch decode execute*), los registros, la ALU, las interrupciones, modos de trabajo, etc. Hacerte tu compilador y tus herramientas de desarrollo. Millones de dólares en formación, años de esfuerzo y depuración de errores. También suena muy, muy caro.

O podrías **comprar** todo eso ya hecho y probado. Únicamente lo que es una CPU personalizada. Con un juego de instrucciones básicas y otras definidas por el usuario. Los registros que tú quieras, los buses que tú quieras, hardware opcional. Eso es justo lo que Tensilica comercializa: [Tensilica Customizable Processors](https://ip.cadence.com/ipportfolio/tensilica-ip/xtensa-customizable).

{% include image.html class="medium-width" file="lx6-processor-arch-diagram.png" caption="Arquitectura Tensilica Xtensa LX6. <https://www.cadence.com/>." %}

Esta es la **arquitectura Tensilica Xtensa LX6**. En la que se basa el ESP8266. El ESP32 ya se basa en la LX7 ya que la anterior quedó obsoleta. Los bloques en **azul oscuro** son los componentes básicos. Incluyen:

- el ciclo de instrucción para 32 bits
- un juego de instrucciones básico (*ISA: Instruction Set Architecture*). Son 80 instrucciones RISC comunes a todos los núcleos de Xtensa. Lo que te garantiza es que no necesitarás hacerte un compilador especial y podrás usar herramientas de desarrollo compatibles.
- una unidad aritmético-lógica sencilla de 32 bits.
- soporte de excepciones y control del procesador.

Luego tienes otros componentes que puedes configurar a tu gusto añadir o quitar. Por nombrar algunos:

- ¿MAC de 16 bits? (*multiply accumulator*, si no te suena la instrucción MAC, echa un vistazo a [Tu primer proyecto con DSP]({{site.baseurl}}{% post_url 2020-06-21-tu-primer-proyecto-con-dsp %}))
)
- ¿Unidad de punto flotante? ¿precisión simple o doble? Para recordar cosas sobre la FPU lee [La presión atmosférica - BPM280]({{site.baseurl}}{% post_url 2018-10-07-la-presion-atmosferica-bmp280 %}).

- ¿Registros directos para GPIO?
- Temporizadores ¿cuantos?
- ¿Puerto JTAG para depuración?
- Periféricos, ¿lo quieres con I2C, SPI, I2C, etc? ¿cuántos de cada?
- ¿Cuántos bancos de RAM? ¿Cuántas interrupciones, de qué tipo?

Hay un montón de opciones y módulos configurables:

{% include image.html class="medium-width" file="lx6-processor-options.png" caption="Opciones de configuración para la arquitectura Xtensa LX6." %}

Para cosas más complejas puedes añadir cores de DSP. O por ejemplo para ejecutar un Sistema Operativo sofisticado necesitarás una Unidad de Gestión de Memoria. Su función es traducir direcciones de memoria virtuales a físicas y facilitar protección de memoria, paginación etc. Tienen una compatible con Linux. Pero hasta donde yo sé ni el ESP8266 ni el ESP32 hasta ahora la incluyen. Por lo que no podemos **ejecutar Linux** en ellos y sí en otros chips de Xtensa.

Te dejo un enlace al datasheet de la arquitectura LX6 por si tienes curiosidad. En la web de Cadence encontrarás las especificaciones para LX7. [Xtensa LX6 Customizable DPU]({{page.assets | relative_url}}/Cadence_Tensillica_Xtensa_LX6_ds.pdf).


El ESP8266 es un core RISC LX6 básico al que han acoplado un transmisor/receptor de radio.

{% include image.html class="medium-width" file="esp8266ex-blocks.png" caption="Diagrama de bloques del ESP8266EX. [Fuente](https://www.espressif.com/sites/default/files/documentation/0a-esp8266ex_datasheet_en.pdf)." %}












{% include image.html class="medium-width" file="esp01s-module-cropped.jpg" caption="" %}






presentación esp8266
 - basado en Xtensa (microcontrolador extensible)
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


