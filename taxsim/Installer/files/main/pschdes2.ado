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






#delimit ;
capture program drop itschdes2 ;
program define itschdes2 , eclass;
version 9.2;
syntax namelist  [,  ITEM(string) DGRA(int 0) SGRA(string) EGRA(string) *];



_get_gropts , graphopts(`options') ;
	local options `"`s(graphopts)'"';

tokenize `namelist';
_nlargs `namelist';

local iitsch = "`1'";
local fitsch = "`2'";

tempvar Variable;
qui gen `Variable'="";

local n1  =  `.`iitsch'.nrange'; 
local bun1  =  `.`iitsch'.bun'; 
local str1  =  `.`iitsch'.str'; 
local n2  =  `.`fitsch'.nrange'; 
local bun2  =  `.`fitsch'.bun'; 
local str2  =  `.`fitsch'.str'; 
local nn = `n1'+`n2';

if `n1' > 1 local lq1 = `.`iitsch'.ran[`n1'-1].max'; 
if `n2' > 1 local lq2 = `.`fitsch'.ran[`n2'-1].max'; 

if `n1' == 1 local lq1 = `.`iitsch'.ran[`n1'].max'; 
if `n2' == 1 local lq2 = `.`fitsch'.ran[`n2'].max'; 

local mq = max(`lq1',`lq2')*100;
qui count;
local nn1 = `nn'-1;
local nn2 = `nn'-2;
if r(N)<`nn' qui set obs `nn';
tempvar q t1 t2 s;
qui gen `q' = .;
qui gen `t1' = .;
qui gen `t2' = .;
qui gen `s' = .;

forvalues i = 1/`n1' {;
if `i'!=`n1' qui replace `q'  = `.`iitsch'.ran[`i'].max'    in `i' ;
if `i'==`n1' qui replace `q'  = `mq'                   in `i' ;
             qui replace `t1' = `.`iitsch'.ran[`i'].tax'  in `i' ;
             qui replace `s' =  `.`iitsch'.ran[`i'].subside'  in `i' ;
};


forvalues i = 1/`n2' {;
local j=`i'+`n1';
if `i'!=`n2' qui replace `q'  = `.`fitsch'.ran[`i'].max'   in `j' ;
if `i'==`n2' qui replace `q'  = `mq'                  in `j' ;
             qui replace `t2' = `.`fitsch'.ran[`i'].tax' in `j';
};




preserve;
tempvar pt1 pt2 vs;
qui keep in 1/`nn';
quietly {;
by `q', sort : egen  `pt1' = mean(`t1');
by `q', sort : egen  `vs' = mean(`s') ;
by `q', sort : egen  `pt2' = mean(`t2') ;
};

cap drop __q;
qui gen __q=`q';
collapse (mean) `pt1' `vs' `pt2', by(__q);

qui count;
local nn = `r(N)';

forvalues i=1/`nn' {;
local q`i' = __q[`i'];
local t1`i' = `pt1'[`i'];
local vs`i' = `vs'[`i'];
local t2`i' = `pt2'[`i'];
};

restore; 

cap drop `q' `t1' `vs' `t2';
tempvar q t1 vs t2;
qui gen `q' = .;
qui gen `t1' = .;
qui gen `vs' = .;
qui gen `t2' = .;

forvalues i=1/`nn' {;
qui replace `q'  = `q`i''  in `i';
qui replace `t1' = `t1`i'' in `i';
qui replace `vs' = `vs`i'' in `i';
qui replace `t2' = `t2`i'' in `i';
};




local nn1=`nn'-1;
local nn2=`nn'-2;

sort `q'  in 1/`nn';



*list `q' `t1' `t2' in 1/`nn' ;


forvalues i = 1/`nn' {;
local i1=`i'-1;
if   (`t1'[`i']==. ) {;
local h1=`i';
while `t1'[`h1']==. & `h1' <=`nn' {;
local h1 =`h1'+1 ;
};
qui replace `t1'=`t1'[`h1'] in `i';
qui replace `vs'=`vs'[`h1'] in `i';
local h1=`h1'-1;
};
};


