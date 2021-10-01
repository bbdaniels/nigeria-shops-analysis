// Covid Related Disruptions
use "${git}/data/provider-survey.dta" , clear

  // Closure map
  bys hf_type: gen N = _n
  tw ///
    (rspike close_start_1 close_end_1 N , hor lw(vthin) lc(black)) ///
    (rspike close_start_2 close_end_2 N , hor lw(vthin) lc(black)) ///
    (rspike close_start_3 close_end_3 N , hor lw(vthin) lc(black)) ///
    (rspike close_start_4 close_end_4 N , hor lw(vthin) lc(black)) ///
    (rspike close_start_5 close_end_5 N , hor lw(vthin) lc(black)) ///
  , by(hf_type, yrescale ixaxes legend(off) scale(0.7) imargin(medium) ///
      title("Covid-related facility closures", span pos(11)))  ///
    ylab(none) xlab(,format(%tdMon_YY)) ytit("") xtit("") xoverhang
    
    graph export "${git}/outputs/img/covid-close-all.png", replace
  
  // Closure reasons
  graph bar ///
    closed_lockdown closed_patients closed_protest closed_staff closed_supplies ///
    , over(hf_type) legend(on) blab(bar) title("Covid closure reasons" , pos(11) span) ///
      legend(r(1) pos(12) symxsize(small) order(1 "Lockdown" 2 "Low Demand" 3 "Protests" 4 "Staff Shortage" 5 "Supply Shortage")) ///
      blab(bar, format(%9.1f)) scale(0.7) perc
      
      graph export "${git}/outputs/img/covid-close-why.png", replace
      
  // Neighborhood closures
  use "${git}/data/provider-survey.dta" , clear
    recode covid_close_2 (4=0) 
      lab def covid_close_2 0 "< 25%" , modify
    recode covid_close_4 (3=0) 
      lab def covid_close_4 0 "< 25%" , modify
      
    local x = 0
    qui foreach var of varlist covid_close_1 covid_close_2 covid_close_3 covid_close_4 {
      local ++x
      local lab : var lab `var'
      graph hbar , over(`var') scale(0.7) ///
        title("`lab'", span pos(11)) nodraw blab(bar, format(%9.1f))
      graph save "${git}/outputs/img/changes-`x'.gph" , replace
      local graphs `" `graphs' "${git}/outputs/img/changes-`x'.gph" "'
    }
    
    graph combine `graphs' , imargin(medium) colf title("In your neighborhood...", span pos(11))
    graph export "${git}/outputs/img/covid-close-count.png", replace
    
// Service changes
use "${git}/data/provider-survey.dta" if inlist(hf_type_long,1,3,5,6), clear

  forvalues i = 1/9 {
    foreach var of varlist *_`i' {
      cap replace `var' = 0 if `var' == .
    }
  }
  
  // Long term
  betterbar  ///
    covid_disruption_l_1 covid_disruption_l_2 covid_disruption_l_3 ///
    covid_disruption_l_4 covid_disruption_l_5 covid_disruption_l_6 ///
  , pct barlab xoverhang title("Long Term Disruptions to Clinics" , pos(11) span) ///
    scale(0.8) over(hf_type_long) legend(on) n
  
  graph export "${git}/outputs/img/covid-disruptions-long.png", replace
  
  // Short term
  betterbar  ///
    covid_disruption_s_1 covid_disruption_s_2 covid_disruption_s_3 ///
    covid_disruption_s_4 covid_disruption_s_5 covid_disruption_s_6 ///
  , pct barlab xoverhang title("Short Term Disruptions to Clinics" , pos(11) span) ///
    scale(0.8) over(hf_type_long) legend(on) n
  
  graph export "${git}/outputs/img/covid-disruptions-short.png", replace
  
  // New policies
  betterbar  ///
    covid_new_1 covid_new_2 covid_new_3 covid_new_4 covid_new_5 covid_new_6 covid_new_7 ///
  , pct barlab xoverhang title("New Policies at Clinics" , pos(11) span) ///
    scale(0.8) over(hf_type_long) legend(on) n
  
  graph export "${git}/outputs/img/covid-disruptions-policy.png", replace
  
  // New policies
  betterbar  ///
    covid_ppe covid_ppe_1 covid_ppe_2 covid_ppe_3 covid_ppe_4 covid_ppe_5 covid_ppe_6 ///
  , pct barlab xoverhang title("New Fees for PPE at Clinics" , pos(11) span) ///
    scale(0.8) over(hf_type_long) legend(on) n
  
  graph export "${git}/outputs/img/covid-disruptions-ppe.png", replace
  
  // Shortages
  betterbar  ///
    covid_shortage_1 covid_shortage_2 covid_shortage_3 covid_shortage_4 ///
  , pct barlab xoverhang title("Shortages at Clinics" , pos(11) span) ///
    scale(0.8) over(hf_type_long) legend(on) n
  
  graph export "${git}/outputs/img/covid-disruptions-shortage.png", replace

  // Service cuts
  betterbar  ///
    covid_ended_1 covid_ended_2 covid_ended_3 covid_ended_4 ///
    covid_ended_5 covid_ended_6 covid_ended_7 covid_ended_8 covid_ended_9 ///
  , pct barlab xoverhang title("Service Cuts at Clinics" , pos(11) span) ///
    scale(0.8) over(hf_type_long) legend(on) n
  
  graph export "${git}/outputs/img/covid-disruptions-cuts.png", replace
  
  // Service cuts
  betterbar covid_demographic_change ///
    covid_demo_1 covid_demo_2 covid_demo_3 covid_demo_4 ///
    covid_demo_5 covid_demo_6 covid_demo_7 covid_demo_8 covid_demo_9 ///
  , pct barlab xoverhang title("Patient Demographic Changes at Clinics" , pos(11) span) ///
    scale(0.8) over(hf_type_long) legend(on) n
  
  graph export "${git}/outputs/img/covid-disruptions-demo.png", replace
  
  // Policy impacts
  betterbar covid_policy ///
    covid_policy_1 covid_policy_2 covid_policy_3 ///
    covid_policy_4 covid_policy_5 covid_policy_6 ///
  , pct barlab xoverhang title("Government Policy Impacts at Clinics" , pos(11) span) ///
    scale(0.8) over(hf_type_long) legend(on) n
  
  graph export "${git}/outputs/img/covid-disruptions-govt.png", replace

// End
