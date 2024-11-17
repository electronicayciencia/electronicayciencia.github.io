---
title: Verilog VGA
web: https://electronicayciencia.github.io/verilog-vga/
date: 2024-01-01
image: verilog-vga.jpeg
---

Varios proyectos para aprender cómo usar una FPGA.

Basados en la placa Sipeed Tang Nano y una pantalla LCD VGA.

Los proyectos van en grado de dificultad creciente:
- Patrones simples
- Imágenes desde la ROM
- Texto
- Terminal serie

Cada subdirectorio del proyecto principal tiene su propio README con los puntos clave y ejemplos (en inglés).
Así como un artículo con una extensa explicación (en español).

Artículos:
- [Primeras experiencias con Sipeed Tang Nano]({{site.baseurl}}{% post_url 2021-07-05-tang_nano_fpga %}). Impresiones, primeros circuitos en verilog y errores de principante.
- [Pantalla LCD con Tang Nano parte I. Patrones]({{site.baseurl}}{% post_url 2021-11-29-lcd_tang_nano_I_patrones %}). Cómo manejar una pantalla VGA. Señales de reloj.
- [Pantalla LCD con Tang Nano parte II. Imágenes]({{site.baseurl}}{% post_url 2021-12-12-lcd_tang_nano_II_imagenes %}). Mostrar imágenes monocromo. Ruido blanco. Colores CGA. Texturas.
- [Gráficos VGA con FPGA Tang Nano parte III. Texto]({{site.baseurl}}{% post_url 2023-11-10-lcd_tang_nano_III_texto %}). Repasamos la historia de la informática mientras diseñamos un controlador VGA para texto.
- [Mi propia consola serie y el terminal de Unix]({{site.baseurl}}{% post_url 2024-01-17-consola-serie %}). Desde hacer un terminal serie a hackear con STTY. Pasando por la historia del teletipo, la disciplina de línea o Terminfo.

