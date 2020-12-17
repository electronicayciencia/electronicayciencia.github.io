---
assets: /assets/2010/03/conversor-usb-rs232
image: /assets/2010/03/conversor-usb-rs232/img/Imagen148.jpg
layout: post
tags:
- Reciclaje
title: Conversor USB - RS232
---

Hola.

Para inaugurar este blog he elegido un proyecto muy sencillo y muy práctico. Se trata de adaptar un barato conversor de 2€ para poder comunicarnos con un microcontrolador. Es útil en caso de que vuestro PC no tenga puerto serie y sólo tenga puertos USB, o si lo tiene  generalmente está poco accesible en la parte de atrás de la torre.

En esta ocasión no se trata de diseñar y construir nuestro conversor, porque por el precio que tiene no merece la pena el tiempo que invertiríamos. Además necesitaríamos cierta práctica trabajando con SMD. Hay conversores de varios precios, el más barato que he visto está en [Dealextreme](http://www.dealextreme.com/details.dx/sku.24799). Una vez desmontado podéis verlo en esta foto. Disculpad la calidad.

{% include image.html size="" file="Imagen148.jpg" caption="" %}

Está basado en el popular PL2303 de Prolific. Descripción y datasheet [aqui](http://www.prolific.com.tw/eng/Products.asp?ID=59). Sin embargo para reducir el precio no integra un PL2303 "de verdad" sino que está integrado en la misma placa.Para conectar un microcontrador al PC habitualmente usaremos sólo las lineas Rx, Tx y GND. Dejando de lado las demás. No obstante nos interesará que esas líneas no queden en el aire, de lo contrario algunos programas podrían no funcionar. Para evitarlo haremos una *conexión null modem con falso handshake* como se indica aquí:

{% include image.html size="" file="db9_null_loop.png" caption="" %}

La imagen está tomada de [esta web](http://www.lammertbies.nl/comm/info/RS-232_null_modem.html), donde se detallan los pros y los contras de cada conexionado.

Recomiendo eliminar las clavijas DB9 y USB y sustituirlas por sendos cables. Eliminar el conector USB es sencillo. Para extraer el DB9 quizá tengáis que serrar los pines, porque están soldados por ambos lados. Para terminar, un poco de retráctil evitará que toquemos con la placa en sitios delicados.

{% include image.html size="" file="Imagen149.jpg" caption="" %}

Notas adicionales:
