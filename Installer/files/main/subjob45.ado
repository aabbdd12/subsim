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


#delimit;
capture program drop subjob45;
program define subjob45, eclass;
version 9.2;
syntax varlist(min=1)[, HSize(varname) HGroup(varname) LAN(string) XRNAMES(string)  AGGRegate(string) PCEXP(varname) IPSCH(varname)  FPSCH(varname) elas(varname) wappr(int 1) UNIT(varname) GVQNT( int 0)];

tokenize `varlist';
_nargs    `varlist';

forvalues i=1/$indica {;
tempvar Variable EST`i';
qui gen `EST`i''=0;
local tipsch = ""+`ipsch'[`i'];
local tfpsch = ""+`fpsch'[`i'];
local telas   = `elas'[`i'];
imq0sub ``i'' , ipsch(`tipsch') hsize(`hsize');
tempvar imq0sub_``i'' ;
if (`wappr'==1)  imqsub ``i''          , ipsch(`tipsch') fpsch(`tfpsch') hsize(`hsize') elas(`telas');
if (`wappr'==2)  imqsub_cob_doug ``i'' , ipsch(`tipsch') fpsch(`tfpsch') hsize(`hsize') ;
tempvar imqsub_``i'' ;
qui gen  `imqsub_``i''' = __imqsub;
local nlist `nlist' `imqsub_``i''' ;

if (`gvqnt'==1) {;
cap drop _qnt_1_``i'' ;
qui gen  _qnt_1_``i''  =_qnt_0_``i''+ __imqsub ;
if "`unit'[`i']"~="" local qtem = "( in "+`unit'[`i']+")";
lab var _qnt_1_``i''  "Per capita final quantity of ``i'' `qtem'";
};

cap drop __imqsub;
};
 
aggrvar `nlist' , xrnames(`xrnames') aggregate(`aggregate');

local slist = r(slist);
local flist = r(flist);
local drlist = r(drlist);
subjobstat `flist',   hs(`hsize') hgroup(`hgroup') lan(`lan')   xrnames(`slist')  stat(exp_pc) unit(`unit');
cap drop `drlist';
tempname mat45 ;
matrix `mat45'= e(est);
local rowsize = rowsof(`mat45');
local colsize = colsof(`mat45') - 1 ;
matrix `mat45' = `mat45'[1..`rowsize', 1..`colsize'];
ereturn matrix est = `mat45';

end;



