---
title: Descifrando la configuración del Sagemcom F@ST 5657
layout: post
assets: /assets/2021/02/descifrar-configuracion-sagemcom-fast5657
image: /assets/2021/02/descifrar-configuracion-sagemcom-fast5657/img/aead_10.png
featured: false
tags:
  - Binario
  - Informática
---

Hoy hablaremos de **criptografía**, **depuración** de software y seguridad por oscuridad. ¿Te acuerdas de cuando [obtuvimos la PLOAM password de este router]({{site.baseurl}}{% post_url 2020-10-26-obteniendo-ploam-password-fast-5657 %})? Hoy vamos a profundizar hasta **descubrir el algoritmo** y la clave con que se cifran los *backups* de la configuración.

**Nota**. Si sólo has venido a por el programa y no te interesan los detalles, aquí está el binario para Windows: [Sagemcom F@ST 5657 configuration decryptor v1.0](https://github.com/electronicayciencia/tr-069-proxy/releases/tag/v1.0). Suerte.

## El método anterior: MitM

Un inciso antes de comenzar.

El método que describía en la otra entrada consiste en **interceptar la comunicación** con el servidor de configuración (ACS) e inyectar los parámetros necesarios para habilitar el acceso al dispositivo. Era necesario porque el router estaba completamente cerrado. No teníamos ni SSH ni telnet desde la propia LAN. Era un desafío, pero **era un rollo**.

Según algunos comentarios, en la versión más reciente del firmware ya no funciona. Lo acabo de probar con la versión SGDV10000043 (GUI versión 4.100.0) y ciertamente he notado algunos cambios.

**Sigue funcionando**. Cambio la URL del ACS a mi servidor local. Al poco se establece la comunicación. Ahora bien, durante la primera fase en que el router envía al servidor el estado actual de la configuración, no había ni rastro de la PLOAM Password. Sin embargo ahora sí lo incluye:

```xml
<ParameterValueStruct>
  <Name>Device.Optical.X_MM_G988.RegId</Name>
  <Value xsi:type="xsd:string">37*************</Value>
</ParameterValueStruct>
```

Si sólo queríamos eso, ya no es preciso entrar por SSH para verlo. Pero hay más.

Siguiendo con el procedimiento, activo el SSH y accedo desde una máquina remota. Entro por ssh con el usuario *admin* y la contraseña que he visto durante la comunicación con el ACS. Entre los procesos ahora hay un segundo dropbear (una versión ligera de SSH) también en la interfaz local.

```console
admin@home:/tmp$ ps | grep dropbear
 1865 root  3448 S dropbear -F -j -k -U admin -p [192.168.1.1]:22 -P /v
 2576 root  3448 S dropbear -F -j -k -U admin -p [88.27.275.35]:22 -P /v
```

Lo cual significa que:

- cuando habilitas el acceso por SSH, se habilita en remoto y en local
- ahora podemos conectarnos desde nuestra red, sin necesidad de entrar por 4G o desde un servidor externo
- este método sirve aún estando tras el CG-NAT, cuando no tenemos una IP pública y por tanto no podemos acceder desde fuera

Pero este post no va de eso.

## El fichero cifrado

En la entrada anterior, cuando nos fijamos en si podíamos manipular la configuración, el fichero tenía este aspecto:

{% include image.html file="aead10_notepad.png" caption="El fichero de configuración no es legible." %}

Decíamos entonces:

> No es texto, es un fichero binario. Quizá comprimido, cifrado o las dos cosas. La cabecera AEAD me recuerda a Authenticated Encryption with Associated Data, prefiero buscar otro camino.

Tras hacernos *root* por aquel otro camino, vamos a saber más acerca de ese fichero de aspecto intimidatorio. El primer paso será verlo en hexadecimal. Empieza así:

```text
00000000  41 45 41 44 20 31 30 00  00 00 53 d7 00 00 00 07  |AEAD 10...S.....|
00000010  ee f7 87 c4 6c 12 ae d8  a7 3a d5 1c 3c 25 f4 d0  |....l....:..<%..|
00000020  bc 3d b1 36 3e 40 0a f8  a9 6b bc ee 0f cb d0 bb  |.=.6>@...k......|
00000030  64 65 66 61 75 6c 74 f1  28 46 ca 0f 49 9c 31 40  |default.(F..I.1@|
00000040  47 3a 01 f9 93 22 06 29  01 97 25 a9 b4 9b 96 d1  |G:...".)..%.....|
00000050  30 30 08 7c c4 9e ff 1a  79 4d ec 52 75 bb 69 3f  |00.|....yM.Ru.i?|
00000060  ...
```

A la hora de analizar un fichero binario hay dos cosas por donde empezar a desgranar el formato. Una son las palabras legibles (**strings**) y la otra los **ceros**. De esto habíamos hablado ya en [Describiendo un protocolo desconocido]({{site.baseurl}}{% post_url 2017-12-25-describiendo-un-protocolo-desconocido %}).

Tenemos varios elementos que son comunen en todos los ficheros. Dos son palabras legibles: `AEAD 10` al principio del todo, que podría ser una **firma** identificativa del tipo de fichero. Y más adelante `default`. El resto es binario.

En cuanto a ceros tenemos uno al final de `AEAD 10`, podría ser una cadena terminada en cero. Luego encontramos `00 00 53 d7`. Cabe suponer que sea un entero de 32 bits,en tal caso equivaldría a 21463 en hexadecimal. Lo cual coincide con el **tamaño** en bytes del fichero:

```console
$ wc -c device.cfg
21463 device.cfg
```

Y finalmente `00 00 00 07`, si fuese un entero sería igual a 7. Aún no sabemos qué es.

El resto de los bytes cambian en cada fichero. Son producto, por tanto, de alguna operación con bytes aleatorios, basados en el tiempo o contadores.

## Magic AEAD 10

Solemos llamar *magic number* a la secuencia inicial de algunos ficheros. Facilita descartar rápidamente un archivo si no es del tipo que esperamos.

Hay marcas muy conocidas, por ejemplo los ejecutables de MSDOS comenzaban por `MZ`, iniciales de [Mark Zbikowski](https://en.wikipedia.org/wiki/DOS_MZ_executable). Los de Windows por `PE` *Portable Executable*. Los binarios de Linux modernos por `ELF` *Executable and Linkable Format*. Los PDF empiezan por `PDF`. Y los ficheros comprimidos con zip lo hacen por `PK`, iniciales de Phil Katz -autor de pkzip-.

Sin otra pista que seguir buscamos en Google ese "AEAD 10": nada. Probamos en hex "41 45 41 44 20 31 30": tampoco, nada.

Nos vamos al router, algún fichero debe escribir literalmente esa cadena. Busquemos dónde aparece.

```console
admin@home:/tmp$ grep -l -r "AEAD 10" /opt/
/opt/squashfs/usr/lib/libgsdf.so
/opt/squashfs/usr/lib/libgsdf.so.1
/opt/squashfs/usr/lib/libgsdf.so.1.0.0
admin@home:/tmp$
```

Tres ficheros; pero sólo uno es de verdad. Los otros dos son enlaces simbólicos. Al parecer esta librería es la encargada de generar el fichero de configuración. Miremos qué tiene por dentro.

```console
$ strings libgsdf.so.1
...
aes_setkey_enc
sha2_update
rsa_gen_key
gsdfAeadEncrypt
gsdfAeadDecrypt
gsdfEncryptFile
gsdfDecryptFile
...
GSDF 10
AEAD 10
...
error: gsdfAeadEncrypt cannot open /dev/urandom
error: gsdfAeadEncrypt returned %d
...
```

Con un comando strings vemos básicamente tres cosas:

- Nombres de las **secciones** del ejecutable.
- **Símbolos**, es decir, funciones que el ejecutable exporta o importa. Nos dan una idea de qué cosas hace. En este caso, por ejemplo, sabemos que usa criptografía pues vemos funciones relacionadas con AES, SHA2 o RSA. También nos llaman la atención *gsdfAeadDecrypt* porque contiene la marca AEAD y *gsdfDecryptFile* parece operar con ficheros.
- Datos inicializados del ejecutable. Si este tuviera un certificado o una clave sin ofuscar ni comprimir lo veríamos. También **mensajes** y cadenas de formato. Conocer el tipo de mensajes o de errores que muestra nos da una idea de cómo funciona. Así sabemos que *gsdfAeadEncrypt* hace uso de */dev/urandom*.

## Posts de noconroy.net

Con esta nueva información en la mano, volvemos a buscar en Internet. Con más suerte esta vez. Encontramos una serie de artículos de hace unos años. El dominio *noconroy.net* ya no existe pero podemos visitarlo en Archive.org.

- [Sagemcom F@ST5355 Reverse Engineering - Part 1](https://web.archive.org/web/20180129221204/https://noconroy.net/sagemcom-fast5355-re-p1.html)
- [Sagemcom F@ST5355 Reverse Engineering - Part 2](https://web.archive.org/web/20180129221204/https://noconroy.net/sagemcom-fast5355-re-p2.html)
- [Sagemcom F@ST5355 Reverse Engineering - Part 3](https://web.archive.org/web/20180129221204/https://noconroy.net/sagemcom-fast5355-re-p3.html)

A lo largo de estos tres posts, el autor intenta conseguir shell de root en su router **F@ST 5355**. Igual que nosotros, antes de nada debe conseguir acceso por telnet o SSH. Su plan consiste en descubrir el algoritmo de cifrado de la configuración mediante **ingeniería inversa**. Esto le permitiría manipular el fichero de configuración, modificar los parámetros del acceso remoto, volverlo a cifrar y aplicarlos como si restaurara una configuración guardada.

Para ello se vale del **firmware** de un modelo anterior, el F@ST 5350, que Sagemcom había hecho **público** poco tiempo antes.

Como nosotros, busca la firma "AEAD 10" y llega hasta la librería **libgsdf.so**. Se centra en la función *gsdfDecryptFile* y descubre que recibe dos parámetros. Son los nombres de los ficheros origen (cifrado) y destino (descifrado).

Escribe un programa para llamar a las funciones *gsdfDecryptFile* y *gsdfEncryptFile* de la librería y con él manipula la configuración. Activando así el acceso remoto. Después prosigue su investigación hasta lograr, en el tercer artículo, un **script Python** con el algoritmo de cifrado y descifrado.

Su script **ya no funciona** en el modelo FAST 5657; no obstante es un gran avance. Hemos pasado de no saber nada a tener que actualizar un script existente.

Hay razones para pesar que el algoritmo no ha cambiado demasiado:

- La firma AEAD 10 sigue siendo la misma.
- La librería se llama igual y las funciones *gsdfDecryptFile* y *gsdfEncryptFile* existen en nuestra versión.
- La cabecera del fichero y los campos descritos en el artículo son compatibles con lo que hemos encontrado hasta ahora.
- Es el mismo fabricante y entre un modelo y otro sólo hay cuatro años.

Seguramente sólo hayan cambiado la clave. Vamos a comprobarlo.

El autor de *noconroy.net* descubre la clave para su firmware haciendo **análisis estático** del código con radare2. Yo no tengo experiencia en reversing, pero sí en sistemas y programación. Por eso **mi técnica es diferente**.

{% include image.html file="byte_a_byte.png" caption="Rutina de generación de la clave en el firmware del modelo 5355. Los números 7d, 58 o 13 son los bytes individuales de la clave de cifrado. EyC." %}

## Llamar a las funciones

Lo primero será ejecutar esas dos funciones de la librería. Probaremos el mismo programa usado en los artículos mencionados:

```c
#include <stdio.h>

int gsdfDecryptFile(char *src_file, char *dst_file);
int gsdfEncryptFile(char *src_file, char *tag, char *dst_file);
char *tag = "default";

int main(int argc, char *argv[]) {
  int i = 0;

  if(argc != 4 || (argv[1][0] != 'e' && argv[1][0] != 'd')) {
    printf("Usage: %s [e|d] file_in file_out\n", argv[0]);
    return -1;
  }

  switch(argv[1][0]) {
    case 'e':
      i = gsdfEncryptFile(argv[2], tag, argv[3]);
      printf("Encryption returned: %d\n", i);
      break;
    case 'd':
      i = gsdfDecryptFile(argv[2], argv[3]);
      printf("Decryption returned: %d\n", i);
      break;
  }
  return 0;
}
```

Pero ¿dónde lo ejecutamos?

El FAST 5355 **es MIPS**. El autor debió hacerse con una toolchain MIPS y usar Qemu para emular en local dicha  plataforma. El modelo 5657, por el contrario, **es ARM**.

```console
admin@home:/tmp$ cat /proc/cpuinfo
processor       : 0
model name      : ARMv7 Processor rev 5 (v7l)
BogoMIPS        : 100.00
Features        : half thumb fastmult edsp tls idiva idivt lpae
...
Hardware        : BCM96846
```

Estamos de suerte. Precisamente conozco bien la toolchain para otro dispositivo ARM: la **Raspberry Pi**.

No es exactamente el mismo SOC pero la arquitectura parece compatible. De hecho los binarios vienen compilados para ARM EABI5. Es más, si copiamos el `busybox` del router a la Raspberry se ejecuta sin problema.

```console
$ file libgsdf.so.1.0.0
libgsdf.so.1.0.0: ELF 32-bit LSB shared object, ARM, EABI5 version 1 (SYSV), dynamically linked, stripped
```

Copiamos, pues, la librería *libgsdf.so* a nuestra raspberry. Ningún error al compilar. Pero falla la ejecución.

```console
pi@raspberrypi:~$ gcc -o prog prog.c -L . -l gsdf
pi@raspberrypi:~$ ./prog
./prog: error while loading shared libraries: libgsdf.so.1: cannot open shared object file: No such file or directory
```

El compilador sí encuentra la librería. De lo contrario habría fallado en la fase de linkado.

Quien no la encuentra es el **cargador dinámico**. Los binarios ELF necesitan de un programa aparte que los lee; recoge los módulos que necesitan, los busca en el sistema y carga en memoria; resuelve a su vez los que estos necesitan y, al final del todo, carga el binario ELF y le pasa el control.

Y se llama precisamente **intérprete**, como el intérprete de Python o de Bash:

```console
$ file /bin/bash
/bin/bash: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, for GNU/Linux 2.6.32, stripped
```

Hay múltiples formas de indicarle al cargador dónde encontrar una librería. Las dos más habituales son copiar la librería a una ruta del sistema o bien añadir la ruta adecuada a la variable de entorno LD_LIBRARY_PATH.

Te lo puedes ahorrar. Da igual, no te vale.

El problema no es ese. Aunque diga *not found* no es que no la encuentre, es que **no puede cargarla**. La arquitectura es compatible. El procesador reconoce las instrucciones ARM y puede ejecutarlas. Pero los binarios han sido compilados para otra versión de Linux, con otras librerías y, por supuesto, otro cargador dinámico. El programa terminará funcionando. Pero no lo hará con las librerías de nuestro sistema.

Necesitamos hacer una **compilación cruzada**. Usaremos la toolchain de Raspbian para compilar. Y a la hora de linkar el ejecutable final lo haremos **con la glibc del router** (digamos OpenWrt). También debemos indicar el cargador correcto porque, con esas librerías extrañas, el de Raspbian se va a estrellar.

Primero copiamos los directorios `/lib` y `/usr/lib` a la Raspberry. Y después le decimos a GCC lo que queremos hacer:

```console
$ ROUTERFS=/home/pi/router_arm/squashfs
$ gcc -o prog prog.c \
    -L $ROUTERFS/lib \
    -L $ROUTERFS/usr/lib \
    -l gsdf \
    -l c \
    -l rt \
    -l pthread \
    -Wl,-rpath=$ROUTERFS/lib \
    -Wl,-rpath=$ROUTERFS/usr/lib \
    -Wl,--dynamic-linker=$ROUTERFS/lib/ld-linux.so.3
```

- incluimos esos dos directorios como ruta preferente a la hora de buscar las librerías para el linker
- añadimos la librerías gsdf (la que queremos usar)
- añadimos la libc externa
- las versiones modernas de libc requieren librt y libpthread, las añadimos también
- con el parámetro `rpath` ordenamos al linker incluir en el fichero binario las rutas *hardcoded* donde buscar las librerías. Estas rutas tienen preferencia sobre las indicadas en `/etc/ld.so.conf`. Por tanto, cuando el cargador busque una *libc* para este ejecutable, encontrará la del router en lugar de cargar la de Raspbian.
- forzamos el cargador correcto, que es quien entiende cómo manejar esas librerías.

Compilado así, funciona sin problemas:

```console
pi@raspberrypi:~$ ./prog
Usage: ./prog [e|d] file_in file_out
```

Ya podemos **cifrar y descifrar a voluntad** usando las mismas funciones que el firmware. Nos será más sencillo hacer pruebas.

## Algoritmo de cifrado

Para estudiar cómo funciona el el cifrado **sin hacer ingeriería inversa** vamos a cifrar un fichero muy cortito. Por ejemplo 4 bytes, 4 letras "a".

```console
$ echo -n aaaa > testfile
$ ./prog e testfile testfile.out
header size         : 48
associated data size: 7
encrypted data size : 4
output size         : 59
Encryption returned: 0
```

Durante el proceso la propia librería gsdf revela cierta información. El tamaño de salida son 59 bytes. Resultado de sumar los anteriores 48 bytes de cabecera, 7 de *datos asociados* y 4 de datos cifrados.

Así es el fichero que obtenemos tras cifrar:

```console
$ hd testfile.out
00000000  41 45 41 44 20 31 30 00  00 00 00 3b 00 00 00 07  |AEAD 10....;....|
00000010  1e 19 15 3b 53 30 45 8f  12 99 99 b6 d5 db ff 66  |...;S0E........f|
00000020  51 f6 ac 1f 4d 9b 2f 2b  f5 85 8c bb 9b c4 ca 8d  |Q...M./+........|
00000030  64 65 66 61 75 6c 74 f4  7d ee fa                 |default.}..|
```

Tal como vimos antes, tenemos la firma `AEAD 10\0`. Luego el número `00 00 00 3b` equivalente a 59, eso es el tamaño. Después viene el número `00 00 00 07`, cabe pensar que se trata del dato *associated data size*.

Las filas 00000010 y 00000020 no sabemos aún qué son. Pero varían en cada iteración.

A continuación dice `default`. Supondremos que es el *associated data* porque mide 7 bytes.

Y finalmente 4 bytes cifrados `f4 7d ee fa`. El tamaño del cifrado es igual al tamaño del texto claro. Lo cual significa **stream cipher**. Si fuera un cifrador en bloque, la salida -como mínimo- habría sido del tamaño del bloque. Y no hay cifrado en flujo sin **vector de inicialización**.

En teoría, dicho vector debería ser aleatorio. Antes vimos un mensaje haciendo referencia a `/dev/urandom`. Abrir un fichero o leer de un fichero son llamadas al sistema. Como sabrás, *strace* es una utilidad que registra y muestra las llamadas al sistema efectuadas por un ejecutable.

```console
$ strace -x ./prog e testfile testfile.out
execve("./prog", ["./prog", "e", "testfile", "testfile.out"], [/* 17 vars */]) = 0
...
open("/dev/urandom", O_RDONLY)          = 3
read(3, "\x1e\x19\x15\x3b\x53\x30\x45\x8f\x12\x99\x99\xb6\xd5\xdb\xff\x66", 16) = 16
close(3)                                = 0
```

Aquí vemos cómo se ha abierto `/dev/urandom` y se han leído 16 bytes: `1e 19 ... ff 66`. Ve arriba y mira en el volcado del fichero la linea 00000010. Ahí tienes los 16 bytes del vector de inicialización.

Tal como habíamos supuesto, el algoritmo de cifrado no ha cambiado apenas respecto a lo encontrado en *noconroy.net*. Vamos a comprobar si la clave es distinta.

## La *nueva* clave

El cifrado, suponemos, sigue haciéndose con AES_CTR. Hay herramientas como [*aesfinder*](https://github.com/mmozeiko/aes-finder) capaces de encontrar una clave AES en la memoria de un proceso simplemente viendo el rastro que dejan las operaciones derivadas de ella. Realmente ingenioso. Una maravilla. No vamos a usarlo.

Seguiremos el método tradicional: ejecutaré el programa con el **depurador**, buscaré algún sitio donde pueda estar la clave y miraré cuál es. Veamos algunas funciones de la librería que podrían estar relacionadas con la clave:

```console
$ strings libgsdf.so | grep key
aes_setkey_enc
aes_setkey_dec
rsa_check_pubkey
rsa_check_privkey
rsa_gen_key
x509parse_key
x509parse_keyfile
...
```

Me gusta *aes_setkey_enc*. Suena a "función que llamas para establecer cuál va a ser la clave". La buscamos en Google. Encontramos lo que parece ser un SDK:
[WICED™ v3.1.0 - API Reference Guide](https://chenchenece.github.io/wiced-sdk/API/group__aes.html). Según dice ahí, este es su prototipo:

```c
// AES key schedule (encryption)
void aes_setkey_enc (aes_context_t *ctx, const unsigned char *key, int32_t keysize)
```

Recibe un puntero a una estructura (que no nos interesa), un puntero al buffer con la clave (que nos interesa mucho) y un entero con el tamaño de esta.

Abrimos gdb, ponemos un **punto de ruptura** y ejecutamos. Si tenemos suerte la ejecución se detendrá al entrar en la función:

```console
$ gdb --args ./prog e testfile testfile.out
GNU gdb (Raspbian 7.7.1+dfsg-5+rpi1) 7.7.1
...

(gdb) break aes_setkey_enc
Function "aes_setkey_enc" not defined.
Make breakpoint pending on future shared library load? (y or [n]) y
Breakpoint 1 (aes_setkey_enc) pending.

(gdb) r
Starting program: prog e testfile testfile.out
...
Breakpoint 1, 0x76fae380 in aes_setkey_enc () from libgsdf.so.1

(gdb)
```

Desconozco cómo se hace el **paso de parámetros** en arquitectura ARM. ¿En la pila, en los registros? Lo averiguaremos inspeccionando el código justo antes de hacer la llamada a la función *aes_setkey_enc*. Pedimos al depurador el stack de ejecución:

```console
(gdb) info stack
#0  0x76fae380 in aes_setkey_enc () from libgsdf.so.1
#1  0x76fad628 in gsdfAeadEncrypt () from libgsdf.so.1
```

Cuando aes_setkey_enc retorne, la ejecución se reanudará desde la dirección 0x76fad628, así que examinaremos los bytes previos a la llamada volcándolos en ensamblador:

```nasm
   0x76fad618 <+408>:   mov     r1, r8
   0x76fad61c <+412>:   mov     r0, r9
   0x76fad620 <+416>:   mov     r2, #256        ; 0x100
   0x76fad624 <+420>:   bl      0x76faaef4
   0x76fad628 <+424>:   mov     r1, r11
```

Se fijan tres registros: `r1`, `r0` y `r2`. En `0x76fad624` se produce la llamada y la instrucción siguiente ya es por donde seguiría ejecutando el programa. Esos tres registros pueden ser los tres parámetros. ¿Qué valor toman?

```gdb
(gdb) i r
r0             0x7efff438       2130703416
r1             0x7efff3f8       2130703352
r2             0x100            256
```

Uno debe ser un puntero a estructura AES. El otro un puntero al buffer con la clave y el tercero su longitud. Ese último parece ser 256.

El registro `r1` contiene la dirección del buffer. 256 bits son 32 caracteres, los volcamos:

```gdb
(gdb) x /32bx $r1
0x7efff3f8:     0x7d    0xa2    0x58    0x13    0xdd    0x9d    0x7a    0x15
0x7efff400:     0x3e    0x60    0xa0    0x28    0xba    0xdd    0xb2    0x88
0x7efff408:     0x00    0x00    0x00    0x00    0x00    0x00    0x00    0x00
0x7efff410:     0x00    0x00    0x00    0x00    0x00    0x00    0x00    0x00
```

Espera... en el post de noconroy la clave de 128 bits (16 carácteres) era esta:

```console
7d a2 58 13 dd 9d 7a 15 3e 60 a0 28 ba dd b2 88
```

¡La primera mitad es idéntica! Ahora vez de 128 son 256 bits, pero se han limitado a **completar con ceros**.

Actualizamos el script de Python con esta *nueva* clave y ya puedo descifrar con él lo cifrado con la librería. Funciona.

```console
$ echo hola > testfile
$ ./prog e testfile testfile.out
header size         : 48
associated data size: 7
encrypted data size : 5
output size         : 60
Encryption returned: 0
$ python gsdf.py d < testfile.out
hola
```

Pero al revés, no. La librería no reconoce lo cifrado con Python.

```console
$ ./prog d testfile_python.out testfile_python
Error: gsdfAeadDecrypt returned -21
Decryption returned: -1
```

## Cifrado autenticado

AEAD, decíamos al principio, eran las iniciales de ***Authenticated Encryption with Associated Data***. Lo cual es un derivado de *Authenticated Encryption*. Y consiste en añadir al texto cifrado un **código** (MAC) en el que involucramos el mensaje y la propia clave de cifrado. El sistema destino se asegura así de procesar solo aquellos mensajes generados por alguien que estaba en posesión de la clave.

Hay varios esquemas en función de si calculamos el código del mensaje en claro o del mensaje ya cifrado. El más común y el recomendado es **cifrar el mensaje primero, y luego calcular un HMAC** de la clave y el texto cifrado.

El *Associated Data* simplemente son datos añadidos al mensaje cifrado. Que van **en claro** pero también entran en el cálculo del HMAC. Por lo que solamente se garantiza su integridad.

Según el programa de noconroy, en el F@ST 5355 se calculaba así:

```python
ciphertext = b"AEAD 10\x00"
ciphertext += int_to_hex(total_length, 4)
ciphertext += int_to_hex(tag_length, 4)
ciphertext += int_to_hex(iv, 16)
ciphertext += key
ciphertext += tag
ciphertext += data_ciphertext

h = SHA256.new()
h.update(ciphertext)
mac = h.digest()

...

ciphertext += mac[0:16]
```

El buffer se compone de:

- la firma "AEAD 10\0"
- los dos tamaños de 4 bytes (del fichero final y de los datos asociados)
- el vector de inicialización (16 bytes)
- la clave, en este modelo 16 bytes, en el nuestro 32
- los datos asociados (en la variable `tag`)
- y el mensaje cifrado

Se calcula un hash SHA-256 de todo y **los primeros 16 bytes** de ese hash es lo que emplean como MAC.

Este esquema se denomina ***Encrypt-then-MAC (EtM)***. Y, aunque cumple su función, la implementación es **mejorable**.

- En primer lugar, **truncar un hash** es muy mala idea. Una propiedad fundamental de una función hash como SHA256 es su alta resistencia a colisiones. Pero sólo es cierto si conservamos sus 256 bits (32 bytes) de salida. Si lo truncamos a 16 dicha propiedad se pierde.
- Es más, en lugar de usar un hash deberían haber usado una construcción **HMAC**, parecida a un hash, pero pensada especialmente para esta función.
- También se recomienda usar **claves diferentes** para cifrar y para calcular el MAC.

En cualquier caso, es suficiente para guardar la configuración de un router que tiene ***hardcoded*** la clave de cifrado. Veamos qué ha cambiado entre el modelo 5355 y el 5657 para que no funcione.

Empezamos por listar aquellas funciones de `libgsdf.so` relacionadas con un SHA-256.

```console
$ strings libgsdf.so | grep -i sha2
sha2_starts
sha2_update
sha2_finish
sha2_hmac_starts
sha2_hmac_update
sha2_hmac_finish
sha2_file
sha2_hmac
```

Cifraremos un fichero de prueba mientras ponemos *breakpoints* en `sha2_hmac_update` y en `sha2_update` para ver cuál usa y sobre qué se calcula:

```gdb
Breakpoint 3, 0x76fb2898 in sha2_update () from libgsdf.so.1
```

Ahí está, y tal como hicimos para `aes_setkey_dec` miramos su prototipo:

```c
void sha2_update( sha2_context *ctx, const unsigned char *input, size_t ilen )
```

Recibe tres parámetros:

- un puntero a la estructura inicializada
- un puntero al buffer sobre el que se calcula el hash
- el tamaño del buffer

```gdb
(gdb) i r
r0             0x7efff2c4    2130703044
r1             0x21018       135192
r2             0x37          55
```

Esta vez volcaremos el buffer en formato *hexdump*, así será más fácil reconocerlo.

```gdb
(gdb) define hd
>dump binary memory dump.bin $arg0 $arg0+$arg1
>shell hd dump.bin
>end

(gdb) hd $r1 $r2
00000000  41 45 41 44 20 31 30 00  00 00 00 3b 00 00 00 07  |AEAD 10....;....|
00000010  3e 1a b8 3a ac 70 2b d3  1a d8 43 64 c9 bf 49 88  |>..:.p+...Cd..I.|
00000020  7d a2 58 13 dd 9d 7a 15  3e 60 a0 28 ba dd b2 88  |}.X...z.>`.(....|
00000030  64 65 66 61 75 6c 74 2f  fb dc e9                 |default/...|
0000003b

(gdb)
```

En la línea 00000000 están la firma y los tamaños. La fila 00000010 era el vector de inicialización aleatorio. La fila 00000030 comenzaba en los datos asociados y seguía por el mensaje cifrado. La fila 00000020, aquí ha resultado ser los **primeros 16 bytes** de la clave de 32.

El hash SHA-256 del buffer anterior es:

```console
$ xxd -r /tmp/buffer | sha256sum -
4f7974990219ddebdaa204827e57aaa82003adba8a159a6a21b7b7d320578655  -
```

Mientras que el fichero cifrado:

```console
$ hd testfile.out
00000000  41 45 41 44 20 31 30 00  00 00 00 3b 00 00 00 07  |AEAD 10....;....|
00000010  3e 1a b8 3a ac 70 2b d3  1a d8 43 64 c9 bf 49 88  |>..:.p+...Cd..I.|
00000020  4f 79 74 99 02 19 dd eb  da a2 04 82 7e 57 aa a8  |Oyt.........~W..|
00000030  64 65 66 61 75 6c 74 2f  fb dc e9                 |default/...|
```

Vemos como en la línea 00000020, donde antes estaban los primeros 16 bytes de la clave, ahora están los primeros 16 bytes del hash calculado.

El algoritmo por tanto sigue siendo el mismo. Sólo que en lugar de utilizar la clave completa para calcular el MAC, sólo se usan **los primeros 16 bytes**. Hacemos ese pequeño cambio en el script de Python y...

```console
$ python gsdf.py e < testfile > testfile.out
$ ./prog d testfile.out testfile
input size          : 59
header size         : 48
associated data size: 7
decrypted data size : 4
Decryption returned: 0
```

Hemos conseguido hacer funcionar el programa Python con tan sólo cambios menores. En este repositorio GitHub os dejo el resultado: [tr-069-proxy part2](https://github.com/electronicayciencia/tr-069-proxy/tree/main/part2).

## Implicaciones de seguridad

Una vez descifrado, el fichero de configuración contiene información de todo tipo. Por ejemplo:

- Datos identificativos del dispositivo (fabricante, modelo y número de serie)
- Cuentas de usuario, perfiles de acceso y contraseñas en claro
- Configuración de los puntos de acceso WiFi (SSID, contraseña, PIN WPS, filtrado por MAC)
- Datos de registro VoIP del usuario
- Configuración del ACS (URL, usuario y contraseña)
- Accesos remotos habilitados (HTTPS, HTTP, SSH o telnet)
- Configuración del filtro parental y cortafuegos
- Listado de los hosts conectados a la red (IP, MAC, hostname)
- Configuración de la interfaz óptica (RegId o PLOAM password)

Sumado al **usuario y contraseña por defecto** "1234/1234" podría dar lugar a escenarios como estos:

Un intruso que accediera puntualmente a tu red por un punto de acceso mal configurado, podría entrar en el router usando el usuario 1234. Y una vez dentro volcar la configuración y descifrarla. Obteniendo toda la información. No sólo eso. Podría manipular la configuración. Activando el WPS o el **acceso remoto SSH**.

El fichero también contiene los **datos de configuración VoIP**. Con estos datos alguien podría configurar un teléfono SIP y hacer llamadas que quedarían reflejadas **en tu factura**.

Con el fin de **evitarlo**, algunos ISP han eliminado la opción de salvar y cargar un *backup*. Un movimiento agresivo y desconsiderado hacia el usuario final.

Una solución más adecuada podría ser **solicitar una contraseña** al usuario en el momento de generar el fichero y utilizarla para derivar la clave de cifrado; en lugar de usar siempre la misma clave estática.

## Conclusiones

En este artículo hemos investigado cómo funciona el mecanismo de cifrado de la configuración de un router doméstico. Partiendo del algoritmo de un modelo anterior, lo hemos actualizado con tan sólo unos **cambios menores**.

Hemos visto cómo llamar a las funciones de una librería desconocida; para lo cual fue necesario compilar un programa totalmente desligado de las librerías del sistema anfitrión.

A la hora de estudiar el funcionamiento interno del algoritmo nos hemos valido únicamente de **herramientas genéricas** como *strings*, *gcc*, *gdb*, *strace* o *hexdump*, presentes en muchos sistemas Unix.

Para terminar, hemos discutido algunas implicaciones de seguridad relacionadas con el uso de una **clave estática** oculta al usuario. Exponiendo, una vez más, cómo la **seguridad por oscuridad** penaliza al usuario final sin aportar protección contra un atacante.

## Referencias

Artículos relacionados:

- [Describiendo un protocolo desconocido - electronicayciencia]({{site.baseurl}}{% post_url 2017-12-25-describiendo-un-protocolo-desconocido %})
- [Obteniendo la PLOAM password de un router F@ST 5657 - electronicayciencia]({{site.baseurl}}{% post_url 2020-10-26-obteniendo-ploam-password-fast-5657 %})

Para ampliar información:

- [Magic number (programming) - In Files - Wikipedia](https://en.wikipedia.org/wiki/Magic_number_(programming)#In_files)
- [Null-terminated_string - Wikipedia](https://en.wikipedia.org/wiki/Null-terminated_string)
- [DOS_MZ_executable - Wikipedia](https://en.wikipedia.org/wiki/DOS_MZ_executable)
- [Authenticated encryption - Wikipedia](https://en.wikipedia.org/wiki/Authenticated_encryption)
- [Block cipher mode of operation - Counter (CTR) - Wikipedia](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Counter_(CTR))
- [Sagemcom F@ST5355 Reverse Engineering - Part 2 - noconroy.net](https://web.archive.org/web/20180129221204/https://noconroy.net/sagemcom-fast5355-re-p2.html)
- [Sagemcom F@ST5355 Reverse Engineering - Part 3 - noconroy.net](https://web.archive.org/web/20180129221204/https://noconroy.net/sagemcom-fast5355-re-p3.html)
- [aesfinder - github](https://github.com/mmozeiko/aes-finder)
- [WICED™ v3.1.0 - API Reference Guide](https://chenchenece.github.io/wiced-sdk/API/group__aes.html)

Ficheros usados durante el artículo:

- [Sagemcom F@ST 5657 configuration decryptor - electronicayciencia](https://github.com/electronicayciencia/tr-069-proxy/tree/main/part2)
