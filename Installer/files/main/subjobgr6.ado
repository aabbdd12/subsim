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
capture program drop subjobgr6;
program define subjobgr6, rclass ;
version 9.2;
syntax varlist(min=1)[ ,  HSize(varname) PCEXP(varname) VIPSCH(varname)  VFPSCH(varname)  INF(real 0) APPR(int 1) MIN(real -1) MAX(real 0) AGGRegate(string) XRNAMES(string) LAN(string) SCEN(string) NSCEN(int 1) OGR(string) ];

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
local fpsch  =  ""+`vfpsch'[`z'];
local nva   =  ""+`1'[`z'];

local issub = `.`ipsch'.issub'; 


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


tempvar q p1 p2 st1 st2 s  sub1 sub2;;
qui gen `q' = .;
qui gen `p1' = .;
qui gen `p2' = .;
qui gen `st1' = .;
qui gen `st2' = .;
qui gen `s' = .;
qui gen `sub1' = .;
qui gen `sub2' = .;



forvalues i = 1/`n1' {;
if `i'!=`n1' qui replace `q'  = `.`ipsch'.blk[`i'].max'    in `i' ;
if `i'==`n1' qui replace `q'  = `mq'                   in `i' ;
             qui replace `p1' = `.`ipsch'.blk[`i'].price'  in `i' ;
			 qui replace `sub1' = `.`ipsch'.blk[`i'].price'  in `i' ;
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
			 qui replace `sub2' = `.`fpsch'.blk[`i'].price'  in `j' ;
             qui replace `s'  = 2                     in `j' ;
			 
if `str2' == 1 qui replace `st2' = 1   in `j' ;	
if `str2' == 2 qui replace `st2' = 2   in `j' ;	
if `str2' == 3 {;
qui replace `st2' = 1   in `j' if `i' <= `bcut2';
qui replace `st2' = 2   in `j' if `i' >  `bcut2';		
}; 
			 
};


preserve;
tempvar pp1 pp2 sst1 sst2 ss1 ss2;
qui keep in 1/`nn';
quietly {;
by `q', sort : egen  `pp1' = mean(`p1');
by `q', sort : egen  `pp2' = mean(`p2') ;
qui by `q', sort : egen  `ss1' = mean(`sub1') ;
qui by `q', sort : egen  `ss2' = mean(`sub2') ;
by `q', sort : egen  `sst1' = mean(`st1');
by `q', sort : egen  `sst2' = mean(`st2') ;
};

cap drop __q;
qui gen __q=`q';
collapse (mean) `pp1'  `pp2' `ss1'  `ss2' `sst1'  `sst2'  , by(__q);

qui count;
local nn = `r(N)';

forvalues i=1/`nn' {;
local q`i' = __q[`i'];
local p1`i' = `pp1'[`i'];
local p2`i' = `pp2'[`i'];
local st1`i' = `sst1'[`i'];
local st2`i' = `sst2'[`i'];
local sub1`i' = `ss1'[`i'];
local sub2`i' = `ss2'[`i'];
};

restore; 

cap drop `q' `p1'  `p2'   `st1'  `st2' `sub1' `sub2';
tempvar q p1 p2 sub1 sub2 st1 st2;
qui gen `q' = .;
qui gen `p1' = .;
qui gen `p2' = .;
qui gen `st1' = .;
qui gen `st2' = .;
qui gen `sub1' = .;
qui gen `sub2' = .;

forvalues i=1/`nn' {;
qui replace `q'  = `q`i''  in `i';
qui replace `p1' = `p1`i'' in `i';
qui replace `p2' = `p2`i'' in `i';
qui replace `st1' = `st1`i'' in `i';
qui replace `st2' = `st2`i'' in `i';
qui replace `sub1' = `sub1`i'' in `i';
qui replace `sub2' = `sub2`i'' in `i';
};




local nn1=`nn'-1;
local nn2=`nn'-2;

sort `q'  in 1/`nn';

/* list `q' `p1' `p2' `st1' `st2' in 1/`nn' ; */


forvalues i = 1/`nn' {;
local i1=`i'-1;
if   (`p1'[`i']==. ) {;
local h1=`i';
while `p1'[`h1']==. & `h1' <=`nn' {;
local h1 =`h1'+1 ;
};
qui replace `p1'=`p1'[`h1'] in `i';
qui replace `st1'=`st1'[`h1'] in `i';
qui replace `sub1'=`sub1'[`h1'] in `i';
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
qui replace `sub2'=`sub2'[`h2'] in `i';
local h2=`h2'-1;
};
};




forvalues i = 1/`nn' {;
cap drop `p1_`i'' ;
cap drop `p2_`i'' ;
cap drop `sub1_`i'' ;
cap drop `sub2_`i'' ;
tempvar p1_`i'  p2_`i' sub1_`i'  sub2_`i' ;
if `st1'[`i']==1 qui gen `p1_`i'' = `p1'  ;
if `st1'[`i']==2 qui gen `p1_`i'' = `p1'[`i'] ;

if `st2'[`i']==1 qui gen `p2_`i'' = `p2'  ;
if `st2'[`i']==2 qui gen `p2_`i'' = `p2'[`i'] ;

if `st1'[`i']==1 qui gen `sub1_`i'' = `sub1'  ;
if `st1'[`i']==2 qui gen `sub1_`i'' = `sub1'[`i'] ;

if `st2'[`i']==1 qui gen `sub2_`i'' = `sub2'  ;
if `st2'[`i']==2 qui gen `sub2_`i'' = `sub2'[`i'] ;

};





