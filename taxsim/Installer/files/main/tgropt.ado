*! version 1.00  03-Mayo-2017   M. Araar Abdelkrim & M. Paolo verme
/*************************************************************************/
/* TAXSIM: TAX Simulation Stata Toolkit  (Version 1.0)               */
/*************************************************************************/
/* Conceived by Dr. Araar Abdelkrim[1] and Dr. Paolo Verme[2]            */
/* World Bank Group (2012-2014)                                   */
/*           */
/* [1] email : aabd@ecn.ulaval.ca                                        */
/* [1] Phone : 1 418 656 7507                                            */
/*          */
/* [2] email : pverme@worldbank.org                                      */
/*************************************************************************/


#delimit ;
capture program drop tgropt;
program define tgropt, rclass sortpreserve;
version 9.2;
args ngr lan;

 #delimit ;
/* FIGURE 01 */ 
 
 local style_gr1 
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(11) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ;
   
local  title_fr_gr1 Figure 01: Niveau de vie et taxes sur le revenue (per cap.);
local xtitle_fr_gr1 Percentiles (p);
local ytitle_fr_gr1 Estimé de la taxe sur le revenue per cap.;

local  title_en_gr1 Figure 01: Wellbeing and income taxes (per cap.);
local xtitle_en_gr1 Percentiles (p);
local ytitle_en_gr1 Expected par cap. income tax.;

/* FIGURE 02 */ 
 local style_gr2
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(5) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ;
local  title_fr_gr2 Figure 02: Le ratio entre la taxe et le niveau de vie (per cap. and in %);   
local xtitle_fr_gr2 Percentiles (p);
local ytitle_fr_gr2 Tax par cap. / wellbeing per cap.;

local  title_en_gr2 Figure 02: The ratio between income tax and wellbeing (per cap. and in %);
local xtitle_en_gr2 Percentiles (p);
local ytitle_en_gr2 Tax par cap. / wellbeing per cap.;



/* FIGURE 03 */ 
 local style_gr3
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  ytitle(, size(2.8))  
  subtitle("")
   ; 
 
   
local  title_fr_gr3 Figure 03: Niveau de vie et taxes sur le revenue par groupes de population;
local  title_en_gr3 Figure 03: Wellbeing and income taxes by population groups;




/* FIGURE 04 */ 
 local style_gr4
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(11) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ; 
 
   
local  title_fr_gr4 Figure 04: La progressivité des taxes sur le revenue;
local xtitle_fr_gr4 Les percentiles (p);
local ytitle_fr_gr4 Courbes de Lorenz et de concentrations;

local  title_en_gr4 Figure 04: The progressivity of income taxes;
local xtitle_en_gr4 The percentiles (p);
local ytitle_en_gr4 Lorenz and concentration curves;

/* FIGURE 05 */ 
 local style_gr5
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(11) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ; 
 
   
local  title_fr_gr5 Figure 05: Le changement du prix et l'impact sur le revenu du gouvernement;
local xtitle_fr_gr5 L'augmentation du prix (in %);
local ytitle_fr_gr5 L'impact sur le revenu du gouvernement;

local  title_en_gr5 Figure 05: Price changes and the impact on the governement revenue ;
local xtitle_en_gr5 The increase in prices (in %);
local ytitle_en_gr5 The impact on the governement revenue;



/* FIGURE 06 */ 
 local style_gr6
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(1) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ; 
 
   
local  title_fr_gr6 Figure 06: L'élasticité et l'impact sur le revenu du gouvernement;
local xtitle_fr_gr6 Le niveau de l'élasticité;
local ytitle_fr_gr6 L'impact sur le revenu du gouvernement;

local  title_en_gr6 Figure 06: The elasticity and the impact on the governement revenue ;
local xtitle_en_gr6 The elasticity;
local ytitle_en_gr6 The impact on the governement revenue;




/* FIGURE 07 */ 
 local style_gr7
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(11) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ; 
 
   
local  title_fr_gr7 Figure 07: Le changement de la subvention et l'impact sur le revenu du gouvernement;
local xtitle_fr_gr7 Diminution de la subvention (en %);
local ytitle_fr_gr7 L'impact sur le revenu du gouvernement;

local  title_en_gr7 Figure 07: Subsidy changes and the impact on the governement revenue ;
local xtitle_en_gr7 The decrease in subsides (in %);
local ytitle_en_gr7 The impact on the governement revenue;



/* FIGURE 08 */ 
 local style_gr8
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(11) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ; 
 
   
local  title_fr_gr8 Figure 08: Niveau de transfert et  le bien-être ;
local xtitle_fr_gr8 Niveau de transfert;
local ytitle_fr_gr8 L'impact sur le bien-être ;

local  title_en_gr8 Figure 08: Level of transfer and wellbeing ;
local xtitle_en_gr8 Level of transfer ;
local ytitle_en_gr8 Impact on wellbeing ;



/* FIGURE 09 */ 
 local style_gr9
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(11) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ; 
 
   
local  title_fr_gr9 Figure 09: Niveau de transfert et la pauvreté;
local xtitle_fr_gr9 Niveau de transfert;
local ytitle_fr_gr9 Taux de population pauvre;

local  title_en_gr9 Figure 09: Level of transfer and poverty;
local xtitle_en_gr9 Level of transfer;
local ytitle_en_gr9 Headcount;



/* FIGURE 10 */ 
 local style_gr10
 plotregion(style(none) margin(zero)) 
 graphregion(fcolor(gs16) margin(medsmall) lstyle(none))
  xlabel(, labsize(2.6)) 
  ylabel(, angle(horizontal) labsize(2.6))
  title(,size(small))
  xtitle(, size(2.8) margin(0 0 0 2))
  ytitle(, size(2.8))  
  legend(pos(11) ring(0) col(1) size(2.4) symxsize(8)
  region(style(none)) margin(zero) bmargin(zero))
  scheme(s2mono)
  subtitle("")
   ; 
 
   
local  title_fr_gr10 Figure 10: Niveau de transfert et le revenu du gouvernement;
local xtitle_fr_gr10 Niveau de transfert;
local ytitle_fr_gr10 Variation dans le revenu du gouvernement;

local  title_en_gr10 Figure 10: Level of transfer and government revenue;
local xtitle_en_gr10 Level of transfer;
local ytitle_en_gr10 Change in government revenue;





 
/**********************************/

return local gtitle `title_`lan'_gr`ngr'';
return local gxtitle `xtitle_`lan'_gr`ngr'';
return local gytitle `ytitle_`lan'_gr`ngr'';
return local gstyle `style_gr`ngr'';




end;

