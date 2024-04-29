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






#delimit ;
capture program drop pschdes2 ;
program define pschdes2 , eclass;
version 9.2;
syntax namelist  [,  ITEM(string) DGRA(int 0) SGRA(string) EGRA(string) *];



_get_gropts , graphopts(`options') ;
	local options `"`s(graphopts)'"';

tokenize `namelist';
_nlargs `namelist';

local ipsch = "`1'";
local fpsch = "`2'";

tempvar Variable;
qui gen `Variable'="";

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
			 qui replace `sub1' = `.`ipsch'.blk[`i'].subside'  in `i' ;
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
			 qui replace `sub2' = `.`fpsch'.blk[`i'].subside'  in `j' ;
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




/* list `q' `p1' `p2' `st1' `st2' in 1/`nn' ; */

local mxb0 = 0;
forvalues i=1/`nn' {;
local j= `i'-1;
local mxb`i' = round(`q'[`i'], 4.0) ;
qui replace `Variable' = " `mxb`j'' - `mxb`i'' " in `i';
if `i'==`nn' qui replace `Variable' = " `mxb`j'' and more " in `i';
};
                 local rstr1="IBT";
if `str1' == 2   local rstr1="VDT";
if `str1' == 3   local rstr1="IBT/VDT";

                 local rstr2="IBT";
if `str2' == 2   local rstr2="VDT";
if `str2' == 3   local rstr2="IBT/VDT";
	tempname table;
	.`table'  = ._tab.new, col(6);
	.`table'.width |30|8 20 20 | 8 20 |;
	.`table'.strcolor . . . . . . ;
	.`table'.numcolor yellow yellow yellow   yellow yellow   yellow;
	local atit = "";
	if "`item'"~="" local atit = "of `item'" ; 
	di _n as text "{col 4} Description of the price schedules `atit'";
	di _n as text "{col 4} Initial schedule subscription fees: `sfee1'";
	di    as text "{col 4} Final   schedule subscription fees: `sfee2'";
	.`table'.numfmt %16.0g  %8.0g  %16.6f %16.6f %8.0g  %16.6f  ;
    .`table'.sep, top;
	.`table'.titles "    " "" "Initial price"     "  "    ""  "Final price        ";
    .`table'.sep, mid;
	.`table'.titles "Block                    " "Structure" "Tariff     "     "Subsidy    "    "Structure"  "Tariff       ";
	.`table'.sep, mid;
	forvalues i=1/`nn'{;
	                         local tmp1 = "IBT"; 
	  if `st1'[`i']==2       local tmp1 = "VDT"; 
	  	                  local tmp2 = "IBT"; 
	  if `st2'[`i']==2    local tmp2 = "VDT"; 
                                       .`table'.numcolor white yellow   yellow  yellow  yellow  yellow ;
			                           .`table'.row `Variable'[`i'] "`tmp1'" `p1'[`i'] `sub1'[`i'] "`tmp2'" `p2'[`i']   ; 
									   	   local temn= `Variable'[`i'];
											local  rnama `"`rnama' "`temn'""';
			                          
				           };
.`table'.sep,bot;
tempname ma;
 mkmat `p1' `sub1' `p2' in 1/`nn' , matrix(`ma') ;
	  
  matrix colnames `ma' = "Initial price (`rstr1')" "Subsidy"   "Final price (`rstr2')"  ;
  matrix rownames `ma' = `rnama' ;
  ereturn matrix maps = `ma' ;
  ereturn scalar str1 = `str1';
  ereturn scalar str2 = `str2';
  ereturn scalar bct1 = `bcut1';
  ereturn scalar bct2 = `bcut2';
  


end;


