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



 
/*

stat:
exp_tt  : Total expenditures
exp_pc  : Expenditures per capita
exp_hh  : Expenditures per household

con_tt  : Total consumption
con_pc  : Consumption per capita
con_hh  : Consumption per household

*/



#delimit ;



capture program drop basicpov;
program define basicpov, rclass;
syntax varlist(min=1 max=1) [, HHID(varname) HSize(varname)  PLINE(varname)  PCEXP(varname) ALpha(real 0) ];
preserve; 
tokenize `varlist';
tempvar we ga0 ga10 ga1 hy;
gen `hy' = `1';
tempvar key;
qui egen byte `key' = tag(`hhid');

local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 
qui gen     `we'=`hsize';
qui replace `we'=`we'*`key' ;


if "`stat'" == "" local stat = "exp_tt";




gen `ga0' = 0;
gen `ga10' = 0;
gen `ga1' = 0;


if (`alpha'==0) qui replace `ga0' = `we'*(`pline'>`pcexp');
if (`alpha'~=0) qui replace `ga0' = `we'*((`pline'-`pcexp')/`pline')^`alpha' if (`pline'>`pcexp');

qui svy: ratio `ga0' / `we';
cap drop matrix _aa;
matrix _aa=e(b);
local fgt0 = el(_aa,1,1);
cap drop matrix _vv;
matrix _vv=e(V);
local ste0 = el(_vv,1,1)^0.5;



if (`alpha'==0) qui replace `ga1' = `we'*(`pline'>`hy');
if (`alpha'~=0) qui replace `ga1' = `we'*`key'*((`pline'-`hy')/`pline')^`alpha' if (`pline'>`hy');


qui replace `ga10' = `ga1'-`ga0';


qui svy: ratio `ga1' / `we';
cap drop matrix _aa;
matrix _aa=e(b);
local fgt1 = el(_aa,1,1);
cap drop matrix _vv;
matrix _vv=e(V);
local ste1 = el(_vv,1,1)^0.5;


qui svydes;
local fr=`r(N_units)'-`r(N_strata)';

qui svy: ratio `ga10' / `we';
cap drop matrix _aa;
matrix _aa=e(b);
local estdif = el(_aa,1,1);
cap drop matrix _vv;
matrix _vv=e(V);
local stedif = el(_vv,1,1)^0.5;




local tval = `estdif'/`stedif';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `stedif'==0 local pval = 0; 
return scalar pvaldif = `pval';

local tval = `fgt0'/`ste0';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `ste0'==0 local pval = 0; 
return scalar pval0 = `pval';

local tval = `fgt1'/`ste1';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `ste1'==0 local pval = 0; 
return scalar pval1 = `pval';

return scalar fgt0  = `fgt0'*100;
return scalar fgt1  = `fgt1'*100;
return scalar estdif  = `estdif'*100;
return scalar stedif  = `stedif'*100;
return scalar ste0 = `ste0'*100;
return scalar ste1 = `ste1'*100;
return scalar stedif = `stedif'*100;

end;



capture program drop itjobpov;
program define itjobpov, eclass;
version 9.2;
syntax varlist(min=1)[, 
HHID(varname)
HSize(varname)  
PCEXP(varname)
XRNAMES(string) 
LAN(string) 
STAT(string)
ALPHA(real 0)
pline(varname)
];




preserve;

tokenize `varlist';
_nargs    `varlist';
local indica2 = $indica+1;

tempvar total;
qui gen `total'=0;
tempvar Variable EST1 EST11 EST111   ;
qui gen `EST1'=0;
qui gen `EST11'=0;
qui gen `EST111'=0;




forvalues i=1/$indica {;
qui replace `total'=`total'+``i'';
};






tempvar Variable ;
qui gen `Variable'="";

tempvar _ths;
qui gen  `_ths'=1;
if ( "`hsize'"!="") qui replace `_ths'=`hsize';

cap svy: total;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);



tempvar sliving;
qui gen `sliving' = `pcexp'+`total';
basicpov `sliving' ,   hhid(`hhid') hsize(`_ths') pline(`pline')  alpha(`alpha') pcexp(`pcexp');

qui replace `EST1'=   `r(fgt0)'  in 	1;
qui replace `EST11'=  `r(ste0)' in 	1;
qui replace `EST111'= `r(pval0)'  in 	1;

qui replace `EST1'=   `r(fgt1)'  in 	2;
qui replace `EST11'=  `r(ste1)' in 	2;
qui replace `EST111'= `r(pval1)'  in 	2;

qui replace `EST1'  =  `r(estdif)'    in 3;
qui replace `EST11' =  `r(stedif)'  in 	3;
qui replace `EST111'=  `r(pvaldif)'  in 	3;









/****TO DISPLAY RESULTS*****/

local cnam = "";

if ("`lan'"~="fr")  local cnam `"`cnam' "Poverty level""';
if ("`lan'"~="fr")  local cnam `"`cnam' "Standard error""';
if ("`lan'"~="fr")  local cnam `"`cnam' "P-Value""';



if ("`lan'"=="fr")  local cnam `"`cnam' "Niveau de pauvreté""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Erreur type""';
if ("`lan'"=="fr")  local cnam `"`cnam' "P-Value""';




/*
local lng = (`indica2');
qui keep in 1/`lng';
*/
local dste=0;



tempname zz;

qui mkmat   `EST1'  `EST11'  `EST111'  in 1/3 ,   matrix(`zz');


local rnam;
local rnam `"`rnam' "Pre reform" "Post reform" "Change"  "';



matrix rownames `zz' = `rnam' ;
matrix colnames `zz' = `cnam' ;


cap matrix drop _vv _aa gn;


ereturn matrix est = `zz';

restore;

end;



