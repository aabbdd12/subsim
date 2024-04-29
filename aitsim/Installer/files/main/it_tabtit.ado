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
capture program drop it_tabtit;
program define it_tabtit, rclass sortpreserve;
version 9.2;
args ntab lan;

local	tabtit_10_fr	=	"Tableau 1.0: Strutcures des taxes sur les revenues (in %) 	"	;

local	tabtit_11_fr	=	"Tableau 1.1: Population et personnes payées	"	;

local	tabtit_21_fr	=	"Tableau 2.1: Revenues et dépenses		"	;

local	tabtit_31_fr	=	"Tableau 3.1: La distribution du fardeau fiscal des impôts sur les revenues personels"	;

local	tabtit_32_fr	=	"Tableau 3.2: Taux moyen de taxation (en %)"	;

local	tabtit_41_fr	=	"Tableau 4.1: Le total des impacts sur le bien-être de la population (en monnaie)";		

local	tabtit_42_fr	=	"Tableau 4.2: L'impact de la réforme sur les recettes de l'état (en monnaie)";

local	tabtit_43_fr	=	"Tableau 4.3: Reformes et taux de pauvreté";

local	tabtit_44_fr	=	"Tableau 4.4: Reformes et carence moyenne de pauvreté";

local	tabtit_45_fr	=	"Tableau 4.5: Réformes et l'inégalité de Gini"; 

local	tabtit_46_fr	=	"Tableau 4.6: Réformes et progressivité de la taxe sur le revenue (niveau de vie / population)"; 

local	tabtit_47_fr	=	"Tableau 4.7: Réformes et progressivité de la taxe sur le revenue (Revenue / travailleurs payés )"; 

/*
local	tabtit_44_fr	=	"Tableau 4.4: L'impact total sur les quantités consommées (en quantité)";                              
local	tabtit_45_fr	=	"Tableau 4.5: L'impact total sur les quantités consommées per capita (en quantité)";	
local	tabtit_46_fr	=	"Tableau 4.6: L'impact de la réforme sur les recettes de l'état (en monnaie)";
local	tabtit_47_fr	=	"Tableau 4.7: Reformes et taux de pauvreté";	

*/

local	tabtit_10_en	=	"Table 1.0: The income tax schedules (in %) "	;

local	tabtit_11_en	=	"Table 1.1: Population and payed wordeks "	;

local	tabtit_21_en	=	"Table 2.1: Incomes and expenditures "	;

local	tabtit_31_en	=	"Table 3.1: The incidence of the income tax burden"	;

local	tabtit_32_en	=	"Table 3.2: Equivalent flate tax rates (in %) "	;

local	tabtit_41_en	=	"Table 4.1: The total impact on  well-being (in currency)";	

local	tabtit_42_en	=	"Table 4.2: The impact of the reform on the government revenue (in currency)";

local	tabtit_43_en	=	"Table 4.3: The reform and the poverty headcount";	

local	tabtit_44_en	=	"Table 4.4: The reform and the poverty gap";

local	tabtit_45_en	=	"Table 4.5: The reform and the Gini inequality";

local	tabtit_46_en	=	"Table 4.6: The reform and the progressivity of the income tax (wellbeing / whole population) ";

local	tabtit_47_en	=	"Table 4.7: The reform and the progressivity of the income tax (income / payed workers)";

/*	
local	tabtit_46_en	=	"Table 4.6: The impact of the reform on the government revenue (in currency)";
local	tabtit_47_en	=	"Table 4.7: The reform and the poverty headcount";	
local	tabtit_48_en	=	"Table 4.8: The reform and the poverty gap";
local	tabtit_49_en	=	"Table 4.9: The reform and the Gini inequality";
*/

return local tabtit `tabtit_`ntab'_`lan'';
end;


