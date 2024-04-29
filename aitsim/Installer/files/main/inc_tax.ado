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
capture program drop inc_tax;
program define inc_tax, sortpreserve;
version 9.2;
syntax varlist(min=1 max=1)[ ,   ITSCH(string)  HSIZE(varname)];

tokenize `varlist';


local n1    =  `.`itsch'.nrange'; 
local bun1  =  `.`itsch'.bun'; 
local str1  =  `.`itsch'.str'; 
local nn = `n1';

if `n1' > 1 local lr1 = `.`itsch'.ran[`n1'-1].max'; 
 

if `n1' == 1 local lr1 = `.`itsch'.ran[`n1'].max'; 


local mr= (`lr1')*100;
qui count;
local nn1 = `nn'-1;
local nn2 = `nn'-2;
if r(N)<`nn' qui set obs `nn';
tempvar r t1 s;
qui gen `r' = .;
qui gen `t1' = .;
qui gen `s' = .;

forvalues i = 1/`n1' {;
if `i'!=`n1' qui replace `r'  = `.`itsch'.ran[`i'].max'    in `i' ;
if `i'==`n1' qui replace `r'  = `mr'                   in `i' ;
             qui replace `t1' = `.`itsch'.ran[`i'].tax'  in `i' ;
             qui replace `s' = 1                       in `i' ;
};



preserve;
tempvar tt1;
qui keep in 1/`nn';
qui {;
by `r', sort : egen  `tt1' = mean(`t1');
};

cap drop __r;
qui gen __r=`r';
collapse (mean) `tt1' , by(__r);

qui count;
local nn = `r(N)';

forvalues i=1/`nn' {;
local r`i' = __r[`i'];
local t1`i' = `tt1'[`i'];
};

restore; 

cap drop `r' `t1' ;
tempvar r t1;
qui gen `r' = .;
qui gen `t1' = .;

forvalues i=1/`nn' {;
qui replace `r'  = `r`i''  in `i';
qui replace `t1' = `t1`i'' in `i';
};

local nn1=`nn'-1;
sort `r'  in 1/`nn';



*list `r' `t1'  in 1/`nn' ;



forvalues i = 1/`nn' {;
local i1=`i'-1;
if   (`t1'[`i']==. ) {;
local h1=`i';
while `t1'[`h1']==. & `h1' <=`nn' {;
local h1 =`h1'+1 ;
};
qui replace `t1'=`t1'[`h1'] in `i';
local h1=`h1'-1;
};
};

*list `r' `t1'  in 1/`nn';

forvalues i = 1/`nn' {;
cap drop `t1_`i'' ;
tempvar t1_`i' ;
if `str1'==1 qui gen `t1_`i'' = `t1'  ;
if `str1'==2 qui gen `t1_`i'' = `t1'[`i'] ;
};

forvalues i = 1/`nn' {;
local se1_`i'=`r'[1];
local basev1_`i'=0;
local sr1_`i'=`r'[1];
local baser1_`i'=0;
};

forvalues i = 2/`nn' {;
forvalues h = `i'/`nn' {;
local j  = `i'-1;
local j1 = `i'-2;
local se`i'_`h' = `se`j'_`h'' + (`r'[`i']-`r'[`i'-1]);
if `i'== 2 local base`i'_`h'=  (`r'[`j']  -       0)*(`t1_`h''[`j']);
if `i'!= 2 local base`i'_`h'=  (`r'[`j']-`r'[`j'-1])*(`t1_`h''[`j']);
local basev`i'_`h'=`basev`j'_`h''+`base`i'_`h'';
};
};


cap drop `binc';
tempvar binc;
if `bun1'==1 qui gen `binc' = `1';
/*
to be treated latter (sum incomes with hhid) 
if `bun1'==2 qui gen `binc' = `1';
*/

tempvar class ;
qui gen `class' = 1;
if `nn1' > 1 {;
forvalues i = 2/`nn1' {;
local j=`i'-1;
 qui replace `class' = `i'  if (`binc'>`se`j'_`j'' & `binc'<=`se`i'_`i'') ;
};
};
if `nn1'>=1 qui replace `class' = `nn'                                                                                      if (`binc'>`se`nn1'_`nn1'')  ;


tempvar inct ;
qui gen `inct' = 0 ;
qui replace `inct' = `binc'*(`t1_1'[1])                                                                        if `class'==1; 
if `nn1' > 1 {;
forvalues i = 2/`nn1' {;
local j=`i'-1;
 qui replace `inct' = `basev`i'_`i'' + (`binc'-`se`j'_`i'')*(`t1_`i''[`i'])                                 if (`class'==`i') ;
};
};
if `nn1'>=1  qui replace  `inct' = `basev`nn'_`nn'' + (`binc'-`se`nn1'_`nn'')*(`t1_`nn''[`nn'])           if (`class' == `nn' )  ;

if `bun1'==2 qui replace `inct' = `inct'/ `hsize' ;



cap drop __inc_tax;
qui gen  __inc_tax=`inct';
end;
