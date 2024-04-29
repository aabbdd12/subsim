capture program drop _itsim_vers
program define       _itsim_vers

local  inst_ver   1.00
local  inst_dat  "06April2016"

dis _n
qui include http://dasp.ecn.ulaval.ca/subsim/aitsim/Installer/version
dis _col(5) "- Installed AITSIM"_col(33) ": Version `inst_ver'" _col(50) "| Date: `inst_dat'  "
dis _col(5) "- Available updated AITSIM" _col(33) ": Version $srv_ver " _col(50) "| Date: $srv_dat  "

cap macro drop srv_dat
cap macro drop srv_ver

end


