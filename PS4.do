*______________________________________________________________________
*Data Management in Stata
*Kate Cruz, Fall 2017
*Problem Set 4 due: November 7th
*Stata Version 15/IC

/* For Problem Set 4 I began to work on my final project by using macros and loops.
I have combined all the problems sets below as separated by the different sections.
I have over 600 lines of code (including breaks and comments) 
In problem set 4 I created macros for my datasets to streamline lines of bulky web addresses. 
I used loops to run descriptive statistics for several of my variables of interest: health, food access, income*/ 



/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                
								
								PROBLEM SET 1 
								
								
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/ 


//For the purpose of this excerise I have chosen to merge NJ County Health Rankings Data (http://www.countyhealthrankings.org/rankings/data/nj) and data from the New Jersey Behavioral Risk Factor Survey in 2016. 
//New Jersey Behavioral Risk Factor Survey, Center for Health Statistics, New Jersey Department of Health Suggested citation: New Jersey Behavioral Risk Factor Survey (NJBRFS). New Jersey Department of Health, Center for Health Statistics, New Jersey State Health Assessment Data (NJSHAD) 
//Accessed at http://nj.gov/health/shad on [9/24/17] at [6pm].
//As an additional activity I have also merged data from the U.S. Census Bureau, 2016 American Community Survey 1-Year Estimates to add more demographic data (education, marital status, household size etc). 

//Using these data sets I hope to gain a clearer understading of the impact of the environment on public health. 
//I am interested to see if there is a correlation between access to food and/or green space and mental health and behavior. 
//Eventually I hope to merge data about tree count and pollution to see if the number of trees and the amount of air pollution impacts behavior and mental health.
/*Research questions may look like: 
Do trees negate negative impacts of pollution in highly polluted areas in New Jersey? Does race imapact the correlation? 
Does inaccces to healthy food impact behavior and mental health?
Does increased green space impact poverty and mental health?
More specifically, does tree cover impact air quality and public health related to air quality ie: asthma rates */ 



local worDir "C:\Users\kathr\Desktop\CLASS2"

capture mkdir ps2 
cd ps2

//PART 1: Manipulating Data using original data set. I chose to manipulate this dataset because it has more variables 
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCiZFZKbzhlOFN4Sm8&export=download", clear 

//First Round 
/*Renamed all of the variables in my dataset to provide clarity*/ 
rename A County 
rename B deaths 
rename C yearslost 
rename F zyearslost
rename G perfairpoorhealth
rename J zfairpoor
rename K puhdays
rename N zpuhdays
rename O muhdays
rename R zmuhdays
rename T lowbirth
rename U livebirth
rename V perlowbirth
rename Z persmoke
rename AC zsmoke 
rename AD perobese 
rename AG zobese 
rename AH foodindex
rename AI zfood
rename AJ perinactive
rename AM zinactive
rename AN perwaccess
rename AO zwaccess
rename AP perdrink
rename AS zdrink
rename AT aldrivedeath
rename AV peraldrivedeath
rename BC teenbirth
rename BD teenpop
rename BE teenbirthrate
rename BI uninsured
rename BJ peruninsured 
rename BM zuninsured 
rename BN PCP
rename BO PCPrate
rename BP zPCP
rename BQ dentist
rename BR dentistrate
rename BS zdentist 
rename BT MHproviders
rename BU MHPrate
rename BY medicaidenrolled
rename BZ prevhosprate
rename CC zprevhosprate
rename CD diabetics
rename CI zmedicareenrolled
rename CN cohortsize
rename CO gradrate
rename CP zgradrate
rename CQ somecollege
rename CR population 
rename CS persomecollege
rename CV zsomecollege
rename CW unemployed
rename CX laborforce 
rename CY perunemployed 
rename DA childpov
rename DB perchildpov
rename DE zchildpov
rename DF eightyincome
rename DG twentyincome
rename DH incomeratio
rename DI zincome 
rename DJ singleparent
rename DK households
rename DL persingleparent
rename DO zhouseholds
rename DP associations
rename DQ associationrate
rename DR zassociations 
rename DT violentcrimerate
rename DU zviolentcrime
rename DS violentcrime 
rename DV injurydeath
rename DW injurydeathrate
rename DZ zinjurydeath
rename EC violation
rename ED zviolation
rename EE severeproblems
rename EF persevereproblems
rename EI zsevereproblems 

