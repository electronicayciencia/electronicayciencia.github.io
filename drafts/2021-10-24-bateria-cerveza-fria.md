---
title: Proyectos a batería y cerveza fría
layout: post
assets: /assets/2021/10/bateria-cerveza-fria
image: /assets/2021/10/bateria-cerveza-fria/img/esp-01s-sleep-mod.jpg
featured: false
description: Proyectos a baterías con el ESP8266. Veremos ideas para **reducir el consumo** y lograr la máxima autonomía.
tags:
  - Fisica
  - Informática
  - Sensores
  - ESP8266
---

Hacer un termómetro inalámbrico con un chip ESP8266 no es difícil. Que funcione a pilas y dure más de unos pocos días requiere más cabeza. Nos iniciamos en los **proyectos a baterías**. Veremos ideas para **reducir el consumo** y lograr la máxima autonomía. Bienvenido a un mundo donde cada miliamperio cuenta.

Te va a sonar a perogrullo, pero lo primero que debes hacer **conocer cada componente** de tu circuito. Y tener bajo control su consumo. Por eso voy a usar un módulo ESP-01S. Porque conozco el esquema de cuando hice la entrada [Avisador personal de autobús con ESP8266][Electrónica y Ciencia - Avisador personal de autobús con ESP8266]. Podría haber usado un módulo ESP-12F. Pero cuidado con las **placas de desarrollo**, porque tienen muchos componentes adicionales cuyo consumo no conoces.

El software lo voy a hacer con el framework ESP-IDF y mi propia librería para DS1820. El código está en GitHub. Te dejo los enlaces al final.

Sí, se puede hacer lo mismo más fácilmente con Arduino, Tasmota, Esphome, Node-red, Home Assistant y muchos otros frameworks. No hace falta complicarse tanto.


## Tensión de alimentación

Según el [datasheet del ESP8266][ESP8266EX Datasheet - Espressif Systems], este chip necesita entre 2.5 y 3.6V. Una batería de litio de 3.6V parece lo más apropiado. Son recargables y fáciles de conseguir en varios tamaños.

Sin embargo, trabajando con baterías siempre debemos hilar fino. 

Para empezar, las baterías no *son de 3.6V*. Igual que las pilas alcalinas no *son de 1.5V*. Existen pilas que recién compradas dan 1.55V y, al punto de agotarse, sólo 0.8V. Eso sí *durante la mayor parte de su vida útil* están entre 1.4 y 1.5V.

Las baterías de litio de 3.6 o 3.7V, se cargan hasta los 4.2V. Y puedes usarlas mientras tienen 3 o 2.5V mínimo.

A propósito, no las dejes descargadas mucho tiempo ni las lleves por debajo del mínimo. Porque empiezan a ocurrir reacciones químicas indeseadas. Lentamente uno de los electrodos se descompone y se disuelve en el electrolito. Como consecuencia, **se deterioran**, pierden capacidad, su resistencia interna aumenta sensiblemente y su auto-descarga también lo hace. 

Volviendo a la tensión, mira esta gráfica de una 18650 de Panasonic. He resaltado en fondo verde el rango recomendado para el ESP8266.

{% include image.html file="discharge_rate.png" caption="Discharge Rate Characteristics for NCR18650B [Panasonic-NCR18650 datasheet]" %}

Pasa bastante tiempo **por encima** de los 3.6V. Sobre todo con corrientes de descarga pequeñas.

En muchos foros vas a leer comentarios como:

> Aunque el fabricante diga que el máximo absoluto del ESP8266 son 3.6V el mío lleva meses funcionando a 4.2 y va perfecto.

Y puede ser que sí, verás, depende de la **suerte** que tengas. Te lo explico.

En el proceso de fabricación de un microchip intervienen muchos factores que afectan al resultado. La **calidad** de la oblea de silicio, la pureza de los materiales, el estado de las máquinas... Por pura estadística, en cada partida de semiconductores los hay mejores y peores.

Durante el proceso de producción se toma una muestra del lote y se somete a unos tests para evaluar cuánto se ajusta a las especificaciones. Si sale **sobresaliente**, lo vendes más caro como grado especial (automotriz, médico, militar, aeroespacial, o lo que sea). Si sale **normal**, lo vendes a distribuidores y fabricantes; y entra a formar parte de sus productos de consumo. Y, si estadísticamente **no cumple** con las expectativas, lo vendes a mayoristas chinos para intentar sacarle el provecho que puedas.

