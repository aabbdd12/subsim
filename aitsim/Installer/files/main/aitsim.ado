/*************************************************************************/
/* SUBSIM: Subsidy Simulation Stata Toolkit  (Version 2.0)               */
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

capture program drop aitsim;
program define aitsim, rclass sortpreserve;
version 9.2;
syntax varlist(min=1 max=1)[ ,
HHID(varname)   
HSize(varname) 
PLINE(varname)
INCOME(varname)
TYINC(int 1)

ITSCH(string)
NSCEN(int 1) 

FTSCH1(string)
FTSCH2(string)
FTSCH3(string)

ELAS1(varname)
ELAS2(varname)
ELAS3(varname)

OINF(int 1)
HGroup(varname) 


XFIL(string)
LAN(string)

INISave(string) 
TJOBS(string)
SUMMARY(int 0) 
GJOBS(string) 

CNAME(string)
YSVY(string)
YSIM(string)
LCUR(string)

FOLGR(string)
GVIMP(int 0) 


OPR1(string) OPR2(string)  OPR3(string)  OPR4(string) OPR5(string)  
OPR6(string) OPR7(string)  OPR8(string)  OPR9(string) OPR10(string)

GTITLE(string)

OPGR1(string)   
OPGR2(string)   
OPGR3(string)   
OPGR4(string)   
OPGR5(string)  
OPGR6(string)   
OPGR7(string)   
OPGR8(string)   
OPGR9(string)  
OPGR10(string)  


];



 if ("`inisave'" ~="") {;
  aitdbsave `0' ;
  };

  

	qui svyset ;
	if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);

	if ("`inisave'" ~="" ) {;
	tokenize "`inisave'" ,  parse(".");

	local inisave = "`1'";
	};
    
local mylist min max ogr;
forvalues i=1/10 {;
if ("`opgr`i''"~="") {;
extend_opt_graph test , `opgr`i'' ;
foreach name of local mylist {;
local `name'`i' = r(`name');
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};
};
 
	local inf1 =0;
	local inf2 =0;
	local inf3 =0;
	tokenize `varlist';
	tempvar exp_pc;
	local varna = "`1'";
	gen `exp_pc'=`1';
	local nexp_pc="`1'";
    if ("`lan'" =="") local lan = "en";

if (`oinf'==2) {;

local ITSCH   = "`ITSCH'" ;

};

if ("`lan'" == "") local lan = "en";
if ("`tjobs'" == ""  & "`tjobs'"~="off")  local tjobs 10 11 21  31 32 41 42 43 44 45 46 47 ; 
if ("`gjobs'" == ""  & "`gjobs'"~="off" ) local gjobs 1 2 3 4 5 6 7 8 9 10;



tokenize "`tjobs'";
quietly {;
local k = -1;
if "`exp_pc'" ~= "" {;
local k = 1;
mac shift;
};
while "``k''" ~= "" {; 
local k = `k'+1;
};
};
if (`k'==-1) local k = 0;
tokenize "`tjobs'";
forvalues i=1/`k' {;
local tjob`i' = "``i''";
};
local ntables = `k';
tokenize "`gjobs'";
quietly {;
local k = -1;
if "`exp_pc'" ~= "" {;
local k = 1;
mac shift;
};
while "``k''" ~= "" {; 
local k = `k'+1;
};
};
if (`k'==-1) local k = 0;
tokenize "`gjobs'";
forvalues i=1/`k' {;
local gjob`i' = "``i''";

};
local ngraphs = `k';


tokenize `varlist';



local hweight=""; 
cap qui svy: total `exp_pc'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear;


if (`tyinc'==1) {;
tempvar groinc ;
gen `groinc' = `income' ;
};

if (`tyinc'==2) {;
nettogross `income', itsch(`itsch') ;
tempvar groinc;
gen `groinc' = _gross_inc ;
};


if ("`hsize'"=="" )         {;
tempvar hsize;
qui gen `hsize' = 1;
};
tempvar fw;
qui gen `fw'=`hsize';
if ("`hweight'"~="")        qui replace `fw'=`fw'*`hweight';

tempvar quint;
xtile  `quint'=`exp_pc' [aw=`fw'],  nq(5);
cap label drop quint;
forvalues i=1/5 {;
  lab def quint `i' "Quintile `i'", add;
};
lab val `quint' quint; 

local ohgroup = "`hgroup'";

