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



/*
capture program drop wfpsdb;
program define wfpsdb;
version 9.2;
syntax anything  [ ,  INISave(string) NAMEPS(string) ITEM(string) PER(string) mxb(varname) tr(varname) sub(varname) ];
  
  tokenize `inisave' ,  parse(".");
tokenize "`inisave'" ,  parse(".");
local inisave = "`1'";
   cap file close myfile;
   tempfile  myfile;
   /*cap erase "`inisave'.itp" ;*/
   file open myfile   using "`inisave'.itp", write replace ;
   tokenize `namelist';	
   
   	file write myfile `" if ("$"';
	file write myfile `"prg_pointer"== "ps_`per'_`item'") "';
	file write myfile `" & ("$"';
	file write myfile `"r_`per'_`item'=1)"';
	file write myfile "{" _n;
   file write myfile `".pschset_`per'_`item'_dlg.main.cb_ini.setvalue    `.pschset_`per'_`item'_dlg.main.cb_ini.value'"'          _n;
   file write myfile `".pschset_`per'_`item'_dlg.main.cb_bracs.setvalue  `.pschset_`per'_`item'_dlg.main.cb_bracs.value'"'        _n;
   file write myfile `".pschset_`per'_`item'_dlg.main.ed_bracs.setvalue  `.pschset_`per'_`item'_dlg.main.ed_bracs.value'"'        _n;
   file write myfile `".pschset_`per'_`item'_dlg.main.cb_bun.setvalue    `.pschset_`per'_`item'_dlg.main.cb_bun.value'"'           _n;
   
   if "`.pschset_`per'_`item'_dlg.main.cb_bracs.value'"!=""  local nblock1 =  `.pschset_`per'_`item'_dlg.main.cb_bracs.value' ;
   if "`.pschset_`per'_`item'_dlg.main.ed_bracs.value'"!=""  local nblock2 =  `.pschset_`per'_`item'_dlg.main.ed_bracs.value' ;
   if "`.pschset_`per'_`item'_dlg.main.cb_ini.value'" == "1" local nblk = `nblock1' ;
   if "`.pschset_`per'_`item'_dlg.main.cb_ini.value'" == "2" local nblk = `nblock2' ;
   
 forvalues i=1/`nblk' {;
 file write myfile `".pschset_`per'_`item'_dlg.main.en_mxb`i'.setvalue    "`.pschset_`per'_`item'_dlg.main.en_mxb`i'.value'""'  _n;  
 file write myfile `".pschset_`per'_`item'_dlg.main.en_tarif`i'.setvalue  "`.pschset_`per'_`item'_dlg.main.en_tarif`i'.value'""'  _n; 
 file write myfile `".pschset_`per'_`item'_dlg.main.en_sub`i'.setvalue    "`.pschset_`per'_`item'_dlg.main.en_sub`i'.value'""'  _n; 
  };
  
 file write myfile `".pschset_`per'_`item'_dlg.main.var_mxb.setvalue     "`.pschset_`per'_`item'_dlg.main.var_mxb.value'""'  _n; 
 file write myfile `".pschset_`per'_`item'_dlg.main.var_tr.setvalue      "`.pschset_`per'_`item'_dlg.main.var_tr.value'""'   _n; 
 file write myfile `".pschset_`per'_`item'_dlg.main.var_sub.setvalue     "`.pschset_`per'_`item'_dlg.main.var_sub.value'""'  _n; 
file write myfile "}" _n;
 file close myfile;
end;


*/


capture program drop aitdbsave;
program define aitdbsave, rclass sortpreserve;
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
/*
TYPETR(int 1)
GTARG(varname)
*/
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


