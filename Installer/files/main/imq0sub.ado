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




#delimit ;
capture program drop imq0sub;
program define imq0sub, sortpreserve;
version 9.2;
syntax varlist(min=1 max=1)[ ,   IPSCH(string) HSIZE(varname) ];

tokenize `varlist';






/*************************/

cap drop `qvar' ;
tempname qvar;
qui gen `qvar' =0;

local nblock  =  `.`ipsch'.nblock'; 
local bun     =  `.`ipsch'.bun'; 
local str     =  `.`ipsch'.str'; 
local bcut     =  `.`ipsch'.bcut'; 
local sfee     =  `.`ipsch'.sfee'; 

cap drop `bexp';
tempvar bexp;
if `bun'==1 qui gen `bexp' = `1'*`hsize';
if `bun'==2 qui gen `bexp' = `1';

qui replace `bexp' = max(0,`bexp'-`sfee') ;

local n1= `nblock' - 1; 
forvalues i = 1/`n1' {;
local mxb`i'   = `.`ipsch'.blk[`i'].max';
local tr`i'    = `.`ipsch'.blk[`i'].price';
};
local tr`nblock'   =  `.`ipsch'.blk[`nblock'].price';


local ex0=0;
local mxb0=0;



if (`str' == 1) {;

forvalues i=1/`nblock' {;
local j = `i' - 1;
local ex`i' = `ex`j''+ ( `mxb`i'' - `mxb`j'' ) *`tr`i'' ;
};

forvalues i=1/`nblock' {;
local j = `i' - 1;
qui replace `qvar' = (((`bexp'-`ex`j'')/`tr`i'')+(`mxb`j''))*(`bexp'<=`ex`i'')*(`bexp'>`ex`j'') if (`bexp'<=`ex`i'') & (`bexp'>`ex`j'') & `bexp'!=.  ;
if `i' == `nblock'  {;
qui replace `qvar' = (((`bexp'-`ex`j'')/`tr`i'')+(`mxb`j''))*(`bexp'>`ex`j'') if (`bexp'>`ex`j'') & `bexp'!=.  ;
};
};
};

if (`str' == 2) {;
forvalues i=1/`nblock' {;
local j=`i'-1;
local ex0=0 ;
if `j' != 0        local ex`j' = `mxb`j''*`tr`j'';
if `i' != `nblock' local ex`i' = `mxb`i''*`tr`i'';		
if `i' != `nblock' qui replace `qvar' = ((`bexp')/`tr`i'')       if (`bexp'>=`ex`j'') & (`bexp'<=`ex`i'') ;
if `i' == `nblock' qui replace `qvar' = ((`bexp')/`tr`nblock'')  if (`bexp'>=`ex`j'') ;
};
};


if (`str' == 3) {;

forvalues i=1/`bcut' {;
local j = `i' - 1;
local l = `i' + 1;
local ex`i' = `ex`j''+ ( `mxb`i'' - `mxb`j'' ) *`tr`i'' ;
};
forvalues i=1/`bcut' {;
local j = `i' - 1;
/* dis `i' "=== " `ex`j'' " --IBT - " `ex`i'' " :::" `tr`i'' ;	*/	
qui replace `qvar' = (((`bexp'-`ex`j'')/`tr`i'')+(`mxb`j''))*(`bexp'<=`ex`i'')*(`bexp'>`ex`j'') if (`bexp'<=`ex`i'') & (`bexp'>`ex`j'') & `bexp'!=.  ;
if `i' == `bcut'  {;
qui replace `qvar' = (((`bexp'-`ex`j'')/`tr`i'')+(`mxb`j''))*(`bexp'>`ex`j'') if (`bexp'>`ex`j'') & `bexp'!=.  ;
};
};


local bcut1=`bcut'+1 ;
forvalues i=`bcut1'/`nblock' {;
local j=`i'-1;
local l = `i' + 1;
local ex0=0 ;
if `i' != `nblock'        local ex`i' = `mxb`i''*`tr`i'';
if `i' != `nblock'        local ex`l' = `mxb`i''*`tr`l'';
if `i' == `nblock'        local ex`i' = `mxb`j''*`tr`i'';		
if `i' != `nblock' qui replace `qvar' = ((`bexp')/`tr`i'')       if (`bexp'>=`ex`i'') & (`bexp'<=`ex`l'') & `bexp'!=. ;
if `i' == `nblock' qui replace `qvar' = ((`bexp')/`tr`nblock'')  if (`bexp'>=`ex`i'') & `bexp'!=. ;
};

};


if `bun'==1  qui replace `qvar' = `qvar'/ `hsize' ;


cap drop __imq0sub;
qui gen  __imq0sub=`qvar';
end;
