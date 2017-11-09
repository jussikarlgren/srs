foreach $dd (F32, F33, F34, F41, F43, M16, M17, M54, M60) {
    $diagnosisofinterest{$dd}++;
}

while (<>) {
    chomp;
    @fall = split "\t";
    $lopnr = $fall[0];
    $diagnos = $fall[6];
    if ($diagnosisofinterest{$diagnos} && ! $thisdudeF{$lopnr}) {
	$thisdudeF{$lopnr} = 1;
    }
    unless ($seen{$lopnr}{$diagnos}) {
	$seen{$lopnr}{$diagnos}++;
	$diagnosantal{$lopnr}++;
    }
    $sjukskriven{$lopnr}++;
    $diagnosobservation{$diagnos}++;
}

for $individ (keys %diagnosantal) {
    if ($thisdudeF{$individ}) {
	$f++;
	$fs += $diagnosantal{$individ};
	for $diagnos (keys %{ $seen{$individ} }) {$fdiagnos{$diagnos}++;}
    } else {
	$n++;
	$ns += $diagnosantal{$individ};
	$nd += $sjuksksriven{$individ};
	for $diagnos (keys %{ $seen{$individ} }) {$ndiagnos{$diagnos}++;}
    }
}

print "$f ".$fd/$f." ".$fs/$f." $n ".$nd/$n." ".$ns/$n."\n";
for $diagnos (sort {$fdiagnos{$a} <=> $fdiagnos{$b}} keys %diagnosobservation) {
    next if $fdiagnos{$diagnos} < 1000;
    print "$diagnos\t$fdiagnos{$diagnos}\t$ndiagnos{$diagnos}\t$diagnosobservation{$diagnos}\t".$fdiagnos{$diagnos}/($fdiagnos{$diagnos}+$ndiagnos{$diagnos})."\n";
}