if "`hgroup'"==""  local hgroup = "`quint'";
                   local langr  = "Groups"; 
if ("`lan'"=="fr") local langr = "Groupes";

local dec10=2;

local dec11_1=0;
local dec11_2=0;
local dec11_3=2;
local dec11_4=2;

local dec21_1=0;
local dec21_2=0;
local dec21_3=1;
local dec21_4=1;

local dec21=0;


local dec22=2;
local dec23=2;
local dec24=0;
local dec25=2;
local dec31=2;
local dec32=2;
local dec33=0;
local dec34=2;
local dec35=2;
local dec41=0;
local dec42=2;

local dec43=2;
local dec44=2;
local dec45=2;
local dec46=2;
local dec47=2;


local dec31_1=2;
local dec31_2=2;

local dec32_1=2;
local dec32_2=2;

local dec41_1=0;
local dec41_2=2;

local dec42_1=0;
local dec42_2=2;


local dec43_1=3;
local dec43_2=3;

local dec44_1=3;
local dec44_2=3;

local dec45_1=3;
local dec45_2=3;

local dec46_1=3;
local dec46_2=3;

local dec47_1=3;
local dec47_2=3;



local dec43=2;
local dec44=0;
local dec45=3;
local dec46=0;
local dec47=3;
local dec48=3;
local dec49=2;

tokenize "`xfil'" ,  parse(".");
local tname `1'.xml;

if "`xfil'" ~= ""  { ;
tokenize "`xfil'" ,  parse(".");
local xfil `1'.xml ;
cap erase `1'.xml ;
/* cap winexec   taskkill /IM excel.exe ; */

};





