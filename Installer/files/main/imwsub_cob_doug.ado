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
capture program drop imwsub_cob_doug;
program define imwsub_cob_doug, sortpreserve rclass;
version 9.2;
syntax varlist(min=1 max=1)[ ,   IPSCH(string) FPSCH(string) HSIZE(varname)  PCEXP(varname) NETINC(varname)];
/* Welfare impact with Cobb-Douglas preferences (equivalent variation):
   (y - F2)(p1/p2)^s - (y - F1), the fees F a lump sum paid by those who buy
   the good, p1 and p2 the average prices of the same spending on the tariffs,
   s the share of that spending in income net of the initial fees (netinc():
   net of the fees of all the items; default: of this item).
   __tdef = (p2/p1)^s, __cdfee = F2 - F1 (per person). */
tokenize `varlist';
tempvar hs f1 f2 q0 q1 eadj ny ishare;
if "`hsize'"=="" qui gen `hs' = 1;
else             qui gen `hs' = `hsize';
local bun   = `.`ipsch'.bun';
local sfee1 = `.`ipsch'.sfee';
local sfee2 = `.`fpsch'.sfee';
qui gen `f1' = 0;
qui gen `f2' = 0;
if `bun'==1 {;
qui replace `f1' = `sfee1'/`hs' if `1'>0 & `1'<. ;
qui replace `f2' = `sfee2'/`hs' if `1'>0 & `1'<. ;
};
if `bun'==2 {;
qui replace `f1' = `sfee1' if `1'>0 & `1'<. ;
qui replace `f2' = `sfee2' if `1'>0 & `1'<. ;
};

imq0sub `1' , ipsch(`ipsch') hsize(`hs');
qui gen `q0' = __imq0sub;
qui cap drop __imq0sub;
/* what the same spending on the tariffs buys at the final ones */
qui gen `eadj' = `1' - `f1' + `f2';
imq0sub `eadj' , ipsch(`fpsch') hsize(`hs');
qui gen `q1' = __imq0sub;
qui cap drop __imq0sub;

if "`netinc'"=="" qui gen `ny' = `pcexp' - `f1';
else              qui gen `ny' = `netinc';
qui gen `ishare' = max(0, (`1' - `f1')/`ny');
qui cap drop __tdef;
qui gen  __tdef = (`q0'/`q1')^`ishare';
qui replace __tdef = 1 if __tdef ==.;
qui cap drop __cdfee;
qui gen  __cdfee = `f2' - `f1';
qui cap drop __imwsub ;
qui gen __imwsub = (`ny' - __cdfee)/__tdef - `ny' ;
end;
