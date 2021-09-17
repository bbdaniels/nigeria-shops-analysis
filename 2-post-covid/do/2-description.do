// Nigeria post covid survey analysis

// Sample description
use "${git}/data/provider-survey.dta" , clear
  
  // Sample description
  graph hbar (sum) n ///
  , over(hf_type_long) over(state_name) ///
    blab(bar) ytit(" ") title("Sample description" , pos(11) span)
    
    graph export "${git}/outputs/img/fac-type.png", replace
  
  // Sample description  
  graph hbar (sum) n ///
  , over(hf_type_shops) asy stack over(hf_type_long) over(state_name) ///
    ytit(" ") title("Sample description" , pos(11) span) ///
    legend(on c(1) ring(0) symxsize(small) pos(2)) scale(0.7)
    
    graph export "${git}/outputs/img/fac-type-shops.png", replace
  
  // Facility size and monthly patient load  
  replace hf_inpatient = . if hf_inpatient == 0
  graph box hf_inpatient hf_opt  ///
  , scale(0.7) over(hf_type_long, label(angle(30))) over(state_name) ///
    ytit(" ") ylab(1 10 100 1000 10000) yscale(log) title("Facility capacity and utilization" , pos(11) span) ///
    legend(on c(2) pos(6) ring(1) order(1 "Inpatient Beds" 2 "Monthly Outpatients" ))
    
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
  graph hbar (mean) tb_afb tb_cxr tb_gx tb_hiv ///
  , over(hf_type_long) ///
    blab(bar , format(%9.2f)) ytit(" ") title("Facilities offering screening for TB" , pos(11) span) ///
    legend(on c(2) pos(6) ring(1) order(0 "Facilities offering:" 1 "AFB testing" ///
      2 "CXR Testing" 3 "GX Testing" 4 "TB-HIV Testing" )) scale(0.7) 
      
      graph export "${git}/outputs/img/test-tb.png", replace
  
  // Facilities offering screening for COVID      
  graph hbar (mean) covid_screen tb_covid covid_gx ///
  , over(hf_type_long) ///
    blab(bar , format(%9.2f)) ytit(" ") title("Facilities offering screening for COVID" , pos(11) span) ///
    legend(on c(2) pos(6) ring(1) order(0 "Facilities offering:" 1 "COVID Screening" 2 "Bi-directional Screening" ///
      3 "COVID GX" )) scale(0.7)
      
    graph export "${git}/outputs/img/test-covid.png", replace
      
  // Facility Prices
  graph hbar (mean) ///
    fee_registration fee_consult tb_afb_price tb_gx_price tb_cxr_price tb_hiv_price  ///
    if hf_type_shops != 1 ///
  , over(hf_type) by(hf_type_shops , legend(on pos(3)) title("Prices", span pos(11))) ///
    legend(c(1) symxsize(small) order(1 "Registration" 2 "Consultation" 3 "AFB" 4 "GX" 5 "CXR" 6 "HIV")) ///
    blab(bar, format(%9.0f)) scale(0.7)
    
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