En Aliexpress compras 100 transistores por $0.90. Y van *perfectos*. Algunos a lo mejor no aguantan hasta la intensidad máxima... en promedio tienen menor ganancia... quizá uno o dos no funcionan. Lo aceptamos, porque en general para tus proyectos de aficionado te sirven. Pero realmente pertenecían a un **lote defectuoso**. Eso no significa que no funcione ninguno. Significa que -en promedio- algún valor está fuera de las especificaciones de ese modelo. Ningún fabricante serio te lo va a admitir.

Por eso, según la calidad del ESP8266 que te haya tocado, si le metes 4.2V puede que:

- se funda
- se dañe en algún aspecto sutil pero irreversible
- se comporte de forma inestable o
- no le pase nada de nada. 

También puede ver reducida a la mitad su vida útil y tú nunca llegues a saberlo, porque te habrás cansado de él mucho antes.

La obligación de Espressif -como fabricante- es decirte que el máximo absoluto son 3.6V. Porque a partir de ahí ya no puede garantizar las especificaciones que da para este chip.

Te pongo un ejemplo. El consumo en modo de espera **deep sleep** es de 20 a 30uA. Lo cual es cierto... para todo el rango recomendado entre 2.5 y 3.6V. Pero en cuanto pasamos de ahí, mira lo que ocurre.

{% include image.html file="consumo_deep_sleep.png" caption="Evolución del consumo en *deep-sleep* del módulo ESP-01S. EyC." %}

Se dispara. Con 4.2V no se ha fundido, pero ya va por **400uA**, ¡Multiplica por 20 lo indicado!


## El regulador

¿A quién se le ocurre hacer un chip, ponerle un modo de bajo consumo para ahorrar batería, y por otro lado diseñarlo para funcionar en un rango donde no encuentras baterías?

Dejemos a un lado las discusiones filosóficas y vamos a ver cómo rebajamos esa tensión que nos sobra.

Lo primero que debes considerar es la **corriente** del circuito. El ESP8266 consume unos 20uA en reposo (*deep-sleep*), 50mA en promedio y picos de hasta 400mA transmitiendo WiFi.

Una recomendación que he leído es usar sencillamente un **diodo**. La caída de tensión de un diodo es de 0.7V. Eso dejaría los 4.2 en 3.5V. Perfecto. Es un componente muy barato, fácil de conseguir y de usar, no consume nada en reposo y puede suministrar la corriente necesaria.

¿Suena demasiado bien? Claro, porque es **mentira**. 

La caída de tensión de un diodo **no es fija**, depende de la corriente que circule por él. Desde los 20uA en deep-sleep a los 300mA en transmisión, el rango es demasiado amplio como para decir que *"en un diodo caen 0.7V"*. No es cierto. Depende del tipo de diodo, pero mira este gráfico para el 1N4148, por ejemplo.

{% include image.html file="caida_1N4148_20u_300m.png" caption="Caída de tensión en un diodo 1N4148 en función de la corriente directa (simulación modelo LTSpice). EyC." %}

En modo reposo sólo te va a quitar 0.4V. Mientras que en picos esa caída subiría hasta 1V. Depende del tipo de diodo, por supuesto.

No es lo ideal, pero si dudas entre conectar la pila directamente o poner un diodo, **pon un diodo**. Al menos protege contra los cambios de polaridad accidentales.

Yo prefiero usar un **regulador serie**. 

Los **LDO** de *Low Dropout Regulator* son reguladores diseñados especialmente para funcionar con baterías. Se caracterizan por su **mínima caída de tensión** y **bajo consumo**. El [**MCP1700** de Microchip][MCP1700 Low Quiescent Current LDO Data Sheet - Microchip] consume en reposo **sólo 1.8uA**.

Espera. Antes de seguir. 1.8uA es **poco**. Pero piensa en cómo de poco es. Sin considerar las pérdidas por auto-descarga, una batería Li-Ion corriente de 1500mAh podría alimentar un MCP1700 durante **¡95 años!**.

Aunque ese consumo tan diminuto se consigue a costa de algunas limitaciones:

- La **corriente máxima** que puede suministrar es 250mA.
- La **velocidad de respuesta** es muy lenta.

El ESP8266 tiene picos de consumo superiores a los 250mA. ¿Supone un problema? **No, según el datasheet**:

