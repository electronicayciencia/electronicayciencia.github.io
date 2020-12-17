---
assets: /assets/2010/04/decodificacion-del-protocolo-rc5-usando
image: /assets/2010/04/decodificacion-del-protocolo-rc5-usando/img/rc5.png
layout: post
tags:
- Binario
- PIC
title: Decodificacion del protocolo RC5 usando un PIC
---

Dicen que la gran mayoría de los mandos a distancia **infrarrojos** que tenemos por casa funcionan usando la codificación RC5. En mi caso, de nada menos que 7 mandos analizados, 2 son Sony y el resto usan la codificación NEC o similares. Pero hoy voy a hablar del RC5.

Empecemos por lo básico, los impacientes pueden saltarse la intro.

## Transmisión

Los mandos a distancia funcionan transmitiendo al receptor un código binario. La longitud en bits del código depende del formato, pero en ese código ciertos bits indican **el aparato** y otros **la función**. El aparato (o identificador) indica a qué electrodoméstico va destinada la orden (TV, TDT, DVD...), mientras que la función indica cuál es la orden. El identificador no es único, en el sentido de que es el mismo para todos los aparados de una misma marca y modelo. Por regla general el aparato es siempre el mismo para todos los botones del mando, y cada botón está identificado por un código que es el número de la función.

Puede ocurrir que una marca use el mismo formato que otra, y además dé a casualidad de que ambas marcas han elegido los mismo códigos de identificación y de función que otra, en ese caso podemos usar el mando de una con la otra. Pero habitualmente la concordancia no es total:

- Si sólo coinciden las funciones da lo mismo, porque el receptor no va a hacer ningún caso códigos que no vayan destinados a él.
- En cambio, si sólo coincide el código de identificación pero las funciones son distintas. El receptor obedecerá una orden que no iba para él, llevándole a ejecutar a saber qué función, y por eso *cuando subimos el volumen de la tele, se apaga el DVD.*

