---
title: WiFi Telnet Serial Console
web: https://github.com/electronicayciencia/esp32-remote-serial-console
date: 2026-01-01
image: remotecon-esp32c3.jpg
---

Servidor de consola serie con un ESP32-C3.

Expone la consola serie de un servidor Linux mediante un servidor Telnet. Útil para tener un acceso *out-of-band* al servidor si la interfaz de red principal falla.

Todo el hardware está en una placa *ESP32-C3 Super Mini*. La provisión inicial del dispositivo (IP, puerto, WiFi, contraseña de sesión) se hace con su propia consola serie. Se necesita un conversor USB-UART o un segundo ESP32-C3. Ver [conversor USB-UART](https://github.com/electronicayciencia/esp32-uart-bridge).

- Servidor Telnet compatible para suprimir el echo local y soportar varios formatos de salto de línea (LF, CR-LF, CR-NUL).
- Autenticación de la sesión con contraseña; y bloqueo temporal tras varios intentos fallidos.
- Entrada/salida de USB CDC a bajo nivel debido a que el driver usb_serial_jtag driver de ESP-IDF 5.5.2 tiene un bug. Ver [USB Serial JTAG Read Bug](https://github.com/electronicayciencia/esp32-misc/tree/master/usb_serial_jtag_read).
- Lectura de mensajes en modo desconectado: almacena hasta 64kb de mensajes del sistema y los envía en la próxima conexión para un análisis *post-mortem* si fuera necesario.
