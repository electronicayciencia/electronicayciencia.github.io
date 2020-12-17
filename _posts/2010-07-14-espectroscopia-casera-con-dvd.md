---
assets: /assets/2010/07/espectroscopia-casera-con-dvd
featured: 'true'
image: /assets/2010/07/espectroscopia-casera-con-dvd/img/Imagen065_2.jpg
layout: post
tags:
- Experimentos
- Fisica
- Sonido
- Optica
- Reciclaje
title: Espectroscopía casera con DVD
---

En [otra entrada anterior]({{site.baseurl}}{% post_url 2010-07-07-difraccion-en-un-dvd %}) habíamos explicado que un DVD o un CDROM se comportan como una red de difracción. También habíamos calculado el número de líneas y los ángulos para hacer la observación. En esta segunda parte lo aplicaremos para observar los espectros de una luz de **sodio a alta presión** (HPS o High Pressure Sodium) y una lámpara fluorescente de bajo consumo de **mercurio**.

Hay algunas condiciones que debemos cumplir para que las observaciones salgan mejor:

- Lo primero de todo, las observaciones salen mejor cuando se trata de una **fuente puntual**. Un foco extenso sólo producirá borrones en lugar de líneas.
- Los **rayos** deben llegar **paralelos**. Para minimizar los artefactos de la y las lineas espurias de la difracción. En el laboratorio utilizaríamos un colimador, en casa conseguimos lo mismo al observar una fuente muy lejana, como por ejemplo una farola.
- Limitar la entrada. En la línea de lo anterior, es muy conveniente tener una **ranura** por donde entran los rayos de luz. Mientras más fina más definido el espectro, pero también menos intenso. Si es muy fina podría darse dispersión y empeorar la condición anterior. Los rayos ya no serían paralelos y el espectro se vuelve borroso. Por lo tanto hay un límite en cómo de estrechas podemos hacer las líneas.
- La **fuente** debe ser **única**. Parece que no hace falta decirlo. Si tenemos otras luches a la entrada o alrededor veremos los espectros solapados y nada nítidos. Por extraño que parezca, en casa esto es de lo más complicado de conseguir, por los reflejos en los cristales o las paredes que meten ruido en la observación. Incluso con una farola hay reflejos en edificios cercanos. Por eso lo mejor es limitar la entrada con una ranura.

