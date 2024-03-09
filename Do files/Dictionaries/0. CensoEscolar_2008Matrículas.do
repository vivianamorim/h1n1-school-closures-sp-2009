clear
set more off
foreach i in SP { //RO AC AM RR PA AP TO MA PI CE RN PB PE AL SE BA MG ES RJ SP PR SC RS MS MT GO DF 
#delimit ;
infix
str	ANO_CENSO	1	 - 	8
str	PK_COD_MATRICULA	9	 - 	24
str	FK_COD_ALUNO	25	 - 	40
str	NU_DIA	41	 - 	46
str	NU_MES	47	 - 	52
str	NU_ANO	53	 - 	60
str	NUM_IDADE	61	 - 	68
str	TP_SEXO	69	 - 	69
str	TP_COR_RACA	70	 - 	70
str	TP_NACIONALIDADE	71	 - 	71
str	FK_COD_PAIS_ORIGEM	72	 - 	78
str	FK_COD_ESTADO_NASC	79	 - 	84
str	SGL_UF_NASCIMENTO	85	 - 	86
str	FK_COD_MUNICIPIO_DNASC	87	 - 	102
str	FK_COD_ESTADO_END	103	 - 	108
str	SIGLA_END	109	 - 	110
str	FK_COD_MUNICIPIO_END	111	 - 	126
str	ID_ZONA_RESIDENCIAL	127	 - 	127
str	ID_TIPO_ATENDIMENTO	128	 - 	128
str	ID_N_T_E_P	129	 - 	129
str	ID_RESPONSAVEL_TRANSPORTE	130	 - 	130
str	ID_POSSUI_NEC_ESPECIAL	131	 - 	131
str	ID_TIPO_NEC_ESP_CEGUEIRA	132	 - 	132
str	ID_TIPO_NEC_ESP_BAIXA_VISAO	133	 - 	133
str	ID_TIPO_NEC_ESP_SURDEZ	134	 - 	134
str	ID_TIPO_NEC_ESP_DEF_AUDITIVA	135	 - 	135
str	ID_TIPO_NEC_ESP_SURDO_CEGUEIRA	136	 - 	136
str	ID_TIPO_NEC_ESP_DEF_FISICA	137	 - 	137
str	ID_TIPO_NEC_ESP_DEF_MENTAL	138	 - 	138
str	ID_TIPO_NEC_ESP_TRANSTORNOS	139	 - 	139
str	ID_TIPO_NEC_ESP_SINDROME_DOWN	140	 - 	140
str	ID_TIPO_NEC_ESP_DEF_MULTIPLAS	141	 - 	141
str	ID_TIPO_NEC_ESP_SUPERDOTACAO	142	 - 	142
str	ID_NEC_APO_ESP_PEDAGOGICO	143	 - 	143
str	FK_COD_MOD_ENSINO	144	 - 	149
str	FK_COD_ETAPA_ENSINO	150	 - 	155
str	PK_COD_TURMA	156	 - 	169
str	FK_COD_CURSO_PROF	170	 - 	179
str	COD_UNIFICADA	180	 - 	191
str	FK_COD_TIPO_TURMA	192	 - 	197
str	PK_COD_ENTIDADE	198	 - 	209
str	FK_COD_ESTADO_ESCOLA	210	 - 	215
str	SIGLA_ESCOLA	216	 - 	217
str	COD_MUNICIPIO_ESCOLA	218	 - 	233
str	ID_LOCALIZACAO_ESC	234	 - 	234
str	ID_DEPENDENCIA_ADM_ESC	235	 - 	235
str	DESC_CATA_ESCOLA_PRIV	236	 - 	236
str	ID_CONVENIADA_PP_ESC	237	 - 	237
str	ID_TIPO_CONVENIO_PODER_PUBLICO	238	 - 	238
str	ID_MANT_ESCOLA_PRIVADA_EMP	239	 - 	239
str	ID_MANT_ESCOLA_PRIVADA_ONG	240	 - 	240
str	ID_MANT_ESCOLA_PRIVADA_SIND	241	 - 	241
str	ID_MANT_ESCOLA_PRIVADA_APAE	242	 - 	242
str	ID_DOCUMENTO_REGULAMENTACAO	243	 - 	243
str	ID_LOCALIZACAO_DIFERENCIADA	244	 - 	244
str	ID_EDUCACAO_INDIGENA	245	 - 	245
using "$raw/Censo Escolar/2008/DADOS/TS_MATRICULA_`i'.txt";
save "$inter/Matrículas2008`i'.dta", replace;
clear; 
};

