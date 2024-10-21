---
title: Chips criptográficos de usar y tirar
layout: post
assets: /assets/2024/10/cripto-desechable
image: /assets/2024/10/cripto-desechable/img/atecc608.jpg
featured: false
description: Explicación y uso del ATECC608. Autenticación de consumibles. Cifrado por hardware. Ataques y defensas en microelectrónica.
tags:
  - Binario
  - Criptografía
  - Raspberry
---


Esto son muestras del ATECC608. Un **chip criptográfico** fabricado por la empresa americana Microchip. Usado a veces en la autenticación de consumibles y accesorios. Puede calcular **SHA256**, **AES128** y **ECC P256**; también soporta KDF, ECDH, GCM y muchas siglas más.

{% include image.html file="atecc608.jpg" caption="ATECC608C (aunque ponga otra cosa). Los alargados son para pegarlos en consumibles sin electrónica ni PCB." %}

Como te decía, un integrado capaz de calcular una **función hash** segura, un algoritmo de **cifrado simétrico** robusto y otro **asimétrico**.

Los pedí y me los enviaron. Así, sin más.

¿No le ves **nada de extraño**? ¡Cuánto me alegro! Porque [no siempre ha sido así](https://en.wikipedia.org/wiki/Export_of_cryptography_from_the_United_States).



## Cuando la criptografía era munición

**Hasta el año 2000**, EEUU consideraba la *criptografía fuerte* **munición militar**. Estando sujeta a licencias de uso y restricciones de exportación. Sólo el **gobierno** de EE.UU. tenía derecho a utilizar claves de más de 40 bits. Y el ejército. Los ciudadanos, no. Y mucho menos naciones extranjeras.

**Debian** tenía el repositorio *Non-US* con software compilado en Europa, el cual sería delito exportar -y a veces usar- dentro de América.

{% include image.html file="debian3_non_us.png" caption="Mensaje durante la instalación de Debian Woody (2002). EyC." %}

Las distribuciones de Linux basadas en la Unión Europea, como SuSE (alemana), no tenían ese problema.

PGP fue el **primer programa** destinado al público que usaba criptografía asimétrica (RSA). Surgió en 1991 y digamos que el mundo aún no estaba preparado para el cifrado masivo de las comunicaciones civiles.

Nada iba cifrado, ni en USA ni en ningún sitio. Las líneas telefónicas eran analógicas; las conexiones, por telnet; las radios y hasta los recientes móviles GSM estaban en claro.

PGP se difundió por las BBS de todo el mundo. En 1993, su autor fue **perseguido** por exportar sin licencia munición militar. Hubo [protestas](https://en.wikipedia.org/wiki/Crypto_Wars). Imprimieron su código fuente en un libro. Este, protegido por la primera enmienda, sí que podía exportarse.

Para mostrar el absurdo de la ley, también estamparon camisetas con el algoritmo.

{% include image.html file="camiseta-rsa.png" caption="Perl es el único lenguaje que se lee igual antes y después de cifrarlo con RSA. [blockstream.com](https://store.blockstream.com/products/rsa-t-shirt-1)" %}

Con la popularización de internet la criptografía había dejado de ser **cosa de espías**.

Para el año **2000**, algunas restricciones cayeron:

> EEUU elimina las restricciones de exportación de criptografía

> El código fuente de productos comerciales de cifrado,
> herramientas de cifrado y componentes ahora ya pueden exportarse
> sin necesidad de licencia para uso interno, adaptación y para el
> desarrollo de nuevos productos. El gobierno también ha relajado
> las restricciones sobre la publicación de código fuente, lo que
> incluye su envío sobre Internet.

> [Una al día - enero de 2000 - Hispasec](https://unaaldia.hispasec.com/2000/01/eeuu-elimina-las-restricciones-de-exportacion-de-criptografia.html)

Si bien el software aún tardó **años** en adaptarse a la nueva legislación.

La JCE ([*Java Cryptography Extension*](https://www.oracle.com/java/technologies/javase-jce8-downloads.html)) es una librería que fue necesario instalar para usar claves de 128 bits en Java... ¡[hasta 2017](https://bugs.openjdk.java.net/browse/JDK-8170157)!

{% include image.html file="java_ce.png" caption="Hasta 2017, Java permitía criptografía \"fuerte\"... pero limitada. README de JCE. EyC." %}

A finales de los 90, **AES** como tal no existía. DES (Data Encryption Standard) se había quedado pequeño y el NIST organizó un **concurso** para elegir sucesor. Varios algoritmos competían y el que acabó ganando pasó a llamarse AES (American/Advanced Encryption Standard).

{% include image.html file="rijndael-kernel-before-AES.png" caption="Decían que el mejor era el del nombre raro. EyC." %}

Hoy, una empresa americana me ha hecho llegar chips con una tecnología que, hace escasos veinte años, o **no existía**; o era **secreta**; o directamente estaba **prohibida**.


## Exploits electrónicos

El ATECC608 forma parte de la **familia ATCA** (*Atmel Crypto Authentication*), ahora de Microchip.

Estos integrados son como mini-HSM. Aunque con aplicaciones y algoritmos muy limitados. Los llaman **secure element**, a veces *secure memory*.

Su función principal **fue**, en su día, la autenticación de **accesorios y consumibles**. ¿Sabes esos cartuchos de tinta que no se pueden reutilizar porque "llevan un chip"? ¿O esos portátiles que no funcionan sin el cargador original? A veces son chips de este estilo.

**Actualmente**, la seguridad embebida va mucho más allá de satisfacer la codicia de los fabricantes de impresoras. Echale un vistazo al [estándar ISA/IEC 62443](https://www.isa.org/standards-and-publications/isa-standards/isa-iec-62443-series-of-standards):

> The international series of standards IEC 62443 are being developed [...] to address the need to design cybersecurity robustness and resilience into industrial automation and control systems (IACS), covering both organizational and technical aspects of security over the life cycle of systems. - [IEC 62443 Background](https://syc-se.iec.ch/deliveries/cybersecurity-guidelines/security-standards-and-best-practices/iec-62443/)

Dentro de la familia hay modelos específicos para autenticación de **consumibles** (desechables, más baratos, con menos memoria, y menos algoritmos soportados), otra gama para seguridad en el sector **automoción**, y otra más **generalista**.

El ATECC608 se puede usar como **acelerador criptográfico**, almacén de claves, autenticación de dispositivos IoT, *secure boot*, cifrado de comunicaciones TLS y más.

¿Es necesario un micro especial para **seguridad** cuando casi todos los micros tienen ya protección de firmware?

Como siempre... depende de cuál sea el **valor** de tus secretos.

La **microelectrónica**, en general, es **vulnerable** a **dos tipos de ataques**:
- canal lateral
- inyección de errores

Un ataque de **canal lateral** suele ser pasivo. Consiste en aprovechar la **información filtrada** de manera indirecta durante la operación normal.

Por ejemplo pequeñas variaciones en el **tiempo** de procesamiento, en el **consumo** de corriente, o el campo electromagnético emitido pueden revelar las instrucciones que se están ejecutando. Y puedes llegar a deducir si en tal o cual posición de la clave había un 0 o un 1.

{% include image.html file="aes_power.png" caption="A veces se puede saber qué está haciendo un chip sólo por su consumo. [SSTIC2021](https://www.sstic.org/media/SSTIC2021/SSTIC-actes/defeating_a_secure_element_with_multiple_laser_fau/SSTIC2021-Article-defeating_a_secure_element_with_multiple_laser_fault_injections-heriveaux.pdf)." %}

Con la **inyección de errores** tratamos de hacer **fallar** la lógica interna.

Bien generando un *glitch* en el **voltaje** en el momento oportuno, o en la señal de **reloj**. Bien emitiendo un **pulso EM** muy intenso cerca.

En los ataques más sofisticados, decapando el chip y haciendo incidir un **laser** sobre un transistor concreto. O usando una máquina de litografía para modificar el circuito integrado.

{% include image.html file="voltage_glitch.webp" caption="Una caída abrupta de tensión en el momento apropiado puede hacer fallar a lógica interna. [stm32_vglitch](https://jerinsunny.github.io/stm32_vglitch/)." %}

Al final del todo te dejo unos enlaces a ataques exitosos donde consiguen **leer** el **firmware protegido** de un **STM32** o romper el ***secure boot*** de un **ESP32** con un simple ***glitch*** de voltaje.

El ATECC608 incorpora defensas contra estos ataques:
- **Blindaje** metálico: Bajo el encapsulado epoxy hay una **capa metálica** a modo de blindaje, cubierto por un **hilo** muy fino. Impide fugas electromagnéticas y evita que los campos muy fuertes alteren el funcionamiento normal. Si lo retiras o lo perforas romperás el hilo y el micro dejará de funcionar.
- Señal de **reloj** interna: evita los ataques de *glitch* en el reloj.
- Regulador de **voltaje** interno: Detecta un *glitch* en el voltaje y **reinicia el micro**. También introduce ruido de forma deliberada en la alimentación para dificultar los ataques de canal lateral.
- **Cifrado** de los datos almacenados: aunque consiguieras hacer un volcado de la **EEPROM**, no te serviría, porque está cifrada. Necesitas que sea el propio chip quien la lea.
- ***Self-testing*** durante el proceso de **inicialización** (*wake-up*). Se pasan unos tests internamente. Si se detecta algo raro, se detiene el arranque.

{% include image.html file="shield.png" caption="Blindaje del ATECC508. Si la malla se corta en algún punto, el micro se inutiliza. [SSTIC2020](https://www.sstic.org/media/SSTIC2020/SSTIC-actes/blackbox_laser_fault_injection_on_a_secure_memory/SSTIC2020-Article-blackbox_laser_fault_injection_on_a_secure_memory-heriveaux.pdf)" %}

Pese a todas estas protecciones, se han llevado a cabo **ataques exitosos**.

[El **primero**](https://www.youtube.com/watch?v=7-9knubFJjY) contra el **ATECC508A** (predecesor del ATECC608A), presentado en la BlackHat 2020. Los investigadores consiguieron extraer las claves secretas de una **cartera de criptomonedas** usando un ataque de inyección laser.

Microchip ya no recomienda el ATECC508 en nuevos diseños.

En [el **segundo**](https://www.youtube.com/watch?v=Kj1nVJypXPM), presentado en la BlackHat 2021, **rompieron el ATECC608A** usando inyección láser en **dos puntos** diferentes de la ejecución.

El fabricante actualizó a la versión B. E introdujo **esperas aleatorias** para hacer la ejecución menos predecible.

Aún así, en 2023, se presentó [un tercer ataque](https://www.youtube.com/watch?v=Hd_K2yQlMJs) contra el **ATECC608B**.

No se conocen ataques aún para la versión **C** del **ATECC608**.

En la sección de enlaces te dejo las exposiciones en vídeo, presentaciones y *papers*.

> The use of secure circuits is considered the best practice for protecting secrets in a system. Those circuits are much stronger than standard microcontrollers. The vulnerability we found is powerful, but required really expensive equipment, and a lot of effort and expertise. Compared to microcontrollers, where a simple low-cost voltage glitch can give full access to the Flash memory, the ATECC device can protect from a wide range of attackers. [Lit By Laser: Pin Code Recovery On Coldcard Mk2 Wallets](https://www.ledger.com/blog/coldcard-pin-code)


## Primer contacto

A día de escribir este artículo, el *datasheet* completo del ATECC608 es confidencial. Si tienes suerte, podrás encontrar una versión filtrada buscando *ATECC608A "MICROCHIP CONFIDENTIAL"*. Si no, el del ATECC508 sí se puede encontrar fácilmente.

{% include image.html file="ATECC608-memory.svg" caption="El ATECC608 tiene más cosas, pero hoy sólo voy a mencionar estas. EyC." %}

**Número de serie**: Para **identificar** dispositivos necesitas algo distinto en cada uno, ligado al hardware y que no se pueda cambiar. En este chip son 9 bytes, de los que 3 son fijos y el resto son únicos: `0x01 23 xx xx xx xx xx xx EE`.

**OTP**: 64 bytes para guardar lo que quieras. Marca, modelo, versión del dispositivo, etc. Una vez escrito ya no se puede modificar.

**Contadores**: Hay dos contadores de 21 bits. Sólo pueden ir hacia adelante y no se pueden reiniciar. Sirven para deshabilitar el consumible tras cierto número de usos o bloquear una clave en un ataque de fuerza bruta.

**TempKey**: Es una especie de acumulador interno. No se puede leer directamente (aunque sí escribir). Sirve para hacer los cálculos criptográficos.

**State**: Son bits que van cambiando según hacemos operaciones. Dependiendo del estado interno, podremos ejecutar ciertos comandos y usar ciertas claves o no.

**Config Zone**: aquí se seleccionan las opciones del integrado, protocolo I2C o 1-Wire, dirección I2C, duración del watchdog, protección durante el transporte, etc. Y también es donde configuran los slots.

**Data Zone**: Son 16 ***slots***. Para guardar claves AES, secretos, claves públicas, certificados o datos en general.

En cada *slot* se puede configurar individualmente:
- El **tipo** de clave: ECC privada, AES, o datos varios; por ejemplo secretos, claves públicas, certificados, etc.
- Si se puede **leer** en claro, sólo leer cifrada -sabiendo otra clave- o directamente no se puede leer -es secreto-.
- Lo mismo para **escribir**.
- Si la podemos usar sin ***nonce*** (luego veremos qué es), si este puede ser un valor dado o debe ser aleatorio.
- Si requiere estar **autorizado** con alguna otra clave antes de usar esta.
- Si tiene **límite** de usos (asociada al contador 0).

Ahora toca probarlo y ver cómo funciona.

Lo conectamos por **I2C** a una Raspberry Pi.

{% include image.html file="cn-2233VCH.jpg" caption="Conexión del chip a las lineas I2C de una Raspberry. EyC." %}

Fíjate que no requiere **ningún componente externo** (la Raspberry ya incorpora resistencias de *pull-up*). Están pensados para ponerlos en un consumible sin más electrónica que este chip.

Verás que está marcado como **CN-2233VCH**, que nada tiene que ver con ATECC608. Es una contramedida más para **despistar**. Podrías pensar que es una EEPROM o algún micro chino.

He usado como masa el pin 4 del conector GPIO. Normalmente estará configurado como **entrada**, y así no va a funcionar. Primero debemos configurarlo como **salida** con el comando:

```
gpioset pinctrl-bcm2835 4=0
```

Comprobamos que lo detecta:

```console
pi@raspberrypi:~$ i2cdetect -y 1
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: 60 -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
```

La librería del fabricante es pública: [MicrochipTech/cryptoauthlib - GitHub](https://github.com/MicrochipTech/cryptoauthlib).

Yo, por mi cuenta, me he hecho unas **utilidades** en forma de comandos y scripts de Bash: [electronicayciencia/ATECC608-Tools - GitHub](https://github.com/electronicayciencia/ATECC608-Tools).



## Configuración y provisión

Antes de empezar a usar el chip hay que seguir unos pasos:
1. Primero, personalizas las **opciones de configuración**: Dices qué slots se van a poder escribir, cuáles van a ser secretos o de sólo lectura, etc.
1. **Bloqueas** esa configuración (*config lock*).
1. Con los slots configurados, **grabas las claves**, certificados, etc. Inicializas la OTP y los contadores de uso.
1. Una vez lo tengas todo a tu gusto, **bloqueas** esos datos (*data lock*).

En ese momento se **hace efectiva** la configuración de los slots. Si era de sólo lectura, ya no se podrá escribir. Si la escritura estaba protegida por una clave, ahora esa protección se activa.

El **data lock** no significa que ya no puedas escribir nada. Si el slot era de lectura/escritura, se podrá seguir escribiendo libremente en él.

Vamos con el **primer paso**.

Cada slot se configura individualmente según el uso previsto.

Esta es la parte más complicada. Toda la seguridad del chip es **inútil** si te dejas un secreto legible o una clave mal configurada.

Yo le voy a dar una **configuración variada**, sin un uso concreto en mente, tan sólo para ver cómo funciona.

Slot |Bytes | Tipo         | Read | Write | Uso previsto
----:|-----:|--------------|------|-------|-------------
  00 |  36  | ECC Private  | No   | Sí    | Clave **privada**.
  01 |  36  | AES          | 7    | 7     | Clave **simétrica**.
  02 |  36  | AES          | 7    | 7     | Clave **simétrica** con **contador** de usos.
  03 |  36  | AES          | Sí   | Sí    | Clave **simétrica** R/W para **pruebas**.
  04 |  36  | SHA          | 7    | 7     | Secreto.
  05 |  36  | SHA          | 7    | 7     | Secreto con contador de usos.
  06 |  36  | SHA          | Sí   | Sí    | Secreto R/W para pruebas.
  07 |  36  | SHA          | 7    | 7     | Clave de **personalización** o *encrypted I/O*.
  08 | 416  | Data         | Sí   | Sí    | Datos R/W (416 bytes)
  09 |  72  | ECC Public   | Sí   | Sí    | Clave pública de **0**.
  10 |  72  | -            | -    | -     | -
  11 |  72  | -            | -    | -     | -
  12 |  72  | AES          | No   | 13    | Clave **simétrica** autorizada por **13**.
  13 |  72  | SHA          | No   | 13    | **Secreto** para utilizar **12**.
  14 |  72  | -            | -    | -     | -
  15 |  72  | Data         | Sí   | 7     | **Información** del consumible.

La clave del slot **0** va a ser una **clave privada**. La podemos escribir pero no leer. La idea es que el chip cree una clave usando su generador aleatorio y nos devuelva la parte pública. Esta la guardaremos en el slot **9**.

Los slots del **1** al **3** serán **claves simétricas** para **AES**:
- **1** solo se puede leer y escribir sabiendo la clave **7**.
- **2** solo se puede leer y escribir sabiendo la clave **7** y tiene contador de usos.
- **3** se puede leer y escribir en claro.

Los slots del **4** al **6** son igual pero con **secretos** para **SHA**.

La clave **7** var a ser muy importante. Se llama de ***personalización***. Con ella podremos leer y escribir otras claves. Sirve para actualizar el dispositivo o para provisionarlo una vez pasada la línea de montaje. También se le llama de *I/O encryption*, porque los valores que escribamos no irán en claro sino "cifrados".

El slot **8** lo destinamos a guardar **datos variados**, como si fuera una EEPROM.

El slot **9** lo reservamos para la **clave pública** de **0** (los slots anteriores son muy pequeños y no cabe una clave pública).

En el slot **12** irá una **clave AES**, la podremos escribir pero **nunca leer**, ni siquiera cifrada. Además, para usarla debemos conocer la clave **13**.

**13** es un **secreto SHA**. Nos servirá para desbloquear **12**. Lo podremos escribir si y sólo si lo conocemos previamente.

Por último, el slot **15** serán **datos varios**. Públicamente accesibles pero, a diferencia del **8**, para modificarlos se necesitará la clave de *personalización* **7**.

El resto de slots no los usaremos.

**Paso dos**: bloqueamos la config.

**Paso tres**: inicializamos las claves **7** y **13**, necesarias para poder cambiar luego las demás.

Les pondré como valor el SHA256 de la palabra `password`:

```bash
function SHA256 {
    echo -n $@ | sha256sum | cut -d' ' -f 1
}
```

```console
$ SHA256 password
5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
```

Por último, ya sólo queda **bloquear la data zone** y listo.


## Autenticación con secreto compartido

La **autenticación** con *hash + secreto compartido* se basa en un principio muy simple: Ambas partes calculan por su cuenta una operación en la que interviene un **secreto**. Si ambas partes llegan al **mismo resultado** es porque ambos conocen el secreto.

Imaginemos que el chip está instalado en un **accesorio/consumible**. Conectado a la Raspberry. Y yo quiero asegurarme de que es un accesorio original y no está caducado, por ejemplo.

{% include image.html file="auth_accesorios.svg" caption="En este ejemplo de uso autenticamos un consumible o un accesorio. EyC." %}

Lo primero que voy a hacer es crear un **nonce**. El *nonce* es un número que entra a formar parte de la operación criptográfica.

Su **función** es impedir que un falsificador copie los mensajes de una **autenticación anterior** y los reproduzca. Aún no sabiendo la clave, pero sabe lo que tiene que responder. Eso se llama ataque de **replay**.

Si yo comienzo cada vez con un *nonce* diferente, los mensajes de una conversación anterior ya **no valen** para esta. No tiene por qué ser aleatorio; basta con **no reutilizarlo**.

Tomaré la fecha actual hasta los nanosegundos. *Pero la fecha se puede manipular*, me dirás. Y llevas razón. Lo más seguro es uno random. Aunque en un sistema embebido tampoco es fácil obtener un número aleatorio de verdad.

¿Y no puedo llamar al **mismo ATECC608** para que me genere un random y pasárselo de nonce? ¡No! Eso sí sería un fallo de seguridad. Es cómo preguntarle al posible *suplantador* qué nonce quiere usar.

El ATECC608 requiere un *nonce* de 20 bytes. La fecha, como decía, y el resto lo rellenaré con ceros.

```console
$ printf %40x `date +%s%N` | tr ' ' '0'
00000000000000000000000017fe1ae201b054d5
```

Se lo paso al ATECC608, él genera otro número aleatorio y me lo devuelve. Ambos los combina en **TempKey**.

```console
$ ./nonce_rand 00000000000000000000000017fe1ae201b054d5
3141a096115c8b18c6b6d89bf3c34fff11f0de4e2b969dd8e3b6f8cdc792472a
```

Ya tenemos **TempKey** inicializado. El estado cambia. Reflejando que la fuente de TempKey tiene un componente **aleatorio** (porque lo ha generado el chip con su propio generador interno).

```console
$ ./state
TempKey.SourceFlag: 0    <-- random
TempKey.Valid:      1
```

Ahora le pido que me dé el **contenido** del *slot* **15** y lo convierto a ASCII.

```console
$ ./read_slot 15 | xxd -r -p
EyC test  Cad:12/2024 Lot:24AA11
```

Ahí he grabado el tipo de consumible, **fecha de caducidad** y lote. Esos datos se podrían cambiar para actualizarlos, pero sólo por alguien que supiera la clave **7**.

La respuesta va sin cifrar. ¿Cómo sé que no lo han alterado?

Le pido al chip que **combine** ese mismo *slot 15* con el valor actual de **TempKey** mediante un **hash**.

```console
$ ./gendig 15
Ok
```

No devuelve nada, pero sí **actualiza** el **TempKey**. Lo vemos en el estado interno:

```console
$ ./state
TempKey.GenDigData: 1    <-- contiene un digest
TempKey.SourceFlag: 0    <-- con un nonce aleatorio
TempKey.KeyID:      15   <-- y el slot 15
TempKey.Valid:      1
```

Finalmente le pido al chip que genere un **MAC** combinando el **TempKey** con el contenido de la clave **7**. Aquí está el **secreto compartido**.

```console
$ ./mac 7
7d2a2ff8af0ed2e085d6709176afda6a99b982d7b2efc1e6b36ce1739c71af6a
```

Ese es el resultado final. Dependiente de:
- El ***nonce*** inicial. Luego este MAC sólo vale para **esta vez**.
- El **contenido** del slot **15**. Si el falsificador manipuló la respuesta, el hash no coincidirá.
- La **clave 7**. Que es **secreta**.

**Comparando** el resultado sabremos si el componente es original, y que los datos leídos de él son auténticos (no está caducado, etc).

{% include image.html file="MAC.svg" caption="Esquema del proceso de autenticación. EyC." %}

El comando *GenDig* puede hacer entrar en el cálculo otros *slots*, la OTP o los contadores. Así podemos leer cualquier información del chip sin que nadie pueda **alterar** esa lectura.

```console
$ ./eyc_original.sh
EyC component validator
Secret key slot: 7

It's original.

EyC Crypt Cad:12/2024 Lot:24AA11
```

Estos **comandos** los tienes en [electronicayciencia/ATECC608-Tools - GitHub](https://github.com/electronicayciencia/ATECC608-Tools).



## Cifrar con una clave desconocida

En la clave **13** habíamos puesto el **SHA256** de **password***.

En **12** vamos a crear una **clave aleatoria** por medio de una operación de **rotado**.

Esta operación consiste en **sobrescribir** la clave antigua con el resultado de combinar su **valor actual** (que no conocemos) con un **número aleatorio** (que no apuntamos).

```console
$ ./rotate_key.sh 12 `SHA256 password`
Ok
```

{% include image.html file="rotate_key.svg" caption="Esquema de la operación de rotado de clave. EyC." %}

Ahora es **aleatoria y secreta**.

¿Y para qué quiero cifrar datos con una **clave desconocida** que no puedo extraer?

Para **vincular** los datos al dispositivo **físico**.

Es más, como necesitas la clave **13** para usarla, conseguimos un **doble factor**:
- algo que **tienes** (este chip físico)
- y algo que **sabes** (la clave **13**)

Vamos a practicarlo.

Primero tengo que **autenticarme** con la clave **13**. ¿Cómo le demuestro al chip que conozco la clave **13** sin revelarla?

Con un **MAC**, como en el ejemplo anterior. Pero esta vez soy **yo** quien le enseño el MAC al chip y **él** quien lo verifica.

```console
$ ./authorize.sh 13 `SHA256 password`
Ok
```

Me reconoce como **autorizado** con la clave **13**. El estado interno cambia.

```console
$ ./state
TempKey.SourceFlag: 0
TempKey.KeyID:      0
TempKey.Valid:      1
Auth Key ID:        13
Auth Valid:         1
```

Ya podría usar la clave **12**.

Pero, en lugar de usarla directamente, voy a crear lo que se llaman **claves derivadas**.

Derivar la clave requiere un paso adicional, pero es muy útil para no cifrar todo con la **misma clave**. Por ejemplo cada fichero con una clave diferente. O cada contraseña, o cada partición de la flash.

La clave derivada va a ser el resultado de **combinar** la **12** (desconocida) con un **valor de entrada** conocido. A este valor le llamaremos **índice de derivación**.

{% include image.html file="derive_key_encryption.svg" caption="Esquema para cifrar con una clave derivada temporal. EyC." %}

Por cierto, si quieres hacerlo **correctamente** el ATECC680 soporta **KDF** (*Key Derivation Functions*). La derivación que hacemos aquí es menos segura pero más simple.

Primero cargo **TempKey** con el **índice de derivación** 0.

```console
$ ./load_tempkey 00000000000000000000000000000000
Ok
```

El estado cambia para reflejar que TempKey ya **no** viene de una semilla **aleatoria**.

```console
$ ./state
TempKey.SourceFlag: 1    <-- no random
TempKey.KeyID:      0
TempKey.Valid:      1
Auth Key ID:        13
Auth Valid:         1
```

A continuación, usaré el comando `GenDig` para **combinar** el slot **12** con lo que haya en **TempKey**.

```console
$ ./gendig 12
Ok
```

No necesito saber lo que hay en **TempKey**.

Sólo sé que viene de **12** y el índice que he puesto... y que puedo usarlo para **cifrar y descifrar**.

Ciframos un bloque de entrada `aa55aa55...`:

```console
$ ./aes_encrypt TEMPKEY aa55aa55aa55aa55aa55aa55aa55aa55
44c536ec5fc1f410174170ea4b1edc32
```

Recuerda usar [**CBC**](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation) si los datos a cifrar superan el **tamaño del bloque** AES.

{% include image.html file="CBC_encryption.svg" caption="Cifrado encadenado. EyC." %}

**Descifrar** los datos es igual, proporcionando la credencial en **13** y el **índice** de la clave derivada.

```console
$ ./authorize.sh 13 `SHA256 password`
Ok
$ ./load_tempkey 00000000000000000000000000000000
Ok
$ ./gendig 12
Ok
$ ./aes_decrypt TEMPKEY 44c536ec5fc1f410174170ea4b1edc32
aa55aa55aa55aa55aa55aa55aa55aa55
```

¿Y para **cambiar la contraseña**?

Por eso habíamos puesto que el slot **13** se pudiera escribir **conociendo** el slot **13**.

```console
$ ./write_enc 13 `SHA256 anacardo` 13 `SHA256 password`
Ok
```

¿Te cuento **otra ventaja** de no saber la clave? La **destrucción segura** de información.

Quieres **borrar** los datos, pero has leído [Memorias Flash: almacenamiento en IoT]({{site.baseurl}}{% post_url 2024-02-27-mtd-spi-iot %}) y sabes que por el *wear leveling* cuesta mucho borrarlo todo y siempre quedan restos.

Ningún problema: vuelves a **rotar la clave** **12**.

```console
$ ./rotate_key.sh 12 `SHA256 password`
Ok
```

Un comando y olvídate de borrar nada. Al haber **destruido la clave**, cualquier dato cifrado con ella o sus derivadas ya es **irrecuperable**.


## Conclusión

Por naturaleza, trabajar con **criptografía y seguridad** siempre es complicado. En este artículo hemos hablado de **ataques**, defensas y vulnerabilidades en **microelectrónica**.

Hemos presentado el **ATECC608** y practicado dos casos de uso:
- Una **autenticación** con hash y secreto compartido, donde apreciamos la importancia del ***nonce*** y de la función ***hash*** para leer datos de forma autenticada.
- Y un **cifrado** simétrico usando claves derivadas de otra custodiada por **hardware**.

Si bien nos hemos dejado fuera muchas capacidades importantes del chip (firmas, certificados, ECDH, KDF o *secure boot*), ha servido para familiarizarnos con él.

La **documentación** aún es **escasa** (a menudo sujeta a **NDA**). Y, aunque tenemos la librería del fabricante, pública, con ejemplos y notas de aplicación, se aprecia que es un producto orientado sobre todo al **sector profesional**.


## Más información

Documentación y casos de uso:

- [CryptoAuthLib - Microchip CryptoAuthentication Library](https://microchiptech.github.io/cryptoauthlib/)

- [CryptoAuthentication™ Product Uses - Atmel (2009)](https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ApplicationNotes/ApplicationNotes/doc8663.pdf)
- [CryptoAuthentication Personalization Guide - Atmel (2015)](https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ApplicationNotes/ApplicationNotes/Atmel-8845-CryptoAuth-ATSHA204A-ATECC508A-Personalization-Guide-ApplicationNote.pdf)

- [MicrochipTech/cryptoauthlib - GitHub](https://github.com/MicrochipTech/cryptoauthlib)
- [ATECC508A CryptoAuthentication Device Complete Data Sheet](https://cdn.sparkfun.com/assets/learn_tutorials/1/0/0/3/Microchip_ATECC508A_Datasheet.pdf)

Hacking para electrónicos:

- [An Introduction to Fault Injection](https://www.nccgroup.com/sg/research-blog/an-introduction-to-fault-injection-part-13/)
- [How to voltage fault injection ](https://www.synacktiv.com/publications/how-to-voltage-fault-injection)
- [Voltage glitching on STM32F4 MCUs](https://jerinsunny.github.io/stm32_vglitch/)
- [SECGlitcher (Part 1) - Reproducible Voltage Glitching on STM32 Microcontrollers](https://sec-consult.com/blog/detail/secglitcher-part-1-reproducible-voltage-glitching-on-stm32-microcontrollers/)
- [Power Side-Channel Attack Analysis: A Review of 20 Years of Study for the Layman - PDF](https://www.researchgate.net/publication/341513963_Power_Side-Channel_Attack_Analysis_A_Review_of_20_Years_of_Study_for_the_Layman)

Ataque al ATECC508:

- [Black-box Laser Fault Injection on a Secure Memory - Vídeo BlackHat 2020](https://www.youtube.com/watch?v=7-9knubFJjY)
- [Black-box Laser Fault Injection on a Secure Memory - Presentación BlackHat 2020](https://i.blackhat.com/USA-20/Thursday/us-20-Heriveaux-Black-Box-Laser-Fault-Injection-On-A-Secure-Memory.pdf)
- [Black-Box Laser Fault Injection on a Secure Memory - Paper en PDF](https://www.sstic.org/media/SSTIC2020/SSTIC-actes/blackbox_laser_fault_injection_on_a_secure_memory/SSTIC2020-Article-blackbox_laser_fault_injection_on_a_secure_memory-heriveaux.pdf)

Ataque al ATECC608A:

- [Defeating a Secure Element with Multiple Laser Fault Injections - Vídeo BlackHat 2021](https://www.youtube.com/watch?v=Kj1nVJypXPM)
- [Defeating a Secure Element with Multiple Laser Fault injections - Presentación BlackHat 2021](https://i.blackhat.com/USA21/Wednesday-Handouts/us-21-Defeating-A-Secure-Element-With-Multiple-Laser-Fault-Injections.pdf)
- [Defeating a Secure Element with Multiple Laser Fault Injections - Paper en PDF](https://www.sstic.org/media/SSTIC2021/SSTIC-actes/defeating_a_secure_element_with_multiple_laser_fau/SSTIC2021-Article-defeating_a_secure_element_with_multiple_laser_fault_injections-heriveaux.pdf)

Ataque al ATECC608B:

- [Triple Exploit Chain with Laser Fault Injection on a Secure Element - Video Hardwear.io 2023](https://www.youtube.com/watch?v=Hd_K2yQlMJs)
- [Triple Exploit Chain with Laser Fault Injection on a Secure Element - Presentación Hardwear.io](https://hardwear.io/netherlands-2023/presentation/triple-exploit-chain-with-laser-fault-injection-on-a-secure-element.pdf)

Artículos relacionados:

- [Electrónica y Ciencia - Certificados criptográficos hechos a mano]({{site.baseurl}}{% post_url 2021-06-13-certificados-criptograficos %})
- [Electrónica y Ciencia - Prácticas con TPM virtual]({{site.baseurl}}{% post_url 2020-09-02-practicas-tpm-virtual %})
- [Electrónica y Ciencia - Memorias Flash: almacenamiento en IoT]({{site.baseurl}}{% post_url 2024-02-27-mtd-spi-iot %})

- [electronicayciencia/ATECC608-Tools - GitHub](https://github.com/electronicayciencia/ATECC608-Tools)

