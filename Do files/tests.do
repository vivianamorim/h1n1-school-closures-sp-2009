
global controls2007 c.mother_edu_highschool5##c.mother_edu_highschool5 c.number_dropouts5##c.number_dropouts5 									///
				c.number_repetitions5##c.number_repetitions5 c.computer5##c.computer5																			///
				c.pib_pcap##c.pib_pcap c.work5##c.work5 						   																				///
				c.white5##c.white5 c.male5##c.male5 c.private_school5##c.private_school5 c.live_mother5##c.live_mother5 										///
				c.ComputerLab##c.ComputerLab c.ScienceLab##c.ScienceLab c.SportCourt##c.SportCourt 																///
				c.Library##c.Library c.InternetAccess##c.InternetAccess c.classhour5##c.classhour5 c.spt5##c.spt5 												///
				c.incentive_study5##c.incentive_study5 c.incentive_homework5##c.incentive_homework5 c.incentive_read5##c.incentive_read5	 					///
				c.incentive_school5##c.incentive_school5 c.incentive_talk5##c.incentive_talk5 c.incentive_parents_meeting5##c.incentive_parents_meeting5	

	
global teachers_principals lack_books quality_books45 principal_effort5 student_effort_index5 absenteeism_issue5 classrooms_het_performance 
	
	use  "$final/h1n1-school-closures-sp-2009.dta" if (year == 2007 | year == 2009), clear
	drop if treated_management_program == 1
	
 	 reg math5 beta1-beta6 $controls2007 $teachers_principals  T2009 if tipo_municipio_ef1 == 1, cluster(codmunic)

		xtset codschool year
		drop 	 T2009
		clonevar T2009 = beta7
		xtreg 	 math5 beta1-beta6 $controls2007 $teachers_principals T2009  if tipo_municipio_ef1 == 1, fe cluster(codmunic)


	
	
	
	
	
		reg math5  i.codmunic $controls2007 i.year i.T T2009 [aw = enrollment5] if G == 1 & tipo_municipio_ef1 == 1, cluster(codmunic)

		reg math5  i.codmunic $controls2007 $teachers_principals i.year i.T T2009 [aw = enrollment5] if G == 1 & tipo_municipio_ef1 == 1, cluster(codmunic)
		
		replace T 	  = 0 if network == 3
		replace T2009 = 0 if network == 3 
		reg math5  i.codmunic i.year i.T T2009 [aw = enrollment5] if G == 0 & tipo_municipio_ef1 == 1, cluster(codmunic)

		reg math5  i.codmunic $controls2007 $teachers_principals i.year i.T T2009 [aw = enrollment5] if G == 0 & tipo_municipio_ef1 == 1, cluster(codmunic)

		drop 	 T2009
		clonevar T2009 = beta7
		reg 	 math5 beta1-beta6 i.codmunic $controls2007 $teachers_principals T2009 	[aw = enrollment5] if year == 2007 | year == 2009, cluster(codmunic)

		
		
		
		
		
		xtreg math5   $controls2007  i.year i.T T2009  if G == 1 & tipo_municipio_ef1 == 1, fe cluster(codmunic)
		xtreg math5   $controls2007 $teachers_principals  i.year i.T T2009  if G == 1 & tipo_municipio_ef1 == 1, fe cluster(codmunic)

		xtreg math5   $controls2007  i.year i.T T2009  if G == 0 & tipo_municipio_ef1 == 1, fe cluster(codmunic)
		xtreg math5   $controls2007 $teachers_principals  i.year i.T T2009  if G == 0 & tipo_municipio_ef1 == 1, fe cluster(codmunic)