> 6.5 Pulsed Load Applications 
> The 250 mA rating is a maximum average continuous rating. As long as the average current does not exceed 250 mA, pulsed higher load currents can be applied to the MCP1700. The typical current limit for the MCP1700 is 550 mA.

Viene a decir que los 250mA máximos son **de continuo**. Mientras el pico no llegue a los 550mA, funcionará.

Ahora es cuando entra en juego el otro compromiso, la **velocidad de respuesta**. 

He conectado a la salida del MCP1700 un circuito consumiendo 30uA que, de golpe, sube a 400mA. Mira lo que ocurre con la tensión regulada:

{% include image.html file="mcp1700-600us-400mA-0uF.png" caption="Respuesta del MCP1700-3302 a un transitorio de carga escalón de 400mA. EyC." %}

En un instante, la tensión nominal de 3.3 cae hasta **menos de 1 voltio**. Luego se regula hasta los 3.0 y, al desconectar la carga, sube hasta **superar los 4V**. Luego vuelve a los 3.3V originales. 

Según la calidad del ESP8266 que tengas, puede llevar bien esas variaciones. Pero lo más frecuente que se te reinicie o se cuelgue.

Por suerte, es fácil evitarlo. Basta colocar a la salida un condensador de capacidad suficiente (330uF por ejemplo). Así suavizamos el pico y el regulador puede adaptarse a tiempo. Mira qué diferencia con lo anterior:

{% include image.html file="mcp1700-600us-400mA-330uF" caption="Respuesta del MCP1700-3302 a un transitorio de carga escalón de 400mA con un condensador de 330uF en paralelo. EyC." %}

También podríamos haber utilizado un **LDO más potente**, donde el transitorio se nota menos, o **reguladores conmutados**, que tienen mayor rendimiento.

Sin embargo, en mi opinión el criterio con más peso a la hora de elegir componentes para este diseño es el **consumo en reposo**. Porque el chip va a pasar la mayor parte del tiempo en modo *deep sleep*. No me planteo usar un LDO con mayor consumo si puedo dejarlo en 1.8uA añadiendo un condensador.


## Modos de espera

Cuando un microcontrolador entre en modo de espera *(sleep)*, se apagan algunos componentes internos para ahorrar energía.

El ESP8266 tiene tres modos diferentes:

- **Modem-sleep**: Apaga la radio y el modem Wi-Fi. Todo lo demás funciona. Consume **15mA** según el datasheet.
- **Light-sleep**: La CPU y los periféricos entran en pausa. La ejecución puede reanudarse en presencia de algunos eventos tales como, por ejemplo, interrupciones hardware. Consume **0.9mA**.
- **Deep-sleep**: Se apaga todo (incluida la CPU). Sólo queda encendido el RTC (*Real Time Clock*). La ejecución se detiene y no es posible reanudarla. Únicamente se puede salir de este modo reiniciando el microcontrolador. Consume **20uA**. 

En un ESP8266, el *reinicio* se consigue llevando a nivel lógico cero la **patilla 32** (EXT_RSTB). Eso puede suceder de dos formas.

- Con un **evento físico**. Por medio de un pulsador por ejemplo. El dispositivo estaría en *deep-sleep* consumiendo muy poquito. Cuando se pulsa el botón de *reset* se ejecuta el programa y acto seguido vuelve a dormir.
- Con un **evento lógico** provocado por el RTC, el único subsistema que quedaba funcionando. El RTC es capaz de llevar a cero la **patilla 8** (XPD_DCDC) al finalizar un intervalo programado. Lo aprovecharemos para provocar un reinicio.

El ESP-01S necesita una **ligera modificación**. Consiste en unir la patilla 8 con la línea de reset por medio de **una resistencia** de entre 1 y 2k.

{% include image.html file="esp-01s-sleep-mod.jpg" caption="Modificación necesaria en un ESP-01S para salir del modo deep-sleep mediante el RTC. EyC." %}

Usa siempre una resistencia. Si lo haces directamente te dará problemas a la hora de programar el dispositivo. Ya que el programador no conseguiría reiniciar el chip si en la patilla 8 existiera un nivel lógico alto.

Programamos el ESP-01S para leer el sensor de temperatura DS18B20 y enviar el dato (luego veremos dónde y cómo).

En esta gráfica se aprecia el consumo durante una ejecución completa:

{% include image.html file="medida_completa_21db.png" caption="Consumo aproximado del ESP-01S durante una medida de temperatura. EyC" %}

Cada lectura de temperatura dura más o menos 1.2 segundos, y se puede dividir en:

