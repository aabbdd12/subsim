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



cap program drop ataxini2_act
program ataxini2_act
	version 10
	local inis $ini_taxa
	global prg_pointer = "main"
	if "`inis'"~="" {
	cap do "`inis'.act"
	}
	cap macro drop ini_taxa
	global tempprj `inis'
end