Ver las líneas espectrales de una luz valiéndose de un CD es muy fácil y no tiene ningún misterio. Conseguir fotografiarlo ya es más complicado y se necesita bastante paciencia. Hay mucha gente que ha echo experimentos y los ha subido, esta es una buena página: [http://ioannis.virtualcomposer2000.com/spectroscope/toyspectroscope.html](http://ioannis.virtualcomposer2000.com/spectroscope/toyspectroscope.html)

## Análisis por ordenador

Hemos obtenido la foto de un espectro interesante, por ejemplo este

{% include image.html size="small" file="Imagen065_2.jpg" caption="" %}

Ni que decir tiene que **los colores** de la imagen **son aproximados** ya que tanto la cámara como el monitor trabajan con valores de Rojo-Verde-Azul y algunas frecuencias (colores) quedan fuera de su alcance y no se pueden reproducir.

Ahora lo que me gustaría es tenerlo en un gráfico, de Intensidad frente a longitud de onda. Lamentablemente nunca podremos hacer eso con un montaje precario, porque para saber la intensidad necesitamos medir y compensar la respuesta del CCD de la cámara. Y puesto que es la del móvil, no tenemos tales datos. Para la longitud de onda necesitaríamos medir los ángulos de una manera precisa, y tampoco tenemos esa información en la imagen. Si supiéramos el ángulo exacto no tendríamos más que aplicar la transformación que hay en este gráfico:

{% include image.html size="" file="angulo.png" caption="" %}

Obtenido con [esta hoja de datos](https://spreadsheets.google.com/ccc?key=0AjHcMU3xvtO8dHBpdHdWQ3BNWU54MkY5bzlBTzVkQXc&amp;hl=es&amp;authkey=CIjFp_UF). Así que de momento a lo máximo que podemos optar es a un gráfico *Intensidad* - *Píxel* y eso haremos.

Suponiendo que tenemos un espectro como el de antes, queremos una sección transversal de la imagen, o sea coger la linea central por ejemplo, y obtener su intensidad luminosa en cada píxel. Eso nos lo hace [http://rsb.info.nih.gov/ij/](http://rsb.info.nih.gov/ij/), que es una herramienta en java para manipulación de imágenes online. Muy útil. Lo que ocurre es que yo quería más cosas.

Yo quiero procesar varias líneas de cada imagen (no sólo la línea central. Hay espectros que por el centro están sobreexpuestos y se ven mejor en los bordes. Quiero hacerlo con varias imágenes y dejar el resultado en un fichero. Finalmente me gustaría que el gráfico estuviera superpuesto al espectro, en parte porque queda bonito, y en parte porque al carecer de la longitud de onda me tengo que guiar por el color. Por cierto que esto de dejarse guiar por el color no es del todo buena idea porque las cámaras digitales suelen alterarlos (por una cosa que se llama [balance de blancos](http://es.wikipedia.org/wiki/Balance_de_blancos)), así que si en la vuestra se puede desactivar mucho mejor.

Para todo eso he programado un breve programa en C que:

- Usando la librería *libjpeg* extrae la linea que se le diga (por defecto la línea media).
- Extrae las N líneas adyacentes que se pidan y calcula la media. Por ejemplo puede servir para suavizar el gráfico. Además este efecto se acentúa al ser concéntricas las líneas espectrales. Sirve para eliminar ruido del CCD en las zonas oscuras, como contrapunto ensancha las líneas y vuelve borroso el espectro.
- Con los tonos de color obtenidos genera una imagen en formato AVS para graficarla con Gnuplot. El formato AVS de imágenes es de los más sencillos que hay. Documentado aquí en dos párrafos: [http://local.wasp.uwa.edu.au/~pbourke/dataformats/avs_x/](http://local.wasp.uwa.edu.au/%7Epbourke/dataformats/avs_x/)
- Si la imagen es en color calcula la intensidad total usando una media cuadrática. Hay multitud de maneras de convertir una imagen a escala de grises, esta es la que mejor resultado me ha dado para las imágenes que tengo. Lo malo es que no incorpora ningún tipo de ponderación de colores.
- Escribe un archivo con la intensidad luminosa calculada por cada píxel.
- Escribe un archivo con los comandos de Gnuplot necesarios para hacer el gráfico.
- Y finalmente ejecuta Gnuplot para generar una imagen PNG con todos los elementos. Con una versión antigua de Gnuplot las líneas quedan muy ásperas porque *libgd* no soporta antialias. Así que he usado el terminal tipo *pngcairo* que incorpora Gnuplot 4.4.

El resultado me encanta. Aquí abajo tenéis por ejemplo el gráfico de un tubo fluorescente de espectro ensanchado. A decir verdad no sé interpretar casi ninguna línea. Pero podéis ver el doblete amarillo del mercurio por ejemplo.

{% include image.html size="big" file="Fluorescente.jpg_esp_150_1.png" caption="" %}

## ¿Sodio o mercurio?

Teniendo la longitud de onda de una linea dada podríamos ir a la [base de datos del NIST](http://www.nist.gov/physlab/data/atomspec.cfm) a mirar de qué elemento podría ser. Pero como esa información no la tenemos no podemos analizar nada, y nos limitaremos a interpretar lo que vemos en base a espectro que conocemos. Como por ejemplo el del mercurio.

He aquí la luz que proporciona una lámpara de bajo consumo (varía según marca y modelo).

{% include image.html size="big" file="Imagen188.jpg_esp.png" caption="" %}

Fijaos en el doblete amarillo que se distingue fácilmente. Es del mercurio y está formado por dos líneas en 576.9nm y 579nm. Además de este se ven varias líneas más que también parecen compuestas.

Cuando vemos un doblete en el amarillo es tentador pensar que estamos resolviendo el doblete de la **línea D del sodio**. Pero no es el caso, primero porque estamos observando una lámpara de mercurio, no de sodio, y aunque podría contener trazas no darían unas líneas tan intensas. Sin embargo hay otra forma de verlo, mirad la imagen original:

{% include image.html size="small" file="Imagen188.jpg" caption="" %}

El espectro anterior está calculado en la línea media, así que vamos a suponer que el ancho total es de 320 pixeles (que es el ancho de la imagen). Habíamos dicho en la [primera parte]({{site.baseurl}}{% post_url 2010-07-07-difraccion-en-un-dvd %}) que la anchura en grados del segundo orden de difracción es de 60. Tenemos 320 pixeles para reproducir 60º de espectro. Mirad la posición y separación de las lineas del doblete del mercurio y del sodio:

{% include image.html size="" file="dobletes.png" caption="" %}

Por una simple regla de tres al mirar el doblete del **sodio**, que está separado 0.14º, la separación entre los máximos de las líneas sería de

$$
\Delta = \frac{320 \times 0.14}{60} = 0.75
$$

es decir, los máximos están separados por **menos de un píxel**. Así que los veremos como uno sólo. La resolución que tenemos no es suficiente. Sin embargo la separación de las líneas del doblete amarillo del **mercurio** es de 0.40º, y su intensidad es mucho más débil (no se presenta el problema de la sobreexposición que ensancharía las líneas y las solaparía). La separación en las imágenes es de

$$
\Delta = \frac{320 \times 0.40}{60} = 2.13
$$

algo más de 2 pixeles. Ese sí que podríamos verlo y de hecho es el que vemos en la imagen.

Ahora mirad este otro espectro, de una luz de sodio a alta presión. La banda negra que veis en la zona naranja es una banda de absorción del sodio -con la alta presión se da un fenómeno de auto absorción, y la línea D en lugar de radiarse se retiene-. El caso es que no es una absorción limpia con un mínimo en el centro, sino que en el centro tiene un pequeño máximo. ¡Ahí tenemos el **doblete D del sodio**! Estamos viendo que la absorción no es de una única línea sino que se compone de dos separadas. Hemos tenido que recurrir a verlo en absorción porque los medios que tenemos no son suficientes para verlo en emisión. Con un ancho de la imagen original de 480px, la separación sería de 1.12 pixeles, algo más si tenemos en cuenta que lo que se ve en esa imagen no es el espectro visible completo de 60º, sino sólo una parte.

{% include image.html size="big" file="Imagen057.jpg_esp_400_1.png" caption="" %}

En esta otra imagen de la lámpara de mercurio he quitado el zoom y se ve el comienzo del tercer orden de difracción. Fijaos como las dos líneas violetas están más separadas a la derecha de la imagen que a la izquierda.

{% include image.html size="big" file="Imagen172.jpg_esp_400_1.png" caption="" %}

Y hasta aquí podemos llegar sin recurrir a apoyos ópticos como un ocular o un colimador. Y sin un montaje fijo que nos permita medir ángulos con precisión y situar la cámara en el punto adecuado. Hay muchos más tipos de lámparas, la próxima vez que la grabadora os estropee un DVD ya sabéis algo que probar. Tenéis más información así como espectros comentados en [http://ioannis.virtualcomposer2000.com/spectroscope/](http://ioannis.virtualcomposer2000.com/spectroscope/) o en [http://www.astrosurf.com/~buil/us/spe2/hresol4.htm](http://www.astrosurf.com/%7Ebuil/us/spe2/hresol4.htm).

Como siempre, os dejo las imágenes, los espectros así como el código fuente del programa [en esta dirección]({{page.assets | relative_url}}/espectroDVD.rar). El programa en C está bastante liado, no es un buen ejemplo de programación, aún así tal vez os resulte útil para vuestras pruebas.
