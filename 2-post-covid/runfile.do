// Runfile for Post-Covid Nigeria Facility Survey 

global box "/Users/bbdaniels/Box/COVET/Standardized Patients/Nigeria"
global git "/Users/bbdaniels/GitHub/nigeria-shops-analysis/2-post-covid"

do "${git}/do/1-makedata.do"
do "${git}/do/2-analysis.do"

// End
