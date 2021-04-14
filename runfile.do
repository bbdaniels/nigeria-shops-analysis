// Runfile for Nigeria SHOPS program data analysis

global box "/Users/bbdaniels/Box/COVET/SHOPS Data"
global git "/Users/bbdaniels/GitHub/nigeria-shops-analysis"

// Load data

use "${box}/SHOPS Plus Progam Data 2018-2021.dta" , clear
iecodebook apply using "${box}/SHOPS Plus Progam Data 2018-2021 codebook.xlsx"
save "${git}/data/data.dta" , replace


// Fig: Cascade by State
use "${git}/data/data.dta" , clear

  collapse ///
    (sum) attendance_total screened_total presumptives_total diagnosed_total ///
  , by(year month state) fast
  
  drop if attendance_total == 0
  
  gen t_string = string(month) + "/" + string(year)
    gen t = date(t_string,"MY")
    format t %tdMon_YY
  
  tw ///
    (area attendance_total t , lw(none) fc(navy%50)) ///
    (area screened_total t , lw(thin) lc(black) fc(navy%50)) ///
    (area presumptives_total t , lw(none) fc(black)) ///
    (area diagnosed_total t , lw(none) fc(red)) ///
  , yscale(r(1)) ylab(#6) yscale(log) ylab(1 "0" 10 100 1000 10000 100000) ///
    xsize(7) xlab(21550 21731 21915 22097 22281) xtit("Month") ///
    by(state, legend(pos(12)) title("Case Cascade by State, Logarithmic", pos(11) span))  ///
    legend(r(1) size(small) symxsize(small) symysize(small) ///
      order(1 "Total OPD" 2 "Total Screened" 3 "Total Presumptive" 4 "Total Diagnosed"))
      
    graph export "${git}/outputs/state.png" , replace

// End of dofile