- **Fase A**: Reinicio del integrado. Ejecución del bootloader. Carga el programa inicial a la RAM. Inicializa los periféricos internos (PLL, I2C, temporizadores, etc.). Inicialización de librerías. Durante todo este tiempo el consumo ha sido de unos **50mA**.
- **Fase B**: Arranque del sistema operativo RTOS y tareas en segundo plano. Se lanza la tarea principal de usuario. Inicializamos el bus 1-Wire para leer del sensor DS1820, acto seguido le damos orden de realizar una nueva lectura. Aquí también estamos consumiendo 50mA
- **Fase C**: El sensor está calculando la temperatura con 12 bits de precisión. Eso le llevará alrededor de 750ms. Aprovechamos para entrar en *light-sleep*. Despertamos a intervalos para preguntar al sensor si ha terminado ya. El consumo en esta etapa es poco más de **1mA** en promedio.
- **Fase D**: El sensor ha terminado. Leemos el resultado. Inicializamos la radio, que hasta ahora teníamos apagada. El consumo se incrementa hasta los **150mA**. La duración y consumo es muy variable, porque en este momento ocurre también un calibrado del hardware.
- **Fase E**: Transmitimos el dato. Es un pico de corriente fuerte pero muy breve. Puede superar los **400mA**.
- **Fase F**: Apagamos todo y entramos en *deep-sleep* de nuevo. Hasta la siguiente medida consumiremos 30uA.


## Aumentar la duración de las pilas

Cada medida consume batería. **Espaciar las medidas** es el modo más simple de alargar su duración. La tempteratura de un sistema pequeño puede cambiar rápidamente. Necesitas medir con frecuencia. Cada 5 segundos es adecuado. Pero para medir la temperatura atmosférica quizá te sirva con una medida cada minuto, o incluso cada 10 minutos.

Pero **no te pases**. Las baterías siempre tienen un consumo propio, correspondiente a su auto-descarga. Pequeño pero está ahí. No pienses que por hacer una medida al mes la pila te va a durar siglos.

Otro *truco* es **alimentar el sensor a través de una patilla** IO del ESP8266. Así cortamos la alimentación entre medidas -consumo cero en reposo- y lo encendemos justo cuando vayamos a medir. La salida del ESP8266 puede suministrar unos pocos miliamperios, suficientes para alimentar el DS18B20. Con sensores de mayor potencia usaríamos un **mosfet** a modo de interruptor.

Si el receptor está cerca, considera **reducir la potencia** de transmisión. En el SDK del ESP8266 la opción se llama `Component config->PHY->Max WiFi TX power` y viene dada en dBm (decibelios **milivatio**). La potencia máxima del chip es 20dBm y la mínima 0dBm. La correspondencia entre dBm y vatios sería así:
 
Potencia en dBm | Potencia en mW
---:|---:
**0 dBm** |  **1 mW**
 3 dBm |  2 mW
 7 dBm |  5 mW
**10 dBm** | **10 mW**
13 dBm | 20 mW
17 dBm | 50 mW
**20 dBm** | **100 mW**

Reducir la potencia tiene otro efecto positivo. Requiere menor corriente de pico, lo cual reduce o incluso elimina el condensador electrolítico tras el MCP1700.

Más ideas. Durante todo el tiempo que estemos fuera del *deep sleep* gastaremos batería. Por tanto conviene minimizarlo. Por eso usamos espnow, como veremos luego. Aquí tienes **otras opciones del SDK** que pueden ser útiles:

- `Log output->Default log verbosity: Error`: **Reducir el nivel de log** evitará perder tiempo escribiendo mensajes que nadie va a leer.
- `Compiler options->Optimization Level: Release`: **Activar las optimizaciones del compilador** puede ahorrar algunos microsegundos.
- `Component config->Common ESP-related->Task Watchdog timeout period: 6.5536s`: Reducir al mínimo el **watchdog** hará que, en caso de inconsistencia, el chip se reinicie lo antes posible volviendo a un estado conocido.


Por último dos cosas muy útiles para sensores remotos:

- Calidad de recepción
- Estado de la batería

La **calidad de la señal** se puede deducir de la fracción entre el número de paquetes espnow recibidos y los esperados en un intervalo de tiempo.

Por ejemplo si hacemos una medida cada 5 segundos y cada medida dura 1.3s. En 20 minutos espero haber recibido unas 190 mediciones. Pero cuando hacemos el gráfico con la cuenta vemos que fluctúa:

