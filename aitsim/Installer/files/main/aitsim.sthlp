{smcl}
{* April 2016}{...}
{hline}
{hi:AITSIM 1.0: Automated Income Tax SIMulation Stata Toolkit}{right:{bf:World Bank}}
help for {hi:aitsim}{right:Dialog box:  {bf:{dialog aitsim}}}
{hline}

{title:Impact of income tax reforms on household wellbeing and on government revenue} 

{title:Syntax}
{p 8 10}{cmd:aitsim}  {it:varlist (min=1, max=1)}  {cmd:,} [ 

{cmd:HHID(}{it:varname}{cmd:)} 
{cmd:HSize(}{it:varname}{cmd:)} 
{cmd:HGroup(}{it:varname}{cmd:)}
{cmd:INCOME(}{it:varname}{cmd:)}
{cmd:TYPEIN(}{it:int}{cmd:)}
{cmd:XFIL(}{it:string}{cmd:)} 
{cmd:FOLGR(}{it:string}{cmd:)}
{cmd:LAN(}{it:string}{cmd:)} 
{cmd:INISAVE(}{it:string}{cmd:)} 
{cmd:WAPPR(}{it:int}{cmd:)} 
{cmd:TJOBS(}{it:string}{cmd:)} 
{cmd:GJOBS(}{it:string}{cmd:)} 

{cmd:OPGRk: k:1...4:(}{it:Syntax }{cmd:)} 
{cmd:MIN(}{it:string}{cmd:)} 
{cmd:MAX(}{it:string}{cmd:)} 
{cmd:OGR(}{it:string}{cmd:)} 

{cmd:ITSCH(}{it:varname}{cmd:)} 
{cmd:NSCEN(}{it:int}{cmd:)}
{cmd:FTSCHk: k:1..3(}{it:varname}{cmd:)}
{cmd:ELASk: k:1..3(}{it:varname}{cmd:)}

{cmd:CNAME(}{it:string}{cmd:)} 
{cmd:YSVY(}{it:string}{cmd:)} 
{cmd:YSIM(}{it:string}{cmd:)} 
{cmd:LCUR(}{it:string}{cmd:)} 

]

{p}where {p_end}
{p 8 8} {cmd:varlist} is a list of one variable: the per capita expenditures (or per capita income). {p_end}

{title:Description}
{p 8 8} {cmd: aitsim} is the main module of the package ITSIM 1.0. The later was conceived to automate the estimation of a large size of results about the impact of income tax reforms on household well-being and government revenue.  By default, the results are reported by quinitiles, but the user can indicate any other partition of the population.  The following two lists show the tables and graphs that can be produced.{p_end}

{p 2 8}{cmd:List of tables:}{p_end}
{p 4 8}{inp:[01]  Table 1.0: The income tax schedules (in %)}{p_end}

{p 4 8}{inp:[02]  Table 1.1: Population and payed wordeks}{p_end}

{p 4 8}{inp:[03]  Table 2.1: Incomes and expenditures}{p_end}

{p 4 8}{inp:[04]  Table 3.1: The incidence of the income tax burden}{p_end}
{p 4 8}{inp:[05]  Table 3.2: Equivalent flate tax rates}{p_end}
{p 4 8}{inp:[06]  Table 4.1: The total impact on well-being}{p_end}
{p 4 8}{inp:[07]  Table 4.2: The impact of the reform on the government revenue}{p_end} 
{p 4 8}{inp:[08]  Table 4.3: The reform and the poverty headcount}{p_end}
{p 4 8}{inp:[09]  Table 4.4: The reform and the poverty gap}{p_end}
{p 4 8}{inp:[10]  Table 4.5: The reform and the Gini inequality}{p_end}
{p 4 8}{inp:[11]  Table 4.6: The reform and the progressivity of income taxes (wellbeing / whole population)}{p_end}
{p 4 8}{inp:[12]  Table 4.7: The reform and the progressivity of income taxes (income    / payed worker)}{p_end}


{p 2 8}{cmd:List of graphs:}{p_end}
{p 4 8}{inp:[01] Figure 01: Wellbeing and income taxes (per cap.)}{p_end}
{p 4 8}{inp:[02] Figure 02: The ratio between income tax and wellbeing (per cap. and in %)}{p_end}
{p 4 8}{inp:[03] Figure 03: Wellbeing and income taxes by population groups}{p_end}
{p 4 8}{inp:[04] Figure 04: The progressivity of income taxes;}{p_end}


{title:Version} 10.1 and higher.

