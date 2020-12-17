---
assets: /assets/2010/03/caracteristica-i-v-de-una-bombilla
image: /assets/2010/03/caracteristica-i-v-de-una-bombilla/img/grafico_IV_1.png
layout: post
tags:
- Fisica
- Optica
title: Característica V/I de una bombilla
---

De todos es sabido que si medimos la resistencia de una bombilla apagada, no obtenemos la resistencia verdadera que ofrece estando encendida. Por el mero hecho de que cuando un material se calienta, su resistencia eléctrica aumenta.

Esto se debe a un aumento de la sección eficaz de los portadores de carga, porque con el aumento de la temperatura, aumenta la magnitud de las oscilaciones en torno a su posición de equilibro. Es un efecto físico curioso, más curioso aún cuando se trata de semiconductores -en los que bajo condiciones adecuadas, puede darse al contrario-. Os animo a que le dediquéis alguna búsqueda en Google.

El enfoque de esta entrada es más pragmático. Para cierto proyecto del que hablaré más adelante en este blog (nombre en clave DimmerIR) necesito caracterizar una bombilla y saber qué potencia da en función de la tensión recibida. Se define la potencia como $P = VI$ , para una resistencia tenemos la conocida expresión $P = VI = \frac{V^2}{R}$ . Para una bombilla la cosa se complica pues a pesar de ser una resistencia $R = R(T) = R(I,V)$ . Es decir que la resistencia varía con la temperatura, que a su vez es función de la intensidad aplicada.

Como todas estas relaciones son no-lineales, lo más fácil es obtener la relación entre V e I de manera empírica. Simplemente tomando un reóstato, un autotransformador, o un atenuador electrónico a TRIAC (teniendo la precaución en este último caso de usar un tester *True RMS* pues la forma de onda deja de ser sinusoidal). Medimos la tensión en extremos de la bombilla y la intensidad que circula. Ahora dividiendo obtenemos el valor de la resistencia, y lo podemos graficar.

{% include image.html size="medium" file="grafico_IV_1.png" caption="" %}

Como ya habíamos previsto, la resistencia no se mantiene constante y es **siempre creciente**.

La resistencia a 0 voltios no es más que la resistencia a temperatura ambiente: 62.8 ohmios. La región menos lineal es la marcada con un **tono naranja**. Aquí el filamento aún no está incandescente o tiene muy poca temperatura.

La intensidad circulante con 220V es de 264mA, lo que equivale a una resistencia máxima de 833.3 ohmios. Esto nos da una potencia máxima de 58.8 vatios. Tiene sentido, pues la bombilla dice ser de 60w.

¿A qué temperatura debe estár el filamento para ofrecer tal resistencia? Hay una ecuación aproximada que nos permite calcular ese dato dependiendo del material. En este caso tungsteno:

$$
R_f = R_0 \cdot [1+\alpha (T_f-T_0)] \mbox{ con } \alpha = 0.0045
$$

Sustituyendo los valores obtenemos 3191ºC. La temperatura de fusión del tungsteno es 3422ºC.

Si nos concentramos en la zona a partir de los 80 voltios la característica se puede parecer a una recta.

{% include image.html size="medium" file="grafico_IV_2.png" caption="" %}

El coeficiente de ajuste no es muy bueno, pero no necesito demasiada exactitud y me conviene tener una expresión analítica lo más sencilla posible. Por tanto, haciendo un **abuso de la aproximación** podemos considerar que la resistencia aumenta de manera directamente proporcional a la tensión que se le aplique. Esto no es cierto, si bien es más aproximado que considerar la resistencia constante, cosa que sería completamente errónea.

Del ajuste lineal obtenemos los parámetros de la recta que mejor se aproxima a nuestros datos:

$$
R = 2.93V+193
$$

Y de ahí ya podemos obtener la potencia:

$$
P = VI = VI(V) = \frac{V^2}{R(V)} = \frac{V^2}{2.93V+193}
$$

Fijaos en la V en el denominador. Es más importante de lo que parece porque hemos pasado de una expresión de la potencia que varía con V al cuadrado, a otra aproximada que varía casi linealmente con V.

He dejado el archivo con las medidas [aquí]({{page.assets | relative_url}}/bombilla_V-I.dat).
