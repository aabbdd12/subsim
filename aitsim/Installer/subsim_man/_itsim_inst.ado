
*! version 1.0
*

capture program drop _itsim_inst
program define _itsim_inst

set more off
net from http://dasp.ecn.ulaval.ca/subsim/aitsim/Installer
net install itsim_part1, force
net install itsim_part2, force
cap addITMenu profile.do _itsim_menu


end


