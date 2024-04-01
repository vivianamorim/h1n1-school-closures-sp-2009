import delimited "$raw/Censo Escolar/Máscaras do Censo Escolar\2005\DADOS_MASCARA.TXT", delimiter(space) clear stringcols(_all) emptylines(skip) 
rename (v5 v7) (codschool MASCARA)
replace codschool = substr(codschool, 5,.)
drop v*
save  "$inter/Máscara2005.dta", replace
