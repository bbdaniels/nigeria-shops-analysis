// Nigeria post covid survey analysis


// Sample description
use "${git}/data/provider-survey.dta" , clear
  
  graph hbar (sum) n ///
  , over(hf_type_long) over(state_name) ///
    blab(bar) ytit(" ") title("Sample description" , pos(11) span)
    
    graph export "${git}/outputs/img/fac-type.png", replace
    
  graph hbar (sum) n ///
  , over(hf_type_shops) asy stack over(hf_type_long) over(state_name) ///
    ytit(" ") title("Sample description" , pos(11) span) ///
    legend(on c(1) ring(0) symxsize(small) pos(2)) scale(0.7)
    
    graph export "${git}/outputs/img/fac-type-shops.png", replace
    
  replace hf_inpatient = . if hf_inpatient == 0
  graph box hf_inpatient hf_opt  ///
  , scale(0.7) over(hf_type_long, label(angle(30))) over(state_name) ///
    ytit(" ") ylab(1 10 100 1000 10000) yscale(log) title("Facility size and monthly patient load" , pos(11) span) ///
    legend(on c(2) pos(6) ring(1) order(1 "Inpatient Beds" 2 "Monthly Outpatients" ))
    
    graph export "${git}/outputs/img/fac-size.png", replace
    
  replace hf_staff = . if hf_staff == 0
  scatter hf_opt hf_staff  ///
    , yscale(log) xscale(log) by(hf_type, rescale ixaxes iyaxes title("Facility size and staff" , pos(11) span)) ///
      ylab(1 10 100 1000 10000) xlab(1 5 25 125) 
      
      graph export "${git}/outputs/img/fac-size-2.png", replace
    
// Testing
use "${git}/data/provider-survey.dta" , clear
  
  graph hbar (mean) tb_afb tb_cxr tb_gx tb_hiv ///
  , over(hf_type_long) ///
    blab(bar , format(%9.2f)) ytit(" ") title("Facilities offering screening for TB" , pos(11) span) ///
    legend(on c(2) pos(6) ring(1) order(0 "Facilities offering:" 1 "AFB testing" ///
      2 "CXR Testing" 3 "GX Testing" 4 "TB-HIV Testing" )) scale(0.7) 
      
      graph export "${git}/outputs/img/test-tb.png", replace
        
  graph hbar (mean) covid_screen tb_covid covid_gx ///
  , over(hf_type_long) ///
    blab(bar , format(%9.2f)) ytit(" ") title("Facilities offering screening for COVID" , pos(11) span) ///
    legend(on c(2) pos(6) ring(1) order(0 "Facilities offering:" 1 "COVID Screening" 2 "Bi-directional Screening" ///
      3 "COVID GX" )) scale(0.7)
      
      graph export "${git}/outputs/img/test-covid.png", replace

// Telemedicine for TB
use "${git}/data/provider-survey.dta" , clear

  graph hbar (sum) tb_telemed  ///
  , over(hf_type_long) over(state_name) ///
    blab(bar) ytit(" ") title("Facilities offering telemedicine for TB" , pos(11) span)
    
    graph export "${git}/outputs/img/tb-telemed.png", replace
  
  graph hbar (sum) ///
    tb_telemed_1 tb_telemed_2 tb_telemed_3 tb_telemed_4 tb_telemed_5 ///
  , over(hf_type_long) legend(on) blab(bar) title("TB testing modality in telemedicine" , pos(11) span) ///
    legend(on c(2) pos(6) ring(1) order(0 "Facilities offering TB testing via:" 1 "Public Facility" 2 "Pickup/Dropoff" ///
      3 "At-Home Testing" 4 "No Testing" 5 "Private Laboratory")) scale(0.7)
      
    graph export "${git}/outputs/img/tb-telemed-test.png", replace
    
// Pricing



// End
