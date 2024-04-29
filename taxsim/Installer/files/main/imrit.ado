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




#delimit ;
capture program drop imrit;
program define imrit, sortpreserve;
version 9.2;
syntax varlist(min=1 max=1)[ ,   ITSCH(string) FTSCH(string) HSIZE(varname) APPR(int 1) ELAS(varname) INF(real 0) ];

tokenize `varlist';


local n1    =  `.`itsch'.nrange'; 
local bun1  =  `.`itsch'.bun'; 
local str1  =  `.`itsch'.str'; 
local n2  =  `.`ftsch'.nrange'; 
local bun2  =  `.`ftsch'.bun'; 
local str2  =  `.`ftsch'.str'; 
local nn = `n1'+`n2';

if `n1' > 1 local lr1 = `.`itsch'.ran[`n1'-1].max'; 
if `n2' > 1 local lr2 = `.`ftsch'.ran[`n2'-1].max'; 

if `n1' == 1 local lr1 = `.`itsch'.ran[`n1'].max'; 
if `n2' == 1 local lr2 = `.`ftsch'.ran[`n2'].max'; 

local mr= max(`lr1',`lr2')*100;
qui count;
local nn1 = `nn'-1;
local nn2 = `nn'-2;
if r(N)<`nn' qui set obs `nn';
tempvar r t1 t2 s;
qui gen `r' = .;
qui gen `t1' = .;
qui gen `t2' = .;
qui gen `s' = .;

forvalues i = 1/`n1' {;
if `i'!=`n1' qui replace `r'  = `.`itsch'.ran[`i'].max'    in `i' ;
if `i'==`n1' qui replace `r'  = `mr'                   in `i' ;
             qui replace `t1' = `.`itsch'.ran[`i'].tax'  in `i' ;
             qui replace `s' = 1                       in `i' ;
};


forvalues i = 1/`n2' {;
local j=`i'+`n1';
if `i'!=`n2' qui replace `r'  = `.`ftsch'.ran[`i'].max'   in `j' ;
if `i'==`n2' qui replace `r'  = `mr'                  in `j' ;
             qui replace `t2' = `.`ftsch'.ran[`i'].tax' in `j';
             qui replace `s'  = 2                     in `j' ;
};




preserve;
tempvar tt1 tt2;
qui keep in 1/`nn';
qui {;
by `r', sort : egen  `tt1' = mean(`t1');
by `r', sort : egen  `tt2' = mean(`t2') ;
};

cap drop __r;
qui gen __r=`r';
collapse (mean) `tt1' `tt2', by(__r);

qui count;
local nn = `r(N)';

forvalues i=1/`nn' {;
local r`i' = __r[`i'];
local t1`i' = `tt1'[`i'];
local t2`i' = `tt2'[`i'];
};

restore; 

cap drop `r' `t1' `t2';
tempvar r t1 t2;
qui gen `r' = .;
qui gen `t1' = .;
qui gen `t2' = .;

forvalues i=1/`nn' {;

qui replace `r'  = `r`i''  in `i';
qui replace `t1' = `t1`i'' in `i';
qui replace `t2' = `t2`i'' in `i';
};




local nn1=`nn'-1;
local nn2=`nn'-2;

sort `r'  in 1/`nn';



*list `r' `t1' `t2' in 1/`nn' ;




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


forvalues i = 1/`nn' {;
if   (`t2'[`i']==. ) {;
local h2=`i';
while `t2'[`h2']==. & `h2' <=`nn' {;
local h2 =`h2'+1 ;
};
qui qui replace `t2'=`t2'[`h2'] in `i';
local h2=`h2'-1;
};
};


*list `r' `t1' `t2' in 1/`nn';


forvalues i = 1/`nn' {;
cap drop `t1_`i'' ;
cap drop `t2_`i'' ;
tempvar t1_`i'  t2_`i' ;
if `str1'==1 qui gen `t1_`i'' = `t1'  ;
if `str1'==2 qui gen `t1_`i'' = `t1'[`i'] ;

if `str2'==1 qui gen `t2_`i'' = `t2'  ;
if `str2'==2 qui gen `t2_`i'' = `t2'[`i'] ;

};




local dt1_1 = 0;

forvalues i = 1/`nn' {;
local se1_`i'=`r'[1];
local basev1_`i'=0;
local sr1_`i'=`r'[1];
local baser1_`i'=0;
};

if "`elas'"=="" {;
tempvar elas;
gen `elas'=0;
};

forvalues i = 2/`nn' {;
forvalues h = `i'/`nn' {;
local j  = `i'-1;
local j1 = `i'-2;
local se`i'_`h' = `se`j'_`h'' + (`r'[`i']-`r'[`i'-1]);
if `i'== 2 local base`i'_`h'=   (`r'[`j']  -       0)*(`t2_`h''[`j']-`t1_`h''[`j'])*(1-min(abs(`elas'*(`t2_`h''[`j']-`t1_`h''[`j'])), 1)) ;
if `i'!= 2 local base`i'_`h'=   (`r'[`j']-`r'[`j'-1])*(`t2_`h''[`j']-`t1_`h''[`j'])*(1-min(abs(`elas'*(`t2_`h''[`j']-`t1_`h''[`j'])), 1)) ;
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
if `nn1'>=1 qui replace `class' = `nn'                              if (`binc'>`se`nn1'_`nn1'')  ;



tempvar svar ;
qui gen `svar' = 0 ;


/* The formulat : dR = Inc*dt*(1-max(1, abs(elas*dt)) */
qui replace `svar' = `binc'*`dt1_1'                                                       if `class'==1; 
forvalues i = 2/`nn' {;
local k = `i'-1;
forvalues j = 1/`k' {;
 qui replace `svar' = `basev`i'_`i'' + (`binc' - `se`j'_`i'' )*(`t2_`i''[`i']-`t1_`i''[`i'])*(1-min(abs(`elas'*(`t2_`i''[`i']-`t1_`i''[`i'])) , 1 ) )       if (`class'==`i') ;
};
};
if `nn1'>=1  qui replace  `svar' = `basev`nn'_`nn'' + (`binc'-`se`nn1'_`nn'')*(`t2_`nn''[`nn']-`t1_`nn''[`nn'])*(1-min(abs(`elas'*(`t2_`nn''[`nn']-`t1_`nn''[`nn'])), 1))           if (`class' == `nn' )  ;

if `bun1'==2 qui replace `svar' = `svar'/ `hsize' ;


cap drop __imrit;
qui gen __imrit=`svar';
end;
