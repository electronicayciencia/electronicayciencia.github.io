#===  FUNCTION  ================================================================
#         NAME:  array_entran_salen
#      PURPOSE:  Calcula los elementos que han entrado o han salido al comparar dos matrices
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

