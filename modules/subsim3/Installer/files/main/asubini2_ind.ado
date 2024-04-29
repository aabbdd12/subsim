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



cap program drop asubini2_ind
program asubini2_ind
	version 10
	local inis $ini_suba
	if "`inis'"~="" {
	cap do "`inis'.pri"
	}
	cap macro drop ini_suba
	global tempprj `inis'
end
