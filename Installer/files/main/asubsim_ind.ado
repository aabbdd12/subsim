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

/* 
IN PROGRESS***** 
KEEP the structure
initialise the prices.
1- init price = 1 sub 0
2- estimate price changes
3- fin price
4- compute
*/

#delimit ;

capture program drop asubsim_ind;
program define asubsim_ind, rclass sortpreserve;
version 9.2;
syntax varlist(min=1 max=1)[ ,   
HSize(varname) 
PLINE(varname)

ITNAMES(varname)
SNAMES(varname)
IPSCH(varname)
UNIT(varname)

FPSCH1(varname)
ELAS1(varname)

FPSCH2(varname)
ELAS2(varname)

FPSCH3(varname)
ELAS3(varname)

OINF(int 1)
ESAP(int 1)



NSCEN(int 1) 
HGroup(varname) 
NITEMS(int 1)

XFIL(string)
LAN(string)
TAGGRegate(string)
GAGGRegate(string)
/*appr(int 1) */ 
wappr(int 1)
INISave(string) 
TJOBS(string)
SUMMARY(int 0) 
GJOBS(string) 

CNAME(string)
YSVY(string)
YSIM(string)
LCUR(string)
TYPETR(int 1)
GTARG(varname)
FOLGR(string)
GVIMP(int 0) 

GTITLE(string)

IT1(string) IT2(string)  IT3(string)  IT4(string) IT5(string)  
IT6(string) IT7(string)  IT8(string)  IT9(string) IT10(string)

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

IOMATRIX(string)
MATCH(varname)

IOMODEL(int 1)
TYSHOCK(int 1)
ADSHOCK(int 1)
NADP(int 1)

NSHOCKS(int 1)
SHOCK1(string)
SHOCK2(string)
SHOCK3(string)
SHOCK4(string)
SHOCK5(string)
SHOCK6(string)
];

 if ("`inisave'" ~="") {;
  asdbsave_ind `0' ;
  };

	qui svyset ;
	if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);

	if ("`inisave'" ~="" ) {;
	tokenize "`inisave'" ,  parse(".");
	/* dis "`1'"; */
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
local appr=1;
	local inf1 =0;
	local inf2 =0;
	local inf3 =0;

local mylist secp pr;
forvalues i=1/6 {;
if ("`shock`i''"~="") {;
extend_opt_shocks test , `shock`i'' ;
foreach name of local mylist {;
local `name'`i' = r(`name');
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};
};


 
	
	tokenize `varlist';
	tempvar exp_pc;
	local varna = "`1'";
	qui gen `exp_pc'=`1';
	cap drop if `1'==.;
	local nexp_pc="`1'";
    if ("`lan'" =="") local lan = "en";
	
	
if (`oinf'==1) {;

local mylist sn it el ms;
forvalues i=1/`nitems' {;
extend_opt_item test , `it`i'' ;
foreach name of local mylist {;
local `name'`i'  `r(`name')';
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};	




cap drop __VNITEMS ; 
qui gen  __VNITEMS = "";

cap drop __SLITEMS ; 
qui gen __SLITEMS = "";


 
cap drop __IPSCH  ; 
qui  gen __IPSCH = "";

cap drop __ELAS1   ; 
qui gen  __ELAS1  = "";
  
cap drop __MS  ; 
qui  gen __MS = "";

forvalues i=1/`nitems' {;
if "`el`i''"==""  local el`i' = 0 ;


if ("`it`i''" ~= "" ) qui replace __VNITEMS =  "`it`i''"  in `i' ;
if ("`ms`i''" ~= "" ) qui replace __MS =  "`ms`i''"  in `i' ;

if ("`sn`i''" == "" ) local sn`i' = "`it`i''" ;
if ("`sn`i''" ~= "" ) qui replace __SLITEMS =  "`sn`i''"  in `i' ;

if ("`el`i''" ~= "" ) qui replace __ELAS1 = "`el`i''" in `i' ;
if ("`el`i''" == "" ) qui replace __ELAS1 = 0         in `i' ;


};

local nscen=1;
local vnitems = "__VNITEMS"  ; 
local slitems = "__SLITEMS" ;
local elas1 = "__ELAS1"; 
local match = "__MS"; 
};

	
tempvar ipsch fpsch;

