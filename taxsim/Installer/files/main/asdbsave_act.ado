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



capture program drop asdbsave_act;
program define asdbsave_act, rclass sortpreserve;
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
/* appr(int 1)  */
wappr(int 1)
INISave(string) 
TJOBS(string) 
SUMMARY(string)
GJOBS(string) 

CNAME(string)
YSVY(string)
YSIM(string)
LCUR(string)
TYPETR(int 1)
GTARG(varname)
FOLGR(string)
GVIMP(int 0) 

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

local mylist secp pr;

   tokenize `varlist';
   cap file close myfile;
   tempfile  myfile;
   cap erase "`inisave'.act" ;
   file open myfile   using "`inisave'.act", write replace ;
   file write myfile `".actsim_dlg.main.vn_pcexp.setvalue "`1'""' _n;
   file write myfile `".actsim_dlg.main.vn_hhs.setvalue "`hsize'""' _n;
   file write myfile `".actsim_dlg.main.vn_pl1.setvalue "`pline'""' _n;
   file write myfile `".actsim_dlg.main.cb_wmet.setvalue "`wappr'""' _n; 
   file write myfile `".actsim_dlg.main.cb_ioap_ad.setvalue `adshock'""' _n; 
   
   if ("`inisave'"~="")  file write myfile `".actsim_dlg.main.dbsamex.setvalue "`inisave'""' _n;
   if ("`cname'"~="")    file write myfile `".actsim_dlg.main.ed_cname.setvalue "`cname'""' _n;
   if ("`ysvy'"~="")     file write myfile `".actsim_dlg.main.ed_ysvy.setvalue "`ysvy'""' _n;
   if ("`ysim'"~="")     file write myfile `".actsim_dlg.main.ed_ysim.setvalue "`ysim'""' _n;
   if ("`lcur'"~="")     file write myfile `".actsim_dlg.main.ed_lcur.setvalue "`lcur'""' _n;
   if ("`typetr'"~="")   file write myfile `".actsim_dlg.main.cb_tr.setvalue "`typetr'""' _n;
   if ("`gtarg'"~="")  {;
                         file write myfile `".actsim_dlg.main.cb_trg.setvalue "gr""' _n;
						 file write myfile `".actsim_dlg.main.var_trg.setvalue "`gtarg'""' _n;
					   };
	/* if (`gvimp'==1)     file write myfile `".actsim_dlg.main.chk_gvimp.settrue "' _n; : find how to set the value of checkbox latter */
   
   if ("`folgr'"~="")  {;
   file write myfile `".actsim_dlg.gr_options.ck_folgr.seton"' _n;
   file write myfile `".actsim_dlg.gr_options.ed_folgr.setvalue "`folgr'""' _n;
   };
   
   file write myfile `".actsim_dlg.main.vn_hhg.setvalue "`hgroup'""' _n;
   
   if ("`taggregate'"~="") {;
   file write myfile `".actsim_dlg.tb_options.ck_order.seton"' _n;
   file write myfile `".actsim_dlg.tb_options.ed_aggr.setvalue "`taggregate'""' _n;
   };
   
    if ("`gaggregate'"~="") {;
   file write myfile `".actsim_dlg.gr_options.gck_order.seton"' _n;
   file write myfile `".actsim_dlg.gr_options.ged_aggr.setvalue "`gaggregate'""' _n;
   };
   
   if ("`tjobs'"~="") {;
   file write myfile `".actsim_dlg.tb_options.ck_tables.seton"' _n;
   file write myfile `".actsim_dlg.tb_options.ed_tab.setvalue "`tjobs'""' _n;
   };
   
   if ("`gjobs'"~="") {;
   file write myfile `".actsim_dlg.gr_options.ck_graphs.seton"' _n;
   file write myfile `".actsim_dlg.gr_options.ed_gra.setvalue "`gjobs'""' _n;
   };
   
   if ("`xfil'"~="") {;
   file write myfile `".actsim_dlg.tb_options.ck_excel.seton"' _n;
   file write myfile `".actsim_dlg.tb_options.fnamex.setvalue "`xfil'""' _n;
   };
   if ("`lan'" == "fr") file write myfile `".actsim_dlg.tb_options.cb_lan.setvalue fr "' _n;
   
   forvalues i=1/10 {;
   if ("`min`i''"~="")  file write myfile `".actsim_dlg.gr_options.en_min`i'.setvalue "`min`i''""' _n;
   if ("`max`i''"~="")  file write myfile `".actsim_dlg.gr_options.en_max`i'.setvalue "`max`i''""' _n;
   if ("`ogr`i''"~="")  file write myfile `".actsim_dlg.gr_options.en_opt`i'.setvalue `"`ogr`i''"' "' _n;
   };
   
   file close myfile;  
   
  
  
  

  
  
if (`oinf'==1) {;
local mylist sn it el ms;
forvalues i=1/`nitems' {;
extend_opt_item test , `it`i'' ;
foreach name of local mylist {;
local `name'`i'  `r(`name')';
if  "``name'`i''"=="." local `name'`i' = "" ;
};
};

forvalues i=1/`nitems' {;
if "`sn`i''"==""      local sn`i' = "" ;
if "`el`i''"==""      local el`i' = 0 ;
if ("`it`i''" == "" ) local it`i' = "`it`i''" ;
if ("`ms`i''" == "" ) local ms`i' = "`ms`i''" ;
};


 
   cap file close myfile;
   tempfile  myfile;
   
   file open myfile   using "`inisave'.act", write append;
 
		forvalues i=1/`nitems' {;
		file write myfile `".actsim_dlg.items_info_act.en_sn`i'.setvalue  "`sn`i''""'  _n;  
		file write myfile `".actsim_dlg.items_info_act.vn_item`i'.setvalue  "`it`i''""'  _n;   
		file write myfile `".actsim_dlg.items_info_act.en_elas`i'.setvalue  "`el`i''""'  _n; 
	    file write myfile `".actsim_dlg.items_info_act.en_ms`i'.setvalue  "`ms`i''""'  _n; 
		};
		


local nfile = "$S_FN" ;
/* file write myfile `"cap use `nfile' , replace"'  _n; */
file close myfile;
};

   cap file close myfile;
   tempfile  myfile;
   file open myfile   using "`inisave'.act", write append;
 file write myfile `".actsim_dlg.items_info_act.cb_items.setvalue  `nitems'"'  _n;
 file write myfile `".actsim_dlg.items_info_act.ed_items.setvalue  `nitems'"'  _n;
 file write myfile `".actsim_dlg.items_info_act.cb_ini.setvalue `oinf'""' _n;  
 file write myfile `".actsim_dlg.main.cb_ioap_ad.setvalue `adshock'""' _n;  
 file write myfile `".actsim_dlg.items_info_act.var_sn.setvalue "`snames'""' _n;
 file write myfile `".actsim_dlg.items_info_act.var_ms.setvalue "`match'""' _n;
 file write myfile `".actsim_dlg.items_info_act.var_item.setvalue "`itnames'""' _n;

 

    file write myfile `".actsim_dlg.items_info_act.var_elas1.setvalue "`elas1'""' _n;
 
   if ("`iomatrix'"~="")       file write myfile `".actsim_dlg.items_info_act.dbiom.setvalue "`iomatrix'""' _n;
   if ("`match'"~="")          file write myfile `".actsim_dlg.items_info_act.var_ms.setvalue "`match'""' _n;



 local nfile = "$S_FN" ;
 /* file write myfile `"cap use `nfile' , replace"'  _n; */
 file close myfile;







end;

