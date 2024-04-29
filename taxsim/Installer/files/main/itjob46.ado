*! version 1.00  03-Mayo-2017   M. Araar Abdelkrim & M. Paolo verme
/*************************************************************************/
/* TAXSIM: TAX Simulation Stata Toolkit  (Version 1.0)               */
/*************************************************************************/
/* Conceived by Dr. Araar Abdelkrim[1] and Dr. Paolo Verme[2]            */
/* World Bank Group (2012-2016)		                                 */
/* 									 */
/* [1] email : aabd@ecn.ulaval.ca                                        */
/* [1] Phone : 1 418 656 7507                                            */
/*									 */
/* [2] email : pverme@worldbank.org                                      */
/*************************************************************************/




#delimit;
capture program drop itjob46;
program define itjob46, eclass;
version 9.2;
syntax varlist(min=1)[,  HHID(varname) HSize(varname) HGroup(varname) LAN(string) XRNAMES(string) PCEXP(varname) ITSCH(string)  FTSCH(string)  GVIMP(int 0)];

tokenize  `varlist';
_nargs    `varlist';


tempvar Variable EST;
qui gen `EST'=0;

inc_tax `1' , itsch(`itsch') hsize(`hsize');
tempvar i_tax;
cap drop ___suma;
by `hhid', sort : egen float ___suma = total(__inc_tax) ;
gen `i_tax' = ___suma / `hsize' ;
cap drop ___suma;

inc_tax `1' , itsch(`ftsch') hsize(`hsize');
tempvar f_tax;
cap drop ___suma;
by `hhid', sort : egen float ___suma = total(__inc_tax) ;
gen `f_tax' = ___suma / `hsize' ;
cap drop ___suma;

itjobprog  `i_tax' `f_tax' ,   hhid(`hhid')  hs(`hsize')  lan(`lan')   xrnames(`slist')  pcexp(`pcexp')  ;
cap drop `drlist';
tempname mat46 ;
matrix `mat46'= e(est);
/*
if (`wappr'==2) {;
local rowsize = rowsof(`mat47');
local colsize = colsof(`mat47');
forvalues i=1/`rowsize' {;
 matrix `mat47'[ `i',`colsize'] = el(`mat47tot',`i',1);
};

};
*/
ereturn matrix est = `mat46';

end;