di _n as text in white "{col 5}***************************General information on I/O matrix*************************";
forvalues i=1/6 {;
if "`pr`i''"=="" local pr`i' = 10;
if "`secp`i''"=="" local secp`i' = `i';
};
forvalues i=1/6 {;
local pr`i' = `pr`i''/100;
};
pciom_ind `varlist' , 
iom(`iomatrix')
vnmatch(`match')
secp1(`secp1')
pr1(`pr1')
secp2(`secp2')
pr2(`pr2')
secp3(`secp3')
pr3(`pr3')
secp4(`secp4')
pr4(`pr4')
secp5(`secp5')
pr5(`pr5')
secp6(`secp6')
pr6(`pr6')
nshocks(`nshocks')
nitems(`nitems')
iomodel(`iomodel')
tyshock(`tyshock')
adshock(`adshock')
nadp(`nadp')

;



cap matrix drop RESA;
matrix RESA=e(PRCG);
svmat RESA, names(_PRC_GOOD);
cap matrix drop RESA;
cap drop `ipsch';
tempvar ipsch;
qui gen `ipsch' = "";

cap drop `fpsch1';
tempvar fpsch1;
qui gen `fpsch1' = "";

forvalues i=1/`nitems' {;
pschset	ips`i'	,	nblock(1)	sub1(0)	tr1(1);
local tdp = _PRC_GOOD[`i']+1;
pschset	fps`i'	,	nblock(1)	sub1(0)	tr1(`tdp');
qui replace `ipsch'   = "ips`i'" in `i';
qui replace `fpsch1'   = "fps`i'" in `i';
};
/*
cap drop _PRC;
*/
cap drop __MS;

if (`oinf'==2) {;
local vnitems = "`itnames'"  ; 
local slitems = "`snames'"  ;
if "`snames'"=="" local  slitems = "`itnames'"  ;
};



/*

if ("`lan'" == "") local lan = "en";
if ("`tjobs'" == ""  & "`tjobs'"~="off")  local tjobs 11 21 22 23 24 25 31 32 33 34 35 41 42 43 44 45 46 47 48 49;
if ("`gjobs'" == ""  & "`gjobs'"~="off" ) local gjobs 1 2 3 4 5 6 7 8 9 10;

*/




if ("`lan'" == "") local lan = "en";
if ("`tjobs'" == ""  & "`tjobs'"~="off")  local tjobs 11 21 22 23 31 32  41 42 43 47 48 49;
if ("`gjobs'" == ""  & "`gjobs'"~="off" ) local gjobs 1 3 4 8 9 10;



local vlist;
local slist;
preserve;
qui  cap drop if `vnitems'=="";
//sort `vnitems';
qui count;


forvalues i=1/`r(N)' {;
local tmp = ""+`vnitems'[`i'];
if `i' == 1 local tmp2 = " "+`slitems'[`i'];
if `i' != 1 local tmp2 = " |"+`slitems'[`i'];
if ("`slitems'"~="") {;
local vlist `vlist' `tmp';
local slist `slist' `tmp2';
};
};
restore;

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

local dec11=0;
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
//cap winexec   taskkill /IM excel.exe ;

};

/*
//in test
_getfilename `1';
return list;
local _fname  `r(filename)';
set trace on;
set tracedepth 1;
cap winexec   taskkill /F /FI "WINDOWTITLE eq Microsoft Excel - `_fname'.xml " ;
set trace off;
cap erase `1'.xml ;
*/




if (1==1) {;
set more off;
di _n as text in white "{col 5}***************************General information on Items*************************";
       
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
	   
	      di as text     "{col 5}Per capita expenditures{col 30}:  `nexp_pc'";
		  local tnote6   `" " - Per capita expenditures:  `nexp_pc' " , "'   ;
		  
       if ("`hsize'"!="")   di as text     "{col 5}Household size{col 30}:  `hsize'";
	   if ("`hsize'"!="")   local tnote7   `" " - Household size:  `hsize' " , "'   ;
	   
       if ("`hweight'"!="") di as text     "{col 5}Sampling weight{col 30}:  `hweight'";
	   if ("`hweight'"!="")   local tnote8   `" " - Sampling weight:  `hweight' " , "'   ;
	   
       if ("`ohgroup'"!="")   di as text     "{col 5}Group variable{col 30}:  `ohgroup'";
	   if ("`ohgroup'"!="")   local tnote9   `" " - Household group:  `ohgroup' " , "' ; 
	   
local titmodel = "" ;
if `iomodel'==1 {;
if (`tyshock' == 1)  & (`adshock' == 1) local titmodel = "Cost push price model | sort term | permanent exogenous shock(s)" ;
if (`tyshock' == 1)  & (`adshock' == 2) local titmodel = "Cost push price model | long term | permanent exogenous shock(s)" ;

if (`tyshock' == 2)  & (`adshock' == 1) local titmodel = "Cost push price model | sort term | temporal exogenous shock(s)" ;
if (`tyshock' == 2)  & (`adshock' == 2) local titmodel = "Cost push price model | long term | temporal exogenous shock(s)" ;

};
if `iomodel'==2  local titmodel = "Marginal profit push price model | long term | temporal exogenous shock(s)";
local tnote10     `" " - `titmodel'"  , "';


	
	    if (`wappr'==1| "`wappr'"=="")  di as text     "{col 5}Impact on well-being{col 30}: Marginal approach";
		if (`wappr'==2)  di as text     "{col 5}Impact on well-being{col 30}: Modeling approach (Cob-Douglas function)";
		
	    if (`wappr'==1 | "`wappr'"=="")  local tnote11     `" " - Impact on well-being: Marginal approach" , "'   ;
		if (`wappr'==2)  local tnote11     `" " - Impact on well-being: Modeling approach (Cob-Douglas function)" , "'    ;
		
		    cap sum `pline';
		local maxpl =`r(max)' ;
		local minpl =`r(min)' ;
		
	    if ("`pline'"!="")  di as text     "{col 5}Poverty line {col 30}:  `pline'  {col 40}: Min = `minpl'   {col 60}: Max = `maxpl'";
	    if ("`pline'"!="")   local tnote12   `" " - Poverty line :  `pline'   | Min=`minpl' | Max=`maxpl'  " , "'   ;
	   
		
	    if ("`nitems'"!="")  di as text     "{col 5}Number of items{col 30}:  `nitems'";
	    if ("`nitems'"!="")   local tnote13   `" " - Number of items:  `nitems' " , "'   ;
		
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
	   
	      di as text     "{col 5}Dépenses per capita {col 30}:  `nexp_pc'";
		  local tnote6   `" " - Dépenses per capita :  `nexp_pc' " , "'   ;
		  
       if ("`hsize'"!="")   di as text     "{col 5}Taille du ménage {col 30}:  `hsize'";
	   if ("`hsize'"!="")   local tnote7   `" " - Taille du ménage:  `hsize' " , "'   ;
	   
       if ("`hweight'"!="") di as text     "{col 5}Poids d'échantillonage {col 30}:  `hweight'";
	   if ("`hweight'"!="")   local tnote8   `" " - Poids ménages :  `hweight' " , "'   ;
	   
       if ("`ohgroup'"!="")   di as text     "{col 5}Variable de groupe {col 30}:  `ohgroup'";
	   if ("`ohgroup'"!="")   local tnote9   `" " - Variable de groupe :  `ohgroup' " , "' ; 
	     /*
	     if (`appr'==1 | "`appr'"=="")   di as text     "{col 5}Approximation{col 30}: Ignore  the interaction effect";
		 if (`appr'==2)                  di as text     "{col 5}Approximation{col 30}: Include the interaction effect";
		
	    if (`appr'==1 | "`appr'"=="")  local tnote10     `" " - Approximation: Ignore  the interaction effect " , "'   ;
		if (`appr'==2)                 local tnote10     `" " - Approximation: Include the interaction effect   " , "'   ;
		*/

	    if (`wappr'==1| "`wappr'"=="")  di as text     "{col 5}Impact sur le bien-être{col 30}:  Approche marginale";
		if (`wappr'==2)  di as text     "{col 5}Impact sur le bien-être: Modelisation des préférences avec une fontion Cobb-Douglas";
		
	    if (`wappr'==1 | "`wappr'"=="")  local tnote11     `" " - Impact sur le bien-être:  Approche marginale" , "'   ;
		if (`wappr'==2)  local tnote11     `" " - Impact sur le bien-être: Modelisation des préférences avec une fontion Cobb-Douglas"  , "'    ;
		
		    cap sum `pline';
		local maxpl =`r(max)' ;
		local minpl =`r(min)' ;
		
	    if ("`pline'"!="")  di as text     "{col 5}Ligne de pauvreté {col 30}:  `pline'  {col 40}: Min = `minpl'   {col 60}: Max = `maxpl'";
	    if ("`pline'"!="")   local tnote12   `" " - Ligne de pauvreté :  `pline'   | Min=`minpl' | Max=`maxpl'  " , "'   ;
	   
		
	    if ("`nitems'"!="")  di as text     "{col 5}Nombre des items{col 30}:  `nitems'";
	    if ("`nitems'"!="")   local tnote13   `" " - Nombre des items:  `nitems' " , "'   ;
		
		};
	
	    tempvar ipr sub fpri1  fpri2 fpri3;
	    qui gen `ipr' = .  ;
	    qui gen `sub' = .  ;
		               qui gen `fpri1' = . ;
		if `nscen'>=2  qui gen `fpri2' = . ;
		if `nscen'==3  qui gen `fpri3' = . ;
	
	      tempname table;
		  local nscen1= `nscne'+1;
		  local ncol = 2+`nscen';
		  forvalues i=2/`nscen' {;
		  local tad1 `tad1' 16 ;
		  local tad2 `tad2' %12.5f;
		  local mad  `mad' `fpri`i'' ;
		  };
        .`table'  = ._tab.new, col(`ncol')  separator(0) lmargin(4);
        .`table'.width  20|16 16 `tad1' ;
		 
		 
        .`table'.numfmt %20.0g  %12.5f %12.5f `tad2';
	    .`table'.sep, top; 
		 if ("`lan'"=="en") {;
       if `nscen'==1  .`table'.titles "Varname  " "Initial price"        "Final price " ;
	   if `nscen'==2  .`table'.titles "Varname  " "Initial price"        "Final price(S1) "        "Final price(S2)"  ;
	   if `nscen'==3  .`table'.titles "Varname  " "Initial price"        "Final price(S1)"         "Final price(S2)" "Final price(S3)" ;
	   };
	   if ("`lan'"=="fr") {;
	    if `nscen'==1  .`table'.titles "Varname  " "Prix initial"       "Prix final " ;
	    if `nscen'==2  .`table'.titles "Varname  " "Prix initial"        "Prix final(S1) "        "Prix final(S2)"  ;
	    if `nscen'==3  .`table'.titles "Varname  " "Prix initial"       "Prix final(S1)"         "Prix final(S2)" "Prix final(S3)" ;
	   };
       .`table'.sep, mid;

	
	   cap drop __compna;
       qui gen  __compna=`vnitems';
	   forvalues i=1/`nitems' {;
	   local ipa = ""+`ipsch'[`i'] ;
	   local n       = `.`ipa'.nblock' ;
	   local su`i'   = `.`ipa'.blk[1].subside';
	   local ip`i'   = `.`ipa'.blk[1].price';
	   forvalues s = 1/`nscen' {;
	   local  fpr = ""+`fpsch`s''[`i'] ;
	   local  fp`s'`i' = `.`fpr'.blk[1].price';
	   };
	   
	   	 qui replace `ipr'  = `ip`i''    in `i';
	     qui replace `sub'  = `su`i''    in `i';
		
		               qui replace `fpri1' = `fp1`i''    in `i';
		 if `nscen'>=2 qui replace `fpri2' = `fp2`i''    in `i';
		 if `nscen'==3 qui replace `fpri3' = `fp3`i''    in `i';
		 
      .`table'.row `slitems'[`i'] `ip`i''  `fp1`i'' `fp2`i'' `fp3`i''  ; 
	   *local temn=__compna[`i'];
	   local temn=`slitems'[`i'];
       local  rnama `"`rnama' "`temn'""';
	  
	   };
	   
	   .`table'.sep, bot; 
	   tempname ma;
	   
	   mkmat `ipr' `sub' `fpri1' `mad' in 1/`nitems' , matrix(`ma') ;
	  
	   if `nscen'==1 matrix colnames `ma' = "Initial price"    "Final price" ;
	   if `nscen'==2 matrix colnames `ma' = "Initial price"    "Final price(S1)"  "Final price(S2)" ;
	   if `nscen'==3 matrix colnames `ma' = "Initial price"    "Final price(S1)"  "Final price(S2)" "Final price(S3)"  ;
	   matrix rownames `ma' = `rnama' ;
	   
	    local frm = "SCCB0 N2316 N2316";
	   cap drop __compna;
	   
	  capture {;
	    xml_taba2 `ma' , title("`xtit'")   /*lines(COL_NAMES 14 `lst1' 2 LAST_ROW 13) */  
	    topnote( `tnote' `tnote2' `tnote3' `tnote4' `tnote5' `tnote6' `tnote7' `tnote8' `tnote9' `tnote10' `tnote11' `tnote12'  `tnote13'  ) 
		font("Courier New" 8) format((S2111) (`frm')) 
	    lines(COL_NAMES 14 `nitems' 2 LAST_ROW 13)  newappend save(`xfil') sheet(General Info);
	        };  
	
di _n as text in white "{col 5}*************************************************************************";


};

local summalist 11 33 34 42 46 46b 47 49 g9 ;
foreach val of local summalist {;
local suk`val' = 0;
};



if ("`tjobs'"~="off") {;
forvalues i=1/`ntables' {;
if (`tjob`i'' == 11) {;
subjob11 `exp_pc'        , hs(`hsize') hgroup(`hgroup') lan(`lan') ;
tempname mat11 ;
matrix `mat11'= e(est);
tabtit 11 `lan';
local tabtit = "`r(tabtit)'";
distable `mat11', dec(`dec`tjob`i''')   atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat11') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);

if (`summary' == 1) {;
local suk`tjob`i'' = 1;
tempname my`tjob`i'';
matrix `my`tjob`i''' = `mat`tjob`i''' ;
};

cap matrix drop `mat`tjob`i''';
};



if (`tjob`i'' >= 21 & `tjob`i'' <= 23) {;
subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc');
tempname  mat`tjob`i'' ; 
matrix `mat`tjob`i'''= e(est);
tabtit `tjob`i'' `lan'; local tabtit = "`r(tabtit)'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`r(tabtit)')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};


if (`tjob`i'' >= 24 & `tjob`i'' <= 25) {;
*set trace on;

set tracedepth 10;
subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch')  unit(`unit')  ;
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
tabtit `tjob`i'' `lan'; local tabtit = "`r(tabtit)'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`r(tabtit)')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};


if (`tjob`i'' >= 31 & `tjob`i'' <= 32) {;
tokenize `varlist';
subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc');
tempname  mat`tjob`i'' ; 
matrix `mat`tjob`i'''= e(est);
tabtit `tjob`i'' `lan'; 

if `tjob`i''==31 & "`lan'"=="en" local tabtit Table 3.1: Structure of expenditure on products (in %) ; 
if `tjob`i''==32 & "`lan'"=="en" local tabtit Table 3.2: Expenditure on products over the total expenditures (in %) ;


if `tjob`i''==31 & "`lan'"=="fr" local tabtit Tableau 3.1: Structure des dépenses sur les produits (en %) ; 
if `tjob`i''==32 & "`lan'"=="fr" local tabtit Tableau 3.2: Dépense sur les produits par rapport aux dépenses totales (en %) ;
	
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i'') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};

if (`tjob`i'' >= 33 & `tjob`i'' <= 35 ) {;
*set trace on;
set tracedepth 3;
subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch');
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
tabtit `tjob`i'' `lan'; local tabtit = "`r(tabtit)'";
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



if (`tjob`i'' >= 41 & `tjob`i'' <= 42) {;
*set trace on;

subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') wappr(`wappr') gvimp(`gvimp');
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

if (`summary' == 1) {;
local suk`tjob`i'' = 1;
tempname my`tjob`i''_`s';
matrix `my`tjob`i''_`s'' = `mat`tjob`i''' ;
};

cap matrix drop `mat`tjob`i''';
};





if (`tjob`i'' == 43) {;
subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') wappr(`wappr');
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);

tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

cap matrix drop `mat`tjob`i''';
};


if (`tjob`i'' >= 44 & `tjob`i'' <= 45) {;
*set trace on;
set more off;
set tracedepth 2;
subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') elas(`elas`s'') wappr(`wappr')  unit(`unit') ;
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);
cap matrix drop `mat`tjob`i''';
};




if (`tjob`i'' == 46) {;
*set trace on;
set tracedepth 3;
subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') inf(`inf`s'') elas(`elas`s'') appr(`appr');
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

