# kör med *lopnr-sorterad* pass1-output som input!
#==============================================================================================================================
#
# 5.0
# fixar fler liknande specialer
#
#
# 4.0
# fixar special för F32-4 och F33-34
#
# 3.0
# 
# tar bort många variabler som inte kommer användas (n000 etc)
# skapar nya variabler (ternära) för deltidssjukskrivningar 
# tre tidsperioder istf bara 2y
# subrutin för ekvivalensklasser
#
# 2.0
# fixar en wart som gjorde att M_*_2y etc har oväntade värden. 
# fixar så att "-00" inte är en diagnos som bidrar till "samma"
# disable nästan alla utom *_brutto_2y-variablerna tills vidare
# 
#
# 1.0
# plockar ut och aggregerar fall från den av FK tillhandahållna filen huvudpersoner.txt
# varje fall utökas med sjukskrivningstatistik från de senaste två åren för 
# a) samma diagnos
# b) F-diagnoser
# c) M-diagnoser
# d) alla diagnoser öht
#
#==============================================================================================================================
foreach $dd (F32, F33, F34, F41, F43, M16, M17, M54, M60) {
    $diagnosisofinterest{$dd}++;
}
use DateTime;
use DateTime::Format::Strptime;
my $debug = 0;
my $separator = "\t";
my $parser   = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d' );
my $ettaar = DateTime::Duration->new( years => 1);
my $tvaaaar = DateTime::Duration->new( years => 2);
my $femaar = DateTime::Duration->new( years => 5);
my $vecka    = DateTime::Duration->new( days => 7);
my $specialF = 1;
#==============================================================================================================================
# 0-2
print "lopnr".$separator."FALL_FROM_DATUM".$separator."FALL_TOM_DATUM".$separator;
# 3-5
print "nbrutto".$separator."deltid".$separator."summa_utbetalt".$separator;
# 6-13
print "nbrutto_1y".$separator."deltid_1y".$separator;# summa_utbetalt_1y".$separator;
print "nbrutto_2y".$separator."deltid_2y".$separator;# summa_utbetalt_2y".$separator;
print "nbrutto_5y".$separator."deltid_5y".$separator;# summa_utbetalt_5y".$separator;
print "nbrutto_hittills".$separator."deltid_hittills".$separator;# summa_utbetalt_hittills".$separator;
# 14-21
print "samma_nbrutto_1y".$separator."samma_deltid_1y".$separator;# samma_summa_utbetalt_1y".$separator;
print "samma_nbrutto_2y".$separator."samma_deltid_2y".$separator;# samma_summa_utbetalt_2y".$separator;
print "samma_nbrutto_5y".$separator."samma_deltid_5y".$separator;# samma_summa_utbetalt_5y".$separator;
print "samma_nbrutto_hittills".$separator."samma_deltid_hittills".$separator;# samma_summa_utbetalt_hittills".$separator;
# 22-29
print "F_nbrutto_1y".$separator."F_deltid_1y".$separator;# F_summa_utbetalt_1y".$separator;
print "F_nbrutto_2y".$separator."F_deltid_2y".$separator;# F_summa_utbetalt_2y".$separator;
print "F_nbrutto_5y".$separator."F_deltid_5y".$separator;# F_summa_utbetalt_5y".$separator;
print "F_nbrutto_hittills".$separator."F_deltid_hittills".$separator;# F_summa_utbetalt_hittills".$separator;


print "M_nbrutto_1y".$separator."M_deltid_1y".$separator;# M_summa_utbetalt_1y".$separator;
print "M_nbrutto_2y".$separator."M_deltid_2y".$separator;# M_summa_utbetalt_2y".$separator;
print "M_nbrutto_5y".$separator."M_deltid_5y".$separator;# M_summa_utbetalt_5y".$separator;
print "M_nbrutto_hittills".$separator."M_deltid_hittills".$separator;# M_summa_utbetalt_hittills".$separator;

