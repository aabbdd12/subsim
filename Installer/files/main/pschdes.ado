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
capture program drop pschdes ;
program define pschdes , rclass;
version 9.2;
syntax namelist  [,  DGRA(int 0) SGRA(string) EGRA(string) *];

_get_gropts , graphopts(`options') ;
	local options `"`s(graphopts)'"';
preserve;
tokenize `namelist';
_nlargs `namelist';


forvalues t=1/$indica {;
local  nblock =  `.``t''.nblock' ;
local  str    =  `.``t''.str' ;
local  bcut    =  `.``t''.bcut' ;
local  sfee    =  `.``t''.sfee' ;
qui count;
if r(N)<`nblock' qui set obs `nblock';
tempvar Variable tarif  subside;
qui gen `Variable'="";
qui gen `tarif' = 0;
qui gen `subside' = 0;
local pos = 1;
local mxb0 = 0;
forvalues i=1/`nblock' {;
local j= `i'-1;
local mxb`i' = `.``t''.blk[`i'].max' ;
qui replace `Variable' = " `mxb`j'' - `mxb`i'' " in `pos';
if `i'==`nblock' qui replace `Variable' = " `mxb`j'' and more " in `pos';
qui replace `tarif'   = `.``t''.blk[`i'].price' in `pos'  ;
qui replace `subside' = `.``t''.blk[`i'].subside' in `pos'  ;
local pos = `pos'+ 1;
};
                local  struc = "Increasing block tariff."; 
if `str' == 2   local  struc = "Volume-differentiated tariff ."; 
if `str' == 3   local  struc = "Mixed structure: IBT until bolck `bcut' .";


	tempname table;
	if (`str' == 1 | `str' == 2 ) {;
	.`table'  = ._tab.new, col(4);
	.`table'.width |8| 30 | 20 | 20 |;
	.`table'.strcolor . . . .;
	.`table'.numcolor yellow yellow yellow  yellow  ;
	.`table'.numfmt   %8.0f %16.0g  %16.6f  %16.6f;
	 di _n as text "{col 4} Description of the price schedule:  ``t''";
	 di  as text "{col 4} Tariff structure:  `struc'";
	  di  as text "{col 4} Subscrition fees:  `sfee'";
    .`table'.sep, top;
    .`table'.titles "Number " "Block     " "Tariff      "  "Subsidy      "  ;
	.`table'.sep, mid;
	forvalues i=1/`nblock'{;
                                       .`table'.numcolor white  yellow yellow   yellow  ;
			                           .`table'.row `i' `Variable'[`i'] `tarif'[`i'] `subside'[`i']   ; 
			                          
				           };
    } ;
	
		if (`str' == 3 ) {;
	.`table'  = ._tab.new, col(5);
	.`table'.width |8| 30 | 20 | 20 | 10 |;
	.`table'.strcolor . . . . .;
	.`table'.numcolor yellow yellow yellow  yellow yellow ;
	.`table'.numfmt   %8.0f %16.0g  %16.6f  %16.6f %10.0g ;
	 di _n as text "{col 4} Description of the price schedule:  ``t''";
	 di  as text "{col 4} Tariff structure:  `struc'";
	 di  as text "{col 4} Subscrition fees:  `sfee'";
    .`table'.sep, top;
    .`table'.titles "Number " "Block                       " "Tariff      "  "Subsidy      "  "Structure" ;
	.`table'.sep, mid;
	forvalues i=1/`nblock'{;
	              local struc = "IBT";
	if `i'>`bcut' local struc = "VDT";
                                       .`table'.numcolor white  yellow yellow   yellow  yellow ;
			                           .`table'.row `i' `Variable'[`i'] `tarif'[`i'] `subside'[`i']  "`struc'" ; 
			                          
				           };
    } ;
	
	
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
local  nblock =  `.``t''.nblock' ;
local  str    =  `.``t''.str' ;
local  bcut    =  `.``t''.bcut' ;
local  sfee    =  `.``t''.sfee' ;
                local  sstruc = "IBT"; 
