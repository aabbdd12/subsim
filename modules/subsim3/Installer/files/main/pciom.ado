/*************************************************************************/
/* SUBSIM: Subsidy Simulation Stata Toolkit  (Version 2.0)               */
/*************************************************************************/
/* Conceived by Dr. Araar Abdelkrim[1] and Dr. Paolo Verme[2]            */
/* World Bank Group (2012-2016)		                                 */
/* 									 */
/* [1] email : aabd@ecn.ulaval.ca                                        */
/* [1] Phone : 1 418 656 7507                                            */
/*									 */
/* [2] email : pverme@worldbank.org                                      */
/*************************************************************************/



#delimit; 
/* The module Price Change Input Output Model (pciom_ind */
capture program drop pciom;
program define pciom, eclass sortpreserve;
version 9.2;
syntax varlist(min=1 max=1) [,  
IOM(string)
MATCH(string)
VNMATCH(string)
LABSEC(string)
SECP1(int 1)
PR1(real 10)
SECP2(int 2)
PR2(real 10)
SECP3(int 3)
PR3(real 10)
SECP4(int 4)
PR4(real 10)
SECP5(int 5)
PR5(real 10)
SECP6(int 6)
PR6(real 10)
NSHOCKS(int 1)
NADP(int 1)
NITEMS(int 1)

IOMODEL(int 1)
TYSHOCK(int 1)
ADSHOCK(int 1)

DGRA(int 0)
SGRA(string)
EGRA(string)

LRES(int 0)
SRES(int 0)

];

set more off;

/* a vector of added values (share of renumeration of capital+labor) */
tempname V A B C B`secp1' I IA IB P0 P1 P2;

preserve;
tokenize `varlist' ;
use `iom' , replace ;
qui des;
local nrow1 = `r(N)' ;
local nrow = `r(N)' -1 ;
local ncol = `r(k)';

local supsum= 0;
local _supsum= 0;
local pos =1;
foreach var of varlist _all {;
qui sum `var';
qui replace `var' = `var'/`r(sum)';
local sum`pos' = `r(sum)';
local supsum= `supsum'+`r(sum)';
local pos = `pos'+1 ;
};



forvalues i=1/`ncol' {;
local secshare`i' = `sum`i''/`supsum' ;
};

display  _n "{col 5}*** Checking steps:";
if `nrow'==`ncol' {;
dis "{col 5}Test 1: OK      : The Input/Output matrix is a squared matrix of `nrow' sectors.";
};
if `nrow'!=`ncol' {;
dis "{col 5}Test 1: Failled : The Input/Output matrix is not a squared matrix!";
exit;
};

qui count;
if `nrow'==`r(N)' {;
dis "{col 5}Test 2: OK      : The number of observations of the current datafile is  equal to the number of sectors based on the IO matrix.";
};

if `nrow'!=`ncol' {;
dis "{col 5}Test 2: Failled : The number of observations of the current datafile is  diffrent from the number of sectors based on the IO matrix.";
exit;
};


display _n "{col 5}*** IO model information:" ;

local titmodel = "" ;
if `iomodel'==1 {;
if (`tyshock' == 1)  & (`adshock' == 1) local titmodel = "Cost push price model | sort term | permanent exogenous shock(s)" ;
if (`tyshock' == 1)  & (`adshock' == 2) local titmodel = "Cost push price model | long term | permanent exogenous shock(s)" ;

if (`tyshock' == 2)  & (`adshock' == 1) local titmodel = "Cost push price model | sort term | temporal exogenous shock(s)" ;
if (`tyshock' == 2)  & (`adshock' == 2) local titmodel = "Cost push price model | long term | temporal exogenous shock(s)" ;

};


if `iomodel'==2  local titmodel = "Marginal profit push price model | long term | temporal exogenous shock(s)";

dis  "{col 5}IO Model: `titmodel'.";

/*
display         " - Exogeneous price change (in %)  {col 46} :`pr1' ";
local secinfo = " - Position in the I/O matrix = `secp1' " ;
display         " - The sector with the simulated price change {col 46} :`secinfo' ";
*/
local model =0;
if `iomodel'==1 {;
if (`tyshock' == 1)  & (`adshock' == 1) local model = 1 ;
if (`tyshock' == 1)  & (`adshock' == 2) local model = 2 ;

if (`tyshock' == 2)  & (`adshock' == 1) local model = 3 ;
if (`tyshock' == 2)  & (`adshock' == 2) local model = 4 ;

};

if `iomodel'==2 local model = 5 ;


#delimit cr



forvalues i=1/`nshocks' {
local prices `prices' pr`i'
local positions `positions' secp`i' 
}

forvalues i = 1/`: word count `prices'' {
  local `: word `i' of `prices''name    pricevector[`i']
  local `: word `i' of `positions''name   posvector[`i']
}