for $dd (sort keys %diagnosisofinterest) {

print $dd."_nbrutto_1y".$separator.$dd."_deltid_1y".$separator;# F_summa_utbetalt_1y".$separator;
print $dd."_nbrutto_2y".$separator.$dd."_deltid_2y".$separator;# F_summa_utbetalt_2y".$separator;
print $dd."_nbrutto_5y".$separator.$dd."_deltid_5y".$separator;# F_summa_utbetalt_5y".$separator;
print $dd."_nbrutto_hittills".$separator.$dd."_deltid_hittills".$separator;# F_summa_utbetalt_hittills".$separator;

}

## # 53-54
print "LIU_SYSSELSATTNING".$separator."DIAGNOS_KOD".$separator;
# 55 - 64
print "ar_sysselsatt".$separator."SYSS_STATUS_KOD".$separator."SNI_2007".$separator."CFAR_NR".$separator."KON_KOD".$separator."fodelsear".$separator."LIU_Fodelseland3".$separator."KOMMUN_KOD".$separator."fromdat_kommun".$separator."tomdat_kommun".$separator;
# 65 - 74
print "ANTAL_HEMMA".$separator."fromdat_hemmafor".$separator."tomdat_hemmafor".$separator."ar_pgi".$separator."PGI".$separator."ar_sgi".$separator."belopp_sgi_ar".$separator."inktyp_kod_sgi_ar".$separator."fromdat_sgi".$separator."tomdat_sgi".$separator;
# 75 - 79
print "belopp_sgi".$separator."inktyp_kod_sgi".$separator."SSYK3".$separator."ar_yrke".$separator."lopnr_make_maka";
print "\n";
#==============================================================================================================================
# 0	lopnr
# 1	FALL_FROM_DATUM
# 2	FALL_TOM_DATUM
#       nbrt
#       nnet
#       cash
# 6	FORSAKRADTYP_KOD
# 7	DIAGNOS_KOD
# 8 	ar_sysselsatt
# 9	SYSS_STATUS_KOD
# 10	SNI_2007
# 11	CFAR_NR
# 12	KON_KOD
# 13	fodelsear
# 14	FODELSELAND_KOD
# 15	KOMMUN_KOD
# 26	fromdat_kommun
# 27	tomdat_kommun
# 28	ANTAL_HEMMA
# 29	fromdat_hemmafor
# 20	tomdat_hemmafor
# 21	ar_pgi
# 22	PGI
# 23	ar_sgi
# 24	belopp_sgi_ar
# 25	inktyp_kod_sgi_ar
# 36	fromdat_sgi
# 37	tomdat_sgi
# 38	belopp_sgi
# 39	inktyp_kod_sgi
# 30	SSYK3
# 31	ar_yrke
# 32	lopnr_make_maka
#================================================
while (<>) {
    chop;
    next if length $_ < 1;
    @sjukskrivningsfall = split "\t";
    $prev = $lopnr;
    $lopnr = $sjukskrivningsfall[0];
#    if ($lopnr < $prev) {die "************************** indata måste vara sorterad!\n";}
    next if $lopnr eq "lopnr";
    next unless $lopnr > 0;
#    $index = $lopnr.$sjukskrivningsfall[1].$sjukskrivningsfall[2]; # lopnrfråndatum-tilldatum sjukskrivningsfall
    my $thisstart = $sjukskrivningsfall[1];
    my $thisstop = $sjukskrivningsfall[2];
    my $brutto = $sjukskrivningsfall[3];
    my $deltid = $sjukskrivningsfall[4];
    my $cash = $sjukskrivningsfall[5];
    my $diagnos = $sjukskrivningsfall[7];
#==============================================================================================================================
# räkna ut saker om anamnes bakåt i tiden!
#==============================================================================================================================
# INIT
    for $per ("1y","2y","5y","hela") {
	for $kat ("alla","samma","F","M") {
	    $nvektor{$per}{$kat}{"brutto"} = 0;
	    $nvektor{$per}{$kat}{"deltid"} = "none";
	}
	for $kat (sort keys %diagnosisofinterest) {
	    $nvektor{$per}{$kat}{"brutto"} = 0;
	    $nvektor{$per}{$kat}{"deltid"} = "none";
	}
    }
#================================================
    my $tidpunkt = $parser->parse_datetime($thisstart);  # här är vi nu!
    my $tidpunktC1 = $parser->parse_datetime($thisstart);  # här är vi nu!
    my $tidpunktC2 = $parser->parse_datetime($thisstart);  # här är vi nu!
    my $tidpunktC5 = $parser->parse_datetime($thisstart);  # här är vi nu!
    my $bortreettparentes = $tidpunktC1->subtract_duration($ettaar);
    my $bortretvaaparentes = $tidpunktC2->subtract_duration($tvaaaar);
    my $bortrefemparentes = $tidpunktC5->subtract_duration($femaar);
    for $start (keys %{ $anamnes{$lopnr} }) { # tag alla kända fall med samma person (lopnr), de börjar i tur och ordning på "start"
	$slut = $anamnes{$lopnr}{$start}[1];  # ok - nu har vi hittat fall som börjar på start och slutar på slut
#=================== RÄKNA UT TIDSPERIOD
	my $sluttid1 = $parser->parse_datetime($slut); 
	my $sluttid2 = $parser->parse_datetime($slut); 
	my $sluttid5 = $parser->parse_datetime($slut); 
	my $begtid = $parser->parse_datetime($start); 
	my $ettefterslut = $sluttid1->add($ettaar);
	my $tvaaefterslut = $sluttid2->add($tvaaaar);
	my $femefterslut = $sluttid5->add($femaar);
	my %test;
	my %overlapp;
	for $per ("1y","2y","5y","hela") { 
	    $test{$per} = 0;
	    $overlapp{$per} = $anamnes{$lopnr}{$start}[2]; #brutto
	}
	$test{"hela"} = 651127;
	if  (DateTime->compare($ettefterslut,$tidpunkt) > 0) {# har fallet slutat mindre än ett år sedan?
	    $test{"1y"} = 1;
	    if  (DateTime->compare($bortreettparentes,$begtid) > 0) {  # har fallet börjat mer än ett år sedan?
		$overlapp{"1y"} = $overlapp{"1y"} - $bortreettparentes->delta_days($begtid)->in_units( 'days' );
	    }
	}
	if  (DateTime->compare($tvaaefterslut,$tidpunkt) > 0) {# har fallet slutat mindre än två år sedan?
	    $test{"2y"} = 1;
	    if  (DateTime->compare($bortretvaaparentes,$begtid) > 0) {  # har fallet börjat mer än två år sedan?
		$overlapp{"2y"} = $overlapp{"2y"} - $bortretvaaparentes->delta_days($begtid)->in_units( 'days' );
	    }
	}
	if  (DateTime->compare($femefterslut,$tidpunkt) > 0) {# har fallet slutat mindre än fem år sedan?
	    $test{"5y"} = 1;
	    if  (DateTime->compare($bortrefemparentes,$begtid) > 0) {  # har fallet börjat mer än fem år sedan?
		$overlapp{"5y"} = $overlapp{"5y"} - $bortrefemparentes->delta_days($begtid)->in_units( 'days' );
	    }
	}
#=================== DELTID
	for $per ("1y","2y","5y","hela") {
	    $var = "deltid";
	    if ($test{$per}) {
		$nvektor{$per}{"alla"}{$var} = "yes" if $anamnes{$lopnr}{$start}[3] eq "yes";
		if (&equivalent($anamnes{$lopnr}{$start}[5], $diagnos)) {
		    $nvektor{$per}{"samma"}{$var} = "yes" if $anamnes{$lopnr}{$start}[3] eq "yes";
		}
		if ($anamnes{$lopnr}{$start}[5] =~ /^F/) {
		    $nvektor{$per}{"F"}{$var} = "yes" if $anamnes{$lopnr}{$start}[3] eq "yes";
		}
		if ($diagnosisofinterest{$anamnes{$lopnr}{$start}[5]}) {
		    $nvektor{$per}{$anamnes{$lopnr}{$start}[5]}{$var} = "yes" if $anamnes{$lopnr}{$start}[3] eq "yes";
		}
		if ($anamnes{$lopnr}{$start}[5] =~ /^M/) {
		    $nvektor{$per}{"M"}{$var} = "yes" if $anamnes{$lopnr}{$start}[3] eq "yes";
		}
	    }
	}
#=================== BRUTTO
	for $per ("1y","2y","5y","hela") {
	    $var = "brutto";
	    $adder =  $overlapp{$per};
	    if ($test{$per}) {
		$nvektor{$per}{"alla"}{$var}	+= $adder;
		if (&equivalent($anamnes{$lopnr}{$start}[5], $diagnos)) {
		    $nvektor{$per}{"samma"}{$var}	+=  $adder;
		}
		if ($anamnes{$lopnr}{$start}[5] =~ /^F/) {
		    $nvektor{$per}{"F"}{$var}	+=  $adder;
		}
		if ($diagnosisofinterest{$anamnes{$lopnr}{$start}[5]}) {
		    $nvektor{$per}{$anamnes{$lopnr}{$start}[5]}{$var}	+=  $adder;
		}
		if ($anamnes{$lopnr}{$start}[5] =~ /^M/) {
		    $nvektor{$per}{"M"}{$var}	+=   $adder;
		}
	    }
	}
    }
#=================== OUTPUT
    print "$sjukskrivningsfall[0]".$separator;
    print "$sjukskrivningsfall[1]".$separator;
    print "$sjukskrivningsfall[2]".$separator;
    print "$sjukskrivningsfall[3]".$separator;
    print "$sjukskrivningsfall[4]".$separator;
    print "$sjukskrivningsfall[5]".$separator;
    for $kat ("alla","samma","F","M") {
	for $per ("1y","2y","5y","hela") {
	    print $kat."_".$per."_" if $debug;
	    print $nvektor{$per}{$kat}{"brutto"}.$separator;
	    if ($nvektor{$per}{$kat}{"brutto"} > 0 && $nvektor{$per}{$kat}{"deltid"} eq "none") {$nvektor{$per}{$kat}{"deltid"} = "full";}
	    print $nvektor{$per}{$kat}{"deltid"}.$separator;
	}
    }
    for $kat (sort keys %diagnosisofinterest) {
	for $per ("1y","2y","5y","hela") {
	    print $kat."_".$per."_" if $debug;
	    print $nvektor{$per}{$kat}{"brutto"}.$separator;
	    if ($nvektor{$per}{$kat}{"brutto"} > 0 && $nvektor{$per}{$kat}{"deltid"} eq "none") {$nvektor{$per}{$kat}{"deltid"} = "full";}
	    print $nvektor{$per}{$kat}{"deltid"}.$separator;
	}
    }
## #======================================================================================================================
## # hemma med barn?
## # slut på föräldraledighet:	
##     my $fend = $parser->parse_datetime($sjukskrivningsfall[25]);
##     if ($fend + $vecka > $tidpunkt) {
## 	print "yes\t"; 
##    } else {
## 	print "no\t";
##     }
##     
#======================================================================================================================
    for ($step=6; $step <= 32; $step++) {
	print "$step:" if $debug;
	if ($sjukskrivningsfall[$step]) {
	    print "$sjukskrivningsfall[$step]";
	} else {
	    print "nil";
	}
	print $separator;
    }
    print "\n";
#==============================================================================================================================
    if ($prev ne $lopnr) { # ny individ
	%anamnes = (); #reset cache
    }
#==============================================================================================================================
# skapa grund för kommande anamnesberäkning!
# en vektor med start slut nbrt deltid cash diagnos
    @{ $anamnes{$lopnr}{$thisstart} } = ($thisstart, $thisstop ,$brutto, $deltid, $cash,$diagnos);
}

exit();

sub equivalent {
    my ($d1, $d2) = @_;
    if ($d1 eq "-00") {return 0;}
    if ($d2 eq "-00") {return 0;}
    if ($d1 eq $d2) {return 1;}
    if ($d1 =~ /M1[56789]/ && $d2 =~ /M1[56789]/) {return 1;}
    return 0;
}
