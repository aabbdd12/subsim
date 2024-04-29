*! version 3.00  15-December-2014   M. Araar Abdelkrim & M. Paolo verme
/*************************************************************************/
/* itSIM: itsidy Simulation Stata Toolkit  (Version 3.0)               */
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
capture program drop basicineq;
program define basicineq, rclass;
syntax varlist(min=2 max=2) [, HHID(varname) HSize(varname)];
preserve; 
tokenize `varlist';
tempvar fw;


local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 
qui gen `fw'=`hsize';
if ("`hweight'"~="")    qui replace `fw'=`fw'*`hweight';

tempvar key ;
qui egen byte `key' = tag(`hhid');
qui drop if `key'!=1;


qui sort `1' ;
tempvar smw smwy l1smwy ca;
gen `smw'  =sum(`fw');
gen `smwy' =sum(`1'*`fw');
gen `l1smwy'=0;
local mu=`smwy'[_N]/`smw'[_N];
local suma=`smw'[_N];
qui count;
forvalues i=2/`r(N)' { ;
qui replace `l1smwy'=`smwy'[`i'-1]  in `i';
};
gen `ca'=`mu'+`1'*((1.0/`smw'[_N])*(2.0*`smw'-`fw')-1.0) - (1.0/`smw'[_N])*(2.0*`l1smwy'+`fw'*`1'); 
sum `ca' [aw=`fw'], meanonly; 