if (1==1) {;
local       tyincome = "gross"; 
if `tyinc' == 2 local tyincome = "net"; 
set more off;
di _n as text in white "{col 5}***************************General information*************************";
       
	   if ("`lan'"=="en") {;

	  if ("`cname'"!="")  local tnote   `" " - Country: `cname' " , "'   ;
	  
	  if ("`cname'"!="")   di as text     "{col 5}Country {col 30}: `cname'";
	  di as text     "{col 5}Data survey{col 30}: $S_FN";

	  local tnote2   `" " - Data survey:  $S_FN  " , "'   ;
	    
	  
	   if ("`ysvy'"!="")   di as text      "{col 5}Year of survey  {col 30}:  `ysvy'";
	   if ("`ysvy'"!="")  local tnote3   `" " - Year of survey:  `ysvy' " , "'   ;
	   
	   
	   if ("`ysim'"!="")   di as text      "{col 5}Year of simulation{col 30}:  `ysim'";
	   if ("`ysim'"!="")  local tnote4   `" " - Year of simulation:  `ysim' " , "'   ;
	   
	   if ("`lcur'"!="")   di as text      "{col 5}Local curency{col 30}: `lcur'";
	    if ("`lcur'"!="")  local tnote5   `" " - Local curency:  `lcur' " , "'   ;
	   

		  
	   if ("`hhid'"!="")   di as text     "{col 5}Household identifier{col 30}:  `hhid'";
	   if ("`hhid'"!="")   local tnote6   `" " - Household  identifier:  `hhid' " , "'   ;  
		  
       if ("`hsize'"!="")   di as text     "{col 5}Household size{col 30}:  `hsize'";
	   if ("`hsize'"!="")   local tnote7   `" " - Household size:  `hsize' " , "'   ;
	   
	   	  di as text     "{col 5}The per cap. expenditures {col 30}:  `nexp_pc'";
		  local tnote8   `" "  - The per capita expenditures  `nexp_pc' " , "'   ;
		  
		  di as text     "{col 5}The `tyincome' income{col 30}:  `income'";
		  local tnote9   `" "  - The `tyincome' income  `income' " , "'   ;
	   
       if ("`hweight'"!="") di as text     "{col 5}Sampling weight{col 30}:  `hweight'";
	   if ("`hweight'"!="")   local tnote10   `" " - Sampling weight:  `hweight' " , "'   ;
	   
       if ("`ohgroup'"!="")   di as text     "{col 5}Group variable{col 30}:  `ohgroup'";
	   if ("`ohgroup'"!="")   local tnote11   `" " - Household group:  `ohgroup' " , "' ; 
	   
	   
	   
		    cap sum `pline';
		local maxpl =`r(max)' ;
		local minpl =`r(min)' ;
		
	    if ("`pline'"!="")  di as text     "{col 5}Poverty line {col 30}:  `pline'  {col 40}: Min = `minpl'   {col 60}: Max = `maxpl'";
	    if ("`pline'"!="")   local tnote12   `" " - Poverty line :  `pline'   | Min=`minpl' | Max=`maxpl'  " , "'   ;
	   
	
		};
		
		 if ("`lan'"=="fr") {;

	  if ("`cname'"!="")  local tnote   `" " - Pays: `cname' " , "'   ;
	  
	  if ("`cname'"!="")   di as text     "{col 5}Pays {col 30}: `cname'";
	  di as text     "{col 5}Enquête {col 30}: $S_FN";

	  local tnote2   `" " - Enquête:  $S_FN  " , "'   ;
	    
	  
	   if ("`ysvy'"!="")   di as text      "{col 5}Année de collecte des données {col 30}:  `ysvy'";
	   if ("`ysvy'"!="")  local tnote3   `" " - Année de collecte des données:  `ysvy' " , "'   ;
	   
	   
	   if ("`ysim'"!="")   di as text      "{col 5}Année de la simulation{col 30}:  `ysim'";
	   if ("`ysim'"!="")  local tnote4   `" " - Année de la simulation:  `ysim' " , "'   ;
	   
	   if ("`lcur'"!="")   di as text      "{col 5}Monnaie du pays {col 30}: `lcur'";
	    if ("`lcur'"!="")  local tnote5   `" " - Monnaie du pays:  `lcur' " , "'   ;
	   
	      di as text     "{col 5} Le revenue  {col 30}:  `nexp_pc'";
		  local tnote6   `" " - Le revenue :  `nexp_pc' " , "'   ;
		  
       if ("`hsize'"!="")   di as text     "{col 5}Taille du ménage {col 30}:  `hsize'";
	   if ("`hsize'"!="")   local tnote7   `" " - Taille du ménage:  `hsize' " , "'   ;
	   
       if ("`hweight'"!="") di as text     "{col 5}Poids d'échantillonage {col 30}:  `hweight'";
	   if ("`hweight'"!="")   local tnote8   `" " - Poids ménages :  `hweight' " , "'   ;
	   
       if ("`ohgroup'"!="")   di as text     "{col 5}Variable de groupe {col 30}:  `ohgroup'";
	   if ("`ohgroup'"!="")   local tnote9   `" " - Variable de groupe :  `ohgroup' " , "' ; 

		    cap sum `pline';
		local maxpl =`r(max)' ;
		local minpl =`r(min)' ;
		
	    if ("`pline'"!="")   di as text     "{col 5}Ligne de pauvreté {col 30}:  `pline'  {col 40}: Min = `minpl'   {col 60}: Max = `maxpl'";
	    if ("`pline'"!="")   local tnote12   `" " - Ligne de pauvreté :  `pline'   | Min=`minpl' | Max=`maxpl'  " , "'   ;
	   

		};
	
	
	
	if (`nscen' > 1) {;
	 dis _n "{col 2}  Initial :" _continue;
	 itschdes `itsch' ;
	 forvalues s=1/`nscen' {;
	 dis _n "{col 2}  Scenario `s' :" _continue;
	  itschdes `ftsch`s'' ;
	 };
	};
	
	
di _n as text in white "{col 5}*************************************************************************";


};


