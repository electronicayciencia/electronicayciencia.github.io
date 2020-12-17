---
assets: /assets/2010/05/convertir-palabras-en-numeros-i
layout: post
tags:
- Estadística
- Matemáticas
title: Convertir palabras en números (I)
---

Tenemos herramientas muy potentes para machacar números, calcular medidas estadísticas, gráficos, distancias, etc. Hoy os propongo jugar con algunas de esas herramientas pero aplicadas a las palabras, al **lenguaje**. Claro que las letras no son números, hemos de buscar una función que asigne un número a cada combinación de letras. Hemos de buscar *una aplicación del conjunto de las palabras a los números*.

Nos interesa que las palabras parecidas tengan resultados parecidos, y las diferentes se distancien en el resultado, digamos que de alguna manera nos interesa que sea **lineal**. Sin duda también buscaremos que mantenga un orden, a ser posible que conserve el mismo orden alfabético al que ya estamos acostumbrados.

<!--more-->

Queremos que de cada palabra se obtenga un número distinto. Porque imaginad que dos palabras dan el mismo número. Si tenemos que decir a qué palabra corresponde tal número no podríamos decidirnos por una u otra. O sea que no podríamos volver hacia atrás. Ese tipo de funciones en que un resultado sólo proviene de un origen se llaman **inyectivas**.

Y hacia atrás, nos gustaría que cualquier número que pongamos se pueda traducir en una combinación de letras -que tenga sentido no importa ahora-. Si no hay *huecos* en la imagen, los resultados estarán mejor distribuidos. Una función en la que todos los resultados posibles se corresponden con un origen y no hay ningún resultado "suelto" se llama **suprayectiva** o sobreyectiva.

