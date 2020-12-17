---
assets: /assets/2020/09/practicas-tpm-virtual/
image: /assets/2020/09/practicas-tpm-virtual/img/sc3205-boli.jpg
description: Describimos la instalación en Linux de un TPM software conforme a la especificación TGC 1.2 (ya obsoleta) para practicar con él y hacer algunas pruebas. Exploramos con detalle las operaciones más habituales como listar PCRs, cifrar y descifrar secretos y atestación.
featured: false
layout: post
tags:
- Informática
title: Prácticas con TPM virtual
---

Un TPM es, básicamente, un **chip criptográfico** con ciertos registros y políticas ligadas a su estado interno. El arranque, la BIOS, o el Sistema Operativo modifican unos registros internos (PCR). Dichos registros se calculan usando un hash. Una vez guardado un valor, el siguiente se calcula encadenando el anterior y no se pueden reiniciar hasta el siguiente arranque.

{% include image.html  file="sc3205-boli.jpg" caption="Chip TPM modelo Atmel SC3205 junto a la punta de un bolígrafo. EyC." %}

Este manual describe la instalación en Linux de un TPM software conforme a la especificación TGC 1.2 (ya obsoleta). Así como el software para practicar con él y algunas pruebas. Exploramos con detalle las posibilidades más habituales como listar PCRs, cifrar y descifrar secretos y atestación.


## Instalación

### Software TPM 1.2 

Es un emulador para practicar. Es conforme a la especificación TPM 1.2, no 2.0. Aunque hay múltiples diferencias, el uso general es muy parecido.

https://sourceforge.net/projects/ibmswtpm/

Tiene tres directorios:

 - /libtpm      
 - /tpm         
 - /tpm_proxy   

