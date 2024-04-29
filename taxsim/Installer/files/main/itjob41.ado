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
capture program drop itjob41;
program define itjob41, eclass;
version 9.2;
syntax varlist(min=1)[,  HHID(varname) HSize(varname) HGroup(varname) LAN(string) XRNAMES(string) PCEXP(varname) ITSCH(string)  FTSCH(string) GVIMP(int 0)];

tokenize  `varlist';
_nargs    `varlist';


tempvar Variable EST;
qui gen `EST'=0;

imwit `1' , itsch(`itsch') ftsch(`ftsch') hsize(`hsize');
 

itjobstat __imwit ,  hhid(`hhid') hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames("Total impact")      stat(inc_tt) ;
tempname mat41 ;
matrix `mat41'= e(est);

local rowsize = rowsof(`mat41');
local colsize = colsof(`mat41') - 1 ;
matrix `mat41' = `mat41'[1..`rowsize', 1..`colsize'];

itjobstat __imwit ,   hhid(`hhid')  hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames("Per capita impact")  stat(inc_pc) ;
tempname mat42 ;
matrix `mat42'= e(est);
local rowsize = rowsof(`mat42');
local colsize = colsof(`mat42') - 1 ;
matrix `mat42' = `mat42'[1..`rowsize', 1..`colsize'];
tempname mat412 ;
matrix `mat412'= `mat41' , `mat42';
ereturn matrix est = `mat412';



end;



