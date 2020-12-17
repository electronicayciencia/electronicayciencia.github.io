---
assets: /assets/2010/04/espectroscopia-casera-con-copas
image: /assets/2010/04/espectroscopia-casera-con-copas/img/copa.jpg
layout: post
tags:
- Experimentos
- Sonido
title: Espectroscopía casera con copas
---

La [espectroscopia](http://es.wikipedia.org/wiki/Espectroscopia) es una técnica analítica que nos permite distinguir los componentes de una sustancia desconocida. Aprovecha que cada molécula tiene una configuración específica y por tanto unas frecuencias de resonancia que la caracterizan. En estas frecuencias la molécula vibra acumulando la energía de la onda, hecho que puede producir calor. Tal es el fundamento del microondas.

Lo de tener ciertas frecuencias con un comportamiento especial no es exclusivo de las moléculas ni mucho menos. Todo oscilador tiene una frecuencia de resonancia que se corresponde con la frecuencia natural de vibración del sistema. Cuando sólo hay un oscilador y es armónico sólo tiene una, pero en la naturaleza nada es ideal, y los espectros de emisión son muy variados. Las longitudes de onda para las que el sistema tiene un comportamiento diferente al resto son del orden del tamaño de este, así pues los sistemas pequeños resuenan en frecuencias más altas, por ejemplo:

- **Osciladores microscópicos**: un átomo o una molécula presentan líneas de emisión en el ultravioleta (mercurio), espectro visible (sodio), infrarrojo (metano) o microondas (agua).
- **Osciladores electrónicos**: un circuito resonante RLC puede oscilar entre unas pocas hasta varios millones de veces por segundo, dependiendo de los valores L y C. Se cumple que cuando L o C aumentan, baja la frecuencia y viceversa.
- **Osciladores mecánicos**: un resorte, un diapasón, un instrumento musical o una copa de vidrio son ejemplos clásicos. La frecuencia de las oscilaciones cae en un espectro fácilmente audible (entre 50 y 10.000Hz). Y todos sabemos que una campana o tubo de órgano suenan más grave cuanto más grandes son.

En este artículo vamos a ver algunos experimentos sencillos de espectroscopia acústica en los que usaremos copas como elementos resonantes.

## Averiguar las frecuencias de resonancia

Tomemos una copa, un vodka con naranja estaría bien. Ahora vamos a por una **copa vacía** para hacer las pruebas. Lo primero que hemos de obtener son las frecuencias de oscilación libre de esa copa. Estas dependerán del tamaño y forma, así como de la composición y grosor del material. De ahí el timbre característico de una copa de fino cristal de Bohemia, frente a una copa usual de vino o un simple vaso. Y de ahí también el que varíe cuando se llena de un líquido, cuando se toca, etc.

{% include image.html size="small" file="copa.jpg" caption="" %}

Podríamos utilizar un oscilador y un micrófono. Si variamos la frecuencia mientras visualizamos la amplitud de la señal captada veremos cómo crece al acercarnos a una frecuencia de resonancia. Este método es viable y así es como se hacía antes de que existieran los ordenadores, cuando no era tan sencillo calcular la [Transformada de Fourier](http://es.wikipedia.org/wiki/Transformada_r%C3%A1pida_de_Fourier). Otro día me detendré en explicarla, porque es realmente interesante; baste hoy con decir que es una operación tal que, a partir de un sonido, obtiene las frecuencias de que se compone.

Este proceso de variar la frecuencia y observar la respuesta es más o menos fácil de hacer con el sonido; con las microondas es un poquito más chungo; y con la luz necesitamos un monocromador, que es bastante caro. Así que lo que se hace hoy día se parece a lo que vamos a hacer nosotros: excitar la muestra con todas las frecuencias por igual y analizar la respuesta a usando la transformada de Fourier.

Parece sencillo, sólo necesitamos un sonido que se componga de todas las frecuencias, y tenemos dos opciones:

- **[ruido blanco](http://es.wikipedia.org/wiki/Ruido_blanco)**. Dado que el ruido no sigue ningún patrón, todas las frecuencias tienen la misma probabilidad. Así la densidad espectral es constante. Pero hay otra forma de obtener un espectro con todas las frecuencias posibles.
- **pulso instantáneo**. Si nos vamos a una tabla de [transformadas básicas](http://es.wikipedia.org/wiki/Transformada_de_Fourier#Tabla_de_Transformadas_b.C3.A1sicas) la función pulso (también llamada [delta de Dirac](http://es.wikipedia.org/wiki/Delta_de_Dirac)) tiene un espectro que no depende de la frecuencia, constante por lo tanto. Es el mismo fenómeno por el que un rayo o una chispa de un mal contacto hacen interferencias en todos los canales de radio y televisión: tienen componentes electromagnéticos en todas las frecuencias.

## Respuesta a un impulso

¿Cómo podemos aplicar energía instantánea a una copa? muy fácil: dándole un golpecito. Así es, ese *tíiinnnn* característico que oímos se compone de las frecuencias de resonancia. Pero eso es hacer trampa, a una copa podemos darle un golpe, pero supongamos que no podemos tocar el sistema. Necesitamos algo que lo golpee sin tocarlo. Necesitamos un *flash* de sonido, una [onda de choque](http://es.wikipedia.org/wiki/Onda_de_choque) es decir, necesitamos **una detonación**. No es plan de tirar un petardo en casa. Así que, aunque quede más ridículo, para lo que quiero hacer también me servirá con explotar **un globo**.

Lo siguiente es un sonograma creado por el programa [baudline](http://www.baudline.com/). El tiempo avanza hacia abajo de la pantalla, siguiendo el eje vertical. Las frecuencias están en el eje horizontal.

{% include image.html size="medium" file="globo.png" caption="" %}

Cuando aportamos energía a la copa, esta absorbe la que corresponde con sus frecuencias características y a continuación la emite. Lo que vemos es un aporte inicial de energía -la explosión- y a continuación los *ecos*. Hay tres tonos principales, los llamaremos A1, A2 y A3 (copa A, tonos 1, 2 y 3) de 1160Hz, 2410Hz y alrededor de 4400Hz. Nos centraremos en A1 y A2, vale la pena observar que son dos tonos limpios, en el sentido de que ninguno presenta armónicos superiores.

Lo que vemos instantes después de la explosión es la reverberación en las paredes, así como otras resonancias más débiles de los objetos de la habitación. Al ser tan débiles se desvanecen rápidamente, si quisiéramos apreciarlo con claridad en el espectro necesitaríamos una frecuencia de muestreo mucho más alta que la que tenemos con nuestra tarjeta de sonido. Con esta información podríamos obtener la respuesta acústica de un espacio y nos serviría si quisiéramos adecuarlo para un concierto por ejemplo.

Una onda de choque transporta energía, en algunos casos mucha, que absorben los cuerpos con los que se topa. Un cuerpo que puede vibrar libremente recibe más energía que otro que esté sujeto. Por eso una explosión puede romper cristales y tímpanos a cierta distancia. A la onda de choque se le llama también *onda expansiva* u *onda de presión*. Los órganos internos están sujetos pero no demasiado: aún cuando no haya efectos visibles, un testigo cercano de una detonación potente puede presentar daños internos de mucha severidad debido únicamente a la onda expansiva.

## Oscilación forzada

Cabe preguntarse qué sucede si aplicamos a la copa un tono de una frecuencia a la que esta resuene. El resultado es esperable: que vibra. Pero esto tiene dos consecuencias:

{% include image.html size="" file="tono1160.png" caption="" %}

- Que una vez la fuente desaparece, al cabo de 0.1s, la vibración persiste durante un tiempo largo (tiempo que viene dado por el llamado [factor de calidad Q](http://es.wikipedia.org/wiki/Factor_de_calidad)). Encontramos una aplicación de este fenómeno en los **[amplificadores de clase C](http://en.wikipedia.org/wiki/Electronic_amplifier#Class_C)**. En un amplificador de clase C, el transistor amplifica mucho muchísimo la señal, pero sólo durante un tiempo que no cubre ni medio ciclo. Produce una distorsión muy desagradable y no sirve para audio. Pero ¿y si quisiéramos amplificar una frecuencia en concreto, para radio por ejemplo? Si lo acompañamos de un circuito tanque (un circuito LC paralelo) que resuene a la frecuencia que queramos pasará como con la copa: que el circuito resonante **recompone** el resto de la sinusoide que no amplificaba el transistor. Tendremos una amplificación muy eficiente, a cambio de limitarnos a **una sola frecuencia**.

{% include image.html size="" file="clasec.png" caption="" %}

- Lo otro es que la copa vibra (lo habíamos dicho), y vibra más cuanto mayor es la amplitud de la señal aplicada (obvio), y si subimos el volumen lo suficiente vibra tanto que **se rompe**. Seguro que todos habéis oído eso de romper una copa con la voz. Pues sí, es posible, con una nota que coincida con la frecuencia de resonancia, siempre que se cante a suficiente volumen la copa se parte. De hecho hay un episodio de *Mythbusters* donde hacen la prueba. ¿Por qué? Pues porque lo que se forma en el cristal es una [onda estacionaria](http://es.wikipedia.org/wiki/Onda_estacionaria) y cuando la amplitud del desplazamiento sobrepasa la flexibilidad del cristal, pues se parte.

En el sonograma veis un tono de 1160Hz y varios armónicos (nombrados A1 -fundamental-, A1b, A1c, etc.). Me hubiera gustado ofreceros una sinusoidal pura, pero no tenía altavoces amplificados y tuve que improvisar con un altavoz de mierda y un *LM386*. Como veis la copa también es sensible a los armónicos pero sólo si la forzamos y, mucho menos que a la fundamental. Por eso no se aprecian en la respuesta a impulso.

Por cierto, al final del post pongo un enlace a los archivos wav. Si reproducís al revés la explosión obtendréis un impresionante efecto "*peli de misterio*".

## Espectroscopia

Hagámoslo más interesante. Antes hemos dicho que se podía intuir la composición de una muestra viendo su espectro de emisión. Es una consecuencia de que el sonido y la luz son ondas, y como tales cumplen el [principio de superposición](http://es.wikipedia.org/wiki/Principio_de_superposici%C3%B3n_%28f%C3%ADsica%29).

Tengo un sistema compuesto de tres copas, llamémoslas A (la que hemos usado antes), B y C. Cada copa tendrá unos picos de emisión, esos los nombraremos con un número correlativo. En el siguiente sonograma vemos los picos excitando cada copa individualmente para ver su espectro característico y después todas al mismo tiempo para ver el espectro completo del sistema.

{% include image.html size="medium" file="sistemaCopas.png" caption="" %}

Antes de nada recordar que lo que estamos viendo no es un espectro de emisión, es un sonograma. Los picos no son picos, sino prolongaciones de esa frecuencia en el tiempo posterior a la excitación. Aún así hablaré de picos por comodidad. Realmente se parece más a una [Resonancia Magnética (RMN)](http://es.wikipedia.org/wiki/Resonancia_magn%C3%A9tica_nuclear), pero no quiero complicar más la entrada.

Varias cosas interesantes:

- El **espectro conjunto** es la suma del espectro de cada copa por separado. Lo que muestra que no hay interacción de una copa con las demás. Así, si tenemos una base de datos con los espectros de todos los modelos de copas que tenemos en casa y nos dan el espectro de un grupo de ellas, podemos decir exactamente de cuales se componía. Extrapolad esto a cientos de miles de moléculas conocidas y sabréis cómo se identifican dentro de una muestra.

- **Los picos C2 y B2** tienen una frecuencia muy cercana. Por eso cuando excitamos cada copa de forma independiente la frecuencia que emite el uno hace también vibrar al otro. Pero aquí ocurre algo muy interesante, porque fijaos en esta imagen ampliada:

{% include image.html size="" file="absorcion_C2.png" caption="" %}

He sacrificado definición de la imagen en favor de que se vea más claro lo siguiente. Cuando golpeamos la copa B, oímos el golpe, que como ya hemos dicho se compone de todas las frecuencias, bueno de todas no. Resulta que el sonido de B tiene que atravesar C para llegar al micrófono, así que **C absorbe la energía** en su frecuencia C2 e instantes después la vuelve a emitir. En esta imagen no se ve cómo la emite, para verlo tenéis que mirar la anterior.

- **El pico A3** parece que esté dividido en dos muy próximos. En efecto al menos los picos A2 y A3 se desdoblan. Es algo común en espectroscopia, y pueden deberse a una acción externa (como el [efecto Zeeman](http://es.wikipedia.org/wiki/Efecto_Zeeman) o el [efecto Stark](http://es.wikipedia.org/wiki/Efecto_Stark)), pero aquí seguramente se deba a defectos en el material. Estos son los picos anteriores ampliados. Se necesita estrujar la FFT para obtenerlos y no se ven del todo bien.

{% include image.html size="small" file="tono_A2.png" caption="" %}

{% include image.html size="small" file="tono_A3.png" caption="" %}

## Espectro completo de A

Para terminar, os dejo el espectro completo de A hasta los 15.000Hz. Espero que hayáis encontrado este artículo tan interesante como yo.

{% include image.html size="big" file="espectro_A.png" caption="" %}

Como siempre, podéis encontrar los ficheros utilizados en esta entrada [aquí]({{page.assets | relative_url}}/espectroscopia_copas.zip).