{% include image.html file="medidas_recibidas_20m.png" caption="Conteo de las medidas recibidas en intervalos de 20 minutos. EyC." %}

En cuanto al **estado de la batería**, lo más fácil es utilizar el **ADC incorporado** en el ESP8266. No es necesario conectar ninguna patilla para medir la tensión de alimentación. Sí hace falta **activar la WiFi** y en el SDK debes configurar `Component config->PHY->vdd33_const: 255`.

Por otro lado si usas un regulador tipo MCP1700, no vas a ver variar la tensión más que cuando esta ya sea muy baja. Con **un diodo** en serie verías algo así:

{% include image.html file="tension_bateria.png" caption="Evolución de la tensión leída en el ADC interno del ESP8266. EyC." %}

Es más visual mostrar estos datos en forma de porcentaje en tiempo real:

{% include image.html file="tension_y_fuerza.png" caption="Estado de la batería y calidad de la señal mostrados como porcentaje. EyC." %}


## ESP Now - Transmisor

Vamos a los detalles de la transmisión por radio. 

En una conexión WiFi *normal* antes de enviar el dato debemos:

- Establecer contacto con el AP
- Registrarnos en la red y autenticarnos
- Obtener la IP así como la configuración de red vía DHCP
- Transmitir el dato por HTTP o MQTT.

Todos esos pasos son tiempo que el dispositivo está encendido y consumiendo batería. Lo que es peor, implica transmitir multitud de paquetes.

¿No podríamos enviar el dato por radio sin más?

Sí, con la tecnología **espnow**. Que por el nombre puede sonar disruptiva, pero consiste en incluir el dato en un paquete estándar y enviarlo sin asociarse a la red.

El protocolo incluido en el SDK de Espressif se describe en [API Reference - Networking APIs - ESP-NOW].

Dentro del estándar hay unos paquetes de tipo *control*llamados **action frame**. Los emiten el AP o las estaciones para solicitar distintos procedimientos como controlar la potencia, ajustar el modo del canal, QoS, etc.

Dentro de los *action frame*, hay un tipo genérico llamado **vendor specific**. Dichos *vendor specific* incluyen un payload de hasta 255 bytes cuyo contenido es arbitrario.

{% include image.html file="a-cat.png" caption="Un gato a tamaño natural, máximo 100% del ancho de la pantalla. Foto de Google." %}
[foto: action_frame.png]

Los paquetes ESPNOW, basados en estos, disponen de un campo libre de hasta 250 bytes para transportar el mensaje que quieras. Como no necesitas estar asociado a red, el envío es inmediato.

Espnow es sencillo, aunque el ejemplo que acompaña al SDK lo veo un poco enrevesado.

La inicialización, si quisiéramos hacerlo bien, sería así:

- Inicializar la radio y la librería espnow.
- Indicar las opciones a utilizar (canal, cifrado, etc.)
- Registrar los dos **callbacks**. Uno que se invocará cuando llegue un paquete para nosotros; y otro para indicar si los paquetes que hemos enviado nosotros han llegado bien al receptor o no.
- Indicar la lista de MAC que serán nuestros peers (y opcionalmente una clave de cifrado para cada uno).

Lo voy a usar en modo broadcast, que es **más simple** porque nos permite omitir cosas:

- no hay lista de MACs (el mensaje llega a todo el mundo)
- no hay lista de peers ni claves, sin cifrado, cualquiera puede leer e inyectarnos paquetes.
- no hay acuse de recibo, los callbacks no hacen nada

Os dejo un transmisor espnow muy básico en [electronicayciencia/esp8266-learning/espnow-tx/main/main.c].


El campo de "datos" es libre. Voy a enviar la temperatura así: `t=XX.XXX`.

*Nota: el **formato en coma flotante** de printf viene desactivado por defecto. Se activa poniendo a **false** la opción* `Component config->Newlib-> Enable 'nano' formatting options`.

Por si tienes interés, el paquete que se transmite (el pico de 400mA en el diagrama del apartado anterior) contiene esto:

```console
d0 00 00 00 ff ff ff ff  ff ff cc 50 e3 5d 6a 90
ff ff ff ff ff ff 20 bd  7f 18 fe 34 25 b7 29 63 
dd 0d 18 fe 34 04 01 74  3d 33 2e 36 38 38 00 ee 
82 ab 42
```

Nuestros datos van casi al final del todo. El resto es envoltorio para componer el paquete 802.11:

```console
Cabecera MAC:
d0                <- Tipo de paquete: action frame
00                <- sin ordenar
00 00             <- duración no especificada
ff ff ff ff ff ff <- MAC destino: cualquiera
cc 50 e3 5d 6a 90 <- MAC origen
ff ff ff ff ff ff <- BSSID (id de la red): broadcast
20 bd             <- secuencia y fragmento

Descripción de Action Frame:
7f                <- Tipo: Específico del fabricante
18 fe 34          <- OUI del fabricante (Espressif)

Payload:
25 b7 29 63       <- bytes aleatorios (anti-replay) 
dd                <- tag id: vendor
0d                <- longitud tag: 13 bytes
  18 fe 34          <- OID: Espressif
  04                <- tipo: espnow
  01                <- version: 1
  74 3d 33 2e 36 38 38 00 <- datos: "t=3.688"

Checksum:
ee 82 ab 42 <- FCS (CRC-32)
```


## ESP Now - Cadena receptora

Necesitarás un segundo chip de Espressif para recibir los paquetes espnow.

Una opción sería recibir los paquetes espnow y enviarlos por WiFi a un servidor MQTT por ejemplo. Se puede hacer siempre y cuando el transmisor espnow esté en el **mismo canal** que tu red WiFi.

Para aprender, yo he ido por un camino **menos integrado** ([electronicayciencia/esp8266-learning/espnow-rx]).

- Recibo los paquetes en un ESP-01S. Retransmito el *payload* por puerto serie a una Raspberry Pi incluyendo la MAC del origen.

{% include image.html file="espnow_rx.png" caption="Datos recibidos por puerto serie. EyC." %}

- Hay un programa leyendo del puerto serie. Añade la hora de recepción y los publica en una cola **MQTT local**.
- Suscrito a la cola MQTT, un segundo programa recoge los datos y los envía a un servidor **InfluxDB Cloud**.

Por cierto, hablando de MQTT. Esto es lo que pasa cuando se interrumpe la conexión con `QoS=0`:

{% include image.html file="qos0.gif" caption="Pérdida de datos tras una desconexión transitoria al servidor MQTT con QoS=0. EyC." %}

Como ves, los datos entre el mensaje 20 y el 27 se han perdido.

Para evitarlo, debes indicar tu **identificador**. Así el servidor *te conoce*. Y cuando te suscribes a una cola con `QoS=2`, te guarda los mensajes mientras estas desconectado:

{% include image.html file="qos2.gif" caption="Desconexión transitoria al servidor MQTT con QoS=2. EyC." %}


¿Y si falla el envío al servidor InfluxDB Cloud?

El otros protocolos de colas como *MQ Series*, el servidor espera a que el receptor confirme que ha podido procesar el mensaje. Pero en MQTT no. **MQTT elimina** el mensaje de la cola **nada más entregarlo** al receptor sin esperar hasta ver si este ha podido procesarlo correctamente o no. 

Para más detalles sobre el envío y consultas a InfluxDB 2 lee el post [Electrónica y Ciencia - Registrador de ruido ambiental].


## Cerveza helada

Ya que te he contado algo de electrónica ¿que tal si ahora te cuento algo de ciencia?

Con mi termómetro a pilas y un bonito panel en Grafana te voy a contar lo que pasa cuando metes **una cerveza en el congelador**.

{% include image.html file="a-cat.png" caption="Un gato a tamaño natural, máximo 100% del ancho de la pantalla. Foto de Google." %}
[foto: cerveza_fria.jpg]

He acoplado el sensor DS18B20 a una lata de cerveza de 33cl y después lo he cubierto con material aislante. 

Ahora meto la lata en la nevera. Evidentemente, se enfría. Primero deprisa y luego cada vez más despacio.

{% include image.html file="enfriamento-newtoniano.png" caption="Evolución de la temperatura de un cuerpo tras introducirlo en un ambiente a temperatura inferior (lata en la nevera). EyC." %}

La transferencia de calor es proporcional a la **diferencia de temperaturas**.

Cuando la velocidad del cambio (segunda derivada) es proporcional a la magnitud que lo causa, el resultado es una exponencial. Esto lo formalizó Newton cuando inventó el cálculo. Por eso lo llamamos *enfriamiento Newtoniano*.

