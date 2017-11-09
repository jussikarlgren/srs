$debug = 0;
$cols = 0;
$rows = 0;
foreach $dd (F32, F33, F34, F41, F43, M16, M17, M54, M60) {
    $diagnosisofinterest{$dd}++;
}

while (<>) {
    chomp;
    @fall = split "\t";
    $lopnr = $fall[0];
    $diagnos = $fall[6];
    if (! $seen{$lopnr}) {
	$rows++;
	$rowindex{$lopnr} = $rows;
	$seen{$lopnr}++;
    }
    if (! $seen{$diagnos}) {
	$cols++;
	$colindex{$diagnos} = $cols;
	$indexcol{$cols} = $diagnos; 
	$seen{$diagnos}++;
    }
    $pretempvector[$rowindex{$lopnr}][$colindex{$diagnos}]++ unless $thisdudeF{$lopnr};
    $postvector[$rowindex{$lopnr}][$colindex{$diagnos}]++ if $thisdudeF{$lopnr};
    $vector[$rowindex{$lopnr}][$colindex{$diagnos}]++;
    if ($diagnosisofinterest{$diagnos} && ! $thisdudeF{$lopnr}) {
	$thisdudeF{$lopnr} = 1;
	for ($di = 0; $di <= $cols; $di++)  {
	    $prevector[$rowindex{$lopnr}][$di] = $pretempvector[$rowindex{$lopnr}][$di];	    
	}
    }
}


for $fdiagnos (keys %diagnosisofinterest) { 
    $fokusdiagnos = $colindex{$fdiagnos};
    next unless $fokusdiagnos;
    for ($otherdiagnos=1;$otherdiagnos<=$cols;$otherdiagnos++) {
#	print "$fokusdiagnos\t$indexcol{$fokusdiagnos}\t$otherdiagnos\t$indexcol{$otherdiagnos}\n";
	$sumoo = 0;
	$sumof = 0;
	$sumff = 0;
	$sumpreoo = 0;
	$sumpreof = 0;
	$sumpostoo = 0;
	$sumpostof = 0;
	$sumf=0;$sumfpre=0;$sumfpost=0;
	$sumo=0;$sumopre=0;$sumopost=0;
	for ($person=0;$person<=$rows;$person++) {
	    $sumf +=      $vector[$person][$fokusdiagnos];
	    $sumfpre +=   $prevector[$person][$fokusdiagnos];
	    $sumfpost +=  $postvector[$person][$fokusdiagnos];
	    $sumo +=      $vector[$person][$otherdiagnos];
	    $sumopre +=   $prevector[$person][$otherdiagnos];
	    $sumopost +=  $postvector[$person][$otherdiagnos];
	    $sumff +=     $vector[$person][$fokusdiagnos]*$vector[$person][$fokusdiagnos];
	    $sumoo +=     $vector[$person][$otherdiagnos]*$vector[$person][$otherdiagnos];
	    $sumof +=     $vector[$person][$otherdiagnos]*$vector[$person][$fokusdiagnos];
	    $sumpreoo +=  $prevector[$person][$otherdiagnos]*$prevector[$person][$otherdiagnos];
	    $sumpreof +=  $prevector[$person][$otherdiagnos]*$vector[$person][$fokusdiagnos];
	    $sumpreff +=  $prevector[$person][$fokusdiagnos]*$vector[$person][$fokusdiagnos];
	    $sumpostoo += $postvector[$person][$otherdiagnos]*$postvector[$person][$otherdiagnos];
	    $sumpostof += $postvector[$person][$otherdiagnos]*$vector[$person][$fokusdiagnos];
	    $sumpostff += $postvector[$person][$fokusdiagnos]*$vector[$person][$fokusdiagnos];
	}    

	$precosine = 0;
	$postcosine = 0;
	$cosine = $sumof/(sqrt($sumoo)*sqrt($sumff));
	if ($sumpreoo > 0 && $sumff > 0) {$precosine = $sumpreof/(sqrt($sumpreoo)*sqrt($sumpreff));}
	if ($sumpostoo > 0 && $sumff > 0) {$postcosine = $sumpostof/(sqrt($sumpostoo)*sqrt($sumpostff));}
	if ($debug) {
	    print "----\n";
	    print "$indexcol{$fokusdiagnos}\t$sumf\t$sumfpre\t$sumfpost\t$sumff\t$sumpreff\t$sumpostff\n";
	    print "$indexcol{$otherdiagnos}\t$sumo\t$sumopre\t$sumopost\t$sumoo\t$sumpreoo\t$sumpostoo\n";
	    print "$indexcol{$fokusdiagnos}\t$indeocol{$otherdiagnos}\tcos\t$cosine = $sumof/(sqrt($sumoo)*sqrt($sumff))\n";
	    print "$indexcol{$fokusdiagnos}\t$indexcol{$otherdiagnos}\tpre\t$precosine = $sumpreof/(sqrt($sumpreoo)*sqrt($sumpreff))\n";
	    print "$indexcol{$fokusdiagnos}\t$indexcol{$otherdiagnos}\tpost\t$postcosine = $sumpostof/(sqrt($sumpostoo)*sqrt($sumpostff))\n";
	}
	next unless $cosine;
	print "$indexcol{$fokusdiagnos}\t$indexcol{$otherdiagnos}\t"; 
	print "$cosine\t$precosine\t$postcosine\n";
    }
}

