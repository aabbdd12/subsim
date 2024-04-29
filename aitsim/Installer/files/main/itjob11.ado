*! version 3.00  15-December-2014   M. Araar Abdelkrim & M. Paolo verme
/*************************************************************************/
/* SUBSIM: Subsidy Simulation Stata Toolkit  (Version 3.0)               */
/*************************************************************************/
/* Conceived by Dr. Araar Abdelkrim[1] and Dr. Paolo Verme[2]            */
/* World Bank Group (2012-2016)		                                 */
/* 									 */
/* [1] email : aabd@ecn.ulaval.ca                                        */
/* [1] Phone : 1 418 656 7507                                            */
/*									 */
/* [2] email : pverme@worldbank.org                                      */
/*************************************************************************/


#delim ;

capture program drop dtable011_2;
program define  dtable011_2, rclass;
version 9.2;
syntax varlist  [,  HSize(varname) HGroup(varname) HWorker(varname) GNumber(int -1)];

tokenize `varlist';
tempvar _hs;
gen `_hs'=`hsize';
if (`gnumber'!=-1)  qui replace `_hs'=`_hs'*(`hgroup'==`gnumber');
local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 

tempvar _num _denum _fw _w _pc_inc;
qui gen `_fw'=`_hs';
if (`"`hweight'"'~="") qui replace `_fw'=`_fw'*`hweight';

qui gen `_w'=1;
if (`"`hweight'"'~="") qui replace `_w'=`hweight';
if (`gnumber'!=-1)     qui replace `_w'=`_w'*(`hgroup'==`gnumber');

qui sum `_fw';
return scalar est1  = `r(sum)';

qui sum `_w';
return scalar est2  = `r(sum)';

qui sum `hsize' [aw=`_w'];
return scalar est3   = `r(mean)';


qui sum `hworker' [aw=`_w'];

return scalar est4   = `r(mean)';
/*
qui sum `1' [aw=`_fw'];
return scalar est5   = `r(mean)';

qui gen `_pc_inc'=`2'/`_hs';
qui sum `_pc_inc' [aw=`_fw'];
return scalar est6   = `r(mean)';
*/
end;




capture program drop itjob11;
program define itjob11, eclass;
version 9.2;
syntax varlist(min=1 max=1)[, HHID(varname) HSize(varname) HGroup(varname)  INCOME(varname)  LAN(string)];


if ("`hgroup'"!="") {;
preserve;


capture {;
local lvgroup:value label `hgroup';
if ("`lvgroup'"!="") {;
uselabel `lvgroup' , clear;
qui count;
forvalues i=1/`r(N)' {;
local tem=value[`i'];
local grlab`tem' = label[`i'];
};
};
};
restore;
preserve;
tempvar key tot_inc is_inc hh_worker; 
qui gen `is_inc' = (`income'> 0);
qui by `hhid', sort : egen float   `tot_inc' = total(`income');
qui by `hhid', sort : egen float `hh_worker' = total(`is_inc');
qui egen byte `key' = tag(`hhid');
qui keep if `key'==1 ;
qui tabulate `hgroup', matrow(gn);
svmat int gn;
global indica=r(r);
tokenize `varlist';
};

if ("`hgroup'"=="") {;
tokenize `varlist';
_nargs    `varlist';
preserve;
tempvar key tot_inc is_inc hh_worker; 
qui gen `is_inc' = (`income'> 0);
qui by `hhid', sort : egen float   `tot_inc' = total(`income');
qui by `hhid', sort : egen float `hh_worker' = total(`is_inc');
qui egen byte `key' = tag(`hhid');
qui keep if `key'==1 ;
};



tempvar Variable EST1 EST2 EST3 EST4 EST5 EST6;
qui gen `Variable'="";
qui gen `EST1'=0;
qui gen `EST2'=0;
qui gen `EST3'=0;
qui gen `EST4'=0;
qui gen `EST5'=0;
qui gen `EST6'=0;


tempvar _ths;
qui gen  `_ths'=1;
if ( "`hsize'"!="") qui replace `_ths'=`hsize';
cap svy: total;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);
local ll=length("`1': `grlab`1''");
forvalues k = 1/$indica {;
local kk = gn1[`k'];
dtable011_2 `1' `tot_inc' ,  hsize(`_ths') hworker(`hh_worker') hgroup(`hgroup') gnumber(`kk');

qui replace `EST1'      = `r(est1)'  in `k';
qui replace `EST2'      = `r(est2)' in `k';
qui replace `EST3'      = `r(est3)' in `k';
qui replace `EST4'      = `r(est4)' in `k';
/*
qui replace `EST5'      = `r(est5)' in `k';
qui replace `EST6'      = `r(est6)' in `k';
*/
local label`f'  : label (`hgroup') `kk';
if ( "`label`f''" == "") local label`f'   = "Group: `kk'";
qui replace `Variable' = "`label`f''" in `k';
local ll=max(`ll',length("`label`f''"));
};
local ll=`ll'+10;


dtable011_2 `1' `tot_inc'  ,  hsize(`_ths')  hworker(`hh_worker');

local kk1 = $indica+1;
qui replace `Variable' = "Total" in `kk1';
qui replace `EST1'      = `r(est1)'  in `kk1';
qui replace `EST2'      = `r(est2)' in `kk1';
qui replace `EST3'      = `r(est3)' in `kk1';
qui replace `EST4'      = `r(est4)' in `kk1';
/*
qui replace `EST5'      = `r(est5)' in `kk1';
qui replace `EST6'      = `r(est6)' in `kk1';

*/
cap drop __compna;
qui gen  __compna=`Variable';

local lng = ($indica+1);
qui keep in 1/`lng';

local dste=0;
local rnam;
forvalues i=1(1)`lng'  {;
local temn=__compna[`i'];
               local rnam `"`rnam' "`temn'""';
};

global rnam `"`rnam'"';
tempname zz;
qui mkmat        `EST1'  `EST2' `EST3' `EST4' /* `EST5' `EST6' */,   matrix(`zz');


local cnam = "";
                     local cnam `"`cnam' "Population ""';
					 
if ("`lan'"~="fr")  local cnam `"`cnam' "Number of households""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Nombre de m�nages""';

if ("`lan'"~="fr")  local cnam `"`cnam' "Household size""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Taille du m�nage""';

if ("`lan'"~="fr")  local cnam `"`cnam' "Average  workers at HH level""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Moyenne des salari�s par m�nage""'

/*
if ("`lan'"~="fr")  local cnam `"`cnam' "Total incomes""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Revenues total""';

if ("`lan'"~="fr")  local cnam `"`cnam' "Total expenditures per capita""';
if ("`lan'"=="fr")  local cnam `"`cnam' "D�penses totale per capita""';

if ("`lan'"~="fr")  local cnam `"`cnam' "Total incomes per capita""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Revenues total par m�nage""';
*/
dis "";
matrix colnames `zz' = `cnam' ;
matrix rownames `zz' = `rnam' ;





cap matrix drop _vv _aa gn;

ereturn matrix est = `zz';

restore;
end;



