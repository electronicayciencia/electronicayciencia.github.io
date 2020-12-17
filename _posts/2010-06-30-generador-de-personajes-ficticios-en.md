---
assets: /assets/2010/06/generador-de-personajes-ficticios-en
layout: post
tags:
- Informática
title: Generador de personajes ficticios en Perl
---

De vez en cuando escribo historias de intriga para jugar a modo de rol con los amigos. Cuando uno escribe una historia llega un momento en que tiene que poner nombre a los personajes. Inventarse nombres ficticios y realistas es difícil. Cualquiera puede poner nombre a un personaje, pero si necesitas varios te puede llevar cierto tiempo.

Yo personalmente no tengo imaginación ninguna para poner nombre a las cosas, ya veis el título del blog. Así que hace tiempo busqué en Google listas de personas con nombre y apellido, listas de oficios y empleos, calles de una ciudad grande, y tipos de vía para lo que usé un callejero que encontré. Con eso alimenté una base de datos **sqlite**. Luego hice un sencillo módulo en **Perl** con unas cuantas funciones para utilizarla y listo: un versátil generador de personajes.

El programa funciona seleccionando al azar un nombre y dos apellidos; una vía y un nombre de vía; un número y una letra; y un oficio. Con eso compone nombre, dirección y ocupación del personaje. Además los nombres y los oficios no están filtrados, así al hacer una búsqueda al azar es más probable que aparezcan aquellos que sean más comunes, tal como ocurriría en la realidad.

Por ejemplo, en una historia sucede un juicio. Algunos personajes pueden tener relevancia más adelante, pero el resto sólo aparecen esta vez, y no merece la pena dedicarle mucho tiempo. Sin contar con que eso puede distraerte y hacerte perder otras ideas.

* **Juez:** Dña. Susana García Perón

* **Comparecen por parte de la Acusación:**- **Abogado:** Blanca Gomez Alcala. Calle Kindelan 9, 6ºD.- **Testigos:**Sabina Diaz Ordoñez. Calle Blanqueo Viejo 12, 4ºD. Agente de seguros.Hannah Rachel Montilla Madrid. Carretera De La Zubia 3, 2ºE. Recepcionista.Domingo Bonillo Jimenez. Calle Aire 18, 2ºD. Médico forense.Escolástico Herranz Barron. Cuesta Aljibe De Trillo 5, 5ºH. Herrero.

* **Comparecen por parte de la Defensa:**- **Abogado:** Eduardo Martin Villar. Calle Pianista Rosa Sabater 18.- **Testigos:**Maria Isabel Almansa Flores. Calle Sancti Spiritus 2. Psicólogo.Virginia Lopez Sedeno. Calle Francisco Hurtado Izquierdo 16, 6ºH. Deportista.

En otra ocasión lo que necesitamos es sólo una lista de empleados de una compañía, u otro tipo de lista donde no necesitamos todos los datos. Para eso hay variedad de funciones en el módulo:

**getNombre:** Antonio**getApellido:** Jabalquinto**getNombreCompleto**: Jose Tomas Dodero Ruiz**getCalle**: Calle Tiberio**getCalleyNumero**: Callejon Del Pretorio 14**getProfesion**: Camarera**getPersona**: Eloy Garcia Almendro. Calle Correo Viejo 8. Actor.

**getNombresCompletos:**1.- M Cristina Lopez Barba2.- Emilio Jesús Gomez Pescuezo3.- Pablo Jimenez Caro4.- Jose-Maria Montiel Garcia5.- M Trinidad Jimenez Bravo

**getPersonas:**1.- Carmen Maria Molero Padilla. Placeta Fernandez De Moratin 7, 4ºF. Guía turístico.2.- Eugenia Jimenez Lopez. Calle Tio Vazquez 21. Abogado de oficio.3.- Antonio Jose Veredas Ariza. Calle Pisas 23, 2ºC. Supervisor.4.- Sonia Moreno Lachica Millan. Calle Albondon 24. Esteticista.5.- Paloma Rider Jimenez. Calle Parra De San Cecilio 13. Recepcionista.

Para asignar edad sólo tendríamos que generar un número aleatorio en el margen que necesitemos. Cuidando, eso sí, de adaptar el oficio y la edad a las circunstancias. Por ejemplo no es realista que un niño de 12 años sea astronauta, o que una señora de 76 trabaje como herrero. No es imposible, pero desde luego sería inusual y eso **distrae la atención** del receptor, pues este pasa a fijarse más en el personaje que en la historia. Claro que a veces es eso lo que se pretende.

Sin embargo el módulo no tiene el cuenta ni las tildes ni la concordancia de género a la hora de asignar oficio, así un señor llamado Manolo podría aparecer como actriz. Hay que tener cuidado con eso y siempre repasar manualmente las listas que genere el programa.

Os dejo los archivos y la base de datos en [esta dirección]({{page.assets | relative_url}}/AleaNombres.rar). Necesitaréis Perl y sqlite. No descarto más adelante convertirlo en un CGI y colgarlo online.
