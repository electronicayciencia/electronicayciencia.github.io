---
assets: /assets/2010/08/configurar-un-raton-serie-en-un-linux
layout: post
tags:
- Informática
- Reciclaje
title: Configurar un ratón serie en un Linux moderno
---

Este fin de semana me ha dado por volver a instalar el [FlightGear Flight Simulator](http://www.flightgear.org/), un simulador de vuelo. Por cierto, como instalar FlightGear 1.9 en Debian desde los repositorios es imposible (dependencias rotas, paquetes que no existen, etc), probad [esta página](http://www.unitedfreeworld.com/ubuntu_debian_fgfs_installation.html). A mi me resultó muy práctica.

La última vez que probé el simulador me dio por hacerme un mando a modo de joystick gigante. Porque no es lo mismo mover el ratón por la mesa que tener un palanca de mando al lado. Por chapucera que sea. Lo publicaré en una próxima entrada, por si alguien encuentra útil la idea.

El caso es que utilicé un ratón de los de bola (no sirven los ópticos) y para que os hagáis una idea del tiempo que tiene el chisme, es un ratón que va conectado al puerto serie. No es USB, ni siquiera PS2.

Me dispongo a configurar el ratón como segundo dispositivo apuntador en el Xorg. Según las instrucciones de varias páginas, se trata de añadir una sección al xorg.conf:

    Section "InputDevice"
        Identifier "Mouse1"
        Driver "mouse"
        Option "Device" "/dev/ttyS0"
        Option "Protocol" "Microsoft"
    EndSection

E incorporarlo en la sección ServerLayout:

    InputDevice "Mouse1" "SendCoreEvent"

Bien, esta era la solución clásica, pero hay que decir que en muchos casos **ya no funciona**.

## Pruebas infructuosas

Después de modificar el fichero y reiniciar el servidor X, no detecta el segundo ratón. El primero que es PS2 sí, ningún problema, pero el ratón serie no lo ve. Así que instalo **gpm** -una utilidad para el ratón en consola- para comprobar que el ratón sigue funcionando y no está estropeado. En efecto gpm lo ve sin problemas en */dev/ttyS0* y se mueve el cursor.

Instalo **xinput**, una herramienta que muestra los dispositivos de entrada y los eventos recibidos en el core X11. Me detecta un ratón *"ImExPS/2 Generic Explorer Mouse"*, el principal, pero no el ratón serie. Pienso que puede ser un error en la configuración, e intento varias configuraciones cambiando parámetros en el xorg.conf. Sin éxito.

Lo que me lleva a pensar que no está leyendo el fichero, puede que */etc/X11/xorg.conf* no sea el fichero de configuración, puede que haya otro alternativo. Inicio el servidor X desde consola con sin el KDM. Me informa de que está leyendo ese fichero y no otro.

Enfadado elimino la configuración del ratón principal, dejo al servidor sólo con el ratón serie que no detecta. Esperando que se queje de no encontrar un puntero y termine inmediatamente (el servidor X, cuando no encuentra un ratón u otro dispositivo apuntador válido, no se inicia). Pues bien, se sigue iniciando, y para mi sorpresa **sigue detectando el ratón PS2**.

Después de muchas pruebas fallidas, navegando doy con la solución. Esto era lo que estaba pasando.

## Causa y solución

En las distribuciones de Linux modernas **no se usan** las secciones InputDevice del xorg.conf. De hecho algunas veces vienen comentadas, o simplemente no existen tales secciones. Ahora (Debian Lenny/Squeeze) se hace todo a través de una capa intermedia llamada [HAL *Hardware Abstraction Layer*](http://en.wikipedia.org/wiki/HAL_%28software%29). Que es la que permite insertar los pen-drives o los CDROM y que se reconozcan automáticamente por el sistema, además de otras muchas cosas. Tantas cosas que según la página anterior de la Wikipedia, se ha vuelto un monstruo inmantenible y se quiere reemplazar por *udev*.

Pues el servidor X lee los dispositivos de HAL, y no de su archivo de configuración, por eso no detectaba el ratón serie, y aunque eliminara el principal PS2 seguía viéndolo. Para que incorpore el nuevo ratón hay que instalar la utilidad **inputattach** (en debian hay un paquete aparte, en Ubuntu creo que viene con la utilidad gpm que antes he nombrado).

El comando mágico es este:

    inputattach --microsoft /dev/ttyS0

...y mano de santo. Con eso ya conseguí que me reconociera el ratón. No es necesario ni reiniciar el servidor X, se hace al vuelo.

Al buscar en Google casi todas las páginas que aparecen explican la solución antigua, dándole difusión con este modesto artículo espero ahorrarle a alguien unas cuantas horas de despropósito.