Para transmitir el código y que el receptor pueda distinguirlo del ruido de ambiente se usa una portadora que está entre 36 y 40kHz. Un [módulo especial](http://www.vishay.com/docs/81732/tsop348.pdf) se encarga de detectar y demodular tal frecuencia, así transforma la señal recibida en niveles lógicos que pueden interpretarse luego mediante un micro.

La forma de codificar un 1 o un 0 en esa portadora es lo que diferencia el formato. Veamos como es en el caso de RC5.

## Modulación RC5

La modulación que emplea el formato RC5 es una [codificación Manchester](http://es.wikipedia.org/wiki/Codificaci%C3%B3n_Manchester), que se emplea también en algunos tipos de redes. En el enlace dela Wikipedia que os doy lo explican mucho mejor de lo que yo sabría hacerlo.

El protocolo RC5 se compone de:

- 2 Bits de *start*, siempre a 1. Sirven para que el módulo receptor ajuste su ganancia respecto al ruido de fondo. Además el receptor puede usarlos para sincronizar su señal de reloj.
- Un bit de *toogle.* Cambia de 1 a 0 y de 0 a 1 cuando se pulsa el mismo botón dos veces seguidas. A diferencia de otros protocolos, los mandos RC5 repiten el mismo código íntegro cada 114ms. Viendo el estado de este bit el receptor sabe si el usuario ha levantado el dedo y lo ha vuelto a pulsar. Útil para los botones que tienen una función y la contraria como encender/apagar, silencio/voz, canales 1_/1, etc.
- 5 bits de identificación, también llamados *address*. Como ya hemos dicho sirven para indicar a qué aparato nos dirigimos.
- 6 bits de comando,indican qué botón se ha pulsado.
- Este protocolo no tiene un último bit de *stop*.

En total son 14 bits.

En [esta pagina web](http://www.sbprojects.com/knowledge/ir/rc5.htm) hay unas imágenes muy buenas de cómo funciona la modulación RC5 y otras:

> All bits are of equal length of 1.778ms in this protocol, with half of the bit time filled with a burst of the 36kHz carrier and the other half being idle. A **logical zero is represented by a burst in the first half** of the bit time. A **logical one is represented by a burst in the second half** of the bit time.

## Vamos a la práctica

Supongamos que recibimos un tren de impulsos como este:

{% include image.html size="big" file="rc5.png" caption="" %}

No es un código RC5, ya que sólo consta de 5 bits de datos, no 11 y además uno de parada, pero la modulación es similar. Con un micro ¿cómo transformamos eso a unos y ceros?

Hay varias formas. La más utilizada y más sencilla es tomar el tiempo de cada bit, que en teoría son 1778ms y dividirlo en dos. Ahora comprobar el nivel del puerto en una de esas mitades, supongamos que en la segunda mitad. Si la segunda mitad es un nivel alto se trata de un 1, de lo contrario es un 0. Si cogiésemos la mitad primera sería al revés: un nivel alto nos indicaría que se está transmitiendo un cero. Este proceso tiene varios inconvenientes, por ejemplo:

- Frecuencia de reloj inexacta. Si el transmisor o el receptor sufre una deriva temporal, es posible que empecemos bien pero erremos los bit finales.
- Inversión de los bits. Por lo general los módulos decodificadores TSOP invierten los bits, es decir, su salida está a nivel alto continuamente salvo cuando reciben una portadora de 36kHz (la frecuencia depende del modelo) que ponen su salida a 0. Esto puede dar lugar a confusión.
- Exige una interrupción periódica. A veces no podemos permitirnos usar un temporizador de micro sólo para esto y el desarrollo se complica.

## Forma de decodificación alternativa

La rutina que quiero presentaros funciona de otra manera. El uso de un temporizador es opcional y sólo precisa una interrupción de cambio de estado para el pin en concreto.

Si miramos la imagen de arriba, la idea principal es que cuando cambiamos de 1 a 0 y viceversa transcurre el doble de tiempo que si continuamos con el mismo valor. Además si seguimos con el valor anterior ya fuera 0 o 1 se producen 2 interrupciones.

La línea superior en la imagen indica con un punto numerado el lugar de cada transición. Por orden numérico:

1. Partimos de 0, así que esta primera transición la tomaremos como **a marca de cambio** a 1. Anotamos un 1.
1. Se produce en un tiempo t, no es más que una **marca de confirmación** del valor anterior, o sea 1. Como se trata de una señal de las llamadas *self-clocking*, habrá transiciones que no porten datos. No hacemos nada.
1. Como sólo transcurre t, indica que continuamos con el valor anterior, es una **marca de continuación**. Anotamos otro 1.
1. Aquí pasa un intervalo 2t, significa una **marca de cambio**, el bit anterior era 1 luego este será un 0. Anotamos un 0.
1. De nuevo intervalo 2t, **marca de cambio**: Estábamos con 0 así que anotamos un 1.
1. 2t, **marca de cambio**: anotamos un 0.
1. Sólo t, **marca de continuación** del valor anterior: anotamos un 0.
1. Sólo t, **marca de confirmación**, no hacemos nada.
1. **Marca de cambio**: anotamos 1.
1. **Marca de confirmación**: nada.
1. 0.
1. 1. Aquí pararíamos, porque con este ya hemos recibido nuestros 10 bits. En el caso de RC5 son 14 bits.
1. nada.

El número decodificado es

    1101001101

. Lo que signifique ya vendrá luego. La máquina de estados sería algo así:

<table border="1"><tbody><tr><th>Tiempo</th><th>Espera conf.</th><th>Marca de</th><th>Accion</th></tr><tr> <td>t</td>  <td>No</td> <td>Continuación</td> <td>Anotamos el mismo valor anterior y pasamos a esperar marca de confirmación.</td> </tr><tr> <td>t</td>  <td>Si</td> <td>Confirmación</td> <td>No hacemos nada. Tan sólo dejamos de esperar la confirmación.</td> </tr><tr> <td>2t</td> <td>No</td> <td>Cambio</td>       <td>Anotamos el valor opuesto al último recibido.</td> </tr><tr> <td>2t</td> <td>Si</td> <td>ERROR</td>        <td>ERROR de transmisión. La marca de confirmación siempre llega en un tiempo t.</td> </tr></tbody></table>

Para obtener el periodo de reloj podemos valernos de que cada transición se da en t o en 2t, en concreto durante los 2 bits de *start* se producen 3 transiciones t pues sabemos que esos bits siempre están a 1.

Esta entrada me está quedando demasiado larga. Voy a parar aquí y dejo la programación para más adelante.

**Actualización:** El código para implementar este algoritmo se describe en [http://electronicayciencia.blogspot.com/2011/01/programacion-pic-para-decodificar-rc5.html]({{site.baseurl}}{% post_url 2011-01-19-programacion-pic-para-decodificar-rc5 %})
