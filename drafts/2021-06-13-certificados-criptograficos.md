---
title: Certificados criptográficos hechos a mano
layout: post
assets: /assets/2021/06/certificados-criptograficos
image: /assets/2021/06/certificados-criptograficos/img/trialdays.png
featured: false
description: Descomponemos el formato de un certificado criptográfico x.509 para manipularlo de forma no estándar.
tags:
  - Binario
  - Informática
  - Matemáticas
---

Descomponemos el formato de un certificado criptográfico x.509 para manipularlo de forma no estándar.

Hay un software cuya licencia de prueba consiste en un certificado x.509 dado por el fabricante. Cuando este expira, lo hace la licencia.

{% include image.html file="trialdays_30.png" caption="Me quedan 30 días de prueba. EyC." %}

El certificado, llamémosle *trial_cert* viene firmado por una Autoridad certificadora llamada *Trial CA*. En el software estará el certificado raíz de *Trial CA* que sirve para blindar las licencias ante manipulaciones.

Me gustaría cambiar la fecha de expiración de *trial_cert*. Pero no puedo porque no poseo la clave privada de *Trial CA*. La firma de mi certificado modificado nunca sería válida.

Lo que si tengo es acceso al software. Sé dónde se guarda el certificado raíz de *Trial CA*. Pienso sustituir el *Trial CA* original por uno mío. Y así poder firmar mis propios *trial_cert* y que sean válidos.

Pero hay un problema.

No me vale cualquiera. Ambos certificados deben tener exactamente la **misma longitud**. De lo contrario va a fallar. Si cambia el número de serie por otro más largo o más corto, falla. Si cambian las extensiones x509, falla. Si cambian los keyIdentifier... falla. No puede variar ni un sólo bit más de lo imprescindible.

¿Es posible tomar la CA original y cambiarle **únicamente la clave** dejando todo lo demás igual? A priori no. Cualquier **herramienta**, programada para generar certificados estándar, siempre **modificará otros campos**.

Por suerte el formato x509 está bien documentado. Si queremos algo *no compliant* tendremos que hacerlo **a mano**.


## x509 por dentro

¿Alguna vez has visto un certificado por dentro? Parece opaco e intimidante ¿verdad?:

{% include image.html file="certificate_example.png" caption="1024 RSA cert PEM Format. [fm4dd.com](https://fm4dd.com/openssl/certexamples.shtm)." %}

Aunque pueda parecerlo, los certificados **no van cifrados**, son públicos. Entonces, ¿por qué tiene ese aspecto?

Porque va codificado en base64. Cuando oyes hablar de *certificados* piensas en servidores HTTPS, errores de privacidad y avisos en el navegador. Pero no se inventaron para eso.

Al comienzo de internet todas las comunicaciones se hacían en claro. Bastante milagro era comunicar dos ordenadores como para preocuparse de que alguien estuviese mirando. Si bien las redes de comunicaciones se pensaron para difundir información y hacerla pública, pronto surgieron servicios donde la **privacidad** resultaba importante. Como el correo electrónico.

En 1985, aprovechando los recientes avances en criptografía asimétrica, se trabajó en una primera propuesta que dotaba al protocolo SMTP con la capacidad de firmar y cifrar **emails**.

{% include image.html file="pem_example.png" caption="PEM example. [Fuente](https://web2.utc.edu/~djy471/CPSC4670/17-privacy-email.pdf)." %}

Como los protocolos y los clientes de correo estaban pensados para texto, era complicado enviar datos binarios. En realidad sólo iban bien con caracteres ASCII de 7 bit ¡Hasta era complicado mandar **carácteres con tilde**, imagínate!

La propuesta introdujo un formato llamado **Privacy-Enhanced Mail** (PEM). Consistía en tomar las claves, firmas y otros elementos binarios y codificarlos dentro del mensaje en **Base64**. Muy usado ya entonces para transferir adjuntos vía eMail o News (NNTP). Luego se le añadía una cabecera `-----BEGIN ...` y un pie `-----END ...` para separarlos del resto del mensaje.

