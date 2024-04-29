In the Stata command window, type the following commands:

set more off
net from  http://wwww.subsim.org/Installer
net install subsim_part1, force
net install subsim_part2, force
cap addSMenu profile.do _subsim_menu

