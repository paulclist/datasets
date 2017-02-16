set more off
/* 
This do file replicates the tables and figures from Clist & Verschoor's language paper. 
I'd recommend reading this in conjunction with the paper: go to paulclist.github.io for more info including the script. 
It makes use of some user-written commands such as cgmreg (see https://sites.google.com/site/judsoncaskey/data)
and the more common esttab (just type 'findit esttab' if not already installed) with latex output. 

open `ClistVerschoor17replication.dta' and then run the below. 

I haven't included the summary statistics of table 1, but these should be obvious to replicate if needed. 
*/

*** Figure 1 
histogram band if sessionl==1 & game_role==1, percent  discrete   xlabel(1 "0" 2 "1-9" 3 "10" 4 "11-19" 5 "20") ///
title("Luganda, Senders") name(temp3, replace) xtitle("")  nodraw 
histogram band if sessionl==2 & game_role==1, percent  discrete   xlabel(1 "0" 2 "1-9" 3 "10" 4 "11-19" 5 "20") ///
title("Lugisu, Senders") name(temp4, replace) xtitle("") ytitle("") nodraw 
histogram band if sessionl==1 & game_role==2, percent  discrete   xlabel(1 "0" 2 "1-9" 3 "10" 4 "11-19" 5 "20") ///
title("Luganda, Receivers") name(temp5, replace) xtitle("")  nodraw 
histogram band if sessionl==2 & game_role==2, percent  discrete   xlabel(1 "0" 2 "1-9" 3 "10" 4 "11-19" 5 "20") ///
title("Lugisu, Receivers") name(temp6, replace) xtitle("") ytitle("") nodraw 
gr combine temp3 temp4 temp5 temp6,  ycommon xcommon 

*** Table 3
ttest 	tokensinbox, by( sessionlanguage) 
ranksum tokensinbox, by( sessionlanguage)
ttest  	tokensinbox if game_role==1, by( signal )
ranksum tokensinbox if game_role==1, by( signal )
ttest  	tokensinbox if game_role==2, by( signal )
ranksum tokensinbox if game_role==2, by( signal )

*** Table 4
tab religion, gen(rel)
global control age gender education nakaloke_years rel1 rel2 rel3 business land 
gen send_coop=(game_role==1 & signal==1)
gen send_dont=(game_role==1 & signal==2)
gen rec_coop= (game_role==2 & signal==1)
gen rec_dont= (game_role==2 & signal==2)

cgmreg contribution15  sessionl send_dont send_coop rec_dont, cluster(sessionid )
est sto a
cgmreg contribution15  sessionl send_dont send_coop rec_dont $control, cluster(sessionid )
est sto b
esttab a b using table4.tex, star(* 0.10 ** 0.05 *** 0.01) replace fragment keep(sessionlanguage send_dont send_coop rec_dont) label

*** Table 5 
ttest tokensinbox if   tribe_own==1, by( sessionlanguage)
ttest tokensinbox if   tribe_own!=1, by( sessionlanguage)
ttest tokensinbox if   tribe_m==1, by( sessionlanguage)
ttest tokensinbox if   tribe_m!=1, by( sessionlanguage)
ttest tokensinbox if   language_main==1, by( sessionlanguage)
ttest tokensinbox if   language_main!=1, by( sessionlanguage)

*** Table 6
gen gisu_luganda=(dummy_bagisu==1 & sessionl==1) // create dummies
gen gisu_lugisu=(dummy_bagisu==1 & sessionl==2)
gen gisu_mother_luganda=(dummy_bagisu_mother==1 & sessionl==1) // create dummies
gen gisu_mother_lugisu=(dummy_bagisu_mother==1 & sessionl==2)
gen gisu_speaker_luganda=(dummy_lugisu==1 & sessionl==1) // create dummies
gen gisu_speaker_lugisu=(dummy_lugisu==1 & sessionl==2)

cgmreg contribution15  gisu_luganda gisu_lugisu, cluster(sessionid )
est sto c
cgmreg contribution15  gisu_luganda gisu_lugisu $control,  cluster(sessionid )
est sto d
cgmreg contribution15  gisu_mother_luganda gisu_mother_lugisu, cluster(sessionid )
est sto e
cgmreg contribution15  gisu_mother_luganda gisu_mother_lugisu $control,  cluster(sessionid )
est sto f
cgmreg contribution15  gisu_speaker_luganda gisu_speaker_lugisu, cluster(sessionid )
est sto g
cgmreg contribution15  gisu_speaker_luganda gisu_speaker_lugisu $control,  cluster(sessionid )
est sto h
esttab c d e f g h  using table6.tex,  star(* 0.10 ** 0.05 *** 0.01) replace fragment label

*** Table 7
gen gisu_coop=(dummy_bagisu==1 & signal==1)
gen gisu_dont=(dummy_bagisu==1 & signal==2)
gen non_coop=(dummy_bagisu==0 & signal==1)
gen non_dont=(dummy_bagisu==0 & signal==2)
gen gisu_speaker_coop=(dummy_lugisu==1 & signal==1)
gen gisu_speaker_dont=(dummy_lugisu==1 & signal==2)
gen gisu_mother_coop=(dummy_bagisu_mother==1 & signal==1)
gen gisu_mother_dont=(dummy_bagisu_mother==1 & signal==2)

cgmreg contribution15 gisu_dont gisu_coop non_coop if game_role==2, cluster(sessionid) 
est sto i 
test gisu_coop=gisu_dont
cgmreg contribution15 gisu_speaker_dont gisu_speaker_coop non_coop if game_role==2, cluster(sessionid) 
est sto j
test gisu_speaker_dont=gisu_speaker_coop
cgmreg contribution15 gisu_mother_coop gisu_mother_dont non_coop if game_role==2, cluster(sessionid) 
est sto k
test gisu_mother_coop =gisu_mother_dont
esttab i j k  using table7.tex,  star(* 0.10 ** 0.05 *** 0.01) replace fragment label

exit
