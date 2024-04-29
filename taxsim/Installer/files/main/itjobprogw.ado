*! version 1.00  03-Mayo-2017   M. Araar Abdelkrim & M. Paolo verme
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
capture program drop basicprogw;
program define basicprogw, rclass;
syntax varlist(min=2 max=2) [, rank(varname) ];
preserve; 
tokenize `varlist';
tempvar fw;


local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 
qui gen `fw'=1;
if ("`hweight'"~="")    qui replace `fw'=`fw'*`hweight';
qui drop if `rank' == 0 ; 



sort `rank' , stable;


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
qui sum `ca' [aw=`fw'], meanonly; 
local gini=`r(mean)'/(2.0*`mu');
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
            qui  gen `vec_a' = ((1.0)*`ca'+(`1'-`fx')+`theta'-(1.0)*(`xi'));
            qui  gen `vec_b' =  2*`1';
	
cap drop `theta';
cap drop `v1';
cap drop `v2'; 
cap drop `sv1';
cap drop `sv2'; 
			
tempvar smw smwy l1smwy ca;
gen `smw'  =sum(`fw');
gen `smwy' =sum(`2'*`fw');
gen `l1smwy'=0;
local mu=`smwy'[_N]/`smw'[_N];
local suma=`smw'[_N];
qui count;
qui replace `l1smwy'=`smwy'[_n-1]  in 2/`=_N';
gen `ca'=`mu'+`2'*((1.0/`smw'[_N])*(2.0*`smw'-`fw')-1.0) - (1.0/`smw'[_N])*(2.0*`l1smwy'+`fw'*`2'); 
qui sum `ca' [aw=`fw'], meanonly; 


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
            qui  gen `vec_c' = ((1.0)*`ca'+(`2'-`fx')+`theta'-(1.0)*(`xi'));
            qui  gen `vec_d' =  2*`2';			
	       
			qui svy: mean `vec_a' `vec_b'  `vec_c'  `vec_d' ;
			qui nlcom ( _b[`vec_c']/_b[`vec_d'] - _b[`vec_a']/_b[`vec_b']) , iterate(10000);
				
tempname aa;
matrix `aa'=r(b);
local dif = el(`aa',1,1);
return scalar kakwani = `dif';

tempname vv;
matrix `vv'=r(V);
local sdif = el(`vv',1,1)^0.5;
return scalar sdif = `sdif';

qui svydes;
local fr=`r(N_units)'-`r(N_strata)';
local tval = `dif'/`sdif';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `sdif'==0 local pval = 0; 
return scalar pval = `pval';
		
restore;
end;



capture program drop itjobprogw;
program define itjobprogw, eclass;
version 9.2;
syntax varlist(min=1 max=2)[, 
groinc(varname)
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


cap svy: total;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);




basicprogw `groinc' `1',  rank(`groinc') ;
qui replace `Variable' = "Pre-reform" in 1;
qui replace `EST1'=  `r(kakwani)'*100  in 	1;
qui replace `EST11'= `r(sdif)'*100  in 	1;
qui replace `EST111'=  `r(pval)'  in 	1;




basicprogw `groinc' `2',   rank(`groinc') ;
qui replace `Variable' = "Post-reform" in 2;
qui replace `EST1'=  `r(kakwani)'*100  in 	2;
qui replace `EST11'= `r(sdif)'*100  in 	2;
qui replace `EST111'=  `r(pval)'  in 	2;


basicprogw `1' `2',   rank(`groinc') ;
qui replace `EST1'=  `r(kakwani)'*100  in 3;
qui replace `EST11'=  `r(sdif)'*100  in 3;
qui replace `EST111'=  `r(pval)'  in 3;
qui replace `Variable' = "Change" in 3;




/****TO DISPLAY RESULTS*****/

local cnam = "";

					 
if ("`lan'"~="fr")  local cnam `"`cnam' "The Kakwani index""';
if ("`lan'"~="fr")  local cnam `"`cnam' "Standard error""';
if ("`lan'"~="fr")  local cnam `"`cnam' "P_Value""';

if ("`lan'"=="fr")  local cnam `"`cnam' "Indice de Kakwani""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Erreur type""';
if ("`lan'"=="fr")  local cnam `"`cnam' "P_Value""';



local lng = (`indica2');
qui keep in 1/`lng';

local dste=0;



tempname zz;
qui mkmat   `EST1' `EST11' `EST111',   matrix(`zz');



local rnam;
local rnam `"`rnam' "Pre reform" "Post reform" "Change"  "';




matrix rownames `zz' = `rnam' ;
matrix colnames `zz' = `cnam' ;


cap matrix drop _vv _aa gn;

ereturn matrix est = `zz';

restore;

end;