local summalist 11 33 34 42 46 46b 47 49 g9 ;
foreach val of local summalist {;
local suk`val' = 0;
};



if ("`tjobs'"~="off") {;
forvalues i=1/`ntables' {;
forvalues s=1/`nscen' {;

if `nscen'!=1 local scena = " : Scenarion `s'";
if (`tjob`i'' == 10 ) {;
qui itschdes2 `itsch' `ftsch`s'' ;
tempname mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(maps);
it_tabtit `tjob`i'' `lan';
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', 
dec(2)  
atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(2) xfil(`xfil') 
dec1(2)  
dec2(2) 
xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);
};
};



if (`tjob`i'' == 11 ) {;
itjob`tjob`i'' `exp_pc' , hs(`hsize') hhid(`hhid') hgroup(`hgroup') income(`groinc') lan(`lan') ;
tempname mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
it_tabtit `tjob`i'' `lan';
local tabtit = "`r(tabtit)'";
distable `mat`tjob`i''', 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')   
dec3(`dec`tjob`i''_3')  
dec4(`dec`tjob`i''_4')  
atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')   
dec3(`dec`tjob`i''_3')  
dec4(`dec`tjob`i''_4') 
xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);

if (`summary' == 1) {;
local suk`tjob`i'' = 1;
tempname my`tjob`i'';
matrix `my`tjob`i''' = `mat`tjob`i''' ;
};

cap matrix drop `mat`tjob`i''';

};

if (`tjob`i'' == 21 ) {;
itjob`tjob`i'' `exp_pc'   , hs(`hsize') hhid(`hhid') hgroup(`hgroup') income(`groinc') lan(`lan') ;
tempname mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
it_tabtit `tjob`i'' `lan';
local tabtit = "`r(tabtit)'";
distable `mat`tjob`i''', 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')   
dec3(`dec`tjob`i''_3')  
dec4(`dec`tjob`i''_4')  
atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')   
dec3(`dec`tjob`i''_3')  
dec4(`dec`tjob`i''_4') 
xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);

if (`summary' == 1) {;
local suk`tjob`i'' = 1;
tempname my`tjob`i'';
matrix `my`tjob`i''' = `mat`tjob`i''' ;
};

cap matrix drop `mat`tjob`i''';

};


forvalues s=1/`nscen' {;

if `nscen'!=1 local scena = " : Scenarion `s'";
if (`tjob`i'' >= 31 & `tjob`i'' <= 32) {;


itjob`tjob`i'' `groinc',  hhid(`hhid') hs(`hsize') hgroup(`hgroup') lan(`lan')  pcexp(`exp_pc') income(`groinc') itsch(`itsch') ftsch1(`ftsch`s'')    gvimp(`gvimp');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

it_tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''' , 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')
atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2') 

xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

if (`summary' == 1) {;
local suk`tjob`i'' = 1;
tempname my`tjob`i''_`s';
matrix `my`tjob`i''_`s'' = `mat`tjob`i''' ;
};

cap matrix drop `mat`tjob`i''';

};
};


if (`tjob`i'' >= 33 & `tjob`i'' <= 35 ) {;
*set trace on;
set tracedepth 3;
itjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ITSCH(`ITSCH');
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
it_tabtit `tjob`i'' `lan'; local tabtit = "`r(tabtit)'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`r(tabtit)')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);

if (`summary' == 1) {;
local suk`tjob`i'' = 1;
tempname my`tjob`i'';
matrix `my`tjob`i''' = `mat`tjob`i''' ;
};
 cap matrix drop `mat`tjob`i''';
};




forvalues s=1/`nscen' {;
if `nscen'!=1 local scena = " : Scenarion `s'";

if (`tjob`i'' == 41 ) {;

* set trace on;

itjob`tjob`i'' `groinc',  hhid(`hhid') hs(`hsize') hgroup(`hgroup') lan(`lan')  pcexp(`exp_pc') itsch(`itsch') ftsch(`ftsch`s'')  gvimp(`gvimp');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

it_tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')
atit(`langr') head1(`tabtit')  head2(`head2') ;

mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2') 
xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};

};



forvalues s=1/`nscen' {;
if `nscen'!=1 local scena = " : Scenarion `s'";

if (`tjob`i'' == 42 ) {;

set more off;
* set trace on;

itjob`tjob`i'' `groinc',  hhid(`hhid') hs(`hsize') hgroup(`hgroup') lan(`lan')  pcexp(`exp_pc') itsch(`itsch') ftsch(`ftsch`s'') elas(`elas`s'') ;

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

it_tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')
atit(`langr') head1(`tabtit')  head2(`head2') ;

mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2') 
xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};

};





forvalues s=1/`nscen' {;
if `nscen'!=1 local scena = " : Scenarion `s'";

if (`tjob`i'' == 43 ) {;

* set trace on;

itjob`tjob`i'' `groinc',  hhid(`hhid') hs(`hsize') hgroup(`hgroup') lan(`lan')  pcexp(`exp_pc') itsch(`itsch') ftsch(`ftsch`s'') pline(`pline') gvimp(`gvimp');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

it_tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')
atit(`langr') head1(`tabtit')  head2(`head2') ;

mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2') 
xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};

};




