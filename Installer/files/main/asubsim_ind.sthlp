{smcl}
{* Nov 2014}{...}
{hline}
{hi:SUBSIM_IND 3.0: Subsidy Simulation Stata Toolkit (Indirect effects}{right:{bf:World Bank}}
help for {hi:asubsim_ind}{right:Dialog box:  {bf:{dialog asubsim_ind}}}
{hline}

{title:Indirect impact of subsidy reforms on household wellbeing} 

{title:Syntax}
{p 8 10}{cmd:asubsim_ind}  {it:varlist (min=1, max=1)}  {cmd:,} [ 
{cmd:HSize(}{it:varname}{cmd:)} 
{cmd:HGroup(}{it:varname}{cmd:)}
{cmd:NITEMS(}{it:int}{cmd:)} 
{cmd:XFIL(}{it:string}{cmd:)} 
{cmd:FOLGR(}{it:string}{cmd:)}
{cmd:LAN(}{it:string}{cmd:)} 
{cmd:INISAVE(}{it:string}{cmd:)} 
{cmd:TAGGReragte(}{it:string}{cmd:)} 
{cmd:GAGGReragte(}{it:string}{cmd:)} 
{cmd:APPR(}{it:int}{cmd:)} 
{cmd:WAPPR(}{it:int}{cmd:)} 
{cmd:TJOBS(}{it:string}{cmd:)} 
{cmd:GJOBS(}{it:string}{cmd:)} 

{cmd:IOMATRIX(}{it:filename}{cmd:)}
{cmd:IOMODEL(}{it:int}{cmd:)}
{cmd:ADSHOCK(}{it:int}{cmd:)}
{cmd:TYSHOCK(}{it:int}{cmd:)}
{cmd:NSHOCKS(}{it:int}{cmd:)}
{cmd:NADP(}{it:int}{cmd:)}

{cmd:OPRk:  k:1...10:(}{it:Syntax }{cmd:)} 
{cmd:SN(}{it:string}{cmd:)} 
{cmd:QU(}{it:string}{cmd:)}
{cmd:IT(}{it:varname}{cmd:)} 
{cmd:IP(}{it:real/string}{cmd:)}
{cmd:SU(}{it:real}{cmd:)}
{cmd:FP(}{it:real/string}{cmd:)}
{cmd:EL(}{it:real}{cmd:)} 
{cmd:PS(}{it:int}{cmd:)}

{cmd:SHOCKk: k:1...6:(}{it:Syntax }{cmd:)}
{cmd:SECP(}{it:int}{cmd:)}
{cmd:PR(}{it:real}{cmd:)} 

{cmd:OPGRk: k:1...10:(}{it:Syntax }{cmd:)} 
{cmd:MIN(}{it:string}{cmd:)} 
{cmd:MAX(}{it:string}{cmd:)} 
{cmd:OGR(}{it:string}{cmd:)} 

{cmd:ITNAMES(}{it:varname}{cmd:)} 
{cmd:SNAMES(}{it:varname}{cmd:)}
{cmd:IPSCH(}{it:varname}{cmd:)} 
{cmd:NSCEN(}{it:int}{cmd:)}
{cmd:FPSCHk: k:1..3(}{it:varname}{cmd:)}
{cmd:ELASk: k:1..3(}{it:varname}{cmd:)}
{cmd:OINF(}{it:int}{cmd:)} 

{cmd:CNAME(}{it:string}{cmd:)} 
{cmd:YSVY(}{it:string}{cmd:)} 
{cmd:YSIM(}{it:string}{cmd:)} 
{cmd:LCUR(}{it:string}{cmd:)} 

{cmd:TYPETR(}{it:int}{cmd:)}
{cmd:GTARG(}{it:varname}{cmd:)}

{cmd:CVIMP(}{it:int}{cmd:)} 

]




{p}where {p_end}
{p 8 8} {cmd:varlist} is a list of one variable: the per capita expenditures. {p_end}

{title:Description}
{p 8 8} {cmd: asubsim_ind} is a complementary module of the package SUBSIM. The latter was conceived to automate the estimation  the results of indirect effect of subsidy reforms on household well-being.  By default, the results are reported by quinitiles, but the user can indicate any other partition of population.  The following lists shows the produces tables and graphs:{p_end}

{p 2 8}{cmd:List of tables:}{p_end}
{p 4 8}{inp:[01] Table 1.1: Population and expenditures}{p_end} 

{p 4 8}{inp:[02] Table 2.1: Expenditures }{p_end}
{p 4 8}{inp:[03] Table 2.2: Expenditures per household}{p_end}
{p 4 8}{inp:[04] Table 2.3: Expenditures per capita}{p_end}


{p 4 8}{inp:[07] Table 3.1: Structure of expenditure on subsidized products}{p_end}
{p 4 8}{inp:[08] Table 3.2: Expenditure on subsidized products over the total expenditures}{p_end}


{p 4 8}{inp:[12] Table 4.1: The total impact on the population well-being}{p_end}
{p 4 8}{inp:[13] Table 4.2: The impact on the per capita well-being}{p_end}
{p 4 8}{inp:[13] Table 4.3: The impact on well-being (in %)}{p_end}
{p 4 8}{inp:[17] Table 4.7: The reform and the poverty headcount}{p_end}
{p 4 8}{inp:[18] Table 4.8: The reform and the poverty gap}{p_end}
{p 4 8}{inp:[19] Table 4.9: The reform and the Gini inequality}{p_end}


{p 2 8}{cmd:List of graphs:}{p_end}
{p 4 8}{inp:[01] Figure 01: The expenditures on the subsidized good relatively to the total expenditures (%)}{p_end}
{p 4 8}{inp:[03] Figure 03: The progressivity in the distribution of benefits}{p_end}
{p 4 8}{inp:[04] Figure 04: The impact of price increasing on poverty (%)}{p_end}
{p 4 8}{inp:[08] Figure 08: Level of transfer and wellbeing}{p_end}
{p 4 8}{inp:[09] Figure 09: Level of transfer and poverty}{p_end}
{p 4 8}{inp:[10] Figure 10: Level of transfer and government revenue}{p_end}


{title:Version} 11 and higher.

{title:Remark(s):} 
{p 8 8} Users should set their surveys' sampling design before using this module (and then save their data files). If the sampling design is not set, simple-random sampling (SRS) will be automatically assigned by default. {p_end}



{title:Options} 

{p 0 6} {cmd:hsize:}    Household size. For example, to compute inequality at an individual level, one will want to weight household-level observations by household size (in addition to sampling weights, best set in survey design). {p_end}

{p 0 6} {cmd:hgroup}   Variable that captures a socio-demographic group. For example, this variable could equal 1 for rural households and 2 for urban ones. When this option is used, the associated varlist should contain only one variable. By default, the population groups are defined by deciles. {p_end}

{p 0 6} {cmd:nitems}   To indicate the number of items used in the simulation. For instance, if we plan to estimate the impact of the potential change in subsidies of Essence and Gasoil (we assume that we have the two variables of expenditures on these two items) the number of items is then two. {p_end}

{p 0 6} {cmd:typetr:}     To indicate the type of transfer. By default, the type is a universal per capita transfer. Set the value to 2 for the case of universal household transfer. {p_end}

{p 0 6} {cmd:wappr:}   To indicate the method used to estimate the impact on well-being, consumed quantities, poverty and inequality. By default, the marginal approach is used. When this option is set to 2 (appr(2)), the modeling preferences approach is used (Cob-Douglas function). {p_end}

{p 0 6} {cmd:it{cmd:k}: and k:1...10:}    To insert information on the item k by using the following syntax: {p_end}

{p 6 12}  {cmd:sn:}    To indicate the short label of the item. {p_end}

{p 6 12}  {cmd:it:}    To indicate the varname of the item. {p_end}

{p 6 12}  {cmd:el:}    To indicate the non-compensated own elasticity. {p_end}

{p 6 12}  {cmd:ms:}    To indicate the matching sectors {p_end}

{p 0 12} {cmd:Example:} it3( sn(Food items) it(food)  el(-0.5) ms(1 4 5) ). {p_end}

{p 0 6} {cmd:oinf:}       To indicate the form to declare the information about items (name of variables of expenditues on items, prices/price shedules, etc). When variables are used to initialise the information, the value must be set to 2. The options in this case are: {p_end}

{p 0 12} {cmd:snames:}     To declare varname of short names of items (the option oinf must be set to 2). {p_end}

{p 0 12} {cmd:itnames:}    To declare the varname of items in one string variable (the option oinf must be set to 2). {p_end}

{p 0 12} {cmd:elas}  To indicate the varname of the non-compensated price elasicities for scenario s (the option oinf must be set to 2). {p_end}

{p 0 12} {cmd:msec}  To indicate the varname of matching sectors(the option oinf must be set to 2). {p_end}

{p 0 4} {cmdab:iomatrix}   To indicate the filename of datafile with (n+1) observations and (n) variables. Except the last observation, the rest forms the square I/O matrix on (n) sectors. The last line of this data file must contain the value added of each sector. {p_end}

{p 0 4} {cmdab:iomodel}   To indicate the IO proche change model. {p_end}

{p 0 4} {cmdab:nshocks}   To indicate the number of sectors affected by the exogenous price shocks (maximum is 6). {p_end}

{p 0 4} {cmdab:shock'i': and 'i' : 1-6}   To intialise the information of price shock i. Example: shock1( secp(2) pr(10)), which means we have an exogenious price shock (in crease of 10%) in the sector 2 (2 is the position of the sector in the IO matrix). {p_end}

{p 0 4} {cmdab:secp}    To indicate the line position of the sector with the exogenous proce shock. {p_end}

{p 0 4} {cmdab:pr}     To indicate the level of price shock (in %) . {p_end}

{p 0 4} {cmdab:nadp}    For the short term results, the user can indicate the number of the periods of price adjustments. {p_end}

{p 0 4} {cmdab:tyshock}    To indicate if the price shock is permenent -exogenous model- (1) or temporary -endogenous model- (2). {p_end}

{p 0 4} {cmdab:adshock}    To indicate this the price change is that of the short term or that of the long term. {p_end}

{p 0 6} {cmd:taggregate:}     To specify the desired aggregation form of table results. {p_end}
{p 10 6}    Form:  # # # ... : label | # # # ... : label |...{p_end}
{p 10 6}    Example: {p_end}
{p 10 6}    If we have the following list of items:{p_end}
{p 20 6}    1- Butane {p_end}
{p 20 6}    2- Petrol {p_end}
{p 20 6}    3- Gas {p_end}
{p 20 6}    4- Cub Sugar {p_end}
{p 20 6}    5- Granulated Sugar {p_end}
{p 20 6}    6- Powdered Sugar {p_end}
{p 20 6}    7- National Flour {p_end}
{p 20 6}    8- Free Flour {p_end}

{p 0 6} {cmd:gaggregate:}     To specify the desired aggregation form of graph results. For the syntax, see option taggretgate. {p_end}


{p 10 6}    You may want to aggregate the result for sugar and flour. This may be done by adding the option: {p_end}
{p 10 6}    aggr( 4 5 6 : "Sugar" | 7 8 : "Flour" ) {p_end}

{p 0 6} {cmd:tjobs:}    You may want to produce only a subset of tables. In such case, you have to select the desired tables by indicating their codes with the option tjobs. 
For instance: tjops(11 21) . See also: {bf:{help jtables}}. {p_end}

{p 0 6} {cmd:gjobs:}    You may want to produce only a subset of graphs. In such case, you have to select the desired graphs by indicating their codes with the option gjobs. 
For instance: gjops(1 2) . See also: {bf:{help jgraphs}}. {p_end}

{p 0 6} {cmd:opgr{cmd:g} and g:1...10::}    Inserting options of graph g by using the following syntax: {p_end}
{p 6 12} {cmd:min:}    To indicate the minimum of the range of x-Axis of figure k. {p_end}
{p 6 12} {cmd:max:}    To indicate the maximum of the range of x-Axis of figure k. {p_end}
{p 6 12} {cmd:opt:}    To indicate additional twoway graph options of figure k. {p_end}
{phang}
{it:twoway_options} are any of the options documented in 
{it:{help twoway_options}}.  These include options for titling the graph 
(see {it:{help title_options}}), options for saving the graph to disk (see 
{it:{help saving_option}}), and the {opt by()} option (see 
{it:{help by_option}}).

{p 0 6} {cmd:xfil}   To indicate the name of Excel file, that will be used to save the results (*.xml format). {p_end}
{p 0 6} {cmd:folgr}   To indicate the name the folder in which the graph results will be saved. {p_end}
{p 0 6} {cmd:lan:}    By default, titles and labels are in English. Add the option lan(fr) for Frensh language.{p_end}
{p 0 6} {cmd:inisave:}    To save the subsim project information. Mainly, all inserted information in the dialogue box will be save in this file. In another session, the user can open the project using the command asubini followed by the name of project. This command will initialise all of the information of the asubsim dialog box. {p_end}

 
 {p 0 6} {cmd:cname}  To indicate the name of the country for which the simulation is performed. {p_end}
 {p 0 6} {cmd:ysvy}   To indicate the year of data survey. {p_end}
 {p 0 6} {cmd:ysvy}   To indicate the year of simulation. {p_end}
 {p 0 6} {cmd:lcur}   To indicate the name of local currency. {p_end}

 {p 0 6} {cmd:typetr}  To indicate unit concerned by the transfer (1: individual transfer | 2: household transfer). {p_end}
 {p 0 6} {cmd:gtarg}   By default, the transfer is universal. However, the user can indicate a dummy variable to indicate the targeted group by the constant transfer {p_end}
 {p 0 6} {cmd:gvimp}   To indicate the name of the new variable that will contain the per capita impact on wellbeing. {p_end}

 
{title:Author(s)}
Abdelkrim Araar
Paolo Verme

{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}



