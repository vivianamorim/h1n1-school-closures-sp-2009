
	*________________________________________________________________________________________________________________________________* 
	**
	**
	**SCHOOL DATASET	
	**
	*________________________________________________________________________________________________________________________________* 

	/*	
	
	**
	*Student dataset, Prova Brasil
	
		-> TEACHER MOTIVATION in math/portuguese.  Variable defined based on how frequently the teacher corrects the homework. 
				Sempre 				(1 = 1) 
				De vez em quando 	(2 = 0.5)
				Nunca				(3 = 0) 
				
				The dataset is organized at student level. The teacher motivation at school level would be an average of students' answers. 
				recode 		hw_corrected_port  (1 = 1) (2 = 0.5) (3 = 0) (4 = .), 				gen (teacher_motivation_port) 
				recode 		hw_corrected_math  (1 = 1) (2 = 0.5) (3 = 0) (4 = .), 				gen (teacher_motivation_math) 

				
	**
	*Teacher dataset, Prova Brasil
	
		-> PRINCIPAL EFFORT. Variable defined based on teacher's anwers of how frequenfly the principal: 
			
			Motivates them. 
			If they fell the principal trust them. 
			If the principal suggest innovations
			IF the principal pays attention to students learning
			if The principal follows the norms
			If the principal pays attention to school's mantainence
			If the principal treats them with respect. 
			If the principals let them participate of work decisions
			If the principal support their ideas. 
			
			Sempre 				(1 = 1) 
			Frequentemente		(2 = 0.66)
			De vez em quando 	(3 = 0.33)
			Nunca				(4 = 0)
				
			The average of these anwers at teacher level gives the principal effort according to teacher's perspective.
			The principal effort at school level is an average of these perspective. 

			egen 	temp1 = rowmiss(principal_motivation-my_ideas)
			foreach var of varlist  principal_motivation-my_ideas{
					recode `var' (1=0) (2=0.33) (3=0.66) (4=1), gen(II_`var')
			}
			egen 	principal_effort = rowmean(II_*) if temp1 < 4
			drop 	II_* temp1

			
		-> STUDENTS' EFFORT Variable defined based on teacher's anwers of what is associated with student's low performance. 
			**
			egen 	temp1 = 			    rowmiss(def_student_loweffort def_absenteeism def_bad_behavior)
			
			foreach var of varlist 					def_student_loweffort 				  def_bad_behavior {
				recode `var'				 (0 = 1) (1 = 0), gen (I_`var')
			}
				recode def_absenteeism		 (0 = 1) (1 = 0.5) (2 = 0)
			
			
			egen 	student_effort_teacherpers   = rowmean(I_def_student_loweffort I_def_absenteeism I_def_bad_behavior)
			replace student_effort_teacherpers  = . if temp1 > 1

			
		-> PARENTS' EFFORT
		
			1 if the parents support children and 0 otherwise. 
			
			Since the dataset is at teacher level, the variable principal effort and teacher effort at school level is an average of teacher's answers. 

			recode def_noparents_support (1 = 0) (0 = 1), gen(parents_effort_teacherpers)  

		
	**
	*Principal's dataset
	
		-> TEACHER EFFORT. Based on teacher absenteeism and turnover. teacher_effort_principalpers
		
		-> STUDENT EFFORT. Based on students absenteeism and bad behavior in class. student_effort_principalpers

			Not an issue 			(0 = 1)
			Small issue  			(2 = 0.5)
			A moderate/big issue 	(3 = 0)

	*/

	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*IDESP at school level	(Performance Assessment of state-managed schools in Sao Paulo)																										
	*________________________________________________________________________________________________________________________________* 
	**	
	/*
	
	In 2008, the state government implemented a management program in low-performing schools in Sao Paulo.
	
	We use data from the performance assessment of the state to identify the treated schools since the intervention was implemented 
	
	in the bottom 5%.
	
	*/
	{

		*----------------------------------------------------------------------------------------------------------------------------*
		
		foreach etapa in AI AF EM { //AI -> 5grade, AF -> 9 grade, EM - > High School
		
			import 		delimited "$raw/IDESP/IDESP por Escola - 2007_2019_`etapa'.csv", delimiter(";")  clear 
			
			**
			**
			if 			"`etapa'" == "AI" local name = "5grade"
			if 			"`etapa'" == "AF" local name = "9grade"
			if 			"`etapa'" == "EM" local name = "EM"
				
			**
			**
			local 	 		year = 2007
			foreach 		var of varlist v7-v19 {
				rename 	   `var' idesp_`name'`year'
				local 		year =			 `year' + 1
			}
			
			**
			**
			drop 		 if missing(codigoinep)
			drop 		 nivelensino codigocie diretoria
			
			**
			**
			reshape 	 long idesp_`name', i(codigoinep  escola municipio) j(year)
			tempfile 	`etapa'
			save       ``etapa''
		}
			
		**
		**
		merge 			1:1 codigoinep year using `AI', nogen
		merge 			1:1 codigoinep year using `AF', nogen
		
		**
		**
		foreach 		 var of varlist idesp* {
			replace  	`var' = subinstr(`var', ",",".",.)
			destring	`var', replace
		}
		
		rename 			(codigoinep  escola municipio) (codschool school muni)
		
		**
		**
		compress
		save 			"$inter/IDESP.dta", replace
	}

	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Bottom 5% schools are the ones included in the program																									
	*________________________________________________________________________________________________________________________________* 
	**	
	{
	
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Bottom 5% in 2007, included in the intervention in 2008
		**

		use 		"$inter/IDESP.dta" if year == 2007, clear 		//selected schools included in the intervention in 2008 
		
			**
			**
			by			year, sort: quantiles idesp_EM,     gen(percentile_EM)      stable  nq(100)
			by	 		year, sort: quantiles idesp_5grade, gen(percentile_5grade)  stable  nq(100)
			by 			year, sort: quantiles idesp_9grade, gen(percentile_9grade)  stable  nq(100)
				
			**
			**
			gen 		school_management_program  			=  1 if (percentile_EM < 6 | percentile_5grade < 6 | percentile_9grade < 6) 
			replace 	school_management_program   		=  0 if (percentile_EM > 5 & percentile_5grade > 5 & percentile_9grade > 5) 
			replace 	school_management_program 			=  . if  missing(percentile_EM) & missing(percentile_5grade) & missing(percentile_9grade)
			
			**
			**
			keep 	if 	school_management_program == 1 
			keep 		school_management_program codschool  
			
			
			**
			tempfile 	treatment_management_program
			save 	   `treatment_management_program'
			
			
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Bottom 5% in 2008, included in the intervention in 2009
		**
		use 	   	"$inter/IDESP.dta" if year == 2008, clear  		//selected schools in 2009
			
			**
			**
			by 			year, sort: quantiles idesp_EM,     gen(percentile_EM)      stable  nq(100)
			by 			year, sort: quantiles idesp_5grade, gen(percentile_5grade)  stable  nq(100)
			by 			year, sort: quantiles idesp_9grade, gen(percentile_9grade)  stable  nq(100)
				
			**
			**
			gen 		school_management_program  			=  1 if 		(percentile_EM < 6 	| 		  percentile_5grade  < 6 | 			 percentile_9grade < 6) 
			replace 	school_management_program   		=  0 if 		(percentile_EM > 5 	& 		  percentile_5grade  > 5 & 			 percentile_9grade > 5) 
			replace 	school_management_program 			=  . if  missing(percentile_EM) 	& missing(percentile_5grade) 	 & 	 missing(percentile_9grade)
			
			**
			**
			
			keep 	 if school_management_program == 1
			keep 		school_management_program codschool
						
			**
			**
			append 		using `treatment_management_program'					//the schools included in 2008 were also included in 2009
	
			**
			**
			duplicates 	drop codschool, force									//each row in a school included in the Program
			
			gen 		year = 2009
			
			tempfile 		   2009
			save 			  `2009'
			
			
			use 		`treatment_management_program', clear				    //schools included in 2008
			gen 		year = 2008
			
			append		using `2009'										    //schools included in 2009
			
			**
			sort 			 codschool
			compress
			save 		"$inter/Managerial Practices Program.dta", replace		//list of state schools included in this intervention
	}		
		
		
		
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Share of teachers working in state-managed schools that implemented the managerial practices program																							
	*________________________________________________________________________________________________________________________________* 
	**	
	/*
	
	Some teachers of state-managed schools included in the Management Program also work in a state-school
	
	not included in the intervention or in a locally-managed school. We are going to identify the schools that have at least 
	
	one teacher in this situation and also the % of teachers in this situation. 
	
	*/
	*-------------------------------------------------------------------------------------------------------------------------------*
	{
	use 		"$inter/Código de Identificação dos professores" 				if (network == 2 | network == 3) & (year == 2007 | year == 2009 | year  == 2008) & coduf == 35, clear		//Censo Escolar Data, each row is a teacher and a school where he/she works
																																																//the same codteacher can be in more than a row if the teacher works in different schools
		**
		**
		merge 		m:1 year codschool using "$inter/Managerial Practices Program.dta", nogen keepusing(school_management_program) keep (1 3)													//identifying the schools included in the Management Program. 

		
		**
		**
		bys 		year codteacher : egen teacher_management_program =   max(school_management_program)																						//identifying the teachers that work in state-managed schools included in the Management Program. 
					
		replace 						   teacher_management_program = 0 if teacher_management_program == .
		clonevar 					 share_teacher_management_program = 	 teacher_management_program 

		
		**
		**
		gen 		T   		= .																  //1 for closed schools, 0 otherwise
		gen 		G	  		= 1																  //0 for the 13 municipalities that extended the winter break, 1 otherwise
		foreach 	munic in $treated_municipalities {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
			replace T   		= 1 		if codmunic == `munic' & network == 3
			replace G	  	  	= 0 		if codmunic == `munic'
		}		
		replace 	T    		= 1 		if network == 2
		replace		T    		= 0 		if T == .

		
		**
		**
		tab 		year teacher_management_program if network == 3 & Teacher5grade == 1 & T == 1 &  year == 2009   //teachers included in the management program intervention that are also working in locally-managed schools in T == 1
		tab 		year teacher_management_program if network == 3 & Teacher5grade == 1 & T == 0 &  year == 2009   //teachers included in the management program intervention that are also working in locally-managed schools in T == 0
		//in T = 1. 4%   of 5th grade teachers of municipal schools also worked on a state managed school that had the managerial practices intervention implemented
		//in T = 0. 1.5%
		
		tab 		year teacher_management_program if network == 2 & Teacher5grade == 1 & G == 0 &  year == 2009  
		tab 		year teacher_management_program if network == 2 & Teacher5grade == 1 & G == 1 &  year == 2009  
		//in G = 0. 18.5% of teachers work in a state managed school that implemented the program
		//in G = 1. 13.4% of teachers work in a state managed school that implemented the program.
		
		**
		**
		collapse 	(max) teacher_management_program   (max)school_management_program  (mean)share_teacher_management_program , by(codschool network year T G year) 				
	
		**
		**
		replace 		  school_management_program = 0 if  school_management_program == .
		
		**
		**
		replace  	share_teacher_management_program = share_teacher_management_program*100
		format   	share_teacher_management_program %4.2fc
		
		save 		"$inter/Teachers Managerial Practices Program.dta", replace			//share of teachers per school participating in the Management Program
	}
		
	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Share of teachers working in state and locally-managed schools																						
	*________________________________________________________________________________________________________________________________* 
	*																								
	{	
		use 		"$inter/Código de Identificação dos professores" if (network == 2 | network == 3) & coduf == 35, clear
		
		**
		**
		bys 		year codteacher: egen min_network = min(network) 					//2 if state-managed
		bys 		year codteacher: egen max_network = max(network)					//3 if locally-managed
		
		
		**
		**
		gen 		T   		= .														//1 for closed schools, 0 otherwise
		gen 		G	  		= 1														//0 for the 13 municipalities that extended the winter break, 1 otherwise
		foreach munic in $treated_municipalities {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
			replace T   		= 1 					if codmunic == `munic' & network == 3
			replace G	  	  	= 0 					if codmunic == `munic'
		}		
		replace 	T    		= 1 					if network == 2
		replace 	T    		= 0 					if T == .
		
		
		**
		**
		gen 			 teacher_both_networks = 1  	if min_network == 2 & max_network == 3
		replace 		 teacher_both_networks = 0  	if teacher_both_networks == .
	
	
		**
		**
		tab 		year teacher_both_networks 			if network == 3 & Teacher5grade == 1
		tab 		year teacher_both_networks 			if network == 2 & Teacher5grade == 1 & G == 1
			
			
		**
		**
		clonevar 	share_teacher_both_networks = 			 teacher_both_networks
		collapse 	(max) teacher_both_networks (mean) share_teacher_both_networks, by(codschool year network codmunic T G) 		
		
		
		**
		**
		replace  	share_teacher_both_networks = share_teacher_both_networks*100
		format   	share_teacher_both_networks %4.2fc
		save 	 	"$inter/Teachers in state and municipal networks.dta", replace				//share of teachers per school that work in a state and in a locally-managed school
	}
	
	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Socioeconomic characteristics of the students at school level																										
	*________________________________________________________________________________________________________________________________* 
	**	
	{
		use 	   "$inter/Students - Prova Brasil.dta" if (network == 2 | network == 3) & (year == 2007 | year == 2009) & coduf == 35, clear
		
		**
		**
		egen 		teacher_motivation = rowmean(teacher_motivation*)						//motivação dos docentes para corrigir lições de matemática e português 
		label var   teacher_motivation "Teacher motivation from students' perspective"		//1 se professor sempre corrige, 0.5 se de vez em quando e 0 se nunca

		
		**
		**
		foreach 	v of var *  {
		local 	  l`v' : variable label `v'
			if `"`l`v''"' == "" {
			local l`v' "`v'"
			}
		}
		
		**
		**
		collapse   (mean) $socioeco_variables teacher_motivation* number_dropouts number_repetitions, by(grade year codschool)
		
		**
		**
		foreach v of var * {
			label var `v' "`l`v''"
		}
		
		
		**
		**
		foreach var of varlist $socioeco_variables {
			replace `var' = `var'*100 
			format  `var' 								   %4.2fc
		} 
		
		
		**
		**
		format 		number* teacher_motivation* %4.2fc
		
		
		**
		**
		foreach v  of varlist  incentive_study-number_repetitions {
			local l`v'5 : variable label `v'
			local l`v'9 : variable label `v'

		}
		
		**
		**
		reshape 	wide $socioeco_variables teacher_motivation* number_dropouts number_repetitions, i(codschool year) j(grade)
		
		
		**
		*Adding the grade and the % symbol in var labels
		**
		foreach	 	v of varlist incentive_study5-hw_corrected_math_always5 incentive_study9-hw_corrected_math_always9 {
			if 		    substr("`v'", -1, .) == "5" {
			local 	new = 1
			}
			if 		    substr("`v'", -1, .) == "9" {
			local 	new = 2
			}
			local 	z = substr("`v'", 1,length("`v'")-1)
			if 		`new' == 1 label var `v' "`l`z'5' - %" 
			if 		`new' == 2 label var `v' "`l`z'9' - %" 
		}
		
		foreach	 	v of varlist number* teacher_motivation* {
			if 		    substr("`v'", -1, .) == "5" {
			local 	new = 1
			}
			if 		    substr("`v'", -1, .) == "9" {
			local 	new = 2
			}
			local 	z = substr("`v'", 1,length("`v'")-1)
			if 		`new' == 1 label var `v' "`l`z'5'" 
			if 		`new' == 2 label var `v' "`l`z'9'" 
		}		
		
		drop			*9 
		tempfile    	socio_economic
		save           `socio_economic'
	}

	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Flow Indicators																									
	*________________________________________________________________________________________________________________________________* 
	**	
	{	
		use 	   "$inter/Flow Indicators.dta", clear
		keep 		*5grade* approval9* codschool year			//nao tirar o approval9
		
		**
		tempfile    	flow_index
		save       	   `flow_index'
	}

	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*School Infrastructure																									
	*________________________________________________________________________________________________________________________________* 
	**	
	{
		use 	   	$matching_schools year codschool coduf uf codmunic codmunic2 operation network cfim_letivo cinicio_letivo  location ///
		mes_fim_letivo dia_fim_letivo CICLOS using "$inter/School Infrastructure.dta"  if (network == 3 | network == 2) & codschool!= . & coduf == 35, clear
		
		**
		tempfile    	school_infra
		save      	   `school_infra'
	}
	
	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Enrollments																									
	*________________________________________________________________________________________________________________________________* 
	**	
	{
		use 		year codschool dif_age_5grade atraso5 enrollmentEMtotal enrollmentEF enrollment5grade network enrollment9grade enrollmentEF1 enrollmentEF2 enrollmentEI coduf  ///
		using "$inter/Enrollments"  if (network == 3 | network == 2)  & !missing(codschool) & coduf == 35, clear
		
		**
		**
		egen 		 enrollmentTotal = rowtotal(enrollmentEMtotal enrollmentEF enrollmentEI)
		foreach 	 var of varlist enrollment* {
			replace `var' = . if `var' == 0
		}
		
		**
		**
		tempfile    	enrollments
		save       	   `enrollments'	
	}
	
	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Class hours																								
	*________________________________________________________________________________________________________________________________* 
	**	
	{
		use 		classhour5grade  year codschool network coduf using "$inter/Class-Hours.dta" 			if (network == 2 | network == 3) & codschool !=. & coduf == 35, clear
		
		**
		tempfile    	class_hours
		save       	   `class_hours'	
	}
	
	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Students per class																								
	*________________________________________________________________________________________________________________________________* 
	**
	{
		use 	    tclass5grade 	 year codschool network coduf using "$inter/Class-Size.dta" 			if (network == 2 | network == 3) & codschool !=. & coduf == 35, clear
		
		**
		tempfile    	class_size
		save       	   `class_size'	
	}
	
	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Students per teacher																						
	*________________________________________________________________________________________________________________________________* 
	**	
	{	
		use 	    spt5grade   		 year codschool network	uf    using "$inter/Students per teacher.dta"   if (network == 2 | network == 3) & codschool !=. & uf == "SP", clear
		
		**
		tempfile    	students_teacher
		save       	   `students_teacher'	
	}	
	
	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*IDEB																							
	*________________________________________________________________________________________________________________________________* 
	**
	{
		use 		"$inter/IDEB by school.dta" if (year == 2005 | year == 2007 | year == 2009) & (network == 2 | network == 3) & codschool !=. & coduf == 35, clear
		rename 		(spEF1 spEF2) (sp5 sp9)
		drop 		flowindexEF* target* approval*
		
		**
		tempfile    	ideb
		save       	   `ideb'
	}	
	
	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*List of schools included in Prova Brasil																							
	*________________________________________________________________________________________________________________________________* 
	**	
	{
		duplicates drop codschool, force
		keep 	 		codschool
		
		**
		tempfile 		data
		save 		   `data'
	}
	
	
	
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Teachers																							
	*________________________________________________________________________________________________________________________________* 
	**	
	{
		use  "$inter/Teachers - Prova Brasil.dta" 	if 			(year == 2007 | year == 2009) & (network == 2 | network == 3) & codschool !=. & coduf == 35 & grade != ., clear
		
		**
		**
		foreach 	   v of var *  {
		local 		 l`v' : variable label `v'
			if 	  `"`l`v''"' == "" {
			local 	 l`v' "`v'"
			}
		}
		
		**
		**
		collapse 		 (mean)$teachers, 	by (codschool year grade)
		
		**
		**
		foreach 	   v of var * {
			label var `v' "`l`v''"
		}
		foreach 		v  of varlist grade-def_bad_behavior {
			local 		l`v'5 : variable label `v'
			local 		l`v'9 : variable label `v'

		}
		
		**
		**
		foreach 	 var of varlist teacher_more10yearsexp-teacher_less3min_wages almost_all_finish_grade9-def_bad_behavior {
			replace `var' = `var'*100
		}
		
		
		**
		**
		reshape 	wide $teachers, 		   				i(codschool year) j(grade)

		
		**
		**
		foreach 	v of varlist teacher_more10yearsexp5-teacher_less3min_wages5 almost_all_finish_grade95-def_bad_behavior5  ///
								 teacher_more10yearsexp9-teacher_less3min_wages9 almost_all_finish_grade99 def_bad_behavior9 {
			if 		substr("`v'", -1, .) == "5" {
			local 	new = 1
			}
			if 		substr("`v'", -1, .) == "9" {
			local 	new = 2
			}
			local 	z = substr("`v'", 1,length("`v'")-1)
			if 		`new' == 1 label var `v' "`l`z'5' - %" 
			if 		`new' == 2 label var `v' "`l`z'9' - %" 
		}
		
		**
		**
		foreach 	v of varlist principal_effort* student_effort* violence_index* { 
			if 		substr("`v'", -1, .) == "5" {
			local 	new = 1
			}
			if 		substr("`v'", -1, .) == "9" {
			local 	new = 2
			}
			local 	z = substr("`v'", 1,length("`v'")-1)
			if 		`new' == 1 label var `v' "`l`z'5'" 
			if 		`new' == 2 label var `v' "`l`z'9'" 
		}
				
		
		**
		**
		format 		teacher_more10yearsexp5-def_bad_behavior9 %4.2fc
		
		
		drop			*9 
		**
		tempfile 	teachers
		save	   `teachers'
	}
		
		
		
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Principals																						
	*________________________________________________________________________________________________________________________________* 
	**	
	{	
		use  		"$inter/Principals - Prova Brasil.dta"		 if (network == 2 | network == 3) & (year == 2007 | year == 2009) & codschool !=. & coduf == 35 , clear
		keep 		codschool year $principals
		
		**
		tempfile 	principals
		save	   `principals'
	}
		
		
		
	*________________________________________________________________________________________________________________________________* 
	**
	**
	*Formação adequada dos professores																				
	*________________________________________________________________________________________________________________________________* 
	**
	{
		use  		"$inter/Formação Adequada dos Docentes.dta" if (network == 2 | network == 3) & (year == 2007 | year == 2009) & codschool !=. & coduf == 35 , clear
		
		**
		tempfile 	formacao
		save	   `formacao'
	}
	
	
		
	*________________________________________________________________________________________________________________________________* 
	**
	**
	
	*Merging all data
	*________________________________________________________________________________________________________________________________* 
	**
		use 		`school_infra'	, clear
		merge   	1:1 codschool year using `enrollments'	 										, nogen keepusing(dif_age_5grade atraso5 enrollment5grade enrollment9grade enrollmentEF1 enrollmentEF2 enrollmentTotal)
		merge   	1:1 codschool year using `flow_index'											, nogen
		merge   	1:1 codschool year using `class_hours'	 										, nogen keepusing(classhour5grade)
		merge   	1:1 codschool year using `class_size'	 										, nogen keepusing(tclass5grade   )
		merge   	1:1 codschool year using `students_teacher'	 									, nogen keepusing(spt5grade      )
		merge 		1:1 codschool year using `formacao'												, nogen 
		merge 		1:1 codschool year using `ideb'													, nogen
		merge 		1:1 codschool year using `socio_economic'										, nogen 
		merge 		1:1 codschool year using `teachers'												, nogen 
		merge 		1:1 codschool year using `principals'											, nogen 
		*merge 		m:1 codschool 	   using `data'													, nogen keep(3) //para manter somente as escolas que estao na base da Prova Brasil	
		merge 		1:1 codschool year using "$inter/Managerial Practices Program.dta"				, nogen keep(1 3) keepusing(school_management_program       ) 
		merge 		1:1 codschool year using "$inter/Teachers Managerial Practices Program.dta"		, nogen keep(1 3) keepusing(teacher_management_program share*) 
		merge 		1:1 codschool year using "$inter/Teachers in state and municipal networks.dta"	, nogen keep(1 3) 
		merge   	m:1 codmunic  year using "$inter/GDP per capita.dta"							, nogen keep(1 3) keepusing(pib_pcap pop porte)              
		drop 		G T


		**
		sort 			codschool year 
		xtset   		codschool year  

		
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*The management program only started in 2008. 
		**
		
		replace school_management_program 			= 0 if school_management_program 		== .
		replace share_teacher_management_program	= 0 if share_teacher_management_program == .

		
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Adjusting the name of the variables
		**
		foreach 	var of varlist *grade {
			local 	newname  = substr("`var'",1, length("`var'") - 5)
			rename `var'  `newname'
		}
	
		**
		**
		drop 		school operation
		replace 	n_munic = n_munic[_n-1] if codmunic[_n] == codmunic[_n-1] & n_munic[_n] == "" & n_munic[_n-1] != ""		//name of municipalities
		replace 	n_munic = n_munic[_n+1] if codmunic[_n] == codmunic[_n+1] & n_munic[_n] == "" & n_munic[_n+1] != ""
		
		**
		**
		gen 		school_year = cfim_letivo - cinicio_letivo
		
		**
		**
		order 		year-codmunic2 n_munic location codschool-mes_fim_letivo school_year CICLOS
		
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Labels
		**
		label 		var codschool								"INEP Code of the school"
		label 		var year 									"Year"
		label 		var network 								"2 if state-managed. 3 if locally managed"
		label 		var location								"1 if urban. 0 if rural "
		label		var coduf 									"Code of the state"
		label 		var uf 										"Brazilian state"
		label 		var codmunic								"Code of the municipality"
		label 		var codmunic2 								"Code of the municipality-6 digits"
		label 		var pop 									"Population of the municipality"
		label 		var n_munic									"Name of the municipality"		
		label 		var cinicio_letivo 							"Início do ano letivo"
		label 		var cfim_letivo 							"Fim do ano letivo"
		label 		var dia_fim_letivo 							"Dia em que terminou o ano letivo"
		label 		var mes_fim_letivo							"Mês em que terminou o ano letivo"
		label 		var math5									"Proficiency in Math [SAEB scale 0 to 350] " 
		label 		var port5									"Proficiency in Portuguese [SAEB scale 0 to 325]" 
		label 		var sp5										"Performance in Math and Portuguese [0 to 10]" 
		label 		var repetition5 							"Repetition - %" 
		label 		var dropout5 								"Dropout - %" 
		label 		var approval5								"Approval - %" 
		label 		var approval9								"Approval 9th grade - %" 
		label 		var ComputerLab 							"Schools with computer lab - %" 
		label 		var ScienceLab 								"Schools with science lab - %" 
		label 		var Library 								"Schools with library - %" 
		label 		var InternetAccess 							"Schools internet access - %" 
		label 		var SportCourt 								"Schools sport court - %"
		label 		var enrollment5 							"Enrollments 5th grade"
		label 		var classhour5 								"Class hours per day"
		label 		var tclass5 								"Students per class"
		label 		var pop										"Population of the municipality, in thousands"
		label 		var pib_pcap								"GDP per capita of the municipality, in 2019 BRL"
		label 		var spt5									"Students per teacher"
		foreach 	x in 9 {
		label 		var math`x'        							"Math, `x'th grade"
		label 		var port`x' 		 						"Portuguese, `x'th grade"
		label 		var sp`x'									"Standardized Performance, `x'th grade"
		}
		foreach 	x in EF1 EF2 {
		label 		var ideb`x'   	  	 						"IDEB `x'"
		label 		var enrollment`x'							"Enrollments `x'"
		}
		label 		var porte									"Size of the municipality"
		label 		var CICLOS									"Schools with automatic approval" 
		label 		var enrollmentTotal							"Total enrollment, all grades"
		label 		var school_year								"Length of the school year (days)"
		label 		var formacao_adequada_port5					"Teachers with the correct degree to teach Portuguese - %" 
		label 		var formacao_adequada_math5					"Teachers with the correct degree to teach Math - %" 
		label 		var school_management_program 				"School included in the managerial practices intervention"
		label 		var teacher_management_program 				"School has at least 1 teacher in the managerial practices intervention" 
		label 		var share_teacher_management_program		"Teachers in the managerial practices intervention - %" 
		label 		var teacher_both_networks 					"School has at least 1 teacher working in a state and a locally-managed school" 
		label 		var share_teacher_both_networks				"Teachers working in state and locally managed school - %" 
		label       var dif_age_5								"Difference in years between the youngest and oldest student of classroom" 
		
		label 		define simnao 1 "Yes" 0 "No" 
		label 		val 			teacher_management_program simnao
		label 		val 			school_management_program  simnao
		label 		val 			teacher_both_networks      simnao
		
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		**
		*Treatment and Comparison Groups
		**
		gen 		T   				= .										//1 for closed schools, 0 otherwise
		gen 		G	  				= 1										//0 for the 13 municipalities that extended the winter break, 1 otherwise
		gen 		E 					= network == 2							//1 for a state managed school and 0, otherwise
		gen 		id_13_mun 			= 0										//1 for the 13 municipalities that extended the winter break, 0 otherwise
		foreach 	munic in $treated_municipalities {
			replace T   				= 1 		if codmunic == `munic' & network == 3
			replace id_13_mun 			= 1 		if codmunic == `munic'
			replace G	  	  			= 0 		if codmunic == `munic'
		}		
		replace 	T    				= 1 		if network == 2				//all state-managed schools were closed
		replace 	T    				= 0 		if T == .
		gen 		post_treat 			= (year >  2008)						//after treatment period
		gen 		T2007 	   			=  year == 2007  & T == 1
		gen 		T2008	   			=  year == 2008  & T == 1
		gen 		T2009 	   			=  year == 2009  & T == 1
		
		**
		**
		label 		var T 				"Schools that extended the winter break"
		label 		var G				"School in a municipality that didnt extend the winter break of their local schools" 
		label 		var id_13_mun		"School in a municipality that extend the winter break of their local schools" 
		label 		var E				"State-managed schools"
		label 		var post_treat		"Pos-treatment"
		label 		var T2007			"1 for treated schools in 2007"
		label 		var T2008			"1 for treated schools in 2008"
		label	    var T2009			"1 for treated schools in 2009"
				
		
		**
		**
		label 		define 	id_13_mun   0 "Locally-managed schools without winter break extended" 	1 "Locally-managed schools with winter break extended" 
		label 		define 	G		    1 "Local authorities did not extend winter break" 		 	0 "Local authoritied extend winter break"
		label 		define 	T		    0 "Comparison Group" 										1 "Treatment Group"
		label		define 	E		    0 "Locally-managed"  										1 "State-managed"
		label 		val 	id_13_mun id_13_mun
		label 		val 	G G
		label 		val 	T T
		label 		val 	E E
	
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Type of municipalities
		**
		gen 		A = 1 if network == 2 & (enrollmentEF1!=.)
		bys 		year codmunic: egen mun_escolas_estaduais_ef1  = max(A)			//municipalities with state schools offering 1st to 5th grade
		drop 		A	
		
		gen 		A = 1 if network == 3 & (enrollmentEF1!=.)
		bys 		year codmunic: egen mun_escolas_municipais_ef1 = max(A)			//municipalities with municipal schools offering 1st to 5th grade
		drop 		A

		
		**
		**
		gen 		tipo_municipio_ef1 	= 1 if mun_escolas_estaduais_ef1 == 1 & mun_escolas_municipais_ef1 == 1
		replace 	tipo_municipio_ef1 	= 2 if mun_escolas_estaduais_ef1 == . & mun_escolas_municipais_ef1 == 1
		replace 	tipo_municipio_ef1 	= 3 if mun_escolas_estaduais_ef1 == 1 & mun_escolas_municipais_ef1 == .
		replace 	tipo_municipio_ef1 	= 4 if mun_escolas_estaduais_ef1 == . & mun_escolas_municipais_ef1 == .				
			
		**
		**
		gen 		offers_ef1 			= !missing(math5)
		
		**
		**
		label 		define 	tipo_municipio_ef1 			1 "State and locally-managed schools offering 1st to 5th grade"					 	 	2  "No state-managed schools but locally-managed schools offering 1st to 5th grade" ///
														3 "State-managed schools but no locally-managed schools offering 1st to 5th grade"  	4  "Without schools offering 1st to 5th grade" 
		
		**
		**
		label 		val 	tipo_municipio_ef1 			tipo_municipio_ef1
		
		
		**
		**
		label 		var 	mun_escolas_estaduais_ef1	"Municipality with state schools offering 1st to 5th grades"
		label 		var 	mun_escolas_municipais_ef1	"Municipality with locally-managed schools offering 1st to 5th grades"
		label 		var 	tipo_municipio_ef1			"Type of municipality that offers 1st to 5h grades"
		label 		var 	offers_ef1					"School offers 1st to 5th grade"
	
		**
		**
		sort 				codschool year
		
		**
		**
		foreach 	var of varlist tipo_municipio* offers* {
		   replace `var' = `var'[_n+1] if year[_n] == 2005 & year[_n+1] == 2007 & codschool[_n] == codschool[_n+1]		//We do not have data of performance or approval rates in 2005 at school level
		}

		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Population
		**
		gen 		pop_2007 = pop if year == 2007
		bys 		codmunic: egen max = max(pop_2007)
		drop 		pop_2007
		rename  	max pop_2007
		label 		var pop_2007 					"Population of the municipality the school is located at"
		format  		pop 		%20.0fc	
	
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Students with basic or adequate performance 
		**
		foreach 	grade in 5 {
			egen 	port_basic_more_`grade' = rowtotal(port_basic`grade' port_adequ`grade'), missing
			egen 	math_basic_more_`grade' = rowtotal(math_basic`grade' math_adequ`grade'), missing
		}
		
		
		**
		**
		label 		var port_basic_more_5			"Basic or adequate performance in Portuguese, 5th grade - %" 
		label 		var math_basic_more_5			"Basic or adequate performance in Mathm, 5th grade - %" 
		
		
		**
		**
		sort 		codschool year 
		
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Triple dif in dif
		**
		gen 		D 		 = (year == 2009)
		gen 		beta1    = E
		gen 		beta2    = G
		gen 		beta3    = D
		gen 		beta4    = E*G
		gen 		beta5    = E*D
		gen 		beta6  	 = G*D
		gen 		beta7    = E*G*D 				//triple dif coefficient
		
		gen 		DP1 	 = (year == 2007)		//coeficientes beta para triple dif placebo
		gen 		beta1P1  = E
		gen 		beta2P1  = G
		gen 		beta3P1  = DP1
		gen 		beta4P1  = E*G
		gen 		beta5P1  = E*DP1
		gen 		beta6P1  = G*DP1
		gen 		beta7P1  = E*G*DP1  			//triple dif coefficient	
		
		gen 		DP2 	 = (year == 2008)		//coeficientes beta para triple dif placebo
		gen 		beta1P2  = E
		gen 		beta2P2  = G
		gen 		beta3P2  = DP2
		gen 		beta4P2  = E*G
		gen 		beta5P2  = E*DP2
		gen 		beta6P2  = G*DP2
		gen 		beta7P2  = E*G*DP2  			//triple dif coefficient
				
		label 		var D   		"2009"
		label 		var DP1 		"2007"
		label 		var DP2 		"2008"
		
		foreach 	var of varlist beta1* {
		label 		var `var' 		"State-managed"
		}
		foreach 	var of varlist beta2* {
		label 		var `var' 		"G = 1"
		}	
		foreach 	var of varlist beta4* {
		label 		var `var' 		"State-managed versus G = 1"
		}	
		foreach 	var of varlist beta5* {
		label 		var `var' 		"State-managed versus post-treament" 
		}	
		foreach 	var of varlist beta6* {
		label	 	var `var' 		"Post-treatment versus with G = 1" 
		}	
		foreach 	var of varlist beta7* {
		label 		var `var' 		"Triple difference in differences"
		}		
		label 		var beta3		"Post-treatment year (2009)"
		label 		var beta3P1		"Post-treatment year (2007)"
		label 		var beta3P2		"Post-treatment year (2008)"
		
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Interactions
		**
		
		/*
		
		Treatment status versus students per teacher, principal effort, teacher tenure, teachers with formacao adequada para lecionar para 5a serie
		
		*/
		
		clonevar  	absenteeism_issue5 = absenteeism_teachers3  	
		
		rename 		(principal_effort_teacherpers5 formacao_adequada_port5 formacao_adequada_math5 dif_age_5	 absenteeism_issue5 teacher_motivation5 mother_edu_highschool5  teacher_tenure5 prog_reduce_dropout) ///
					(prin5			  			   adeqport5			   adeqmath5			   dif5		 	 absen5				mot5				medu5					tenure5			reddrop			)
		
		rename      (classhour5) (hour5)
		
		
		foreach variable in prin5 adeqport5 adeqmath5 dif5 absen5 mot5 medu5 spt5 tenure5 atraso5 reddrop { 		//students per teacher, principal_effort_index teacher_tenure 
				gen   T2009_`variable'  		= T2009*`variable'
		}
		
		**
		**
		label 		var T2009_atraso5				"H1N1 versus age-grade distortion" 
		label 		var T2009_prin5   				"H1N1 versus principal effort" 
		label 		var T2009_adeqport5				"H1N1 versus teacher with the correct degree to teach Portuguese"
		label 		var T2009_adeqmath5 			"H1N1 versus teacher with the correct degree to teach math"
		label 		var T2009_dif5					"H1N1 versus age difference between youngest and oldest of the class" 
		label 		var T2009_absen5 				"H1N1 versus teacher absenteeism" 		
		label 		var T2009_mot5 					"H1N1 versus teacher motivation" 		
		label 		var T2009_medu5 				"H1N1 versus mother's education" 		
		label 		var T2009_spt5  			 	"H1N1 versus students per teacher" 
		label 		var T2009_tenure5  				"H1N1 versus % teachers with tenure" 
		label 		var T2009_reddrop  				"H1N1 versus program to reduce dropout" 


		**
		**
		format 		T2009_* %4.2fc
		
		
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Criteria to student's allocation into their classrooms
		**
		gen  			classrooms_similar_ages  	= 			   criteria_classrooms  == 1
		replace 		classrooms_similar_ages  	= . if missing(criteria_classrooms)
		label 		var classrooms_similar_ages  	 "Students allocated into classrooms according to similar age"

		gen 			classrooms_het_performance  = 			   criteria_classrooms  == 4
		replace 		classrooms_het_performance  = . if missing(criteria_classrooms)
		label 		var classrooms_het_performance 	 "Students allocated into classrooms according to hetero. performance"
	

		foreach		var of varlist classrooms_het_performance classrooms_similar_ages  mun_escolas_estaduais_ef1 ///
					mun_escolas_municipais_ef1 offers_ef1									{
					label val `var' simnao
		}
	
		**
		**
		xtset 		 codschool year 	
		compress
		save	 	 "$inter/data_h1n1.dta", replace
	
		
		*----------------------------------------------------------------------------------------------------------------------------*
		**
		*Triple Dif-in-dif sample
		**
		{
		**
			
			**
			foreach year in 2007 2009 	{
			
				foreach G in 0 1 		{			// for 2007, and G = 0/1, which are the municipalities with schools with performance data available for both state and locally-managed schools.
													// for 2009, and G = 0/1, which are the municipalities with schools with performance data available for both state and locally-managed schools.
													// then, keeping only the municipalities in which we have data for both 2007 and 2009
							
					use  "$inter/data_h1n1.dta" if math5 != . & year == `year',  clear
							
					drop if school_management_program == 1
							
					**
					preserve
						keep 		if G == `G' & network == 2
						duplicates 	drop codmunic, force
						tempfile 	 A`G'`year'
						save 		`A`G'`year''
					restore
						
					**
					keep 			if G == `G' & network == 3
					duplicates 		drop codmunic, force
					merge 			1:1  codmunic using `A`G'`year'', keep(3) nogen		//keeping only the municipalities in G = 0 and G = 1 where 
																						//we have state and locally-managed schools
							
					**
					*di 				as red "Numero de municipios"  in " G = `G' and in year = `year'"
					count
					tempfile 		 A`G'`year'
					save 	   		`A`G'`year''
				}
			}
		
		**
		** in G = 1, selecting municipalities with data available for both 2007 and 2009
		use 		`A12007', clear
			
			merge 		1:1 codmunic  using `A12009', keep(3)
			
			tempfile 	A1
			save 	   `A1'
			*di 				as red "Numero de municipios" 
			count
	
		**
		**	in G = 0, selecting municipalities with data available for both 2007 and 2009
		use 		`A02007', clear
				
			merge 		1:1 codmunic using `A02009', keep(3)
			
			tempfile 	A0
			save 	   `A0'
			*di 				as red "Numero de municipios" 
			count 
		
			
		**
		**
		use 	"$inter/data_h1n1.dta" , clear
					
			**
			merge		 		m:1 codmunic using `A0', gen(merge0) 
					
			**
			merge		 		m:1 codmunic using `A1', gen(merge1) 					
				
			**
			keep 				if merge0 == 3 | merge1 == 3
					
			**
			keep 				codmunic
					
			**
			duplicates 			drop codmunic, force
					
			**
			tempfile 			amostra_triple 					//sample of schools in municipalities with at least one state and one locally managed school with performance data available for 2007 and 2009
			save			   `amostra_triple'

		**
		*Identifying schools and municipalities in the triple dif sample 
		**
		use				"$inter/data_h1n1.dta",  clear
		
			**
			merge 				m:1 codmunic using  `amostra_triple'
				
			**
			gen 				sample_triple_dif = 1 if _merge == 3		//only excluding schools in the management program
			drop 				_merge
			
			**
			save  			 	"$inter/data_h1n1.dta", replace
		}
		
		
		
		*............................................................................................................................*
		**
		*Dif-in-dif sample
		**
		{
			use 		"$inter/IDEB by school.dta" if year == 2005 & network == 3 & codschool !=. & coduf == 35 & math5 != ., clear
			
			**
			gen 		T = .
			foreach 	munic in $treated_municipalities {
				replace T   				= 1 		if codmunic == `munic' 
			}	
			
			**
			duplicates drop codmunic, force

			**
			keep 			codmunic
			
			tempfile 		2005
			save 		   `2005'							//municipalities with math5 data for 2005
			
			
			foreach year in 2007 2009 {
			
			**
			use 		"$inter/IDEB by school.dta" if year == `year' & network == 3 & codschool !=. & coduf == 35 & math5 != ., clear		//finding these municipalities in 2007 and 2009
			
			**
			duplicates 	drop codmunic, force
			
			**
			merge 1:1 		 codmunic using  `2005', keep(3) nogen
			
			tempfile 		`year'
			save		   ``year''
			
			}
			
			**
			use 							`2007', clear
			merge 		1:1 codmunic using 	`2009', keep(3) nogen
			
			keep 		codmunic 
			
			**
			tempfile 	 	sample_dif
			save  		   `sample_dif'
		}

	
		
		*............................................................................................................................*
		**
		*Final
		**
		
			use			"$inter/data_h1n1.dta",  clear
			merge 		m:1 codmunic using `sample_dif'
			
			**
			gen 		sample_dif = 1 if _merge == 3 & network == 3
			drop 		_merge
			
			
			*Prova Brasil sample
			
			gen escola_ef1 = 1 if !missing(enrollment5) 
			
			gen 	pb_prob 		= 1 if escola_ef1 == 1 & (!missing(math5) | !missing(port5))
			replace pb_prob			= 0 if escola_ef1 == 1 &   missing(math5) &  missing(port5)
						
			**
			save 		"$final/h1n1-school-closures-sp-2009.dta", replace
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
		br 			codschool year T2009 enrollment5 math5 spt5 principal_effort5 teacher_tenure5 formacao_adequada_port5 formacao_adequada_math5 absenteeism_teachers absenteeism_teachers3   dif_age_5 T2009*
*/




/*

estimates clear
	global controls2008 c.ComputerLab##c.ComputerLab c.ScienceLab##c.ScienceLab c.SportCourt##c.SportCourt c.pib_pcap##c.pib_pcap 		   	  			///
					    c.Library##c.Library c.InternetAccess##c.InternetAccess c.tclass5##c.tclass5 c.hour5##c.hour5 


	use "$final/h1n1-school-closures-sp-2009.dta" if network == 3  & (year == 2007 | year == 2009), clear
	
	eststo:	reg  pb_prob   i.T i.codmunic i.year  			 T2009		, cluster(codmunic)
	eststo:	reg  pb_prob   i.T i.codmunic i.year $controls2008 T2009		, cluster(codmunic)
	
	
	
	use "$final/h1n1-school-closures-sp-2009.dta" if 				 (year == 2007 | year == 2009), clear
	xtset codschool year
	eststo: xtreg pb_prob T2009 								 beta1-beta6 i.codmunic,  fe 	cluster(codmunic)
	eststo: xtreg pb_prob T2009 				$controls2008	 beta1-beta6 i.codmunic,  fe 	cluster(codmunic)
		
	estout using "$tables/Table3i.xls", keep(T2009*) 		label cells(b(star fmt(3)) se(par(`"="("' `")""') fmt(2)) ) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0g %9.1f %9.2f) labels("N. schools" "R2" )) replace
	
		
		
		
