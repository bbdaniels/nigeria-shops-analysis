// Runfile for Nigeria SHOPS program data analysis

global box "/Users/bbdaniels/Box/COVET/SHOPS Data"
global git "/Users/bbdaniels/GitHub/nigeria-shops-analysis"

// Load data

use "${box}/SHOPS Plus Progam Data 2018-2021.dta" , clear
iecodebook apply using "${box}/SHOPS Plus Progam Data 2018-2021 codebook.xlsx"
save "${git}/data/data.dta" , replace

// Telemedicine

// Fig: Cascade by State (Logarithmic)
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
    
// Fig: Availability by date

use "${git}/data/data.dta" , clear
keep if facility_closed_shutdown != .

  // date setup
  keep fac_id close_date1 open_date1 state
    gen close = date(close_date1,"MDY") if regexm(close_date1,"/2020")
      replace close_date1 = close_date1 + "20" if regexm(close_date1,"-20")
      gen c2 = date(close_date1,"DMY") if close == .
      replace close = c2 if close == .
      drop c2 close_date1
    gen open = date(open_date1,"MDY") if regexm(open_date1,"/2020")
      replace open_date1 = open_date1 + "20" if regexm(open_date1,"-20")
      gen o2 = date(open_date1,"DMY") if open == .
      replace open = o2 if open == .
      drop o2 open_date1
      
  // reshape
  ren close d1 
  ren open d2
  reshape long d , j(j) i(fac_id)
  gen open = (d == .)
    egen check = min(d)
      replace d = check if j == 1 & d == .
      drop check
    egen check = max(d)
      replace d = check if j == 2 & d == .
      drop check
  tsset fac_id d
    tsfill , full
    
    bys fac_id : egen l2 = mode(state)
    
    drop j
    
    local o = 1
    qui forv i = 1/`c(N)' {
      if open[`i'] == 0 local o = 1-`o'
      replace open = `o' in `i' if open[`i'] == .
    }
    
    collapse (sum) open , by(d l2) fast
    ren l2 state
    
    format d %tdMon_YY
    
    tw (line open d if d > 21735 & d < 22286) ///
    , yscale(r(1)) ylab(#6) xlab(21731 21915 22097 22281) ///
      by(state , noyrescale title("Facility Closures During COVID", pos(11) span)) ///
      xtit("") ytit("")
      
    
    graph export "${git}/outputs/closures.png" , replace


// End of dofile