La propuesta no tuvo una adopción masiva. La Red se usaba poco y la seguridad no era una prioridad entonces.

Alrededor de 1994 *Taher Elgamal* propuso securizar otros protocolos, no sólo el SMTP. Y lanzó un estándar para cifrar, no los datos, sino el propio canal de transmisión, la **conexión**. Fue SSL 1.0. Nadie lo usó.

En 1995, salió SSL 2.0. Tímidamente algunos servicios empezaron a habilitar un puerto cifrado alternativo al habitual. La alternativa a **irc** se llamó **ircs**; **ftp** pasó a ser **ftps** (sftp es otra cosa distinta); estaban **ldap** y **ldaps**; y, por supuesto, **http** ofrecía **https**. Más como curiosidad que por seguridad real.

No fue hasta el año 2000, con la llegada de TLS (el sucesor de SSL 3.0), cuando el cifrado HTTP empezó a popularizarse y cobrar fuerza. De hecho hasta hace muy poco era lo normal seguir usando el puerto HTTP no cifrado para servicios autenticados o críticos.

El caso es que la adopción de PEM para el correo fue minoritaria. Muy pocos cifran su correspondencia electrónica, y quienes lo hacen hoy usan S/MIME. Y sin embargo el formato PEM -inventado hace casi 40 años- se ha convertido en el **estándar** *de-facto* para los certificados HTTPS.

Por esta razón te puedes encontrar los certificados x509 en **dos formatos**:

- Codificados en **base64**. Cuando además llevan las líneas de cabecera y pie se dice que es formato **PEM**.
- En **binario** directamente: **DER**.

Tras esta breve introducción histórica, hablemos de certificados x509 con **clave RSA**.


## La clave pública RSA

Las claves RSA ya sabes que tienen dos partes, una pública y otra privada. La parte **pública** se compone de:

- El **módulo**: Un número muy largo, de unos 600 dígitos (2048 bits) en este caso.
- Y el **exponente**. Un número cualquiera que vale 65537 (o a veces 3).

En la práctica, la única diferencia entre una clave pública y otra es el **módulo**.

De hecho, puedes imaginar si quieres un certificado como un **módulo con metadatos**.

Este es el certificado raíz, el de *Trial CA*:

```console
$ openssl x509 -inform pem -in TrialCA.cer  -text
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1484707279 (0x587ed5cf)
        Issuer: O = NA, CN = Trial CA
        Subject: O = NA, CN = Trial CA
        Validity
            Not Before: Jan 18 02:41:19 2017 GMT
            Not After : Jan 13 02:41:19 2037 GMT
```

Fíjate cómo el **Issuer** y el **Subject** son iguales. Debe ser así en todos los certificados raíz, porque son el último eslabón de la cadena de confianza. Se dice que está **autofirmado**.

Luego viene la validez. Y a continuación los parámetros RSA. Importante, **toda la información** contenida en un certificado **es pública**, siempre.

```
Subject Public Key Info:
    Public Key Algorithm: rsaEncryption
        RSA Public-Key: (2048 bit)
        Modulus:
            00:84:04:13:d2:56:66:b5:2a:d4:b0:c5:fa:7d:a2:
            (... ...)
            54:f1
        Exponent: 65537 (0x10001)
```

Ahí está el módulo de 2048 bit expresado en formato hexadecimal (empieza por `00:84:...` y acaba en `54:f1`). Todos los módulos empiezan siempre por `00` para evitar interpretarlo como un número negativo por error.

No tengo sus parámetros privados. No conozco sus **factores primos**. Ese módulo no me sirve para nada y por eso lo quiero cambiar.

Ahora vienen algunos parámetros más y se cierra con el bloque de firma.

```
    X509v3 extensions:
        X509v3 Authority Key Identifier: 
            keyid:08:5E:14:5B:38:DD:D8:12
        X509v3 Basic Constraints: critical
            CA:TRUE, pathlen:2147483647
        X509v3 Subject Key Identifier: 
            08:5E:14:5B:38:DD:D8:12

Signature Algorithm: sha1WithRSAEncryption
     82:53:c4:a0:52:53:01:4b:b5:26:57:fe:a4:c6:37:9e:a6:2c:
     (... ...)
     9e:af:58:ec
```

