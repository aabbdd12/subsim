


set more off
net from  http://wwww.subsim.org/modules/pciom
net install pciom, force


cd c:/data /* you can update this */

use http://dasp.ecn.ulaval.ca/subsim/modules/pciom/example/iomv.dta
save iomv.dta, replace
use http://dasp.ecn.ulaval.ca/subsim/modules/pciom/example/sec_info.dta, replace
save sec_info.dta, replace


use sec_info.dta, replace
pciom code, labsec(lab_sector) iom(C:\subsim3\example_ind\iomv.dta) nadp(10) nshocks(1) iomodel(1) adshock(1) tyshock(1) secp1(15) pr1(10) dgra(1)
