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
capture program drop imqsub;
program define imqsub, sortpreserve;
version 9.2;
syntax varlist(min=1 max=1)[ ,   IPSCH(string) FPSCH(string) HSIZE(varname) ELAS(real 0)];

tokenize `varlist';
/*
set trace on ;
set tracedepth 1;
*/


local n1     =  `.`ipsch'.nblock'; 
local bun1   =  `.`ipsch'.bun'; 
local str1   =  `.`ipsch'.str'; 
local bcut1  =  `.`ipsch'.bcut'; 
local sfee1  =  `.`ipsch'.sfee'; 

local n2     =  `.`fpsch'.nblock'; 
local bun2   =  `.`fpsch'.bun'; 
local str2   =  `.`fpsch'.str'; 
local bcut2  =  `.`fpsch'.bcut'; 
local sfee2  =  `.`fpsch'.sfee'; 

local nn = `n1'+`n2';

if `n1' > 1 local lq1 = `.`ipsch'.blk[`n1'-1].max'; 
if `n2' > 1 local lq2 = `.`fpsch'.blk[`n2'-1].max'; 

if `n1' == 1 local lq1 = `.`ipsch'.blk[`n1'].max'; 
if `n2' == 1 local lq2 = `.`fpsch'.blk[`n2'].max'; 

local mq = max(`lq1',`lq2')*100;
qui count;
local nn1 = `nn'-1;
local nn2 = `nn'-2;
if r(N)<`nn' qui set obs `nn';


tempvar q p1 p2 st1 st2 s;
qui gen `q' = .;
qui gen `p1' = .;
qui gen `p2' = .;
qui gen `st1' = .;
qui gen `st2' = .;
qui gen `s' = .;



forvalues i = 1/`n1' {;
if `i'!=`n1' qui replace `q'  = `.`ipsch'.blk[`i'].max'    in `i' ;
if `i'==`n1' qui replace `q'  = `mq'                   in `i' ;
             qui replace `p1' = `.`ipsch'.blk[`i'].price'  in `i' ;
             qui replace `s' = 1                       in `i' ;
			 
if `str1' == 1 qui replace `st1' = 1   in `i' ;	
if `str1' == 2 qui replace `st1' = 2   in `i' ;	
if `str1' == 3 {;
qui replace `st1' = 1   in `i' if `i' <= `bcut1';
qui replace `st1' = 2   in `i' if `i' >  `bcut1';		
}; 

};


forvalues i = 1/`n2' {;
local j=`i'+`n1';
if `i'!=`n2' qui replace `q'  = `.`fpsch'.blk[`i'].max'   in `j' ;
if `i'==`n2' qui replace `q'  = `mq'                  in `j' ;
             qui replace `p2' = `.`fpsch'.blk[`i'].price' in `j';
             qui replace `s'  = 2                     in `j' ;
			 
if `str2' == 1 qui replace `st2' = 1   in `j' ;	
if `str2' == 2 qui replace `st2' = 2   in `j' ;	
if `str2' == 3 {;
qui replace `st2' = 1   in `j' if `i' <= `bcut2';
qui replace `st2' = 2   in `j' if `i' >  `bcut2';		
}; 
			 
};



preserve;
tempvar pp1 pp2 sst1 sst2 vs;
qui keep in 1/`nn';
quietly {;
by `q', sort : egen  `pp1' = mean(`p1');
by `q', sort : egen  `pp2' = mean(`p2') ;
by `q', sort : egen  `sst1' = mean(`st1');
by `q', sort : egen  `sst2' = mean(`st2') ;
by `q', sort : egen  `vs'  = mean(`s') ;
};

cap drop __q;
qui gen __q=`q';
collapse (mean) `pp1'  `pp2' `sst1'  `sst2' `vs' , by(__q);

qui count;
local nn = `r(N)';

forvalues i=1/`nn' {;
local q`i' = __q[`i'];
local p1`i' = `pp1'[`i'];
local p2`i' = `pp2'[`i'];
local st1`i' = `sst1'[`i'];
local st2`i' = `sst2'[`i'];
local vs`i' = `vs'[`i'];
};

