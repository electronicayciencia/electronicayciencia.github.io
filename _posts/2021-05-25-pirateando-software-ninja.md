---
title: Pirateando software Ninja
layout: post
assets: /assets/2021/05/pirateando-software-ninja/
image: /assets/2021/05/pirateando-software-ninja/img/featured.jpg
featured: false
tags:
  - Binario
  - Informática
---

¡Vamos a piratear Software! No, es broma. Vamos a aprender de informática... a bajo nivel... mientras **depuramos** software.

{% include image.html file="featured.jpg" caption="Ninja, Pirate, Awesome. [PixelBunny - Devianart](https://www.deviantart.com/pixelbunny/art/Ninja-Pirate-Awesome-132809508)" %}

Supón que encuentras por ahí un programa. No importa cómo se llama. Es un software muy específico y aburrido. Llamémosle el [**Servidor Ninja**](https://www.urbandictionary.com/define.php?term=Ninja%20Report). ¿Vale?

Como decía, te descargas el *Servidor Ninja*, que funciona en **Linux**. Y viene con una licencia de ejemplo:

```ini
#-------------------------------------------------------------
# License created by Ninja_LIC_Generator
# WARNING: do NOT modify any part of this file.
#-------------------------------------------------------------

TYPE = FLOATING
HOST = 000C32F4EAC4
TOOL = {ninja, 2016-06-01, 10}

58DA44C35FB678F44056EE11B5E6C289480A78E2
673F17DD54BC551BA9E5E4B2FD11F90B45945C46
B7B635AAA6FA12D271C544A4B9D6D9B677AC45CD
```

Hay una **fecha**, caducada. Y además va ligada al equipo (HOST) por lo que parece ser la **MAC** de la tarjeta de red. Al final varias líneas sin sentido.

Total, que cuando vas a ejecutar el *Servidor Ninja* te devuelve un **error**:

```console
$ ./ninja_server 

10:35 > loading license...
10:35 > <error> host-id does not match, please check your license file.
```

Lo más rápido **es cambiar la MAC y la fecha** del equipo. Todos sabemos buscar en Google cómo se hace. No tiene ciencia.

Yo te voy a contar **otras formas** de hacer que funcione. Empezando por un truco sencillo y terminando por... por aburrirte o sorprenderte. Ya veremos.


## Camino fácil: Obviar la comprobación

Editamos la licencia original y actualizamos la fecha y la MAC. En tu cabeza ya sabes que no sirve. Porque intuyes que las tres líneas en hexadecimal al final del fichero deben valer para algo.

```
TYPE = FLOATING
HOST = 000c297676a9
TOOL = {ninja, 2030-06-01, 10}
```

Has acertado, no arranca:

```
11:21 > loading license...
11:21 > <error> invaild license, or license file was modified artificially. please check your license file.
```

A mi el *reversing* me parece muy complicado. Me lleva mucho tiempo descifrar qué es cada cosa. Por eso intento saber cómo funciona un programa antes de diseccionarlo. Como vimos en [Descifrando la configuración del Sagemcom F@ST 5657]({{site.baseurl}}{% post_url 2021-02-14-descifrar-configuracion-sagemcom-fast5657 %}).

Empezaré por **strace**, una utilidad que muestra las llamadas al **sistema**. En este caso sólo le vemos abrir el fichero con nuestra licencia manipulada, lo lee y poco después escribe el mensaje de error y sale. Nada útil.

Probemos con **ltrace**. A diferencia de *strace*, ltrace muestra las llamadas a **librerías**. Funciona de forma muy interesante: [How does ltrace work? - packagecloud blog](https://blog.packagecloud.io/eng/2016/03/14/how-does-ltrace-work/).

```console
$ ltrace ./ninja_server
...
_ZN18QCryptographicHash4hashERK10QByteArrayNS_9AlgorithmE(0x7ffe0b376300, 0x7ffe0b376200, 2, 0x7ffe0b376200) = 0x7ffe0b376300
_Z5qFreePv(0xdf35d0, 0x7ffe0b376300, 0xdf3500, 1)                                            = 0
_ZNK10QByteArray5toHexEv(0x7ffe0b376320, 0x7ffe0b376200, 0x7ffe0b376200, 6)                  = 0x7ffe0b376320
_ZNK10QByteArray7toUpperEv(0x7ffe0b376310, 0x7ffe0b376320, 0x7ffe0b376320, 20)               = 0x7ffe0b376310
_Z5qFreePv(0xdf3340, 0x7ffe0b376310, 0xdf3300, 6352)                                         = 0
_Z5qFreePv(0xdfdb20, 0xddb020, 0xdfdb00, 7)                                                  = 0
_ZNK7QString6toUtf8Ev(0x7ffe0b376330, 0xdfcfb8, 0xdfcfb8, 0)                                 = 0x7ffe0b376330
memcmp(0xdfd238, 0xdfdee8, 40, 4)                                                            = 4
```

Unas cuantas funciones con nombre ilegible. Luego una llamada a **memcmp**. Después imprime el error y termina.

La función *memcmp* compara dos fragmentos de memoria de longitud dada. Si son iguales devuelve **0**. Aquí devuelve **4** o sea que son distintos. Compara **40** caracteres, precisamente lo que miden las tres líneas finales del fichero.

Yo creo que está comparando las líneas con el valor esperado, como no son iguales da error y termina.

Dice el diccionario:

> obviar:
>
>   Evitar un impedimento o una dificultad o eludir una cosa inconveniente.

Puede que conozcas el truco del *LD_PRELOAD*. Sáltate el apartado si quieres. Si no, te va a encantar. Me voy a hacer mi propia **memcmp**, y va a devolver 0.

Este es el prototipo de *memcmp* según el manual:

```c
int memcmp(const void *s1, const void *s2, size_t n);
```

Programo una función con el mismo nombre y parámetros, pero que siempre devuelve 0.

```c
#include <string.h>

int memcmp(const void *s1, const void *s2, size_t n) {
    return 0;
}
```

La compilamos como una librería compartida:

```console
$ gcc -fpic -shared -o memcmp.so memcmp.c
```

Y al lanzar el *servidor ninja* lo hacemos con la variable **LD_PRELOAD** apuntando a nuestra librería. Con esta variable, el cargador dinámico preferirá nuestra función a la original.

```console
$ LD_PRELOAD=memcmp.so ./ninja_server 
===========OooO=============================OooO==========
=======                                            =======
=====                                                =====
====          NINJA Floating License Server           ====
====        Copyright (C) 2014-2020 NINJASOFT         ====
=====                                                =====
=======                                            =======
===========OooO=============================OooO==========

11:14 > loading license...
        tool: ninja, limit: 10, expired date: 2030-06-01
11:14 > starting server...
        Host-id: 000c297676a9
        IP Address: 192.168.1.142
        Listening Port: 10559
11:14 > server started successfully
```

¡Sí! Arranca porque todas las **comparaciones** han salido bien (todas han devuelto **0** ¿no?, *guiño*).

En este caso el programa es lo suficientemente simple. Pero lo normal habria sido devolver 0 sólo cuando el número de caracteres a comparar es 40 y, en caso contrario, llamar a la función *memcmp* **original** con los parámetros recibidos.

Si quieres ampliar información sobre LD_PRELOAD, aquí hay una explicación muy buena: [Playing with LD_PRELOAD - BreakInSecurity](https://axcheron.github.io/playing-with-ld_preload/).


## Camino intermedio: Obtener los hashs válidos

¿Ha sido demasiado sencillo engañar al *servidor ninja*? En lugar de eso, intentemos obtener los valores correctos para hacer que nuestra licencia falsa se convierta en válida.

¿Recuerdas las funciones ilegibles que salían cuando *ltrace*? Se llaman ***mangled names***. En C no, pero en C++ ocurre que la misma función puede tener distintos argumentos o resultados, siendo en realidad funciones diferentes con el mismo nombre. Se llama *sobrecarga de funciones*. Lo cual supone un problema para el compilador, porque ahora tiene símbolos diferentes que se llaman igual.

Para solucionarlo, les asigna un nombre incluyendo la clase, el método, los argumentos, tipo de salida, etc. Por ejemplo 

```
_ZNK10QByteArray5toHexEv ==> QByteArray::toHex()
```

El parámetro `-C` de ltrace realiza la operación inversa: *demangle*. Habría servido igualmente el comando `c++filt`.

```console
$ ltrace -C ./ninja_server
...
QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)(0x7ffedc349ae0, 0x7ffedc3499e0, 2, 0x7ffedc3499e0) = 0x7ffedc349ae0
qFree(void*)(0xb9c5d0, 0x7ffedc349ae0, 0xb9c500, 1)                              = 0
QByteArray::toHex() const(0x7ffedc349b00, 0x7ffedc3499e0, 0x7ffedc3499e0, 6)     = 0x7ffedc349b00
QByteArray::toUpper() const(0x7ffedc349af0, 0x7ffedc349b00, 0x7ffedc349b00, 20)  = 0x7ffedc349af0
qFree(void*)(0xb9c340, 0x7ffedc349af0, 0xb9c300, 6352)                           = 0
qFree(void*)(0xba6b20, 0xb84020, 0xba6b00, 7)                                    = 0
QString::toUtf8() const(0x7ffedc349b10, 0xba5f68, 0xba5f68, 0)                   = 0x7ffedc349b10
memcmp(0xba61e8, 0xba6408, 40, 4)                                                = 4
```

De ahí deducimos que *ninja_server* está hecho en C++ y utiliza las librerías Qt. 

Claro que también podíamos haber mirado el Zip:

```
ninja_server
libQtCore.so.4
libQtNetwork.so.4
libstdc++.so.6
ninja.lic
```

*ltrace* muestra los parámetros de la llamada a *memcmp* como **punteros**, a nosotros nos sería más útil si los mostrara como **strings**. Así sabríamos qué compara.

Eso lo puedes configurar editando (o creando) el fichero `~./ltrace.conf`. Escribimos lo siguiente para forzar el prototipo de *memcmp*:

```c
int memcmp(string, string, int);
```

Ahora lanzamos *ltrace* filtrando sólo las llamadas a *memcmp*. Y fijamos el tamaño de las strings en más de 40 para que las escriba completas.

```console
$ ltrace -s 41 -e memcmp ./ninja_server 

19:29 > loading license...

ninja_server->memcmp("A9F6163734EAED71DB2D2BA7C59426CD89357624", "F6FF57A3826AD18F28B98EA97F52B4533CD319D1", 40) = -5

19:29 > <error> invaild license, or license file was modified artificially. please check your license file.
+++ exited (status 255) +++
```

Una de las cadenas está en el fichero. La otra es la que debería estar. Sustituimos el valor. Volvemos a probar y lógicamente falla la segunda línea. Misma operación. Igual con la tercera.

```console
$ ltrace -s 41 -e memcmp ./ninja_server 

19:29 > loading license...

ninja_server->memcmp("F6FF57A3826AD18F28B98EA97F52B4533CD319D1", "F6FF57A3826AD18F28B98EA97F52B4533CD319D1", 40) = 0
ninja_server->memcmp("3C8CDA3EC604EE8ECFD43BC13832610AC4948BF7", "3C8CDA3EC604EE8ECFD43BC13832610AC4948BF7", 40) = 0
ninja_server->memcmp("D48CDE2967BA6EF17750CB166FC4D934B6AF9A7E", "9B5A560B5950A32D1547C67CBBBC3D70E10D76B5", 40) = 11

19:29 > <error> invaild license, or license file was modified artificially. please check your license file.
+++ exited (status 255) +++
```

Tras sustituir las tres líneas la licencia se convierte en válida.

```console
$ ./ninja_server 
===========OooO=============================OooO==========
=======                                            =======
=====                                                =====
====          NINJA Floating License Server           ====
====        Copyright (C) 2014-2020 NINJASOFT         ====
=====                                                =====
=======                                            =======
===========OooO=============================OooO==========

19:29 > loading license...
        tool: ninja, limit: 10, expired date: 2030-06-01
19:29 > starting server...
        Host-id: 000c297676a9
        IP Address: 192.168.1.154
        Listening Port: 10559
19:29 > server started successfully
```

Ya tenemos nuestra licencia validada sin haber entrado ni a mirar el ejecutable.


## Camino chungo: Aprender a generar los hashs

¿Pero qué tendrán esas tres líneas? ¿No tienes curiosidad? La traza de *ltrace* hacía referencia a `QCryptographicHash`. No cabe duda que se trata de alguna operación criptográfica.

Si yo tuviera que hacer un validador de licencias supongo que lo haría firmando el fichero con una **clave asimétrica**. En el generador de licencias dejaría la clave privada y en el software la parte pública. Si la firma es válida, la licencia es original.

Otra opción sería incluir en la licencia un HMAC. Cuya clave compartirían el generador de licencias y el software original. Es más débil pero también más simple. Sólo usa criptografía simétrica.

En *Ninja Soft* no sé cómo lo harán. Me llama la atención que haya ¿tres *hashes*? para un mismo fichero. El programa lo hemos roto ya de dos formas distintas, pero quiero saber qué se *hashea*.

Con **QCryptographicHash::hash** no podemos hacer lo mismo que con memcmp -mostrar sus argumentos- porque no recibe un string sino un QByteArray. 

Ahora sí, tendremos que entrar en el ejecutable.

Pero antes algunas opciones interesantes en `~/.gdbinit`:

```bash
set history save on
set history remove-duplicates 20
set history filename ~/.gdb_history
set disassembly-flavor intel

define hd
dump binary memory dump.bin $arg0 $arg0+$arg1
shell hd dump.bin
end

set print demangle on
set print asm-demangle on
```

Habilitamos el **historial**. Cambiamos el ensamblador de AT&T a Intel (me apaño mejor). Definimos la **función `hd`** para volcar el contenido en hexadecimal y ASCII. Por último, activamos el ***demangle***.

Pondremos un punto de ruptura en `QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)`. La función se llama así.

```
(gdb) b QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)
Breakpoint 1 at 0x40ab78
```

Puedes ver la declaración de QCryptographicHash::hash en la documentación de Qt. [QCryptographicHash Class - Qt Documentation](https://doc.qt.io/qt-5/qcryptographichash.html)

```cpp
QByteArray QCryptographicHash::hash(const QByteArray &data, QCryptographicHash::Algorithm method)
```

El primer parámetro es un puntero a una estructura `QByteArray`. El segundo, un entero que indica el tipo de hash:

Constant | Value | Description
---------|-------|--------------
QCryptographicHash::Md4 | 0 | Generate an MD4 hash sum
QCryptographicHash::Md5 | 1 | Generate an MD5 hash sum
QCryptographicHash::Sha1 | 2 | Generate an SHA-1 hash sum
QCryptographicHash::Sha224 | 3 | Generate an SHA-224 hash sum (SHA-2).
QCryptographicHash::Sha256 | 4 | Generate an SHA-256 hash sum (SHA-2).

El valor de retorno será otro puntero a `QByteArray`.

Ejecutamos a ver dónde se para:

```
(gdb) r
Starting program...
19:43 > loading license...

Breakpoint 1, 0x00007ffff795fe00 in QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm) ()
```

Backtrace para saber de dónde viene la llamada:

```
(gdb) bt
#0  0x00007ffff795fe00 in QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm) ()
#1  0x00000000004133f3 in GLIC::LicData::fromTextStream (stream=...)
#2  0x000000000040dc42 in GLIC::LicManager::loadLicense (this=0x633540, strLicPath=...)
#3  0x000000000040afb5 in main (argc=1, argv=0x7fffffffe008)
```

El frame `#1` ya está en el programa principal. Se sabe por el nombre pero también por la dirección de memoria. Lo seleccionamos.

```
(gdb) f 1
#1  0x00000000004133f3 in GLIC::LicData::fromTextStream (stream=...)
```

E inspeccionamos las operaciones justo antes del `call`:

```nasm
lea    rax,[rbp-0x1b0]
lea    rcx,[rbp-0x1a0]
mov    edx,0x2
mov    rsi,rcx
mov    rdi,rax
call   0x40ab78 <QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)@plt>
```

El entero está en **EDX**. Es **2**, corresponde a **sha1**.

Sobre los punteros de entrada y salida, uno será **RSI** y el otro **RDI**. No sé cuál es cual. Eso sí, está claro que vienen de sendas variables locales en `[rbp-0x1a0]` y `[rbp-0x1b0]` respectivamente.

En el momento de efectuar la llamada, el contenido de ambos registros (como puntero *address*) es:

```
(gdb) x/a $rsi
0x7fffffffda90:    0x63dc30
(gdb) x/a $rdi
0x7fffffffda80:    0x7ffff7a00f00
```

Qué tenemos en la memoria a donde apunta **RDI**:

```
(gdb) hd *$rdi 30
Cannot access memory at address 0xfffffffff7a00f00
```

Ese no va a ser el origen. Será el valor devuelto pero aún no lo tenemos.

Y en **RSI**:

```
(gdb) hd *$rsi 0x100
00000000  01 00 00 00 e0 01 00 00  23 01 00 00 00 00 00 00  |........#.......|
00000010  48 dc 63 00 00 00 00 00  23 2d 2d 2d 2d 2d 2d 2d  |H.c.....#-------|
00000020  2d 2d 2d 2d 2d 2d 2d 2d  2d 2d 2d 2d 2d 2d 2d 2d  |----------------|
*
00000050  2d 2d 2d 2d 2d 2d 0a 23  0a 23 20 4c 69 63 65 6e  |------.#.# Licen|
00000060  73 65 20 63 72 65 61 74  65 64 20 62 79 20 4e 69  |se created by Ni|
```

Eso parece el contenido del fichero con unos bytes encima a modo de cabecera. Debe ser la estructura `QByteArray`.

```
01 00 00 00  <- no sé
e0 01 00 00  <- 0x1e0 = 480 ¿tamaño quizá?
23 01 00 00  <- 0x123 = 291 ¿otro tamaño?
00 00 00 00  <- tampoco lo sé
48 dc 63 00 00 00 00 00  <- 0x63dc48 puntero a memoria (de 64bits) ¿es donde está string?
23 2d 2d 2d 2d 2d 2d 2d 2d 2d 2d 2d 2d ... <- string
```

La dirección `0x63dc48` es justo donde comienza el string:

```
(gdb) hd 0x63dc48 0x1e0
00000000  23 2d 2d 2d 2d 2d 2d 2d  2d 2d 2d 2d 2d 2d 2d 2d  |#---------------|
00000010  2d 2d 2d 2d 2d 2d 2d 2d  2d 2d 2d 2d 2d 2d 2d 2d  |----------------|
*
00000030  2d 2d 2d 2d 2d 2d 2d 2d  2d 2d 2d 2d 2d 2d 0a 23  |--------------.#|
00000040  0a 23 20 4c 69 63 65 6e  73 65 20 63 72 65 61 74  |.# License creat|
00000050  65 64 20 62 79 20 4e 69  6e 6a 61 5f 4c 49 43 5f  |ed by Ninja_LIC_|
00000060  47 65 6e 65 72 61 74 6f  72 0a 23 0a 23 20 57 41  |Generator.#.# WA|
...
00000100  61 39 0a 54 4f 4f 4c 20  3d 20 7b 6e 69 6e 6a 61  |a9.TOOL = {ninja|
00000110  2c 20 32 30 33 30 2d 30  36 2d 30 31 2c 20 31 30  |, 2030-06-01, 10|
00000120  7d 0a 0a 00 00 00 00 00  00 00 00 00 00 00 00 00  |}...............|
00000130  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001e0
```

Los primeros `0x123` bytes son el texto del fichero de licencia menos las tres últimas líneas. El resto, ceros. Probablemente espacio reservado por si crece QByteArray.

Entonces, en la pila, en `[rbp-0x1a0]` es donde está el puntero al QByteArray que contiene la licencia sin los *hashes*. Volvemos al frame `#0` para terminar la llamada y cotillear el valor devuelto.

```
(gdb) f 0
(gdb) finish
Run till exit from #0  0x00007ffff795fe00 in QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm) ()
```

Examinamos las variables nuevamente:

```
(gdb) x/a $rbp-0x1a0
0x7fffffffda90:    0x63dc30
(gdb) x/a $rbp-0x1b0
0x7fffffffda80:    0x63ba70
```

En `[rbp-0x1a0]` estaba la licencia, sigue igual. Ahora `[rbp-0x1b0]` ya sí es accesible:

```
(gdb) hd 0x63ba70 0x40
00000000  01 00 00 00 14 00 00 00  14 00 00 00 ff 7f 00 00  |................|
00000010  88 ba 63 00 00 00 00 00  24 cd fc 68 bf d7 a1 d5  |..c.....$..h....|
00000020  cb 1b b5 9d db 22 35 1b  dc 49 5d f1 00 00 00 00  |....."5..I].....|
00000030  40 00 00 00 00 00 00 00  41 00 00 00 00 00 00 00  |@.......A.......|
```

Debe contener el valor devuelto en forma de **QByteArray**. Se supone que con el **SHA1** del texto de entrada:

```
01 00 00 00  <- (no sé qué es)
14 00 00 00  <- 20 bytes
14 00 00 00  <- 20 bytes
ff 7f 00 00  <- (no sé qué es)
88 ba 63 00 00 00 00 00  <- puntero al string
24 cd fc 68 bf d7 a1 d5 cb 1b b5 9d db 22 35 1b dc 49 5d f1  <- string (hash sha1)
```

¿Realmente es el SHA1 del fichero quitando las tres últimas líneas?

```console
$ cat ninja.lic | head -n-3 | sha1sum 
24cdfc68bfd7a1d5cb1bb59ddb22351bdc495df1  -
```

¡Sí! Vamos bien por ahora.


## Desensamblado del primer hash

Si te has liado con lo anterior no pasa nada. Te miras la *[System V AMD64 ABI calling convention](https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI)* y dice:

> The first six integer or pointer arguments are passed in registers RDI, RSI, RDX, RCX, R8, R9

En resumen, el valor de salida -argumento cero- va en **RDI**, el puntero origen -primer argumento- en **RSI** y el algoritmo, -segundo argumento- en **RDX**.

El *servidor ninja* comprueba la licencia validando tres líneas. Veamos cómo se calcula la primera.

Este listado aunque parezca largo es fácil de seguir. Se repite siempre la misma estructura: 

- Carga de variables en la pila a registros
- Asignación de los registros adecuados (RDI, RSI, ...)
- Llamada a la función que corresponda.


```nasm
; hash: data = sha1(licencia)
lea    rax,[rbp-0x1b0] ; destino => data
lea    rcx,[rbp-0x1a0] ; origen  => licencia
mov    edx,0x2         ; alg     => sha1
mov    rsi,rcx
mov    rdi,rax
call   0x40ab78 <QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)@plt>
   
; hash: tmp1 = sha1(data)
lea    rax,[rbp-0x160] ; tmp1
lea    rcx,[rbp-0x1b0] ; data
mov    edx,0x2         ; sha1
mov    rsi,rcx
mov    rdi,rax
call   0x40ab78 <QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)@plt>

; asignación: data = tmp1
lea    rdx,[rbp-0x160] ; tmp1
lea    rax,[rbp-0x1b0] ; data
mov    rsi,rdx
mov    rdi,rax
call   0x414040 <QByteArray::operator=(QByteArray&&)>

; destruir tmp1
lea    rax,[rbp-0x160] ; tmp1
mov    rdi,rax
call   0x40b62a <QByteArray::~QByteArray()>

; hash: tmp2 = sha1(data)
lea    rax,[rbp-0x150] ; tmp2
lea    rcx,[rbp-0x1b0] ; data
mov    edx,0x2         ; sha1
mov    rsi,rcx
mov    rdi,rax
call   0x40ab78 <QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)@plt>

; asignar data = tmp2
lea    rdx,[rbp-0x150] ; tmp2
lea    rax,[rbp-0x1b0] ; data
mov    rsi,rdx
mov    rdi,rax
call   0x414040 <QByteArray::operator=(QByteArray&&)>

; destruir tmp2
lea    rax,[rbp-0x150] ; tmp2
mov    rdi,rax
call   0x40b62a <QByteArray::~QByteArray()>

; pasar data a Hex   
lea    rax,[rbp-0x130] ;
lea    rdx,[rbp-0x1b0] ; data
mov    rsi,rdx
mov    rdi,rax
call   0x40a438 <QByteArray::toHex() const@plt>

; pasar Hex(data) a mayúsculas
lea    rax,[rbp-0x140]
lea    rdx,[rbp-0x130]
mov    rsi,rdx
mov    rdi,rax
call   0x40a898 <QByteArray::toUpper() const@plt>
```

Cualquier decompilador te traduciría ese código a esto:

```c
data = sha1(licencia)
data = sha1(data)
data = sha1(data)
hash1 = to_upper(to_hex(data))
```

Y uno bueno, a esto otro:

```c
hash1 = sha1(sha1(sha1(licencia)))
```

O sea, no hay salt, ni contraseña, nada de HMAC ni de firma RSA. Tan sólo tres SHA1 en **cascada**. ¿¡En serio!?

La primera línea de nuestra licencia válida es: `F6FF57A3826AD18F28B98EA97F52B4533CD319D1`.

Comprobamos:

```console
$ cat ninja.lic | head -n-3 | sha1sum | xxd -r -p | sha1sum | xxd -r -p | sha1sum
f6ff57a3826ad18f28b98ea97f52b4533cd319d1  -
```

Correcto.


## Segundo y tercer hash

Vamos a la segunda línea. Un código similar que parte también de `[rbp-0x1a0]` (ahí estaba el texto de la licencia *ninja.lic*).

```nasm
lea    rax,[rbp-0x1c0] ; destino => data
lea    rcx,[rbp-0x1a0] ; origen  => licencia
mov    edx,0x1         ; alg     => md5
mov    rsi,rcx
mov    rdi,rax
call   0x40ab78 <QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)@plt>

lea    rax,[rbp-0x120]
lea    rcx,[rbp-0x1c0]
mov    edx,0x2         ; alg     => sha1
mov    rsi,rcx
mov    rdi,rax
call   0x40ab78 <QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)@plt>
...
```

La única diferencia con el apartado anterior es que EDX en vez de 2 vale 1. O sea, el primer hash en lugar de ser SHA1 es MD5. En fin...

```c
hash2 = sha1(sha1(md5(licencia)))
```

Segunda línea: `3C8CDA3EC604EE8ECFD43BC13832610AC4948BF7`

Comprobación:

```console
$ cat ninja.lic | head -n-3 | md5sum | xxd -r -p | sha1sum | xxd -r -p | sha1sum
3c8cda3ec604ee8ecfd43bc13832610ac4948bf7  -
```

Correcto.

El tercer hash te lo ahorro. Más de lo mismo. Esta vez los dos primeros son MD5.

```c
hash3 = sha1(md5(md5(licencia)))
```

Tercera línea: `9B5A560B5950A32D1547C67CBBBC3D70E10D76B5`

Comprobación:

```console
$ cat ninja.lic | head -n-3 | md5sum | xxd -r -p | md5sum | xxd -r -p | sha1sum
9b5a560b5950a32d1547c67cbbbc3d70e10d76b5  -
```

Si pasas el resultado a mayúsculas ya puedes hacerte un **generador de licencias** en Bash.


## Conclusión

*Ninja Soft* **no** es una empresa de software. Se dedica a... digamos... las *patatas fritas* ¿ok?.

El *servidor ninja* es para que te puedas comer sus *patatas fritas*. Licenciará su software por motivos administrativos o legales. Tal vez se gane unos ingresos extra con licencias corporativas, es posible, pero para particulares es gratuito. Su negocio son las *patatas fritas*. No le merece la pena invertir mucho dinero en un gestor de licencias sofisticado para su software.

Claro que, en vez de **tres hashes sencillos** calculados a base de encadenar distintos algoritmos sobre el **mismo texto**, una firma asimétrica o un HMAC habrían sido igual de efectivos y -diría- más elegantes.

No me gustan los **crackme** ni los CTF porque son demasiado enrevesados. En la **vida real** la gente programa para hacer lo que le pide su jefe, lo mejor que sabe, en el menor tiempo posible. Cumplir objetivos y llevar dinero a casa. En la vida real la gente se deja los *símbolos* para encontrar los fallos más fácilmente. Y distribuye un software con información de depuración porque sencillamente nadie le ha pedido que la quite.


## Camino hardcore: Bonus con *ltrace*

¿Te parece atrevido usar **gdb** como herramienta de reversing? De acuerdo, lo haré sin él.

Arriba habíamos visto cómo *ltrace* mostraba la siguiente llamada:

```console
$ ltrace -C ./ninja_server
...
QCryptographicHash::hash(QByteArray const&, QCryptographicHash::Algorithm)(0x7ffedc349ae0, 0x7ffedc3499e0, 2, 0x7ffedc3499e0) = 0x7ffedc349ae0
```

Vamos a extraer lo que se *hashea* directamente con **ltrace**.

El ejecutable viene acompañado de la librería `libQtCore.so.4`. Es decir, se apoya en la versión 4 de Qt. Es Open Source. Pues nos vamos a [Qt 4 sources - Qt Downloads](https://download.qt.io/archive/qt/4.0/) y nos bajamos las fuentes.

En el fichero `src/corelib/tools/qbytearray.h` tienes la definición de la estructura `QByteArray`:

```c
struct Data {
    QBasicAtomic ref;
    int alloc, size;
    char *data;
    char array[1];
};
```

O sea que tiene 5 campos:

- **ref**, si se está usando o no
- **alloc**, tamaño máximo reservado
- **size**, longitud del contenido
- **data**, puntero al array
- **array**, contenido de array

De esos sólo nos interesa el tamaño y el puntero al string. 

Lo metemos en `~/.ltrace.conf` junto a la enumeración del algoritmo y el prototipo de la función (con su nombre *mangled*):

```c
typedef alg = enum(MD4,MD5,SHA1);
typedef QByteArray = struct (hide(int), hide(int), int, array(hex(char),elt3)*);

QByteArray** _ZN18QCryptographicHash4hashERK10QByteArrayNS_9AlgorithmE(hide(void), QByteArray**, alg);
```

Ejecutamos filtrando sólo esta función y limitando los arrays a las 4 primeras posiciones para que quede bonito al pegarlo. 

```console
$ ltrace -A 4 -C -e _ZN18QCryptographicHash4hashERK10QByteArrayNS_9AlgorithmE  ./ninja_server

13:58 > loading license...

ninja_server->QCryptographicHash::hash({ 291, [ 0x23, 0x2d, 0x2d, 0x2d... ] }, SHA1) = { 20, [ 0x24, 0xcd, 0xfc, 0x68... ] }
ninja_server->QCryptographicHash::hash({  20, [ 0x24, 0xcd, 0xfc, 0x68... ] }, SHA1) = { 20, [ 0xa0, 0xb7, 0x5a, 0x21... ] }
ninja_server->QCryptographicHash::hash({  20, [ 0xa0, 0xb7, 0x5a, 0x21... ] }, SHA1) = { 20, [ 0xf6, 0xff, 0x57, 0xa3... ] }

ninja_server->QCryptographicHash::hash({ 291, [ 0x23, 0x2d, 0x2d, 0x2d... ] }, MD5)  = { 16, [ 0x45, 0x00, 0x74, 0x83... ] }
ninja_server->QCryptographicHash::hash({  16, [ 0x45, 0x00, 0x74, 0x83... ] }, SHA1) = { 20, [ 0x5c, 0x3c, 0xb5, 0x03... ] }
ninja_server->QCryptographicHash::hash({  20, [ 0x5c, 0x3c, 0xb5, 0x03... ] }, SHA1) = { 20, [ 0x3c, 0x8c, 0xda, 0x3e... ] }

ninja_server->QCryptographicHash::hash({ 291, [ 0x23, 0x2d, 0x2d, 0x2d... ] }, MD5)  = { 16, [ 0x45, 0x00, 0x74, 0x83... ] }
ninja_server->QCryptographicHash::hash({  16, [ 0x45, 0x00, 0x74, 0x83... ] }, MD5)  = { 16, [ 0x88, 0x99, 0x57, 0x95... ] }
ninja_server->QCryptographicHash::hash({  16, [ 0x88, 0x99, 0x57, 0x95... ] }, SHA1) = { 20, [ 0x9b, 0x5a, 0x56, 0x0b... ] }

13:58 > <error> invaild license, or license file was modified artificially. please check your license file.
+++ exited (status 255) +++
```

Si aumentas el parámetro puedes ver todo lo que entra y sale de las funciones.

De ahí puedes deducir el algoritmo, más aún ahora que sabes cómo va:

- Hay tres grupos de tres llamadas al método *hash*.
- La primera llamada es igual en los tres grupos y se hace con un contenido de 291 bytes.
- El resultado de la primera se pasa a la segunda, y el de esta a su vez a la tercera.
- El resultado de la tercera llamada de cada grupo coincide con la línea del fichero de licencia.

Por cierto, una curiosidad más. ¿Te acuerdas arriba cuando describimos así a ojo el formato de QByteArray?

```
01 00 00 00  <- ref
14 00 00 00  <- tamaño disponible
14 00 00 00  <- tamaño usado
ff 7f 00 00  <- ¿?
88 ba 63 00 00 00 00 00  <- puntero al string
24 cd fc 68 bf d7 a1 d5 cb 1b b5 9d db 22 35 1b dc 49 5d f1 <- string
```

Hay un campo entre el tamaño usado y el puntero al string que no viene descrito en ninguna parte.

Es el **padding**. En arquitectura de 64 bits las estructuras se alinean para que los punteros comiencen siempre en múltiplos de 8 bytes. Ese campo, en esta estructura, son simplemente 4 bytes de **relleno**.

Te lo enseño con una prueba sencilla en C. Tengo una estructura con 2 campos: un entero (4 bytes) y un puntero (8 bytes).

```c
struct Prueba {
    int size;
    char *data;
};

int main() {
    struct Prueba a; 
  
    a.size = 0x11111111;
    a.data = 0x2222222233333333;

    return 0;
}
```

El entero lo relleno con todo **unos**. El puntero con **doses** y **treses**. Mira el volcado de memoria:

```
(gdb) hd &a 0x1
00000000  11 11 11 11 ff 7f 00 00  33 33 33 33 22 22 22 22  |........3333""""|
```

¿Ves el valor `ff 7f 00 00`? Para **rellenar**. Igual que este apartado.


## Referencias

Si te ha gustado, aquí te dejo las referencias y enlaces para seguir por tu cuenta:

Manuales y referencias:

- [ltrace(1) - Linux manual page](https://man7.org/linux/man-pages/man1/ltrace.1.html)
- [ltrace.conf(5) - Linux manual page](https://man7.org/linux/man-pages/man5/ltrace.conf.5.html)
- [memcmp(3) - Linux manual page](https://man7.org/linux/man-pages/man3/memcmp.3.html)
- [Data structure alignment - Wikipedia](https://en.wikipedia.org/wiki/Data_structure_alignment)
- [System V AMD64 ABI calling convention - Wikipedia](https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI)
- [QCryptographicHash Class - Qt Documentation](https://doc.qt.io/qt-5/qcryptographichash.html)


Artículos de blogs:

- [Playing with LD_PRELOAD - BreakInSecurity](https://axcheron.github.io/playing-with-ld_preload/)
- [How does ltrace work? - packagecloud blog](https://blog.packagecloud.io/eng/2016/03/14/how-does-ltrace-work/)
- [Descifrando la configuración del Sagemcom F@ST 5657 - Electrónica y Ciencia]({{site.baseurl}}{% post_url 2021-02-14-descifrar-configuracion-sagemcom-fast5657 %}).

Varios:

- [Qt 4 sources - Qt Downloads](https://download.qt.io/archive/qt/4.0/)