qui des, varl
local list  `r(varlist)'
cap drop _stp
qui gen _stp = `nadp'
local list2  _stp
cap drop _dp*
 mata: mata_callfun1()
tempname myres
qui keep _dp* 
qui keep in 1/`nrow'
qui save `myres', replace
restore
cap drop _p*
qui merge 1:1 _n using `myres'
qui drop _merge

#delimit ;
if (`dgra'==1) {;

graph hbar (mean) _dp1 _dp2 _dp3 _dp4 _dp5 /*in 1/16 */,
 over(`labsec', label(labsize(tiny))) 
 title(Price change and IO models)
 legend(order(
 1 "Cost push model         | Permanent shock  | Short term adjustment (number of periods = `nadp')" 
 2 "Cost push model         | Permanent shock  | Long  term adjustment" 
 3 "Cost push model         | Temporal  shock  | Short term adjustment (number of periods = `nadp')" 
 4 "Cost push model         | Temporal  shock  | Long  term adjustment" 
 5 "Marginal profit model | Permanent shock | Long  term adjustment" 
 ) )legend(cols(1) size(vsmall)  position(7)  colgap(zero)  rowgap(zero)  )
 legend(linegap(zero) region(lcolor(none)))
 /*bar(1, fcolor(gs12) lcolor(gs12)) bar(2, fcolor(orange) lcolor(orange))*/
 graphregion(fcolor(white) lcolor(white))
 xsize(12)  ytitle(Price changes (in %)) ysize(8);
 
 };
 

if( `lres' == 1) {;
preserve;
keep  `1' _dp1 _dp2 _dp3 _dp4 _dp5 ;
lis , separator(0) ;
restore;
}; 
 
if( "`sres'" ~= "") {;
preserve;
keep  `1' _dp1 _dp2 _dp3 _dp4 _dp5 ;
save `"`sres'"', replace;
restore;
};

if( "`sgra'" ~= "") {;
graph save `"`sgra'"', replace;
};

if( "`egra'" ~= "") {;
graph export `"`egra'"', replace;
};

 

 #delimit cr