/*

use  "$final/h1n1-school-closures-sp-2009.dta" if uf == "SP" & network == 2 & year == 2009, clear

count if G == 0 & math5 !=.
count if G == 0 & math5 !=. & treated_management_program ==1

use  "$final/h1n1-school-closures-sp-2009.dta" if uf == "SP" & network == 2 & year == 2009, clear

count if G == 1 & math5 !=.
count if G == 1 & math5 !=. & treated_management_program ==1



use  "$final/h1n1-school-closures-sp-2009.dta" if uf == "SP" & network == 2 & year == 2009, clear

count if G == 0 
count if G == 0 & treated_management_program ==1

use  "$final/h1n1-school-closures-sp-2009.dta" if uf == "SP" & network == 2 & year == 2009, clear

count if G == 1 
count if G == 1 & treated_management_program ==1




use "$final/Performance & Socioeconomic Variables of SP schools.dta" if network == 3 & (year == 2007 | year == 2009), clear 

foreach var of varlist T2009 T mother_edu_highschool5 number_dropouts5 number_repetitions5  ///
computer5 pib_pcap work5 white5 male5 private_school5 live_mother5 ///
ComputerLab ScienceLab SportCourt Library InternetAccess  classhour5 spt5 tclass5 incentive_study5 ///
incentive_homework5 incentive_read5 incentive_school5 incentive_talk5 incentive_parents_meeting5 math5 sp5 port5  {
	rename `var' A`var'

}
tempfile a
save `a'


use  "$final/h1n1-school-closures-sp-2009.dta" if network == 3 & (year == 2007 | year == 2009), clear
merge 1:1 codschool year using `a', keep(3)


foreach var of varlist T2009 T mother_edu_highschool5 number_dropouts5 number_repetitions5  ///
computer5 pib_pcap work5 white5 male5 private_school5 live_mother5 ///
ComputerLab ScienceLab SportCourt Library InternetAccess  classhour5 spt5 tclass5 incentive_study5 ///
incentive_homework5 incentive_read5 incentive_school5 incentive_talk5 incentive_parents_meeting5 math5 sp5 port5  {
	gen B`var' = `var' - A`var'
	count if `var' != A`var'
	su B`var'

}



		
	
	
		xtreg 	 port5 beta1-beta6 $controls2007 T2009 	 if year == 2007 | year == 2009, fe cluster(codmunic)






		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
/*





use  "$inter/Class-Size.dta" if (network == 2 | network == 3) & uf == "SP", clear
merge 1:1 codschool year using "$inter/Enrollments.dta",  keep(3) nogen
collapse (mean)tclass5grade 		 [aw = enrollment5grade], by(coduf codmunic network year)
tempfile a1
save 	`a1' 

use  "$inter/Class-Hours.dta"		   if (network == 2 | network == 3) & uf == "SP", clear
merge 1:1 codschool year using "$inter/Enrollments.dta",  nogen keep(3)
collapse (mean)classhour5grade   [aw = enrollment5grade], by(coduf codmunic network year)
tempfile a2
save 	`a2' 

use "$inter/School Infrastructure.dta" if (network == 2 | network == 3) & uf == "SP", clear
merge 1:1 codschool year using "$inter/Enrollments.dta", nogen keep(3)
collapse (mean)$matching_schools [aw = enrollment5grade], by(coduf codmunic network year)
tempfile a3
save 	`a3' 

use "$inter/Teachers - Prova Brasil.dta" if  (network == 2 | network == 3) & grade == 5 & coduf == 35, clear
collapse (mean)  teacher_tenure teacher_less_40years ///
				 principal_effort student_effort_index violence_index   					 			///
				almost_all_finish_highschool covered_curricula4	participation_decisions4				///
				 share_students_books5 quality_books4, by(coduf codmunic network year)
tempfile a4
save 	`a4' 
				 
use "$inter/Principals - Prova Brasil.dta" if (network == 2 | network == 3) & coduf == 35, clear
collapse (mean) org_training lack_books principal_selection_work4 absenteeism_teachers3 				///
								  absenteeism_students3, by (coduf codmunic network year)
tempfile a5
save 	`a5' 

use 	   "$inter/Students - Prova Brasil.dta"  if (network == 2 | network == 3) & coduf == 35, clear
merge m:1 codschool year using "$inter/Enrollments.dta", keep(3)
collapse   (mean) $socioeco_variables  number_dropouts number_repetitions, by(grade year network codmunic)
keep if grade == 5
tempfile a6
save    `a6'
	
		
use "$inter/IDEB by municipality.dta" if uf == "SP" & year < 2011, clear
merge 1:1 codmunic network year using `a1', nogen
merge 1:1 codmunic network year using `a2', nogen
merge 1:1 codmunic network year using `a3', nogen
merge 1:1 codmunic network year using `a4', nogen
merge 1:1 codmunic network year using `a5', nogen
merge 1:1 codmunic network year using `a6', nogen
merge m:1 codmunic 		   year using "$inter/GDP per capita.dta", nogen 
keep if coduf == 35
keep if network == 2 | network == 3

egen group = group(network codmunic)

drop if network == 3 & T == 1 //13 municipalities

drop T
		
		gen T   				= .										//1 for closed schools, 0 otherwise
		foreach munic in $treated_municipalities {
			replace T   		= 1 		if codmunic == `munic' & network == 3
		}		
		replace T    			= 1 		if network == 2
		replace T    			= 0 		if T == .



									

sort group year

drop if year == 2008 | math5 == .



/*
preserve
keep if year == 2005 & math5 != .
keep group 
gen keep = 1
tempfile 2005
save `2005'
restore

merge m:1 group using `2005', keep(3)
*/