//Dropped all irrelevant or confusing variables in the dataset to simplify 
drop D H L P W AA AE BF BK CA CF CK CT DC DM DC EG EM ER E I M Q S X AB AK AL AF AX AQ AW BF BG BK BL CA CB CF CG CK CM CT CU DC DD DM DN DX DY EG EH EM EN ER ES //removed the confidence intervals 
drop Y //unsure of what the zscore is related to therefore it is not necessary 
drop AU //number of driving deaths is not relevant 
drop AY BH CZ EO //unclear what these zscores are refering to 
drop AZ-BB //sexually transmitted diseases are not of interest to this study 
drop BV BW BX //as per note in the data, variable BT is the most up to date count of MHPs 
drop CE-CH //not relevant info 
drop CJ //mamography data not relevant to this study 
drop EA EB //not clear what this measures/relation to this study 
drop EJ-EL //number of drivers is irrelevant 
drop EP EQ ET //number of drivers who drive alone is irrelevant 

//code for cleaning
drop in 1/2 //these lines were confusing the data- they included variable names and statewide totals 
drop in 22/23 //these rows were extra/blank obersvations that were added when creating the new variable Region 

//Recode- 
//code for creating new region variables 
generate region=0
//region==0 means north 
//region==1 means south 
replace region=1 if County=="Burlington" | County=="Camden" | County=="Gloucester" | County=="Salem" | County=="Cumberland" | County=="Atlantic" | County=="Cape May" 
//region==2 means central
replace region=2 if County=="Hunterdon" | County=="Somerset" | County=="Middlesex" | County=="Monmouth" | County=="Ocean" | County=="Mercer" 
// = if you are assigning or generating, == for matching-find
move region deaths //this command moved the new variable to the front the the dataset

recode region (0/1=0 Non-Central) (1.1/2=1 Central), gen(region_2) //this allowed me to create a new level of comaprison looking at Central NJ in particular 
move region_2 region 


//destringing- most of my variables were not destrung and it was making it hard to calucate 
destring region deaths yearslost zyearslost perfairpoorhealth zfairpoor puhdays zpuhdays muhdays zmuhdays lowbirth livebirth perlowbirth persmoke zsmoke perobese zobese foodindex zfood perinactive zinactive perwaccess zwaccess perdrink zdrink aldrivedeath peraldrivedeath teenbirth teenpop teenbirthrate uninsured peruninsured zuninsured PCP PCPrate zPCP dentist dentistrate zdentist MHproviders MHPrate medicaidenrolled prevhosprate zprevhosprate diabetics zmedicareenrolled CL, replace

destring cohortsize gradrate zgradrate somecollege population persomecollege zsomecollege unemployed laborforce perunemployed childpov perchildpov zchildpov eightyincome twentyincome incomeratio zincome singleparent households persingleparent zhouseholds associations associationrate zassociations violentcrime violentcrimerate zviolentcrime injurydeath injurydeathrate zinjurydeath violation zviolation severeproblems persevereproblems zsevereproblems, replace

//violations for regressions- because violations would not destring because the obersvations were "yes" and "no" I created a new variable and assigned numeric values 
generate violations_r=0
replace violations_r=1 if violation=="Yes"
move violations_r violation
 
save kate_ps2

//Collapse- created a dummy variable for region and separated the counties into 3 regions: North, Central, South and used collapse to group 0=North 2=Central 1=South using county boundaries as defined by the State of New Jersey http://www.state.nj.us/transportation/about/directory/images/regionmapc150.gif
collapse childpov, by(region) //North Jersey has the largest population of children in poverty(20,000) followed by Central (13,627)and South Jersey (9,824)
collapse perchildpov, by(region) //When accounting for population size South Jersey has the highest rate of child poverty (18.7%), North Jersey with 15.7 and Central with 11.8 

clear //the collapse command creates issues when recalling the dataset so I cleared the data and started from where I left off prior to collapse 
use kate_ps2 

//Bys:egen- 
egen unhealthy=rowmean(muhdays puhdays) //I combined mental and physical health to create a measurement of overall poor health or unhealthy based on the means pulled by this code I see that Atlantic, Hudson, Ocean and Salem have the poorest overall health (with Camden following right behind) 
move unhealthy deaths 

egen av_deaths=mean(deaths), by(region) // this code produced the mean number of deaths for each region and shows that Central NJ has the largest average of deaths 
move av_deaths deaths 

//Second Round:Cleaning dataset to merge 
clear 
cd ps2
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCiWk1BYUc3R3FFWkE&export=download", clear //this is my second dataset the behavioral risk survey 
rename A County //renamed the column for more clarity 
rename B Countyid 
rename C responses
rename D samplesize
rename E perstressdays //percentage of mental stress days 

