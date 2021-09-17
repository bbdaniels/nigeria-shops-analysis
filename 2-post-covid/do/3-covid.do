// Covid Related Disruptions
use "${git}/data/provider-survey.dta" , clear
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

// Post covid changes
use "${git}/data/provider-survey.dta" , clear
  graph hbar ///
    covid_ppe covid_ppe_1 covid_ppe_2 covid_ppe_3 covid_ppe_4 covid_ppe_5 covid_ppe_6 ///
    if hf_type_shops > 1 & !missing(hf_type_shops) ///
    , legend(on) over(hf_type_shops)
    
use "${git}/data/provider-survey.dta" , clear
  local x = 0
  qui foreach var of varlist *change {
    local ++x
    local lab : var lab `var'
    graph hbar , over(`var') title("`lab'", size(vsmall) span pos(11)) nodraw blab(bar, format(%9.1f))
    graph save "${git}/outputs/img/changes-`x'.gph" , replace
    local graphs `" `graphs' "${git}/outputs/img/changes-`x'.gph" "'
  }
  
  graph combine `graphs' , c(1) imargin(0)
    graph export "${git}/outputs/img/test-prices-change.png", replace
    
// End
