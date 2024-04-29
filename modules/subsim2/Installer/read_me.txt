
Copy the folder subsime in the directory c (or anther emplacement):
Make sure that you have 
c:/subsim2/Installer/stata.toc 
and 
c:/subsim2/Installer/subsim2.pkg ;

In the Stata command window, type the following commands:

set more off
net from c:/subsim2/Installer
net install subsim2_part1, force
net install subsim2_part2, force
cap addSMenu profile.do _subsim_menu