if `str' == 2   local  sstruc = "VDT"; 
if `str' == 3   local  sstruc = "Mixed(IBT/VDT)"; 
qui count;
if r(N)<`nblock' qui set obs `nblock';
tempvar Variable tarif maxbl ;
qui gen `Variable'="";
qui gen `tarif' = 0;
qui gen `maxbl' = 0;
local pos = 1;
local mxb0 = 0;
forvalues i=1/`nblock' {;
local j= `i'-1;
local mxb`i' = `.``t''.blk[`i'].max' ;
qui replace `Variable' = " `mxb`j'' - `mxb`i'' " in `pos';
if `i'==`nblock' qui replace `Variable' = " `mxb`j'' and more " in `pos';

qui replace `tarif' = `.``t''.blk[`i'].price' in `pos'  ;
qui replace `maxbl' = `.``t''.blk[`i'].max' in `pos'  ;
if `i'==`nblock' local tmp`t'  = (`.``t''.blk[`j'].max')*1.2 ;
if `i'==`nblock' local ttmp`t' = (`.``t''.blk[`i'].price') ;
if `i'==`nblock' qui replace `maxbl' = `tmp`t'' in `pos';
local pos = `pos'+ 1;

if `i'==`nblock' local tmp  = max(`tmp',`tmp`t'');
if `i'==`nblock' local ttmp = max(`ttmp',`ttmp`t'');
};

tempvar  x`t' y`t';
qui gen `x`t'' = .;
qui gen `y`t'' = .;

qui replace `y`t'' = `maxbl'[1] in 1;
local pos  = 1;
local pos2 = 2;
local minobs = 2*`nblock';
qui count; if `r(N)'<`minobs' qui set obs `minobs';


forvalues i=1/`nblock' {;
qui replace `y`t'' = `tarif'[`i'] in `pos';
qui replace `x`t'' = `maxbl'[`i'] in `pos2';

local pos = `pos'  + 1;
local pos2 = `pos2'+ 1;
qui replace `y`t'' = `tarif'[`i'] in `pos';
if `i'!=`nblock' qui replace `x`t'' = `maxbl'[`i'] in `pos2';
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

forvalues i=1/`nblock' {;
tempvar z1_`t'_`i' z2_`t'_`i';
qui gen      `z1_`t'_`i''= `tarif'[`i'] in 1;
qui replace  `z1_`t'_`i''= `tarif'[`i'] in 2;
qui sum `x`t'' if `y`t''==`tarif'[`i'] ;
local a = `r(min)';
qui gen `z2_`t'_`i''=  0        in 1;
qui replace `z2_`t'_`i''= `a'   in 2;
local   cmd `cmd'        (line `z1_`t'_`i'' `z2_`t'_`i''  in 1/2, lpattern(dash) lcolor(`mycol') )  ;
local pl=`pl'+1;
local    cmd `cmd'       (line `y`t'' `x`t'' if `y`t''==`tarif'[`i'], lpattern(solid) lcolor(`mycol') )  ;
local pl=`pl'+1;
};
};


/****/

if (`str'==3) {;
if `t'==1 local mycol  black;
if `t'==2 local mycol  blue;
if `t'==3 local mycol  red;
if `t'==4 local mycol  orange;
if `t'==5 local mycol  green;
local dbcut = 2*`bcut'+1;
local cmd `cmd' line `y`t'' `x`t'' in 1/`dbcut' ,  lcolor(`mycol')  || ;
local pl=`pl'+1;
};


if (`str'==3) {;
if `t'==1 local mycol  black;
if `t'==2 local mycol  blue;
if `t'==3 local mycol  red;
if `t'==4 local mycol  orange;
if `t'==5 local mycol  green;
local bcut1 = `bcut'+1;
forvalues i=`bcut1'/`nblock' {;
tempvar z1_`t'_`i' z2_`t'_`i';
qui gen      `z1_`t'_`i''= `tarif'[`i'] in 1;
qui replace  `z1_`t'_`i''= `tarif'[`i'] in 2;
qui sum `x`t'' if `y`t''==`tarif'[`i'] ;
local a = `r(min)';
qui gen `z2_`t'_`i''=  0        in 1;
qui replace `z2_`t'_`i''= `a'   in 2;
local   cmd `cmd'        (line `z1_`t'_`i'' `z2_`t'_`i''  in 1/2, lpattern(dash) lcolor(`mycol') )  ;
local pl=`pl'+1;
local    cmd `cmd'       (line `y`t'' `x`t'' if `y`t''==`tarif'[`i'], lpattern(solid) lcolor(`mycol') )  ;
local pl=`pl'+1;
};
};

/****/

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
title(Price schedules)
xtitle(Quantity)
ytitle(Tariff)
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


