---
assets: /assets/2010/04/control-de-velocidad-por-pwm
image: /assets/2010/04/control-de-velocidad-por-pwm/img/velomtr_sch.png
layout: post
tags:
- Circuitos
- Sonido
title: Control de velocidad por PWM
---

Algo ligero para hoy. Se trata de un control de potencia por Modulación de Anchura de Pulsos (PWM). Está basado en un TL494CN que desoldé de una fuente de alimentación para PC estropeada. Como siempre al final de la entrada os dejo un enlace a los ficheros, incluido el datasheet y una nota de aplicación de TI titulada [Designing Switching Voltage Regulators With the TL494](http://focus.tij.co.jp/jp/lit/an/slva001d/slva001d.pdf).

Este integrado tiene todos los elementos necesarios para construir una fuente conmutada:

> The TL494 contains two error amplifiers, an on-chip adjustable oscillator, a dead-time control (DTC) comparator, a pulse-steering control flip-flop, a 5V - 5% precision regulator, and output-control circuits.

Aunque hoy sólo vamos a usar parte de la circuitería es interesante echarle un ojo a la **nota de aplicación** -*el datasheet deja bastante que desear*- porque tal vez se nos ocurran otros usos. Si bien es cierto que es un integrado diseñado para un propósito muy concreto, merece la pena conocerlo porque es bastante frecuente y muy sencillo de reutilizar. Lo podemos encontrar en fuentes de alimentación conmutadas, sobre todo en fuentes de PC antiguas posteriores al 2003 (fecha de la publicación de la nota de diseño).

Vamos a construir un sencillo circuito para controlar la tensión aplicada a una bombilla o un motor. Cuidado cuando apliquemos pulsos discontinuos a un motor que como sabéis es una **carga inductiva** y va a generar picos de tensión inversa que hay que considerar.

## Descripción del circuito

{% include image.html size="big" file="velomtr_sch.png" caption="" %}

Lo primero que hacemos es llevar a masa lo que no vayamos a utilizar: las patillas 1, 2, 15 y 16 que corresponden a dos amplificadores pensados para sensar y corregir la tensión de salida. Y la patilla 13, que determina si las dos salidas que tiene actúan en *push-pull* o en paralelo. Como sólo vamos a usar una nos da igual, así que la conectamos a 0V y tenemos salidas en paralelo.

La resistencia R2 y C1 están conectados al oscilador, en el datasheet los llaman CT y RT (T de timing). Con los valores que he elegido obtenemos una frecuencia de conmutación de 10kHz. Si os molesta el pitido podéis aumentarla, el límite de este integrado está en 150kHz. Pero si pensáis usarlo para controlar un motor, debéis tener en cuenta que la resistencia del bobinado aumenta con la frecuencia. La formula para calcular la frecuencia de oscilación no viene en el datasheet, pero en la nota se indica y es la habitual:

$$
F_{osc} = \frac{1}{R_T \times C_T}
$$

El **duty-cycle** lo fijamos mediante R1 y el potenciómetro. La patilla 4 (*Dead Time Control*) controla el tiempo de apagado, desde un mínimo de 3% (Duty Cycle 97%) cuando se le aplica una tensión de 3.3V a un máximo de 100% (Duty Cycle 0% o apagado) cuando se conecta a 0V. *Podríamos haber conectado las salidas en push-pull y utilizar la salida complementaria, de esa otra forma tendríamos un duty de 3% a 100% en lugar de 0% a 97% como tenemos con esta configuración*.

R1 actúa como divisor de tensión con P1 para que la tensión en la patilla 4 no sobrepase los **3.3V**. Debéis calcularla en función del valor del potenciómetro que penséis usar. Ya que

$$
V_{max} = \frac{5V}{R_1 + Pot}Pot = 3.3V\rightarrow R_1 \simeq 0.5Pot
$$

A la salida hemos colocado un BD140 que puede conmutar hasta 1.5A. El diodo D1 sirve para cortocircuitar los **picos de retorno** en caso de que conectemos un motor a la salida, y que no lleguen al transistor.

El circuito puede alimentarse entre 7 y 30V aunque los valores de R3 y R4 están pensados para 9V, así que si vais a usar otras tensiones diferentes puede que tengáis que recalcularlos para aseguraros de que el transistor funciona efectivamente en **conmutación**.

Aquí tenéis una foto del circuito terminado.

{% include image.html size="medium" file="BENQ0020.JPG" caption="" %}

En [este enlace]({{page.assets | relative_url}}/velomotor.rar) os dejo los ficheros de Eagle, el datasheet, la nota de aplicación antes mencionada y las fotos.
