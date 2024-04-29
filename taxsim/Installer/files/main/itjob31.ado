*! version 1.00  03-Mayo-2017   M. Araar Abdelkrim & M. Paolo verme
/*************************************************************************/
/* TAXSIM: TAX Simulation Stata Toolkit  (Version 1.0)               */
/*************************************************************************/
/* Conceived by Dr. Araar Abdelkrim[1] and Dr. Paolo Verme[2]            */
/* World Bank Group (2012-2016)		                                 */
/* 									 */
/* [1] email : aabd@ecn.ulaval.ca                                        */
/* [1] Phone : 1 318 656 7507                                            */
/*									 */
/* [2] email : pverme@worldbank.org                                      */
/*************************************************************************/


#delimit;
capture program drop itjob31;
program define itjob31, eclass;
version 9.2;
syntax varlist(min=1)[,  HHID(varname) HSize(varname) HGroup(varname) LAN(string) XRNAMES(string) PCEXP(varname) INCOME(varname) ITSCH(string)  FTSCH1(string) FTSCH2(string) FTSCH3(string) NSCEN(int 1)   GVIMP(int 0)];

tokenize  `varlist';
_nargs    `varlist';


tempvar Variable EST;
qui gen `EST'=0;

inc_tax `1' , itsch(`itsch') hsize(`hsize');
tempvar ini_tax;
qui gen `ini_tax' =__inc_tax ;

forvalues j=1/`nscen' {;
inc_tax `1' , itsch(`ftsch`j'') hsize(`hsize');
tempvar f`j'_tax;
qui gen `f`j'_tax' =__inc_tax ;

 };


itjobstat `ini_tax' `f1_tax' `f2_tax' `f3_tax',  hhid(`hhid') hs(`hsize') hgroup(`hgroup') lan(`lan')  income(`income')  xrnames("Initial" "Final")  stat(tax_pc) ;
tempname mat31 ;
matrix `mat31'= e(est);

local rowsize = rowsof(`mat31');
local colsize = colsof(`mat31') - 1 ;
matrix `mat31' = `mat31'[1..`rowsize', 1..`colsize'];


local cnam = "";

if ("`lan'"~="fr")  local cnam `"`cnam' "Initial""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Final""';

if ("`lan'"~="fr")  local cnam `"`cnam' "Final""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Finale""';


matrix colnames `mat31' = `cnam' ;


ereturn matrix est = `mat31';


end;



