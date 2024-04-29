*! version 1.00  03-Mayo-2017   M. Araar Abdelkrim & M. Paolo verme
/*************************************************************************/
/* AITSIM: itsidy Simulation Stata Toolkit  (Version 3.0)               */
/*************************************************************************/
/* Conceived by Dr. Araar Abdelkrim[1] and Dr. Paolo Verme[2]            */
/* World Bank Group (2012-2016)		                                 */
/* 									 */
/* [1] email : aabd@ecn.ulaval.ca                                        */
/* [1] Phone : 1 418 656 7507                                            */
/*									 */
/* [2] email : pverme@worldbank.org                                      */
/*************************************************************************/


cap program drop _taxsim_menu
program define _taxsim_menu
qui { 
/*window menu clear*/
window menu append submenu "stUser" "&TAXSIM"
window menu append submenu "TAXSIM"   "&Direct Taxes: Persons"
window menu append submenu "TAXSIM"   "&Direct Taxes: Corporates"
window menu append submenu "TAXSIM"   "&Indirect Taxes"
		
window menu append item "Direct Taxes: Persons" /* 
        */   "Automated Income Tax SIMulator"        "db aitsim" 
		window menu append item "Direct Taxes: Persons" /* 
        */   "Initialise the Income Schedule"         "db itschset"
window menu append item "Direct Taxes: Persons" /* 
        */   "Describe  the Income Schedule"          "db itschdes"

window menu append item "Direct Taxes: Corporates" /* 
        */   "Automated Income/Benefit Corporate Tax SIMulator"        "db actsim" 		
		
window menu append separator "TAXSIM"   


window menu append item "TAXSIM" /* 
        */   "TAXSIM Package Manager "  "db taxsim" 
  
window menu refresh
}
end
