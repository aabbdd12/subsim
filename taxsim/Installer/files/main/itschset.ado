*! version 1.00  15-December-2015   M. Araar Abdelkrim & M. Paolo verme
/*************************************************************************/
/* SUBSIM: TAX Simulation Stata Toolkit  (Version 1.0)               */
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
capture program drop itchsetv ;
program define itchsetv , rclass;
version 9.2;
syntax namelist (min=1 max=1) [,   NRANGE(int 1)  MXB(varname)  TAX(varname)  EXEMPT(real 0) NUMBER(int 1) PER(string) STR(int 1) BUN(int 1)  * ];

tokenize `namelist';
cap classutil drop .`1';	
      
.`1' = .itschedule.new `nrange' `exempt'  `str' `bun';

local min1  = 0;
local max1  = `mxb'[1];

forvalues i=2/`nrange' {;
local j = `i' - 1;
local min`i'  = `mxb'[`j'] ;
local max`i'  = `mxb'[`i'] ;
if `i' == `nrange' local max`i'  = 10000*`mxb'[`j'] ;
};


forvalues i=1/`nrange' {;
cap classutil drop .range`i';
.range`i' = .range.new  `min`i'' `max`i'' `tax'[`i'] ;
.`1'.ran[`i'] = .range`i';
};

if "`mxb'" == ""  local mxb  = "no_thing";
if "`tr'"  == ""  local tax  = "no_thing";
local oinf = 2;
.oin1 = .oinf_it.new  `mxb'  `tax'  `oinf' ;
.`1'.oin[1] = .oin1;
end;


#delimit ;
capture program drop itschset ;
program define itschset , rclass;
version 9.2;
syntax namelist (min=1 max=1) [,   
Nrange(int 1)
STR(int 1)
BUN(int 1)
EXEMPT(real 0)
MXB1(real 100)  MXB2(real 200) MXB3(real 300) MXB4(real 400) MXB5(real 500) 
MXB6(real 600)  MXB7(real 700) MXB8(real 800) MXB9(real 900) MXB10(real 1000)
TAX1(real 1)     TAX2(real 1)  TAX3(real 1)  TAX4(real 1)  TAX5(real 1)  
TAX6(real 1)     TAX7(real 1)  TAX8(real 1)  TAX9(real 1)  TAX10(real 1) 
MXB(varname)  TAX(varname) SUB(varname) OINF(int 1)
ITEM(int 1) PER(string) PRNAME(string)
INISAVE(string)
];


if (`oinf'==1) {;
tokenize `namelist';


cap classutil drop .`1';	
.`1' = .itschedule.new `nrange' `exempt' `str' `bun';


local min1  = 0;
local max1  = `mxb1';

forvalues i=2/`nrange' {;
local j = `i' - 1;
local min`i'  = `mxb`j'' ;
local max`i'  = `mxb`i'' ;
if `i' == `nrange' local max`i'  = 10000*`mxb`j'' ;
};


forvalues i=1/`nrange' {;
cap classutil drop .range`i';
.range`i' = .range.new  `min`i'' `max`i'' `tax`i''  ;
.`1'.ran[`i'] = .range`i';
};

if "`mxb'" == ""  local vmxb = "no_thing";
if "`tax'"  == ""  local vtax  = "no_thing";
if "`sub'" == ""  local vsub = "no_thing";
cap classutil drop .oin1;	
.oin1 = .oinf_it.new  `vmxb'  `vtax' `oinf' ;
.`1'.oin[1] = .oin1;

};
if (`oinf'==2) {;
itschsetv `namelist' , nrange(`nrange') mxb(`mxb') tax(`tax')  oinf(2) exempt(`exempt') str(`str') bun(`bun');
};

capture {;
if ("`item'"~="") {;
if ("`per'"=="i") .itaxsim_dlg.items_info.bu_pr`item'.setlabel "`1'";
if ("`per'"=="f") .itaxsim_dlg.items_info.bu_fr`item'.setlabel "`1'";
};
};



/***********/

/***********/


if ("`inisave'" ~="") {;
   if ("`per'"=="") {;
   cap file close myfile;
   tempfile  myfile;
    tokenize `inisave' ,  parse(".");
    local dof = trim("`1'");
	cap erase  "`dof'.isc" ;
   file open myfile   using "`dof'.isc", write append;
   tokenize `namelist';
   file write myfile `".itschset_dlg.main.dbsamex.setvalue "`inisave'""'   _n;
   file write myfile `".itschset_dlg.main.ed_vname.setvalue  `1'"'            _n;
   file write myfile `".itschset_dlg.main.cb_ini.setvalue  `oinf'"'           _n;
   file write myfile `".itschset_dlg.main.cb_bracs.setvalue  `nrange'"'           _n;
   file write myfile `".itschset_dlg.main.ed_bracs.setvalue  `nrange'"'           _n;
   file write myfile `".itschset_dlg.main.ed_exemp.setvalue  `exempt'"'           _n;
  

   
   
 forvalues i=1/`nrange' {;
  if  "`mxb`i''" ~= "" file write myfile `".itschset_dlg.main.en_mxb`i'.setvalue     "`mxb`i''""'  _n;  
  if  "`tax`i''" ~= "" file write myfile `".itschset_dlg.main.en_tax`i'.setvalue     "`tax`i''""'  _n;  
  };

  if  "`mxb'" ~= ""  file write myfile `".itschset_dlg.main.var_mxb.setvalue   "`mxb'""'  _n; 
  if  "`tax'" ~= ""  file write myfile `".itschset_dlg.main.var_tax.setvalue   "`tax'""'  _n; 
file close myfile;
};

};

end;