Las funciones que cumplen las dos propiedades de antes: cada origen tiene un resultado y sólo uno, y cada resultado proviene de un origen y sólo de uno, se llaman **biyectivas**. Pues eso es lo que nos interesa, para convertir las palabras en números y poder luego volver hacia atrás. Tenéis unas ilustraciones a modo de resumen en la [Wikipedia](http://es.wikipedia.org/wiki/Funci%C3%B3n_matem%C3%A1tica#Resumen).

Para los que pasen del álgebra, la función que queremos:

- Puede transformar cualquier palabra en un número.
- Puede volver hacia atrás (tiene inversa).
- En *abc* la letra más importante es la primera, después la segunda, etc. (para mantener el orden alfabético).
- Funciona con palabras de cualquier longitud.

## Bases de numeración

La idea para transformar una palabra en un número y que cumpla todas las propiedades anteriores es simple: voy a tomar cada letra como un símbolo en una base de numeración arbitraria.

Ejemplos de bases tenemos la base 10, cuyo conjunto de símbolos todos conocemos: *{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}*. O la base binaria, que sólo usa *{0, 1}*. O el sistema hexadecimal, que usa un conjunto ampliado de 16 símbolos: *{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F}*

Yo voy a usar el siguiente conjunto: *{@, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z}* y voy a considerar que **cada palabra es un número en base 27**. ¿Por qué la @ al principio si no es una letra? Porque no quiero que la 'a' sea mi cero, si lo fuera palabras como 'Tomas' y 'Tomasa' tendrían el mismo valor numérico. Más adelante esto nos llevará a perder la suprayectividad, pero compensa.

Ahora bien, en *123* el 1 es el más importante, y el 3 el menos. Sin embargo en *abc* queremos justamente lo contrario, que 'a' sea la letra más importante y 'c' la menos. Eso pasa justamente en los números decimales, por ejemplo en *0.123*.

Vamos primero a qué significa un número decimal. Recordemos que 0.125 significa:

    0.125 = 0     +      1x0.1 + 2x0.01  + 5x0.001 
          = 0x10<sup>0</sup> + 1x10<sup>-1</sup> + 2x10<sup>-2</sup> + 5x10<sup>-3</sup>

Es decir, vamos dividiendo la base a cada paso. En el caso de 'abc' eso sería:

    @.abc = 0          + 1x0.037 + 2x0.00137 + 3x0.000051

          = 0x27<sup>0</sup> + 1x27<sup>-1</sup>   + 2x27<sup>-2</sup>      + 3x27<sup>-3</sup>

          = 0.039933

Por que dentro de nuestro conjunto de símbolos, la @ ocupa la posición 0, a = 1, b = 2, etc. Llama la atención cómo la base va disminuyendo rápidamente, así que si queremos representar palabras muy largas necesitamos mucha precisión decimal.

Tal como hacemos la conversión,

    'zzzzzz...' = 0.99999999...

pero 'aaaaa...' no es 0.00000..., eso sería @@@@@@. En realidad

    'aaaaa...' = 0.03846153...

El haber introducido el símbolo extra '@' nos impide llegar a 0 y suma una unidad a la base (haciendo que disminuya más rápidamente), pero a cambio tiene este efecto:

    tom  = 0.761978

    toma = 0.7619793

como hemos dicho esto no ocurriría si la 'a' valiese 0. Al igual que los ceros a la derecha de un decimal no valen nada, la 'a' tampoco valdría nada.

## Posiciones decimales

Una pregunta que surge inmediatamente es ¿cuántos *caracteres en base 10* (números) necesito para representar N *caracteres en base 27* (palabras)?

Si los números no son decimales la respuesta es más facil de ver. Por ejemplo ¿cuantos números en base 2 (cuántos bits) necesito para representar el número 200? Pensemos que cada bit puede representar dos valores (su conjunto sólo tiene dos símbolos). Con N bits prodremos representar 2<sup>N</sup> combinaciones. Como quiero llegar hasta mínimo 200, que es el número que me piden, exigiré que

    2<sup>N</sup> = 200 

y despejaré N. Por la [definición de logaritmo](http://es.wikipedia.org/wiki/Logaritmo) N es el logaritmo en base 2 de 200.

    log<sub>2</sub>(200) = 7.64

necesitaríamos 7 bits y pico, pero como no existe *medio dígito* (a veces se dice que la precisión de un instrumento es de "tres dígitos y medio", pero eso es otra cosa), nos quedamos con el entero superior. Ocho bits nos dan para representar 256 combinaciones, o sea valores de 0 a 255.

Con decimales es más complejo. Podemos aplicar la misma técnica, y es válida. Para representar 1 sóla letra necesitamos 1.43 símbolos en base 10.

    log<sub>27</sub>(10) = 1.43136

pero al pasar un número decimal a otra base puede ocurrir que salga periódico un número que no lo era (y al revés también). De hecho, nuestra base **27 no tiene divisores comunes con 10**, y cualquier *numero decimal en base 27* que expresemos en base 10 va a tener infinitos decimales. Aquí entra en juego otra facilidad que nos da la '@'. Si prohibimos que '@' forme parte de una palabra podemos terminar la conversión en cuanto nos aparezca, aunque aún quede resto. Eso nos permite redondear los resultados sin perder presición.

La técnica que redondeo que utilizo en *pal2num.pl* consiste en multiplicar por 1.43 la longitud de la palabra, y quedarme con esa precisión, redondeando siempre al alza el resultado. Por ejemplo:

    f = 0.222222...
      = 0.23
    
    hola = 0.3174839728...
         = 0.3174840

## Precisión numérica

Pero el mayor problema no está ahí sino en la precisión de los cálculos en coma flotante. Vamos a hacer una prueba, sabemos que 'zzzzzzzzzz...' = '0.99999999...'.

$echo zzzzzzzzzzzzzzzzzzzzzzzzz | pal2num

Es una z, valor 26, base 3.703704E-02, contribucion 0.9629629629629629629**5894739936116480**

Es una z, valor 26, base 1.371742E-03, contribucion 0.03566529492455418381266691631170662

Es una z, valor 26, base 5.080526E-05, contribucion 0.00132093684905756236352230133463195

Es una z, valor 26, base 1.881676E-06, contribucion 0.00004892358700213193939008250007343

Es una z, valor 26, base 6.969172E-08, contribucion 0.00000181198470378266442184724833038

Es una z, valor 26, base 2.581175E-09, contribucion 0.00000006711054458454312673364719404

Es una z, valor 26, base 9.559907E-11, contribucion 0.00000000248557572535344913843282081

Es una z, valor 26, base 3.540706E-12, contribucion 0.00000000009205836019827589401462798

Es una z, valor 26, base 1.311373E-13, contribucion 0.00000000000340956889623244051906030

Es una z, valor 26, base 4.856936E-15, contribucion 0.00000000000012628032949009038958935

Es una z, valor 26, base 1.798865E-16, contribucion 0.00000000000000467704924037371813310

Es una z, valor 26, base 6.662463E-18, contribucion 0.00000000000000017322404593976733826

Es una z, valor 26, base 2.467579E-19, contribucion 0.00000000000000000641570540517656808

Es una z, valor 26, base 9.139181E-21, contribucion 0.00000000000000000023761871871024326

Es una z, valor 26, base 3.384882E-22, contribucion 0.00000000000000000000880069328556457

Es una z, valor 26, base 1.253660E-23, contribucion 0.00000000000000000000032595160316906

Es una z, valor 26, base 4.643185E-25, contribucion 0.00000000000000000000001207228159885

Es una z, valor 26, base 1.719698E-26, contribucion 0.00000000000000000000000044712154070

Es una z, valor 26, base 6.369253E-28, contribucion 0.00000000000000000000000001656005706

Es una z, valor 26, base 2.358982E-29, contribucion 0.00000000000000000000000000061333545

Es una z, valor 26, base 8.736972E-31, contribucion 0.00000000000000000000000000002271613

Es una z, valor 26, base 3.235916E-32, contribucion 0.00000000000000000000000000000084134

Es una z, valor 26, base 1.198487E-33, contribucion 0.00000000000000000000000000000003116

Es una z, valor 26, base 4.438842E-35, contribucion 0.00000000000000000000000000000000115

Es una z, valor 26, base 1.644015E-36, contribucion 0.00000000000000000000000000000000004

0.999999999999999999**837369674127**

Observad cómo a partir del 19º **dígito significativo** lo que queda es ruido de redondeo. Lo vemos ya en la primera conversión en lo que debería ser z = 0.962 periódico. Y eso se refleja en el resultado final, lo que debería ser 0.9 periódico sólo lo es hasta cierto punto. Como nuestro alfabeto es de 26+1 elementos (26 letras más la @), necesitamos 1.431 dígitos por carácter. Con los 18 dígitos decimales que nos da la precisión *double* podemos representar 19/1.431 = 12.57 caracteres. Una muestra:

$echo aaaaaaaaaaaaa | pal2num

Es una a, valor  1, base 3.703704E-02, contribucion 0.037037037037037037

Es una a, valor  1, base 1.371742E-03, contribucion 0.001371742112482853

Es una a, valor  1, base 5.080526E-05, contribucion 0.000050805263425291

Es una a, valor  1, base 1.881676E-06, contribucion 0.000001881676423159

Es una a, valor  1, base 6.969172E-08, contribucion 0.000000069691719376

Es una a, valor  1, base 2.581175E-09, contribucion 0.000000002581174792

Es una a, valor  1, base 9.559907E-11, contribucion 0.000000000095599066

Es una a, valor  1, base 3.540706E-12, contribucion 0.000000000003540706

Es una a, valor  1, base 1.311373E-13, contribucion 0.000000000000131137

Es una a, valor  1, base 4.856936E-15, contribucion 0.000000000000004857

Es una a, valor  1, base 1.798865E-16, contribucion 0.000000000000000180

Es una a, valor  1, base 6.662463E-18, contribucion 0.000000000000000007

Es una a, valor  1, base 2.467579E-19, contribucion 0.000000000000000000 **No contribuye**

0.038461538461538462

El 13er carácter no aparecerá a menos que sea muy alto, porque son 12.57 caracteres, no 12 exactos. De nuevo el haber incluido un carácter extra en el conjunto nos ayuda a mitigar el efecto del error acumulado en las operaciones. Como la aplicación deja de ser suprayectiva, ese *hueco* en el dominio imagen introduce un rango de valores que no provienen de una palabra válida, son los que van desde '@a' a '@zzzzz...'.

Esta entrada es de por sí muy abstracta. Así que para no hacerme pesado prefiero continuar con una segunda parte. Os dejo los archivos por si alguno quiere hacer pruebas. Están en [este enlace]({{page.assets | relative_url}}/pal2num.rar) y podéis encontrar:

- **pal2num.pl**: Es el archivo en Perl que sirve para hacer el estudio. Admite datos por la entrada estándar. Si se le pasa una palabra devuelve su correspondiente número decimal (con la precisión adaptada y el redondeo adecuado a la longitud como he explicado antes). Si se le pasa un número devuelve la palabra origen, si existe.
- **pal2num.c**: Versión simplificada del anterior. Optimizada para hacer conversiones masivas rápidamente.
- **pal2num**: Binario compilado de *pal2num.c*.
- **dominio_espectral.pl**: Dado un texto separa sus palabras, y dibuja un gráfico con el espectro de frecuencias. Lo usaremos en la siguiente entrada.
- Directorio **textos**: Varios textos para probar. Versiones de El Quijote en español, francés e inglés. Y diccionarios de inglés y español obtenidos de OpenOffice.
- Directorio **imágenes**: Algunos gráficos generados por *dominio_espectral.pl*.
