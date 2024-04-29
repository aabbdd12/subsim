*! version 1.00  15-December-2015   M. Araar Abdelkrim & M. Paolo verme
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





#delim ;
capture program drop _nlargs;
program define _nlargs, rclass;
version 9.2;
syntax namelist  [, ];
quietly {;
tokenize `namelist';
local k = 1;
mac shift;
while "``k''" ~= "" {; 
local k = `k'+1;
};
};
global indica=`k';
end;



#delim ;


#delimit ;
capture program drop itschdes ;
program define itschdes , rclass;
version 9.2;
syntax namelist  [,  DGRA(int 0) SGRA(string) EGRA(string) *];



_get_gropts , graphopts(`options') ;
	local options `"`s(graphopts)'"';
preserve;
tokenize `namelist';
_nlargs `namelist';


forvalues t=1/$indica {;
local  nrange=  `.``t''.nrange' ;
local  str    =  `.``t''.str' ;
qui count;
if r(N)<`nrange' qui set obs `nrange';
tempvar Variable tax;
qui gen `Variable'="";
qui gen `tax' = 0;
local pos = 1;
local mxb0 = 0;
forvalues i=1/`nrange' {;
local j= `i'-1;
local mxb`i' = `.``t''.ran[`i'].max' ;
qui replace `Variable' = " `mxb`j'' - `mxb`i'' " in `pos';
if `i'==`nrange' qui replace `Variable' = " `mxb`j'' and more " in `pos';
qui replace `tax'   = `.``t''.ran[`i'].tax' in `pos'  ;
local pos = `pos'+ 1;
};
                local  struc = "Increasing range Tax (IRT)."; 
if `str' == 2   local  struc = "Volume-differentiated tax (VDT) ."; 
if `str' == 3   local  struc = "IRT/VDT ."; 


	tempname table;
	.`table'  = ._tab.new, col(2);
	.`table'.width |30|20  |;
	.`table'.strcolor . . ;
	.`table'.numcolor yellow  yellow  ;
	.`table'.numfmt %16.0g  %16.6f  ;
	 di _n as text "{col 4} Description of income tax schedule:  ``t''";
	 di  as text "{col 4} Income tax structure:  `struc'";
    .`table'.sep, top;
    .`table'.titles "Income range    " "tax      "    ;
	.`table'.sep, mid;
	forvalues i=1/`nrange'{;
                                       .`table'.numcolor white yellow     ;
			                           .`table'.row `Variable'[`i'] `tax'[`i']   ; 
			                          
				           };
.`table'.sep,bot;

};

if (`dgra'==1) {;
local tmp=0;
local ttmp=0;
/*
set trace on;
set tracedepth 1;
*/
local lgd legend(order( ;
local pl = 0;
forvalues t=1/$indica {;
local  nrange=  `.``t''.nrange' ;
local  str    =  `.``t''.str' ;
                local  sstruc = "IRT"; 
if `str' == 2   local  sstruc = "VDT"; 
if `str' == 3   local  sstruc = "IRT/VDT"; 
qui count;
if r(N)<`nrange' qui set obs `nrange';
tempvar Variable tax maxbl ;
qui gen `Variable'="";
qui gen `tax' = 0;
qui gen `maxbl' = 0;
local pos = 1;
local mxb0 = 0;
forvalues i=1/`nrange' {;
local j= `i'-1;
local mxb`i' = `.``t''.ran[`i'].max' ;
qui replace `Variable' = " `mxb`j'' - `mxb`i'' " in `pos';
if `i'==`nrange' qui replace `Variable' = " `mxb`j'' and more " in `pos';

qui replace `tax' = `.``t''.ran[`i'].tax' in `pos'  ;
qui replace `maxbl' = `.``t''.ran[`i'].max' in `pos'  ;
if `i'==`nrange' local tmp`t'  = (`.``t''.ran[`j'].max')*1.2 ;
if `i'==`nrange' local ttmp`t' = (`.``t''.ran[`i'].tax') ;
if `i'==`nrange' qui replace `maxbl' = `tmp`t'' in `pos';
local pos = `pos'+ 1;

if `i'==`nrange' local tmp  = max(`tmp',`tmp`t'');
if `i'==`nrange' local ttmp = max(`ttmp',`ttmp`t'');
};





tempvar x`t' y`t';
qui gen `x`t'' = .;
qui gen `y`t'' = .;

qui replace `y`t'' = `maxbl'[1] in 1;
local pos  = 1;
local pos2 = 2;
local minobs = 2*`nrange';
qui count; if `r(N)'<`minobs' qui set obs `minobs';


forvalues i=1/`nrange' {;
qui replace `y`t'' = `tax'[`i'] in `pos';
qui replace `x`t'' = `maxbl'[`i'] in `pos2';

local pos = `pos'  + 1;
local pos2 = `pos2'+ 1;
qui replace `y`t'' = `tax'[`i'] in `pos';
if `i'!=`nrange' qui replace `x`t'' = `maxbl'[`i'] in `pos2';
local pos  = `pos'+ 1;
local pos2 = `pos2'+ 1;
};
qui replace `x`t'' = 0 in 1;



local ps`t' = `pos2'-2; 



if (`str'==1) {;
local cmd `cmd' line `y`t'' `x`t'' in 1/`minobs' || ;
local pl=`pl'+1;
};


if (`str'==2) {;
if `t'==1 local mycol  black;
if `t'==2 local mycol  blue;
if `t'==3 local mycol  red;
if `t'==4 local mycol  orange;
if `t'==5 local mycol  green;

forvalues i=1/`nrange' {;
tempvar z1_`t'_`i' z2_`t'_`i';
qui gen      `z1_`t'_`i''= `tax'[`i'] in 1;
qui replace  `z1_`t'_`i''= `tax'[`i'] in 2;
qui sum `x`t'' if `y`t''==`tax'[`i'] ;
local a = `r(min)';
qui gen `z2_`t'_`i''=  0        in 1;
qui replace `z2_`t'_`i''= `a'   in 2;
local   cmd `cmd'       (line `z1_`t'_`i'' `z2_`t'_`i''  in 1/2, lpattern(dash) lcolor(`mycol') )  ;
local pl=`pl'+1;
local    cmd `cmd'       (line `y`t'' `x`t'' if `y`t''==`tax'[`i'], lpattern(solid) lcolor(`mycol') )  ;
local pl=`pl'+1;
};
};

qui replace `x`t'' = `tmp' in `ps`t'';
local aa `"`pl' "``t'' (`sstruc')" "';
local lgd `lgd' `aa' ;
};

local ttmp = round(`ttmp'*1.2,0.01);
local tpas= `ttmp'/5;
local lgd `lgd' )) ;



twoway  `cmd' , `lgd' 
plotregion(margin(zero))
graphregion(margin(medlarge))
title(Income tax schedule(s))
xtitle(Income level)
ytitle(Tax rate)
ylabel(0(`tpas')`ttmp')
`options'
;




if( "`sgra'" ~= "") {;
graph save `"`sgra'"', replace;
};

if( "`egra'" ~= "") {;
graph export `"`egra'"', replace;
};

};
end;


