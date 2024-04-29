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


cap program drop _subsim_menu
program define _subsim_menu
qui { 
/*window menu clear*/
window menu append submenu "stUser" "&SUBSIM"


		
window menu append item "SUBSIM" /* 
        */   "SUBSIM Automated Simulator : Direct effects"    "db asubsim" 
		window menu append item "SUBSIM" /* 
        */   "Initialise the Price Schedule"         "db pschset"
window menu append item "SUBSIM" /* 
        */   "Describe  the Price Schedule"          "db pschdes"
		
		
window menu append separator "SUBSIM"   

window menu append item "SUBSIM" /* 
        */   "SUBSIM Automated Simulator : Indirect effects"  "db asubsim_ind"
		
window menu append item "SUBSIM" /* 
        */   "IO Models and Setoral Price Changes "  "db pciom" 
		
window menu append separator "SUBSIM" 

window menu append item "SUBSIM" /* 
        */   "SUBSIM Package Manager "  "db subsim_man" 
  
window menu refresh
}
end
