---
assets: /assets/2010/04/reutilizar-el-motor-de-un-lector-cdrom
featured: 'true'
image: /assets/2010/04/reutilizar-el-motor-de-un-lector-cdrom/img/imagecompatibility.php
layout: post
tags:
- Circuitos
- Reciclaje
title: Reutilizar el motor de un lector CDROM
---

Hoy tenemos un lector de CDROM para desguazar. Es un tanto antiguo, pero eso nos favorece. Como ya os podéis imaginar mientras más moderno es un cacharro, mayor grado de integración y más complicado es reutilizar sus componentes.

Lo que me propongo es hacer funcionar el motor principal del CDROM, el que gira el disco a tropecientasmil revoluciones por minuto. Este tipo de motores son complicados de usar, ya que son prácticamente motores de AC trifásicos sin escobillas. Estos se componen de varias bobinas (generalmente 9) conectadas en triángulo, o también llamada configuración *delta*. En oposición a la configuración en estrella (*wye*) que permite un mayor torque a bajas velocidades, la configuración en triángulo permite más revoluciones, a costa de un arranque más lento. Además de las bobinas tienen algunos [sensores de efecto Hall](http://en.wikipedia.org/wiki/Hall_sensor) para determinar en qué posición está el rotor. Otro día haremos experimentos con estos sensores.

{% include image.html size="" file="imagecompatibility.php" caption="" %}

El truco es alimentar las bobinas en su momento oportuno o mejor, con un determinado *desfase*, pero NO es un motor paso a paso. Buscando por Internet encontraréis esquemas y proyectos que utilizan un micro para aplicar corriente alterna a las bobinas. El problema es que estos chismes están diseñados para funcionar con una señal sinusoidal y no cuadrada. Además si no usamos los sensores Hall seguramente no excitemos cada bobina a tiempo y tendremos unas pérdidas de aúpa.

{% include image.html size="medium" file="trifasica.png" caption="" %}

Dentro de los diversos tipos que hay, podemos distinguir los que efectivamente cuentan con sensores Hall, y los que se sirven de la tensión inducida en las bobinas que en cada momento no estén activas, o miden la [Fuerza Contraelectromotriz](http://es.wikipedia.org/wiki/Fuerza_contraelectromotriz) de cada bobina.

El caso es que si queremos un circuito para alimentar al motor con el que podamos variar la velocidad de rotación y que sufra lo menos posible, los esquemas se complican. ¡Pero el motor funcionaba cuando estaba montado en su placa!

## Secuestrar el driver

La solución técnicamente óptima es usar el propio driver que tenía la unidad lectora. Se tratará de un integrado como este:

{% include image.html size="" file="integrado_driver.jpg" caption="" %}

Encontrar su datasheet es una tarea de chinos (a veces literalmente). Cada fabricante usa su propia referencia que no encontraréis en Google, o si la encontráis entenderéis por qué digo lo de chinos. Pero en realidad sólo hay un puñado de integrados diferentes y el resto son más o menos equivalentes. Buscad "spindle motor driver datasheet" y bajaos unos cuantos modelos. Después quedaos con la hoja que mejor se adapte al circuito que tengáis, en base a:

- Número de patillas, forma y aspecto del integrado.
- ¿El motor tiene sensores hall o no? Si los tiene, el driver debe incluir patillas para estos.
- ¿Hay más motores que controle ese driver? Algunos integrados también llevan el motor del pick-up o de la bandeja. Si veis que esos motores van a parar al mismo integrado, debe indicarse en el datasheet.
- Por último, casi todos los datasheet incluyen un ejemplo de aplicación. Y los fabricantes no le echan mucha imaginación, comprobad que en buena medida se corresponden.

En mi caso descubrí que la referencia que veis arriba se corresponde con el patillaje del KA3020D. Cuyo datasheet podéis encontrar [aquí]({{page.assets | relative_url}}/KA3020D-BA6869FP.pdf). Y este esquema de ejemplo es muy parecido al que veo en la placa -es difícil asegurarlo, teniendo en cuenta que los componentes son SMD y el PCB tiene varias capas-.

{% include image.html size="" file="esquema_tipico.png" caption="" %}

Lo que vamos a hacer es, manteniendo el circuito soldado a la placa y sus componentes afines (alimentación, conectores, etc) tomaremos el control de algunas líneas. Las desconectaremos del microcontrolador principal y podremos controlar nosotros el motor. Para este propósito *secuestraremos* las siguientes líneas:

- **Start / Stop:** Nos servirá para encender y apagar el motor.
- **Short Brake:** Cuando está patilla se lleva a nivel alto, el driver aplica tensión a todas las bobinas por igual, frenando el motor. Esta no es la mejor forma de bajar gradualmente las revoluciones, pero  dependiendo de la inercia de la carga y su velocidad, frenar utilizando torque inverso (lo vemos debajo) obliga al integrado a aguantar una corriente elevada hasta detener el motor, y puede calentarse más de la cuenta.
- **Ecr:** Tensión de referencia.
- **Ec:** Torque aplicado. Al variar esta tensión respecto a la de referencia, el integrado aplicará más o menos tensión al motor variando la velocidad. Cuando se aplica una tensión menor a Ecr el driver aplica un par de frenado (o torque inverso), que es menor que si aplicáramos la patilla de freno.

{% include image.html size="" file="cables_cortes.jpg" caption="" %}

Con estas 4 líneas podemos aprovechar el driver mientras aún está en la placa del CDROM. Basta con aplicar tensión a la placa procedente de una fuente de alimentación para PC y conectar nuestras líneas secuestradas:

- Start/Stop a +5V.
- Brake a 0V.
- Ec: a 2.5V.
- Ecr: potenciómetro para regular la velocidad. La velocidad es proporcional a Ecr - Ec.

## Determinar la velocidad de rotación

Ahora que somos dueños del motor, nos interesa saber la velocidad que alcanza a la máxima potencia. Hay muchas formas de medir esto, una que tenía más a mano es usar la tarjeta de sonido y el programa *Xoscope*. Si pudiéramos oír un 'tic' en cada vuelta del motor, sería inmediato determinar el periodo de rotación, y con él las RPM.

Para oir ese 'tic' **sin frenar el motor** -eso es importante- atamos un hilo corto al eje y lo ponemos en marcha. Parte del hilo se enrollará mientras el extremo queda rotando con el motor. Ponemos una hoja de papel de forma que el hilo la toque de refilón en cada vuelta y visualizamos la señal en el PC.

{% include image.html size="medium" file="max_rpms.png" caption="" %}

En la imagen se aprecian picos de mayor amplitud (fruto del toque contra la hoja) y otros de menor amplitud, que no son otra cosa sino ecos del primero ya que el golpe contra la hoja no es seco. Medimos el periodo entre dos picos 'altos', y obtenemos 5056us. Lo que nos da un periodo de 197 vueltas por segundo o unas 11800 revoluciones por minuto.

En [esta tabla (tomada de Wikipedia)](http://en.wikipedia.org/wiki/CD-ROM#Transfer_rates), podemos ver la velocidad de giro en relación a la velocidad de lectura. El nuestro era un lector x52 por lo que esperaríamos un resultado de 10400 rpm. No obstante hemos obtenido más; es justo pensar que la limitación de x52 no está en el hardware que hace girar el CD sino en la misma circuitería del lector, además estamos girando en vacío, sin carga alguna por lo que esperamos más revoluciones.

## Discos de color

Hay algunos experimentos curiosos con discos que giran. Aprovechando esta entrada os voy a hablar de dos: el disco de Newton y el disco de Benham.

El **disco de Newton**, como podéis ver debajo tiene varios colores pintados de tal forma que al girar da la sensación de ser blanco. Simplemente por la suma aditiva de luces. Con un prisma vemos que la luz blanca está compuesta por varios colores, aquí vemos el efecto contrario, componemos esa luz blanca a base de superponer colores a una velocidad mayor que el refresco de la retina.

{% include image.html size="small" file="disco_newton.jpg" caption="" %}

El **disco de Benham** me resulta mucho más curioso. Se trata de una ilusión óptica por la cual un disco con un determinado diseño, pintado únicamente con tinta negra sobre fondo blanco, produce al girar la sensación de estar coloreado. Hay varios diseños, este que os pongo aquí es el que me ha dado mejor resultado.

{% include image.html size="small" file="Benham-s_Disc.PNG" caption="" %}

Hay mucha información en Internet sobre ambos fenómenos y os animo a seguir investigando.