¿Cuanto tarda en enfriarse? **Varias horas** dependiendo de la temperatura exterior, potencia y condición del frigorífico, lo lleno que esté, tamaño y forma de la lata, dónde la pongas, cuántas veces abras la puerta y un montón de variables más.

Pongamos que ya se ha enfriado del todo, pero no te vale.

A ti no te gusta la cerveza fría, te gusta la cerveza **muy fría**. Eso de que la temperatura óptima es de 3ºC te parece una tontería de gente que no sabe cómo pega el Sol en verano en tu tierra. Si fueras el alcalde, harías obligatoria la Cruzcampo Glacial.

Así que la metes en el congelador, pero no quieres que se congele, tampoco. Porque pierde el gas y no sabe a nada.

La pregunta ahora es ¿cuándo sacarla?

Déjame que te hable de los **cambios de fase**. 

Ahora estarás pensando en una caña fría con su tapita y no te interesa, pero prometo ser breve.

La cerveza es básicamente una disolución acuosa de alcohol, CO<sub>2</sub> a presión y electrolitos. Cuando en el colegio te decían que **El agua se congela a 0 grados**, en realidad querían decir *la temperatura a la que conviven los estados sólido y líquido del agua pura es 0ºC a 1 atmósfera de presión*. Pequeños matices que ahora cobran relevancia.

La metes en el congelador, y empieza a enfriarse. El siguiente gráfico muestra la temperatura según va pasando el tiempo. Estás en la **fase A**.

{% include image.html file="punto_de_congelacion.png" caption="Etapas de un proceso de transición de fase líquida a sólida (cerveza congelándose). EyC." %}

A medida que el líquido se enfría, cambia su densidad. Por debajo de -1ºC cesan las corrientes de convección y el enfriamiento se frena un poco. Se sabe porque la línea tiene menor pendiente. Es la **fase B**. Aún es líquida.

Seguimos enfriando. Bajamos de -2 ¿se ha congelado ya? No...

4ºC bajo cero ¿se ha congelado ya? No... 

10 bajo cero ¿y ahora? Aún no... 

Ya va por -12ºC...

¡Bueno, basta! Tenía que haberse congelado hace rato, pero ***no sabe por dónde empezar***. 

Literalmente. El interior de la lata es tan liso que no hay ningún sitio donde formar el primer cristal de hielo. Se llama **estado metaestable**. Tienes un líquido **subenfriado**. 

Te cuento lo que va a pasar si la sacas ahora. Abres la lata, empiezas a verterla y, según toca el vaso se hace hielo. Es más, la de la lata también se ha helado y ahora no sale. ¿Te ha pasado alguna vez? De lo más frustrante cuando te pasa con un botellín en el bar.

El estado metaestable se acaba rompiendo. Bien por una perturbación, o de forma espontánea como aquí. Entramos en la **fase D**.

Estábamos en -12ºC, y de nuevo a -4ºC. Al pasar de líquido a sólido, se libera calor y la temperatura sube. El valor al que hemos vuelto es justo el **punto de congelación**. 

¿Cuándo había que haberla sacado? **A la media hora**, más o menos. Antes de entrar en la zona roja. -4ºC es la temperatura más fría a la que puedes servir esta cerveza. Es más, como estás por debajo del punto de congelación del agua, la humedad ambiente se condensará y se formará ese **hielo** en la jarra que tanto te gusta.


¿Y si me olvido de sacarla?

Se supone que la temperatura varía muy poco mientras se congela. Pero ¿sabes qué? El hielo abulta más que el agua. A medida que se forma hielo, aumenta el volumen. Como el sistema está cerrado aumenta la presión. La presión, a su vez, impide la formación de hielo. Es un bucle en el que cada vez se necesita más frío. Mientras el recipiente aguante, el punto de congelación va bajando más y más. 

{% include image.html file="cambio_de_fase.png" caption="Evolución del punto de congelación en un sistema cerrado (cerveza congelándose más). EyC." %}

Si a mitad del proceso abres la lata o se rompe, la presión se pierde, el punto de congelación vuelve al nivel normal y todo el líquido se convierte de golpe en hielo.

Sólo una pequeña parte del CO<sub>2</sub> disuelto en el agua se difunde en la red cristalina de hielo. La mayoría escapa. Por esa razón una cerveza descongelada ya **no tiene gas**.

{% include image.html file="completo_desde_caliente_grad.png" caption="Proceso completo y gradiente de temperatura. EyC." %}


## Referencias y enlaces

Artículos propios

