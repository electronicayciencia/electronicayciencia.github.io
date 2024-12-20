---
layout: easymcp-project
title: LED parpadeante
---

## Componentes

- LED del color que quieras
- Resistencia de 1k&ohm;

## ¿Qué vas a aprender?

- Todo el programa dentro de un microcontrolador se ejecuta dentro de un bucle.
- El ojo humano es más lento que un microchip.
- La función ´sleep´ sirve para hacer una pausa.

## Esquema eléctrico

Conecta el LED a una de las salidas del integrado. El LED tiene dos posiciones. Si lo pones al revés no se encenderá.

Usa una resistencia en serie para limitar la corriente que circula por el LED y evitar que se queme.

{% include image.html class="medium-width" file="circuit.svg" %}

## Bucle principal

En un microcontrolador, el código se ejecuta dentro de un bucle. Se llama bucle principal (*main loop*). Comienza a ejecutarse cuando conectas el circuito y sólo acaba cuando lo desconectas.

Aquí lo simulamos con un bucle `while True`. Enciende el LED y luego lo apaga. Todo el rato. hasta que interrumpas el programa.

```python
{% include_relative prog1.py %}
```

Este es el resultado:

{% include image.html class="medium-width" file="fast.gif" %}

¿No hace nada? En realidad sí parpadea, pero tan rápido que no da tiempo de verlo. Hay que hacer que vaya más despacio.


## La función *sleep*

La función `sleep` hace una pausa antes de seguir con la siguiente instrucción.

```python
{% include_relative prog2.py %}
```

Se enciende, *esperamos* un segundo, se apaga, *esperamos* otro segundo y vuelta a empezar.

El **periodo** es el tiempo total que tarda, 2 segundos. La **frecuencia** son las veces que parpadea por segundo.

{% include image.html class="medium-width" file="blink.gif" %}


## Cambia la frecuencia

Haz que vaya más deprisa acortando el tiempo de la pausa. En vez de un segundo prueba a poner 0.5 o 0.1:

```python
# Encender
mcp.GPIO_write(gp0 = 1)
sleep(0.1)

# Apagar
mcp.GPIO_write(gp0 = 0)
sleep(0.1)
```

Prueba tiempos diferentes de encendido y apagado para hacer que parpadee de distintas formas. Por ejemplo prueba con 0.01 y 0.5 para hacer un destello.

## Al limite

En algunos sistemas, la función `sleep` no es adecuada para tiempos muy cortos. Y por eso por mucho que bajes el tiempo siempre notarás un ligero parpadeo. 

