clear 
set more off
#delimit
infix
str	MASCARA	1-8
str ANO 9-13
str CODMUNIC 14-25
str DEP 128-137
str LOC 138-147
str LAB_INFO 222-222
str LAB_CIEN 223-223
str QUAD_COB 229-229
str GIN_ESP 241-241
str	BIBLIO 245-245
str SAL_LEIT 246-246
str PARA_INT 336-347			//antena parabolica para conexao com internet
str PARAB_INT 468-479			//antena parabolica para conexao com internet
str S_CONEX 581-581 			//conexao internet
str DE9F11G 14061-14072			//5ano
str NE9F11G 14301-14312			//5ano
str DEF11F 3633-3644			//4a serie
str NEF11F 3849-3860			//4a serie
str DE9F11N 14109-14120
str NE9F11L 14217-14228
str DEF11J 3681-3692
str NEF11J 3897-3908
str DEF116 3513-3524			//numero de turmas
str NEF116 3729-3740
str DE9F117 13929-13940
str NE9F117 14169-14180
using "$raw/CensoEscolar_2005/DADOS/CENSOESC_2005.txt";
save "$inter/Pré_2007/CensoEscolar2005.dta", replace;
clear; 
