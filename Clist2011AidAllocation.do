*The file produces the tables 2 and 3 from the article Clist 2011 "25 Years of Aid Allocation Practice: Whither Selectivity"
*World Development, 39(10). The dataset can be found at https://sites.google.com/site/paulclist

xtset count year
global RN lngdp 
global POP lnpop 
global POL freedom pts 
global jaDIst lnimpj proxjp
global deDIst lnimpdeu proxde
global frDIst lnimpfra proxfr
global ntDIst lnimpnt proxnt
global swDIst lnimpsw proxsw
global usDIst lnimpus proxus
global ukDIst lnimpuk proxuk

*Table 2
xi: probit sharefr ($RN) ($POP) ($POL) ($frDIst), nolog
quietly est store fr
estat clas
local positive `r(P_1p)'
estadd scalar positive= `positive'
local negative `r(P_0n)'
estadd scalar negative= `negative'
xi: probit sharede ($RN) ($POP) ($POL) ($deDIst), nolog
quietly est store de
estat clas
local positive `r(P_1p)'
estadd scalar positive= `positive'
local negative `r(P_0n)'
estadd scalar negative= `negative'
xi: probit sharejp ($RN) ($POP) ($POL) ($jaDIst), nolog
quietly est store ja
estat clas
local positive `r(P_1p)'
estadd scalar positive= `positive'
local negative `r(P_0n)'
estadd scalar negative= `negative'
xi: probit shareit ($RN) ($POP) ($POL) ($itDIst), nolog
quietly est store it
estat clas
local positive `r(P_1p)'
estadd scalar positive= `positive'
local negative `r(P_0n)'
estadd scalar negative= `negative'
xi: probit shareuk ($RN) ($POP) ($POL) ($ukDIst), nolog
quietly est store uk
estat clas
local positive `r(P_1p)'
estadd scalar positive= `positive'
local negative `r(P_0n)'
estadd scalar negative= `negative'
xi: probit shareus ($RN) ($POP) ($POL) ($usDIst), nolog
quietly est store us
estat clas
local positive `r(P_1p)'
estadd scalar positive= `positive'
local negative `r(P_0n)'
estadd scalar negative= `negative'
xi: probit sharent ($RN) ($POP) ($POL) ($ntDIst), nolog
quietly est store nt
estat clas
local positive `r(P_1p)'
estadd scalar positive= `positive'
local negative `r(P_0n)'
estadd scalar negative= `negative'
xi: probit sharesw ($RN) ($POP) ($POL) ($swDIst), nolog
quietly est store sw
estat clas
local positive `r(P_1p)'
estadd scalar positive= `positive'
local negative `r(P_0n)'
estadd scalar negative= `negative'
esttab  fr de ja nt sw us uk using Table2.csv, cells(b(star fmt(a2)) t(par abs)) pr2 scalars(N positive negative) label nogap replace  
eststo clear

*Table 3
xi: reg lnsharefr $RN $POP $POL $frDIst if sharefr==1, beta
estadd beta
quietly est store fr
xi: reg lnsharede $RN $POP $POL $deDIst if sharede==1, beta
estadd beta
quietly est store de
xi: reg lnsharejp $RN $POP $POL $jaDIst if sharej==1, beta
estadd beta
quietly est store ja
xi: reg lnshareit $RN $POP $POL $itDIst if shareit==1, beta
estadd beta
quietly est store it
xi: reg lnshareuk $RN $POP $POL $ukDIst if shareuk==1, beta
estadd beta
quietly est store uk
xi: reg lnshareus $RN $POP $POL $usDIst if shareus==1, beta
estadd beta
quietly est store us
xi: reg lnsharent $RN $POP $POL $ntDIst if sharent==1, beta
estadd beta
quietly est store nt
xi: reg lnsharesw $RN $POP $POL $swDIst if sharesw==1, beta
estadd beta
quietly est store sw
esttab fr de ja nt sw us uk using Table3.csv,  cells(beta(star fmt(a2)) t(par abs)) margin(u) ar2 scalars(N) label nogap replace  
eststo clear