restore; 

cap drop `q' `p1'  `p2'   `st1'  `st2' `vs';
tempvar q p1 p2 st1 st2 vs;
qui gen `q' = .;
qui gen `p1' = .;
qui gen `p2' = .;
qui gen `st1' = .;
qui gen `st2' = .;
qui gen `vs' = .;

forvalues i=1/`nn' {;
qui replace `q'  = `q`i''  in `i';
qui replace `p1' = `p1`i'' in `i';
qui replace `p2' = `p2`i'' in `i';
qui replace `st1' = `st1`i'' in `i';
qui replace `st2' = `st2`i'' in `i';
qui replace `vs' = `vs`i'' in `i';
};




local nn1=`nn'-1;
local nn2=`nn'-2;

sort `q'  in 1/`nn';



*list `q' `p1' `p2' `st1' `st2' in 1/`nn' ;


forvalues i = 1/`nn' {;
local i1=`i'-1;
if   (`p1'[`i']==. ) {;
local h1=`i';
while `p1'[`h1']==. & `h1' <=`nn' {;
local h1 =`h1'+1 ;
};
qui replace `p1'=`p1'[`h1'] in `i';
qui replace `st1'=`st1'[`h1'] in `i';
qui replace `vs'=`vs'[`h1'] in `i';
local h1=`h1'-1;
};
};


forvalues i = 1/`nn' {;
if   (`p2'[`i']==. ) {;
local h2=`i';
while `p2'[`h2']==. & `h2' <=`nn' {;
local h2 =`h2'+1 ;
};
qui replace `p2'=`p2'[`h2'] in `i';
qui replace `st2'=`st2'[`h2'] in `i';
local h2=`h2'-1;
};
};


/* list `q' `p1' `p2' `st1' `st2' in 1/`nn' ; */


forvalues i = 1/`nn' {;
cap drop `p1_`i'' ;
cap drop `p2_`i'' ;
tempvar p1_`i'  p2_`i' ;
if `st1'[`i']==1 qui gen `p1_`i'' = `p1'  ;
if `st1'[`i']==2 qui gen `p1_`i'' = `p1'[`i'] ;

if `st2'[`i']==1 qui gen `p2_`i'' = `p2'  ;
if `st2'[`i']==2 qui gen `p2_`i'' = `p2'[`i'] ;

};




/* A corriger ici */



forvalues i = 1/`nn' {;
local se1_`i'=`q'[1]*`p1_`i''[1];
local basev1_`i'=0;
local sq1_`i'=`q'[1];
local baseq1_`i'=0;
};


forvalues i = 2/`nn' {;
forvalues h = `i'/`nn' {;
local j  = `i'-1;
local j1 = `i'-2;
local se`i'_`h' = `se`j'_`h'' + (`q'[`i']-`q'[`i'-1])*`p1_`h''[`i'];
if `i'== 2 local base`i'_`h'=  - (`q'[`j']  -       0)*(`p2_`h''[`j']-`p1_`h''[`j']);
if `i'!= 2 local base`i'_`h'=  - (`q'[`j']-`q'[`j'-1])*(`p2_`h''[`j']-`p1_`h''[`j']);
local basev`i'_`h'=`basev`j'_`h''+`base`i'_`h'';
};
};

forvalues i = 2/`nn' {;
forvalues h = `i'/`nn' {;
local j  = `i'-1;
local sq`i'_`h' = `sq`j'_`h'' + (`q'[`i']-`q'[`i'-1]);
if `i'== 2 local base`i'_`h' =   (`q'[`j']  -       0)*(`elas'*(`p2_`h''[`j']/`p1_`h''[`j']-1));
if `i'!= 2 local base`i'_`h' =   (`q'[`j']-`q'[`j'-1])*(`elas'*(`p2_`h''[`j']/`p1_`h''[`j']-1));
local baseq`i'_`h'=`baseq`j'_`h''+`base`i'_`h'';
/* if `i' == `h' dis "***: `baseq`i'_`h''"; */
};
};


cap drop `bexp';
tempvar bexp;
if `bun1'==1 qui gen `bexp' = `1'*`hsize';
if `bun1'==2 qui gen `bexp' = `1';

qui replace `bexp' = max(0,`bexp'-`sfee2'+`sfee1') ;

local se0=0;
local se1=`q'[1]*`p1'[1];
local basev1=0;
forvalues i = 2/`nn' {;
local j  = `i'-1;
local se`i' = `se`j'' + (`q'[`i']-`q'[`i'-1])*`p1'[`i'];
};
local ex1= `q'[1]*`p1'[1];
local ex0= 0;
forvalues i = 2/`nn' {;
local ex`i'= (`q'[`i']-`q'[`i'-1])*`p1'[`i'];
};


tempvar class ;
qui gen `class' = 1;


if `str1'==1      {;
if `nn1' > 1 {;
forvalues i = 2/`nn1' {;
local j=`i'-1;
 qui replace `class' = `i'  if (`bexp'>`se`j'' & `bexp'<=`se`i'') ;
};
};
if `nn' >= 2 qui replace `class' = `nn'         if (`bexp'>`se`nn1'')  ;
};



if `str1'==2      {;
if `nn1' > 1 {;
forvalues i = 2/`nn1' {;
local j=`i'-1;
 qui replace `class' = `i'  if `bexp'>(`q'[`j']*`p1'[`i'])   ; 
};
};
if `nn' >= 2 qui replace `class' = `nn'         if (`bexp'>`q'[`nn'-1]*`p1'[`nn'])  ;
};