La extensión **Basic Constraints** es propia de las CA. Indica si se permite usar este certificado (su correspondiente clave privada) para firmar otros con él. 

Los *Key Identifier* sirven para identificar la clave, pero no de forma unívoca sino sólo entre otras con el mismo nombre. Por ejemplo si tuvieras dos entidades llamadas *Trial CA*. Es nuevo de la versión 3, en la v1 directamente no se permitía y punto.

El parámetro `sha1WithRSAEncryption` nos indica que la firma consiste en un hash tipo **sha1** cifrado con RSA. Como la clave de cifrado es de 2048 bit, el texto cifrado será otro bloque de igual longitud: 256 caracteres. Empieza por `82:53` y acaba en `58:ec`.

Lo primero que haremos será aprender a validar la firma a mano.


## Validar la firma a mano

¿Qué es una firma electrónica? Una firma es un **hash, cifrado** con una clave privada. Sólo eso. Claro que el hash no va desnudo sino dentro de una estructura ASN.1 indicando de qué tipo es. Y la estructura tampoco se cifra sola sino acompañada de un padding. Ahora lo veremos.

Convertimos el certificado de Base64 (PEM) a binario (DER) para trabajar más fácilmente.

```console
$ openssl x509 -in TrialCA.cer -inform pem -out TrialCA.bin -outform der
```

Los últimos 256 caracteres del fichero son el bloque de firma. Míralo en el apartado anterior. Empezaba por `82:53` y acaba en `58:ec`.

