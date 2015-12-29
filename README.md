Kod för att hantera Försäkringskassans filer. 
Jussi Karlgren
jussi@kth.se

-------------------- 

wc -l huvudpersoner.txt 
117023751 huvudpersoner.txt

-------------------- 
0	lopnr
1	DELFORMAN1_KOD
2	DELFORMAN2_KOD
3	OMFATTNING
4	DAGBELOPP
5	DEL_FROM_DATUM
6	DEL_TOM_DATUM
7	DEL_DAGAR_TOT
8	DEL_DAGAR_BRUTTO
9	DEL_DAGAR_NETTO
10	DEL_BELOPP_BRUTTO
11	FALL_FROM_DATUM
12	FALL_FROM_DATUM2
13	FALL_TOM_DATUM
14	FALL_DAGAR_TOT
15	FORSAKRADTYP_KOD
16	DIAGNOS_KOD
17	ar_sysselsatt
18	SYSS_STATUS_KOD
19	SNI_2007
20	CFAR_NR
21	KON_KOD
22	fodelsear
23	FODELSELAND_KOD
24	KOMMUN_KOD
25	fromdat_kommun
26	tomdat_kommun
27	ANTAL_HEMMA
28	fromdat_hemmafor
29	tomdat_hemmafor
30	ar_pgi
31	PGI
32	ar_sgi
33	belopp_sgi_ar
34	inktyp_kod_sgi_ar
35	fromdat_sgi
36	tomdat_sgi
37	belopp_sgi
38	inktyp_kod_sgi
39	SSYK3
40	ar_yrke
41	lopnr_make_maka

-------------------- 

1. sortera på löpnummer

-------------------- 

kolla funktionen genom att excerpera några testfall med känt utfall ur huvudpersoner-filen. 

-------------------- 

2. kör pass1: perl pass1_aggregera.perl huvudpersoner.txt > resultat.pass1

-------------------- 

3. kör pass2: perl pass2_anamnes.perl resultat.pass1 > resultat.pass2

-------------------- 

4. kör pass3: perl pass3_makemaka.perl resultat.pass2 > resultat.pass3