if (`summary' == 1) {;
local suk`tjob`i'' = 1;
tempname my`tjob`i''_`s';
matrix `my`tjob`i''_`s'' = `mat`tjob`i''' ;
};

cap matrix drop `mat`tjob`i''';


};


if (`tjob`i'' >= 47 & `tjob`i'' <= 48) {;
subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') pline(`pline') wappr(`wappr');
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') dsmidl(1) ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);

if (`summary' == 1) {;
local suk`tjob`i'' = 1;
tempname my`tjob`i''_`s';
matrix `my`tjob`i''_`s'' = `mat`tjob`i''' ;
};

cap matrix drop `mat`tjob`i''';

};

if (`tjob`i'' == 49) {;
subjob`tjob`i'' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') wappr(`wappr');
tempname  mat`tjob`i'' ;
matrix `mat`tjob`i'''= e(est);
tabtit `tjob`i'' `lan'; 
local tabtit = "`r(tabtit)'"+"`scena'";
distable `mat`tjob`i''', dec(`dec`tjob`i''') atit(`langr') head1(`tabtit')  head2(`head2') dsmidl(1) ;
mk_xtab_m2 `exp_pc' ,  matn(`mat`tjob`i''') dec(`dec`tjob`i''') xfil(`xfil') xshe(table_`tjob`i''_S`s') xtit(`tabtit') xlan(`lan') dste(0);
if (`summary' == 1) {;
local suk`tjob`i'' = 1;
tempname my`tjob`i''_`s';
matrix `my`tjob`i''_`s'' = `mat`tjob`i''' ;
};
cap matrix drop `mat`tjob`i''';
};

};

}; // end nscen.

};


*set more off;
*set trace on ;
set tracedepth 1 ;

if (`summary'==1 ) {;

tempvar component sum_res_I sum_res_S Delta_sum_res ;
qui gen  `sum_res_I'  = . ; 
qui gen  `sum_res_S'  = . ; 
qui gen  `Delta_sum_res'  = . ; 
qui gen     `component'  = "" ; 

qui replace `component' = "Welfare(per capita)"                            in 1;
qui replace `component' = "Poverty (%)"                                    in 2;
qui replace `component' = "Inequality (%)"                                 in 3;
/*
qui replace `component' = "Subsidies    (in millions)"                             in 4;
qui replace `component' = "Transfers    (in millions)*"                             in 5;
qui replace `component' = "Total budget (in millions)"                             in 6;

qui replace `component' = "Subsidy  (per capita)"                             in 7;
qui replace `component' = "Transfer (per capita)"                             in 8;
qui replace `component' = "Transfer (per beneficiary)"                        in 9;
*/
forvalues s=1/`nscen' {;

if `nscen'!=1 local scena = " : Scenario `s'";




local code = 11;
if (`suk`code'' != 1) {;
subjob11 `exp_pc'        , hs(`hsize') hgroup(`hgroup') lan(`lan') ;
tempname my`code' ;
matrix `my`code''= e(est);
};
local pos_last_row rowsof(`my`code'');
qui replace  `sum_res_I'  = el(`my`code'',`pos_last_row',5) in 1 ; 

*cap matrix drop `my`code'';
/*
local code = 33;
if (`suk`code'' != 1) {;
subjob`code' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch');
tempname  my`code' ;
matrix `my`code''= e(est);
};
local cola = colsof(`my`code'');
qui replace  `sum_res_I'  = round(el(`my`code'',6,`cola')/1000000, 0.01) in 4 ; 
*cap matrix drop `my`code'';
*/
/*
local code = 34;
if (`suk`code'' != 1) {;
subjob`code' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch');
tempname  my`code' ;
matrix `my`code''= e(est);
};
local cola = colsof(`my`code'');
qui replace  `sum_res_I'  = round(el(`my`code'',6,`cola'), 0.01)        in 7 ; 
*cap matrix drop `my`code'';
*/

local code = 42;
if (`suk`code'' != 1) {;
subjob`code' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') wappr(`wappr') gvimp(`gvimp');
tempname  my`code'_`s' ;
matrix `my`code'_`s''= e(est);
};
local cola = colsof(`my`code'_`s'');
local pos_last_row rowsof(`my`code'_`s''); 
qui replace  `sum_res_S'  = `sum_res_I'[1]+ el(`my`code'_`s'',`pos_last_row',`cola')             in 1 ; 
cap matrix drop `my`code'';

/*
local code = "46b";
subjob`code' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') inf(`inf`s'') elas(`elas`s'') appr(`appr');
tempname  my`code'_`s' ;
matrix `my`code'_`s''= e(est);
local cola = colsof(`my`code'_`s'');
qui replace  `sum_res_S'  =   round(`sum_res_I'[7]+el(`my`code'_`s'',6,`cola'), 0.01) in 7 ;
*/
/*
local code = 46;
if (`suk`code'' != 1) {;
subjob`code' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') inf(`inf`s'') elas(`elas`s'') appr(`appr');
tempname  my`code'_`s' ;
matrix `my`code'_`s''= e(est);
};


local cola = colsof(`my`code'_`s'');
qui replace  `sum_res_S'  =   round(`sum_res_I'[4]+el(`my`code'_`s'',6,`cola')/1000000, 0.01) in 4 ; 
cap matrix drop `my`code'_`s'';
*/

local code = 47;
if (`suk`code'' != 1) {;
subjob`code' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') pline(`pline') wappr(`wappr');
tempname  my`code'_`s' ;
matrix `my`code'_`s''= e(est);
};
local rola = rowsof(`my`code'_`s'');
qui replace  `sum_res_I'  = el(`my`code'_`s'',1,1) in 2 ; 
qui replace  `sum_res_S'  = el(`my`code'_`s'',`rola',1) in 2 ; 

cap matrix drop `my`code'_`s'';

local code = 49;
if (`suk`code'' != 1) {;
subjob`code' `vlist',   hs(`hsize') hgroup(`hgroup') lan(`lan')  xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') wappr(`wappr');
tempname  my`code'_`s' ;
matrix `my`code'_`s''= e(est);
};
local rola = rowsof(`my`code'_`s'');
qui replace  `sum_res_I'  = el(`my`code'_`s'',1,1) in 3 ; 
qui replace  `sum_res_S'  = el(`my`code'_`s'',`rola',1) in 3 ;
cap matrix drop `my`code'_`s'';

/*
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 100;

subjobgr9  `vlist' ,   hs(`hsize')   pline(`pline') lan(`lan')  gtarg(`gtarg') xrnames(`slist')  aggr(`taggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') wappr(`wappr')  min(`min`gjob`i''') max(`max`gjob`i''') ogr(`ogr`gjob`i''') typetr(`typetr') nscen(`nscen') scen(`s') dgra(0) ;
qui replace  `sum_res_I'  = 0                 in 5 ; 
qui replace  `sum_res_S'  = r(ttrans)/1000000 in 5 ; 

qui replace  `sum_res_I'  =  `sum_res_I'[4]+`sum_res_I'[5]     in 6 ; 
qui replace  `sum_res_S'  =  `sum_res_S'[4]+`sum_res_S'[5]     in 6 ; 

qui replace  `sum_res_I'  = 0        in 9 ; 
qui replace  `sum_res_S'  = r(trans) in 9 ; 

qui replace  `sum_res_I'  = 0         in 8 ; 
qui replace  `sum_res_S'  = r(ctrans) in 8 ; 
*/


qui replace  `Delta_sum_res'  = `sum_res_S' - `sum_res_I' ;
cap matrix drop `sumat';
tempname sumat;
local tabtit "Main results `scena'";

cap drop `cocnam';
local cocnam ="";
/* forvalues j = 1/9 {; */
forvalues j = 1/3 {;
local tmp = `component'[`j'] ;
local cocnam `"`cocnam' " `tmp'""';
};

/* mkmat  `sum_res_I' `sum_res_S' `Delta_sum_res' in 1/9, matrix(`sumat'); */
mkmat  `sum_res_I' `sum_res_S' `Delta_sum_res' in 1/3, matrix(`sumat');
matrix rownames `sumat' = `cocnam' ; 
matrix colnames `sumat' = "Pre-Ref" "Post-Ref" "Change" ;
if "`lan'" == "en" local nota  "Note (*): The transfer refers to the required amount to offest the change in headcount poverty.";
if "`lan'" == "fr" local nota  "Note (*): Le transfert se réfère au montant requis pour éliminer le changement dans l'indice de pauvreté.";

mk_xtab_m2 `exp_pc' ,  matn(`sumat') dec(3) xfil(`xfil') xshe(table_Summary_S`s') xtit(`tabtit') xlan(`lan') dste(-1) note(`nota');



 local dec = 3;
 tempname table;
        .`table'  = ._tab.new, col(4);
        .`table'.width |35| 16 16 16 |;
        .`table'.strcolor . . yellow yellow;
        .`table'.numcolor yellow yellow . . ;
        .`table'.numfmt %16.0g  %16.`dec'f  %16.`dec'f %16.`dec'f;
		
        di _n as text "{col 4} Main results `scena'";
     
        .`table'.sep, top;
        .`table'.titles "Component  " "Pre-Ref"  "Post-Ref"  "Change";
        .`table'.sep, mid;
		/*
		forvalues k=1/9{;
		*/
        forvalues k=1/3{;
		        if `k'==1 .`table'.row "WELFARE :"  "" "" "";
			    if `k'==4 .`table'.row "BUDGET  :" "" "" "";
				if `k'==7 .`table'.row "TRANSFER:" "" "" "";
              .`table'.numcolor white yellow yellow yellow  ;
              .`table'.row `component'[`k'] `sum_res_I'[`k']  `sum_res_S'[`k'] `Delta_sum_res'[`k'] ;
                };
              .`table'.sep, bot;
			  di as text "{col 3} Note (*): The transfer refers to the required amount to offest the change in headcount poverty. ";	 
};

}; // end summary 

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

subjobgr`gjob`i'' `vlist',   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`exp_pc') ogr(`ogr`gjob`i''') min(`min`gjob`i''') max(`max`gjob`i''')   ;

 qui graph save           "`mygrdir'Fig_`gjob`i''.gph" , replace ;
 qui graph export         "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
 qui cap graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;



};

if (`gjob`i'' == 2 ) {;
*set trace on;
set more off;
set tracedepth 1;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 1;
subjobgr`gjob`i'' `vlist',   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`exp_pc') ogr(`ogr`gjob`i''') ipsch(`ipsch')  min(`min`gjob`i''') max(`max`gjob`i''')  ;;
qui graph save       "`mygrdir'Fig_`gjob`i''.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;
};