forvalues s=1/`nscen' {;
if `nscen'!=1 local scena = " : Scenarion `s'";

if (`tjob`i'' == 44 ) {;

* set trace on;

itjob`tjob`i'' `groinc',  hhid(`hhid') hs(`hsize') hgroup(`hgroup') lan(`lan')  pcexp(`exp_pc') itsch(`itsch') ftsch(`ftsch`s'') pline(`pline') gvimp(`gvimp');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

it_tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')
atit(`langr') head1(`tabtit')  head2(`head2') ;

mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2') 
xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};

};



forvalues s=1/`nscen' {;
if `nscen'!=1 local scena = " : Scenarion `s'";

if (`tjob`i'' == 45 ) {;

* set trace on;

itjob`tjob`i'' `groinc',  hhid(`hhid') hs(`hsize') hgroup(`hgroup') lan(`lan')  pcexp(`exp_pc') itsch(`itsch') ftsch(`ftsch`s'') gvimp(`gvimp');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

it_tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')
atit(`langr') head1(`tabtit')  head2(`head2') ;

mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2') 
xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};

};





forvalues s=1/`nscen' {;
if `nscen'!=1 local scena = " : Scenarion `s'";

if (`tjob`i'' == 46 ) {;

* set trace on;

itjob`tjob`i'' `groinc',  hhid(`hhid') hs(`hsize') hgroup(`hgroup') lan(`lan')  pcexp(`exp_pc') itsch(`itsch') ftsch(`ftsch`s'') gvimp(`gvimp');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

it_tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')
atit(`langr') head1(`tabtit')  head2(`head2') ;

mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2') 
xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};

};



forvalues s=1/`nscen' {;
if `nscen'!=1 local scena = " : Scenarion `s'";

if (`tjob`i'' == 47 ) {;

* set trace on;

itjob`tjob`i'' `groinc',   hgroup(`hgroup') lan(`lan')  itsch(`itsch') ftsch(`ftsch`s'') gvimp(`gvimp');

tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

it_tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', 
dec(`dec`tjob`i''_1') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2')
atit(`langr') head1(`tabtit')  head2(`head2') ;

mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') 
dec(`dec`tjob`i''_1') xfil(`xfil') 
dec1(`dec`tjob`i''_1')  
dec2(`dec`tjob`i''_2') 
xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';

};

};


};
};

*set trace on ;
set tracedepth 1 ;



tempvar component sum_res_I sum_res_S Delta_sum_res ;
qui gen  `sum_res_I'  = . ; 
qui gen  `sum_res_S'  = . ; 
qui gen  `Delta_sum_res'  = . ; 
qui gen     `component'  = "" ; 

qui replace `component' = "Welfare(per capita)"                            in 1;
qui replace `component' = "Poverty (%)"                                    in 2;
qui replace `component' = "Inequality (%)"                                 in 3;

qui replace `component' = "Subsidies    (in millions)"                             in 4;
qui replace `component' = "Transfers    (in millions)*"                             in 5;
qui replace `component' = "Total budget (in millions)"                             in 6;

