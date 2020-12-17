---
assets: /assets/2010/05/criptoanalisis-del-cifrado-xor-simple
featured: 'true'
image: /assets/2010/05/criptoanalisis-del-cifrado-xor-simple/img/XOR_TABLE.jpg
layout: post
tags:
- Estadística
- Informática
- Matemáticas
title: Criptoanálisis del cifrado XOR simple
---

Voy a presentaros un experimento que hice hace tiempo estudiando el cifrado simple XOR. Se trata de una herramienta que es capaz de adivinar la clave con que se ha cifrado un archivo y descifrarlo. Nada más que haciendo un criptoanálisis del texto cifrado. Veréis que el algoritmo es sencillo, y por qué dicen los expertos que XOR es un cifrado *de juguete*.

> An XOR might keep your kid sister from reading your files, but it won’t stop a cryptanalyst for more than a few minutes. -[Bruce Schneier](http://een.iust.ac.ir/profs/Falahati/Cryptography/CrytoBooks/B_Schneier%20-%20Applied%20Cryptography/ch01/01-05.html#Heading5)-

<!--more-->

## Propiedades de la operación XOR

Para los muy profanos, no iba a decir lo que es un xor y en su lugar iba a pegar un enlace a la Wikipedia, pero creo que os ibais a quedar igual, así que tened en cuenta esto: un xor es la abreviatura de eXclusive OR. Recordad que un OR es *A o B* y por tanto vale 1 en cuanto A o B valgan 1.

- 0 ó 0 = 0
- 0 ó 1 = 1
- 1 ó 0 = 1
- **1 ó 1 = 1** (y aquí está la diferencia)

En un or **exclusivo** sería:

{% include image.html size="" file="XOR_TABLE.jpg" caption="" %}

Si separamos la tabla en dos veremos una propiedad curiosa: cuando A es 0, entonces la salida es lo mismo que B (cuadro azul), pero si A vale 1, entonces la salida es lo contrario de B (B negado). Una forma de ver la función XOR es que nos permite invertir bits a voluntad.

{% include image.html size="" file="XOR_TABLE_cuadros.jpg" caption="" %}

Otras propiedades interesantes de esta operación:

1. **Es conmutativa:** Es decir que A xor B = B xor A
1. **Asociativa:**(A xor B) xor C = A xor (B xor C)
1. **Autoinversa:**(A xor B) xor B = A

La propiedad **2** dice que si ciframos un texto con dos claves distintas es lo mismo que si cifráramos con una única clave resultado de hacer XOR entre las dos anteriores. Por lo que dar dos o mas pasadas en un cifrado XOR carece de lógica, ya que por la propiedad siguiente hasta podría dejar el texto claro tal cual estaba.

La propiedad **3** se deduce de la **2** sabiendo que cualquier número xor consigo mismo es 0:

    A xor A = 0

por la propia definición de xor. Esto hace de xor una función nilpotente, tal que si se aplica dos veces con la misma clave, se vuelve al original. Además

    0 xor B = B

, así que si ciframos con xor un texto que contenga bloques de 0 seguidos estamos guardando en el archivo la clave de cifrado.

La propiedad **2** es peligrosa para aplicaciones  criptográficas pues nos permite modificar datos predecibles sin  necesidad de conocer la clave de cifrado. El cifrado  wireless WEP, por ejemplo, es lo mismo que [un  generador de números aleatorios](http://es.wikipedia.org/wiki/RC4) más un XOR. En los paquetes cifrados con WEP, y concretamente en las cabeceras de las capas inferiores (ARP, IP, TCP) hay datos que son conocidos como la MAC del router, o fácilmente predecibles, como la IP del PC cliente o del punto de acceso. Sabiendo el texto en claro podemos extraer de él la clave, y volver a cifrar los datos alterados. Se conocen varios ataques a WEP que dan muy buenos resultados, de hecho ya no se aconseja utilizar WEP.

## Cifrado XOR simple

Para cifrar un texto se escoge una clave y se aplica la operación a cada byte de texto. Como generalmente la longitud de la clave es menor que la longitud de texto que ciframos lo que se hace es repetirla cíclicamente. Un ejemplo se puede ver en la [Wikipedia](http://es.wikipedia.org/wiki/Cifrado_XOR) pero hay multitud de sitios que lo explican bien.

Como habíamos apuntado arriba, es lo mismo que invertir bits del texto en claro. ¿cuales bits? Pues depende de la clave. Cuando el bit de la clave sea 1 se invierte el bit original, y cuando toque 0 en la clave, se deja igual. En teoría sin la clave es imposible saber qué bit se han invertido y cuales se han dejado igual, así que no tenemos información para descifrar el texto a menos que tengamos la clave.

*¿Seguro?*

## Criptoanálisis

Vamos con el análisis de un texto cifrado. Lo primero será averiguar la longitud de la clave ¿pero eso se puede? Pues en general sí que se puede. Suponed que tenemos un texto sin cifrar, de un libro por ejemplo. Si lo desplazamos un carácter y contamos las letras que coinciden ronda el 6%. Si lo desplazamos dos caracteres o n, lo que sean, y contamos la tasa de coincidencia ronda también el 6%. Es debido a la redundancia de los lenguajes escritos, no me voy a detener en eso ahora.

El caso es que en un texto cifrado eso no se cumple. Si cogemos un texto cifrado parecen caracteres aleatorios. Y si lo desplazamos y lo superponemos no va a coincidir más de un 1% o como mucho 2%, porque una 'a' estará cifrada con la primera letra de la clave que puede ser 'E' mientras que más adelante otra 'a' puede estarlo con la cuarta letra de la clave, una 'h'. Pero seguimos desplazándolo y superponiéndolo consigo mismo, 2 caracteres, 3, 4... hasta que llegamos a la longitud de la clave. En ese momento, como la clave es cíclica, las coincidencias aumentan súbitamente hasta el 6%. Serán coincidencias de caracteres raros, pero coincidencias. Así vamos rotando el texto y superponiéndolo. Y esos picos se producen justamente cuando el desplazamiento del texto es un múltiplo exacto de la longitud de la clave.

{% include image.html size="big" file="xor.png" caption="" %}

Ved arriba cómo varían las coincidencias al superponer consigo mismo un texto cifrado con una clave de 16 caracteres de longitud. Los picos están en los múltiplos de 16. A partir de ahí inmediatamente deducimos la longitud de la clave. Este efecto sólo funciona cuando:

- La longitud de la clave es mayor que 2 caracteres.
- La longitud del texto es muy grande comparada con la de la clave.
- La clave no tiene grupos de caracteres repetidos.

Y ahora que sabemos cómo es de larga la clave ¿qué hacemos? Pues hay dos caminos.

**Camino A:** Schneier propone hacer xor del texto original con el mismo texto desplazado tantos caracteres como tiene la clave, con esto anulamos la clave:

    Esto es un ejemplo de texto cifrado con la palabra    (XOR)
    claveclaveclaveclaveclaveclaveclaveclaveclaveclave
    (XOR)
    es un ejemplo de texto cifrado con la palabra clav    (XOR)
    claveclaveclaveclaveclaveclaveclaveclaveclaveclave
    --------------------------------------------------------
    Esto es un ejemplo de texto cifrado con la palabra    (XOR)
    es un ejemplo de texto cifrado con la palabra clav

porque por las propiedades antes dichas:

    (TEXTO xor CLAVE) xor (TEXTODESPLAZADO xor CLAVE) = 
    (TEXTO xor TEXTODESPLAZADO) xor (CLAVE xor CLAVE) =
    (TEXTO xor TEXTODESPLAZADO)

A partir de ahí tenemos suficiente información para descifrar el texto.

**Camino B:** Dividir el texto en tantas columnas como caracteres tenga la clave. Así cada una de las columnas está cifrada con el mismo carácter de la clave. Y podemos aplicar un análisis de frecuencias para saber cual es ese carácter que cifra toda la columna. Dicho de forma más técnica, *hemos pasado de tener un texto cifrado con un sistema de sustitución polialfabético a tener varios textos cada uno con un cifrado de sustitución simple*.

Precisamente los cifrados de sustitución polialfabéticos se inventaron para evitar el análisis de frecuencias de letras que hacía posible descifrar las sustituciones simples. No tenemos más que tomar una columna y ver qué carácter es [el que más se repite](http://en.wikipedia.org/wiki/Letter_frequencies). Generalmente será el correspondiente al ESPACIO o bien, si hemos suprimido los espacios, la E, o la A, dependiendo del idioma en que esté escrito el texto. Como cualquier cosa estadística, esta afirmación es más cierta cuanto más largo sea el texto que tengamos.

Cuando sepamos con qué carácter se cifra cada columna, ya sabemos la clave completa y ya podríamos descifrar el texto.

## Herramientas del estudio

Hice un par de herramientas mientras investigaba este campo. Una se llama simplemente *XOR.pl* y sirve para aplicar la operación XOR al texto que se le pase como parámetro, usando una clave proporcionada por el usuario. Sirve tanto para cifrar como para descifrar. Porque recordad que para descifrar el texto es suficiente con volver a aplicar el xor con la misma clave. La otra se llama *xor_frecs.pl* y es la que realiza el estudio de frecuencias y finalmente obtiene la clave.

Para ver cómo funcionan primero tomaremos un texto, por ejemplo un *[Lorem Ipsum](http://www.lipsum.com/)* y lo cifraremos con la clave que queramos:

    $ XOR.pl loremipsum.txt
    -= Estudio de Cifrado =-
    Introduce la clave de cifrado: 3lectronic4
    $

Se crea un archivo cifrado. Ahora aplicaremos el criptoanálisis que he descrito antes para encontrar la clave:

    $ xor_frecs.pl loremipsum_XOR_3lectronic4
    -= Estudio de Cifrado =-
    Desplazamiento: 1 caracteres, grado de coincidencia 2.103310%
    ...
    Desplazamiento: 10 caracteres, grado de coincidencia 2.078164%
    Desplazamiento: 11 caracteres, grado de coincidencia 6.701831%
    Desplazamiento: 12 caracteres, grado de coincidencia 1.893234%
    ...
    Desplazamiento: 21 caracteres, grado de coincidencia 2.458761%
    Desplazamiento: 22 caracteres, grado de coincidencia 5.821918%
    Desplazamiento: 23 caracteres, grado de coincidencia 2.086577%

Primero aplica desplazamiento de varios caracteres y anota el índice de coincidencia. Por cómo aumenta la coincidencia cuando el desplazamiento es 11 o 22 intuimos ya que la clave podría tener 11 caracteres.

    Filtrando resultados (coincidencia > media + n * varianza):
    Media estadística de los resultados: 2.0445164058409
    Varianza: 2.32809936248974
    Con n = 2.36 (9 resultados) longitud obtenida 76.27 -> r = 0.982123
    Con n = 2.13 (42 resultados) longitud obtenida 37.43 -> r = 0.998094
    Con n = 1.91 (92 resultados) longitud obtenida 17.11 -> r = 0.999388
    Con n = 1.72 (131 resultados) longitud obtenida 12.34 -> r = 0.999476
    Con n = 1.55 (144 resultados) longitud obtenida 11.24 -> r = 0.999909
    Con n = 1.39 (147 resultados) longitud obtenida 11.00 -> r = 1.000000
    
    La longitud de la clave parece que es 11.

Para saber cual es la longitud podríamos hacer el mínimo común múltiplo de los desplazamientos que dan un máximo. Pero en este caso yo he preferido hacer una regresión lineal, la pendiente nos dará la longitud de la clave, y por el factor de correlación tendremos una idea de si vamos por buen camino. El algoritmo iterativo que veis se usa para filtrar los picos. Al principio se consideran picos los que superen la media más cuatro veces la normal, pero no hay ninguno así que se va rebajando el umbral **n** hasta que se obtiene un resultado exacto.

Ahora se aplica la separación por columnas y se busca el carácter que más se repite en cada una. Esperamos que sea el espacio. Y de ahí deducimos ya el carácter de la clave que corresponde a cada columna.

    Estudio de las frecuencias de aparición para obtener la clave.
    El caracter de la clave para la columna 1 podría ser '3'.
    El caracter de la clave para la columna 2 podría ser 'l'.
    El caracter de la clave para la columna 3 podría ser 'e'.
    El caracter de la clave para la columna 4 podría ser 'c'.
    El caracter de la clave para la columna 5 podría ser 't'.
    El caracter de la clave para la columna 6 podría ser 'r'.
    El caracter de la clave para la columna 7 podría ser 'o'.
    El caracter de la clave para la columna 8 podría ser 'n'.
    El caracter de la clave para la columna 9 podría ser 'i'.
    El caracter de la clave para la columna 10 podría ser 'c'.
    El caracter de la clave para la columna 11 podría ser '4'.
    
    Clave encontrada: 3lectronic4

Así hemos roto el cifrado. En el programa se asume que el carácter más abundante en el texto plano es el espacio. También he asumido que la clave consta sólo de caracteres alfanuméricos, con algunas verificaciones adicionales se puede saltar esta restricción. Os dejo las herramientas y unos archivos para probar [aquí]({{page.assets | relative_url}}/xor_frecs.zip). Hay un archivo que se llama *cifrado.txt*. Está cifrado usando este método, intentad descifrarlo.

No obstante, hay más herramientas que ilustran este mismo método para romper un cifrado XOR, por ejemplo [CyptoTool](http://www.cryptool.org/). Si os interesa el tema, encontrad un rato para leer [Applied Cryptography](http://www.schneier.com/book-applied.html) de Bruce Schneier.

Como nota adicional, no penséis que todos los cifrados basados en xor son débiles por naturaleza, sólo los que cifran en flujo de datos. Esta operación se utiliza habitualmente como parte de [cifradores en bloque](http://es.wikipedia.org/wiki/Cifrado_por_bloques).
