{smcl}
{* November 2014}{...}
{hline}
{hi:SUBSIM 2.1: Subsidy Simulation Stata Toolkit}{right:{bf:World Bank}}
help for {hi:pciom}{right:Dialog box:  {bf:{dialog pciom}}}
{hline}

{title:Price change and the input/output models:} 

{p 8 10}{cmd:pciom}  {it:varlist}  {cmd:,} 
[   
{cmd:IOM(}{it:filename}{cmd:)}
{cmd:LABSEC(}{it:string}{cmd:)}
{cmd:IOMODEL(}{it:int}{cmd:)}
{cmd:ADSHOCK(}{it:int}{cmd:)}
{cmd:TYSHOCK(}{it:int}{cmd:)}
{cmd:NSHOCKS(}{it:int}{cmd:)}
{cmd:NADP(}{it:int}{cmd:)}
{cmd:SEC1-6(}{it:int}{cmd:)}
{cmd:PR1-6(}{it:real}{cmd:)}
{cmd:LRES(}{it:int}{cmd:)}
{cmd:DGRA(}{it:int}{cmd:)}
{cmd:SGRA(}{it:string}{cmd:)}
{cmd:EGRA(}{it:string}{cmd:)}
]



{p}where {p_end}
{p 8 8} {cmd:varlist} is the varname of the variable that contains the code of the economic sectors (string or numeric format). {p_end}


{title:Version} 9.0 and higher.

{title:Description}

{cmd:pciom} is designed to estimate the change in prices of the diferent sectors implies by a change in price(s) of in homogenous good(s) of some sectors, like the petrolium products.  
It is based on the information that can be founed in the usual SAM matrices that contains the information on the level of intensivity of use of each input.   
The IO price models:

{p 4 8}{inp:. Cost push model.}{p_end}
{p 4 8}{inp:. Marginal price model.}{p_end}


{title:Options}


{p 0 4} {cmdab:iomatrix}   To indicate the filename of datafile with (n+1) observations and (n) variables. Except the last observation, the rest forms the square I/O matrix on (n) sectors. The last line of this data file must contain the value added of each sector. {p_end}

{p 0 4} {cmdab:iomodel}   To indicate the IO proche change model. {p_end}

{p 0 4} {cmdab:labsec}   Starting from the oppened data file, that must contain (n+1) observations, the user can indicate variable of labels or short names of sectors. {p_end}

{p 0 4} {cmdab:nshocks}   To indicate the number of sectors with exogenous price shocks. {p_end}

{p 0 4} {cmdab:sepc:1-6}    To indicate the line position of the sector with the exogenous proce shock. {p_end}

{p 0 4} {cmdab:pr:1-6}    To indicate the level of price shock (in %) . {p_end}

{p 0 4} {cmdab:nadp}    For the short term results, the user can indicate the number of the periods of price adjustments. {p_end}

{p 0 4} {cmdab:tyshock}    To indicate this the price shock is permenent (1) or temporal (2). {p_end}

{p 0 4} {cmdab:adshock}    To indicate this the price change is that of the short term or that of the long term. {p_end}

{p 0 4} {cmdab:lres}    If option "1" is selected, the prices are listed. {p_end}

{p 0 4} {cmdab:dgra}    If option "1" is selected, the bar graph of price changes is displayed. By default, the graph is not displayed. {p_end}

{p 0 4} {cmdab:sgra}    To save the graph in Stata format (*.gph), indicate the name of the graph file using this option. {p_end}

{p 0 4} {cmdab:egra}    To export the graph in an EPS or WMF format, indicate the name of the graph file using this option. {p_end}


{title:Reference(s)}
{p 4 4 2}  Araar, A. and P. Verme, 2012, {browse "http:www.subsim.org/ref/note_io.pdf": {Price changes and the input/output model}}, Mimeo.{p_end}



{title:Authors}
Araar, A.  & P. Verme


{title:Contact}
If you note any problems, please contact {bf:Abdelkrim Araar:} {browse "mailto:aabd@ecn.ulaval.ca"}