tokenize "`inisave'" ,  parse(".");
local inisave = "`1'";
    

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
   tokenize `varlist';
   cap file close myfile;
   tempfile  myfile;
   cap erase "`inisave'.itp" ;
   file open myfile   using "`inisave'.itp", write replace ;
    
	file write myfile `" if ("$"';
	file write myfile `"prg_pointer"== "main") "';
	file write myfile "{" _n;
   file write myfile `".aitsim_dlg.main.vn_pcexp.setvalue "`1'""' _n;
   file write myfile `".aitsim_dlg.main.vn_hhid.setvalue "`hhid'""' _n;
   file write myfile `".aitsim_dlg.main.vn_hhs.setvalue "`hsize'""' _n;
   file write myfile `".aitsim_dlg.main.vn_inc.setvalue "`income'""' _n;
   file write myfile `".aitsim_dlg.main.cb_inc.setvalue "`tyinc'""' _n;
   file write myfile `".aitsim_dlg.main.vn_pl1.setvalue "`pline'""' _n;

   
   if ("`inisave'"~="")  file write myfile `".aitsim_dlg.main.dbsamex.setvalue "`inisave'""' _n;
   if ("`cname'"~="")    file write myfile `".aitsim_dlg.main.ed_cname.setvalue "`cname'""' _n;
   if ("`ysvy'"~="")     file write myfile `".aitsim_dlg.main.ed_ysvy.setvalue "`ysvy'""' _n;
   if ("`ysim'"~="")     file write myfile `".aitsim_dlg.main.ed_ysim.setvalue "`ysim'""' _n;
   if ("`lcur'"~="")     file write myfile `".aitsim_dlg.main.ed_lcur.setvalue "`lcur'""' _n;
 

   
   file write myfile `".aitsim_dlg.main.vn_hhg.setvalue "`hgroup'""' _n;
   

   
   
   if ("`tjobs'"~="") {;
   file write myfile `".aitsim_dlg.tb_options_t.ck_tables.seton"' _n;
   file write myfile `".aitsim_dlg.tb_options_t.ed_tab.setvalue "`tjobs'""' _n;
   };
   
   if (`summary'==1)  file write myfile `".aitsim_dlg.tb_options_t.chk_sum.seton"' _n;
   if ("`gjobs'"~="") {;
   file write myfile `".aitsim_dlg.gr_options_t.ck_graphs.seton"' _n;
   file write myfile `".aitsim_dlg.gr_options_t.ed_gra.setvalue "`gjobs'""' _n;
   };
   
   if ("`xfil'"~="") {;
   file write myfile `".aitsim_dlg.tb_options_t.ck_excel.seton"' _n;
   file write myfile `".aitsim_dlg.tb_options_t.fnamex.setvalue "`xfil'""' _n;
   };
   
   if ("`lan'" == "fr") file write myfile `".aitsim_dlg.tb_options_t.cb_lan.setvalue fr "' _n;
   forvalues i=1/10 {;
   if ("`min`i''"~="")  file write myfile `".aitsim_dlg.gr_options_t.en_min`i'.setvalue "`min`i''""' _n;
   if ("`max`i''"~="")  file write myfile `".aitsim_dlg.gr_options_t.en_max`i'.setvalue "`max`i''""' _n;
   if ("`ogr`i''"~="")  file write myfile `".aitsim_dlg.gr_options_t.en_opt`i'.setvalue `"`ogr`i''"' "' _n;
   };
   
  /* file write myfile `".aitsim_dlg.main.en_inf1.setvalue "`inf1'""' _n; */
   file close myfile;  
   
  
  
  
  
  
 
   cap file close myfile;
   tempfile  myfile;
   file open myfile   using "`inisave'.itp", write append;


local it = "`itsch'" ;
local tcmd  itschset `it' , ;
local n  =  `.`it'.nrange'; 
local bun  =  `.`it'.bun'; 
local str  =  `.`it'.str'; 
local tcmd `tcmd' nrange(`n') bun(`bun')  str(`str') ;
local n1=`n'-1;
forvalues j = 1/`n1' {;
local tcmd `tcmd' mxb`j'(`.`it'.ran[`j'].max')   tax`j'(`.`it'.ran[`j'].tax') ;
};
local tcmd `tcmd'   tax`n'(`.`it'.ran[`n'].tax') ;
file write myfile `"`tcmd'"'  _n;

forvalues s=1/`nscen' {;
local ft = "`ftsch`s''" ;
local tcmd  itschset `ft' , ;
local n    =  `.`ft'.nrange'; 
local bun  =  `.`ft'.bun'; 
local str  =  `.`ft'.str'; 
local tcmd `tcmd' nrange(`n') bun(`bun') str(`str') ;
local n1=`n'-1;
forvalues j = 1/`n1' {;
local tcmd `tcmd' mxb`j'(`.`ft'.ran[`j'].max')  tax`j'(`.`ft'.ran[`j'].tax') ;
};

local tcmd `tcmd'  tax`n'(`.`ft'.ran[`n'].tax') ;
file write myfile `"`tcmd'"'  _n;

};




 /*
 file write myfile `".aitsim_dlg.main.cb_ini.setvalue `oinf'""' _n;
 file write myfile `".aitsim_dlg.main.var_sn.setvalue "`snames'""' _n;
 file write myfile `".aitsim_dlg.main.var_item.setvalue "`itnames'""' _n;
 file write myfile `".aitsim_dlg.main.var_ip.setvalue "`itsch'""' _n;
 */
 file write myfile `".aitsim_dlg.main.cb_nscen.setvalue  `nscen'"'  _n;

 file write myfile `".aitsim_dlg.main.ed_itsch.setvalue "`itsch'""' _n;
 forvalues s = 1/`nscen' {;
  file write myfile `".aitsim_dlg.main.ed_ftsch`s'.setvalue "`ftsch`s''""' _n;
  file write myfile `".aitsim_dlg.main.var_elas`s'.setvalue "`elas`s''""' _n;
  /* file write myfile `".aitsim_dlg.main.vn_elas`s'.setvalue "`elas`s''""' _n; */
 };

 local nfile = "$S_FN" ;
 file write myfile "}" _n;
 /* file write myfile `"cap use `nfile' , replace"'  _n; */
 file close myfile;






end;

