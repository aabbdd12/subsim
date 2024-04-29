*! version 1.00  03-Mayo-2017   M. Araar Abdelkrim & M. Paolo verme
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


#delim ;
capture program drop mk_xtab_m2;
program define mk_xtab_m2, rclass;
version 9.2;
syntax anything [,  matn(string) dste(int 1) dec(int 6) dec1(int 6) dec2(int 6) dec3(int 6) dec4(int 6) dec5(int 6) dec6(int 6)
 xfil(string) xshe(string) xtit(string)  xlan(string) hsep(int 0) topnote(string)  topnote(string) note(string) ];


local ncol = colsof(`matn');
tempname mym ;
if `ncol'  > 13   matrix `mym' = `matn'';
if `ncol' <= 13   matrix `mym' = `matn';

if (`dste' == 1)                  local note1 = "[-] Standard errors are in italics.";
if (`dste' == 1 & "`xlan'"=="fr") local note1 = "[-] Les erreurs types sont en format italique.";
if (`dste' == 1 & "`xlan'"=="fr") local note1 = "[-] Les erreurs types sont en format italique.";


if (`dste' ==  1)    local frm = "SCCB0 N231`dec' N232`dec' ";
if (`dste' !=  1)    local frm = " (N231`dec') (N2312) ";

if (`dste' ==  1)  local lst1 = rowsof(`mym')-2 ;
if (`dste' ==  0)  local lst1 = rowsof(`mym')-1;

local frm = "";
forvalues i=1/6 {;
if ("`dec`i''"~="") local frm = "`frm'"+" N231`dec`i'' "; 
if ("`dec`i''"=="") local frm = "`frm'"+" N231`dec' "; 
};


local lst1 `lst1' 2 ;

if (`dste' == -1)  {;
 local lst1 = "";
 };



xml_taba2 

`mym',
title("`xtit'")  
lines(COL_NAMES 14 `lst1' LAST_ROW 13)  
topnote(`topnote')
notes( "`note1'" ,  "`note'")
font("Courier New" 8)
format((S2111) `frm') 
 newappend save(`xfil') sheet(`xshe')


;
end;

