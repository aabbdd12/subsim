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

capture program drop it_basicstats;
program define  it_basicstats, rclass;
version 9.2;
syntax varlist  [, HHID(varname) HSize(varname) HGroup(varname)  STAT(string) DENOM(varname) INCOME(varname)];
preserve;

tokenize `varlist';

tempvar _hs;

gen `_hs'=`hsize';

local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 

tempvar _num _denum _fw _w;

if "`stat'" == "" local stat = "exp_tt";
qui gen `_fw'=`_hs';
if (`"`hweight'"'~="") qui replace `_fw'=`_fw'*`hweight';

qui gen `_w'=1;
if (`"`hweight'"'~="") qui replace `_w'=`hweight';




if "`stat'" == "exp_tt" {;
tempvar key ;
qui egen byte `key' = tag(`hhid');

forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk')*`key';
qui sum `1' [aw=`_fwg'];
return scalar est`i' =  r(sum);
};
qui sum  `1'  [aw=`_fw'*`key'] ;
local pe = $indig+1;
return scalar est`pe' =  r(sum);
};

if "`stat'" == "inc_tt" {;
tempvar key ;
qui egen byte `key' = tag(`hhid');

forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk')*`key';
qui sum `1' [aw=`_fwg'];
return scalar est`i' =  r(sum);
};
qui sum  `1'  [aw=`_fw'*`key'] ;
local pe = $indig+1;
return scalar est`pe' =  r(sum);
};



if "`stat'" == "exp_pc" {;
tempvar key ;
qui egen byte `key' = tag(`hhid');

forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk')*`key';
qui sum `1' [aw=`_fwg'];
return scalar est`i' =  r(mean);
};

qui sum  `1'  [aw=`_fw'*`key'] ;
local pe = $indig+1;
return scalar est`pe' =  r(mean);


};



if "`stat'" == "tax_pc" {;

tempvar key tot_tax  pc_tax; 
qui by `hhid', sort : egen float `tot_tax' = total(`1');
qui egen byte `key' = tag(`hhid');
tempvar fw_key;
qui gen `fw_key' = `_fw'*`key' ;
qui gen `pc_tax' = `tot_tax' / `hsize';

forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk')*`key';
qui sum `pc_tax' [aw=`_fwg'];
return scalar est`i' =  r(mean);
};

qui sum  `pc_tax'  [aw=`fw_key'] ;
local pe = $indig+1;
return scalar est`pe' =  r(mean);
};


if "`stat'" == "inc_pc" {;

tempvar key tot_inc  pc_inc; 
qui by `hhid', sort : egen float `tot_inc' = total(`1');
qui egen byte `key' = tag(`hhid');
tempvar fw_key;
qui gen `fw_key' = `_fw'*`key' ;
qui gen `pc_inc' = `tot_inc' / `hsize';

forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk')*`key';
qui sum `pc_inc' [aw=`_fwg'];
return scalar est`i' =  r(mean);
};

qui sum  `pc_inc'  [aw=`fw_key'] ;
local pe = $indig+1;
return scalar est`pe' =  r(mean);


};



if "`stat'" == "flat_tax" {;

tempvar key tot_inc pc_inc; 
qui by `hhid', sort : egen float `tot_inc' = total(`income');
qui gen `pc_inc' = `tot_inc' / `hsize';


tempvar key tot_tax  pc_tax; 
qui by `hhid', sort : egen float `tot_tax' = total(`1');
qui gen `pc_tax' = `tot_tax' / `hsize';

qui egen byte `key' = tag(`hhid');
tempvar fw_key;
qui gen `fw_key' = `_fw'*`key' ;


forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk')*`key';

qui sum `pc_tax' [aw=`_fwg'];
local  est1 =  r(mean);

qui sum `pc_inc' [aw=`_fwg'];
local  est2 =  r(mean);



return scalar est`i' =  `est1'/`est2'*100;
};

qui sum  `pc_tax'  [aw=`_fw'] ;
local est1 =  r(mean);

qui sum  `pc_inc'  [aw=`fw_key'] ;
local est2 =  r(mean);

local pe = $indig+1;

return scalar est`pe' =  `est1'/`est2'*100;


};


if "`stat'" == "exp_hh" {;
tempvar var;
qui gen `var' = `1'*`_hs';
tempvar key ; 
qui egen byte `key' = tag(`hhid');
tempvar fw_key;
qui gen `fw_key' = `_fw'*`key' ;

forvalues i=1/$indig {;
local kk = gn1[`i'];
tempvar _wg;
qui gen `_wg'=`_w'*(`hgroup'==`kk')*`key';
qui sum `var' [aw=`_wg'];
return scalar est`i' =  r(mean);
};

qui sum  `var'  [aw=`_w'*`key'] ;
local pe = $indig+1;
return scalar est`pe' =  r(mean);
};


/*
if "`stat'" == "share_tot_pro" | "`stat'" == "share_tot_exp" {;


forvalues i=1/$indig {;
tempvar _fwg;
local kk = gn1[`i'];
qui gen `_fwg'=`_fw'*(`hgroup'==`kk');
qui sum `1'     [aw=`_fwg'];  local st1= r(sum);
qui sum `denom' [aw=`_fwg' ]; local st2= r(sum);
return scalar est`i' =  `st1' / `st2' *100;
local pe = $indig+1;
qui sum `1'     [aw=`_fw'];  local st1= r(sum);
qui sum `denom' [aw=`_fw' ]; local st2= r(sum);
return scalar est`pe' =  `st1' / `st2' *100;
};
};
*/


restore;

end;