```console
$ tail -c256 TrialCA.bin | hd
00000000  82 53 c4 a0 52 53 01 4b  b5 26 57 fe a4 c6 37 9e  |.S..RS.K.&W...7.|
00000010  a6 2c 47 10 ca 04 4f 33  7a d8 d6 f2 60 ee e2 36  |.,G...O3z...`..6|
...
000000e0  1c 59 43 af 02 52 b4 f3  3e f3 1b a6 ea 1d 61 ad  |.YC..R..>.....a.|
000000f0  6b 59 35 25 98 a5 7b 84  60 7f 15 f1 9e af 58 ec  |kY5%..{.`.....X.|
```

Tanto la clave privada como la pública permiten cifrar y descifrar. La única condición es descifrar con una lo cifrado con la otra.

Un mensaje secreto lo **cifraremos con la clave pública** del destinatario y así solo él -con su privada- podrá descifrarlo. Openssl llama a estas operaciones **encrypt** y **decrypt**.

Las firmas, en cambio, se **cifran con la clave privada** del firmante. Y todo el mundo -con la clave pública- puede descifrarla. Openssl llama a estas operaciones **sign** y **verify**.

Descifraremos el bloque usando la clave pública contenida en el propio certificado. Para lo cual primero la extraemos a un fichero aparte:

```console
openssl x509 -in TrialCA.cer -pubkey -noout -out TrialCA.pubkey
```

Y ahora desciframos:

```console
$ tail -c256 TrialCA.bin \
  | openssl rsautl -verify -pubin -inkey TrialCA.pubkey \
  | hd
00000000  30 21 30 09 06 05 2b 0e  03 02 1a 05 00 04 14 44  |0!0...+........D|
00000010  0e 01 d3 2a 84 bd e0 77  2b 4e 77 f7 69 d8 4d d2  |...*...w+Nw.i.M.|
00000020  bf 07 da                                          |...|
00000023
```

No, no. Todo. El padding también. Con `-raw`:

```console
$ tail -c256 TrialCA.bin \
  | openssl rsautl -verify -pubin -inkey TrialCA.pubkey -raw \
  | hd
00000000  00 01 ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
000000d0  ff ff ff ff ff ff ff ff  ff ff ff ff 00 30 21 30  |.............0!0|
000000e0  09 06 05 2b 0e 03 02 1a  05 00 04 14 44 0e 01 d3  |...+........D...|
000000f0  2a 84 bd e0 77 2b 4e 77  f7 69 d8 4d d2 bf 07 da  |*...w+Nw.i.M....|
00000100
```

Eso es. El primer byte es `00`, por razones prácticas. El siguiente `01` indica **padding con caracteres `FF`**. Si fuera `02` sería *padding con caracteres aleatorios no nulos*. El texto cifrado real comienza después del primer carácter `00`. Este tipo de padding se llama *PKCS#1 v1.5*.

El padding tipo **01** es determinista y se usa en la **firma**. Donde no supone un problema saber que dos firmas son iguales antes de descifrarlas. El tipo **02** -aleatorio- en el **cifrado**. Como cada vez da un resultado distinto, es imposible saber a priori si dos criptogramas provienen del mismo texto en claro.

Se cifra una estructura ASN.1 que se interpreta así:

```
30 21 30 09 06 05 2b 0e 03 02 1a 05 00 04 14 44 0e 01 d3 2a 84 bd e0 77 2b 4e 77 f7 69 d8 4d d2 bf 07 da 

30 21     <- secuencia con logitud 0x21 bytes
  30 09   <- primer campo: secuencia de 9 bytes
    06 05 <- primer campo: identificador OID, 5 bytes
      2b 0e 03 02 1a  <- OID de SHA1
    05 00 <- segundo campo: null de tamaño 0
  04 14   <- segundo campo: cadena de octetos, 20 bytes
      44 0e 01 d3 2a 84 bd e0 77 2b 4e 77 f7 69 d8 4d d2 bf 07 da  <- los 20 bytes del hash
```

Todo eso viene a decir *"Es un hash SHA1 cuyo valor es `440e01d32a84bde0772b4e77f769d84dd2bf07da`"*. Quédate con este resultado para luego.

¿Pero eso es el hash **de qué** exactamente?

Un certificado x509 consiste en una estructura que engloba tres elementos:

- una estructura *SEQUENCE* con los datos del certificado (Issuer, Fechas, Subject, número de serie, propósito y -por supuesto- clave pública).
- una estructura *SEQUENCE* con los datos relativos a cómo está calculada su firma.
- una cadena de bits *BIT STRING* con dicha firma.

*SEQUENCE* en ASN.1 viene a significar un *array*.

```console
$ openssl asn1parse -i -inform pem -in TrialCA.cer 
    0:d=0  hl=4 l= 779 cons: SEQUENCE    <- Estructura global
    4:d=1  hl=4 l= 499 cons:  SEQUENCE   <- Estructura con los datos del certificado (el hash se calcula de esto)
  507:d=1  hl=2 l=  13 cons:  SEQUENCE   <- Estructura con los datos de la firma       
  522:d=1  hl=4 l= 257 prim:  BIT STRING <- Firma (hash cifrado)
```

Nota: La primera columna (0, 4, 507...) es el offset, la posición donde empieza el campo. **d** es *depth* o sea el nivel anidamiento. **hl** es *header lenght*, tamaño de la cabecera. El mínimo es 2 bytes (tipo de dato y longitud) pero si el dato es largo (mayor de 127) se necesitarán más. Y **l** es la longitud del campo.

La secuencia que nos interesa es la primera dentro de la global. Empieza en el **offset 4** y tiene una longitud de **499 bytes**.

La extraemos y calculamos su SHA1:

```console
$ cat TrialCA.bin \
  | tail -c+5 \
  | head -c+503 \
  | sha1sum 
440e01d32a84bde0772b4e77f769d84dd2bf07da  -
```

Aquí lo tienes, el mismo que habíamos obtenido antes descifrando la firma.


## Sustituir el módulo

Como ya vimos, a efectos prácticos cambiar una clave por otra se reduce a sustituir el módulo por otro.

Lo primero que necesito es un módulo del que conozca la parte privada. Así pues, creo en el momento una clave del mismo tamaño:

```console
$ openssl genrsa -out rsa_2048.pem 2048
Generating RSA private key, 2048 bit long modulus (2 primes)
...........................................................+++++
.........+++++
e is 65537 (0x010001)
```

La clave privada tiene todos los parámetros de RSA y algunos otros

```console
$ openssl rsa -text -in rsa_2048.pem
RSA Private-Key: (2048 bit, 2 primes)
modulus:
    00:b7:d1:d8:df:03:b3:1f:9d:6e:bf:58:77:b0:ae:
    (...)
    1d:14:42:79:6e:ee:28:aa:52:38:7f:7b:3f:98:98:
    de:7b
publicExponent: 65537 (0x10001)
privateExponent: ...
prime1: ...
prime2: ...
exponent1: ...
exponent2: ...
coefficient: ...
```

Por si te lo estás preguntando, la equivalencia con lo que hayas podido estudiar de RSA es esta:

```
prime1:          p
prime2:          q
modulus:         N = p * q
publicExponent:  e
privateExponent: d
exponent1:       d_p  = p mod (p-1)
exponent2:       d_q  = q mod (q-1)
coefficient:     qInv = q^-1
```

En teoría sólo necesitas *N* y *d*. En la práctica te viene bien guardar todo, algunos [por rendimiento](https://en.wikipedia.org/wiki/RSA_(cryptosystem)#Using_the_Chinese_remainder_algorithm).

Dejemos la parte privada y centrémonos en el módulo.

```console
$ openssl rsa -modulus -noout -in rsa_2048.pem 
Modulus=B7D1D8DF03B31F9D6EBF5877B0AE9...6EEE28AA52387F7B3F9898DE7B
```

Para sustituir el módulo en el certificado, podría usar un editor ASN.1. Es casi igual de sencillo hacerlo sin él. Pasaré a **hexadecimal** el certificado original -que ya teníamos en formato binario DER- al fichero `TrialCA.hex`.

```console
$ xxd -p -c 9999 TrialCA.bin > TrialCA.hex
```

El módulo queda tal cual en hexadecimal, así que bastará con **buscar y reemplazar**.

```bash
modulo_viejo=$(openssl x509 -modulus -in TrialCA.bin -inform der -noout | cut -d= -f2)
modulo_nuevo=$(openssl rsa -modulus -noout -in rsa_2048.pem | cut -d= -f2)
sed -i "s/$modulo_viejo/$modulo_nuevo/i" TrialCA.hex
```

Ya está cambiado.

Tal como estarás pensando, el hash de la firma ya no vale. Debemos recalcularlo.


## Recalcular el hash

Este apartado resulta un poco críptico. Básicamente es sustituir un hash por el otro con el mismo procedimiento que antes, usando `sed`. No pongo los resultados intermedios por no extenderme.

Para calcular el hash usamos el mismo comando que antes. Tendremos dos *hashes*. El **viejo**, calculado con el fichero *.bin* en el apartado anterior. Y el **nuevo**, calculado a partir del fichero *.hex* sobre el que habíamos hecho el cambio del módulo.

```bash
hash_viejo=$(cat TrialCA.bin \
  | tail -c+5 \
  | head -c+503 \
  | sha1sum \
  | cut -d' ' -f1)
  
hash_nuevo=$(cat TrialCA.hex \
  | xxd -r -p \
  | tail -c+5 \
  | head -c+503 \
  | sha1sum \
  | cut -d' ' -f1)
```

El hash va dentro del bloque de firma. Con él usaremos el mismo método de reemplazar una cadena hexadecimal por la otra.

Primero vuelco el bloque descifrado en un fichero en hexadecimal (*signblock.hex*):

```bash
tail -c256 TrialCA.bin \
  | openssl rsautl -verify -pubin -inkey TrialCA.pubkey -raw \
  | xxd -p -c 9999 \
  > signblock.hex
```

A continuación sustituimos el hash viejo por el nuevo:

```bash
sed -i "s/$hash_viejo/$hash_nuevo/i" signblock.hex
```

**Nota:** Tanto este apartado como el siguiente pueden hacerse en un sólo paso. La **operación dgst** de `openssl` sirve para calcular un hash de la entrada, componer la estructura ASN.1 correspondiente y hasta cifrarlo con la clave privada que le indiques:

```console
$ cat TrialCA.hex \
  | xxd -r -p \
  | tail -c+5 \
  | head -c+503 \
  | openssl dgst -sha1 -sign rsa_2048.pem \
  | hd
00000000  b6 1c 50 5c 9c 02 ee 32  a2 87 c7 ca 08 f6 f0 d4  |..P\...2........|
...
000000f0  13 7b 96 b2 52 15 c3 bd  d6 d4 31 2a f0 f7 be 1a  |.{..R.....1*....|
```

Verás cómo el resultado de abajo es el mismo.

## Regenerar la firma

Debemos cifrar el nuevo hash con una clave privada para convertirlo así en una firma.

Si lo ciframos con la clave privada correspondiente al módulo que acabamos de colocar, diremos que está **autofirmado**. En cambio, si lo cifráramos usando otra clave privada diferente, hablaríamos de **cadena de confianza**.

Como es un certificado raíz, debe estar **autofirmado**. Procedemos a cifrar el bloque conservando el padding que tuviera en un prinicpio:

```console
$ cat signblock.hex \
   | xxd -r -p \
   | openssl rsautl -sign -inkey rsa_2048.pem -raw \
   | hd
00000000  b6 1c 50 5c 9c 02 ee 32  a2 87 c7 ca 08 f6 f0 d4  |..P\...2........|
...
000000f0  13 7b 96 b2 52 15 c3 bd  d6 d4 31 2a f0 f7 be 1a  |.{..R.....1*....|
```

Ahora sustituimos los últimos 256 bytes (512 caracteres hexadecimales) de `TrialCA` por el nuevo bloque cifrado.

```bash
firma_vieja=$(cat TrialCA.hex | tail -c 512)

firma_nueva=$(cat signblock.hex \
   | xxd -r -p \
   | openssl rsautl -sign -inkey rsa_2048.pem -raw \
   | xxd -p -c 9999)

sed -i "s/$firma_vieja/$firma_nueva/i" TrialCA.hex
```

Tras re-firmar el certificado lo volvemos a pasar de hexadecimal a PEM para guardarlo en *TrialCA_nueva.cer*.

```bash
cat TrialCA.hex \
  | xxd -r -p \
  | openssl x509 -inform DER -outform PEM -out TrialCA_nueva.cer
```

## Comprobación

Lo que más nos importaba era el **tamaño**, que no podía variar. El original tenía 1115 bytes y el nuevo... también.

```
1115 TrialCA.cer       <- fichero origen: certificado original en formato PEM (base64)
 783 TrialCA.bin       <- certificado original en formado DER (binario)
1566 TrialCA.hex       <- el mismo certificado pero en formato hexadecimal
 451 TrialCA.pubkey    <- clave pública original
1675 rsa_2048.pem      <- nueva clave rsa creada al efecto
1115 TrialCA_nueva.cer <- fichero final: certificado con la nueva clave RSA
```

Ahora verificamos el módulo. Si todo ha salido bien debe empezar por `00:b7:d1:d8` (como el de la clave que habíamos guardado en `rsa_2048.pem`).

```
$ openssl x509 -inform pem -in TrialCA_nueva.cer  -text
...
Public Key Algorithm: rsaEncryption
    RSA Public-Key: (2048 bit)
    Modulus:
        00:b7:d1:d8:df:03:b3:1f:9d:6e:bf:58:77:b0:ae:
        ...
        de:7b
    Exponent: 65537 (0x10001)
```

Por último, validamos la *autofirma*. Esta tiene truco porque `openssl`, por defecto **no comprueba** la firma de los certificados autofirmados. Hay que pedírselo explícitamente con el parámetro `-check_ss_sig`.

```
$ openssl verify \
>  -check_ss_sig \
>  -CAfile TrialCA_nueva.cer \
>  TrialCA_nueva.cer
TrialCA_nueva.cer: OK
```

Ya sólo queda reemplazar la CA original por la nuestra en el sistema destino y este tomará por auténtico cualquier certificado firmado por nosotros.

## Nuestro propio *trial_cert*

Para terminar, construiremos un *trial_cert* similar al que nos dio el fabricante, pero con una **fecha** de expiración mayor.

Estos son los datos del original:

```
Version: 1 (0x0)
Serial Number: 0 (0x0)
Signature Algorithm: sha256WithRSAEncryption
Issuer: O = NA, CN = Trial CA
Validity
    Not Before: Jun  6 08:23:35 2021 GMT
    Not After : Sep  5 08:23:35 2021 GMT
Subject: O = NA, CN = 550001GJ7J
Subject Public Key Info:
    Public Key Algorithm: rsaEncryption
        RSA Public-Key: (2048 bit)
        Modulus:
            00:b1:de:af:7e:3b:f3:dc:c9:a6:dc:d0:eb:2f:a2:
            ...
```

Hay dos maneras de conseguir nuestro certificado-licencia. Está el camino **artesanal**, o sea, como antes:

1. Salvarlo como hexadecimal.
1. En la estructura principal cambiar la fecha de caducidad.
1. Generar una firma nueva con la privada de *nuestra Trial CA*.
1. Cambiar la firma original por la nuestra y guardarlo en formato PEM.

Y luego está el **profesional**, es decir, aprovechando las herramientas hasta donde se pueda. 

Con el primer método aprendes criptografía; con el segundo, a usar openssl. Yo -por no repetirme- tomaré este último.

Para conseguir un certificado firmado por una CA siempre partimos de un **CSR** (Certificate Signing Request). Un CSR es como un certificado normal autofirmado pero con ciertos **datos ausentes**. En particular el número de serie, issuer o fechas.

Openssl tiene una opción que genera un CSR copiando los datos de un certificado previo: `-x509toreq`.

```console
$ openssl x509 \
>  -x509toreq \
>  -in trial_cert.cer \
>  -out trial_cert_nuevo.csr
Getting request Private Key
no request key file specified
```

**Problema**: los CSR hay que firmarlos. Como no tengo la clave privada de *trial_cert* me generaré otra clave RSA distinta.

```
openssl genrsa -out rsa_2048.pem 2048
```

Volvemos a intentarlo con la clave recién generada. Esta vez sí funciona:

```console
$ openssl x509 \
>   -x509toreq \
>   -in trial_cert.cer \
>   -out trial_cert_nuevo.csr \
>   -signkey rsa_2048.pem
Getting request Private Key
Generating certificate request
```

Ha copiado casi todos los datos salvo el Issuer, la fecha y el número de serie como habíamos previsto.

```
Version: 1 (0x0)
Subject: O = NA, CN = 550001GJ7J
Subject Public Key Info:
  Public Key Algorithm: rsaEncryption
      RSA Public-Key: (2048 bit)
      Modulus:
        00:b1:de:af:7e:3b:f3:dc:c9:a6:dc:d0:eb:2f:a2:
        ...
```

Pero sigue existiendo un problema. El **módulo** empieza por `00:b1:de` como el del certificado original. Pero yo lo acabo de firmar con otra clave; una creada por mí ahora mismo.

¿Qué va a pasar? Pues que openssl **se va a estrellar** cuando quiera comprobar la firma e intente descifrarla con el módulo que consta en el CSR.

```console
$ openssl x509 \
>  -req \
>  -in trial_cert.csr \
>  -out trial_cert_nuevo.cer \
>  -CA ../ca/rsa_2048.pem 
Signature did not match the certificate request
```

Otra vez tendremos que ponernos artesanales. Pero sólo un poco.

El módulo de *trial_cert* es

```console
$ openssl x509 -modulus -in trial_cert.cer 
Modulus=B1DEAF7E3BF3D...5336BF5E3
```

Mientras que el módulo de mi nueva clave RSA es:

```console
$ openssl rsa -modulus -in rsa_2048.pem 
Modulus=F0C339ED18EE0...2166213A3
```

Puedes usar un editor ASN1, un editor binario o pasarlo a hexadecimal y hacerlo con un editor de texto. Lo que quieras. Pero **busca** el módulo que empieza por `B1DE` y termina por `F5E3` y **reemplázalo** por el otro.

Ahora tenemos un nuevo *trial_cert* con otro módulo. Su firma no es válida ¿y qué? Sólo lo queremos para el CSR.

Hacemos el CSR con el certificado del módulo manipulado y le decimos a `openssl` que lo firme con nuestra CA. Indicando el valor deseado de los valores ausentes: 

- número de serie a 0, como en el original.
- fecha de inicio: actual
- días de validez: **999999**.

```console
$ openssl x509 \
  -req \
  -in trial_cert.csr \
  -CA ../ca/TrialCA_nueva.cer \
  -CAkey ../ca/rsa_2048.pem \
  -out trial_cert_nuevo.cer \
  -set_serial 0 \
  -days 999999
Signature ok
subject=O = NA, CN = 550001GJ7J
Getting CA Private Key
```

Espera... ¿días de validez 99999? Se supone que una CA no te deja firmar un certificado con fecha de expiración posterior a su certificado raíz. Esta caducaba en el 2037. No te va a funcionar...

{% include image.html file="trialdays.png" caption="Me quedan más de 30 días de prueba. EyC." %}


## Conclusión

¿No seguirás pensando que este artículo va sobre piratear software, verdad?

Cuando hablamos de **criptografía** nos vienen a la cabeza fórmulas, matemáticas discretas, álgebra... Pero esa es la criptografía *de libro*. En la práctica lo realmente importante es **su implementación**. Suele estar en unas librerías -OpenSSL, LibreSSL, boringssl, GSKit- que programan y mantienen grupos de trabajo. Los detalles los conocen cuatro frikis, varios investigadores y algunos becarios de doctorado.

Una CA no te deja firmar un certificado más allá de su fecha de validez sólo porque alguien se molestó en programar un *if* que lo comprueba. Al algoritmo que calcula el SHA256 le da exactamente igual cuándo caduque. Un navegador no te acepta un certificado manipulado porque, en alguna parte de una inescrutable librería, hay un *goto fail* tras la comparación.

OpenSSL es una herramienta muy versátil y compleja. Puedes pasar años usando algo, pero es **salirte del terreno marcado** lo que te lleva realmente a investigar y aprender cómo funciona por dentro.


## Enlaces

Algunos fallos de OpenSSL con repercusión masiva en su día:

- [Anatomy of a “goto fail” – Apple’s SSL bug explained, plus an unofficial patch for OS X! - sophos.com](https://nakedsecurity.sophos.com/2014/02/24/anatomy-of-a-goto-fail-apples-ssl-bug-explained-plus-an-unofficial-patch/)
- [Apple y "goto fail", un fallo de seguridad en SSL/TLS - genbeta.com](https://www.genbeta.com/seguridad/apple-y-goto-fail-un-fallo-de-seguridad-en-ssl-tls-y-su-posible-relacion-con-la-nsa)
- [The Heartbleed Bug - heartbleed.com](https://heartbleed.com/)
- [openssl predictable random number generator - Debian Security Advisory](https://www.debian.org/security/2008/dsa-1571)
- [Alternative chains certificate forgery (CVE-2015-1793) - OpenSSL Security Advisory (2015)](https://www.openssl.org/news/secadv/20150709.txt)

Para ampliar información:

- [Internet Privacy Enhanced Mail - Stephen T. Kent](https://web2.utc.edu/~djy471/CPSC4670/17-privacy-email.pdf)
- [Privacy-Enhanced Mail - Wikipedia](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail)
- [Teorema chino del resto - Wikipedia](https://es.wikipedia.org/wiki/Teorema_chino_del_resto)
- [PKCS #1: RSA Encryption Version 1.5 - IETF 1998](https://datatracker.ietf.org/doc/html/rfc2313)
- [ASN.1 JavaScript decoder](https://lapo.it/asn1js/)
- [X.509 - Wikipedia](https://es.wikipedia.org/wiki/X.509)

Otros artículos del blog relacionados:

- [Electrónica y Ciencia - Prácticas con TPM virtual]({{site.baseurl}}{% post_url 2020-09-02-practicas-tpm-virtual %})
- [Electrónica y Ciencia - Pirateando software Ninja]({{site.baseurl}}{% post_url 2021-05-25-pirateando-software-ninja %})