if (`gjob`i'' == 3 ) {;
*set trace on;
subjobgr`gjob`i'' `vlist',   hs(`hsize') lan(`lan')  xrnames(`slist')  aggr(`gaggregate') pcexp(`exp_pc') ogr(`ogr`gjob`i''')  min(`min`gjob`i''') max(`max`gjob`i''')  ;
qui graph save       "`mygrdir'Fig_`gjob`i''.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;

};


if (`gjob`i'' == 4 ) {;
*set trace on;
set tracedepth 2;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 100;
subjobgr`gjob`i''    `vnitems' , hs(`hsize')   vipsch(`ipsch')  pcexp(`exp_pc') pline(`pline') aggr(`gaggregate') xrnames(`slist') lan(`lan') ogr(`ogr`gjob`i''') min(`min`gjob`i''') max(`max`gjob`i''')  ;
qui graph save       "`mygrdir'Fig_`gjob`i''.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''.pdf"  ,  as(pdf) replace ;

};


forvalues s=1/`nscen' {;
if (`gjob`i'' == 5 ) {;
*set trace on;
set tracedepth 3;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 100;

subjobgr`gjob`i''  `vnitems' , hs(`hsize')   vipsch(`ipsch')  pcexp(`exp_pc')  aggr(`gaggregate') xrnames(`slist') lan(`lan')  min(`min`gjob`i''') max(`max`gjob`i''') ogr(`ogr`gjob`i''') inf(`inf`s'') ielas(`elas`s'') nscen(`nscen') scen(`s') ;
qui graph save       "`mygrdir'Fig_`gjob`i''_S`s'.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.pdf"  ,  as(pdf) replace ;

};


if (`gjob`i'' == 6 ) {;

if "`min`gjob`i'''"=="" local min`gjob`i'' = -1;
if "`max`gjob`i'''"=="" local max`gjob`i'' =  0;

subjobgr`gjob`i''  `vnitems' , hs(`hsize')   vipsch(`ipsch') vfpsch(`fpsch`s'') pcexp(`exp_pc')  aggr(`gaggregate') xrnames(`slist') lan(`lan')  min(`min`gjob`i''') max(`max`gjob`i''') ogr(`ogr`gjob`i''') inf(`inf`s'') nscen(`nscen') scen(`s') ;
qui graph save       "`mygrdir'Fig_`gjob`i''_S`s'.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.pdf"  ,  as(pdf) replace ;

};

