

In the Stata command window, type the following commands:


set more off

net from http://wwww.subsim.org/taxsim/Installer 

net install taxsim_part1, force

net install taxsim_part2, force
net install taxsim_part3, force

cap additMenu profile.do _taxsim_menu

