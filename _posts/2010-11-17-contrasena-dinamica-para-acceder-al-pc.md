---
assets: /assets/2010/11/contrasena-dinamica-para-acceder-al-pc
image: /assets/2010/11/contrasena-dinamica-para-acceder-al-pc/img/capturaescudo.png
layout: post
tags:
- Informática
- Reciclaje
title: Contraseña dinámica para acceder al PC de casa
---

En ocasiones necesitamos acceder a nuestro ordenador desde fuera de casa. No hay problema, instalamos un servidor SSH y desde cualquier ordenador con Linux, o con PuTTY o SecureCRT instalado nos podemos conectar y ejecutar comandos o ver el correo como si estuviéramos delante mismo de la consola en casita.

El problema viene cuando nos conectamos desde ordenadores no seguros. Qué se yo, un cyber-café, un puesto de acceso libre en alguna party, o el ordenador de un amigo o no tan amigo. Estos sitos no seguros pueden tener instalados algún tipo de troyano o programa semejante para capturar las contraseñas que la gente mete. Puesto que la contraseña de acceso siempre es la misma (salvo que la cambiemos) con que alguien nos la robe en un descuido ya puede andar por nuestro PC de casa sin problemas. Y si tenemos alguna de estas distribuciones con el sudo abierto pues puede organizar un desaguisado de mucho cuidado.

La solución pasa entonces por tener una clave que cambie cada día, o mejor aún que cada vez que accedamos sea una distinta. Así al intruso no le bastará con sólo capturar la clave una vez, porque no servirá para la próxima vez que intente entrar.

Pero la pregunta es, si cada vez que entre la clave es distinta ¿cómo sé yo con qué clave tengo que entrar? Pues una solución sencilla podría ser que el ordenador nos mande un desafío y nosotros tengamos que responder siguiendo un algoritmo que hayamos programado previamente. Esa es la dinámica del programa que os quiero presentar hoy.

{% include image.html size="big" file="capturaescudo.png" caption="" %}

## El algoritmo

En este caso la clave es el algoritmo. Al espía no se bastará capturar una clave o veinte, necesitará descubrir con qué algoritmo respondemos. Porque si intenta entrar y su respuesta es errónea, el programa nos alertará.

Hay algoritmos que aunque el intruso sepa el algoritmo sería incapaz de generar una clave válida a partir de una clave usada. Es el caso del intercambio de claves Diffie-Hellman basado en el problema del logaritmo discreto. Pero como no es cuestión de teclear varias decenas de cifras cada vez que nos conectemos, vamos a usar algoritmos un poco menos seguros.

Como cualquier móvil hoy en día tiene una calculadora básica tenemos muchas operaciones para elegir. Por ejemplo podríamos elegir *las cuatro últimas cifras del cuadrado del número*. Si el ordenador nos pasa el número **3465** nosotros responderíamos con **6225**. Hay infinitos algoritmos para elegir. Algunos os habréis dado cuenta de que precisamente este no es muy inteligente.

