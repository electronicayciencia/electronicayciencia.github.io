---
assets: /assets/2010/07/difraccion-en-un-dvd
image: /assets/2010/07/difraccion-en-un-dvd/img/Imagen095.jpg
layout: post
tags:
- Fisica
- Matemáticas
- Optica
title: Difraccion en un DVD
---

Todos sabemos que un DVD o un CD presentan iridiscencia cuando se miran bajo un foco de luz. La información de un DVD se guarda en un surco de anchura micrométrica que recorre el disco en espiral. En un milímetro a lo largo del eje central puede haber más de 1000 surcos. Eso le da al DVD las propiedades de una **[red de difracción](http://en.wikipedia.org/wiki/Diffraction_grating)**. No explicaré cómo funciona una red o sus propiedades, hay información de sobra por ahí. Básicamente, debido a interferencias múltiples, cada longitud de onda de las que componen la luz blanca se refleja con un ángulo distinto, así que la luz incidente se descompone en colores. Eso se puede aprovechar para hacer un espectroscopio casero con un DVD o con un CD.

El parámetro más importante de una red de difracción es su densidad de líneas, expresada en **líneas por milímetro**. O también nos puede servir la separación entre cada surco. Vamos a medir este parámetro en un DVD para usarlo más adelante como elemento difractor en un **espectroscopio** casero básico.

Para medir cuántas líneas por milímetro tiene un DVD hacemos un sencillo montaje. Este es un experimento que hice la semana pasada, en lo que tardaba en beberme una cervecita con la música de [Saratoga](http://www.youtube.com/watch?v=0WEAotCoFqU) o [Tierra Santa](http://www.youtube.com/watch?v=V_sfOjTf86s).

## Medir el número de líneas

El método consiste hacer el montaje en el suelo o en una mesa baja y señalar los rayos. Después sacar una foto y medir los ángulos en el PC.

Lo primero que necesitamos es un trozo de DVD. Así que cortamos un trapecio circular para que sea más cómodo. Quitaremos el aluminio que recubre la superficie y nos quedaremos sólo con el plástico semitransparente. Para levantar el aluminio usad cinta aislante, pero tened cuidado de **no rallarlo**. Ahora tenemos una red de difracción de transmisión y de reflexión. Dibujad con cuidado varios radios desde el centro, nos servirán para orientar mejor la placa.

Si apuntamos un puntero láser contra este trozo de plástico se refleja en varios puntos por la pared. Nos interesa anotar esas reflexiones. Para eso vamos a utilizar un método muy *de andar por casa* pero que da muy buenos resultados si se hace con cuidado.

En primer lugar sujetamos el trozo de DVD de forma **perpendicular al suelo**, con el radio paralelo al suelo. La plastilina es muy útil, pero si no tenéis usad cinta aislante o -en mi caso- una pinza de la ropa. Da igual, se trata de que no se mueva. Por facilidad, uno de los radios que habéis dibujado antes debe quedar horizontal. Después explico por qué.

Tomad un puntero láser y apuntadlo a la **misma altura** que el radio que está horizontal. Yo en esta ocasión he usado un mazo de cartas que es una base fácilmente regulable en altura. El motivo de hacer esto es que las reflexiones y refracciones van a suceder siguiendo el plano de este radio (primera ley de la reflexión). Si no es horizontal el plano se inclina y algunos rayos se proyectarán hacia el suelo y otros en las paredes. Al asegurarnos un plano horizontal todos los rayos tienen la misma altura. Si en vez de circular tuviéramos una red de difracción recta, la cosa sería más fácil.

Para hacer los testigos, o banderas, o **soldaditos** si tenéis plastilina pues adelante con ella. Si no tomad unos trozos finos de papel y doblados por la base para que se tengan de pie.

Ahora con el láser apuntando a la placa, localizad el rayo reflejado y colocad todo para que el reflejo impacte de nuevo contra el puntero. Con eso nos aseguramos que el ángulo de incidencia es 0. Sin mover el láser ni la placa id colocando los testigos de forma que todos los rayos **reflejados y difractados** impacten contra ellos. Será la forma de señalar las posiciones para cuando apaguemos el láser y hagamos la foto.

Una vez situados los *soldaditos* le sacaremos una foto desde arriba. Importante que sea lo más vertical posible y centrada en la placa de DVD. Así los ángulos no se deforman con la perspectiva ni con la óptica de la cámara por mala que sea. El resultado es una foto así, fijaos que **el trozo de DVD no se ve** porque está completamente *de canto*:

{% include image.html size="" file="Imagen095.jpg" caption="" %}

La luz incide por la derecha (centro). A la izquierda está el rayo transmitido. El rayo reflejado no se ve porque hemos hecho que **coincida con el incidente**. A ambos lados del rayo principal veis los difractados. Estos provienen del **primer oden de difracción** tanto transmitida (izquierda) como reflejada (derecha). Con este ángulo de incidencia el segundo orden no aparece. Para que se vea más claro he hecho un esquema de la imagen:

{% include image.html size="" file="esq_img095.png" caption="" %}

Medir ángulos sobre la imagen es fácil. Sólo tenéis que unir los puntos dos a dos para obtener el centro. Y a partir de ahí cualquier programa de dibujo como GIMP os permite medir ángulos. Yo lo he hecho con el Xfig, que es *prehistórico* pero hace muy buenos apaños y me encanta.

Según Xfig el ángulo del primer máximo de difracción es de 62.4º. Hay una ecuación que nos da la posición de los máximos de interferencia, ya la habíamos usado antes en esta [otra entrada]({{site.baseurl}}{% post_url 2010-06-09-escaner-nuevo-y-difraccion %}):

$$
d \left( \sin{\theta_m} - \sin{\theta_i} \right) = m \lambda
$$

- **d** es la separación entre las líneas (pistas del DVD)
- **θ<sub>i</sub>** es el ángulo incidente
- **θ<sub>m</sub>** es el ángulo en el que aparece el máximo de orden m
- **m** es el orden de la difracción, puede valer 0, ±1 ,±2 ...
- **λ** es la longitud de onda de la luz incidente

Sabemos que *θ<sub>i</sub>* es cero, porque para eso hicimos coincidir el rayo reflejado con el incidente. En el esquema de antes *m* sería el -1.El ángulo *θ<sub>-1</sub>* también lo conocemos, es lo que hemos medido 62.4º. Y la longitud de onda de un láser rojo es 650nm. Así que despejando *d*:

$$
d = \frac{1 \times 650}{\sin 62.4} = 0.734 \mu m
$$

Dice el estándar DVD en [este documento]({{page.assets | relative_url}}/Ecma-267.pdf) (página 12) que:

> 10.6.2 Track geometry  
In the Information Zone tracks are constituted by a 360° turn of a spiral.  
The track pitch shall be 0,74 µm ± 0,03 µm.  
**The track pitch averaged over the Data Zone shall be 0,74 µm ± 0,01 µm**.  


Nosotros hemos obtenido 0.734 lo que nos da un **error menor del 1%** (fijaos que es del orden de los 10nm). Y eso con un montaje rudimentario, midiendo solamente un ángulo y sin tener en cuenta el cálculo de errores (propagación). Realmente es una pasada la precisión que se puede alcanzar con un láser.

La conclusión es que un DVD se comporta como una red de difracción de **1360 líneas por milímetro**. No está mal. Para un CD es alrededor de 600.

## Los órdenes superiores

He preparado una hoja de cálculo para este apartado. Está en [este enlace](https://spreadsheets.google.com/ccc?key=0AjHcMU3xvtO8dHBpdHdWQ3BNWU54MkY5bzlBTzVkQXc&amp;hl=es&amp;authkey=CIjFp_UF). Ahora uso el dato de 0.74µm. Con el ángulo incidente 0, totalmente perpendicular tenemos este caso.

{% include image.html size="" file="dvd_0_720.png" caption="" %}

Además del láser hay dos columnas más. Una corresponde a la longitud de onda del rojo y la otra la del violeta. ¿Para qué? Pues para cubrir todo el espectro visible. La captura anterior nos dice que, con el ángulo de incidencia 0, *la difracción en primer orden del espectro visible cubre un ángulo que va desde 77º a los 33º, por tanto tiene una anchura angular de 44º*. Los ángulos se cuentan desde la perpendicular, como en el esquema de antes. No os dejéis despistar por los signos, solamente indican si se cuentan hacia la izquierda o hacia la derecha.

Con 1300 líneas/mm la difracción en primer orden es muy brillante, pero las líneas están poco separadas; la resolución es muy pobre. Para ver algo mejor el espectro recurriremos al segundo o tercer orden. Habrá que variar el ángulo de incidencia. Este es un esquema de lo que obtenemos si situamos el **láser donde estaría el R<sub>1</sub>**.

{% include image.html size="" file="esq_img105.png" caption="" %}

Aparecen máximos de segundo orden. Pero esto es para una longitud de onda de 650nm. Como lo que nos interesa es el espectro visible aún tenemos que decidir qué ángulo es el que más nos conviene.

Veamos esta otra tabla en la que aparece el principio y el final de los dos primeros órdenes en un DVD según variemos el ángulo de incidencia. He tenido que **recortar la zona del rojo** de los 750nm a los 700, para que el segundo orden apareciera completo. La difracción en segundo orden de 750nm no aparece por ser una longitud de onda tan larga, necesitaríamos un ángulo de incidencia mayor de 90º, y eso es imposible.

{% include image.html size="" file="incidencias_dvd.png" caption="" %}

El segundo orden comienza a verse a los 5º, pero sólo las ondas cortas como el violeta. Para ver el espectro hasta el rojo habrá que esperar hasta los 65º. Con un ángulo incidente de 65º ya veríamos el espectro completo en segundo orden. A 80º veríamos el rojo y a 10º el violeta. Pero hay un problema, que a 65º, más o menos a la mitad, tenemos **el propio rayo reflejado** y nos lo jode. Así que no nos vale. Con 85º o 90º ya no pasa esto, el problema es ahora que los rayos llegan demasiado oblicuos y el espectro se ve muy débil.

El ángulo óptimo parece que es 80º.

{% include image.html size="" file="dvd_60gr_700.png" caption="" %}

Sin embargo vemos como el violeta de tercer orden se superpone ya a los 40º. El tercer orden empieza a superponerse a partir de los 460nm. En general no supone un problema pues además de ser mucho más débil, es fácil distinguir por el color las líneas que son producto de la superposición. Nos interesa este segundo orden porque **el ancho (60º) es mayor que el primero (sólo 24º)**. *Nota: el orden 0 no se dispersa.* La cámaras de fotos de los móviles tienen una apertura angular de unos 60º precisamente (es fácil medirlo: dibujad dos puntos en un papel y separad la cámara hasta que los puntos coincidan con los extremos de la pantalla, sabiendo la separación entre los puntos y la distancia del papel a la cámara lo demás es trigonometría).

Para que os hagáis una idea, cuando observamos el espectro de una luz con un DVD realmente estamos haciendo esto (no he dibujado el tercer orden):

{% include image.html size="big" file="dvd.png" caption="" %}

## Con un CD

Como un CD tiene menos líneas por milímetro los números cambian, pero **la ley es la misma**. Así que con las mismas hojas de cálculo que antes obtenemos la posición de los máximos. Por ejemplo cuando el ángulo incidente es 0:

{% include image.html size="" file="cd_0.png" caption="" %}

Poniendo el rayo incidente donde antes estaba el rojo. Vemos hasta el tercer orden completo. Sin bien todos los espectros están superpuestos entre sí.

{% include image.html size="" file="cd_rj_en-1.png" caption="" %}

Y lo que es más importante, es que para obtener la anchura de 60º que teníamos antes con un DVD en segundo orden, con un CD tenemos que recurrir al tercer orden, y será mucho más débil.

En la imagen de abajo veis los rayos que produce un CD. Si os fijáis bien en el mazo de cartas se ve el rayo difractado de tercer orden que debería coincidir con el transmitido (puntero). Aquí lo he desviado un poco para que se vea. Digamos que en lugar de estar a 54º le láser está a 50º respecto a la normal del CD.

{% include image.html size="" file="Imagen128_editada.jpg" caption="" %}

Los ángulos no los he medido, son sólo un ejemplo de lo que sale en la hoja de cálculo si suponemos que el láser está a 50º. Observad siempre el **criterio de signos**.

{% include image.html size="" file="cd_lr_en_2.png" caption="" %}

Más adelante estos cálculos nos servirán para hacer un espectroscopio casero.
