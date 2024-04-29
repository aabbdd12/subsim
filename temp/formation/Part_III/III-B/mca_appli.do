
set more off
cd "C:\WorldBank\Mauritania\DATA\Data__2008"

use "menage.dta", clear
gen year = 2008

#delimit ;
keep 
dr
menage
year
f1
f2
f21
f22
f3
f4
f5
f6
f7

f8
f9
f10
f11
f12
f13
f14
f15
f16a
f16b
f16c
f16d
f16e
f16f
f16g
f16h
f16i
f16j
f16k
f17
f18

f19

f20
f21
g0
g1
g2
g3
g4
g5
g6
g7
g8a
g8b
g8c
g8d
g8e
g8f
g8g
g9a
g9b
g9c
g9d
g9e
g9f
g9g


;

#delimit cr
save temp1_2008, replace


cd "C:\WorldBank\Mauritania\DATA\Data__2014"



/* Standard Living */
use "menage.dta", clear
rename a4 dr
rename a7 menage

#delimit ;
gen year = 2014;
keep 
dr
menage
year
f1
f2
f21
f22
f3
f4
f5
f6
f7

f8
f9
f10
f11
f12
f13
f14
f15
f16a
f16b
f16c
f16d
f16e
f16f
f16g
f16h
f16i*
f16j
f16k
f17
f18

f19

f20
f21
g0
g1
g2
g3
g4
g5
g6
g7
g8a
g8b
g8c
g8d
g8e
g8f
g8g
g9a
g9b
g9c
g9d
g9e
g9f
g9g


f16l


;

#delimit cr



replace  f16e=f16f 
replace  f16f=f16g 
replace  f16g=f16h
replace  f16h=f16i1 | f16i2 
gen  f16i =	f16j
replace  f16j = f16k
replace  f16k =	f16l

drop f16i1
drop f16i2
drop f16l
#delimit cr
save temp1_2014, replace

cd "C:\WorldBank\Mauritania\DATA\Data__2008"
append using  temp1_2008

save indicators0814, replace 

use "C:\WorldBank\Mauritania\MRT\mrt08_14.dta", clear
gen dr=int(hid/100)
gen menage =hid-dr*100
merge 1:1 dr menage year using "indicators0814.dta"
drop if _merge!=3
drop _merge

save mca_data, replace

recode f8 (1/10 = 1) (11/50 =2) (51/1000=3) 
recode f10 (1/10 = 1) (11/50 =2) (51/1000=3) 
recode f12 (1/10 = 1) (11/50 =2) (51/1000=3) 
recode f14 (1/10 = 1) (11/50 =2) (51/1000=3) 
foreach var of varlist f4 f5 f8 f9 f10 f11 f12 f13 f14 f15 {
gen `var'r=`var'*(rururb==1)
gen `var'u=`var'*(rururb==0)
drop `var'
} 







set matsize 800

#delimit ;
local mylist

region 
capital 

f1
f2
f21


f4*
f5*
f8*
f9*
f10*
f11*
f12*
f13*
f14*
f15*


f16a
f16b
f16c
f16d
f16e
f16f
f16g
f16h
f16i
f16j
f16k


g0
g1
g2
g3
g4
g5
g6
g7


;

sum `mylist' ;

des `mylist' ; 
cap drop intww;
gen intww=int(100*wta_pop);
mca `mylist'  [fw=intww] , comp sup(quintile);

#delimit cr
mcaprojection (quintile), normalize(principal)

#delimit cr
predict score
replace score = - score

table capital year [aw=wta_pop], c(mean score)

preserve
keep if rururb==0
cdensity score, hg(year) title(Density curve of MD wellbeing score: Rural Area)
restore 


preserve
keep if rururb==1
cdensity score, hg(year) title(Density curve of MD wellbeing score: Urban Area)
restore 




set more off
#delimit ;
cap drop scora; 
gen double scora=0;
set matsize 800;

local mylist

region 
capital 

f1
f2
f21


f4*
f5*
f8*
f9*
f10*
f11*
f12*
f13*
f14*
f15*


f16a
f16b
f16c
f16d
f16e
f16f
f16g
f16h
f16i
f16j
f16k


g0
g1
g2
g3
g4
g5
g6
g7


;
table year [aw=wta_pop], c(mean score);
mca `mylist'  [fw=intww] , comp sup(quintile);
table year [aw=wta_pop], c(mean score);

#delimit ;
cap drop scora; 
gen double scora=0;
foreach var of varlist `mylist' {;
cap drop scr_`var';
predict double scr_`var', score(`var')   dim(1)     ;
replace scr_`var'= - scr_`var';
qui replace scora = scora+scr_`var';
};


table year [aw=wta_pop], c(mean scora);



#delimit ;
cap drop if scora==.;
qui sum score if scora!=.;
local m1 = r(mean);

qui sum scora if scora!=.;;
local m2 = r(mean);

dis `m2'/`m1' ;


cap drop scoran; 
gen double scoran=0;

foreach var of varlist `mylist' {;
dis `var';
replace scr_`var'=scr_`var' *abs(`m1'/`m2') ;
qui replace scoran = scoran+scr_`var';
};

sum scor* if scora != . ;



#delimit ;
local mylist_house
OcupStat_milieu
milieu
Bedroom
Cook_Ene
LighT
Garbage_Vac
Wall
Roof
Ground
Toilet
;

local mylist_educ
Write
Problem_School 
;

local mylist_durable_goods
Phone
Radio
Fridge
Fan
Air_Con
Car
;


cap drop score_assets;
gen score_assets=0; 


cap drop score_house;
gen score_house=0; 




local mylist_assets



f4*
f5*
f8*
f9*
f10*
f11*
f12*
f13*
f14*
f15*


f16a
f16b
f16c
f16d
f16e
f16f
f16g
f16h
f16i
f16j
f16k



;


foreach var of varlist `mylist_assets' {;
qui replace score_assets = score_assets+scr_`var';
}; 


local mylist_house


region 
capital 

f1
f2
f21


g0
g1
g2
g3
g4
g5
g6
g7


;


foreach var of varlist `mylist_house' {;
qui replace score_house = score_house+scr_`var';
}; 


table year [aw=wta_pop], c(mean score_assets mean score_house mean score);

preserve
set more on
keep if rururb==0
cdensity score_assets, hg(year) title(Density curve: Assest and durable goods) band(0.06)
more
cdensity score_house , hg(year) title(Density curve : Housing and related facilities) band(0.06)
set more off
restore 


preserve
set more on
keep if rururb==1
cdensity score_assets, hg(year) title(Density curve: Assest and durable goods) band(0.06)
more
cdensity score_house , hg(year) title(Density curve : Housing and related facilities) band(0.06)
set more off
restore 





