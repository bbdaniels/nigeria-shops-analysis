// Nigeria post covid survey analysis


// Sample description
  use "${git}/data/provider-survey.dta" , clear
  
  graph hbar (sum) n ///
  , over(hf_type_long) over(state_name) ///
    blab(bar) ytit(" ")
    
    graph export "${git}/outputs/img/fac-type.png"





// End
