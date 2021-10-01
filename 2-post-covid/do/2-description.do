// Nigeria post covid survey analysis

// Descriptives table
use "${git}/data/provider-survey.dta" , clear

  local stats hf_age hf_inpatient hf_opt hf_staff ///
    hf_staff_med hf_staff_nurse hf_staff_ppmv ///
    closed_lockdown tb_afb tb_cxr tb_gx tb_test_n telemedicine

  sumstats ///
   (`stats' if hf_type == 1 & state == 1) ///
     (`stats' if hf_type == 2 & state == 1) ///
     (`stats' if hf_type == 3 & state == 1) ///
     (`stats' if hf_type == 4 & state == 1) ///
   (`stats' if hf_type == 1 & state == 2) ///
     (`stats' if hf_type == 2 & state == 2) ///
     (`stats' if hf_type == 3 & state == 2) ///
     (`stats' if hf_type == 4 & state == 2) ///
  using "${git}/outputs/summary.xlsx" ///
  , stats(mean median sd min max n) replace


// Sample description
use "${git}/data/provider-survey.dta" , clear
  
  // Sample description
  graph hbar (sum) n ///
  , over(hf_type_long) over(state_name) ///
    blab(bar) ytit(" ") title("Sample description" , pos(11) span)
    
    graph export "${git}/outputs/img/fac-type.png", replace
  
  // Sample description  
  graph hbar (sum) n ///
  , over(hf_type_shops) asy stack over(hf_type) over(state_name) ///
    ytit(" ") title("Sample description" , pos(11) span) ///
    legend(on c(1) ring(0) symxsize(small) pos(2)) scale(0.7)
    
    graph export "${git}/outputs/img/fac-type-shops.png", replace
  
  // Facility size and monthly patient load  
  replace hf_inpatient = . if hf_inpatient == 0
  graph box hf_inpatient hf_opt  ///
  , scale(0.7) over(hf_type, label(angle(30))) by(state_name , title("Facility capacity and utilization" , pos(11) span)) ///
    ytit(" ") ylab(1 10 100 1000 10000) yscale(log)  ///
    legend(off c(2) pos(6) ring(1) order(1 "Inpatient Beds" 2 "Monthly Outpatients" ))
    
    graph export "${git}/outputs/img/fac-size.png", replace
    
  // Facility size and staffing
  replace hf_staff = . if hf_staff == 0
  tw ///
    (scatter hf_opt hf_staff if hf_type_shops == 1 ///
      , m(X) mlw(vthin) mc(navy) jitter(1))  ///
    (scatter hf_opt hf_staff if hf_type_shops == 2 ///
      , m(Oh) mlw(vthin) mc(red%50) jitter(1))  ///
    (scatter hf_opt hf_staff if hf_type_shops == 3 ///
      , m(Oh) mlw(vthin) mc(black%50) jitter(1))  ///
    , yscale(log) xscale(log) ///
      by(hf_type, rescale ixaxes iyaxes ///
        title("Facility size and staff" , pos(11) span) ///
        legend(on r(1) pos(12) order(1 "Backup" 2 "Non Network" 3 "Shops Plus")) ) ///
      ylab(1 10 100 1000 10000) xlab(1 5 25 125) legend( r(1) order(1 "Backup" 2 "Non Network" 3 "Shops Plus")) 
      
      graph export "${git}/outputs/img/fac-size-2.png", replace
      
   graph bar hf_respondent ///
   , over(hf_type_shops) asy stack over(hf_type_long) 
    
// Testing and Screening
use "${git}/data/provider-survey.dta" , clear
  
  // Facilities offering screening for TB
  betterbar tb_afb tb_cxr tb_gx tb_hiv ///
  , over(hf_type) by(state) n ///
    barlab pct ytit(" ") title("Facilities offering screening for TB" , pos(11) span) ///
    legend(on r(1) pos(6) ring(1) ) scale(0.6) xoverhang 
      
      graph export "${git}/outputs/img/test-tb.png", replace
  
  // Facilities offering screening for COVID      
  betterbar covid_tests_4 covid_tests_5  ///
  , over(hf_type) by(state) n ///
    barlab pct ytit(" ") title("Facilities offering screening for COVID" , pos(11) span) ///
    legend(on r(1) pos(6) ring(1) ) scale(0.6) xoverhang 
      
    graph export "${git}/outputs/img/test-covid.png", replace
      
  // Facility Prices
  betterbar ///
    fee_registration fee_consult tb_afb_price tb_gx_price tb_cxr_price tb_hiv_price  ///
    if (hf_type == 1 | hf_type == 3) ///
  , over(hf_type) title("Prices", span pos(11)) ///
    legend(on c(1) pos(2) ring(0) symxsize(small)) ///
    barlab scale(0.7) ci barcolor(navy maroon)
    
    graph export "${git}/outputs/img/test-prices.png", replace  

// Telemedicine for TB
use "${git}/data/provider-survey.dta" , clear

  // TB Telemedicine Testing Offered
  graph hbar (sum) tb_telemed  ///
  , over(hf_type_long) over(state_name) ///
    blab(bar) ytit(" ") title("Facilities offering telemedicine for TB" , pos(11) span)
    
    graph export "${git}/outputs/img/tb-telemed.png", replace
  
  // TB Telemedicine Testing Modality
  graph hbar (sum) ///
    tb_telemed_1 tb_telemed_2 tb_telemed_3 tb_telemed_4 tb_telemed_5 ///
  , over(hf_type_long) legend(on) blab(bar) title("TB testing modality in telemedicine" , pos(11) span) ///
    legend(on c(2) pos(6) ring(1) order(0 "Facilities offering TB testing via:" 1 "Public Facility" 2 "Pickup/Dropoff" ///
      3 "At-Home Testing" 4 "No Testing" 5 "Private Laboratory")) scale(0.7)
      
    graph export "${git}/outputs/img/tb-telemed-test.png", replace
    
  // TB Telemedicine Yield
  replace tb_telemed_pos = . if tb_telemed_pos == 0
  replace tb_telemed_n = . if tb_telemed_n == 0
  tw ///
    (scatter tb_telemed_pos tb_telemed_n if hf_type_shops == 1 ///
      , m(X) mlw(vthin) mc(navy) jitter(1))  ///
    (scatter tb_telemed_pos tb_telemed_n if hf_type_shops == 2 ///
      , m(Oh) mlw(vthin) mc(red%50) jitter(1))  ///
    (scatter tb_telemed_pos tb_telemed_n if hf_type_shops == 3 ///
      , m(Oh) mlw(vthin) mc(black%50) jitter(1))  ///
    (function x , range(1 100) lw(thin) lc(black)) ///
    , yscale(log) xscale(log) ///
      by(hf_type, rescale ixaxes iyaxes ///
        title("TB Telemedicine Yield" , pos(11) span) ///
        legend(on r(1) pos(12) order(1 "Backup" 2 "Non Network" 3 "Shops Plus")) ) ///
      ylab(1 10 100) xlab(1 10 100) legend( r(1) order(1 "Backup" 2 "Non Network" 3 "Shops Plus")) ///
      xtit("Number of Telemedicine TB Patients Screened In") ytit("Number Tested Positive")
          
    graph export "${git}/outputs/img/tb-telemed-yield.png", replace


// End