drop F G //confidence intervals are not relevant at this time 
drop in 1/11 //Drop or Keep- I dropped labels and introductory information  
drop in 22/66 //dropped footnotes 

//destringing- my variables were not destrung and it was making it hard to calucate 
destring Countyid, gen(Countyid_n) 
destring responses, gen(responses_n)
destring samplesize, gen(samplesize_n)
destring perstressdays, gen(perstressdays_n) 

//Recode- 
//code for creating new region variables 
generate region=0
//region==0 means north 
//region==1 means south 
replace region=1 if County=="Burlington" | County=="Camden" | County=="Gloucester" | County=="Salem" | County=="Cumberland" | County=="Atlantic" | County=="Cape May" 
//region==2 means central
replace region=2 if County=="Hunterdon" | County=="Somerset" | County=="Middlesex" | County=="Monmouth" | County=="Ocean" | County=="Mercer" 

save kate_ps22 //didn't save as kate_ps2 because it is a different dataset

bys region: egen avgStress=mean(perstressdays_n) //shows the average percentage of stressful days per county. South Jersey has the highest average (15%), Central Jersey (10%) and North (9%) 

 
//PART 2: Merging Datasets 
clear 
cd ps2
use kate_ps2
merge 1:1 County using kate_ps22
save kate_ps2final

//Cleaning 3rd data set to merge: Source: U.S. Census Bureau, 2016 American Community Survey 1-Year Estimates
clear
pwd
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCiZHRMT3BWNEZjNW8&export=download", clear 
keep C D H J L N P R T V AR AJ AB AN AP CB CD EN EP GZ HB IH IF JD JF LD LF QB QD QF QH QN QP RD RF RL RN 
drop JD 
rename C County 
rename D households
rename H families
rename J perfamilies
rename L familieswchildren
rename N perfamilieswchildren
rename P marcouplefam
rename R permarcouplefam
rename T marcouplewchildren
rename V permarcouplewchildren 
rename AR livealone
rename AJ singlemom
rename AB singledad
rename AN nonfamily
rename AP pernonfamily
rename CB children
rename CD perchildren
rename EN givebirthpastyr
rename EP pergivebirthpastyr
rename GZ inschool
rename HB perinschool
rename IH nodiploma
rename JD pernodiploma
rename JF perhsabove
rename LD samehouse
rename LF persamehouse
rename QB englishonly
rename QD perenglishonly
rename QF notenglish
rename QH pernotenglish
rename QN spanish
rename QP perspanish
rename RD api
rename RF perapi
rename RL otherlang
rename RN perotherlang

drop in 1 //removed NJ state level data 
replace County = "Atlantic" in 1
replace County = "Bergen" in 2 
replace County = "Burlington" in 3
replace County = "Camden" in 4
replace County = "Cape May" in 5
replace County = "Cumberland" in 6
replace County = "Essex" in 7
replace County = "Gloucester" in 8
replace County = "Hudson" in 9
replace County = "Hunterdon" in 10
replace County = "Mercer" in 11
replace County = "Middlesex" in 12
replace County = "Monmouth" in 13
replace County = "Morris" in 14
replace County = "Ocean" in 15
replace County = "Passaic" in 16
replace County = "Salem" in 17
replace County = "Somerset" in 18
replace County = "Sussex" in 19
replace County = "Union" in 20
replace County = "Warren" in 21

generate region=0
//region==0 means north 
//region==1 means south 
replace region=1 if County=="Burlington" | County=="Camden" | County=="Gloucester" | County=="Salem" | County=="Cumberland" | County=="Atlantic" | County=="Cape May" 
//region==2 means central
replace region=2 if County=="Hunterdon" | County=="Somerset" | County=="Middlesex" | County=="Monmouth" | County=="Ocean" | County=="Mercer" 
move region households

destring households families perfamilies familieswchildren perfamilieswchildren marcouplefam permarcouplefam marcouplewchildren permarcouplewchildren livealone singlemom singledad nonfamily, replace 
destring pernonfamily children perchildren givebirthpastyr pergivebirthpastyr inschool perinschool nodiploma pernodiploma perhsabove samehouse persamehouse englishonly perenglishonly, replace 
destring notenglish pernotenglish spanish perspanish api perapi otherlang perotherlang, replace 

pwd
save kate_ps2census

