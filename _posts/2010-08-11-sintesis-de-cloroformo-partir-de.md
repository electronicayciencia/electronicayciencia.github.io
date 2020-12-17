---
assets: /assets/2010/08/sintesis-de-cloroformo-partir-de
layout: post
tags:
- Reciclaje
title: 'Síntesis de cloroformo a partir de productos de limpieza: estequiometría'
---

Hay multitud de productos químicos en cualquier casa y las reacciones entre ellos son múltiples y variadas. Al mezclar, por ejemplo, un álcali clorado como la lejía con un ácido fuerte también basado en el cloro como el salfumán, se produce una neutralización con generoso desprendimiento de cloro. Este gas es tóxico, irritante y mata por asfixia, así que cuidado con él.

El experimento de hoy es un clásico casero, la reacción entre acetona y lejía para dar [cloroformo](http://www.insht.es/InshtWeb/Contenidos/Documentacion/TextosOnline/Valores_Limite/Doc_Toxicologica/FicherosSerie2/DLEP%2026.pdf). Hay multitud de vídeos ilustrativos en YouTube.

Viendo el experimento desde el punto de vista químico, lo que sucede es la [**reacción del haloformo**](http://es.wikipedia.org/wiki/Reacci%C3%B3n_del_haloformo). Consta de varios pasos. Copio de la Wikipedia:

> Bajo condiciones básicas, la cetona sufre tautomerización ceto-enol, y subsecuente formación del anión enolato. El enolato sufre ataque electrofílico por el hipohalito (que contiene un halógeno con carga formal +1). Cuando la posición alfa ha sido halogenada exhaustivamente, la molécula sufre una sustitución nucleofílica acílica por hidróxido, con -CX3 como grupo saliente, puesto que está estabilizado por tres EWG. El anión -CX3 abstrae un protón, bien del ácido carboxílico formado, o del solvente, y forma el haloformo.

Estoy flojo de orgánica, si alguien es capaz de entender el párrafo anterior que por favor me lo explique.

**Nota** aclaratoria para los tertulianos de [endoroot](http://www.endoroot.com/modules/newbb/viewtopic.php?topic_id=3154&amp;forum=4&amp;post_id=31258)  que están debatiendo el tema. La reacción del haloformo se utiliza en  determinación cualitativa tanto de acetona como de alcoholes secundarios  y de etanol. No se suele usar la del cloroformo sino la del iodoformo.  No os costará encontrar [referencias](http://www.google.com/search?q=ethanol+iodoform).  En general sustancias que contienen una estructura R-CO-CH3. Si R es  otro CH3 hablamos de acetona. Si R es un simple H lo que tenemos es  etanal (acetaldehido) que también funciona. La reacción no se da con  etanol directamente, pero este [fácilmente]({{page.assets | relative_url}}/chi3flowoh.gif) se oxida a etanal.

## Estequiometría

Lo que sí podemos calcular, sin ser químicos y sin necesidad de entender los pasos intermedios de la reacción es la **estequiometría** del experimento. Que además será un buen ejercicio para repasar algo de química elemental.

Veamos esta hoja de cálculo:  [https://spreadsheets.google.com/ccc?key=0AjHcMU3xvtO8dEo3X3IyLWM3SkdFUUF2TXhzV1dzbnc&amp;hl=es&amp;authkey=CO-0lLsK](https://spreadsheets.google.com/ccc?key=0AjHcMU3xvtO8dEo3X3IyLWM3SkdFUUF2TXhzV1dzbnc&amp;hl=es&amp;authkey=CO-0lLsK)

<a href="https://spreadsheets.google.com/pub?key=0AjHcMU3xvtO8dEo3X3IyLWM3SkdFUUF2TXhzV1dzbnc&amp;hl=es&amp;single=true&amp;gid=0&amp;output=html">

</a>

Los datos **en negrita** son los datos que introducimos para el problema, los que ya conocemos. Mientras que los números normales son los que calculamos. Las columnas de la izquierda son los datos principales, a la derecha están los cálculos auxiliares.

El ajuste de la reacción no requiere apenas método. Simplemente ver que el hipoclorito sólo tiene un átomo de cloro mientras que el cloroformo requiere tres. Es lo que se representa en las celdas B11 y B12. Como sabemos que no es la única reacción que se da, el rendimiento no es del 100%, pongamos 90% pero aún así parece demasiado optimista.

    CH<sub>3</sub>-CO-CH<sub>3</sub> + 3 NaClO --> CHCl<sub>3</sub> + CH<sub>3</sub>-... + ...

La lejía doméstica es una disolución de hipoclorito de sodio con una concentración, por ley, inferior al 5%. Hay lejías especiales que llegan al 10% y están etiquetadas como tales. Así pues este será el **reactivo limitante**, dado que la acetona se consigue casi pura en botellas de litro.

Como veis hemos puesto 250ml de lejía, el equivalente a un vaso grande. La concentración exacta y la densidad no las conocemos, así que las estimamos. Dado que la concentración es muy pequeña y el hipoclorito es una molécula muy simple la densidad no puede variar mucho de la del agua pura.

Con esos datos calculamos los moles de hipoclorito en disolución. Y según la reacción por cada tres moles de hipoclorito corresponde uno de acetona. Con esa cantidad de reactivo limitante, reaccionarán 3.3cm<sup>3</sup> de acetona. Considerando acetona casi pura, al 99%.

Y eso dará 0.04mol de cloroformo. Que teniendo en cuenta su masa molecular y densidad se convertirán en 3.28ml de líquido.

3.28ml es muy poquito, pero ahí no acaba la cosa. Porque esta sustancia es parcialmente soluble en agua. Y como la lejía es un 95% agua tenemos mucha, mucha agua. Así que vamos a perder mucho producto en disolución a menos que destilemos la mezcla después.

En concreto la solubilidad es de 8 gramos de cloroformo en cada litro de agua. He aproximado que en 250ml de lejía hay 250ml de agua, no es del todo cierto pero para bajas concentraciones el error es muy pequeño. **La perdida en disolución es de nada menos que 2 gramos, el 42% del producto**. Observad que la pérdida es mayor cuanto menos concentrado esté el hipoclorito, por tanto esta reacción, con lejía doméstica, es totalmente inútil salvo como curiosidad.

Este procedimiento se usa más para detectar cierto tipo de moléculas orgánicas, por ejemplo los alcoholes secundarios que dan la reacción. Como método de producción en el laboratorio también se puede usar, pero empleando hipoclorito cálcico (cloro rápido para piscinas) en lugar de la lejía.

Después de todos los cálculos, de un vaso grande de lejía se obtiene poco menos que 2ml de cloroformo.

## Efectos del cloroformo

Hemos visto que la mezcla intencionada de un vaso de lejía con un mínimo de acetona, da lugar a menos de 2ml de cloroformo. La mezcla accidental de productos de limpieza puede generar esta sustancia, pero en cantidades tan pequeñas que los efectos son imperceptibles.

El cloroformo como depresor del sistema nervioso que es, coloca y relaja. Hace tiempo se usó como anestésico, pues era más fácil de manejar y más seguro que el éter (el nuevo anestésico no hacía explotar el quirófano a la mínima). Se dejó de usar en cuanto se encontraron alternativas mejores, menos agresivas para el hígado. En ocasiones se inhala buscando estos efectos, igual que otros disolventes orgánicos. Sin embargo cuando esta sustancia llega al hígado, la única forma que tiene de degradarlo es oxidarlo y se convierte en fosgeno. El fosgeno, lejos de ser inocuo, se usaba como arma química en la Primera Guerra Mundial; de hecho fue el gas que más muertes causó.

A propósito del fosgeno, el nombre viene de *fos* que en griego significa luz, pensad en fósforo, *portador de luz*. ¿Pero por qué, si el fosgeno no "arde"? Es interesante, cuando encendemos un fuego hay una sustancia que se oxida (un combustible) y otra que es la que proporciona el oxígeno para oxidar el combustible (un comburente). De esto ya hablamos [en esta entrada](). Generalmente el comburente es el oxígeno, pero el fosgeno también **aviva la llama**. De ahí su nombre fos-geno *generador de luz*.

## Abuso del cloroformo

Para terminar, si estáis pensando en usar esta reacción para sintetizar cloroformo, pasad del tema. Como habéis visto la cantidad que sale es muy pequeña y no merece la pena. Lo podéis encontrar en tiendas de productos químicos y en algunas ferreterías y tiendas de manualidades. Se usa para moldear plástico y es relativamente barato.

Y si estás pensando en sintetizarlo para inhalarlo, aún sabiendo que es tóxico y en exposiciones prolongadas cancerígeno, no te lo recomiendo. Ten en cuenta que con lejía normal lo que se obtiene es una cantidad mínima. Además no es sólo cloroformo, sino una mezcla de este y acetona, más algunos subproductos que te pueden joder el colocón, como la [cloroacetona](http://www.insht.es/InshtWeb/Contenidos/Documentacion/FichasTecnicas/FISQ/Ficheros/701a800/nspn0760.pdf) que se usa precisamente de **gas lacrimógeno**.
