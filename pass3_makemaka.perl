#==============================================================================================================================
# plockar ut och aggregerar fall från den av FK tillhandahållna filen huvudpersoner.txt
# varje fall utökas med data för eventuell makemaka.
#==============================================================================================================================
use DateTime;
use DateTime::Format::Strptime;
my $debug = 0;
my $parser   = DateTime::Format::Strptime->new( pattern => '%Y-%m-%d' );
my $ettaar = DateTime::Duration->new( years => 1);
my $tvaaaar = DateTime::Duration->new( years => 2);
my $separator = "\t";
#==============================================================================================================================
open GIFT, "<make_maka.txt";
while (<GIFT>) {
my @v = split;
### $gift{$v[0]}{$v[1]}++;
### $gift{$v[1]}{$v[0]}++;
$gift1{$v[0]}++;
$gift1{$v[1]}++;
}
### #$makemakasjukstart{$v[0]} = $parser->parse_datetime($v[2]);
### #$makemakasjukstop{$v[0]} = $parser->parse_datetime($v[3]);
close GIFT;
#==============================================================================================================================
# 0-2
print "lopnr	FALL_FROM_DATUM	FALL_TOM_DATUM	";
# 3-5
print "nbrutto	deltid	summa_utbetalt	";
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
# 30-37
print "M_nbrutto_1y".$separator."M_deltid_1y".$separator;# M_summa_utbetalt_1y".$separator;
print "M_nbrutto_2y".$separator."M_deltid_2y".$separator;# M_summa_utbetalt_2y".$separator;
print "M_nbrutto_5y".$separator."M_deltid_5y".$separator;# M_summa_utbetalt_5y".$separator;
print "M_nbrutto_hittills".$separator."M_deltid_hittills".$separator;# M_summa_utbetalt_hittills".$separator;
# (6-...) -> 38-64
print "LIU_SYSSELSATTNING".$separator."DIAGNOS_KOD".$separator."ar_sysselsatt".$separator."SYSS_STATUS_KOD".$separator."SNI_2007".$separator."CFAR_NR".$separator."KON_KOD".$separator."fodelsear".$separator."LIU_Fodelseland3".$separator."KOMMUN_KOD".$separator."fromdat_kommun".$separator."tomdat_kommun".$separator."ANTAL_HEMMA".$separator."fromdat_hemmafor".$separator."tomdat_hemmafor".$separator."ar_pgi".$separator."PGI".$separator."ar_sgi".$separator."belopp_sgi_ar".$separator."inktyp_kod_sgi_ar".$separator."fromdat_sgi".$separator."tomdat_sgi".$separator."belopp_sgi".$separator."inktyp_kod_sgi".$separator."SSYK3".$separator."ar_yrke".$separator."lopnr_make_maka".$separator;
# 65-70
print "makemaka_nbrutto_1y".$separator;
print "makemaka_nbrutto_2y".$separator;
print "makemaka_F_nbrutto_1y".$separator;
print "makemaka_F_nbrutto_2y".$separator;
print "makemaka_M_nbrutto_1y".$separator;
print "makemaka_M_nbrutto_2y".$separator;
print "\n";
#==============================================================================================================================
while (<>) {
	chomp;
    next if length $_ < 1;
    @sjukskrivningsfall = split "\t";
    $lopnr = $sjukskrivningsfall[0];
    $start = $sjukskrivningsfall[1];
    $slut = $sjukskrivningsfall[2];
    next if $lopnr eq "lopnr";
    next unless $lopnr > 0;
    $makemaka = $sjukskrivningsfall[64];
    @{ $historia{$lopnr}{$slut} } = ($start,$sjukskrivningsfall[39],$sjukskrivningsfall[3]);
    unless ($makemaka) {
	print;
	print "\n"; 
    } else {
	s/\s+$//;
	print;
	print $separator;
	print ">>>>" if $debug;
	print $separator if $debug;
	my $endofperiodofinterest = $parser->parse_datetime($start);  # här är vi nu!
	my $tidpunktC1 = $parser->parse_datetime($start);  # här är vi nu!
	my $tidpunktC2 = $parser->parse_datetime($start);  # här är vi nu!
	my $bortreettparentes = $tidpunktC1->subtract_duration($ettaar); 
	my $bortretvaaparentes = $tidpunktC2->subtract_duration($tvaaaar);
	$endofperiodofinterest->subtract(days => 1);   # do not include starting day of this sick leave 
	$overlapp1a = 0;
	$overlapp2a = 0;
	$overlapp1F = 0;
	$overlapp2F = 0;
	$overlapp1M = 0;
	$overlapp2M = 0;
	for $makemakasluttid (keys %{ $historia{$makemaka} }) {
	    my $sluttid0 = $parser->parse_datetime($makemakasluttid);
	    my $sluttid1 = $parser->parse_datetime($makemakasluttid);
	    my $sluttid2 = $parser->parse_datetime($makemakasluttid);
	    my $begtid1 = $parser->parse_datetime($historia{$makemaka}{$makemakasluttid}[0]);
	    my $begtid2 = $parser->parse_datetime($historia{$makemaka}{$makemakasluttid}[0]);
	    my $ettefterslut = $sluttid1->add($ettaar);
	    my $tvaaefterslut = $sluttid2->add($tvaaaar);
	    if  (DateTime->compare($ettefterslut,$endofperiodofinterest) > 0) {# har makemakafallet slutat mindre än ett år sedan?
		print "\n!!! $begtid1\n" if $debug;
		print "!!! $sluttid0 -1y- $ettefterslut\n" if $debug;
		print "    sopoi: $bortreettparentes\n" if $debug;
		print "    eopoi: $endofperiodofinterest\n" if $debug;
		my $deltastart = $begtid1;
		if  (DateTime->compare($bortreettparentes,$begtid1) > 0) {  # har makemakafallet börjat mer än ett år sedan?
		    $deltastart=$bortreettparentes;
		}
		$deltastart->subtract(days => 1); # hack to include first day of period
		print "   $deltastart --->" if $debug;
		my $deltaend = $sluttid0;
		if  (DateTime->compare($sluttid0,$endofperiodofinterest) > 0) {  # håller makemakafallet fortfarande på?
		    $deltaend = $endofperiodofinterest;
		}
		print "---> $deltaend ---> " if $debug;
		my $delta = $deltaend->delta_days($deltastart)->in_units( 'days' );
		print "$delta\n" if $debug;
		$overlapp1a += $delta;
#		if ($overlapp1a > 366) {$overlapp1a = 366;}
		if ($historia{$makemaka}{$makemakasluttid}[1] =~ /^F/) {
		    $overlapp1F += $delta;
#		    if ($overlapp1F > 366) {$overlapp1F = 366;}
		}
		if ($historia{$makemaka}{$makemakasluttid}[1] =~ /^M/) {
		    $overlapp1M += $delta;
#		    if ($overlapp1M > 366) {$overlapp1M = 366;}
		}
	    }
	    if  (DateTime->compare($tvaaefterslut,$endofperiodofinterest) > 0) {# har makemakafallet slutat mindre än 2 år sedan?
		print "\n2!! $begtid2\n" if $debug;
		print "2!! $sluttid0 -2y- $tvaaefterslut\n" if $debug;
		print "2    sopoi: $bortretvaaparentes\n" if $debug;
		print "2    eopoi: $endofperiodofinterest\n" if $debug;
		my $deltastart = $begtid2;
		if  (DateTime->compare($bortretvaaparentes,$begtid2) > 0) {  # har makemakafallet börjat mer än 2 år sedan?
		    $deltastart=$bortretvaaparentes;
		} 
		$deltastart->subtract(days => 1); # hack to include first day of period
		print "2  $deltastart --->" if $debug;
		my $deltaend = $sluttid0;
		if  (DateTime->compare($sluttid0,$endofperiodofinterest) > 0) {  # håller makemakafallet fortfarande på?
		    $deltaend = $endofperiodofinterest;
		}
		print "---> $deltaend ---> " if $debug;
		my $delta = $deltastart->delta_days($deltaend)->in_units( 'days' );
		print "$delta\n" if $debug;
		$overlapp2a += $delta;
#		if ($overlapp2a > 731) {$overlapp2a = 731;}
		if ($historia{$makemaka}{$makemakasluttid}[1] =~ /^F/) {
		    $overlapp2F += $delta;
#		    if ($overlapp2F > 731) {$overlapp2F = 731;}
		}
		if ($historia{$makemaka}{$makemakasluttid}[1] =~ /^M/) {
		    $overlapp2M += $delta;
#		    if ($overlapp2M > 731) {$overlapp2M = 731;}
		}
	    } else { # ta bort det! det är för gammalt och slöar ner programmet!#
		undef $historia{$makemaka}{$makemakasluttid};
	    }
	}
	print "$overlapp1a".$separator;
	print "$overlapp2a".$separator;
	print "$overlapp1F".$separator;
	print "$overlapp2F".$separator;
	print "$overlapp1M".$separator;
	print "$overlapp2M";
	print "\n";
    }
}






