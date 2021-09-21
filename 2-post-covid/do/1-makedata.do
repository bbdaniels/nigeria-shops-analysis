// Make data for post covid provider survey

clear all

insheet using ///
  "${box}/provider-survey-data.csv" ///
  , clear 

iecodebook apply using "${box}/provider-survey-codebook.xlsx" ///
  , drop
  
// Values

replace hf_type_long = "PPMV" if regexm(hf_type_long,"Patent")

// Clean data types

qui foreach var of varlist close_* {
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
  if "`t'" == "str21" {
    replace `var' = "" if length(`var') > 4
    compress `var'
    local t : type `var'
  }
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
  else {
    cap replace `var' = . if `var' < 0
  }
}

// Labelling
lab def hf_type 1 "Clinic" 2 "Pharmacy" 3 "Laboratory" 4 "PPMV" , replace

lab val closed_* yesno

// Data Cleaning
replace hf_opt = . if hf_opt <= 0

lab val tb_covid yesno
  replace tb_covid = tb_covid - 1
lab val covid_screen yesno
  replace covid_screen = covid_screen != 1 if !missing(covid_screen)
lab val tb_gx yesno
  replace tb_gx = tb_gx != 1 if !missing(tb_gx)
lab val covid_gx yesno
  replace covid_gx = covid_gx > 2 if !missing(covid_gx)

// Save

order * , alpha
order hfid state* lga* hf* , first

gen n = 1
  lab var n "COUNTER"

qui compress
save "${git}/data/provider-survey.dta" , replace

// End
