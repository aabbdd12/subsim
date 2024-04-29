/*************************************************************************/
/* TAXSIM: TAX Simulation Stata Toolkit  (Version 1.0)               */
/*************************************************************************/
/* Conceived by Dr. Araar Abdelkrim[1] and Dr. Paolo Verme[2]            */
/* World Bank Group (2012-2014)		                                     */
/* 									 									 */
/* [1] email : aabd@ecn.ulaval.ca                                        */
/* [1] Phone : 1 418 656 7507                                            */
/*																		 */
/* [2] email : pverme@worldbank.org                                      */
/*************************************************************************/



cap program drop ataxini_act
program ataxini_act
	version 10
    args dof
  tokenize `dof' ,  parse(".")
   local dof = "`1'"
	global ini_taxa `dof'
	discard
    db actsim

end