//Second Merge 
clear
pwd 
cd C:\Users\kathr\Documents\ps2\ps2
use kate_ps2final
drop _merge
merge 1:1 County using kate_ps2census 
save kate_ps2complete




/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                              
							  
							  PROBLEM SET 2 
							  
							  
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/ 

/*Building upon previous assignements, I will merge 4 additional datasets to the exisiting data listed below. It is my hope to add more of the environmental data to this dataset.
I have a great amount of data about education, family type, poverty, and health but not much detail about environmental variables like pollution or hunger. 
For this reason I chose to add data about the release of toxins into the environment, measures of pollution and the use of food stamps as well as population counts for multiple years.

Exisiting Data:
1- NJ County Health Rankings Data (http://www.countyhealthrankings.org/rankings/data/nj)
2- New Jersey Behavioral Risk Factor Survey http://nj.gov/health/shad 
3- U.S. Census Bureau, 2016 American Community Survey 

New Data: 
4- The first new dataset is from the Center for Disease Control and Prevention and is a list of the number of toxic releases by County in 2007:this could be interesting to look for counties with more toxic releases and health data.  
Centers for Disease Control and Prevention. Environmental Public Health Tracking Network. Acute Toxic Substance Releases. Accessed From Environmental Public Health Tracking Network: www.cdc.gov/ephtracking. Accessed on 10/14/2017
note: I would love to have data from 2015 since most of my other datasets are from this year but this was the most recent I could find. This would be good to research further. 
5- The second new data set is from the EPA and it shows pollution levels by County for 2015- I will need to analyze this data further to understand what levels are safe/unsafe but it will be great for comparison 
https://www.epa.gov/outdoor-air-quality-data/air-quality-statistics-report
6- The third dataset is from the Food Access and Research Center (FARC) and it is County SNAP (food stamp) usage from 2011-2015 and simply shows the use of the Supplemental Nutrition Assistance Program. 
7- The fourth dataset is from the US Census Bureau and it contains population counts by County for 2010-2016 https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?src=bkmk
*/ 

local worDir "C:\Users\kathr\Desktop\combinereshape"
 
capture mkdir ps3 
cd ps3 


/*_______________________________________________________

      STEP 1: Preparing the new datasets 
_________________________________________________________*/ 

//Toxic Release Data
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCianducmRLbl84dzQ&export=download", clear firstrow 
drop stateFIPS State countyFIPS Year Stability 
generate region=0
 //region==0 means north 
 //region==1 means south 
replace region=1 if County=="Burlington" | County=="Camden" | County=="Gloucester" | County=="Salem" | County=="Cumberland" | County=="Atlantic" | County=="Cape May" 
 //region==2 means central
replace region=2 if County=="Hunterdon" | County=="Somerset" | County=="Middlesex" | County=="Monmouth" | County=="Ocean" | County=="Mercer" 
move region County 
save kate_ps3toxic, replace 

//EPA air pollution Data
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCic1lHUUxUZHhvZGs&export=download", clear firstrow 
drop CountyCode 
//Dr. Adam gave the code to generate a new variable to lessen the error but I wasn't sure if I could create a new variable such as mycounty and still use it for merging on "County" 
replace County = "Atlantic" in 1
replace County = "Bergen" in 2 
replace County = "Camden" in 3
replace County = "Cumberland" in 4
replace County = "Essex" in 5
replace County = "Gloucester" in 6
replace County = "Hudson" in 7
replace County = "Hunterdon" in 8
replace County = "Mercer" in 9
replace County = "Middlesex" in 10
replace County = "Monmouth" in 11
replace County = "Morris" in 12
replace County = "Ocean" in 13
replace County = "Passaic" in 14
replace County = "Union" in 15
replace County = "Warren" in 16

generate region=0
 //region==0 means north 
 //region==1 means south 
replace region=1 if County=="Camden" | County=="Gloucester" | County=="Cumberland" | County=="Atlantic"  
 //region==2 means central
replace region=2 if County=="Hunterdon" | County=="Middlesex" | County=="Monmouth" | County=="Ocean" | County=="Mercer" 
move region County 

save kate_ps3pollution, replace 

//County SNAP usage
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCicWZRS3c2MFhianM&export=download", clear firstrow 
replace County = "Passaic" in 1
replace County = "Cumberland" in 2 
replace County = "Essex" in 3
replace County = "Hudson" in 4
replace County = "Atlantic" in 5
replace County = "Camden" in 6
replace County = "Salem" in 7
replace County = "Mercer" in 8
replace County = "Union" in 9
replace County = "Ocean" in 10
replace County = "Gloucester" in 11
replace County = "Cape May" in 12
replace County = "Warren" in 13
replace County = "Middlesex" in 14
replace County = "Monmouth" in 15
replace County = "Burlington" in 16
replace County = "Bergen" in 17
replace County = "Sussex" in 18
replace County = "Morris" in 19
replace County = "Hunterdon" in 20
replace County = "Somerset" in 21

