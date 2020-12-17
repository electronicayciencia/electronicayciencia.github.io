---
assets: /assets/2010/05/mando-de-un-coche-teledirigido
image: /assets/2010/05/mando-de-un-coche-teledirigido/img/circuito.png
layout: post
tags:
- Circuitos
- Radio
- Reciclaje
title: Mando de un coche teledirigido
---

Hoy tenemos un transmisor de un coche teledirigido muy básico. Tiene dos botones, es el clásico *avanza / gira mientras retrocede*. En una [entrada anterior]({{site.baseurl}}{% post_url 2010-04-30-obtener-el-esquema-desde-una-placa-de %}) obtuvimos el esquema desde la placa. Ahora, como prometimos, lo analizaremos para saber cómo funciona.

**Actualización:** En esta entrada hablo sobre el transmisor. Si quieres saber cómo funciona el receptor ve a [esta otra entrada.]({{site.baseurl}}{% post_url 2010-09-15-receptor-coche-rc-de-dos-canales %})

{% include image.html size="" file="circuito.png" caption="" %}

El circuito consta de dos partes. Un [oscilador astable]({{site.baseurl}}{% post_url 2010-04-27-multivibrador-astable-transistores %}) de BF, y un [oscilador *Pierce*](http://pr.erau.edu/%7Elyallj/ee412/pierce_exp.html) con un cristal de 27.145MHz como emisor de RF.

<!--more-->

## Baja frecuencia

Empezaremos hablando de la etapa de audio, o de baja frecuencia. Está compuesta por un sencillo oscilador astable con los transistores PNP Q2 y Q3. Similar al que estudiamos en la entrada que enlazo arriba. Aunque este tiene algunos elementos particulares.

- Las resistencias **R7** y **R8** están en paralelo con los condensadores de 470nF que determinan la frecuencia de oscilación del astable. Se utilizan para que que el pico de tensión inversa de los condensadores no fría por avalancha la unión BE en los transistores. De lo contrario, como ésta es de -5V (ver el datasheet), no podríamos alimentar el circuito con 9V.
- La resistencia **R10**, en el emisor de Q3, introduce una asimetría y asegura que el circuito siempre comience a oscilar y no quede en un estado estable.
- La resistencia **R8** y el diodo **D1** tienen el siguiente cometido: El mando tiene dos botones (A y B). Para avanzar y retroceder. El positivo de alimentación siempre está conectado, el negativo en cambio depende del botón que pulsemos. Cuando pulsamos el **botón A**, se conecta el negativo la pista de masa y alimenta a todas las partes del circuito; la resistencia R9 limita la corriente en serie con las resistencias de las bases R5 y R6. No obstante, cuando pulsamos el segundo **botón B** el negativo se conecta a donde pone Vss, puenteando R9;  el resto del circuito se alimenta a través de D1. El efecto de puentear R9 es que aumenta la frecuencia y pasa de 310Hz a 1025Hz. Así el receptor puede saber qué botón se ha pulsado.
- **C8** y **L2** forman un filtro paso bajo que separa el oscilador de Baja Frecuencia y el de RF. Permite el paso de la oscilación de 310Hz o 1025Hz pero impide que la alta frecuencia de 27MHz se propague hacia atrás.

## Alta frecuencia

Q1 está conectado como un oscilador *Pierce*. Este tipo de oscilador se caracteriza porque necesita muy pocos componentes y, al utilizar un cristal de cuarzo, es muy estable. Es frecuente encontrarlo en este tipo de circuitos de bajo coste.

El cristal de cuarzo está tallado para resonar en **27.145MHz**. Es habitual en este tipo de mandos emitir en la banda de [CB](http://www.cb27.com/). Por suerte además de tener poca potencia, esa frecuencia concreta no corresponde a ningún canal sino que está entre medias de dos canales. Aún así ni el diseño del circuito transmisor cuida reducir las interferencias a canales adyacentes, ni el receptor del coche mira por la selectividad. Por lo que la mañana de Reyes en enero es muy *entretenida* para radioaficionados y niños.

Como la oscilación depende de que haya tensión positiva en el colector de Q1, sólo oscilará cuando Q2 esté activo. Esto produce una portadora intermitente de 27.145MHz con una frecuencia igual a la frecuencia de oscilación de Q1 y Q2. Para un receptor AM es similar a encontrar una portadora continua, modulada por una señal cuadrada de su misma amplitud. Y esto es precisamente lo que escuchamos en un receptor. Os incluyo los archivos de sonido.

La salida del oscilador pasa a través de C3 que filtrará la componente continua. C2, L1 y C1 forman un filtro pasabajos para atenuar las frecuencias espurias de la modulación, así como los armónicos generados por Q1. L1 está formada por 16 espiras de hilo de 0.4mm sobre un soporte de 7mm de diámetro provisto de núcleo de ferrita ajustable. Ya el hecho de que esté sellado con cera nos indica que es importante efectuar un buen ajuste para maximizar potencia a la frecuencia que queremos mientras eliminamos las indeseadas.

Como de costumbre os dejo los archivos utilizados en esta entrada [aquí]({{page.assets | relative_url}}/mandobao.rar).
