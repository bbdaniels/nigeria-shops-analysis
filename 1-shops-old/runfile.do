// Runfile for Nigeria SHOPS program data analysis

global box "/Users/bbdaniels/Box/COVET/SHOPS Data"
global git "/Users/bbdaniels/GitHub/nigeria-shops-analysis/1-shops-old"

// Load data

use "${box}/SHOPS Plus Progam Data 2018-2021.dta" , clear
iecodebook apply using "${box}/SHOPS Plus Progam Data 2018-2021 codebook.xlsx"
drop if year == 2021

  egen cases_private = rsum(cases_starttrt_pvthosp_total ontreat_pvtfac_total)
  egen cases_public = rsum(ref_pubhosp_total cases_starttrt_pubhosp_total)

save "${git}/data/data.dta" , replace

// TX types
use "${git}/data/data.dta" , clear

  collapse (sum) cases_private cases_public ///
    , by(year month state) fast
    
      gen t_string = string(month) + "/" + string(year)
        gen t = date(t_string,"MY")
        format t %tdMon_YY
              
        levelsof t , local(levels)
        local x = 0
        local base = 2019
        foreach level in `levels' {
          local ++x
          local l = substr("`:word `=month(`level')' of `c(Mons)''",1,1) 
            if `=month(`level')' == 1 local l = `" "{bf:J}" "{bf:`base'}{&rarr}""'
            if `=month(`level')' == 1 local ++base
          local lab = `"`lab'"' + `" `x' `"`l'"' "'
        }

  graph bar (sum)  cases_private cases_public ///
  , stack over(t , relabel(`lab') ) by(state , title("Treatment") c(1) legend( pos(3))) ///
    legend(c(1) symxsize(small) symysize(small) order(2 "Public" 1 "Private" ))
    
    graph export "${git}/outputs/img/treat-state.png" , replace
    outsheet using "${git}/outputs/data/treat-state.csv" , comma replace
    
use "${git}/data/data.dta" , clear

  replace fac_type = "Clinical Facility" if fac_type == "Clinical Faclity"
  drop if fac_type == "Hospital" 

  collapse (sum)  cases_private cases_public ///
    , by(year month state fac_type) fast
    
      gen t_string = string(month) + "/" + string(year)
        gen t = date(t_string,"MY")
        format t %tdMon_YY
              
        levelsof t , local(levels)
        local x = 0
        local base = 2019
        foreach level in `levels' {
          local ++x
          local l = substr("`:word `=month(`level')' of `c(Mons)''",1,1) 
            if `=month(`level')' == 1 local l = `" "{bf:J}" "{bf:`base'}{&rarr}""'
            if `=month(`level')' == 1 local ++base
          local lab = `"`lab'"' + `" `x' `"`l'"' "'
        }

  graph bar (sum) cases_private cases_public ///
  , stack over(t , relabel(`lab') ) by(state fac_type , title("Treatment") c(2) iscale(*.55) colfirst ixaxes yrescale legend( pos(3))) ///
    legend(c(1) symxsize(small) symysize(small) order(2 "Public" 1 "Private"))
    
    graph export "${git}/outputs/img/treat-fac_type.png" , replace
    outsheet using "${git}/outputs/data/treat-fac_type.csv" , comma replace

// Diagnosis types
use "${git}/data/data.dta" , clear

  collapse (sum) diagnosed_xpert_total diagnosed_afb_total diagnosed_other_total ///
    , by(year month state) fast
    
      gen t_string = string(month) + "/" + string(year)
        gen t = date(t_string,"MY")
        format t %tdMon_YY
              
        levelsof t , local(levels)
        local x = 0
        local base = 2019
        foreach level in `levels' {
          local ++x
          local l = substr("`:word `=month(`level')' of `c(Mons)''",1,1) 
            if `=month(`level')' == 1 local l = `" "{bf:J}" "{bf:`base'}{&rarr}""'
            if `=month(`level')' == 1 local ++base
          local lab = `"`lab'"' + `" `x' `"`l'"' "'
        }

  graph bar (sum) diagnosed_xpert_total diagnosed_afb_total diagnosed_other_total ///
  , stack over(t , relabel(`lab') ) by(state , c(1) legend( pos(3))) ///
    legend(c(1) symxsize(small) symysize(small) order(3 "Other" 2 "AFB" 1 "Xpert" ))
    
    graph export "${git}/outputs/img/cases-state.png" , replace
    outsheet using "${git}/outputs/data/cases-state.csv" , comma replace
    
use "${git}/data/data.dta" , clear

  replace fac_type = "Clinical Facility" if fac_type == "Clinical Faclity"
  drop if fac_type == "Hospital" 

  collapse (sum) diagnosed_xpert_total diagnosed_afb_total diagnosed_other_total ///
    , by(year month state fac_type) fast
    
      gen t_string = string(month) + "/" + string(year)
        gen t = date(t_string,"MY")
        format t %tdMon_YY
              
        levelsof t , local(levels)
        local x = 0
        local base = 2019
        foreach level in `levels' {
          local ++x
          local l = substr("`:word `=month(`level')' of `c(Mons)''",1,1) 
            if `=month(`level')' == 1 local l = `" "{bf:J}" "{bf:`base'}{&rarr}""'
            if `=month(`level')' == 1 local ++base
          local lab = `"`lab'"' + `" `x' `"`l'"' "'
        }

  graph bar (sum) diagnosed_xpert_total diagnosed_afb_total diagnosed_other_total ///
  , stack over(t , relabel(`lab') ) by(state fac_type , c(2) iscale(*.55) colfirst ixaxes yrescale legend( pos(3))) ///
    legend(c(1) symxsize(small) symysize(small) order(3 "Other" 2 "AFB" 1 "Xpert" ))
    
    graph export "${git}/outputs/img/cases-fac_type.png" , replace
    outsheet using "${git}/outputs/data/cases-fac_type.csv" , comma replace


// Costs
use "${git}/data/data.dta" , clear

graph hbox cost_of_*_test telecmedicine_service_cost cost_of_registration ///
  , noout over(fac_type) ylab(0 1000 "1k" 2000 "2k" 3000 "3k" 4000 "4k" 5000 "5k") ///
  by(state,  ///
      c(2) title("Cost of Services by Facility Type", pos(11) span)) ///
      legend(order(1 "Sputum" 2 "GeneXpert" 3 "X-Ray" 4 "HIV" 5 "Telemedicine" 6 "Registration"))
      
      graph export "${git}/outputs/img/costs.png" , replace

// Telemedicine
use "${git}/data/data.dta" , clear

  replace lga = proper(lga)
  replace fac_type = "Clinical Facility" if fac_type == "Clinical Faclity"
  drop if fac_type == "Hospital" 
  
  graph hbar telemedicine_service ///
  , blabel(bar, format(%9.2f) size(tiny)) nofill ///
    by(state, title("Telemedicine Availability by LGA", pos(11) span)) ///
    over(lga , label(labsize(tiny)))  ///
    ysize(6) ylab(0 "0%" .5 "50%" 1 "100%") ytit("") 
    
    graph export "${git}/outputs/img/telemedicine.png" , replace
    
  graph hbar telemedicine_service ///
  , blabel(bar, format(%9.2f) size(small)) nofill ///
    by(state, title("Telemedicine Availability by Type", pos(11) span)) ///
    over(fac_type , label(labsize(small)))  ///
    ylab(0 "0%" .5 "50%" 1 "100%") ytit("") 
    
    graph export "${git}/outputs/img/telemedicine2.png" , replace
    
// Telemedicine
use "${git}/data/data.dta" , clear

  replace lga = proper(lga)
  replace fac_type = "Clinical Facility" if fac_type == "Clinical Faclity"
  drop if fac_type == "Hospital" 
  
  graph hbar (sum) telemedicine_service (count) telemedicine_service  ///
  , bargap(-100) nofill ///
    by(state, title("Telemedicine Availability by LGA", pos(11) span)) ///
    over(lga , label(labsize(tiny)))  ///
    ysize(6) ytit("")  legend(order(1 "Telemedicine" 2 "No Telemedicine") size(small))
    
    graph export "${git}/outputs/img/telemedicine3.png" , replace
    tabout lga telemedicine_service using "${git}/outputs/img/telemedicine3.csv" , style(csv) replace
    
  graph hbar (sum) telemedicine_service (count) telemedicine_service  ///
  , bargap(-100) nofill ///
    by(state, c(1) title("Telemedicine Availability by LGA", pos(11) span)) ///
    over(fac_type , label(labsize(small)))  ///
    ysize(6) ytit("")  legend(order(1 "Telemedicine" 2 "No Telemedicine") size(small))
    
    graph export "${git}/outputs/img/telemedicine4.png" , replace
    tabout fac_type telemedicine_service using "${git}/outputs/img/telemedicine4.csv" , style(csv) replace

// Reporting by date
use "${git}/data/data.dta" , clear
  
  collapse (count) attendance_total , by(state fac_type year month)
    replace fac_type = "Clinical Facility" if fac_type == "Clinical Faclity"
    drop if fac_type == "Hospital"
  
  gen t_string = string(month) + "/" + string(year)
    gen t = date(t_string,"MY")
    format t %tdMon_YY
    
    tw (line attendance_total t) ///
    , by(state fac_type , c(2) colfirst ixaxes yrescale ///
         title("Facilities Reporting Over Time", pos(11) span)) ///
      yscale(r(0)) ylab(#3) xtit("") ytit("")
      
      graph export "${git}/outputs/img/reporting.png" , replace
      outsheet using "${git}/outputs/data/reporting.csv" , comma replace
      
    
  

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
      
    graph export "${git}/outputs/img/state.png" , replace
    outsheet using "${git}/outputs/data/state.csv" , comma replace
    
// Fig: Cascade by State, type (Logarithmic)
use "${git}/data/data.dta" , clear

    replace fac_type = "Clinical Facility" if fac_type == "Clinical Faclity"
    drop if fac_type == "Hospital"

  collapse ///
    (sum) attendance_total screened_total presumptives_total diagnosed_total ///
  , by(year month state fac_type) fast
  
  drop if attendance_total == 0
  
  gen t_string = string(month) + "/" + string(year)
    gen t = date(t_string,"MY")
    format t %tdMon_YY
    
    replace diagnosed_total = 1 if diagnosed_total == 0
  
  tw ///
    (area presumptives_total t , lw(none) fc(black)) ///
    (area diagnosed_total t , lw(none) fc(red)) ///
  , yscale(r(1)) ylab(#3) yscale(log) ylab(1 "0" 10 100 1000 , labsize(small)) ///
    xsize(7) xlab(21550 21731 21915 22097 22281) xtit("Month") ///
    by(state fac_type, c(2) colfirst ixaxes yrescale legend(pos(12)) ///
      title("Case Cascade by State, Logarithmic", pos(11) span))  ///
    legend(r(1) size(small) symxsize(small) symysize(small) ///
      order(1 "Total Presumptive" 2 "Total Diagnosed")) ysize(6)
      
    graph export "${git}/outputs/img/cascade-type.png" , replace
    outsheet using "${git}/outputs/data/cascade-type.csv" , comma replace
    
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
      
    
    graph export "${git}/outputs/img/closures.png" , replace
    outsheet using "${git}/outputs/data/closures.csv" , comma replace


// End of dofile
