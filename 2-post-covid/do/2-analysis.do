// Nigeria post covid survey analysis


// Sample description
use "${git}/data/provider-survey.dta" , clear
  
  graph hbar (sum) n ///
  , over(hf_type_long) over(state_name) ///
    blab(bar) ytit(" ")
    
    graph export "${git}/outputs/img/fac-type.png", replace
    
// Testing
use "${git}/data/provider-survey.dta" , clear
  replace tb_covid = tb_covid - 1
  replace covid_screen = covid_screen != 1
  replace tb_gx = tb_gx != 1
  replace covid_gx = covid_gx > 2
  
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

// End
