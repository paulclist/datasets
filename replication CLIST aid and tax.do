set more off
* use "aid and tax 2\website do files\dataset aid and tax 2014.dta", clear
* load the data, available from https://sites.google.com/site/paulclist/data


* Table 1, columns 1-4. 
xtreg lntax  oda oda_2 agri indus lngdppc  trade_openess i.year if year>1979 & year<2010 & benedeksample==1, robust fe // their table 1 col 1
est store reg1 //orig model1
estadd scalar Groups =e(N_g)
xtreg lntax  oda_loans oda_loans_2 oda_grants oda_grants_2 agri indus lngdppc  trade_openess  i.year if year>1979 & year<2010 & benedeksample==1, fe robust  // their table 1 col 4
est store reg3 //orig model2
estadd scalar Groups =e(N_g)
xtreg lntax  oda oda_2 agri indus lngdppc  trade_openess i.tax_src i.year if year>1979 & year<2010 & benedeksample==1, robust fe // their table 1 col 1
est store reg2 //sourcedummies model1
estadd scalar Groups =e(N_g)
xtreg lntax  oda_loans oda_loans_2 oda_grants oda_grants_2 agri indus lngdppc  trade_openess i.tax_src i.year if year>1979 & year<2010 & benedeksample==1, fe robust  // their table 1 col 4
est store reg4 //sourcedummies model2
estadd scalar Groups =e(N_g)
estout reg1 reg2 reg3 reg4 , style(tex)  cells(b(star fmt(3)) t(par fmt(2)))   ///
varlabels(_cons Constant oda_loans Loans oda_loans_2 "Loans Squared" oda_grants "Grants" oda_grants_2 "Grants Squared" agri Agriculture indus Industry lngdppc  "GDP pc (Logged)" trade_openess "Trade Openness" /// 
1.tax_src "WEO Gen" 2.tax_src "GFS 2001 Cen" 3.tax_src "GFS 2001 Cen" 4.tax_src "GFS 1986 Cen" 5.tax_src "GFS 2001 Bud" 6.tax_src "Afri R M") ///
stats(r2_o r2_b N Groups, labels(Overall-R-Squared  Between-R-Squared  Observations Countries) fmt(%9.2f %9.2f %9.0g %9.0g) ) starlevels(* 0.1 ** 0.05 *** 0.01 )

* Table 3.
forvalues i=0/6 {
xtreg lntax  oda oda_2 agri indus lngdppc  trade_openess i.year if year>1979 & year<2010 & benedeksample==1 & tax_src==`i', robust fe 
est store a`i'
estadd scalar Groups =e(N_g)
}
estout a0 a1 a2 a3 a4 a5 a6 , keep(oda oda_2 agri indus lngdppc  trade_openess)  varlabels(_cons Constant) style(tex)  cells(b(star fmt(3)) t(par fmt(2))) stats(r2_o r2_b N Groups, labels(Overall-R-Squared  Between-R-Squared  Observations Countries) fmt(%9.2f %9.2f %9.0g %9.0g) )

*table 4
foreach var of varlist taxrev_* rev_* revenuebyGDP* {
gen ln`var' = ln(`var')
}
 foreach var of varlist lntaxrev_ba_gfs lntaxrev_cg_gfs lntaxrev_gg_gfs lnrevenuebyGDP_weo  lntaxrev_cg_oecd {
local temp = 0
display `temp'
foreach var2 of varlist lntaxrev_ba_gfs lntaxrev_cg_gfs lntaxrev_gg_gfs lnrevenuebyGDP_weo  lntaxrev_cg_oecd {
local temp = `temp'+1
display `temp'
capture reg `var' `var2'
eststo `var'`temp'
test _cons=0
estadd scalar alpha = r(p) 
test _b[`var2']=1
estadd scalar beta = r(p) 
}
}
foreach var of varlist lntaxrev_ba_gfs lntaxrev_cg_gfs lntaxrev_gg_gfs lnrevenuebyGDP_weo  lntaxrev_cg_oecd {
estout `var'*, style(tex) stats( alpha beta N ,fmt(%9.2f %9.2f %9.0f ) )  keep(_cons )  mlabels(,dep)
}

*table 5
foreach var of varlist  taxrev_ba_gfs  taxrev_cg_gfs taxrev_gg_gfs revenuebyGDP_weo taxrev_cg_oecd  {
capture xtreg ln`var' l.oda_loans l.oda_grants agri indus lngdppc  imports exports i.year if year>1979  & benedeksample==1, fe robust  // their table 1 col 4
eststo table5`var'
}
estout table5* , style(tex)  cells(b(star fmt(3)) t(par fmt(2)))  keep(L.oda_loans L.oda_grants agri indus lngdppc  imports exports)  ///
stats(r2_o r2_b N N_g, labels(Overall-R-Squared  Between-R-Squared  Observations Countries) fmt(%9.2f %9.2f %9.0g %9.0g) ) starlevels(* 0.1 ** 0.05 *** 0.01 )


*table 6
sem (Latent_tax <-l.oda_loans l.oda_grants agri indus lngdppc  imports exports if year>1979 & year<2010 & benedeksample==1) ///
(  Latent_tax -> lntaxrev_ba_gfs  lnrevenuebyGDP_weo ), method(mlmv) latent(Latent_tax)
eststo table6
estout  table6, style(tex)  cells(b(star fmt(3)) t(par fmt(2)))    ///
stats(r2_o r2_b N N_g, labels(Overall-R-Squared  Between-R-Squared  Observations Countries) fmt(%9.2f %9.2f %9.0g %9.0g) ) starlevels(* 0.1 ** 0.05 *** 0.01 )
estat eqgof