local xi = `r(mean)';
tempvar vec_a vec_b vec_c vec_d  theta v1 v2 sv1 sv2;
            qui count;
            qui count;
            local fx=0;
            gen `v1'=`fw'*`1';
            gen `v2'=`fw';
            gen `sv1'=sum(`v1');
            gen `sv2'=sum(`v2') ;
            qui replace `v1'=`sv1'[`r(N)']   in 1;
            qui replace `v2'=`sv2'[`r(N)']   in 1;
			qui replace `v1'=`sv1'[`r(N)']-`sv1'[_n-1]   in 2/`=_N'; 
			qui replace `v2'=`sv2'[`r(N)']-`sv2'[_n-1]   in 2/`=_N';
			gen `theta'=`v1'-`v2'*`1';
			qui replace `theta'=`theta'*(2.0/`suma')  in 1/`=_N'; 
			tempvar fxvar;
			qui gen `fxvar'=sum(`fw'*`1');
			local fx = `fxvar'[`=_N']/`suma';
            qui  gen `vec_a' = `hsize'*((1.0)*`ca'+(`1'-`fx')+`theta'-(1.0)*(`xi'));
            qui  gen `vec_b' =  2*`hsize'*`1';
	
cap drop `theta';
cap drop `v1';
cap drop `v2'; 
cap drop `sv1';
cap drop `sv2'; 
			
qui sort `2' ;
tempvar smw smwy l1smwy ca;
gen `smw'  =sum(`fw');
gen `smwy' =sum(`2'*`fw');
gen `l1smwy'=0;
local mu=`smwy'[_N]/`smw'[_N];
local suma=`smw'[_N];
qui count;
qui replace `l1smwy'=`smwy'[_n-1]  in 2/`=_N';
gen `ca'=`mu'+`2'*((1.0/`smw'[_N])*(2.0*`smw'-`fw')-1.0) - (1.0/`smw'[_N])*(2.0*`l1smwy'+`fw'*`2'); 
sum `ca' [aw=`fw'], meanonly; 
*return scalar gini = `r(mean)'/(2*`mu')*100;
local xi = `r(mean)';

            qui count;
            local fx=0;
            gen `v1'=`fw'*`2';
            gen `v2'=`fw';
            gen `sv1'=sum(`v1');
            gen `sv2'=sum(`v2') ;
            qui replace `v1'=`sv1'[`r(N)']   in 1;
            qui replace `v2'=`sv2'[`r(N)']   in 1;
			qui replace `v1'=`sv1'[`r(N)']-`sv1'[_n-1]   in 2/`=_N'; 
			qui replace `v2'=`sv2'[`r(N)']-`sv2'[_n-1]   in 2/`=_N';
			gen `theta'=`v1'-`v2'*`2';
			qui replace `theta'=`theta'*(2.0/`suma')  in 1/`=_N'; 
			tempvar fxvar;
			qui gen `fxvar'=sum(`fw'*`2');
			local fx = `fxvar'[`=_N']/`suma';
            qui  gen `vec_c' = `hsize'*((1.0)*`ca'+(`2'-`fx')+`theta'-(1.0)*(`xi'));
            qui  gen `vec_d' =  2*`hsize'*`2';			
	       

qui svy: ratio `vec_a' / `vec_b';
cap drop matrix _aa;
matrix _aa=e(b);
local gini0 = el(_aa,1,1);
cap drop matrix _vv;
matrix _vv=e(V);
local ste0 = el(_vv,1,1)^0.5;



qui svy: ratio `vec_c' / `vec_d';
cap drop matrix _aa;
matrix _aa=e(b);
local gini1 = el(_aa,1,1);
cap drop matrix _vv;
matrix _vv=e(V);
local ste1 = el(_vv,1,1)^0.5;


qui svydes;
local fr=`r(N_units)'-`r(N_strata)';

			qui svy: mean `vec_a' `vec_b'  `vec_c'  `vec_d' ;
			qui nlcom (_b[`vec_a']/_b[`vec_b'] - _b[`vec_c']/_b[`vec_d']) , iterate(10000);
				
tempname aa;
matrix `aa'=r(b);
local estdif = el(`aa',1,1);
tempname vv;
matrix `vv'=r(V);
local stedif = el(`vv',1,1)^0.5;







local tval = `estdif'/`stedif';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `stedif'==0 local pval = 0; 
return scalar pvaldif = `pval';

local tval = `gini0'/`ste0';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `ste0'==0 local pval = 0; 
return scalar pval0 = `pval';

local tval = `gini1'/`ste1';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `ste1'==0 local pval = 0; 
return scalar pval1 = `pval';

return scalar gini0  = `gini0'*100;
return scalar gini1  = `gini1'*100;
return scalar estdif  = `estdif'*100;
return scalar stedif  = `stedif'*100;
return scalar ste0 = `ste0'*100;
return scalar ste1 = `ste1'*100;
return scalar stedif = `stedif'*100;
		
restore;
end;



capture program drop itjobineq;
program define itjobineq, eclass;
version 9.2;
syntax varlist(min=1)[, 
HHID(varname)
HSize(varname)  
PCEXP(varname)
XRNAMES(string) 
LAN(string) 
];


preserve;

tokenize `varlist';
_nargs    `varlist';
local indica2 = $indica+1;

tempvar total;
qui gen `total'=0;
tempvar Variable EST1 EST11 EST111 ;
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
basicineq `sliving' `pcexp',  hhid(`hhid')  hsize(`_ths') ;

qui replace `EST1'=   `r(gini0)'  in 	1;
qui replace `EST11'=  `r(ste0)' in 	1;
qui replace `EST111'= `r(pval0)'  in 	1;

qui replace `EST1'=   `r(gini1)'  in 	2;
qui replace `EST11'=  `r(ste1)' in 	2;
qui replace `EST111'= `r(pval1)'  in 	2;

qui replace `EST1'  =  `r(estdif)'    in 3;
qui replace `EST11' =  `r(stedif)'  in 	3;
qui replace `EST111'=  `r(pvaldif)'  in 	3;









/****TO DISPLAY RESULTS*****/

local cnam = "";

if ("`lan'"~="fr")  local cnam `"`cnam' "Gini index""';
if ("`lan'"~="fr")  local cnam `"`cnam' "Standard error""';
if ("`lan'"~="fr")  local cnam `"`cnam' "P-Value""';



if ("`lan'"=="fr")  local cnam `"`cnam' "Indice de Gini""';
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



