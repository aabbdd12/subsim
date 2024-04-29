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
capture program drop subjobgr5;
program define subjobgr5, rclass ;
version 9.2;
syntax varlist(min=1)[ ,  HSize(varname) PCEXP(varname) VIPSCH(varname)  IELAS(varname) INF(real 0) APPR(int 1) MIN(real 0) MAX(real 100) AGGRegate(string) XRNAMES(string) LAN(string) SCEN(string) NSCEN(int 1) OGR(string) ];

preserve;

local vlist;
local slist;
tokenize `varlist' ;
qui drop if `1'=="";
//sort `1';
qui count;
local nit=`r(N)';
forvalues i=1/`r(N)' {;
local tmp = ""+`1'[`i'];
if ("`1'"~="") {;
local vlist `vlist' `tmp';
};
};



qui aggrvar `vlist' , xrnames(`xrnames') aggregate(`aggregate');
local  slist = r(slist);
local nl = `r(nl)'; 


local glegend legend(order( ;
if ("`slist'"~="") {;
local xrna  "`slist'";
local xrna : subinstr local xrna " " ",", all ;
local xrna : subinstr local xrna "|" " ", all ;
local count : word count `xrna';
tokenize "`xrna'";
forvalues a = 1/`count' {;
	local `a': subinstr local `a' "," " ", all ;
	local glegend `"`glegend' `a' "``a''""';
	
};

};
local glegend `"`glegend' ))"';

restore;

preserve;
tokenize `varlist' ;
qui svyset ;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized); 
local hweight=""; 
cap qui svy: total `pcexp'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear;
tempvar fw;
qui gen `fw'=1;
if ("`hsize'"~="" )         qui replace `fw' = `hsize';
if ("`hweight'"~="")                           qui replace `fw'=`fw'*`hweight';



