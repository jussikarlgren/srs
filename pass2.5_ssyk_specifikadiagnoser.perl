#open SSYK3, "</home/jussi/srs/ssyk3korning/lopnr-datum-ssyk3.txt";
#while (<SSYK3>) {
#    chomp;
#    ($lopnr,$datum,$ssyk3) = split "\t";
#    unless ($firstssyk3{$lopnr}) {$firstssyk3{$lopnr} = $ssyk3;} else {$multiple{$lopnr}++;}
#    $ssyk3{$lopnr}{$datum} = $ssyk3;
#}
#close SSYK3;
$debug = 0;
$ssykfelt=134;
$antalfelt=137;
while (<>) {
    @fall = split "\t";
    $prev = $lopnr;
    $lopnr = $fall[0];
    if ($lopnr eq "lopnr") {print; next;}
    $ssyk3 = $fall[$ssykfelt];
    $ssyk3{$lopnr} = $ssyk3;
    if ($lopnr ne $prev) {
	$prevssyk3 = $ssyk3{$prev};
	for $kejs (@buffert) {	# töm buffert
	    @kejsfall = split "\t", $kejs;
	    for ($step = 0; $step < $ssykfelt; $step++) {
		print "$step:" if $debug;
		print "$kejsfall[$step]\t";
	    }
	    print "$step:" if $debug;
	    print $prevssyk3;
	    print "\t";
	    for ($step = $ssykfelt+1; $step < $antalfelt; $step++) { #antalfelt is number of fields; start from 0 here tho
	    print "$step:" if $debug;
		print "$kejsfall[$step]\t";
	    }
	    print "\n";
	}
	@buffert = ();
    }
    if ($ssyk3 > 0) {
	for $kejs (@buffert) {	# töm buffert
	    @kejsfall = split "\t", $kejs;
	    for ($step = 0; $step < $ssykfelt; $step++) {
		print "$kejsfall[$step]\t";
	    }
	    print "$step:" if $debug;
	    print "$ssyk3\t";
	    for ($step = $ssykfelt+1; $step < $antalfelt; $step++) { #antalfelt is number of fields; start from 0 here tho
		print "$step:" if $debug;
		print "$kejsfall[$step]\t";
	    }
	    print "\n";
	}
	@buffert = ();
	print;
    } else {
	push @buffert, $_; #lagra detta fall
    }
}







