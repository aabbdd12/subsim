

In the Stata command window, type the following commands:

set more off

net from http://wwww.subsim.org/aitsim/Installer 

net install aitsim_part1, force

net install aitsim_part2, force

cap additMenu profile.do _itsim_menu