drop State
drop MetroSmallTownRuralStatus

generate region=0
 //region==0 means north 
 //region==1 means south 
replace region=1 if County=="Burlington" | County=="Camden" | County=="Gloucester" | County=="Salem" | County=="Cumberland" | County=="Atlantic" | County=="Cape May" 
 //region==2 means central
replace region=2 if County=="Hunterdon" | County=="Somerset" | County=="Middlesex" | County=="Monmouth" | County=="Ocean" | County=="Mercer" 
move region County 

save kate_ps3snap, replace 

//NJ County Census Data 2010-2016 

import excel "https://docs.google.com/uc?id=0B1opnkI-LLCiV2tGMjhfTTZjWkE&export=download", clear firstrow 
drop GEOid GEOid2 rescen42010 resbase42010 
drop in 1/1
rename GEOdisplaylabel County
replace County = "Atlantic" in 1
replace County = "Bergen" in 2 
replace County = "Burlington" in 3
replace County = "Camden" in 4
replace County = "Cape May" in 5
replace County = "Cumberland" in 6
replace County = "Essex" in 7
replace County = "Gloucester" in 8
replace County = "Hudson" in 9
replace County = "Hunterdon" in 10
replace County = "Mercer" in 11
replace County = "Middlesex" in 12
replace County = "Monmouth" in 13
replace County = "Morris" in 14
replace County = "Ocean" in 15
replace County = "Passaic" in 16
replace County = "Salem" in 17
replace County = "Somerset" in 18
replace County = "Sussex" in 19
replace County = "Union" in 20
replace County = "Warren" in 21

generate region=0
 //region==0 means north 
 //region==1 means south 
replace region=1 if County=="Burlington" | County=="Camden" | County=="Gloucester" | County=="Salem" | County=="Cumberland" | County=="Atlantic" | County=="Cape May" 
 //region==2 means central
replace region=2 if County=="Hunterdon" | County=="Somerset" | County=="Middlesex" | County=="Monmouth" | County=="Ocean" | County=="Mercer" 
move region County

save kate_ps3census, replace 

/*__________________________________________________

                STEP 2: MERGE NEW DATASETS
____________________________________________________*/ 

use "https://docs.google.com/uc?id=0B1opnkI-LLCiVVdTS3hDX0ZsUUE&export=download" //this is the merged dataset from PS2
drop _merge 
merge 1:1 County using kate_ps3toxic 
save kate_ps3, replace 

use kate_ps3
drop _merge 
merge 1:1 County using kate_ps3pollution
//note: 5 variables were not matched from the master because 5 states were mising from this dataset 
save kate_ps3, replace 

use kate_ps3
drop _merge 
merge 1:1 County using kate_ps3snap
save kate_ps3, replace 

use kate_ps3
drop _merge 
merge m:1 County using kate_ps3census 
drop _merge 
save kate_ps3, replace 



/*_______________________________________________________

             STEP 3: RESHAPE 
_________________________________________________________*/ 


use kate_ps3census 
reshape long respop, i (County) j(year)
//this was actually pretty cool! It created multiple lines for each County- this could be useful for viewing the data by County and year in a nice orderly row. 
reshape wide respop, i (County) j(year) //this moved the data back to its original wide format 



 

/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


                                   PROBLEM SET 4 
								   
								   
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/ 

/*_________________________________________

             STEP 1: MACROS 
___________________________________________*/ 

//Using original dataset County Health Rankings 
//use "https://docs.google.com/uc?id=0B1opnkI-LLCiZFZKbzhlOFN4Sm8&export=download"
loc gooPre "https://docs.google.com/uc?id="
loc gooSuf "&export=download"
loc goohealth= "`gooPre'"+"0B1opnkI-LLCiZFZKbzhlOFN4Sm8"+"`gooSuf'"
di "`goohealth'" 
use "`goohealth'", clear  

