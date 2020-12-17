---
assets: /assets/2010/03/valor-eficaz-de-una-sinusoidal
image: /assets/2010/03/valor-eficaz-de-una-sinusoidal/img/forward_phase.png
layout: post
tags:
- Fisica
- Matemáticas
- Sonido
title: Valor eficaz de una sinusoidal incompleta
---

Continuamos con el proyecto *DimmerIR*. La intención como ya habéis supuesto es diseñar un atenuador electrónico. La caracterizacíon que hicimos de una bombilla incandescente en una [entrada anterior]({{site.baseurl}}{% post_url 2010-03-27-caracteristica-i-v-de-una-bombilla %}) nos servirá para calcular la potencia a partir del valor eficaz. Ahora vamos a perfilar cómo cambia el valor eficaz dependiendo de la fase del disparo.

Voy a usar un TRIAC para sólo dejar pasar parte de cada semiciclo, la forma de onda que recibe la bombilla es así:

{% include image.html size="small" file="forward_phase.png" caption="" %}

Debido a los cambios bruscos de tensión, esta forma de atenuación sólo sirve para cargas resistivas. Olvidaros de conectar una bombilla de bajo consumo.

Necesitamos saber cómo cambia la tensión según disparemos el TRIAC antes o después. Se define el *valor eficaz* de una corriente alterna como la tensión que tendría que tener una corriente continua para provocar el mismo efecto Joule. Lo que queremos saber ahora es cuánto vale este dependiendo de la porción del periodo que cortemos.

Una definición más formal nos va a permitir calcularlo, se demuestra que el valor eficaz es lo mismo que el valor RMS. Durante un periodo de duración T, que por simplicidad supondremos que empieza en 0:

$$
V_{RMS} = \sqrt{\frac{1}{T} \int_0^T V^2(t) dt}
$$

Ahora bien, como vemos en la figura $V(t) = V_p \sin(\omega t)$ pero sólo en los intervalos

$$
\tau < t \leq \frac{T}{2} \quad \mbox{y} \quad \frac{T}{2}+\tau < t \leq T
$$

Donde, además, tiene el mismo valor sólo que cambiado de signo. Dado que va al cuadrado dentro de la integral, consideramos que en ambos semiciclos la integral vale lo mismo. Eso nos permite integrar para un único intervalo:

$$
V_{RMS}(\tau) = V_p \sqrt{\frac{2}{T} \int_\tau^\frac{T}{2} \sin^2(\omega T) dt}
$$

con

$$
0 \leq \tau \leq {T \over 2}
$$

Empleamos que $\sin^2(\omega t) = \frac{1-\cos(2\omega t)}{2\omega}$ e integramos:

$$
V_{RMS}(\tau) = V_p \sqrt{{ "{{" }}1 \over T} \left[ t - \frac{\sin(2\omega t)}{2\omega} \right]_\tau^{T/2}}
$$

Tras operar, teniendo en cuenta que $\omega = {2\pi \over T}$ obtenemos:

$$
V_{RMS}(\tau) = {1 \over 2} - {\tau \over T} + \frac{\sin \left(4 \pi{\tau \over T}\right)}{4\pi}
$$

El siguiente gráfico muestra cómo varía el valor eficaz de una corriente alterna dependiendo de en qué parte del semiciclo disparemos el TRIAC.

{% include image.html size="big" file="tensionrelativa.png" caption="" %}

Como era de esperar, si lo disparamos en 0, la onda llega completa y tenemos el 100% del valor nominal (serían 220V). A medida que cortamos más baja la potencia que llega a cero si nos esperamos al final para disparar el TRIAC. En este caso cortamos el total del semiciclo.

Esta es la razón de que la mayoría de los dimmers comerciales sean poco lineales, y varíen más rápidamente la luminosidad al principio del recorrido y menos hacia el final.

Para las formulas he utilizado este [previsualizador de LaTeX](http://www.tlhiv.org/ltxpreview/).