forvalues i = 1/`nn' {;
forvalues h = 1/`nn' {;
local dp`i'_`h' = (`p2_`h''[`i']/`p1_`h''[`i']-1) ;
local sb`i'_`h' = `sub1_`h''[`i']/`p1_`h''[`i']; // add valorem subsidy
};
};


forvalues i = 1/`nn' {;
local se1_`i'=`q'[1]*`p1_`i''[1];
local basev1_`i'=0;
local sq1_`i'=`q'[1];
local baseq1_`i'=0;
local ex1_`i'= `q'[1]*`p1_`i''[1];
};


forvalues i = 2/`nn' {;
forvalues h = `i'/`nn' {;
local j  = `i'-1;
local j1 = `i'-2;
local ex`i'_`h'= (`q'[`i']-`q'[`i'-1])*`p1_`h''[`i'];
local se`i'_`h' = `se`j'_`h'' + (`q'[`i']-`q'[`i'-1])*`p1_`h''[`i'];
if `i'== 2 local base`i'_`h'=  - (`q'[`j']  -       0)*(`p2_`h''[`j']-`p1_`h''[`j']);
if `i'!= 2 local base`i'_`h'=  - (`q'[`j']-`q'[`j'-1])*(`p2_`h''[`j']-`p1_`h''[`j']);
local basev`i'_`h'=`basev`j'_`h''+`base`i'_`h'';
};
};



cap drop `bexp_`z'';
tempvar bexp_`z';
if `bun1'==1  qui gen `bexp_`z'' = `nva'*`hsize';
if `bun1'==2  qui gen `bexp_`z'' = `nva';
qui replace `bexp_`z'' = max(0,`bexp_`z''-`sfee2'+`sfee1') ;




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
 qui replace `class' = `i'  if (`bexp_`z''>`se`j'' & `bexp_`z''<=`se`i'') ;
};
};
if `nn' >= 2 qui replace `class' = `nn'         if (`bexp_`z''>`se`nn1'')  ;

};



if `str1'==2      {;
if `nn1' > 1 {;
forvalues i = 2/`nn1' {;
local j=`i'-1;
 qui replace `class' = `i'  if `bexp_`z''>(`q'[`j']*`p1'[`i'])  ; 
};
};
if `nn' >= 2 qui replace `class' = `nn'         if (`bexp_`z''>`q'[`nn'-1]*`p1'[`nn'])  ;
};



if `str1'==3      {;
if `nn1' > 1 {;
forvalues i = 2/`bcut1' {;
local j=`i'-1;
 qui replace `class' = `i'  if (`bexp_`z''>`se`j'' ) ;
};
};

local bc11 = `bcut1'-1;
qui replace `class' = `bcut1'         if (`bexp_`z''>`se`bc11'')  ;

local bcut11= `bcut1'+1;
if `nn1' > 1 {;
forvalues i = `bcut11'/`nn1' {;
local j=`i'-1;
 qui replace `class' = `i'  if `bexp_`z''>(`q'[`j']*`p1'[`i'])  ; 
};
};
if `nn' >= 2 qui replace `class' = `nn'         if (`bexp_`z''>`q'[`nn'-1]*`p1'[`nn'])  ;
};





forvalues v=1/101 {;

local pos = (`v'-1)*`step';
qui replace `perc' = `min'+`pos' in `v';
local elas = `min'+`pos';



cap drop _svar_`nva';
qui gen _svar_`nva' = 0 ;


if (`issub'==0) {;

qui replace _svar_`nva'  = `bexp_`z''*`dp1_1'*(1+`elas')                                                  if `class'==1; 
forvalues i = 2/`nn' {;
local k = `i'-1;
forvalues j = 1/`k' {;
qui replace _svar_`nva'  = _svar_`nva'  + `ex`j'_`i''*`dp`j'_`i''*(1+`elas')                                      if `class'==`i'; 
};
local k = `i'-1;
qui replace _svar_`nva'  = _svar_`nva'  + (`bexp_`z''-`se`k'_`i'')*`dp`i'_`i''*(1+`elas')                             if `class'==`i'; 
};

};



if (`issub'==1) {;
qui replace _svar_`nva' = `bexp_`z''*`dp1_1' + max(`elas'*`bexp_`z''*`dp1_1' , -`bexp_`z'')*(`dp1_1'-`sb1_1')                                                                                  if `class'==1; 
forvalues i = 2/`nn' {;
local k = `i'-1;
forvalues j = 1/`k' {;
qui replace _svar_`nva' = _svar_`nva' +  `ex`j'_`i''*`dp`j'_`i'' + max(`elas'*`ex`j'_`i''*`dp`j'_`i'' , -`ex`j'_`i'')*(`dp`j'_`i''-`sb`j'_`i'')                                          if `class'==`i'; 
};
local k = `i'-1;
qui replace _svar_`nva' = _svar_`nva' + (`bexp_`z''-`se`k'_`i'')*`dp`i'_`i'' + max(`elas'*(`bexp_`z''-`se`k'_`i'')*`dp`i'_`i'' , -(`bexp_`z''-`se`k'_`i''))*(`dp`i'_`i''-`sb`i'_`i'')                if `class'==`i'; 
};
};

if `bun1'==1 qui replace  _svar_`nva'= _svar_`nva'/`hsize';
qui sum  _svar_`nva' [aw=`fw'];
qui replace `est_`z'' = `r(sum)'/(1+`inf'/100) in `v';
cap drop _svar_`nva';

}; 

};
 


aggrvar `ylist' , xrnames(`xrnames') aggregate(`aggregate');
local slist = r(slist);
local flist = r(flist);
local nl = `r(nl)'; 


gropt 6 `lan' ;
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








