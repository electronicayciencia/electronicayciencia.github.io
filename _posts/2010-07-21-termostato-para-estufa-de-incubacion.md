---
assets: /assets/2010/07/termostato-para-estufa-de-incubacion
image: /assets/2010/07/termostato-para-estufa-de-incubacion/img/esquema.png
layout: post
tags:
- Circuitos
- Sensores
title: Termostato para estufa de incubación casera
---

Este sencillo proyecto es ideal para quienes quieran ver con un ejemplo el funcionamiento básico de un comparador, de un sensor de temperatura y de un triac. Se trata de un termostato muy preciso capaz de regular una temperatura de entre 27 y 40 grados centígrados. Apto para regular una estufa de cultivo casera.

Un inciso rápido para los profanos: para observar colonias de bacterias, estas se depositan en una placa con gelatina y se cultivan cuales plantas. Para que crezcan se necesita una temperatura estable entre 35 y 38 grados más o menos; si baja crecen muy lentamente, y si sube se asan. El objetivo es obtener 37ºC estabilizados.

Hay varias formas de hacer una estufa casera, yo opté por lo fácil: coger una yogurtera vieja y aplicarle un termostato que la encienda y la apague cuando sea necesario. Hay quien lo hace con una caja aislante (de corcho o madera) y un lámpara incandescente, es un buen método, pero a menudo las colonias crecen mejor a oscuras. He visto proyectos hasta con un secador, es muy buena idea, una fuente de calor con un ventilador que lo distribuye.

Aunque como digo me quedo con la yogurtera. Otra opción es aprovechar la resistencia de nicrom de un brasero que no se use. La fuente de calor va al gusto del experimentador, yo aporto el termostato.

## Análisis del circuito

{% include image.html size="big" file="esquema.png" caption="" %}

El componente principal es un sensor del tipo [LM35](http://www.national.com/ds/LM/LM35.pdf). La salida de este integrado es proporcional a la temperatura (exactamente 10mV por cada grado centígrado). De forma que a 20ºC su salida es de 200mV, a 25ºC es 250mV y a 30ºC da 300mV. No se ve en el esquema de arriba. Va conectado al conector SL1 siendo sus pines 1, 2 y 3 el terminal positivo, el de salida y el negativo respectivamente. El zener que veis marcado como VR1 es un LM431 y tal como está proporciona una tensión constante de 2.5V, es mejor que uséis un zener normal, yo era lo que tenía a mano en ese momento.

La resistencias R2A, R2B, R3 y R4 forman un divisor de tensión. Normalmente el valor resultante a la salida del R3 dependería de la tensión de alimentación, pero R1 y VR1 nos aseguran que **el divisor siempre va a estar a 2.5V**, independientemente de que alimentemos el circuito con una pila o un transformador. El separar R2 en 2 es por aproximar mejor el valor necesario.

Cuando la temperatura (tensión en la entrada -) es mayor de la seleccionada (tensión en la entrada +) la salida del comparador cae a 0V. Desactivando el optotriac y cortando la corriente de la estufa. Cuando la temperatura vuelve a estar por debajo el comparador conmuta su salida, activa el LED indicador y el LED del optotriac. Este a su vez dispara el triac que proporciona corriente a la fuente de calor.

No hemos usado ningún tipo de histéresis en el comparador, ya que lo que pretendemos no es tener un rango sino una temperatura fija. Además el optotriac que hemos usado incorpora detección de cruce por cero, y sólo se disparará en la parte baja del ciclo de alterna.

Debido a que no hemos amplificado la salida del LM35 trabajamos con tensiones del orden de mV. No es del todo recomendable trabajar con tensiones tan bajas, pues una mínima interferencia puede activar o desactivar momentáneamente el termostato, pero en este caso prima la sencillez del circuito.

## Cálculo de los componentes

Lo más importante es calcular R2, R3 y R4 pues de su valor depende el rango de temperaturas de trabajo. Yo lo he calculado para darle un rango entre 27 y 40ºC. [En esta hoja](https://spreadsheets.google.com/ccc?key=0AjHcMU3xvtO8dEFpQmhOdmNndjVqWllBcHA2NnZTQXc&amp;hl=es&amp;authkey=CKPH-dII) tenéis los cálculos. Los valores en negrita son introducidos manualmente, los que están en letra normal son calculados.

Calculamos R1 a partir de la tensión de alimentación para que por el zener circulen como mínimo 5mA. Despreciamos la corriente que absorbe el sensor. Tened cuidado con la tensión del zener que uséis, que esté dentro del margen de alimentación del LM35. Necesitaríamos 1530 ohm, como el valor no es crítico usaremos 1k. Con ese valor nos da 7.65mA, es aceptable.

Lo primero es medir R3. Es un potenciómetro de 10k, que una vez medido resulta ser de 10400ohm. R2 y R4 se calculan atendiendo a la tensión zener y al rango que se pida. Después se ajustan a los valores estándar de mercado más próximos y se recalcula el rango de temperaturas. Más tarde conviene medir con un téster la tensión en la patilla 3 de IC1 porque debido a la tolerancia de las resistencias se va a desviar de los cálculos. Tendréis que jugar un poco con R2B hasta ajustar el rango deseado.

Tras los cálculos los valores quedan:

- **R1** 1kΩ
- **R2A+R2B** 153kΩ
- **R3** 10400Ω
- **R4** 18000Ω
- **R6** 470Ω
- **R7** 1kΩ
- **R8** 220Ω

El triac BT137 soporta hasta 8A, que a 220V son 1700W. Es más que suficiente, pero si vuestra estufa es más potente usad otro.

## Montaje

Aunque más abajo os dejo los archivos de Eagle del diseño y un PDF esta sería una imagen del circuito con y sin los componentes:

{% include image.html size="small" file="placa_pistas.png" caption="" %}

{% include image.html size="small" file="placa_comp.png" caption="" %}

No he previsto fuente de alimentación. Podéis usar una pila de 9V como dice el esquema, pero no os lo recomiendo porque se supone que se va a usar durante varias horas o días seguidos. Así que lo mejor es utilizar un transformador viejo, por ejemplo de un móvil que ya no uséis. Otra opción es diseñar una fuente de alimentación externa. Si quitáis el led y sustituís el optotriac por un modelo tipo MOC3043 (que necesita sólo 5mA para dispararse en lugar de los 15mA que necesita el 3041) el circuito consume tan poquito que se puede alimentar con una fuente sin transformador.

Este montaje se intercala en serie con el cable de alimentación de la estufa.

Os adjunto una carátula de ejemplo para montarlo en una caja de registro cuadrada. Está en formato png y en formato vectorial eps.

{% include image.html size="small" file="caratula_limpia.png" caption="" %}

Como siempre, os dejo los archivos [aquí]({{page.assets | relative_url}}/Termostato_incubacion.rar).