Con las modernas calculadoras para móviles no es difícil hacer cualquier operación, a mi me gusta mucho esta: [http://midp-calc.sourceforge.net/Calc.html](http://midp-calc.sourceforge.net/Calc.html). Además como es programable sólo tengo que pasarle los números y me devuelve el resultado.

Conviene escoger funciones que no sean lineales, o por lo menos no lo parezcan. Por ejemplo el módulo (he dicho no lo parezcan) va oscilando entre 0 y un valor máximo, igual que el seno o el coseno. Esta propiedad es estupenda para despistar.

## El programa

Veamos el programa que permite esto. Se trata de un pequeño script en Perl que se coloca en lugar de la shell de nuestro usuario. Así cuando alguien meta la contraseña correcta se le presenta el desafío.

Desde el momento que se presenta el desafío el que entra tiene dos opciones:

- Responder correctamente, con lo que se le dejará entrar.
- Cualquier otra acción, ya sea cortar la conexión o responder equivocadamente disparará la rutina de error.

```perl
#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  escudo.pl
#
#        USAGE:  ./escudo.pl  
#
#  DESCRIPTION:  Se pone como shell de usuario para proporcionar un nivel de
#                seguridad extra. Puede ser una contraseña dinámica que cambie
#                cada vez a modo de token. O que cambie según día.
#
#                Cuando un usuario se logee con nuetra cuenta y no sepa qué algoritmo
#                hemos puesto en el escudo fallará. Y nos llegará un correo avisando.
#                De esa forma sabremos que nuestra contraseña ha sido comprometida.
#
#                Como acciones posteriores puede cambiar la contraseña y enviar la nueva
#                a un correo seguro. O bloquear la IP origen.
#
#        NOTES:  Hay que modificar las funciones &parametros y &calcular para crear
#                el algoritmo que nosotros diseñemos.
#
#       AUTHOR:  Reinoso Guzmán
#      VERSION:  1.0
#      CREATED:  13/11/10 12:48:18
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Sys::Syslog;
use Net::SMTP;

openlog('escudo', 'cons,pid', 'user');

$| = 1;
# Si el usuario hace cualquier otra cosa que no sea meter la clave correcta,
# damos la alarma.
$SIG{TERM} = \&tomar_medidas;
$SIG{HUP}  = \&tomar_medidas;
$SIG{INT}  = \&tomar_medidas;
$SIG{CHLD} = \&tomar_medidas;


# Variable global con el nombre del usuario
my $usuario = $ENV{LOGNAME} || $ENV{USER} || "Perfecto desconocido";
$usuario = ucfirst($usuario);

# Actuamos si es shell remota por SSH.
# Los comandos no interactivos fallarán, pero es de lo que se trata.
if (not exists $ENV{SSH_CLIENT}) {
 do_shell();
}


# Le hacemos una pregunta al usuario con los parámetros
my @params = parametros();
print "\nHola $usuario.\nSi yo te digo @params, ¿tú que me contestas?\n";

# Esperar respuesta
my $respuesta = <>;
chomp $respuesta;

# Comprobamos la respuesta
if (calcular(@params) eq $respuesta) {
 do_shell();
}


# Tomar medidas en caso de que algo no funcione bien.
# La shell se lanza con exec, que no retorna. 
# Luego si de cualquier forma llegamos a esta función (ya sea por un fallo
# en exec, o por algún truco del intruso, tomamos medidas):
tomar_medidas();
exit(1);


##############################################################################


# Proporciona un array con los parámetros que se le dan al usuario.
sub parametros {
 my $param1 = 13 + int (rand(10000));
 my $param2 = 13 + int (rand(100));
 #$param1 = 7521;
 #$param2 = 77;
 return($param1, $param2);
}


# Devuelve 0 si la respuesta coincide con el número que se esperaría.
# Se le pasan los parámetros de &parametros.
sub calcular {
 my ($a, $b) = @_;
 my $dia = (localtime(time))[3];
 my $respuesta;

 # Inventar aquí el algoritmo: respuesta = f(a, b, c, ...)
 # Otra opción sería usar tokens:
 # (números aparentemente aleatorios pero con una estructura interna desconocida
 # para el atacante. Calculados de manera automática y de un sólo uso.
 # --------------------------
 $respuesta = abs (int (log($a + $b * $dia) * 10000));
 # --------------------------

 return $respuesta;
}


# Hemos comprobado que el usuario es legítimo y ejecutamos la shell.
sub do_shell {
 syslog('notice', 'Respuesta correcta, entra %s.', $usuario);

 # Reemplazando SHELL y llamando a exec de esa manera es como si el escudo nunca
 # hubiera existido por medio.
 $ENV{SHELL} = '/bin/bash';
 exec {"/bin/bash"} "-bash";
}

sub interr {
 tomar_medidas();
}


# Esta función toma las medidas que se prevean. Generalmente enviar un correo
# o bloquear la IP atacante al cabo de algunos intentos.
sub tomar_medidas {
# print "Password comprometida. ¡Fuera!\n¡Avisaré a $usuario!\n";
 my $conn = $ENV{SSH_CLIENT} || "localhost";
 syslog('notice',
     'Respuesta incorrecta al desafio para %s: acceso denegado.',
     $usuario);
 
 my $smtp = Net::SMTP->new('localhost');
    $smtp->mail($usuario.'@localhost');
    $smtp->to($usuario.'@localhost');
    $smtp->data();
    $smtp->datasend("To: $usuario\n");
    $smtp->datasend("From: root\n");
    $smtp->datasend("Subject: Clave de $usuario comprometida.\n");
    $smtp->datasend("\n");
    $smtp->datasend("Alguien intento entrar desde $conn con la clave de $usuario.\n");
    $smtp->dataend();
    $smtp->quit;

 closelog();

 # La última medida que se toma, es por supuesto, terminar la shell para tirar la sesión.
 exit(1);
}
```

El funcionamiento es sencillo. Lo primero que hacemos es capturar todas la interrupciones que pueden ocurrir. Para conseguir que una vez llamado, el programa sea una trampa: o se contesta bien, o se tomarán medidas.

Por otro lado no nos interesa que el escudo moleste cuando iniciemos sesión nosotros localmente. Así que justo después hay una condición para que si la conexión no es desde un terminal remoto por SSH nos presente la shell sin mediar palabra.

Una primera rutina nos genera unos parámetros dentro del rango adecuado a nuestro algoritmo. Estos números son los que nos presentará el escudo cuando intentemos entrar. Una segunda rutina se encarga de generar la respuesta que corresponde a esos parámetros. Como la calculadora en el móvil debe seguir el mismo que hay programado en el escudo las respuestas deben ser idénticas.

Si la respuesta era la esperada por el escudo, llamamos a la shell. Fijaos la forma de llamarla con *exec*, y cómo se reemplaza la variable de entorno SHELL. Así es como si el escudo nunca hubiera estado en medio.

La rutina *tomar_medidas* actúa según hayamos programado.

- Evidentemente sale del programa. Terminando la shell y desconectando al posible intruso.
- Puede enviar un correo a alguna dirección que se ponga para que nos avise de que alguien ha conseguido entrar con nuestra contraseña.
- Podría cambiar la contraseña a otra que tengamos programado. Para el caso de que comprometan la primera podamos seguir entrando con la de respaldo.
- Podría bloquear la IP al cabo de unos cuantos intentos infructuosos. Aunque haría falta un poco de maña, porque el escudo corre con los privilegios del usuario.

## Observaciones

Es de cajón, pero hay que advertir no teclear en la calculadora de Windows o en la de Google la operación. Porque si realmente hay instalado un programa para capturar claves también descubrirá las operaciones que hacemos.

Yo he optado por sustituir a la shell del usuario. Pero otra opción es sustituir al programa *login*para que actúe sobre todos los usuarios. Este paso es peliagudo, porque *login* hace algunas cosas más a parte de autenticar al usuario y lo que es peor: se ejecuta con privilegios de root. Así que cualquier fallo es peligroso.

Si quisiéramos usarlo para varios usuarios lo mejor sería un fichero de configuración en el home del usuario. Bien con el código del algoritmo para ejecutarlo con *eval*, o bien con algunos números que sirvan de parámetros y poder personalizar el algoritmo para cada usuario.

Huelga decir que el código que presento hay que modificarlo si lo quieres usar. No dejes el algoritmo que pongo de ejemplo.
