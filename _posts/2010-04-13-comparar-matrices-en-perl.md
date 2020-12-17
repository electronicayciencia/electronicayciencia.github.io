---
assets: /assets/2010/04/comparar-matrices-en-perl
layout: post
tags:
- Informática
title: Comparar matrices en Perl
---

En algunas ocasiones tenemos dos listas y necesitamos saber qué elementos *han entrado* nuevos en la segunda, cuales estaban en la primera pero no en la segunda -*han salido*- y cuales se han mantenido. Podríamos utilizar el módulo [Array::Diff]({{page.assets | relative_url}}/Diff.pm) pero tiene un defecto, y es que **depende del orden**. Como utiliza un algoritmo similar a Diff, cuando los elementos cambian de orden el módulo ofrece resultados incorrectos.

Para eso podemos usar la siguiente función:

```perl
#===  FUNCTION  ================================================================
#         NAME:  array_entran_salen
#      PURPOSE:  Calcula los elementos que han entrado o han salido al comparar matrices
#   PARAMETERS:  ref_array_origen, ref_array_destino
#      RETURNS:  ref_array_entran, ref_array_salen, ref_array_comunes
#        NOTES:  Hago esta rutina porque el Array::Diff depende del orden
#===============================================================================
sub array_entran_salen {
 my $origen  = shift;
 my $destino = shift;
 my %elem;
 my @entran;
 my @salen;
 my @comunes;

 $elem{$_} = 1  for @$origen;
 $elem{$_} += 2 for @$destino;

 foreach (keys %elem) {
  $elem{$_} == 1 and push @salen, $_;
  $elem{$_} == 2 and push @entran, $_;
  $elem{$_} == 3 and push @comunes, $_;
 }

 return (\@entran, \@salen, \@comunes);
}
```

Tenemos dos listas:

    a b c d e f g
    
    a   c d   f g h

Al aplicar la función nos devuelve:

    Entran: h
    Salen: b e
    Comunes: a c d f g

El funcionamiento es sencillo:

1. Se toman los elementos de la matriz A y se les asigna un valor 1.
1. Se toman los de la B y se les asigna un valor 2.
1. Al sumar las claves, los que sólo estaban en la A pero no en la B, seguirán teniendo **valor 1**. Los que estaban en la A y la B tendrán **valor 3**, y los que estaban sólo en la B, pero no en A **valdrán 2**.

Este método es escalable y podríamos comparar **varias matrices**, sumando 2, 4, 8...

Es posible que no se vea bien el código porque el render de LaTeX se empeña en interpretar expresiones de Perl, y claro, pues no le molan. Creo que lo he corregido pero por si acaso os dejo el código [en este enlace]({{page.assets | relative_url}}/array_entran_salen.pl).