//Using Census Data from PS1 
//use "https://docs.google.com/uc?id=0B1opnkI-LLCiZHRMT3BWNEZjNW8&export=download"
loc gooPre "https://docs.google.com/uc?id="
loc gooSuf "&export=download"
loc goohealth= "`gooPre'"+"0B1opnkI-LLCiZHRMT3BWNEZjNW8"+"`gooSuf'"
di "`goocensus'" 
use "`goocensus'", clear 

 
//PS2 https://drive.google.com/open?id=0B1opnkI-LLCiVVdTS3hDX0ZsUUE 
//use "https://docs.google.com/uc?id=0B1opnkI-LLCiVVdTS3hDX0ZsUUE&export=download" //this is the merged dataset from PS2
loc gooPre "https://docs.google.com/uc?id="
loc gooSuf "&export=download"
loc gooPS2= "`gooPre'"+"0B1opnkI-LLCiVVdTS3hDX0ZsUUE"+"`gooSuf'"
di "`gooPS2'"
use "`gooPS2'", clear //completed dataset from PS2 on my google drive and made public
clear 
 
//Using PS3 merged data
//PS3 https://drive.google.com/open?id=0B1opnkI-LLCiVWtNaVdPRmtETlk
//use ""https://docs.google.com/uc?id=0B1opnkI-LLCiVWtNaVdPRmtETlk&export=download" //this is merged dataset from PS3 
loc gooPre "https://docs.google.com/uc?id="
loc gooSuf "&export=download" 
loc gooPS3= "`gooPre'"+"0B1opnkI-LLCiVWtNaVdPRmtETlk"+"`gooSuf'" 
di "`gooPS3'" 
use "`gooPS3'", clear  

//Using EPA Air Pollution Dataset 
//use "https://docs.google.com/uc?id=0B1opnkI-LLCic1lHUUxUZHhvZGs&export=download"
loc gooPre "https://docs.google.com/uc?id="
loc gooSuf "&export=download"
loc goohealth= "`gooPre'"+"0B1opnkI-LLCic1lHUUxUZHhvZGs"+"`gooSuf'"
di "`gooEPA'" 
use "`gooEPA'", clear 

/*____________________________________________________
          
		  STEP 2: LOOPS USING PS3 MERGED DATASET  
_______________________________________________________*/ 
//Using PS3 merged data
loc gooPre "https://docs.google.com/uc?id="
loc gooSuf "&export=download" 
loc gooPS3= "`gooPre'"+"0B1opnkI-LLCiVWtNaVdPRmtETlk"+"`gooSuf'" 
di "`gooPS3'" 
use "`gooPS3'", clear 

//--------------------
//to tabulate the distribution of several key variables I used the following code 
foreach v of varlist perchildpov nodiploma persevereproblems violentcrime muhdays puhdays{
 ta `v', p
}
/*I learned that the most common percentage of physically unhealthy days was 3.7 and 2.9
Similarly I found that mentally unhealthy days were most commonly reported at 3.2, 3.6 and 3.7 days 
19 percent was the most common for severe housing problems and 11% for child poverty*/  

//-------------------SCATTERPLOT---------------- 
//to create a scatterplot graph of health and food access by County I used the following code 
foreach v of varlist foodindex {

  scatter `v' perfairpoorhe, mlab(County)
 
gr export `v'.pdf
}
//what we see is a correlation between access to healthy food and health- the higher the food access the lower the level of poor health 

//to better understand the relationship between food access and mentally unhealthy days 
foreach v of varlist foodindex {

scatter `v' muhdays, mlab(County)

gr export `v'.pdf 
}
//the better access to food, the less mentally unhealthy days you have 

//--------------------HISTOGRAM----------------
//to see a histogram of the percentage of fair and poor health I used the following code 
foreach v of varlist perfairpoorhe {
hist `v', 
}

//--------------------BAR GRAPH-----------------
//bar graph of the percentage of poor and fair health by County- this makes it very easy to compare quickly  
hist perfairpoorhe, freq
gr hbar perfairpoorhe, over(County, sort(perfairpoorhe))
//Hudson has the poorest reported levels of health with Cumberland following right behind 

//bar graph of the percentage of obesity by County 
hist perobese, freq
gr hbar perobese, over(County, sort(perobese)) 
//the highest rate of obesity is Cumberland County. I am seeing a pattern that Cumberland County scores very low in health rankings and has many social issues. 


//--------------BRANCHING------------------------

foreach var of varlist *{
           capture confirm numeric variable `var'
           if _rc==0 {
             sum `var', meanonly
             replace `var'=`var'-r(mean)
           } 
           else display as error "`var' is not a numeric variable and cannot be demeaned."
         }
sum
clear 
//This gave me the means and standard deviations for all the numeric variables 











