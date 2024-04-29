
*! version 1.0
*

capture program drop _taxsim_inst
program define _taxsim_inst

set more off
net from http://dasp.ecn.ulaval.ca/subsim/taxsim/Installer
net install taxsim_part1, force
net install taxsim_part2, force
net install taxsim_part3, force
cap addITMenu profile.do _taxsim_menu


end


