#==============================================================================================================================
# 2.0 11 augusti 2015
# samlar ihop födelselandskoder
# 
# 1.0 11 juni 2015
# plockar ut och aggregerar fall från den av FK tillhandahållna filen huvudpersoner.txt
# matar ut en sjukskrivning per rad, med randvariabler plockade från det äldsta fallet. 
# 
# jussi
#==============================================================================================================================
use DateTime;
use DateTime::Format::Strptime;
my $parser   = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d' );
#==============================================================================================================================
# 0-2
print "lopnr	FALL_FROM_DATUM	FALL_TOM_DATUM	";
# 3-5
print "nbrutto	deltid	summa_utbetalt	";
# 6-32
print "LIU_SYSSELSATTNING	DIAGNOS_KOD	ar_sysselsatt	SYSS_STATUS_KOD	SNI_2007	CFAR_NR	KON_KOD	fodelsear	FODELSELAND_KOD	KOMMUN_KOD	fromdat_kommun	tomdat_kommun	ANTAL_HEMMA	fromdat_hemmafor	tomdat_hemmafor	ar_pgi	PGI	ar_sgi	belopp_sgi_ar	inktyp_kod_sgi_ar	fromdat_sgi	tomdat_sgi	belopp_sgi	inktyp_kod_sgi	SSYK3	ar_yrke	lopnr_make_maka	"; 
print "\n";

while (<>) {
    chop;
    next if length $_ < 1;
    @delfall = split "\t";
    $lopnr = $delfall[0];
    next if $lopnr eq "lopnr";
    next unless $lopnr > 0;
    $dettadelfall = $lopnr.$delfall[5].$delfall[6]; # lopnrfråndatum-tilldatum delfall
    $dettadelfallstartdatum = $delfall[5];
    if ($seen{$dettadelfall}) {next;} else {$seen{$dettadelfall}++;}
    $index = $lopnr.$delfall[11]; #lopnr - sjukskrivningsstart
    $start{$index} = $delfall[11];
    $stop{$index} = $delfall[13];
    $lopnr{$index} = $lopnr;
    next if $fertig{$index};
#==============================================================================================================================
# 0	lopnr
# 1	DELFORMAN1_KOD
# 2	DELFORMAN2_KOD
# 3	OMFATTNING
# 4	DAGBELOPP
# 5	DEL_FROM_DATUM
# 6	DEL_TOM_DATUM
# 7	DEL_DAGAR_TOT
# 8	DEL_DAGAR_BRUTTO
# 9	DEL_DAGAR_NETTO
# 10	DEL_BELOPP_BRUTTO
# 11	FALL_FROM_DATUM
# 12	FALL_FROM_DATUM2
# 13	FALL_TOM_DATUM
# 14	FALL_DAGAR_TOT
# 15	FORSAKRADTYP_KOD
# 16	DIAGNOS_KOD
# 17	ar_sysselsatt
# 18	SYSS_STATUS_KOD
# 19	SNI_2007
# 20	CFAR_NR
# 21	KON_KOD
# 22	fodelsear
# 23	FODELSELAND_KOD
# 24	KOMMUN_KOD
# 25	fromdat_kommun
# 26	tomdat_kommun
# 27	ANTAL_HEMMA
# 28	fromdat_hemmafor
# 29	tomdat_hemmafor
# 30	ar_pgi
# 31	PGI
# 32	ar_sgi
# 33	belopp_sgi_ar
# 34	inktyp_kod_sgi_ar
# 35	fromdat_sgi
# 36	tomdat_sgi
# 37	belopp_sgi
# 38	inktyp_kod_sgi
# 39	SSYK3
# 40	ar_yrke
# 41	lopnr_make_maka
    for ($step=15; $step <= $#delfall; $step++) {
	if ((! $diagnosdatum{$index}) || ($dettadelfallstartdatum < $diagnosdatum{$index}) || (! $aggregator{$index}[$step])) {
	    $aggregator{$index}[$step] = $delfall[$step];
	    $diagnosdatum{$index} = $dettadelfallstartdatum; 
	    if ($step == 16) {    $diagnosanteckning{$index} = $delfall[$step];}
	}
    }
#==============================================================================================================================
# räkna ihop värden för detta fall från delfallets fält
#    $deltid{$index} = "yes" if $delfall[3] == 0;
    $deltid{$index} = "yes" if $delfall[3] == 0.25;
    $deltid{$index} = "yes" if $delfall[3] == 0.5;
    $deltid{$index} = "yes" if $delfall[3] == 0.75;
    $nbrt{$index} += $delfall[7];
    $cash{$index} += $delfall[10];
#==============================================================================================================================
# vi har hela fallet samlat nu, om våra aggregerade bruttodagar är lika med fältet i delfallet som ska innehålla bruttodagar
    if ($nbrt{$index} >= $delfall[14]) { 
	$fertig{$index}++; 
	$deltid{$index} = "no" unless $deltid{$index};
#==============================================================================================================================
	print "$lopnr\t$start{$index}\t$stop{$index}\t";
	print "$nbrt{$index}\t$deltid{$index}\t$cash{$index}\t";
	$step = 15; #FORSAKRADTYP_KOD #Omkodas från variabeln Forsakradtyp_kod:
	if ($aggregator{$index}[$step] eq "8") {print "1\t";} #8 kodas som 1 (anställd)
	elsif ($aggregator{$index}[$step] eq "2") {print "2\t";} #2 kodas som 2 (arbetslös)
	elsif ($aggregator{$index}[$step] eq "3") {print "3\t";} #3, 5 och 6 kodas som 3 (Egenföretagare/student)
	elsif ($aggregator{$index}[$step] eq "5") {print "3\t";} 
	elsif ($aggregator{$index}[$step] eq "6") {print "3\t";} 
	elsif ($aggregator{$index}[$step] eq "4") {print "4\t";} #4 kodas som 4 (föräldraledig)
	else {print "0\t";} #Exkludera 0, 1 och 9.
	for ($step=16; $step <= 22; $step++) {
	    print "$aggregator{$index}[$step]\t";
	}
	$step = 23; # FODELSELAND_KOD
	if ($aggregator{$index}[$step] eq "SE") {print "SE\t";} 
	elsif ($aggregator{$index}[$step] eq "00") {print "00\t";} 
	elsif ($aggregator{$index}[$step] eq "NN") {print "NN\t";} 
	elsif ($aggregator{$index}[$step] eq "FI") {print "NN\t";} 
	elsif ($aggregator{$index}[$step] eq "NO") {print "NN\t";} 
	elsif ($aggregator{$index}[$step] eq "DK") {print "NN\t";} 
	elsif ($aggregator{$index}[$step] eq "IS") {print "NN\t";} 
	else {print "VV\t";}
	for ($step=24; $step <= 38; $step++) {
	    print "$aggregator{$index}[$step]\t";
	}
	if ($aggregator{$index}[39]) {print "$aggregator{$index}[39]\t";} elsif ($ssyk3{$lopnr}) {print "$ssyk3{$lopnr}\t";} else {print "000\t";}
	if ($aggregator{$index}[39]) {$ssyk3{$lopnr} = $aggregator{$index}[39];}
	for ($step=40; $step <= 41; $step++) {
	    print "$aggregator{$index}[$step]\t";
	}
	print "\n";

	delete $aggregator{$index};
	delete $diagnosdatum{$index};
	delete $nbrt{$index};
	delete $deltid{$index};
	delete $cash{$index};
    }
}

exit();

#finns det rester kvar?
##-## 
for $index (keys %nbrt) {
 	$fertig{$index}++; 
	print "oklar $index\n";
}
