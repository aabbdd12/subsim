capture program drop _taxsim_vers
program define       _taxsim_vers

local  inst_ver   1.00
local  inst_dat  "30April2017"

dis _n
qui include http://dasp.ecn.ulaval.ca/subsim/taxsim/Installer/version
dis _col(5) "- Installed TAXSIM"_col(33) ": Version `inst_ver'"        _col(50) "| Date: `inst_dat'  "
dis _col(5) "- Available updated TAXSIM" _col(33) ": Version $srv_ver " _col(50) "| Date: $srv_dat  "

cap macro drop srv_dat
cap macro drop srv_ver

end


