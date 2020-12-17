---
assets: /assets/2010/05/convertir-palabras-en-numeros-ii
image: /assets/2010/05/convertir-palabras-en-numeros-ii/img/lon_pal_es.png
layout: post
tags:
- Estadística
- Matemáticas
title: Convertir palabras en números (II)
---

En la [entrada anterior](http://electronicaycienciadebug.blogspot.com/2010/05/convertir-palabras-en-numeros-i.html) programamos una función para convertir palabras en números entre 0 y 1. Se trata de un simple cambio de base, consideramos cada palabra como un *número* escrito con un conjunto de 27 símbolos *{@ a b c d e f g h i j k l m n o p q r s t u v w x y z}* y cambiábamos la base de numeración para expresarlo como un número decimal en base 10. El resultado es similar a:

    aaaaa... -> 0.11111...>
    zzzzz... -> 0.99999...>

Ahora vamos a jugar con esa conversión, veremos algunas propiedades y obtendremos estadísticas aplicándola a varios idiomas.

<!--more-->

## Ejemplos de cambio de base

Decíamos el otro día que el que un número sea periódico en una base no implica que lo sea en cualquier otra. Esto es consecuencia de que un número racional se puede escribir como una fracción. No ocurre lo mismo con los irracionales. Pi sigue teniendo infinitas cifras no periódicas lo expresemos en la **base entera** que lo expresemos.

Algunos ejemplos:

Hay números exactos tanto en una base como en otra:

    0.235 = fihmqcxs

Hay números simples en base 10 que son periódicos en base 27:

    0.2 = ejup ejup ejup ejup ejup...

Y viceversa:

    c = 0.111111111...

Tenemos números periódicos puros que pasan a ser periodicos mixtos:

ababababababababababa

    0.039 835164 835164 835164...

De da un error de redondeo al truncar el resultado:

    0.111111111111 = bzzzzzzzzdchvb... -> c

Además recordad que exigimos que la '@' detuviera la conversión. Necesitamos esto porque muy pocos resultados van a dar exactos. Ved una prueba:

    ab       = 0.039780522

    ab@cd = 0.039786446

Si ahora convierto 'ab@cd' el resultado se corta a la mitad por la '@':

    0.039786446 = ab

Con esto podríamos sumar y restar palabras tal como si fueran números, calcular su raíz cuadrada, etc. Pero de momento estas operaciones no nos interesan. De utilidad para algún lingüista quizá fuera calcular la entropía de un texto, pero este es un campo que desconozco.

## Analizar un texto

Lo primero que vamos a analizar es una lista de palabras en español. Para eso he fusionado dos diccionarios. Uno es el de Open Office, y otro lo he encontrado buscando en Google, en [este enlace](http://tools.assembla.com/svn/homedevel/devel/ftrie/diccionario.txt). Como curiosidad mirad un histograma con la longitud de las palabras:

{% include image.html size="big" file="lon_pal_es.png" caption="" %}

Los números los podéis ver aquí: [datos originales](http://spreadsheets.google.com/pub?key=tuJhJL6EMffJAALar8b4tUw&amp;single=true&amp;gid=0&amp;output=html). Dicen que las palabras más usuales en español son de cinco letras. Eso es cierto si no contamos los tiempos verbales, plurales y demás derivaciones. A propósito, la palabra más larga (sin contar formas adverbiales terminadas en *mente*) tiene nada menos que 24 letras: **electroencefalografistas**.

El programa *dominio_espectral.pl* está preparado para obtener todas las palabras de un texto y aplicar *pal2num* (la versión optimizada de *pal2num.pl*) para obtener sus equivalentes numéricos entre 0 y 1. A partir de esos resultados dibuja varios gráficos semejantes a espectros de emisión.

Este es el resultado de aplicarlo al diccionario **español** de OpenOffice:

{% include image.html size="huge" file="es_ES.png" caption="" %}

Y este otro gráfico se obtiene cuando lo aplicamos al **inglés** estadounidense:

{% include image.html size="huge" file="en_US.png" caption="" %}

Si os fijáis, todo el rango de la 'W' que está muy presente en la lengua inglesa, no existe en el gráfico castellano. El segundo gráfico que genera el programa es detallado, sin embargo es muy grande para verlo de una pieza con claridad. Voy a comentar el espectro de la lista combinada de la que os hablé antes, os dejo [el enlace]({{page.assets | relative_url}}/esp_grande.png) y a continuación pego algunas partes interesantes:

{% include image.html size="big" file="esp_a.png" caption="" %}

Ved por ejemplo la herencia árabe en nuestra lengua en las palabras que empiezan por *al*. En [esta web](http://www.libreopinion.com/members/jose_marmol/influencia_arabe.htm) hay una lista de palabras castellanas que son de origen árabe y como veis el intervalo 'AL' no tiene huecos en su interior.

{% include image.html size="big" file="esp_p.png" caption="" %}

En esta zona vemos como detrás de una 'P' habitualmente viene una vocal. Salvo contados casos que son *PS*.

{% include image.html size="medium" file="esp_co.png" caption="" %}

Y para terminar, estos son los intervalos que presentan un pico en el espectro. En la 'c' hay gran cantidad de palabras que empiezan por *con* o *com*. Y en la 'd' el pico se debe a *des*. ¿Por qué? Pues porque *con* y *des* son prefijos que combinan con multitud de palabras. Además si abrís el gráfico en grande veréis que no hay apenas palabras en las letras 'k', y al final del abecedario 'v,w, x, y,z'. Estas últimas letras no existía en el abecedario latino, del que procede el español, se incorporaron más tarde y por eso figuran las últimas.

Tened en cuenta que este estudio está hecho sobre una lista de palabras y no refleja el uso diario del idioma. Si analizáramos un texto con sentido habría muchas palabras que se repiten mucho, como las preposiciones o los determinantes. No podemos observar esto en una lista de palabras. No obstante refleja el uso de esta aplicación que convierte palabras en números decimales que era la intención al escribirlo.

Podéis encontrar los archivos relativos a esta entrada [en este enlace]({{page.assets | relative_url}}/pal2num.rar).
