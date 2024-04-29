/*************************************************************************/
/* subsim: Subsidy Simulation Stata Toolkit  (Version 1.01)               */
/*************************************************************************/
/* Conceived and programmed by Dr. Araar Abdelkrim  (2006-2012)          */
/* Universite Laval, Quebec, Canada                                      */
/* email : aabd@ecn.ulaval.ca                                            */
/* Phone : 1 418 656 7507                                                */
/*************************************************************************/
/* module  : nettogross                                                     */                             
/*************************************************************************/







#delimit ;
capture program drop nettogross;
program define nettogross, rclass;
version 9.2;
syntax varlist(min=1)[ ,  
HSize(varname)
HGroup(varname)
ITSCH(string)
RESULT(string)
DGRA(int 0) NAME(string) dec(int 3)
 
 *
];


_get_gropts , graphopts(`options') ;
        local options `"`s(graphopts)'"';

if ("`itsch'"=="") {;
        di in r "The income tax schedule must be indicated: option itsch(...).";
          exit 198;
exit;
};

local ll = 20;

qui svyset ;
tokenize `varlist';
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);
global indicag=0;
local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 



local mxb0 = 0;






local nrange  =  `.`itsch'.nrange'; 
local n1= `nrange' - 1; 
forvalues i = 1/`n1' {;
local mxb`i'   = `.`itsch'.ran[`i'].max';
local tax`i'    = `.`itsch'.ran[`i'].tax';

};

local tax`nrange'   =  `.`itsch'.ran[`nrange'].tax';

local tx0 = 0;
local ttx0 = 0;
local max_net0=0;
forvalues i=1/`n1' {;
local j = `i' -1;
local tx`i' = (`mxb`i''-`mxb`j'')*`tax`i'';
local ttx`i' = `ttx`j''+ `tx`i'';
local max_net`i'= `.`itsch'.ran[`i'].max' - `ttx`i'';
/* dis `tx`i''  "  "  `ttx`i'' "  "`max_net`i''  ;   */
local xline `xline'  `mxb`i'' ;
};


tempvar class;
qui gen `class' = 0;

forvalues i=1/`n1' {;
local j = `i' -1;
qui replace `class' = `i' if `1'>`max_net`j'' & `1'<=`max_net`i'';
};

qui replace `class' = `nrange' if `1'>`max_net`n1'';

cap drop _gross_inc;
qui gen  _gross_inc = 0;


qui replace _gross_inc = (`1'-`max_net0')/(1-`tax1')            if `class'==1;

forvalues i=2/`n1' {;

local j = `i' -1;
qui replace _gross_inc = `mxb`j'' +(`1'-`max_net`j'')/(1-`tax`i'')   if `class'==`i';
};
qui replace _gross_inc =  `mxb`n1''+(`1'-`max_net`n1'')/(1-`tax`n1'') if `class'==`nrange';

/*
cap drop _class;
qui gen _class=`class';
*/




tempvar fw;
gen `fw'=1;
if ("`hweight'" ~="")     qui replace `fw'=`hweight';


qui sum `fw' if  `1'!=0;
local tot=r(sum);
forvalues i=1/`nrange' {;
qui sum `fw' if  `1'!=0 & `class'==`i';
local prop`i' = `r(sum)' / `tot' * 100;
};


local t = "itsch";
local  nrange=  `.``t''.nrange' ;
local  str    =  `.``t''.str' ;
qui count;
if r(N)<`nrange' qui set obs `nrange';
tempvar Variable tax prop;
qui gen `Variable'="";
qui gen `tax' = 0;
qui gen `prop' = 0;
local pos = 1;
local mxb0 = 0;
forvalues i=1/`nrange' {;
local j= `i'-1;
local mxb`i' = `.``t''.ran[`i'].max' ;
qui replace `Variable' = " `mxb`j'' - `mxb`i'' " in `pos';
if `i'==`nrange' qui replace `Variable' = " `mxb`j'' and more " in `pos';
qui replace `tax'   = `.``t''.ran[`i'].tax' in `pos'  ;
qui replace `prop'   = `prop`i'' in `pos'  ;
local pos = `pos'+ 1;
};
                local  struc = "Increasing range Tax (IRT)."; 
if `str' == 2   local  struc = "Volume-differentiated tax (VDT) ."; 
if `str' == 3   local  struc = "IRT/VDT ."; 


	tempname table;
	.`table'  = ._tab.new, col(3);
	.`table'.width |30|28 |28 |;
	.`table'.strcolor . . . ;
	.`table'.numcolor yellow  yellow  yellow  ;
	.`table'.numfmt %16.0g  %16.6f  %16.3f ;
	 di _n as text "{col 4} Description of income tax schedule:  ``t''";
	 di  as text "{col 4} Income tax structure:  `struc'";
    .`table'.sep, top;
    .`table'.titles "Income range    " "Tax rate     "   " Proportion of     "  ;
   .`table'.titles "                 " "             "   " worker population in (%) "  ;
	.`table'.sep, mid;
	forvalues i=1/`nrange'{;
                                       .`table'.numcolor white yellow    yellow     ;
			                           .`table'.row `Variable'[`i'] `tax'[`i']   `prop'[`i']  ; 
			                          
				           };
.`table'.sep,bot;






if `dgra'==1 {;

preserve;

qui keep if  `1'!=0;
tempvar fw;
gen `fw'=1;
if ("`hweight'" ~="")     qui replace `fw'=`hweight';
qui sort _gross_inc;
qui gen _ww = sum(`fw');
cap drop _pc;
qui sum _ww;
qui gen _pc=_ww/_ww[_N];
local min=0;
local max = 1.5*`mxb`n1'';
local m5=(`max'-`min')/5;

local ftitle = "The cumulative distribution of gross incomes";
local xtitle = "Gross income (y)";
local ytitle = "F(y)";
line  _pc _gross_inc  if _gross_inc<1.5*`mxb`n1'',
title(`ftitle')
ytitle(`ytitle')
xtitle(`xtitle') 
xscale(range(`min' `max'))
xlabel(`min'(`m5')`max', labsize(small))
ylabel(, labsize(small))
plotregion(margin(zero))
legend(size(small))
xline(`xline' , lpattern(dash))
ylabel(, nogrid) graphregion(fcolor(white) ifcolor(white))
`options' 

;

restore;

};


end;