{title:Remark(s):} 
{p 8 8} Users should set their surveys' sampling design before using this module (and then save their data files). If the sampling design is not set, simple-random sampling (SRS) will be automatically assigned by default. {p_end}


{title:Description}
{p 8 8} {cmd: aitsim}, can be used to estimate the impact of price schedule reform on  the household wellbeing. 
Further, some descriptive results by population groups are produced. By default, the population groups are defined by deciles, but the user can indicate any other partition of population,  for instance, by urban and rural areas.  {p_end}


{title:Options} 


{p 0 6} {cmd:hhid:}    to indicate the varname of household identifiers. {p_end}

{p 0 6} {cmd:hsize:}    Household size. For example, to compute inequality at an individual level, one will want to weight household-level observations by household size (in addition to sampling weights, best set in survey design). {p_end}

{p 0 6} {cmd:income:}    to indicate the varname of post or pre tax incomes. {p_end}

{p 0 6} {cmd:typein:}    to indicate type of income indicated in the option income. By default it takes the value 1: income(...) is the gros income or pre tax income. Indicate 2  for the net or post tax income. {p_end}


{p 0 6} {cmd:hgroup}   Variable that captures a socio-demographic group. For example, this variable could equal 1 for rural households and 2 for urban ones. When this option is used, the associated varlist should contain only one variable. By default, the population groups are defined by deciles. {p_end}

{p 0 6} {cmd:wappr:}   To indicate the method used to estimate the impact on well-being, consumed quantities, poverty and inequality. By default, the marginal approach is used. When this option is set to 2 (appr(2)), the modeling preferences approach is used (Cob-Douglas function). {p_end}


{p 0 6} {cmd:itsch:}            To indicate  initial income tax schedules before the reform. {p_end}

{p 0 6} {cmd:ftsch{cmd:s}}      To indicate the  final income tax schedules after the reform with scenario s (the option oinf must be set to 3). {p_end}

{p 0 6} {cmd:elas{cmd:s}}        To indicate the varname of non-compensated price elasicities for scenario s. {p_end}

{p 0 6} {cmd:nscen:}          To indicate the number or simulated scenarios.  {p_end}


{p 0 6} {cmd:tjobs:}    You may want to produce only a subset of tables. In such case, you have to select the desired tables by indicating their codes with the option tjobs. 
For instance: tjops(11 21) . See also: {bf:{help jtables_it}}. {p_end}

{p 0 6} {cmd:gjobs:}    You may want to produce only a subset of graphs. In such case, you have to select the desired graphs by indicating their codes with the option gjobs. 
For instance: gjops(1 2) . See also: {bf:{help jgraphs_it}}. {p_end}

{p 0 6} {cmd:opgr{cmd:g} and g:1...10::}    Inserting options of graph g by using the following syntax: {p_end}

{p 6 6} {cmd:min:}    To indicate the minimum of the range of x-Axis of figure k. {p_end}
{p 6 6} {cmd:max:}    To indicate the maximum of the range of x-Axis of figure k. {p_end}
{p 6 6} {cmd:opt:}    To indicate additional twoway graph options of figure k. {p_end}
{phang}
{it:twoway_options} are any of the options documented in 
{it:{help twoway_options}}.  These include options for titling the graph 
(see {it:{help title_options}}), options for saving the graph to disk (see 
{it:{help saving_option}}), and the {opt by()} option (see 
{it:{help by_option}}).

{p 0 6} {cmd:xfil}   To indicate the name of Excel file, that will be used to save the results (*.xml format). {p_end}
{p 0 6} {cmd:folgr}   To indicate the name the folder in which the graph results will be saved. {p_end}
{p 0 6} {cmd:lan:}    By default, titles and labels are in English. Add the option lan(fr) for Frensh language.{p_end}
{p 0 6} {cmd:inisave:}    To save the subsim project information. Mainly, all inserted information in the dialogue box will be save in this file. In another session, the user can open the project using the command asubini followed by the name of project. This command will initialise all of the information of the aitsim dialog box. {p_end}

 
 {p 0 6} {cmd:cname}  To indicate the name of the country for which the simulation is performed. {p_end}
 {p 0 6} {cmd:ysvy}   To indicate the year of data survey. {p_end}
 {p 0 6} {cmd:ysvy}   To indicate the year of simulation. {p_end}
 {p 0 6} {cmd:lcur}   To indicate the name of local currency. {p_end}

 
 {p 0 6} {cmd:gvimp}   To indicate 1 to generate a new variable that will contain the per capita impact on wellbeing. {p_end}
 
 
{title:Author(s)}
Abdelkrim Araar
Paolo Verme

{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}



