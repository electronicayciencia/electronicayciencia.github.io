---
assets: /assets/2010/11/decodificar-aiken-biphase-con-perl
image: /assets/2010/11/decodificar-aiken-biphase-con-perl/img/acelerando.png
layout: post
tags:
- Binario
- Experimentos
- Informática
title: Decodificar Aiken Biphase con Perl
---

Antes de nada quería mandar un saludo a Explorer de [perlenespanol.com](http://perlenespanol.com/). Porque, sin conocernos previamente, se ve que le gustan mis artículos. Pues casi desde que empecé con el blog todo lo que escribo que tenga que ver con Perl acaba reseñado en su foro.

Ya hemos codificado y decodificado una señal digital otras veces para extraer información. Hemos decodificado señales NRZ, Manchester, etc. Hoy vamos a hablar de un tipo de señal llamado FM1, Biphase Mark Code (BMC) o también Aiken Biphase. Es un tipo de FSK ampliamente utilizado. Vamos a ver uno de los sitios donde se usa y lo usaremos como ejemplo para construir un programita que lo decodifique.

El soporte de datos que vamos a usar como ejemplo nos exigirá hacer uso de la característica de *auto sincronía (self clocking)* de la señal. Si seguís leyendo ya veréis el motivo.

## Self Clocking

En la mayoría de circuitos digitales hay un mecanismo de coordinación de todo el esquema. Un reloj. No es más que oscilador de onda cuadrada a una frecuencia fija, pero hace que los componentes actúen como un todo. Y lo que es más importante, puedan interactuar con otros sistemas digitales.

Pero los osciladores no son tan exactos como nos gustaría. Los relojes se atrasan y se adelantan, los sistemas se descoordinan y la transmisión de información falla. Pero hay una forma fácil de evitarlo: hacer que en cada bit, ya sea uno o cero, la señal cambie de estado. Así el receptor reconoce fácilmente cuando empieza y cuando acaba cada bit, y si el transmisor tiene una deriva temporal puede adaptarse a ella.

Vamos a ver un ejemplo de esto que os digo. En una codificación *Aiken Biphase* la frecuencia del cero es la mitad que la del uno. En el gráfico siguiente hay un pico de señal en cada transición. Es decir, dos picos juntos es un uno, dos picos separados es un cero. Veremos esto más despacio pues por ahora lo que me interesa que veáis es cómo hacia el final se van juntando los impulsos.

{% include image.html size="big" file="acelerando.png" caption="" %}

Pinchad para ampliar la imagen. Fijaos que lo que hay al comienzo y al final son ceros. Y entre medias hay algunos unos. Pero los ceros del final están más juntos que los del principio. Es decir que la trnasmisión se ha ido acelerando en el tiempo. Y si el receptor no se adapta, e insiste en interpretar la señal del final con el mismo patrón que la del principio acabará detectando los ceros más juntos como unos.

Como ya lo sabemos, nuestro programa tiene que irse adaptando a la velocidad de la señal en tiempo real, tanto si se acelera como si desacelera, dentro de unos márgenes, porque si no lo más probable es que falle.

¿Pero por qué tanto insistir en este aspecto? Un oscilador puede tener cierta deriva temporal, pero no tanto. Pasará desapercibido a menos que sean velocidades muy altas. El problema viene cuando mezclamos lo digital con lo analógico.

La señal del gráfico anterior es la lectura de una **banda magnética** de una tarjeta de identificación. Obtenida al recorrer la banda con un cabezal lector de un casete (un *fonocaptor magnético* para ser pedantes). La aceleración viene por el hecho de que es muy difícil mover el brazo a una velocidad constante; aunque con práctica se consigue, sería de vagos no aprovechar el *self clocking* de la señal que precisamente está para eso.

## Bandas magnéticas

Por si os ha sorprendido: sí, se puede. Con un cabezal de cinta se pueden leer y hasta grabar tarjetas de identificación o de crédito, billetes de aparcamiento y cualquier otro soporte que use banda magnética para almacenar datos. Hay mucha información en Internet y experimentos. Si os interesa el tema os recomiendo especialmente una página que de haberla descubierto antes me habría ahorrado un montón de trabajo: [http://www.gae.ucm.es/~padilla/extrawork/stripe.html](http://www.gae.ucm.es/%7Epadilla/extrawork/stripe.html).

Casi todas las tarjetas se adhieren a un formato concreto. Por la sencilla razón de que es más fácil implementar una norma que ya está hecha y se usa, que diseñar un sistema desde cero. No obstante también los hay que usan sus propios [formatos no estándar](http://www.gae.ucm.es/%7Epadilla/extrawork/magexam2.html). Por lo general casi siempre se usa Aiken Biphase pero no es el único sistema.

Doy brevemente unas pinceladas sobre cómo se graba la información en una banda magnética para que entendáis de dónde viene la forma de la señal que vamos a tratar. El siguiente dibujo está sacado de [http://www.gae.ucm.es/~padilla/extrawork/card-o-rama.txt]({{page.assets | relative_url}}/card-o-rama.txt). La cabeza grabadora/lectora es simplemente un anillo de un metal ferromagnético pero no cerrado, sino con un hueco diminuto en la pate que se expone a la cinta. Hay un cable que está enrollado al anillo, con muchas muchas espiras, y es con el que captaremos la señal, o la grabaremos.

    >

```
                        | |  <----cables al amplificador      
                        | |       (se enrollan al anillo)
                      /-|-|-\
                     /       \
                     |       | <----solenoide (acaba de cambiar la polaridad)                           
                     \       /
                      \ N S / <---hueco en el anillo
N----------------------SS-N-------------------------S
                       ^^  
             <<<<<-la banda se mueve en esta dirección
```

Imaginaos la banda como millones de micro-imanes todos seguidos. Si no hay nada grabado todos los imanes están orientados en la misma dirección. N es el polo norte del imán y S el polo sur. Así:

    N---------------------------------------------------S>

Para grabar información digital lo que hacemos recorrer la banda con el solenoide e ir cambiando la polaridad cuando nos interese invertir el flujo.

    N---------S S-------N N----------S S---------N N----S>

Cuando recorremos la banda con la cabeza de lectura los imanes cierran el anillo y fijan una dirección del flujo magnético, que se establece de acuerdo al dominio magnético con el que esté en contacto el cabezal en ese momento.

    >

```
            /-|-|-\
           /       \
           |       | <----solenoide 
           \       /
            \ N S / 
N--------------------S S--------------N N-----------S
```

Ahora avanzamos por la cinta y nos encontramos con un cambio en la polaridad magnética. Como el flujo que atraviesa el anillo lo fija la banda magnética, se invierte, y pasa de ser N-S a S-N.

    >

```
                           /-|-|-\
                          /       \
                          |       | <----solenoide 
                          \       /
                           \ S N /  (ha cambiado la dirección)
N--------------------S S--------------N N-----------S
```

Y ya sabíamos que al cambiar el flujo magnético en un solenoide se induce una corriente eléctrica. En este caso va a ser muy débil, pero suficiente para detectarla. Cuando avanzamos más vuelve a cambiar el flujo y se induce una corriente en el otro sentido.

Ya os habéis dado cuenta de que sólo se induce cuando cambia el flujo, y ese cambio va a ser casi instantáneo. Así que esperamos ver picos puntuales. Pero ya sabéis que en la naturaleza **la línea recta no existe**, y en la electrónica [menos aún](http://en.wikipedia.org/wiki/Gibbs_phenomenon). Luego lo que vamos a ver es esto:

{% include image.html size="big" file="captura010_sep.png" caption="" %}

Ya veis la que la regla del Aiken Biphase es sencilla, os pego esta imagen de la Wikipedia.

{% include image.html size="medium" file="bmc.png" caption="" %}

## Preamplificador de entrada

Hemos dicho que no se necesita electrónica ninguna para conectar el lector a la tarjeta de sonido. Salvo un condensador, porque si recordáis como es [la entrada]({{site.baseurl}}{% post_url 2010-10-20-medir-valores-logicos-con-tarjeta-de %}) de una tarjeta de sonido sabréis que si lo conectáis tal cual hay una corriente continua atravesando el lector. Con tan mala suerte que es bastante para **borrar** el contenido de la banda magnética. Así que no sólo no leeréis nada sino que borraréis lo que hubiera escrito.

Aunque no es necesario un amplificador, yo sí voy a utilizarlo porque facilita captar correctamente la señal. Este es el circuito, que como veis no es más que un amplificador inversor que [habíamos explicado ya]({{site.baseurl}}{% post_url 2010-05-28-preamplificador-microfono-electret %}). Este tiene una ganancia de 7.5 veces aproximadamente. Los componentes no son críticos, sirve casi cualquier operacional y las resistencias que tengáis por el taller.

{% include image.html size="medium" file="amplificador.png" caption="" %}

El condensador de entrada merece mención aparte. Si usamos capacidades muy bajas, por debajo de 47nF vamos a hacer que las frecuencias bajas estén muy atenuadas. Y el *valle* que hay entre los picos se deformará apareciendo un pico secundario a modo de rebote. Y el lector se va a confundir con esos picos. En cambio si usamos una capacidad alta por encima de 10uF la forma de la onda no se va a deformar apenas, y los picos aparecerán claros y contundentes. Pero también se van a colar ruidos de baja frecuencia que hacen que el tren de pulsos suba y baje como en una montaña rusa. Aunque el algoritmo adaptativo que os presento tolera esas variaciones, si podemos es mejor que nos las quitemos. Yo he hecho las pruebas con una capacidad de 470nF y funciona aceptablemente.

## Tratamiento digital previo

Conectando la cabeza lectora a la entrada de micro de la tarjeta ya llega con suficiente señal para detectarla bien. Aunque para las pruebas he utilizado un pequeño [amplificador operacional]({{site.baseurl}}{% post_url 2010-05-28-preamplificador-microfono-electret %}) a la entrada.

Os cuento ahora algunos pasos que damos en la detección para que entendáis mejor el programa que sigue. Lo primero que vamos a hacer es tomar el valor absoluto de la señal recibida. Porque sólo nos interesa saber cuando hay un pico. Si es positivo o negativo no nos importa. Lo segundo es pensar si filtramos la señal. Como siempre que nos interesa detectar picos, una solución socorrida es elevar la señal a alguna potencia para aumentar la relación señal-ruido. Esta es la señal en valor absoluto:

{% include image.html size="big" file="vabsoluto.png" caption="" %}

La imagen que sigue es al cuadrado. Vemos que el ruido ha disminuido y los picos están más claros. Observad el cambio de escala porque estamos elevando valores menores que uno.

{% include image.html size="big" file="vcuadrado.png" caption="" %}

Pero hay que tener cuidado con esta técnica. Primero porque en un ordenador es muy fácil elevar a una potencia, pero si usamos un integrado tipo PIC o DSP es bastante más chungo. Y segundo porque tiene sus desventajas. Esta es la misma señal a la cuarta potencia:

{% include image.html size="big" file="vcuarta.png" caption="" %}

Mirad como se amplifica la diferencia entre los picos. Esta técnica viene muy bien si lo que hacemos es fijar un umbral y todo lo que hay por encima decimos que es un pico.

Una de las decisiones más difíciles es dónde colocar el **umbral del ruido**. Cuando tenemos el archivo completo delante de nuestras narices lo vemos clarísimo, pero de alguna manera tiene que saber el programa que empieza una lectura y no es ruido.

En el programa de debajo vamos a usar un método adaptativo que tiene en cuenta dos cosas. Por un lado hay un umbral de ruido que tiene un cierto valor que nosotros le damos. Más o menos en función de lo ruidoso que sea el ambiente y de la ganancia del preamplificador. Y por el otro lado hay una variable que llega hasta 0.6 veces el valor del pico anterior. Fijamos el umbral en el más alto de esos valores. Así cuando hay una señal fuerte el umbral se sube automáticamente y evitamos captar nada que no sean picos.

Nuestra mala suerte es que ese algoritmo de ajuste no funciona bien si hacemos lo de elevar al cuadrado. Así que no alteraremos la señal de entrada.

## El algoritmo

Ya hemos nombrado antes dos parámetros que varían: uno es la distancia entre picos (o la frecuencia de reloj, o la velocidad, o como queráis llamarlo); y otro la amplitud de la señal. Francamente nos interesa mucho más el primero porque el segundo es cuestión de fijar un umbral a mano y ya está. El tiempo como tal no nos interesa, lo que vamos a mirar es la distancia en muestras. Si la frecuencia de de muestreo es de 44100Hz quiere decir que cada 44100 muestras habrá transcurrido un segundo, pero eso también nos da igual.

Para controlar el tiempo no podemos (o no debemos) fiarnos de la última medida, porque pudiéramos estar en un error y alterar los bits siguientes. Así que lo que hacemos es usar una [media móvil exponencial](http://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average) de los últimos bits leídos. Es una especie de filtro IIR paso bajos para que una mala lectura no cause estragos. En cuanto leemos un bit y determinamos si es un CERO o un UNO realimentamos la variable. Como las aceleraciones o deceleraciones no son bruscas sino que son graduales, a la media móvil le da tiempo de adaptarse bit a bit. Aunque los bits finales estén mucho más juntos o mucho más separados que los del principio, como el cambio se ha hecho poco a poco el tiempo entre UNOS (que es como llamamos a la variable) se ha ido adaptando progresivamente.

Ya hemos visto antes cómo decodificarlo. Pero yo lo voy a hacer de otra manera aprovechando que tengo un ordenador con un lenguaje de alto nivel y no un integrado. Llamadme vago. Voy a considerar que es un UNO cuando el impulso siguiente venga separado una distancia (en muestras) *parecida* a *Tuno* y que es un cero cuando venga a una distancia *parecida* al doble de *Tuno*. La desventaja es que los UNOS me salen duplicados, porque un UNO son dos picos juntos, que yo detectaré como dos unos separados. Pero no os preocupéis que lo arreglamos después. Lo he hecho así porque viene muy bien para leer bandas con formato desconocido, que pueden no ser Aiken Biphase.

Hemos hablado antes de una duración *parecida* a *Tuno* o al doble de *Tuno*  ¿Pero cuánto es parecida? Bueno pues vamos a tomar un criterio sencillo. Tomamos tres valores:

    el valor es        Tuno

    su mitad es    1/2*Tuno

    y su doble es    

*2*Tuno*

Al principio *Tuno* puede ser la duración del CERO o del UNO (hablamos de esto en el párrafo siguiente). Si recibimos una duración entre pulsos equivalente a *Tuno* diremos que es el mismo carácter que tiene *Tuno*. Si sabemos que eran UNOS pues diremos que llega un UNO. Si llega una duración equivalente al doble, diremos que hemos recibido un CERO. Pero si llega una duración equivalente a la mitad de *Tuno* pueden pasar dos cosas: durante la inicialización servirá para discriminar que *Tuno* era en realidad el tiempo del CERO y no del UNO. Pero pasada la etapa de inicialización se tratará de un error. Lo mismo que si la medida supera el doble. Así dado un tiempo t tenemos 5 intervalos:

    error si            t < 1/4*Tuno 
    mitad si 1/4*Tuno < t <= 3/4*Tuno
    igual si 3/4*Tuno < t <= 3/2*Tuno
    doble si 3/2*Tuno < t <= 5/2*Tuno
    error si 5/2*Tuno < t 

Pero ¡un momento! Habrá que inicializar *Tuno* de alguna manera. Generalmente al principio de la lectura se repite mucho uno de los dos bits, que suele ser CERO para que el receptor se entere de la velocidad de transmisión. Vamos a intentar dar una vuelca de tuerca y a hacer que nuestro decodificador sea inteligente y sepa cuándo los caracteres iniciales sean CEROS y cuando UNOS. Pero eso no lo puede saber hasta que no encuentre un bit diferente. Si este dura la mitad es que lo de antes eran CEROS. Pero si dura el doble es que lo de antes eran UNOS. Por eso al empezar a leer estamos leyendo caracteres "T", que no sabemos si son UNOS o CEROS hasta leer otro diferente para poder comparar.

Cuando ya tenemos una cadena de unos y ceros se la pasamos a las rutinas que decodifican los formatos conocidos. No voy a entrar en cómo calcular la paridad ni el bit de LRC. Si os interesa hay mucha información. Lo que me gustaría es que os fijarais en que se usa paridad IMPAR. Y es por una razón muy sencilla si lo pensáis. Con paridad PAR un *byte*  que sea 0, o sea todo CEROS, su bit de paridad también es CERO. Con lo que si tenemos muchos *bytes* 0 seguidos nos encontramos con una cadena de bit 0 todos iguales. En cambio usando paridad IMPAR el bit de paridad es 1, así que se obliga a que por lo menos uno de los bits del grupo sea distinto. Y así se favorece la sincronía. Un ejemplo con grupos de 5 bits + 1 de paridad.

    Paridad par (siempre el mismo bit):>
    000000 000000 000000 000000 000000>
    >
    Paridad impar (se obliga a un bit distinto):>
    000001 000001 000001 000001 000001>

## El programa

Pego el programa, parece largo pero quiero dejarlo íntegro porque está muy comentado. Os doy unas pinceladas breves y si decidís que os interesa ampliáis información leyendo en los comentarios en el código.

Así por encima, distinguimos cuatro partes:

- **Inicio**, hasta la linea 67. Donde abrimos el dispositivo del que leeremos las muestras, ya sea un archivo de disco o la tarjeta de sonido.
- **Bucle principal.** Hay una rutina nada más empezar el bucle que se para hasta detectar un pico. Es decir que el bucle sólo reacciona a los picos de señal. Fijaos cómo los primeros picos sólo se usan para inicializar variables y a medida que llegan más picos vamos avanzando y llegando más adentro en el bucle. Hasta que del tercer pico en adelante ya pasamos a la parte donde se discrimina la duración para ver si es un UNO o un CERO.
- **Rutinas de la señal.** Aproximadamente entre las líneas 199 y 324. Tratan diversos aspectos de la señal que aún es sonido.
- **Rutinas de decodificación.** Cuando la señal ya no es sonido sino una hilera de bits, entonces pasamos a decodificarla.

Tenemos una variable que activa o desactiva el modo depuración. Cuando el script está en modo depuración escribe por pantalla abundante información sobre cuándo ha detectado un pico, de qué duración, en qué muestra, etc.

Como ejercicio si te interesa, intenta buscar la respuesta a estas preguntas (casi todo está en los comentarios):

- ¿Cual es el criterio de intervalos para *Tuno* y por qué se ha hecho así?
- ¿Donde se hace la realimentación de las medias móviles y por qué sólo ahí?
- ¿Donde se aplica la histéresis al Umbral de ruido?

```perl
#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  decodifica.pl
#
#        USAGE:  ./decodifica.pl [fichero.wav]
#                Si no se da fichero.wav se lee del dispositivo de grabación hw:0,0.
#
#  DESCRIPTION:  Recibe un archivo de sonido e intenta decodificar la información que 
#                contiene la banda magnética.
#
#                Esta utiliza los picos y medias móviles para adaptarse a la velocidad
#                de lectura variable.
#
#      OPTIONS:  ---
# REQUIREMENTS:  sox
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Reinoso Guzman
#      VERSION:  1.0
#      CREATED:  14/11/10 12:16:09
#===============================================================================

use strict;
use warnings;
use List::Util qw(max);

my $alphaVpico = 0.33;    # Para la media móvil del nivel de pico.
                          # Si la sigue mucho se va hasta el nivel de ruido
           # y no corta la lectura.        
my $alphaTuno  = 0.33;    # Para la media móvil del intervalo del UNO.
my $umbralInicial = 0.4;

my $debug = 0;


my $file = $ARGV[0];
if ($file and ! -e $file) {
 die "El fichero $file no existe o no se puede leer.\n";
}

my $data;
if ($file) {
 open $data, "sox $file -t dat - |" or die "Error: $!\n";
}
else {
    $ENV{AUDIODEV} = "hw:0,0";
 open $data, "rec -q -r 48000 -t alsa hw:0,0  -t dat - |" or die "Error: $!\n";
}


my $muestra;     # No usamos el tiempo sino cuantas muestras,
                 # así no depende de la velocidad de lectura.
                 # Esta variable cuenta por qué muestra vamos.

my $nbits;       # Para contar cuantos picos van.
my $Tuno;        # Tiempo del 1, el del 0 será el doble (media movil).
my $Vpico;       # Valor de pico (media movil).

my $last_pico;   # Para calcular el tiempo entre transiciones
my $string;      # Cadena leída, por ahora vacía.
my $trailChar;   # Caracter inicial a priori no sabemos si es 0 o 1
my $umbral;      # Lo inicializamos más adelante
my $leyendo;     # Indica si estamos en mitad de una lectura

inicializar();

while (1) { # sale cuando get_sample se quede sin datos
 my $intervalo; # duración entre el pico anterior y el proximo que encontremos.

 espera_senal() or next;
 my ($pos_pico, $valPico) = procesa_pico($data);

 # Estamos en el primer pico, aún no tenemos la mitad de las variables
 # definidas. Definimos los valores iniciales y no hacemos nada más.
 if (not defined $last_pico) {
  $last_pico = $pos_pico;
  $Vpico     = $valPico;
  print "\n------------- Comienza nueva lectura en la muestra $muestra.\n";
  $leyendo = 1;

  # Bajamos el umbral en cuanto llega el primer impulso para
  # intentar captar los demás.
  $umbral = 0.70*$umbralInicial;
  # No seguimos.
  next;
 }

 # Está definido last_pico, luego ya ha habido un pico anterior y
 # este puede ser del segundo en adelante. Ya podemos hablar de intervalo
 # entre dos picos.
 $intervalo = $pos_pico - $last_pico;
 print "Pico en $pos_pico.   Duración: $intervalo.   Valor: $valPico.\n" if $debug;
 
 # Si el pico dura muy poco (menos que 3 muestras) es sospechoso de ser debido
 # al ruido. Si además el valor es muy próximo al umbral lo ignoramos.
 # Consideramos corta duración si es menor que 1/4 de Tuno, pero puede no estar
 # definido Tuno. En ese caso que dure menos de 1/4*24 = 6 muestras.
 if ($intervalo < 1/4*($Tuno||24) and $valPico <= 1.1 * $umbral) {
  print "Pico ingnorado\n" if $debug;
  next;
 }

 # Si hemos llegado aquí se trata de un pico válido. Actualizamos. 
 $last_pico = $pos_pico;

 # Si aún no está definido $Tuno Estamos en el segundo pico: 
 # lo inicializamos al primer intervalo que pillemos. Y luego veremos si eran
 # cero o eran unos.
 if (not defined $Tuno) {
  $Tuno = $intervalo;
  $string .= $trailChar; # no sabemos cual es el caracter inicial.
  next;
 }


 # Este es a partir del tercer pico, ya tenemos una referencia con la que comparar.
 # Juzgamos si es de la misma duración que el anterior del doble o de la mitad.

 # La duración t puede ser:
 #   1/2T   si  1/4T < t <= 3/4T
 #      T   si  3/4T < t <= 3/2T
 #     2T   si  3/2T < t <= 5/2T
 #   indefinida en otros casos.
 
 # Es de la misma duración que Tuno
 if ($intervalo > 3/4*$Tuno and $intervalo <= 3/2*$Tuno) {
  # Si aún no hemos recibido nada diferente para comparar no sabemos
  # si Tuno es la duración del UNO o del CERO.
  if ($trailChar eq "T") {
   $string .= $trailChar;
  }
  # Si ya sabemos que Tuno es del uno pues lo ponemos
  else {
   $string .= "1";
  }
  
  $Tuno  = $alphaTuno  * $intervalo + (1-$alphaTuno)  * $Tuno;
  $Vpico = $alphaVpico * $valPico   + (1-$alphaVpico) * $Vpico;
 }

 # Recibimos un símbolo de duración el doble: un CERO
 elsif ($intervalo > 3/2*$Tuno and $intervalo <= 5/2*$Tuno) {
  # Confirmamos, si no lo sabíamos, que Tuno es el tiempo del UNO
  # porque acabamos de recibir un CERO.
  if ($trailChar eq "T") {
   $trailChar = "1";
   $string =~ s/T/$trailChar/g;
  }
  # Y añadimos el CERO recién recibido a la vez que realimentamos
  # la media móvil que lleva el tiempo del UNO.
  $string .= "0";
  $Tuno  = $alphaTuno  * $intervalo/2 + (1-$alphaTuno)  * $Tuno;
  $Vpico = $alphaVpico * $valPico     + (1-$alphaVpico) * $Vpico;
 }

 # Recibimos un símbolo de duración la mitad: un UNO
 elsif ($intervalo > 1/4*$Tuno and $intervalo <= 3/4*$Tuno) {
  # Si no sabíamos cual era el caracter inicial eso quiere decir que son 
  # CEROS y no UNOS. Porque acabamos de recibir el primer UNO.
  # Así que rectificamos la cadena y la duración del UNO.
  if ($trailChar eq "T") {
   $trailChar = 0;
   $string =~ s/T/$trailChar/g;
   $Tuno = $Tuno / 2; # Rectificamos la duración
  
   $string .= "1";
   $Tuno  = $alphaTuno  * $intervalo + (1-$alphaTuno)  * $Tuno;
   $Vpico = $alphaVpico * $valPico   + (1-$alphaVpico) * $Vpico;
  }

  # Pero si ya habíamos determinado la duración del UNO y nos llega un
  # pulso que dura la mitad, es que hay algo que está mal. 
  # Se tratará de un error.
  else {
   $string .= "M";
  }
 }

 # Dura más o menos de lo esperado, se trata de un error, hemos perdido algo.
 # Evitamos alimentar $Tuno con una medida errónea y con suerte el resto de
 # bits los recibiremos correctamente.
 elsif ($intervalo < 1/4*$Tuno) {
  $string .= "_";
 }

 elsif ($intervalo > 5/2*$Tuno) {
  $string .= "^";
 }

 print "Tuno = $Tuno      Vpico = $Vpico      Umbral = ". max($umbral, 0.7*($Vpico||0))."\n" if $debug;
}


print "\n";



# Sale en cuanto haya una señal.
# Mientras Vpico está si definir sólo cuenta el umbral
# Si pasa mucho tiempo con ruido decimos que es otra lectura diferente
sub espera_senal {
 my $muestras_ruido = 0;
 my $valor;
 while (defined ($valor = get_sample($data)) and $valor < max($umbral, 0.6*($Vpico||0))) {
  $muestras_ruido++;
  # El tiempo del cero tiene que ser como mucho el doble que el del uno
  # pero si pasa el triple asumimos que se ha terminado la lectura.
  if ($leyendo and defined $Tuno and $muestras_ruido > 3*$Tuno) {
   print "Ruido durante $muestras_ruido > 3*$Tuno\n" if $debug;
   fin_lectura(); # des-define Tuno y saldría del bucle
   return undef;
  }
  elsif ($leyendo and not defined $Tuno and $muestras_ruido > 100*44100/1000) {
   print "Ruido durante $muestras_ruido\n" if $debug;   
   fin_lectura();
   return undef;
  }
 }
 return $valor;
}


# Procesa lo que es un pico, devuelve la posición y el valor máximo
sub procesa_pico {
 my $maximo   = $umbral;  # Valor de pico
 my $posicion = $muestra; # Posición del pico
 my $valor    = 0; # Valor de la muestra actual
 print "Entra pico: $muestra " if $debug;
 while (($valor = get_sample($data)) > max($umbral, 0.6*($Vpico||0))) {
  if ($valor >= $maximo) {
   $posicion = $muestra;
   $maximo   = $valor;
  }
 }
 print "Sale pico: $muestra.    Valor: $maximo en $posicion\n" if $debug;
 return ($posicion, $maximo);
}


# Inicializa las variables para una nueva lectura
sub inicializar {
 print "Variables reseteadas.\n" if $debug;
 $last_pico = undef;
 $Tuno      = undef;
 $string    = "";
 $Vpico     = undef;
 $trailChar = "T";
 $leyendo   = 0;

 # El umbral tiene histéresis:
 #   Cuando no estamos leyendo es un 10% superior al fijado.
 #   Pero en cuanto se detecte la primera señal bajamos al 75%
 #   por si luego llegan señales débiles.
 $umbral    = $umbralInicial * 1.1;

 printf "Umbral de señal fijado en %3.4f\n", $umbral if $debug;
}

# Obtiene una muestra a partir del descriptor abierto
# Lee la línea y extrae la información arpopiada.
# Incrementa la posición contando una muestra más.
sub get_sample {
 my $data = shift;

 my $linea;
 while ($linea = <$data>) {
  next unless $linea;

  my (undef, $time, $valor) = split /\s+/, $linea;
  next unless $time =~ /\d+/; # Saltar las lineas no numéricas.
  
  # Preprocesamos la señal para hacer más evidentes lo picos.
  $valor = abs($valor);
  #$valor = 0.90*$valor + (1-0.90)*$valor_old;
  #$valor = $valor*$valor*$valor;

  $muestra++;
  return $valor if defined $valor;
 }

 
 print "Fin de los datos en la muestra $muestra\n";
 fin_lectura();
 exit; # Se acabaron los datos.
}


sub fin_lectura {
 # No hace nada si no estábamos leyendo.
 return undef unless $leyendo;

 # Si estábamos leyendo termina.
 print "Terminamos en la muestra $muestra\n";
 if ($string and length $string > 10) {
  #print "String: $string\n";
  print_data_stream($string);
  print "-------------------------------------------------------\n\n";
 }
 else {
  print "Lectura vacía.\n" if $debug;
 }

 inicializar();
}



sub print_data_stream {
 my $string = shift;

 $string =~ s/11/1/g; # apaño porque los 1 salen en parejas
 my $bits = length($string);
 print "Crudo: $string\n";
 print "Bits: $bits\n\n" if $bits;


 # Intentamos decodificarla con todo lo que podría ser.
 # Y comprobamos los bit de paridad, lrc, etc
 my ($decoded, $chars, $perrors, $LRCerror);
 
 ($decoded, $chars, $perrors, $LRCerror) = decode_ALPHA($string);
 if ($decoded) {
  printf "Formato:            ALPHA\n";
  printf "Caracteres:         $chars\n";
  printf "Errores de paridad: $perrors\n";
  printf "Comprobación LRC:   %s\n", $LRCerror ? "No válido." : "¡Correcto!";
  printf "Contenido:          %s\n", $decoded;

#  if ($chars and $chars > 10 and $perrors < 2) {
#   print "Anotada.\n";
#   open my $fh, ">> log";
#   print $fh "$string : $decoded\n";
#   close $fh;
#  }
 
  return;
 }

 ($decoded, $chars, $perrors, $LRCerror) = decode_BCD($string);
 if ($decoded) {
  printf "Formato:            BCD\n";
  printf "Caracteres:         $chars\n";
  printf "Errores de paridad: $perrors\n";
  printf "Comprobación LRC:   %s\n", $LRCerror ? "No válido." : "¡Correcto!";
  printf "Contenido:          %s\n", $decoded;

#  if ($chars and $chars > 10 and $perrors < 2) {
#   print "Anotada.\n";
#   open my $fh, ">> log";
#   print $fh "$string : $decoded\n";
#   close $fh;
#  }
  return;
 }
}


# Sustituye los grupos por su correspondiencia
sub decode_BCD {
 # http://www.gae.ucm.es/~padilla/extrawork/card-o-rama.txt
 my %BCD_table = (
  '00001' => '0',
  '10000' => '1',
  '01000' => '2',
  '11001' => '3',
  '00100' => '4',
  '10101' => '5',
  '01101' => '6',
  '11100' => '7',
  '00010' => '8',
  '10011' => '9',
  '01011' => ':',
  '11010' => ';', # Start Sentinel
  '00111' => '<',
  '10110' => '=', # Field Separator
  '01110' => '>',
  '11111' => '?', # End Sentinel
 );
 my $string  = shift;
 my $decoded = "";
 my $errores = 0;
 my $chars   = 0;
 my @LRC;
 
 ($string) = $string =~ /(11010([01\?]{5})+11111[01\?]{5})/;
 if (not $string) {
  print "DecodeBCD: Error de formato.\n" if $debug;
  return (undef);
 }

 for (my $i = 0; $i < length($string); $i+= 5) {
  my $grupo = substr ($string, $i, 5);
  if (exists $BCD_table{$grupo}) {
   $decoded .= $BCD_table{$grupo};
   $LRC[$_] = ($LRC[$_]||0) ^ substr($grupo, $_, 1) for (0..3);
  }
  else {
   $decoded .= "_";
   $errores++;
  }
  $chars ++;
 }

 return ($decoded, $chars, $errores, any(@LRC));
}

# Sustituye los grupos por su correspondiencia
sub decode_ALPHA {
 # http://www.gae.ucm.es/~padilla/extrawork/card-o-rama.txt
 my %ALPHA_table = (
  "0000001" => ' ', # (0H)   Special
  "1000000" => '!', # (1H)      "
  "0100000" => '"', # (2H)      "
  "1100001" => '#', # (3H)      "
  "0010000" => '$', # (4H)      "
  "1010001" => '%', # (5H)   Start Sentinel
  "0110001" => '&', # (6H)   Special
  "1110000" => "'", # (7H)      "
  "0001000" => '(', # (8H)      "
  "1001001" => ')', # (9H)      "
  "0101001" => '*', # (AH)      "
  "1101000" => '+', # (BH)      "
  "0011001" => ',', # (CH)      "
  "1011000" => '-', # (DH)      "
  "0111000" => '.', # (EH)      "
  "1111001" => '/', # (FH)      "

  "0000100" => '0', # (10H)    Data (numeric)
  "1000101" => '1', # (11H)     "
  "0100101" => '2', # (12H)     "
  "1100100" => '3', # (13H)     "
  "0010101" => '4', # (14H)     "
  "1010100" => '5', # (15H)     "
  "0110100" => '6', # (16H)     "
  "1110101" => '7', # (17H)     "
  "0001101" => '8', # (18H)     "
  "1001100" => '9', # (19H)     "

  "0101100" => ':', # (1AH)   Special
  "1101101" => ';', # (1BH)      "
  "0011100" => '<', # (1CH)      "
  "1011101" => '=', # (1DH)      "
  "0111101" => '>', # (1EH)      "
  "1111100" => '?', # (1FH)   End Sentinel
  "0000010" => '@', # (20H)   Special

  "1000011" => 'A', # (21H)   Data (alpha) 
  "0100011" => 'B', # (22H)     "
  "1100010" => 'C', # (23H)     "
  "0010011" => 'D', # (24H)     "
  "1010010" => 'E', # (25H)     "
  "0110010" => 'F', # (26H)     "
  "1110011" => 'G', # (27H)     "
  "0001011" => 'H', # (28H)     "
  "1001010" => 'I', # (29H)     "
  "0101010" => 'J', # (2AH)     "
  "1101011" => 'K', # (2BH)     "
  "0011010" => 'L', # (2CH)     "
  "1011011" => 'M', # (2DH)     "
  "0111011" => 'N', # (2EH)     "
  "1111010" => 'O', # (2FH)     "
  "0000111" => 'P', # (30H)     "
  "1000110" => 'Q', # (31H)     "
  "0100110" => 'R', # (32H)     "
  "1100111" => 'S', # (33H)     "
  "0010110" => 'T', # (34H)     "
  "1010111" => 'U', # (35H)     "
  "0110111" => 'V', # (36H)     "
  "1110110" => 'W', # (37H)     "
  "0001110" => 'X', # (38H)     "
  "1001111" => 'Y', # (39H)     "
  "0101111" => 'Z', # (3AH)     "

  "1101110" => '[', # (3BH)    Special
  "0011111" => '\\', # (3DH)   Special
  "1011110" => ']', # (3EH)    Special
  "0111110" => '^', # (3FH)    Field Separator
  "1111111" => '_', # (40H)    Special
 );
 my $string  = shift;
 my $decoded = "";
 my $errores = 0;
 my $chars   = 0;
 my @LRC;
 
 ($string) = $string =~ /(1010001([01\?]{7})+1111100[01\?]{7})/;
 if (not $string) {
  print "Decode ALPHA: Error de formato.\n" if $debug;
  return;
 }

 for (my $i = 0; $i < length($string); $i+= 7) {
  my $grupo = substr ($string, $i, 7);
  if (exists $ALPHA_table{$grupo}) {
   $decoded .= $ALPHA_table{$grupo};
   $LRC[$_] = ($LRC[$_]||0) ^ substr($grupo, $_, 1) for (0..5); # paridad no entra en LRC
  }
  else {
   $decoded .= "_";
   $errores++;
  }
  $chars++;
 }

 return ($decoded, $chars, $errores, any(@LRC));
}


# One argument is true
sub any { $_ && return 1 for @_; 0 }
```

## Conclusiones

Y para terminar os acompaño una captura para que veais cómo una secuencia de dominios magnéticos apropiadamente colocados se traduce en unos y ceros, y esa información binaria se decodifica en información útil. La salida no es del programa de arriba sino de una versión anterior.

{% include image.html size="big" file="2lecturastrab.png" caption="" %}

A veces cuesta un poco leer las pistas de alta densidad porque el lector que usamos es más estrecho para el ancho de la banda. Pero no quiere decir que no vayamos a poder leer, sino que cuesta más obtener una señal válida.

Ni que decir tiene que si has leído hasta aquí es porque estás interesado en la parte didáctica del artículo. Porque, si fueras un delincuente no estarías perdiendo el tiempo leyendo sobre electrónica digital y lectores de cintas de cassete sino que estarías clonando ya tarjetas con un [grabador comercial](http://www2.dealextreme.com/details.dx/sku.18362) comprado por Internet.