if (`gjob`i'' == 7 ) {;
*set trace on;
set tracedepth 3;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 100;

subjobgr`gjob`i''  `vnitems' , hs(`hsize')   vipsch(`ipsch')  pcexp(`exp_pc')  aggr(`gaggregate') xrnames(`slist') lan(`lan')  min(`min`gjob`i''') max(`max`gjob`i''') ogr(`ogr`gjob`i''') inf(`inf`s'') ielas(`elas`s'') nscen(`nscen') scen(`s') ;
qui graph save       "`mygrdir'Fig_`gjob`i''_S`s'.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.wmf"  , replace ;
cap  qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.pdf"  ,  as(pdf) replace ;

};



if (`gjob`i'' == 8 ) {;
*set trace on;
set tracedepth 3;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 100;

subjobgr`gjob`i''  `vlist' ,   hs(`hsize')   hgroup(`hgroup') lan(`lan') gtarg(`gtarg') xrnames(`slist')  aggr(`gaggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') wappr(`wappr')  min(`min`gjob`i''') max(`max`gjob`i''') ogr(`ogr`gjob`i''') typetr(`typetr') nscen(`nscen') scen(`s')  ;
															
qui graph save       "`mygrdir'Fig_`gjob`i''_S`s'.gph" , replace ;
qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.wmf"  , replace ;
cap  qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.pdf"  ,  as(pdf) replace ;

};

if (`gjob`i'' == 9 ) {;
*set trace on;
set tracedepth 3;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 100;

subjobgr`gjob`i''  `vlist' ,   hs(`hsize')   pline(`pline') lan(`lan')  gtarg(`gtarg') xrnames(`slist')  aggr(`gaggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'') wappr(`wappr')  min(`min`gjob`i''') max(`max`gjob`i''') ogr(`ogr`gjob`i''') typetr(`typetr') nscen(`nscen') scen(`s') ;

qui graph save           "`mygrdir'Fig_`gjob`i''_S`s'.gph" , replace ;
qui graph export         "`mygrdir'Fig_`gjob`i''_S`s'.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.pdf"  ,  as(pdf) replace ;

};

if (`gjob`i'' == 10 ) {;
*set trace on;
set tracedepth 3;
if "`min`gjob`i'''"=="" local min`gjob`i'' = 0;
if "`max`gjob`i'''"=="" local max`gjob`i'' = 100;

subjobgr`gjob`i''  `vlist' ,   hs(`hsize')  lan(`lan')  gtarg(`gtarg') xrnames(`slist')  aggr(`gaggregate') pcexp(`exp_pc') ipsch(`ipsch') fpsch(`fpsch`s'')  inf(`inf`s'') elas(`elas`s'') appr(`appr') min(`min`gjob`i''') max(`max`gjob`i''') ogr(`ogr`gjob`i''') typetr(`typetr') nscen(`nscen') scen(`s')  ;

qui graph save           "`mygrdir'Fig_`gjob`i''_S`s'.gph" , replace ;
qui graph export         "`mygrdir'Fig_`gjob`i''_S`s'.wmf"  , replace ;
cap qui graph export     "`mygrdir'Fig_`gjob`i''_S`s'.pdf"  ,  as(pdf) replace ;

};



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
cap drop __IPSCH  ; 
cap drop __ELAS1   ; 
cap drop __FPSCH1  ; 
cap drop __imp_well ;
cap drop __imp_rev ;
cap drop __imrsub ;

end;

