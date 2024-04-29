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
capture program drop extend_opt_item;
program define extend_opt_item, rclass;
version 9.2;
syntax anything  [ ,  SN(string)  IT(string)    EL(string)  MS(string) ];
local mylist sn it el ms;
foreach name of local mylist {;
local ret ``name'' ;
return local `name' `ret';
};
end;