if `str1'==3      {;
if `nn1' > 1 {;
forvalues i = 2/`bcut1' {;
local j=`i'-1;
 qui replace `class' = `i'  if (`bexp'>`se`j'') ;
};
};
local bc11 = `bcut1'-1;
qui replace `class' = `bcut1'         if (`bexp'>`se`bc11'')  ;

local bcut11= `bcut1'+1;
if `nn1' > 1 {;
forvalues i = `bcut11'/`nn1' {;
local j=`i'-1;
 qui replace `class' = `i'  if `bexp'>(`q'[`j']*`p1'[`i'])  ; 
};
};
if `nn' >= 2 qui replace `class' = `nn'         if (`bexp'>`q'[`nn'-1]*`p1'[`nn'])  ;
};





tempvar hhq ;
qui gen `hhq' = 0 ;
qui replace `hhq' = `bexp'/`p1_1'[1]                                  if `class'==1; 
if `nn1' > 1 {;
forvalues i = 2/`nn1' {;
local j=`i'-1;
 qui replace `hhq' = `sq`j'_`i'' +   (`bexp'-`se`j'_`i'')/`p1_`i''[`i']         if (`class'==`i') ;
};
};
if `nn1'>=1 qui replace  `hhq' = `sq`nn1'_`nn'' + (`bexp'-`se`nn1'_`nn'')/`p1_`nn''[`nn']                   if (`class' == `nn')  ;


tempvar qvar ;
qui gen `qvar' = 0 ;
qui replace `qvar' = (`hhq')*(`elas'*(`p2_1'[1]/`p1_1'[1]-1))                                                 if `class'==1; 
if `nn1' > 1 {;
forvalues i = 2/`nn1' {;
local j=`i'-1;
 qui replace `qvar' = `baseq`i'_`i'' + (`hhq'-`sq`j'_`i'')*(`elas'*(`p2_`i''[`i']/`p1_`i''[`i']-1))           if (`class'==`i') ;
 };
};
if `nn1'>=1 qui replace  `qvar' = `baseq`nn'_`nn'' + (`hhq'-`sq`nn1'_`nn'')*(`elas'*(`p2_`nn''[`nn']/`p1_`nn''[`nn']-1))         if (`class' == `nn' )  ;

qui replace `qvar' = max(-`hhq', `qvar') ;

if `bun1'==1 qui replace `qvar' = `qvar'/ `hsize' ;


cap drop __imqsub;
qui gen  __imqsub=`qvar';
end;
