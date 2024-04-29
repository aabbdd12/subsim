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



cap program drop aitini2
program aitini2
	version 10
	local inis $ini_suba
	global prg_pointer = "main"
	if "`inis'"~="" {
	cap do "`inis'.itp"
	}
	cap macro drop ini_suba
	global tempprj `inis'
end
