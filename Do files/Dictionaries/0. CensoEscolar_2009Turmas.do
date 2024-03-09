clear 
set more off
#delimit ;
infix
str	ANO_CENSO	1	 - 	5
str	PK_COD_TURMA	6	 - 	16
str	NO_TURMA	17	 - 	96
str	HR_INICIAL	97	 - 	98
str	HR_INICIAL_MINUTO	99	 - 	100
str	NU_DURACAO_TURMA	101	 - 	104
str	NUM_MATRICULAS	105	 - 	109
str	FK_COD_MOD_ENSINO	110	 - 	112
str	FK_COD_ETAPA_ENSINO	113	 - 	116
str	FK_COD_CURSO_PROF	117	 - 	125
str	FK_COD_TIPO_TURMA	126	 - 	128
str	ID_VEZ_ATIVIDADE_COMPLEMENTAR	129	 - 	130
str	FK_COD_TIPO_ATIVIDADE_1	131	 - 	136
str	FK_COD_TIPO_ATIVIDADE_2	137	 - 	142
str	FK_COD_TIPO_ATIVIDADE_3	143	 - 	148
str	FK_COD_TIPO_ATIVIDADE_4	149	 - 	154
str	FK_COD_TIPO_ATIVIDADE_5	155	 - 	160
str	FK_COD_TIPO_ATIVIDADE_6	161	 - 	166
str	ID_BRAILLE	167	 - 	167
str	ID_AUTONOMA	168	 - 	168
str	ID_RECURSOS_BAIXA_VISAO	169	 - 	169
str	ID_PROCESSOS_MENTAIS	170	 - 	170
str	ID_ORIENTACAO_MOBILIDADE	171	 - 	171
str	ID_SINAIS	172	 - 	172
str	ID_COM_ALT_AUMENT	173	 - 	173
str	ID_ENRIQ_CURRICULAR	174	 - 	174
str	ID_SOROBAN	175	 - 	175
str	ID_INF_ACESSIVEL	176	 - 	176
str	ID_PORT_ESC	177	 - 	177
str	ID_QUIMICA	178	 - 	178
str	ID_FISICA	179	 - 	179
str	ID_MATEMATICA	180	 - 	180
str	ID_BIOLOGIA	181	 - 	181
str	ID_CIENCIAS	182	 - 	182
str	ID_LINGUA_LITERAT_PORTUGUESA	183	 - 	183
str	ID_LINGUA_LITERAT_INGLES	184	 - 	184
str	ID_LINGUA_LITERAT_ESPANHOL	185	 - 	185
str	ID_LINGUA_LITERAT_OUTRA	186	 - 	186
str	ID_LINGUA_LITERAT_INDIGENA	187	 - 	187
str	ID_ARTES	188	 - 	188
str	ID_EDUCACAO_FISICA	189	 - 	189
str	ID_HISTORIA	190	 - 	190
str	ID_GEOGRAFIA	191	 - 	191
str	ID_FILOSOFIA	192	 - 	192
str	ID_ENSINO_RELIGIOSO	193	 - 	193
str	ID_ESTUDOS_SOCIAIS	194	 - 	194
str	ID_INFORMATICA_COMPUTACAO	195	 - 	195
str	ID_PROFISSIONALIZANTE	196	 - 	196
str	ID_DISC_ATENDIMENTO_ESPECIAIS	197	 - 	197
str	ID_DISC_DIVERSIDADE_SOCIO_CULT	198	 - 	198
str	ID_LIBRAS	199	 - 	199
str	ID_DISCIPLINAS_PEDAG	200	 - 	200
str	ID_OUTRAS_DISCIPLINAS	201	 - 	201
str	PK_COD_ENTIDADE	202	 - 	210
str	FK_COD_ESTADO	211	 - 	213
str	SIGLA	214	 - 	215
str	FK_COD_MUNICIPIO	216	 - 	223
str	ID_LOCALIZACAO	224	 - 	224
str	ID_DEPENDENCIA_ADM	225	 - 	225
str	DESC_CATEGORIA_ESCOLA_PRIVADA	226	 - 	226
str	ID_CONVENIADA_PP	227	 - 	227
str	ID_TIPO_CONVENIO_PODER_PUBLICO	228	 - 	229
str	ID_MANT_ESCOLA_PRIVADA_EMP	230	 - 	230
str	ID_MANT_ESCOLA_PRIVADA_ONG	231	 - 	231
str	ID_MANT_ESCOLA_PRIVADA_SIND	232	 - 	232
str	ID_MANT_ESCOLA_PRIVADA_S_FINS	233	 - 	233
str	ID_DOCUMENTO_REGULAMENTACAO	234	 - 	234
str	ID_LOCALIZACAO_DIFERENCIADA	235	 - 	235
str	ID_EDUCACAO_INDIGENA	236	 - 	236
using "$raw/Censo Escolar/2009/DADOS/TS_TURMA.txt";
save "$inter/Turmas2009.dta", replace;
clear;