foreach var of varlist tclass5grade classhour5grade approval5 absenteeism_teachers3 absenteeism_students3 covered_curricula4 mother_edu_highschool ///
	ever_repeated ever_dropped work incentive_study incentive_homework  incentive_read  incentive_school ///
	ComputerLab ScienceLab Library InternetAccess SportCourt {
	
		gen `var'_times = 1 if `var' !=. 					& year != 2009 
		bys group: egen n_times_`var' = sum(`var'_times)	if year != 2009 
		drop if n_times_`var'  == 0					&  year != 2009 
		drop `var'_times n_times_`var' 
	}
	
bys group: gen times = _N

keep if times == 3 	
	
tsset    group year

*drop if year == 2005
cd "/Users/vivianamorim/Desktop"

levelsof group if network == 2, local(levels) 
foreach group of local levels{
	preserve
	keep if group == `group' | T == 0 
	synth math5 tclass5grade classhour5grade approval5 absenteeism_teachers3 absenteeism_students3 covered_curricula4 mother_edu_highschool ///
	ever_repeated ever_dropped work incentive_study incentive_homework  incentive_read  incentive_school 						///
	ComputerLab ScienceLab Library InternetAccess SportCourt, trunit(`group') keep(a`group') trperiod(2009)   replace
	restore
}
clear

levelsof group if network == 2, local(levels) 
foreach group of local levels {
append using a`group'.dta
erase a`group' 
}
	
=
	
	keep if group == 2| T == 0 
	trunit(2) trperiod(2009)  replace








gen tclass5grade_times = 1 if tclass5grade !=.
		bys group: egen n_times_tclass5grade = sum(tclass5grade_times)