forvalues i = 1/`nn' {;
if   (`t2'[`i']==. ) {;
local h2=`i';
while `t2'[`h2']==. & `h2' <=`nn' {;
local h2 =`h2'+1 ;
};
qui replace `t2'=`t2'[`h2'] in `i';
local h2=`h2'-1;
};
};


*list `q' `t1' `t2' in 1/`nn';

local mxb0 = 0;
forvalues i=1/`nn' {;
local j= `i'-1;
local mxb`i' = round(`q'[`i'], 4.0) ;
qui replace `Variable' = " `mxb`j'' - `mxb`i'' " in `i';
if `i'==`nn' qui replace `Variable' = " `mxb`j'' and more " in `i';
};
                 local rstr1="IBT";
if `str1' == 2   local rstr1="VDT";
                 local rstr2="IBT";
if `str2' == 2   local rstr2="VDT";
	tempname table;
	.`table'  = ._tab.new, col(3);
	.`table'.width |30|20 20|;
	.`table'.strcolor . .  . ;
	.`table'.numcolor yellow yellow  yellow ;
	di _n as text "{col 4} Description of the tax schedule:  `item'";
	.`table'.numfmt %16.0g  %16.6f  %16.6f ;
    .`table'.sep, top;
    .`table'.titles "Block     " "Initial tax (`rstr1')"      "Final tax (`rstr2')" ;
	.`table'.sep, mid;
	forvalues i=1/`nn'{;
                                       .`table'.numcolor white yellow   yellow  ;
			                           .`table'.row `Variable'[`i'] `t1'[`i']  `t2'[`i']   ; 
									   	   local temn= `Variable'[`i'];
											local  rnama `"`rnama' "`temn'""';
			                          
				           };
.`table'.sep,bot;
tempname ma;
 mkmat `t1' `t2' in 1/`nn' , matrix(`ma') ;
	  
  matrix colnames `ma' = "Initial tax (`rstr1')"  "Final tax (`rstr2')"  ;
  matrix rownames `ma' = `rnama' ;
  ereturn matrix maps = `ma' ;

  end;
/*
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
local  nrange =  `.``t''.nrange' ;
local  str    =  `.``t''.str' ;
qui count;
if r(N)<`nrange' qui set obs `nrange';
tempvar Variable tarif maxbl ;
qui gen `Variable'="";
qui gen `tarif' = 0;
qui gen `maxbl' = 0;
local pos = 1;
local mxb0 = 0;
forvalues i=1/`nrange' {;
local j= `i'-1;
local mxb`i' = `.``t''.ran[`i'].max' ;
qui replace `Variable' = " `mxb`j'' - `mxb`i'' " in `pos';
if `i'==`nrange' qui replace `Variable' = " `mxb`j'' and more " in `pos';

qui replace `tarif' = `.``t''.ran[`i'].tax' in `pos'  ;
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
qui replace `y`t'' = `tarif'[`i'] in `pos';
qui replace `x`t'' = `maxbl'[`i'] in `pos2';

local pos = `pos'  + 1;
local pos2 = `pos2'+ 1;
qui replace `y`t'' = `tarif'[`i'] in `pos';
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
qui gen      `z1_`t'_`i''= `tarif'[`i'] in 1;
qui replace  `z1_`t'_`i''= `tarif'[`i'] in 2;
qui sum `x`t'' if `y`t''==`tarif'[`i'] ;
local a = `r(min)';
qui gen `z2_`t'_`i''=  0        in 1;
qui replace `z2_`t'_`i''= `a'   in 2;
local   cmd `cmd'       (line `z1_`t'_`i'' `z2_`t'_`i''  in 1/2, lpattern(dash) lcolor(`mycol') )  ;
local pl=`pl'+1;
local    cmd `cmd'       (line `y`t'' `x`t'' if `y`t''==`tarif'[`i'], lpattern(solid) lcolor(`mycol') )  ;
local pl=`pl'+1;
};
};

qui replace `x`t'' = `tmp' in `ps`t'';

if (`str1'==1) local sstr = " (IBT)"; 
if (`str2'==2) local sstr = " (VDT)"; 
local aa `"`pl' "``t'' `sstr'" "';
local lgd `lgd' `aa' ;
};

local ttmp = round(`ttmp'*1.2,0.01);
local tpas= `ttmp'/5;
local lgd `lgd' )) ;



twoway  `cmd' , `lgd' 
plotregion(margin(zero))
graphregion(margin(medlarge))
title(tax schedules)
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

*/



