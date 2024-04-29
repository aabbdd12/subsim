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


#delimit;
capture program drop itjobgr3;
program define itjobgr3, eclass;
version 9.2;
syntax varlist(min=1)[, HHID(varname) HSize(varname)  HGroup(varname) ITSCH(string) FTSCH1(string) FTSCH2(string) FTSCH3(string) NSCEN(int 1)  PCEXP(varname) MIN(real 0) MAX(real 1000) OGR(string) LAN(string)  *];


tokenize  `varlist';
_nargs    `varlist';

if "`lan'"=="" local lan = "en";
tempvar Variable EST;
qui gen `EST'=0;

inc_tax `1' , itsch(`itsch') hsize(`hsize');
tempvar ini_tax;
cap drop ___suma;
by `hhid', sort : egen float ___suma = total(__inc_tax) ;
qui gen `ini_tax' =___suma/`hsize' ;
local glist `glist' `ini_tax'  ;

forvalues j=1/`nscen' {;
inc_tax `1' , itsch(`ftsch`j'') hsize(`hsize');

tempvar f`j'_tax;
cap drop ___suma;
by `hhid', sort : egen float ___suma = total(__inc_tax) ;
qui gen `f`j'_tax' =___suma/`hsize' ;
local glist `glist' `f`j'_tax' ;

};


local glegend legend(order(  1 "Per cap. tax: Initial" ;
forvalues i = 1/`nscen' {;
    local j = `i'+1;
	local `i': subinstr local `i' "," " ", all ;
	local glegend `"`glegend' `j' "Per cap. tax: Scenario `i'""';
	
};
local glegend `"`glegend' ))"';

tempvar key;
qui egen byte `key' = tag(`hhid');
preserve;
qui keep if `key'==1;

tgropt 3 `lan' ;

graph hbar (mean)  `glist' ,
 over(`hgroup') 
 bar(1, fcolor(blue)  fintensity(inten20) lcolor(white))
 bar(2, fcolor(blue)  fintensity(inten30) lcolor(white))
 bar(3, fcolor(blue)  fintensity(inten40) lcolor(white)) 
 bar(4, fcolor(blue)  fintensity(inten50) lcolor(white)) 
 scheme(s2color)  
 title(`r(gtitle)')  
`glegend'
`r(gstyle)' 
`ogr'
 ;
 cap drop `glist';

end;