/*
use  "$final/h1n1-school-closures-sp-2009.dta" if uf == "SP" & G == 1 & tipo_municipio_ef1 == 1 & (year == 2005 | year == 2009), clear

global variables math5 spt5 classhour5 approval5 absenteeism_issue5 covered_curricula45 mother_edu_highschool5 ///
	ever_repeated5 ever_dropped5 work5 incentive_study5 incentive_homework5  incentive_read5  incentive_school5 ///
	ComputerLab ScienceLab Library InternetAccess SportCourt

foreach var of varlist $variables {

	gen 	has_value = 1 if `var' != .
	bys 	codschool: egen sum_value = sum(has_value)
	keep 	if sum_value == 2
	drop 	has_value sum_value
	
}


tsset    codschool year
levelsof codschool if network == 2, local(levels) 

	
foreach school of local levels {
	preserve
	keep if codschool == `school' | T == 0 
	synth math5 spt5 classhour5 approval5 absenteeism_issue5 covered_curricula45 mother_edu_highschool5 ///
	ever_repeated5 ever_dropped5 work5 incentive_study5 incentive_homework5  incentive_read5  incentive_school5 ///
	ComputerLab ScienceLab Library InternetAccess SportCourt, trunit(`school') trperiod(2009) keep("`school'")  replace
	restore
}

clear

cd "/Users/vivianamorim/OneDrive"
use  "$final/h1n1-school-closures-sp-2009.dta" if uf == "SP" & G == 1 & tipo_municipio_ef1 == 1 & (year == 2007 | year == 2009), clear
levelsof codschool if network == 2, local(levels) 


foreach school of local levels {
cap noi append using "/Users/vivianamorim/OneDrive/`school'", clear
}
keep if _Y_treated !=. 

collapse (mean) _Y*, by(_time)
		twoway (line _Y_treated _time, lcolor(black)) (line _Y_synthetic _time, lpattern(dash) lcolor(black)), ///
			ytitle("index - number of completed transactions") xtitle("Time") 


			
			
			

	
	
	
keep if G == 1



tsset coduf year

keep if year < 2011

  synth math5 spt5grade(2007) absenteeism_teachers3(2007) absenteeism_students3(2007) pib_pcap(2007) classhour5grade(2007) ComputerLab(2007) ScienceLab(2007) SportCourt(2007) Library(2007) ///
  InternetAccess(2007) ///
  approvalEF1(2005 2007)   ///
    private_school(2007)   ///
  mother_edu_highschool(2007)  preschool(2007)  ever_repeated(2007)  ever_dropped(2007)  work(2007)   ///
   , trunit(35) trperiod(2009)  keep ("sp") replace

   
   
   
   
   
   
   /*
gen 	treated_state = 1 if uf == "SP" | uf == "PR" | uf == "RJ" | uf == "RS" | uf == "MG" 
		replace treated_state = 0 if treated_state == .


drop if year == 2008
keep if (treated_state == 1 & uf == "SP") | treated_state == 0

		
		* Plot the baseline estimation
		use  "sp", clear
		twoway (line _Y_treated _time, lcolor(black)) (line _Y_synthetic _time, lpattern(dash) lcolor(black)), ///
			ytitle("math") xtitle("Time") 
			
			
/*
			xline(`=tq(2018q2)', lpattern(shortdash) lcolor(black)) ///
			xla(`=tq(2014q2)'(2)`=tq(2019q4)', format(%tq) angle(45))
			



/*

	
	use 	"$inter/IDEB by municipality.dta" if (network == 3 | network == 2) & G == 1  , clear
		
	keep 	codmunic network year math5 port5 idebEF1 T


	reshape wide math5 port5 idebEF1, i(codmunic T network) j(year)

	gen portdif =  port52007 - port52005 
	gen mathdif =  math52007 - math52005 
	
*	keep *dif codmunic network
	
	*reshape wide portdif mathdif, i(codmunic) j(network)
	
	psmatch2 T mathdif , common ties 

	keep if _support  == 1
	
	
	tw (histogram math52007 if network == 3, fcolor(none) lcolor(blue)) || (histogram math52007 if network == 2, fcolor(none) lcolor(red))
	
	
	
	
	gen peso = _pscore/(1-_pscore)
	
	
											tw kdensity _pscore if T == 1 [aw = peso],  lw(thick) lp(dash) color(emidblue) 					///
										///
										|| kdensity _pscore if T == 0 [aw = peso],  lw(thick) lp(dash) color(gs12) 						///
											graphregion(color(white) fcolor(white) lcolor(white) icolor(white) ifcolor(white) ilcolor(white)) 	///
											plotregion(color(white) fcolor(white) lcolor(white) icolor(white) ifcolor(white) ilcolor(white)) 	///
											ylabel(, labsize(small) angle(horizontal) format(%2.1fc)) 											///
											xlabel(, labsize(small) gmax angle(horizontal)) 													///
											ytitle("", size(medsmall))			 																///
											xtitle("Propensity score", size(medsmall)) 															///
											title("", pos(12) size(medsmall)) 																	///
											subtitle(, pos(12) size(medsmall)) 																	

				*drop total-peso
			
	
	reshape long port5 math5 idebEF1, i(codmunic network T) j(year)
		keep if year < 2011
	collapse (mean)port5 math5, by(year T)
	
	tw line math5 year if T == 1, lcolor(red) || line math5 year if T == 0, lcolor(blue)
	
									
											
											
	duplicates drop codmunic, force
	keep codmunic

	tempfile munic
	save `munic' 
	
	
	
	
	
	
	use  "$final/h1n1-school-closures-sp-2009.dta" if year == 2007 | year == 2009, clear
	
	*merge m:1 codmunic using `munic', keep (3)
											
	collapse (mean)	port5 math5 idebEF1 [aw = enrollment5], by(year T)
	
		tw line port5 year if T == 1, lcolor(red) || line port5 year if T == 0, lcolor(blue)

											
											
											
	use  "$final/h1n1-school-closures-sp-2009.dta" if (year == 2007) & G == 1 & tipo_municipio_ef1 == 1, clear
	
	keep codmunic network math5 port5 
	
	gsort -port5
	
	br port5 if network == 2
	
	gsort -math5
	
	
	
											
		reg math5  i.codmunic $controls2007 beta1-beta7 [aw = enrollment5] , cluster(codmunic)
									
		reg port5  i.codmunic $controls2007 i.year i.T T2009 [aw = enrollment5] , cluster(codmunic)

	
	
	use  "$final/h1n1-school-closures-sp-2009.dta" if (year == 2007 | year == 2009), clear
	
		reg math5  i.codmunic $controls2007 i.year i.T T2009 [aw = enrollment5] if G == 1 & tipo_municipio_ef1 == 1, cluster(codmunic)
		
		replace T = 0 if network == 3
		replace T2009 = 0 if network ==3 
		reg math5  i.codmunic $controls2007 i.year i.T T2009 [aw = enrollment5] if G == 0 & tipo_municipio_ef1 == 1, cluster(codmunic)
	
	drop 	 T2009
	clonevar T2009 = beta7
	reg 	math5 T2009 										 beta1-beta6 i.codmunic $controls2007 [aw = enrollment5] if year == 2007 | year == 2009, cluster(codmunic)

	
	
	use  "$final/h1n1-school-closures-sp-2009.dta" if (year == 2007 | year == 2009) & G == 0, clear
	
		gen M = network == 3
		
		drop beta*
		
		gen beta1 = T*M
		gen beta2 = T*D
		gen beta3 = M*D
		
		
		reg math5  i.codmunic $controls2007 i.T i.M i.D beta3 [aw = enrollment5] , cluster(codmunic)
	
		reg port5  i.codmunic $controls2007 i.T i.M i.D beta3 [aw = enrollment5] , cluster(codmunic)
	
	
	
	
	
	
	
	
	
	
	

				global controls2007 c.mother_edu_highschool5##c.mother_edu_highschool5 c.number_dropouts5##c.number_dropouts5 									///
				c.number_repetitions5##c.number_repetitions5 c.computer5##c.computer5																			///
				c.pib_pcap##c.pib_pcap c.work5##c.work5 						   																				///
				c.white5##c.white5 c.male5##c.male5 c.private_school5##c.private_school5 c.live_mother5##c.live_mother5 										///
				c.ComputerLab##c.ComputerLab c.ScienceLab##c.ScienceLab c.SportCourt##c.SportCourt 																///
				c.Library##c.Library c.InternetAccess##c.InternetAccess c.classhour5##c.classhour5 c.spt_5##c.spt_5 											///
				c.incentive_study5##c.incentive_study5 c.incentive_homework5##c.incentive_homework5 c.incentive_read5##c.incentive_read5	 					///
				c.incentive_school5##c.incentive_school5 c.incentive_talk5##c.incentive_talk5 c.incentive_parents_meeting5##c.incentive_parents_meeting5	
			

				
				
			use  "$final/h1n1-school-closures-sp-2009.dta" if (year == 2007 | year == 2009) & tipo_municipio_ef1 == 1 , clear
			
			gen M = network == 3


			gen beta8 = id_13_mun*D*M

			reg 	math5  i.codmunic $controls2007  beta1-beta6 beta8 [aw = enrollment5]  if year == 2007 | year == 2009, cluster(codmunic)
			reg 	port5  i.codmunic $controls2007  beta1-beta6 beta8 [aw = enrollment5]  if year == 2007 | year == 2009, cluster(codmunic)
			
			
			
			
			
			use  "$final/h1n1-school-closures-sp-2009.dta" if (year == 2007 | year == 2009) &  network == 3 , clear
			drop
			
			
			
			reg 	math5  i.codmunic $controls2007  i.T i.year T2009  [aw = enrollment5], cluster(codmunic)
			
			boottest T2009,  reps(1000)  boottype(wild) seed(102846) level(95) bootcluster(codmunic) quietly		//Standard errors using bootstrap. We do this in our dif-in-dif models as we have a few number of 

			
			
			
			use  "$final/h1n1-school-closures-sp-2009.dta" if (year == 2007 | year == 2009) &  network == 3 , clear
			
			reg 	math5  i.codmunic $controls2007  i.T i.year T2009  [aw = enrollment5], cluster(codmunic)
			
			boottest T2009,  reps(1000)  boottype(wild) seed(102846) level(95) bootcluster(codmunic) quietly		//Standard errors using bootstrap. We do this in our dif-in-dif models as we have a few number of 

			reg 	port5 i.codmunic $controls2007  i.T i.year T2009  [aw = enrollment5], cluster(codmunic)
			
			boottest T2009,  reps(1000)  boottype(wild) seed(102846) level(95) bootcluster(codmunic) quietly		//Standard errors using bootstrap. We do this in our dif-in-dif models as we have a few number of 
			
			
			
			
			
			
			
			
			
			
			
			
			drop beta*
	
			gen beta1    = E*G
			gen beta2  	 = E*D
			gen beta3    = G*D	
	
			gen beta4    = E*T*D
			gen beta5    = M*T*D
		
			
			
			reg port5 E G D T $controls2007 i.codmunic beta1-beta5  if tipo_municipio_ef1 == 1
			
			
			gen beta8 = M*D*T

			
	
			eststo: reg port5  $controls2007  i.treated i.network i.group i.year  beta6 beta8  [aw = enrollment5] if (year == 2007 | year == 2009) & tipo_municipio_ef1 == 1 , cluster(codmunic)
					
					
					
					
					
					
					
								*drop if codmunic == 3509502 | codmunic == 3520509 | codmunic == 3548807 	
			sort 	codschool year
			
			egen group = group(codmunic network)
			

					
			eststo: reg math5  $controls2007  i.codmunic##i.network i.treated  i.year  T2009 [aw = enrollment5] if (year == 2007 | year == 2009)			  , cluster(codmunic)
					
					
			eststo: reg math5  i.treated i.codmunic i.year $controls2007 beta5  T2009 [aw = enrollment5] if (year == 2007 | year == 2009)  			  , cluster(codmunic)

			
			
			
			xtset codschool year 
			
			xtreg math5 i.year $controls2007  T2009 if (year == 2007 | year == 2009)  & tipo_municipio_ef1 == 1	& G == 1			  , cluster(codmunic)
			
			xtreg math5
			
			
			use "$final/Performance & Socioeconomic Variables of SP schools.dta" if !missing(codschool) & year < 2015, clear 
			
	collapse (mean)math5 port5, by(year id_M network)
			tw 	///
			(line math5  year if network == 2, lwidth(0.5) color(emidblue) lp(solid) connect(direct) recast(connected) 	 												///  
			ml() mlabcolor(gs2) msize(1) ms(o) mlabposition(12)  mlabsize(2.5)) 																						///
			(line math5  year if network == 3, by(id_M) lwidth(0.5) color(cranberry) lp(shortdash) connect(direct) recast(connected) 	 								///  
			ml() mlabcolor(gs2) msize(1) ms(o) mlabposition(12)  mlabsize(2.5)																							///
			ylabel(, labsize(small) gmax angle(horizontal) format(%4.1fc))											     												///
			yscale( alt )  																																				///
			title("", pos(12) size(medium) color(black))													 															///
			xtitle("")  																																				///
			xlabel(2005(2)2009, labsize(small) gmax angle(horizontal) format(%4.0fc))											     									///
			graphregion(color(white) fcolor(white) lcolor(white) icolor(white) ifcolor(white) ilcolor(white))		 													///
			plotregion(color(white) fcolor(white) lcolor(white) icolor(white) ifcolor(white) ilcolor(white)) 															///						
			legend(order(1 "Estadual"  2 "Municipal"  3 "Contrafactual") size(small) region(lwidth(none) color(white) fcolor(none))) 									///
			ysize(5) xsize(5) 																										 									///
			note("", color(black) fcolor(background) pos(7) size(small)))  
			*graph export "$figures/.pdf", as(pdf) replace

			
			
			
			
			drop if id_13_mun == 1
			
			
			
			keep if year == 2007 | year == 2009 | year == 2011 | year == 2013
			replace G = 0 if year == 2011 | year == 2013
			
			replace year = 2007 if year == 2011 & G == 0
			replace year = 2009 if year == 2013 & G == 0
			
			drop beta* E D 
			
			gen E 		 = state_network	
			gen D 		 = (year == 2009)

			gen beta1    = E
			gen beta2    = G
			gen beta3    = D
			gen beta4    = E*G
			gen beta5    = E*D
			gen beta6  	 = G*D
			gen beta7    = E*G*D 				 //triple dif coefficient
			eststo: reg math5  i.codmunic 	 beta1-beta7  if (year == 2007 | year == 2009) & tipo_municipio_ef1 == 1, cluster(codmunic)
			
			
			
			
			use "$final/Performance & Socioeconomic Variables of SP schools.dta", clear 
			drop 	 T2009
			clonevar T2009 = beta7
			
			gen t = 1 if year  == 2007
			replace  t = 2 if year == 2009

			eststo: reg math5  beta1-beta6 i.codmunic 		$controls2007 T2009 [aw = enrollment5] if (year == 2007 | year == 2009) & tipo_municipio_ef1 == 1, cluster(codmunic)
			
		
			egen group = group(codmunic network)
			
			eststo: reg math5  i.codmunic i.year $controls2007  i.treated	i.t##i.network				T2009  [aw = enrollment5] if (year == 2007 | year == 2009) & tipo_municipio_ef1 == 1 & G == 1, cluster(codmunic)

		
		
		
		
		
						
				
		estout * using "$tables/Table2.csv"  , delimiter(";") keep(T2009*) 	label cells(b se) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0g %9.3f %9.2f)) replace

		 
		
		
		
		
		
	use "$final/Performance & Socioeconomic Variables of SP schools.dta" if id_M == 1 & tipo_municipio_ef1 == 1, clear 

	psmatch2 treated $balance_students5 if year == 2007, common ties 
	
	
	
	
	keep if _support  == 1
	
	tw (histogram math5 if network == 3, fcolor(none) lcolor(blue)) || (histogram math5 if network == 2, fcolor(none) lcolor(red))
	
	keep codschool _weight _pscore treated
	
	gen peso = _pscore/(1-_pscore)
	
	
											tw kdensity _pscore if treated == 1 [aw = peso],  lw(thick) lp(dash) color(emidblue) 					///
										///
										|| kdensity _pscore if treated == 0 [aw = peso],  lw(thick) lp(dash) color(gs12) 						///
											graphregion(color(white) fcolor(white) lcolor(white) icolor(white) ifcolor(white) ilcolor(white)) 	///
											plotregion(color(white) fcolor(white) lcolor(white) icolor(white) ifcolor(white) ilcolor(white)) 	///
											ylabel(, labsize(small) angle(horizontal) format(%2.1fc)) 											///
											xlabel(, labsize(small) gmax angle(horizontal)) 													///
											ytitle("", size(medsmall))			 																///
											xtitle("Propensity score", size(medsmall)) 															///
											title("", pos(12) size(medsmall)) 																	///
											subtitle(, pos(12) size(medsmall)) 																	
												
	
	
	tempfile school
	save `school'
	
		use "$final/Performance & Socioeconomic Variables of SP schools.dta" if id_M == 1 & tipo_municipio_ef1 == 1 & (year == 2007 | year == 2009), clear 

		merge m:1 codschool using  `school', keep(3)
		
		
			tw (histogram math5 if network == 3 & year == 2007, fcolor(none) lcolor(blue)) || (histogram math5 if network == 2 & year == 2007, fcolor(none) lcolor(red))
			tw (histogram math5 if network == 3 & year == 2009, fcolor(none) lcolor(blue)) || (histogram math5 if network == 2 & year == 2009, fcolor(none) lcolor(red))
		
		egen group = group(codmunic network)
			eststo: reg math5  i.treated i.group i.year 	T2009  [aw = peso], cluster(group)
		
		
		
		
		tw ///
		line math5 year if uf == "SP", lcolor(red) || line math5 year if uf == "ES", lcolor(blue) || ///
		line		math5 year if uf == "MG", lcolor(green) || line math5 year  if uf == "RJ", lcolor(black)
		
		
		
		