qui replace `component' = "Subsidy  (per capita)"                             in 7;
qui replace `component' = "Transfer (per capita)"                             in 8;
qui replace `component' = "Transfer (per beneficiary)"                        in 9;

cap macro drop indica ;
cap macro drop indig ;
cap macro drop rnam ;


if ("`folgr'"!=""){;
cap rmdir cap rmdir Graphs;
cap mkdir `folgr'/Graphs;
cap mkdir `folgr'/Graphs;
local mygrdir `folgr'\Graphs\ ;
};


if ("`folgr'"==""){;
cap rmdir Graphs;
cap mkdir Graphs;
local mygrdir Graphs\ ;

};


if ( "`gjobs'"~="off" ){;
forvalues i=1/`ngraphs' {;

if (`gjob`i'' == 1 ) {;
 *set trace on; 
set tracedepth 1;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;
itjobgr`gjob`i'' `groinc',  hhid(`hhid')  hsize(`hsize') lan(`lan')  itsch(`itsch') ftsch1(`ftsch1') ftsch2(`ftsch2') ftsch3(`ftsch3') nscen(`nscen') pcexp(`exp_pc') ogr(`ogr`gjob`i''') min(`min`gjob`i''') max(`max`gjob`i''')  lan(`lan')  ;


 qui graph save           "`mygrdir'Fig_`gjob`i''.gph" , replace ;
 qui graph export         "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
 qui cap graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
};

if (`gjob`i'' == 2 ) {;
 *set trace on; 
set tracedepth 1;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;
itjobgr`gjob`i'' `groinc',  hhid(`hhid')  hsize(`hsize') lan(`lan')  itsch(`itsch') ftsch1(`ftsch1') ftsch2(`ftsch2') ftsch3(`ftsch3') nscen(`nscen') pcexp(`exp_pc') ogr(`ogr`gjob`i''') min(`min`gjob`i''') max(`max`gjob`i''')  lan(`lan')  ;


 qui graph save           "`mygrdir'Fig_`gjob`i''.gph" , replace ;
 qui graph export         "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
 qui cap graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
};

if (`gjob`i'' == 3 ) {;
 *set trace on; 
set tracedepth 1;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;
itjobgr`gjob`i'' `groinc',  hhid(`hhid')  hsize(`hsize') hgroup(`hgroup') lan(`lan')  itsch(`itsch') ftsch1(`ftsch1') ftsch2(`ftsch2') ftsch3(`ftsch3') nscen(`nscen') pcexp(`exp_pc') ogr(`ogr`gjob`i''')   ;


 qui graph save           "`mygrdir'Fig_`gjob`i''.gph" , replace ;
 qui graph export         "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
 qui cap graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
};




if (`gjob`i'' == 4 ) {;
 *set trace on; 
set tracedepth 1;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;
itjobgr`gjob`i'' `groinc',  hhid(`hhid')  hsize(`hsize') lan(`lan')  itsch(`itsch') ftsch1(`ftsch1') ftsch2(`ftsch2') ftsch3(`ftsch3') nscen(`nscen') pcexp(`exp_pc') ogr(`ogr`gjob`i''') min(`min`gjob`i''') max(`max`gjob`i''')  lan(`lan')  ;


 qui graph save           "`mygrdir'Fig_`gjob`i''.gph" , replace ;
 qui graph export         "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
 qui cap graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
};




};


};





cap drop __nevar*;

if  ("`xfil'" ~= "" &  "`tjobs'"~="off" ) | ("`xfil'" ~= "" &  `summary'==1) {;
cap !start /min `xfil'; 
};





  
cap drop __VNITEMS ; 
cap drop __SLITEMS ; 
cap drop __UNITS ; 
cap drop __ITSCH  ; 
cap drop __ELAS1   ; 
cap drop __FTSCH1  ; 
cap drop __imp_well ;
cap drop __imp_rev ;
cap drop __imrsub ;

end;