local step=(`max'-`min')/100;


tempvar perc;
qui gen `perc'=. ;
tempvar q p1 p2 sub1 sub2 s rev ran;

forvalues z=1/`nit' {;

tempvar est_`z';
qui gen `est_`z'' = .;
local ylist `ylist' `est_`z'';



local ipsch  =  ""+`vipsch'[`z'];
local elas   =  `ielas'[`z']; 
if "`elas'"=="" local elas=0;
local nva   =  ""+`1'[`z'];
local issub = `.`ipsch'.issub'; 
local n     =  `.`ipsch'.nblock'; 
local bun     =  `.`ipsch'.bun'; 
local str     =  `.`ipsch'.str';
local bcut  =  `.`ipsch'.bcut'; 
local sfee  =  `.`ipsch'.sfee'; 
local n1    = `n' - 1;

cap drop `q' ; qui gen `q' = .;

forvalues h = 1/`n' {;
qui replace `q'    = `.`ipsch'.blk[`h'].max'     in `h' ;
cap drop `p1_`h'' ;
cap drop `sub1_`h'' ; 
tempvar p1_`h' sub1_`h' p1;
qui gen  `p1_`h'' =.;
qui gen  `p1' = .;
qui gen  `sub1_`h'' =.;
forvalues i = 1/`n' {;
            qui replace `p1'       = `.`ipsch'.blk[`i'].price'     in `i' ;
if `str'==1 qui replace `p1_`h''   = `.`ipsch'.blk[`i'].price'     in `i' ;
if `str'==1 qui replace `sub1_`h'' = `.`ipsch'.blk[`i'].subside'   in `i' ;
if `str'==2 qui replace `p1_`h''   = `.`ipsch'.blk[`h'].price'     in `i' ;
if `str'==2 qui replace `sub1_`h'' = `.`ipsch'.blk[`h'].subside'   in `i' ;

if `str'==3 &  `h'<=`bcut' {;
qui replace `p1_`h''   = `.`ipsch'.blk[`h'].price'     in `i' ;
qui replace `sub1_`h'' = `.`ipsch'.blk[`h'].subside'   in `i' ;
};

if `str'==3 &  `h'>`bcut' {;
qui replace `p1_`h''   = `.`ipsch'.blk[`h'].price'     in `i' ;
qui replace `sub1_`h'' = `.`ipsch'.blk[`h'].subside'   in `i' ;
};

};
};







forvalues i = 1/`n' {;
local se1_`i'=`q'[1]*`p1_`i''[1];
local ex1_`i'= `q'[1]*`p1_`i''[1];
};


forvalues i = 2/`n' {;
forvalues h = `i'/`n' {;
local j  = `i'-1;
local se`i'_`h' = `se`j'_`h'' + (`q'[`i']-`q'[`i'-1])*`p1_`h''[`i'];
local ex`i'_`h'= (`q'[`i']-`q'[`i'-1])*`p1_`h''[`i'];

};
};



tempvar svar ;
qui gen `svar' = 0 ;



cap drop `class';
cap drop `bexp_`z'';
tempvar bexp_`z';
if `bun'==1  qui gen `bexp_`z'' = `nva'*`hsize';
if `bun'==2  qui gen `bexp_`z'' = `nva';
qui replace `bexp_`z'' = max(0,`bexp_`z''-`sfee') ;



tempvar class ;
qui gen `class' = 1;


if `str'==1      {;
if `n1' > 1 {;
forvalues i = 2/`n1' {;
local j=`i'-1;
 qui replace `class' = `i'  if (`bexp_`z''>`se`j'_`j'') ;

};
};
if `n' >= 2 qui replace `class' = `n'         if (`bexp_`z''>`se`n1'_`n1'')  ;
};



if  `str'==2      {;
if `n1' > 1 {;
forvalues i = 2/`n1' {;
local j=`i'-1;
 qui replace `class' = `i'  if `bexp_`z''>(`q'[`j']*`p1'[`i'])  ; 
};
};
if `n' >= 2 qui replace `class' = `n'         if (`bexp_`z''>`q'[`n'-1]*`p1'[`n'])  ;
};



if  `str'==3      {;
if `n1' > 1 {;
forvalues i = 2/`bcut' {;
local j=`i'-1;
 qui replace `class' = `i'  if (`bexp_`z''>`se`j'_`z'') ;
};
};
local bc11 = `bcut'-1;
qui replace `class' = `bcut'         if (`bexp_`z''>`se`bc11'_`z'')  ;

local bcut11= `bcut'+1;
if `n1' > 1 {;
forvalues i = `bcut11'/`n1' {;
local j=`i'-1;
 qui replace `class' = `i'  if `bexp_`z''>(`q'[`j']*`p1'[`i'])  ; 
};
};
if `n' >= 2 qui replace `class' = `n'         if (`bexp_`z''>`q'[`n'-1]*`p1'[`n'])  ;
};





forvalues v=1/101 {;



local pos = (`v'-1)*`step';
qui replace `perc' = `min'+`pos' in `v';


forvalues i = 1/`n' {;
forvalues h = 1/`n' {;
cap drop `p2_`h'' ;
tempvar p2_`h' ; 
qui gen `p2_`h''   = `p1_`h''*(1+`pos'/100);
};
};





forvalues i = 1/`n' {;
forvalues h = 1/`n' {;
local dp`i'_`h' = (`p2_`h''[`i']/`p1_`h''[`i']-1) ;
local sb`i'_`h' = `sub1_`h''[`i']/`p1_`h''[`i']; // add valorem subsidy
};
};


cap drop _svar_`nva';
qui gen _svar_`nva' = 0 ;
cap drop _sub_`nva';
qui gen _sub_`nva' = 0 ;


qui replace _sub_`nva'  = `bexp_`z''*`sb1_1'                                      if `class'==1; 

forvalues i = 2/`n' {;
local k = `i'-1;
forvalues j = 1/`k' {;
qui replace _sub_`nva'  = _sub_`nva'  + `ex`j'_`i''*`sb`j'_`i''                         if `class'==`i'; 
};
qui replace _sub_`nva'  = _sub_`nva'  + (`bexp_`z''-`se`k'_`i'')*`sb`i'_`i''            if `class'==`i'; 
};

qui replace _sub_`nva'  = - _sub_`nva' ;

if (`issub'==0) {;


qui replace _svar_`nva'  = `bexp_`z''*`dp1_1'*(1+`elas')                                                  if `class'==1; 
forvalues i = 2/`n' {;
local k = `i'-1;
forvalues j = 1/`k' {;
qui replace _svar_`nva'  = _svar_`nva'  + `ex`j'_`i''*`dp`j'_`i''*(1+`elas')                                      if `class'==`i'; 
};
local k = `i'-1;
qui replace _svar_`nva'  = _svar_`nva'  + (`bexp_`z''-`se`k'_`i'')*`dp`i'_`i''*(1+`elas')                             if `class'==`i'; 
};


qui replace _svar_`nva'  = - _svar_`nva' ;
};



if (`issub'==1) {;

qui replace _svar_`nva'  = `bexp_`z''*`dp1_1'*(`elas'*(`sb1_1'-`dp1_1')-1)                                                       if `class'==1; 
forvalues i = 2/`n' {;
local k = `i'-1;
forvalues j = 1/`k' {;
qui replace _svar_`nva'  = _svar_`nva'  + `ex`j'_`i''*`dp`j'_`i''*(`elas'*(`sb`j'_`i''-`dp`j'_`i'')-1)                                    if `class'==`i'; 
};
local k = `i'-1;
qui replace _svar_`nva'  = _svar_`nva'  + (`bexp_`z''-`se`k'_`i'')*`dp`i'_`i''*(`elas'*(`sb`i'_`i''-`dp`i'_`i'')-1)                              if `class'==`i'; 
};

};

if (`issub'==1) qui replace _svar_`nva' = max(_svar_`nva', _sub_`nva');

if `bun'==1    qui replace  _svar_`nva'= _svar_`nva'/`hsize';


qui sum  _svar_`nva' [aw=`fw'];


qui replace `est_`z'' = -`r(sum)'/(1+`inf'/100) in `v';
cap drop _svar_`nva';
}; 


 
};

aggrvar `ylist' , xrnames(`xrnames') aggregate(`aggregate');
local slist = r(slist);
local flist = r(flist);
local nl = `r(nl)'; 

gropt 5 `lan' ;
local mtitle `r(gtitle)';
if (`nscen'>1) local mtitle `mtitle' : Scenario `scen';
line `flist' `perc' in 1/101 ,
`glegend'
title(`mtitle')  
xtitle(`r(gxtitle)')
ytitle(`r(gytitle)') 
`glegend'
`r(gstyle)' 
`ogr'
;
end;








