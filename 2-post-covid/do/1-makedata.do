// Make data for post covid provider survey

insheet using ///
  "${box}/provider-survey-data.csv" ///
  , clear 

iecodebook apply using "${box}/provider-survey-codebook.xlsx" ///
  , drop

// Clean data types

qui foreach var of varlist close* {
  local l : var l `var'
  ren `var' temp
  gen `var' = date(temp,"DMY")
    format `var' %tdMon_DD_YY
    lab var `var' "`l'"
  drop temp
}

qui foreach var of varlist * {
  local t : type `var'
  local l : var l `var'
  if "`t'" == "str3" {
    ren `var' temp
    gen `var' = (temp=="Yes") if temp != ""
      lab var `var' "`l'"
      lab val `var' yesno
    drop temp
  }
  else if strpos("`t'","str") {
    ren `var' temp
    encode temp , gen(`var')
    lab var `var' "`l'"
    drop temp
  }
}

// Data Cleaning
replace hf_opt = . if hf_opt <= 0



// Save

order * , alpha
order hfid state* lga* hf* , first

gen n = 1
  lab var n "COUNTER"

compress
save "${git}/data/provider-survey.dta" , replace

// End