- [Electrónica y Ciencia - Avisador personal de autobús con ESP8266]
- [Electrónica y Ciencia - Registrador de ruido ambiental]

- [electronicayciencia/esp8266-learning/espnow-rx]
- [electronicayciencia/esp8266-learning/espnow-tx/main/main.c]
- [Github Electronica Y Ciencia - ds18b20-espnow/]

Sobre baterías

- [ENERGIZER E91]
- [Lithium-ion Battery LIR18650 2600mAh]
- [Panasonic-NCR18650 datasheet]
- [Andreas Spiess - #64 What is the Ideal Battery Technology to Power 3.3V Devices like the ESP8266? - YouTube]

Sobre reguladores

- [Understand Low-Dropout Regulator (LDO) Concepts to Achieve Optimal Designs]
- [MCP1700 Low Quiescent Current LDO - Microchip Technology Inc.]
- [MCP1700 Low Quiescent Current LDO Data Sheet - Microchip]


WiFi y espnow

- [How I WI-FI - Power Save Methods]
- [ESP8266 Low Power Solutions]
- [API Reference - Networking APIs - ESP-NOW]

Varios

- [Cervezas frías, pero no tanto. La temperatura ideal de servicio para cada cerveza - cervezasfrias.es]
- [Technology Connections - Reusable handwarmers that get hot by freezing - Youtube]
- [Quality Grades On Nec Semiconductor Devices]
- [ESP8266EX Datasheet - Espressif Systems]







[Electrónica y Ciencia - Avisador personal de autobús con ESP8266]: {{site.baseurl}}{% post_url 2021-01-09-avisador-personal-autobus-con-esp8266 %}
[Electrónica y Ciencia - Registrador de ruido ambiental]: {{site.baseurl}}{% post_url 2021-05-03-registrador-ruido-ambiental %}

[electronicayciencia/esp8266-learning/espnow-rx]: https://github.com/electronicayciencia/esp8266-learning/tree/main/espnow-rx
[electronicayciencia/esp8266-learning/espnow-tx/main/main.c]: https://github.com/electronicayciencia/esp8266-learning/blob/main/espnow-tx/main/main.c
[Github Electronica Y Ciencia - ds18b20-espnow/]: https://github.com/electronicayciencia/esp8266-learning/tree/main/ds18b20-espnow


[Andreas Spiess - #64 What is the Ideal Battery Technology to Power 3.3V Devices like the ESP8266? - YouTube]: https://www.youtube.com/watch?v=heD1zw3bMhw
[ENERGIZER E91]: https://data.energizer.com/pdfs/e91.pdf
[Lithium-ion Battery LIR18650 2600mAh]: https://www.ineltro.ch/media/downloads/SAAItem/45/45958/36e3e7f3-2049-4adb-a2a7-79c654d92915.pdf
[Panasonic-NCR18650 datasheet]: https://www.shoptronica.com/files/Panasonic-NCR18650.pdf


[Understand Low-Dropout Regulator (LDO) Concepts to Achieve Optimal Designs]: https://www.analog.com/en/analog-dialogue/articles/understand-ldo-concepts.html
[MCP1700 Low Quiescent Current LDO - Microchip Technology Inc.]: https://www.microchip.com/en-us/product/MCP1700
[MCP1700 Low Quiescent Current LDO Data Sheet - Microchip]: https://ww1.microchip.com/downloads/en/DeviceDoc/MCP1700-Low-Quiescent-Current-LDO-20001826E.pdf




[How I WI-FI - Power Save Methods]: https://howiwifi.com/2020/06/25/power-save-methods/
[ESP8266 Low Power Solutions]: https://www.espressif.com/sites/default/files/documentation/9b-esp8266-low_power_solutions__en.pdf
[API Reference - Networking APIs - ESP-NOW]: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/network/esp_now.html


[Cervezas frías, pero no tanto. La temperatura ideal de servicio para cada cerveza - cervezasfrias.es]: https://cervezasfrias.es/temperatura-para-servir-la-cerveza
[Technology Connections - Reusable handwarmers that get hot by freezing - Youtube]: https://www.youtube.com/watch?v=Oj0plwm_NMs
[Quality Grades On Nec Semiconductor Devices]: https://www.renesas.com/us/en/document/oth/quality-grades-nec-semiconductor-devices-c11531ej4v1if00
[ESP8266EX Datasheet - Espressif Systems]: https://www.espressif.com/sites/default/files/documentation/0a-esp8266ex_datasheet_en.pdf




