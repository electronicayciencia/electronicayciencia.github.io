---
title: Librería en C para LCD
web: https://electronicayciencia.github.io/wPi_soft_lcd/
date: 2018-01-01
image: wpi-lcd.jpg
---

Librería en C para manejar una LCD I2C (basada en el chip PCF8574).
Prinicpales características:

- Funciones simples muy básicas (posicionar el cursor, escribir texto).
- Integración con *printf* para formato de texto y texto multilinea.
- Soporte de caracteres personalizados.
- Tabla de reemplazo para carácteres UTF8 anchos (ñ, tildes, etc).
- Lectura de datos desde el controlador LCD.
- Control de iluminación posterior (atenuación con PWM).

Pensada en un primer momento para Raspberry Pi utiliza la librería *wPi_soft_i2c*.
Se puede portar fácilmente a otras plataformas como ESP32.


