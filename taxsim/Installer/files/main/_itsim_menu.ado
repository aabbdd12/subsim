*! version 3.00  15-December-2014   M. Araar Abdelkrim & M. Paolo verme
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


cap program drop _itsim_menu
program define _itsim_menu
qui { 
/*window menu clear*/
window menu append submenu "stUser" "&AITSIM"


		
window menu append item "AITSIM" /* 
        */   "Automated Income Tax SIMulator"    "db aitsim" 
		window menu append item "AITSIM" /* 
        */   "Initialise the Income Schedule"         "db itschset"
window menu append item "AITSIM" /* 
        */   "Describe  the Income Schedule"          "db itschdes"
		
		
window menu append separator "AITSIM"   


window menu append item "AITSIM" /* 
        */   "AITSIM Package Manager "  "db aitsim_man" 
  
window menu refresh
}
end