El que nos interesa es `tpm`. Libtpm no he conseguido compilarlo con la librería OpenSSL 1.1. En el foro de soporte te dicen que uses trousers: 
[hilo en el foro de sourceforge](https://sourceforge.net/p/ibmswtpm/discussion/1137021/thread/9c05f6703c/?limit=250).

Leemos el README del directorio TPM para compilarlo.

Una vez levantado escucha en un puerto TCP.


### Api TSS

La capa de software se llama TrouSerS. Tiene un demonio tscd que escucha en el puerto 30003. Esta capa gestiona el uso del TPM por parte de las diferentes aplicaciones que pueden usarla desde el espacio de usuario. Se comunica con el TPM software. Puede hacerlo directamente abriendo el dispositivo de caracteres /dev/tmp o bien enviando los comandos a un puerto TCP.

Hay que bajar los paquetes trousers y tpm-tools. Están en la paquetería del sistema.

El flujo sería el siguiente:

    Aplicaciones -> API TSPI -> demonio TSCD (:30003) -> API TDDL -> (localhost:6543) -> TPM Software


## Primeros pasos

Se trata de arrancar los servicios y inicializar el chip. Normalmente el fabricante o el proveedor nos dará el TPM listo para usar o emplearemos comandos de la BIOS.

Pero aquí el TPM es software, ni el fabricante nos lo ha dado activado ni tampoco tenemos BIOS.

### Inicialización del TPM en el arranque

Ejecutar servidor de TPM virtual de IBM

    TPM_PATH=. TPM_PORT=6543 TPM_DEBUG=0 ./tpm_server

Ahora que ya tenemos TPM, aunque sea virtual, arrancaríamos el demonio TSCD que actúa como driver en espacio de usuario. Pero no va a funcionar:

    TCS GetCapability failed with result = 0x26

Hay que iniciar el TPM. Hasta entonces cualquier interacción devolverá el código 0x26 `TPM_INVALID_POSTINIT`.

Este paso lo haría la BIOS o UEFI antes de arrancar el sistema. La documentación de IBM dice de usar `tpmbios`. Pero no lo tengo, porque no he podido compilar las utilidades. Debo inicializarlo a mano escribiendo los comandos de inicialización directamente al "hardware". Por suerte son cortos:


Lanzar comando TPM_Init (97) directamente al hardware:

    tag:        00 C1         (TPM_TAG_RQU_COMMAND)
    paramSize:  00 00 00 0A
    ordinal:    00 00 00 97   (TPM_ORD_Init)


    echo -e '\x00\xC1\x00\x00\x00\x0A\x00\x00\x00\x97' | netcat localhost 6543

O también con

    echo -e '\x00\xC1\x00\x00\x00\x0A\x00\x00\x00\x97' > /dev/tcp/127.0.0.1/6543


Se supone que las tpm-tools tienen un comando *tpm_startup* para lo siguiente. Pero dicho comando espera encontrar el dispositivo en /dev/tpm0 y no en un puerto TCP. Aquí no funciona:

    $ ./tpm_startup
    Unable to open the device.


Lanzamos a mano el comando TPM_Startup (99), estado clear:

    tag:         00 C1         (TPM_TAG_RQU_COMMAND)
    paramSize:   00 00 00 0C
    ordinal:     00 00 00 99   (TPM_ORD_Startup)
    startupType: 00 01         (TPM_ST_CLEAR)


    echo -e '\x00\xC1\x00\x00\x00\x0C\x00\x00\x00\x99\x00\x01' | netcat localhost 6543


Ahora seguiría la carga del arranque y el Sistema Operativo. Lo cual incluye un driver para acceso al TPM llamado -en linux- TCSD (Trusted Core Services Daemon): 


### Inicialización del demonio TSCD

Ejecutar driver:

    export TCSD_USE_TCP_DEVICE=true
    export TCSD_TCP_DEVICE_PORT=6543
    export TCSD_TCP_DEVICE_HOSTNAME=127.0.0.1
    tcsd -e -f

El TPM está aún en modo **disabled**. Se pueden ejecutar todos los comandos que la especificación marca como *Avail Disabled*. Como por ejemplo GetVersion

Pedir la versión:

    $ export TSS_DEBUG_OFF=1 
    $ export TSS_TCSD_HOSTNAME=127.0.0.1
    $ export TSS_TCSD_PORT=30003

    $ tpm_version
    TPM 1.2 Version Info:
    Chip Version:        1.2.18.160
    Spec Level:          2
    Errata Revision:     3
    TPM Vendor ID:       IBM
    TPM Version:         01010000
    Manufacturer Info:   49424d00



### Habilitar TPM

Los siguientes pasos normalmente no tendremos que darlos, porque el fabricante ya nos proporcionará el TPM activo y con su clave EK pre-grabada, incluso con un certificado firmado en la nemoria no volátil. Listo para operar.

En nuestro caso, al hacer cualquier operación devuelve error **TPM_Disabled** (0x07). Debemos activarlo. Hay una opción en el arranque del emulador de IBM para dejarlo ya activado. Pero no la he usado para hacer este procedimiento a mano.

Algunos comandos no tienen autorización. No pueden: todavía no hemos generado ninguna clave ni puesto contraseña alguna, no hemos tomado posesión. En su lugar requieren que el operador esté presente. Se supone que son comandos que no los podría ejecutar un software. Por eso se llama **presencia física**.

Hay dos formas de asegurar la presencia física del operador:
 - Poniendo un nivel lógico en una patilla del chip al momento de requerir la autorización. Esto lo haría el procesador por ejemplo mientras nos muestra la pantalla de la BIOS UEFI con el menú correspondiente.
 - Mandando un comando, *presencia por software*. 

Espera. ¿No habíamos quedado en que no se podía por software? 

Y no se puede, de hecho primero hay que habilitar el comando:

    $ tpm_setpresence --enable-cmd
    Tspi_TPM_SetStatus failed: 0x00002006 - layer=tcs, code=0006 (6), Not implemented
    Change to Command Enable Failed

Pero el driver tscd lo **deniega** mientras el sistema esté arrancado:

    Physical Presence command denied: Must be in single user mode.

Como el TPM es virtual, no podemos asegurar presencia por hardware. Tampoco tengo ganas de irme a modo single-user. Hago bypass al driver TSCD y habilitamos el comando directamente mandándolo al TPM sin pasar por el TSC. Cosa que no podríamos hacer en un sistema real. Al menos no *normalmente*.

Envío el Comando 0x4000000A (TSC_ORD_PhysicalPresence). Con el parámetro a 0x0020h (TPM_PHYSICAL_PRESENCE_CMD_ENABLE).

    tag:               00 C1         (TPM_TAG_RQU_COMMAND)
    paramSize:         00 00 00 0C
    ordinal:           40 00 00 0A   (TSC_ORD_PhysicalPresence)
    physicalPresence:  00 20         (TPM_PHYSICAL_PRESENCE_CMD_ENABLE)


    echo -e '\x00\xC1\x00\x00\x00\x0C\x40\x00\x00\x0A\x00\x20' | netcat localhost 6543 | hd

Me devuelve 00, lo acepta. De nuevo mando el comando TSC_ORD_PhysicalPresence pero esta vez cambiando el parámetro a TPM_PHYSICAL_PRESENCE_PRESENT.

    tag:               00 C1         (TPM_TAG_RQU_COMMAND)
    paramSize:         00 00 00 0C
    ordinal:           40 00 00 0A   (TSC_ORD_PhysicalPresence)
    physicalPresence:  00 08         (TPM_PHYSICAL_PRESENCE_PRESENT)


    echo -e '\x00\xC1\x00\x00\x00\x0C\x40\x00\x00\x0A\x00\x08' | netcat localhost 6543 | hd


En el log, el TPM acepta la presencia física:

    TPM_Process_PhysicalPresence: Setting physicalPresence TRUE

Ahora podemos activarlo desde el TSC usando Presencia Física como autorización:

    $ tpm_setenable --force --enable --well-known

En los logs ya está habilitado, eso sí, aún desactivado:

    $ tpm_setenable --status --well-known
    Tspi_TPM_GetStatus failed: 0x00000006 - layer=tpm, code=0006 (6), TPM is deactivated

Ya tenemos a nuestra disposición los comandos marcados como *Avail Deactivated*.



### Activar el TPM

Activar el TPM (requiere también presencia física):

    $ tpm_setactive  --active

Se requiere reboot. Paramos `tpm_server` y `tcsd`. 

Volvemos a hacer la inicialización por *BIOS*. El log del TPM virtual debe indicar que no está disabled, pero tampoco está *owned*.

    TPM_State_Trace: disable 0 p_deactive 0 v_deactive 0 owned 0 state 2

Podríamos listar las PCRs con el comando `./list_pcrs` ([list_pcrs.c](pruebas/list_pcrs.c)):

    $ ./list_pcrs
    PCR List
    PCR00: 0000000000000000000000000000000000000000
    PCR01: 0000000000000000000000000000000000000000
    PCR02: 0000000000000000000000000000000000000000
    PCR03: 0000000000000000000000000000000000000000
    PCR04: 0000000000000000000000000000000000000000
    PCR05: 0000000000000000000000000000000000000000
    PCR06: 0000000000000000000000000000000000000000
    PCR07: 0000000000000000000000000000000000000000
    PCR08: 0000000000000000000000000000000000000000
    PCR09: 0000000000000000000000000000000000000000
    PCR10: 0000000000000000000000000000000000000000
    PCR11: 0000000000000000000000000000000000000000
    PCR12: 0000000000000000000000000000000000000000
    PCR13: 0000000000000000000000000000000000000000
    PCR14: 0000000000000000000000000000000000000000
    PCR15: 0000000000000000000000000000000000000000
    PCR16: 0000000000000000000000000000000000000000
    PCR17: ffffffffffffffffffffffffffffffffffffffff
    PCR18: ffffffffffffffffffffffffffffffffffffffff
    PCR19: ffffffffffffffffffffffffffffffffffffffff
    PCR20: ffffffffffffffffffffffffffffffffffffffff
    PCR21: ffffffffffffffffffffffffffffffffffffffff
    PCR22: ffffffffffffffffffffffffffffffffffffffff
    PCR23: 0000000000000000000000000000000000000000

Las PCRs tienen 20 bytes, la misma longitud que un SHA-1.


### Crear Endorsement Key

Normalmente esta clave viene creada ya de fábrica. Pero no es el caso aquí:

    $ tpm_getpubek 
    Tspi_TPM_GetPubEndorsementKey failed: 0x00000023 - layer=tpm, code=0023 (35), No EK

Ejecutamos el comando `tpm_createek` para crearla. El ya debería devolver datos.

    $ tpm_getpubek 
    Public Endorsement Key:
      Version:   01010000
      Usage:     0x0002 (Legacy)
      Flags:     0x00000000 (!VOLATILE, !MIGRATABLE, !REDIRECTION)
      AuthUsage: 0x00 (Never)
      Algorithm:         0x00000020 (RSA)
      Encryption Scheme: 0x00000012 (RSAESOAEP_SHA1_MGF1)
      Signature Scheme:  0x00000010 (None)
      Key Size:          2048 bits
      Public Key:
        b22a1f6e d79d4bf8 b65c647e 1a286911 32d9d3a1 c2225fc1 a0b500d9 c4783cb9
        [....]
        b5ca46d2 5237c286 b18f9e40 e746fefe 44c00b31 c23da490 36c07e53 7616ce77


Esta clave sólo la ve y la usa el propio TPM. Por lo que no lleva contraseña. La siguiente clave la Storage Root Key (SRK) es más práctica. Para crearla debemos crear una contraseña de acceso al TPM, este proceso se llama *tomar posesión*.


### Tomar posesión

Tomar posesión del TPM (take ownership) consiste en crear la clave SRK y protegerla con una contraseña (en nuestro caso, todo ceros).

    $ tpm_takeownership --owner-well-known --srk-well-known

En el log del TPM virtual se indica que ya tiene dueño:

    TPM_State_Trace: disable 0 p_deactive 0 v_deactive 0 owned 1 state 2

Ejecutando el comando `list_keys` se muestra la SRK, con UUID 1, cuyo padre es la EK, con UUID 0:

    $ ./list_keys 
    Registered key 0:
    Version: 1.1.0.0
    UUID: 00000000 0000 0000 00 00 000000000001
    parent UUID : 00000000 0000 0000 00 00 000000000000
    auth: YES
    vendor data: (0 bytes)

La clave SRK tampoco sale del dispositivo y para usarla es necesario haberse autenticado con la debida contraseña.


## Comandos simples

Una vez activado podemos ejecutar un par de comandos de prueba que funcionan si autenticación.

### Extender PCR

Las PCRs son registros del TPM que guardan hash SHA1. Al TPM le pasamos unos datos y un número de PCR. El calcula el SHA1 del valor anterior de la PCR y de los nuevos datos y lo guarda sobrescribiendo el anterior.

No le podemos decir que guarde un valor concreto. Ni que olvide el valor antiguo (salvo en un par de ellas). Por eso se habla de *extender* una PCR.

Este programa extiende la PCR con un digest de 20 bytes a cero y devuelve el nuevo valor. Es algo que haría el sistema durante el arranque, o el software.

Ejecutar el programa [extend_pcr](pruebas/extend_pcr.c) indicando el número de la PCR. 


    $ ./extend_pcr 0
    PCR00: b80de5d138758541c5f05265ad144ab9fa86d1db

El valor que toma *b80de5d138758541c5f05265ad144ab9fa86d1db* corresponde al SHA1 del digest anterior (veinte ceros) concatenado con el nuevo valor (otros veinte ceros). Lo cual es fácil de comprobar:

    $ perl -e 'print "\x00"x40' | sha1sum
    b80de5d138758541c5f05265ad144ab9fa86d1db  -

Como estamos operando con la *locality* 0, sólo podemos modificar las PCRs de la 0 a la 16 y la 23. Si intentams operar con otra no nos deja:

    $ ./extend_pcr 17
    Tspi_TPM_PcrExtend: Locality is incorrect for attempted operation



### Generar un número random

Este es un comando de bajo nivel que no hace uso de las APIs de TSS y puede servir para ver si nos responde. Con el comando 46 (TPM_ORD_GetRandom), le pediremos que nos devuelva varios bytes utilizando el generador aleatorio:

TPM_ORD_GetRandom 0x00000046

    tag:               00 C1         (TPM_TAG_RQU_COMMAND)
    paramSize:         00 00 00 0E
    ordinal:           00 00 00 46   (TPM_ORD_GetRandom)
    bytesRequested:    00 00 00 14   (20 bytes)


    $ echo -e '\x00\xC1\x00\x00\x00\x0E\x00\x00\x00\x46\x00\x00\x00\x14' | netcat localhost 6543 | hd
    00000000  00 c4 00 00 00 22 00 00  00 00 00 00 00 14 24 0d  |....."........$.|
    00000010  b7 56 3a 76 32 9e 3a 5a  96 f1 d0 38 1b 9f ff 69  |.V:v2.:Z...8...i|
    00000020  bc 08                                             |..|
    00000022

La respuesta decodificada es:

    00 c4          TPM_TAG_RSP_COMMAND  A response from a command with no authentication
    00 00 00 22    paramSize            Total number of output bytes including paramSize and ta
    00 00 00 00    returnCode           The return code of the operation. (0: ok)
    00 00 00 14    randomBytesSize      The number of bytes returned (20)
    24 0d b7 56 3a 76 32 9e 3a 5a 96 f1 d0 38 1b 9f ff 69 bc 08 <- random bytes                        


# Guardar secretos

La característica más distintiva de un TPM es poder guardar un secreto bajo una clave y ligarlo al estado actual del sistema.

Podría ser, por ejemplo, la clave privada de un acceso por SSH. O la clave de cifrado de una partición de disco o pendrive.

Al ligar estos secretos a un valor particular de las PCRs, en cuanto se modifique el software o los parámetros que reflejan tales PCRS no se podrá utilizar.

### Cifrar un secreto

Supongamos que este es nuestro texto claro:

    $ cat data/cleartext 
    Twas brillig, and the slithy toves
    Did gyre and gimble in the wabe;
    All mimsy were the borogoves,
    And the mome raths outgrabe.

Ahora extendemos la PCR 0 una vez y la PCR 1 dos veces. Simulando que el sistema está en un estado X desde el arranque.

    $ ./list_pcrs 
    
    PCR List
    PCR00: b80de5d138758541c5f05265ad144ab9fa86d1db
    PCR01: 850659b18eb6fb4ccdcb113ca4266eb945449466
    PCR02: 0000000000000000000000000000000000000000
    PCR03: 0000000000000000000000000000000000000000
    PCR04: 0000000000000000000000000000000000000000
    ...

Con el comando `tpm_sealdata` guardaremos la clave anterior condicionada a las PCRs 0, 1 y 2. 

    $ tpm_sealdata -i data/cleartext -o data/ciphertext.tss -p 0 -p 1 -p 2 -z

La z significa que la contraseña que hemos usado durante la *toma de posesión* ha sido todo ceros. En un sistema real tendríamos que proporcionar la contraseña de owner para desbloquear la SRK.

Este es el fichero con el secreto encriptado. Cifrado mediante AES-256 con una clave simétrica; y esta a su vez cifrada por la SRK vinculada a un hash concreto de unas PCRs concretas.

    $ cat data/ciphertext.tss 
    -----BEGIN TSS-----
    -----TSS KEY-----
    AQEAAAARAAAABAEAAAABAAMAAQAAAAwAAAgAAAAAAgAAAAAAAAAAAAABAJsAYu7R
    iva8VJQHy1jS7+NGFeYApb3jyuJ87xpAEK/8Z+PngxJMyDMdtgfMJTXhTnkof5n5
    6zCyO+zPjTclDUJFmhr62AmQDEymnSJ0TwROg7efEG+oqLJSvCE2rexuUDcffoRy
    sz79LW3AeLkLLCOzE2oQxzcdy37/O5rFnmzaG0kWkYiPQcKhz1gb9csJ1n9IdU8k
    f2Wl1erYZMAkUDuSqFVf1YaoUhWR6QvRkdklHU/yConLJ0ISkRy6Y62twmdhPZql
    f3wEDdTQa31cX0ooSSYJyb1ls0leRRDkQAW377usXQRZ2Qecvv5ACImSlAIvvunp
    9s1dMLDZ0QjKGysAAAEAoBy2ZKdHjuSPACcVaiMhwpMA1wIepo2s0KQMaHgxxaDk
    MVOGfJ55tGPXLsb0ysGIoK/V58a8gXNkW85zWTsUVdQ86YYrieuhkpIKisbzGPC0
    uC+nNyVLDszLlyndEB6EEmAdVXAJdzAJXsehy0qGT5gvhrdnh3SwUM7mxK3uff0+
    Ku3YIb0Calkt50TA5sfdJFcAlePmQbdNDzHjKHEqBaZV4eGnP5gttuDzTYNLDNRc
    I22bWXct/1LK+6Be3NjU8eey7A6KcLBHA9rg+Ah/jRHmlJdpNM2aZHPWHdfj3AIV
    KY4uHZo4jpt4lG/DRvIEPM3wANUZVhG5wEDlNe7TOQ==
    -----ENC KEY-----
    Symmetric Key: AES-256-CBC
    AQEAAAAAACwAAgcArgAOY/acjhh3BnJjsKcq6n5QtOuuAA5j9pyOGHcGcmOwpyrq
    flC06wAAAQBhCZW7rSZa+RJOP1iEPYoqryK3sV+juqdm2upM7r27Dd2FpqgokFcJ
    PYoy8gLpOrsoTsN4ds4wu9TD7WY1Feda09u330s6yfqrwpyCh1xbTw65ZfRKlMJh
    tNPbecczNHEz+K3qq23k5jz5+hLhukQEM70lvOMraXa9M/2WtApvWpOGVVlPoxbQ
    +nkfqvbaKOPTAPij7ITDwjPlRLmpZ1oOA0vUTz45KiCf226l7pw/9wa1XJBx7OqL
    HhSW72KVFkHHRa8s/NqSm22wK7IMp77zjaoAt6xBYqSxBPQYJG6HI3vfPobqFUfE
    ovlFCm7lgqpMQfqvWP2x8ycDE4WcyFC5
    -----ENC DAT-----
    sDY11ZeNAGf+4mXrVLplTpnjFrNjiqpFYdJ1H6PJSkEL2g4fJNGlQuzmQoNhkEdO
    OoGi4A5vtKglywI+I/AaV2ZCN5AAi4Nggtnqj6OyxwP9s6vWh556aK6N0tcuufan
    /qbDd+KIYyc++B12GUDdFfj4pKeDcmnMxOfZHY0MfTM=
    -----END TSS-----


### Descifrar el secreto


Para desencriptarlo usamos el comando `tpm_unsealdata`. Pero el desencriptado sólo funcionará si las PCRs 0, 1 y 2 tienen el mismo valor que cuando se cifró. 

De manera que si extendemos artificalmente por ejemplo la PCR 2:

    $ ./extend_pcr 2
    PCR02: b80de5d138758541c5f05265ad144ab9fa86d1db
    $ ./list_pcrs 
    
    PCR List
    PCR00: b80de5d138758541c5f05265ad144ab9fa86d1db
    PCR01: 850659b18eb6fb4ccdcb113ca4266eb945449466
    PCR02: b80de5d138758541c5f05265ad144ab9fa86d1db
    PCR03: 0000000000000000000000000000000000000000
    PCR04: 0000000000000000000000000000000000000000

No va a funcionar. Porque cuando lo ciframos esa PCRs era 0 y ahora no. No tendremos acceso a la partición cifrada o no podremos entrar a las máquinas por SSH.

    $ tpm_unsealdata -i data/ciphertext.tss -z
    $ 

Las PCRs (salvo la 16 y la 23) no se pueden reinciar a cero. Por tanto la única forma de que vuelvan a tener el mismo valor que cuando se cifró la clave es reiniciar el sistema (apagar la TPM) reproducir exactamente los mismos pasos. Para dar lugar al mismo hash SHA1.

Inicializar TPM (equivalente a reiniciar el sistema cortando la alimentación):

    $ echo -e '\x00\xC1\x00\x00\x00\x0A\x00\x00\x00\x97' > /dev/tcp/127.0.0.1/6543
    $ echo -e '\x00\xC1\x00\x00\x00\x0C\x00\x00\x00\x99\x00\x01' > /dev/tcp/127.0.0.1/6543

Extender con ceros 1 vez la PCR 0 y dos veces la PCR 1

    $ ./extend_pcr 0
    PCR00: b80de5d138758541c5f05265ad144ab9fa86d1db
    $ ./extend_pcr 1
    PCR01: b80de5d138758541c5f05265ad144ab9fa86d1db
    $ ./extend_pcr 1
    PCR01: 850659b18eb6fb4ccdcb113ca4266eb945449466

Y ahora sí podemos acceder a la clave:

    $ tpm_unsealdata -i data/ciphertext.tss -z
    Twas brillig, and the slithy toves
    Did gyre and gimble in the wabe;
    All mimsy were the borogoves,
    And the mome raths outgrabe.








## Atestación o certificación (attestation)

La atestación consiste en pedirle al TPM que nos firme el estado de una o varias PCRs en el momento actual. Es útil cuando queremos asegurarnos remotamente de que el equipo cumple especificaciones. 

Por ejemplo, podríamos solicitar un informe firmado de las PCRs que contienen
 - el hash de la configuración de la BIOS
 - el hash del sector de arranque del sistema.
 - el hash del nivel de parcheado del sistema

Se podría evaluar esta información a la hora de acceder por ejemplo a una VPN y denegar el acceso a la VPN si el valor de estas PCR no se corresponde con alguno de los esperados. El sistema ha sido modificado.


Se necesita el paquete `tpm-quote-tools`. Compilarlo o instalarlo de la paquetería del sistema.

Nunca se firma nada ni con la SRK ni mucho menos con la EK por motivos de privacidad, ya que esta clave identifica unívocamente el TPM y habitualmente no se puede borrar ni cambiar.

Por esta razón, antes de certificar nada con el TPM necesitamos crear una identidad (AIK).

El TPM tampoco dejará que firmemos cualquier cosa con una clave AIK, sólo cosas generadas por él mismo. Por ejemplo otras claves o un informe de PCRs.


### Crear identidad

El comando `tpm_mkaik` creará una nueva clave RSA. Se necesita autorización porque el TPM va a emplear la SRK para cifrar la parte privada.

    $ tpm_mkaik -z blob pubkey

Tras unos comandos al TPM, nos da una respuesta como esta:


    TPM_IO_Write: length 911
    00 C6 00 00 03 8F 00 00 00 00 01 01 00 00 00 12 
    00 00 00 00 00 00 00 00 01 00 01 00 02 00 00 00 
    0C 00 00 08 00 00 00 00 02 00 00 00 00 00 00 00 
    00 00 00 01 00 CD E2 9A 1D 2B DA A3 6D 2F 35 34 
    72 38 20 8C 3F C0 08 85 0F 0C 18 BD 48 86 62 5D 
    [...]
    EA 6A 12 37 1F BD 52 3E CA FE 00 38 75 A6 12 9C 
    75 B9 08 63 6B 15 7E 5F DE CB 03 73 9D 26 69 


La información que contiene el binario sigue la especificación de TGC, es la siguiente:


    TPM's TPM_MakeIdentity response: 

    00 C6        tag
    00 00 03 8F  len
    00 00 00 00  result: ok
    
    TPM_KEY
      01 01 00 00      TPM_STRUCT_VER
      00 12            TPM_KEY_USAGE: TPM_KEY_IDENTITY 
      00 00 00 00      TPM_KEY_FLAGS
      00               TPM_AUTH_DATA_USAGE: TPM_AUTH_NEVER
      TPM_KEY_PARMS  
        00 00 00 01    TPM_ALGORITHM_ID: TPM_ALG_RSA
        00 01          TPM_ENC_SCHEME: TPM_ES_NONE 
        00 02          TPM_SIG_SCHEME: TPM_SS_RSASSAPKCS1v15_SHA1
        00 00 00 0C    parmSize: 12
        TPM_RSA_KEY_PARMS
          00 00 08 00  keyLength: 2048
          00 00 00 02  numPrimes: 2
          00 00 00 00  exponentSize: 0
      00 00 00 00      PCRInfoSize 
      TPM_STORE_PUBKEY
        00 00 01 00    keyLength: 256 
        CD E2 ... 1D 57 RSA modulus
      00 00 01 00      encDataSize: 256
      A2 74 ... 91 5B  encrypted TPM_STORE_ASYMKEY
    
    00 00 01 00        identityBindingSize: 256 
    49 0A ... 6A DA    identityBinding
    57EA3CEB2CAD34CF35072644D9919FE941462A10   nonce
    00                 continueSrkSession: false
    035A7DF647F5C9556718154E32EC6B2EF358AA90   srkAuth
    3140EB8151FEA2577E7FEA6A12371FBD523ECAFE   nonceEven
    00                 continueAuthSession: false
    3875A6129C75B908636B157E5FDECB03739D2669   resAuth


La información se guarda en dos ficheros: `pubkey` y `blob`.

Blob contiene tanto la parte pública (módulo y exponente) como la parte privada cifrada (llamada *encrypted Data* en la estructura anterior). 

En la parte privada sólo está uno de los dos factores. El otro se obtiene dividiendo el módulo.

Pubkey contiene las estructuras TPM_KEY_PARMS y TPM_STORE_PUBKEY. Módulo y exponente de la clave RSA. 

Se supone que `pubkey` usa el formato BER. Sin embargo la especificación TSS define una estructura que no es del todo compatible con ASN.1.

    $ openssl asn1parse -in pubkey -inform der
          0:d=0  hl=4 l= 300 cons: SEQUENCE          
          4:d=1  hl=2 l=   1 prim: INTEGER           :01
          7:d=1  hl=2 l=   1 prim: INTEGER           :02
         10:d=1  hl=2 l=   4 prim: INTEGER           :BAD INTEGER:[0000011C]
         16:d=1  hl=4 l= 284 prim: OCTET STRING      [HEX DUMP]:00000001000100020000000C0000...

Ese *BAD INTEGER* va a causar problemas. Según TSS ese campo tiene una longitud fija de 4 bytes (*3.23 Portable Data* de la especificación TSS 1.2), mientras que ASN.1 dice que los enteros deben guardarse usando el mínimo número de bytes necesarios. En este caso 2 bytes son suficientes para guardar el valor `01 1C`, no cuatro. Tal vez versiones anteriores fueran más tolerantes, pero la librería OpenSSL 1.1.1 no se lo traga. 

De hecho, cuando lo vayamos a usar luego con `tpm_verifyquote` nos dará un error interno. Lo arreglaremos más adelante.


### Crear un UUID

Cada clave tiene asociado un identificador único, UUID. Son 16 bytes casi todos aleatorios. Lo podríamos crear a mano pero hay una utilidad para ello:

    $ tpm_mkuuid uuid

Nos deja el fichero uuid con este contenido:

    $ hd uuid
    00000000  36 4e 3e 18 d8 97 42 4f  84 0d 84 be cb 57 a4 f9  |6N>...BO.....W..|
    00000010

Lo cual corresponde al UUID *183e4e36-97d8-4f42-840d-84becb57a4f9*. La ordenación de los UUIDs es un poco peculiar porque mezcla *big* y *little endian*. Versión 4, o sea, generado aleatoriamente.


### Cargar la clave AIK

Las claves no se guardan en el TPM, salvo SRK y EK sino que se exportan -cifradas- y las guarda el Sistema Operativo.

Cuando hace falta usar alguna, se cargan temporalmente en el TPM la clave necesaria así como sus ancestros hasta completar la cadena de confianza. Al cargar cada clave le asignamos un UUID para poder referirnos a ella.

En TPM v1.2, los identificadores no van ligados a la clave hasta el momento de la carga.

Cargamos en el TPM la clave privada guardada en `blob` asignándole el identificador en `uuid`.

    $ tpm_loadkey blob uuid

Si listamos las claves, ahora aparece la SRK y otra más:

    $ ../pruebas/list_keys
    Registered key 0:
    Version: 1.1.0.0
    UUID: 183e4e36 97d8 4f42 84 0d 84becb57a4f9
    parent UUID : 00000000 0000 0000 00 00 000000000001
    auth: NO
    vendor data : "trousers 0.3.14" (16 bytes)
    
    Registered key 1:
    Version: 1.1.0.0
    UUID: 00000000 0000 0000 00 00 000000000001
    parent UUID : 00000000 0000 0000 00 00 000000000000
    auth: YES
    vendor data: (0 bytes)

La AIK con identificador `183e4e36 97d8 4f42 84 0d 84becb57a4f9` desciende de `00000000 0000 0000 00 00 000000000001` (TSS_UUID_SRK). Y esta a su vez de la EK con ID cero.


### Firmar PCRs


Solicitaremos un informe firmado de las PCRs 0 y 7, cuyo contenido es el siguiente:

    $ pruebas/list_pcrs 
    
    PCR List
    PCR00: 850659b18eb6fb4ccdcb113ca4266eb945449466
    ...
    PCR07: ad919ad2b122e5741612e16329aa7626b63ada73
    ...


Antes de comenzar guardaremos un identificador random de 20 bytes, podría ser el sha1 de algo o simplemente aleatorio. Lo llamaremos `nonce`.

    $ openssl rand 20 > nonce

    $ hd nonce 
    00000000  5b eb ba af 36 43 bb 9b  c5 f3 ed b6 fc 7a 40 75  |[...6C.......z@u|
    00000010  7b 2f 5d e0                                       |{/].|
    00000014

Ahora pedimos que se nos firme usando la clave `uuid` ya cargada, un informe con el identificador aleatorio y el valor de las PCRs 0 y 7.

    $ tpm_getquote uuid nonce quote 0 7

El TPM va a crear un hash SHA1 con las PCR seleccionadas. Después compondrá internamente una estructura especial llamada TPM_QUOTE_INFO con este hash, nuestro **nonce** y algunos datos estáticos. Calculará el SHA1 de dicha estructura y firmará este último con la clave **uuid**. El resultado nos lo devolverá y este comando lo deja en el archivo `quote`:


    $ hd quote 
    00000000  34 b2 ab a7 29 11 12 3e  ca 0c f8 b4 a8 65 a5 a2  |4...)..>.....e..|
    00000010  7a 4d 48 bf e2 ae 1f bc  d6 11 a8 c6 97 8c eb 94  |zMH.............|
    00000020  d9 e6 43 4f 7f 3d 2e 66  90 0f ff 45 92 4b 75 5a  |..CO.=.f...E.KuZ|
    00000030  94 cb 20 83 b8 71 15 39  59 28 b5 69 76 23 58 c9  |.. ..q.9Y(.iv#X.|
    00000040  16 c0 8c 16 55 2e 14 e3  7a b1 04 ae b5 a1 c1 d7  |....U...z.......|
    00000050  b4 8f 14 77 4c ba b8 87  80 13 95 14 29 bc 2e 06  |...wL.......)...|
    00000060  b7 f8 50 ef 19 b5 ce c0  77 34 ad 22 50 ea 82 ff  |..P.....w4."P...|
    00000070  bd 96 6e ba 3b e2 fd 71  55 7d e4 39 c6 b7 18 a1  |..n.;..qU}.9....|
    00000080  85 5e 47 2b 09 6c 60 df  50 7b 01 70 2a 1f 4d 84  |.^G+.l`.P{.p*.M.|
    00000090  a1 88 00 5d ae 3c 13 00  90 34 1f 52 12 1d fc 6c  |...].<...4.R...l|
    000000a0  50 fa b1 3c f5 d2 53 54  04 07 25 dd 42 16 f3 9a  |P..<..ST..%.B...|
    000000b0  68 12 37 7b b4 b9 90 3e  94 dc 5a 0d ce 3f ed 94  |h.7{...>..Z..?..|
    000000c0  2b 3c 1e 05 8e 78 17 25  3e 4f 46 a8 e6 36 db a7  |+<...x.%>OF..6..|
    000000d0  30 da 80 48 df fd 2d 6e  c9 ac 3f f1 4c e1 4b 52  |0..H..-n..?.L.KR|
    000000e0  4d ef be cc 6f d2 08 bb  0d bd 8d 39 df f2 80 4b  |M...o......9...K|
    000000f0  71 88 51 bc 75 1a 9e 9e  e8 55 a3 db ca 9c 1b ee  |q.Q.u....U......|



Pero ¿qué contiene realmente `quote`?

Se supone que es una firma, así que vamos a desencriptarlo con la clave pública AIK que teníamos en `pubkey`.

Para que openssl pueda utilizarla debemos tener la clave en formato DER X.509. 

Una forma de hacerlo es generar un par RSA con OpenSSL y luego sustituir en la clave pública el módulo generado por el que tenemos en `pubkey`. Supongo que habrá utilidades para hacerlo, pero cambiarlo en binario es lo que tengo más a mano.

Creamos clave privada de 2048, exponente F4 (0x10001) por defecto.

    $ openssl genrsa -F4 -out private.pem 2048

Escribimos la pública. Nos interesa el formato DER para sustituir luego este módulo:

    $ openssl rsa -in private.pem -outform DER -pubout -out public.der

Vemos el módulo y el exponente:

    $ openssl rsa -pubin -inform der -in public.der -text
    RSA Public-Key: (2048 bit)
    Modulus:
        00:98:c6:c0:b5:11:5f:45:c0:3c:10:24:c7:5e:dd:
        ...
        a9:15:90:98:b0:56:5d:32:a2:ff:71:bb:68:f6:4d:
        48:09
    Exponent: 65537 (0x10001)

Editando el fichero lo sustituimos por el módulo del TPM. Importante, los módulos en openssl empiezan por 00.

    $ openssl rsa -pubin -inform der -in public_openssl.der -text
    RSA Public-Key: (2048 bit)
    Modulus:
        00:cd:e2:9a:1d:2b:da:a3:6d:2f:35:34:72:38:20:
        ...
        30:24:a4:fe:fc:60:59:3a:d7:18:c9:63:37:3d:69:
        1d:57
    Exponent: 65537 (0x10001)

Desciframos con la clave pública:

    $ openssl rsautl \
      -verify \
      -in ./quote \
      -keyform DER \
      -pubin \
      -inkey public_openssl.der | hd
    00000000  30 21 30 09 06 05 2b 0e  03 02 1a 05 00 04 14 f0  |0!0...+.........|
    00000010  12 53 ff 49 7e ae 7f a1  55 5c 34 a8 22 c2 49 88  |.S.I~...U\4.".I.|
    00000020  35 c5 8b                                          |5..|
    00000023

No nos da error de invalid padding, eso es bueno. Significa que el descifrado ha ido bien. 

Porque si hubiéramos utilizado otro módulo RSA distinto para hacer el descifrado habría sucedido esto:

    $ openssl rsautl -verify -in ./quote -keyform DER -pubin -inkey another_public.der | hd
    RSA operation error
    140673277608384:error:0407008A:rsa routines:RSA_padding_check_PKCS1_type_1:invalid padding:../crypto/rsa/rsa_pk1.c:67:
    140673277608384:error:04067072:rsa routines:rsa_ossl_public_decrypt:padding check failed:../crypto/rsa/rsa_ossl.c:582:

El padding son unos bytes que están en el mensaje, no se nos muestran, pero al sistema le permiten saber si el descifrado tiene buena pinta o no. En realidad lo que hay cifrado es:

    $ openssl rsautl -verify -in quote -keyform DER -pubin -inkey public_openssl.der -raw | hd
    00000000  00 01 ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
    00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
    *
    000000d0  ff ff ff ff ff ff ff ff  ff ff ff ff 00 30 21 30  |.............0!0|
    000000e0  09 06 05 2b 0e 03 02 1a  05 00 04 14 f0 12 53 ff  |...+..........S.|
    000000f0  49 7e ae 7f a1 55 5c 34  a8 22 c2 49 88 35 c5 8b  |I~...U\4.".I.5..|
    00000100


Tal como manda la especificación *PKCS #1*: 

> Concatenate PS, the DER encoding T, and other padding to form the encoded message EM as
> 
>              EM = 0x00 || 0x01 || PS || 0x00 || T.

Luego si el bloque descifrado no empieza por `00 01 FF`, mal.

Por otro lado, en una firma nunca va sólo el hash. Sino una estructura ASN.1 donde indica el tipo: 

>    Encode the algorithm ID for the hash function and the hash
>    value into an ASN.1 value of type DigestInfo 
>    ...
>    The first field identifies the hash function and the second
>    contains the hash value. 

Añadimos la opción `-asn1prse` para que nos la decodifique:

    $ openssl rsautl -verify -in quote -keyform DER -pubin -inkey public_openssl.der -asn1parse 
        0:d=0  hl=2 l=  33 cons: SEQUENCE          
        2:d=1  hl=2 l=   9 cons:  SEQUENCE          
        4:d=2  hl=2 l=   5 prim:   OBJECT            :sha1
       11:d=2  hl=2 l=   0 prim:   NULL              
       13:d=1  hl=2 l=  20 prim:  OCTET STRING      
          0000 - f0 12 53 ff 49 7e ae 7f-a1 55 5c 34 a8 22 c2 49   ..S.I~...U\4.".I
          0010 - 88 35 c5 8b                                       .5..

El hash de la estructura con las PCRs y el nonce -lo que nos ha firmado el TPM- es:

    f01253ff497eae7fa1555c34a822c2498835c58b   

Sabemos que está cifrado con la clave SRK. Pero en cuanto a las PCRs, ese hash no nos dice nada.


### Generar hash de PCRs

El comando `tpm_getpcrhash` genera un fichero `hash` con el que luego podremos verificar el informe anterior.

    $ tpm_getpcrhash uuid hash pcrvals 0 7

crea un fichero `pcrvals`con el contenido actual de las PCRs 0 y 7:

    $ cat pcrvals 
    0=850659B18EB6FB4CCDCB113CA4266EB945449466
    7=AD919AD2B122E5741612E16329AA7626B63ADA73

Así como un fichero `hash`:

    $ hd hash
    00000000  00 36 51 55 54 32 0e 00  00 00 00 00 00 00 0e 00  |.6QUT2..........|
    00000010  00 00 00 00 00 00 00 00  00 00 00 03 81 00 00 01  |................|
    00000020  c1 e5 49 45 35 78 8f 5e  dd e1 2e e1 75 f3 0e 0f  |..IE5x.^....u...|
    00000030  8f ea 99 54                                       |...T|
    00000034

Que en realidad no es un hash, sino una estructura de tipo `TPM_QUOTE_INFO2` (se sabe por la marca *QUT2*), con la información sobre las PCRs seleccionadas. 

    TPM_QUOTE_INFO2
      00 36                TPM_TAG_QUOTE_INFO2
      51 55 54 32          fixed: QUT2
      0e000000000000000e0000000000000000000000  externalData (nonce)
        TPM_PCR_INFO_SHORT
            TPM_PCR_SELECTION
              00 03        sizeOfSelect
              81 00 00     pcrSelect
          01               localityAtRelease
          c1e5494535788f5edde12ee175f30e0f8fea9954 digestAtRelease
    

Esa es la estructura que ha firmado interiormente el TPM. Sólo que el TPM ha usado con nuestro `nonce` como *external data* mientras que `tpm_getpcrhash` usa uno cualquiera. Al final lo que interesa es el hash del final, llamado **digestAtRelease**.

Como curiosidad, podríamos el fichero `hash` y remplazar en la estructura el nonce por el que tenemos nosotros en el fichero `nonce`, tal que así:

    00 36 
    51 55 54 32 
    5b eb ba af 36 43 bb 9b c5 f3 ed b6 fc 7a 40 75 7b 2f 5d e0   <- nuestro nonce
    00 03
    81 00 00 
    01 
    c1 e5 49 45 35 78 8f 5e dd e1 2e e1 75 f3 0e 0f 8f ea 99 54   <- hash PCRs que venía

Si calculamos el SHA1 de esa estructura saldrá:

    $ xxd -r -p /tmp/hash_nonce | sha1sum 
    f01253ff497eae7fa1555c34a822c2498835c58b  -

Exactamente **el mismo** hash que habíamos obtenido en la sección anterior.


### Verificar la firma

Por supuesto hay un comando llamado `tpm_verifyquote` para verificar la firma sin tener que hacerlo a mano.

Se debe indicar:
 - el fichero donde está la parte pública.
 - la estructura que contiene el hash de las PCRs
 - nuestro nonce
 - el informe firmado `quote`.

El programa hará las validaciones que hicimos antes y dirá si la firma es correcta o no:

    $ tpm_verifyquote pubkey hash nonce quote 
    Error while decoding public key. Error code: TSS_E_INTERNAL_ERROR

Vaya. Ya lo sabía yo.

Al depurar, el error salta en la función `Tspi_DecodeBER_TssBlob` que a su vez se apoya en las funciones ASN.1 de OpenSSL. ¿Os acordáis al principio cuando dije que "Ese *BAD INTEGER* va a causar problemas". Pues aquí esta, la clave tal como está no carga.

Editamos el fichero `pubkey` para hacerlo *compliant*. Es suficiente con eliminar los dos octetos innecesarios del entero y corregir la longitud del conjunto:

    $ openssl asn1parse -in pubkey_compliant -inform der
        0:d=0  hl=4 l= 298 cons: SEQUENCE          
        4:d=1  hl=2 l=   1 prim: INTEGER           :01
        7:d=1  hl=2 l=   1 prim: INTEGER           :02
       10:d=1  hl=2 l=   2 prim: INTEGER           :011C
       14:d=1  hl=4 l= 284 prim: OCTET STRING      [HEX DUMP]:00000001...1D57

Ya está, ya se puede parsear bien.

Ahora ya sí, finalmente:

    $ tpm_verifyquote pubkey_compliant hash nonce quote 
    $

No dice nada porque la firma es correcta.

Si no lo fuera diría algo como:

    $ tpm_verifyquote pubkey_compliant hash other_nonce quote 
    Error while verifying signature. Error code: TSS_E_FAIL


Ya podríamos haber descargado la AIK. Puesto que para la verificación no es necesario hacer uso de las funciones del TPM.

    $ tpm_unloadkey uuid

Con esto concluye la sección sobre *attestation*.




## Bibliografía

### Especificaciones oficiales

 * TPM 1.2 Main Specification <https://trustedcomputinggroup.org/resource/tpm-main-specification/>
 * TCG Software Stack (TSS) Specification <https://trustedcomputinggroup.org/resource/tcg-software-stack-tss-specification/>
 * PKCS #1: RSA Cryptography Specifications Version 2.2 <https://tools.ietf.org/html/rfc8017>


### Manuales y guías

 * Emulation of TPM on Raspberry Pi - Marcus Sundberg & Erik Nilsson <https://www.eit.lth.se/sprapport.php?uid=848>
 * TrouSerS FAQ <http://trousers.sourceforge.net/faq.html>
 * A Practical Guide to TPM 2.0 <https://link.springer.com/book/10.1007/978-1-4302-6584-9>
 * Linux TPM Encryption: Initializing and Using the TPM <https://resources.infosecinstitute.com/linux-tpm-encryption-initializing-and-using-the-tpm/>
 * Universally unique identifier - Wikipedia <https://en.wikipedia.org/wiki/Universally_unique_identifier>
 * TPM Funcionality <https://ladyitris.wordpress.com/tpm-functionality/>

### Bitlocker

 * TPM fundamentals <https://docs.microsoft.com/es-es/windows/security/information-protection/tpm/tpm-fundamentals>
 * BITLOCKER USING TPM <https://ladyitris.wordpress.com/bitlocker-using-tpm/>

### Ataques

 * A Hijacker's Guide to the LPC bus <https://online.tugraz.at/tug_online/voe_main2.getvolltext?pCurrPk=59565>
 * A Bad Dream: Subverting Trusted Platform Module While You Are Sleeping <https://www.usenix.org/system/files/conference/usenixsecurity18/sec18-han.pdf>
 * A Security Assessment of Trusted Platform Modules <https://www.cs.dartmouth.edu/~trdata/reports/TR2007-597.pdf>
 * Subverting BitLocker with One Vulnerability <https://i.blackhat.com/eu-19/Thursday/eu-19-Han-BitLeaker-Subverting-BitLocker-With-One-Vulnerability.pdf>

### Experimentación

 * GitHub Trousers <https://github.com/srajiv/trousers/>
 * tpm2-software/tpm2-tss <https://github.com/tpm2-software/tpm2-tss>
 * tpm-quote-tools <https://github.com/edgeos/tpm-quote-tools/blob/develop/README>
 * TPM-Emulator v0.7 - A Software-based TPM and MTM Emulator. <https://github.com/PeterHuewe/tpm-emulator>