foreach var of varlist _dp* {
if "`var'" != "_dp`model'" qui drop `var'
}

rename _dp`model' _dp

set more off
list `1' `labsec' _dp , separator(0) 
end


#delimit cr



mata: mata clear
mata:


void function mata_callfun1()
{
		fun1(  st_data( .,tokens(st_local("list")), st_local("touse") ),  st_data( . , tokens(st_local("list2")), st_local("touse"))  )
}


real matrix function fun1(real matrix X , real matrix Z) 
{
stp=Z[1]
sumX=colsum(X)
N = cols(X) 			
/* Number of sectors */
XX=X
for (i=1; i<=N; ++i) {
XX[.,i]=X[.,i]/sumX[i]	
/* Normalised units/prices */
}
A=XX[1..N,.] 			
/* Technical coefficient matrix */
V=XX[N+1..N+1,.]' 		
/* The added value vector */ 
A=A'
I=I(N)
NU=J(N,N,0)
prices=tokens(st_local("prices"))
positions=tokens(st_local("positions"))


nshocks=cols(prices)
PR  = J(1,nshocks,.)
POS = J(1,nshocks,.)
for (i=1; i<=cols(prices); i++) {
    PR[i]  = strtoreal(st_local(prices[i]))
	POS[i] = strtoreal(st_local(positions[i]))
	NU[POS[i],POS[i]] = PR[i]
}

/*  COST PUSH PRICE / SHORT TERME / EXOGENOUS SHOCKS  */ 
		
NUC=J(N,1,0)
DP =J(N,1,0)
DP0 =J(N,1,0)
DP00=J(N,1,0)
AA=A'

for (i=1; i<=cols(prices); i++) {
DP00[POS[i]]=PR[i]
}
DP00=DP00'*AA
for (i=1; i<=cols(prices); i++) {
DP00[POS[i]]=0
}
DP=DP00
AA=A'
for (i=1; i<=cols(prices); i++) {
AA[POS[i] , .]  = NUC'
AA[., POS[i]]   = NUC
}
for (j=1; j<=stp; j++) {
DP=DP+(DP*AA)
AA=AA*AA
}
for (i=1; i<=cols(prices); i++) {
DP[POS[i]]=PR[i]
}
DPM1=DP'





/*  COST PUSH PRICE / LONG TERME / EXOGENOUS SHOCKS  */ 

NUC=J(N,1,0)
DP =J(N,1,0)
DP0=J(N,1,0)
for (i=1; i<=cols(prices); i++) {
DP0 =DP0:+A[.,POS[i]]*PR[i]
}

for (i=1; i<=cols(prices); i++) {
DP0[POS[i]] =0
}
AA=A'
for (i=1; i<=cols(prices); i++) {
AA[POS[i] , .]  = NUC'
AA[., POS[i]]   = NUC
}

DP=luinv(I-AA')*DP0
for (i=1; i<=cols(prices); i++) {
DP[POS[i]]=PR[i]
}
DPM2=DP



/*  COST PUSH PRICE / SHORT TERME / EXOGENOUS SHOCKS  */ 
DP =J(N,1,0)
DP0 =J(N,1,0)
DP00=J(N,1,0)
AA=A'
for (i=1; i<=cols(prices); i++) {
DP00[POS[i]]=PR[i]
}
DP00=DP00'*AA
for (i=1; i<=cols(prices); i++) {
DP00[POS[i]]=PR[i]
}
DP=DP00
AA=A'
for (j=1; j<=stp; j++) {
DP=DP+(DP*AA)
AA=AA*AA
}
DPM3=DP'




/*  COST PUSH PRICE / LONG TERME / ENDOGENOUS SHOCKS  */ 
DP =J(N,1,0)
DP0=J(N,1,0)
P0 =J(N,1,1)
for (i=1; i<=cols(prices); i++) {
DP0 =DP0:+A[.,POS[i]]*PR[i]
}

for (i=1; i<=cols(prices); i++) {
DP0[POS[i]] =PR[i]
}
AA=A
DP=luinv(I-AA)*DP0
DPM4=DP


/*  MARGINAL PROFIT PUSH PRICE / LONG TERME / ENDOGENOUS SHOCKS  */ 

T=I:+NU
DPM5=luinv(I-A*T)*V-P0

DP =J(N+1,5,0)
DP[1..N,1]=DPM1
DP[1..N,2]=DPM2
DP[1..N,3]=DPM3
DP[1..N,4]=DPM4
DP[1..N,5]=DPM5

st_addvar("float","_dp1")
st_store(., "_dp1", DP[.,1])
st_addvar("float","_dp2")
st_store(., "_dp2", DP[.,2])
st_addvar("float","_dp3")
st_store(., "_dp3", DP[.,3])
st_addvar("float","_dp4")
st_store(., "_dp4", DP[.,4])
st_addvar("float","_dp5")
st_store(., "_dp5", DP[.,5])

}



end
 
