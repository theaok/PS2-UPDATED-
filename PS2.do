//yes, good to have a sense of humor when making commits! :)
//manipulated data sets and merged -phew!!

*______________________________________________________________________
*Data Management in Stata
*Kate Cruz, Fall 2017
*Problem Set 2 due: October 3rd 
*Stata Version 15/IC

//can have everything in nice lock comment, though a matter of taste! (just less typing this way)
/*
For the purpose of this excerise I have chosen to merge NJ County Health Rankings Data (http://www.countyhealthrankings.org/rankings/data/nj) and data from the New Jersey Behavioral Risk Factor Survey in 2016. 
New Jersey Behavioral Risk Factor Survey, Center for Health Statistics, New Jersey Department of Health Suggested citation: New Jersey Behavioral Risk Factor Survey (NJBRFS). New Jersey Department of Health, Center for Health Statistics, New Jersey State Health Assessment Data (NJSHAD) 
Accessed at http://nj.gov/health/shad on [9/24/17] at [6pm].
As an additional activity I have also merged data from the U.S. Census Bureau, 2016 American Community Survey 1-Year Estimates to add more demographic data (education, marital status, household size etc). 

great! additional activity is awesome; because the forst two are very similar--in fact county health rankings are made from brfss!

Using these data sets I hope to gain a clearer understading of the impact of the environment on public health. 
I am interested to see if there is a correlation between access to food and/or green space and mental health and behavior. 

cool! yes! definitely!! and mental health is a big topic these days! 


Eventually I hope to merge data about tree count and pollution to see if the number of trees and the amount of air pollution impacts behavior and mental health.

great! and i may help here also substantively as this is my area of reasearch!

Research questions may look like: 
Do trees negate negative impacts of pollution in highly polluted areas in New Jersey? Does race imapact the correlation? 
Does inaccces to healthy food impact behavior and mental health?
Does increased green space impact poverty and mental health?
More specifically, does tree cover impact air quality and public health related to air quality ie: asthma rates */ 

//all great! just may need to think about uinit of analysis and possible datasets we may use 
//and there may be several different aggregation levels we may want to use!--it does look promising


*--------------------------------------------------------------------
*--------------------------------------------------------------------

local worDir "C:\Users\kathr\Desktop\CLASS2"

capture mkdir ps2 
cd ps2

//PART 1: Manipulating Data using original data set. I chose to manipulate this dataset because it has more variables 
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCiZFZKbzhlOFN4Sm8&export=download", clear 
//fine, but can do it also this way:
//import excel "https://docs.google.com/uc?id=0B1opnkI-LLCiZFZKbzhlOFN4Sm8&export=download", clear  firstrow
//d

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
//now as a check can see how names correspond to first row
l in 1 //ok quick scan reveals that probably fine


//Dropped all irrelevant or confusing variables in the dataset to simplify 
drop D H L P W AA AE BF BK CA CF CK CT DC DM DC EG EM ER E I M Q S X AB AK AL AF AX AQ AW BF BG BK BL CA CB CF CG CK CM CT CU DC DD DM DN DX DY EG EH EM EN ER ES //removed the confidence intervals 
//yes! awesome! but probably better had to keep fewer variables still
//can always add more later--so could have kept say 10 with keep command and then rename them
//would be easier; same below--did a lot of work, which is fine
//but always try to simplify--so here would mean to retain only the very most important vars
//and can always add more later if needed

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

//code for cleaning good
drop in 1/2 //these lines were confusing the data- they included variable names and statewide totals 
drop in 22/23 //these rows were extra/blank obersvations that were added when creating the new variable Region 

//this chunk below seems fine--we laready discussed it

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
destring *, replace //again simplify

//violations for regressions- because violations would not destring because the obersvations were "yes" and "no" I created a new variable and assigned numeric values 
generate violations_r=0
replace violations_r=1 if violation=="Yes"
move violations_r violation
//yes great! but dont forget to check foir missing values
 ta violation, nola mi 
//if there were missing  or coded as sth else than 0 or 1 then such recoding 
//could have been wrong; in general use tabulate a lot!
 
save kate_ps2, replace //always must be replace there! 
//and if you saved then probably you want to say 
use kate_ps2, clear //and then you can start from here next time

//Collapse- created a dummy variable for region and separated the counties into 3 regions: North, Central, South and used collapse to group 0=North 2=Central 1=South using county boundaries as defined by the State of New Jersey http://www.state.nj.us/transportation/about/directory/images/regionmapc150.gif
collapse childpov, by(region) //North Jersey has the largest population of children in poverty(20,000) followed by Central (13,627)and South Jersey (9,824)

//this wouldn't fly--if you collapsed once then cannot collapse agiain--ned to start with fresh data!
use kate_ps2, clear
collapse perchildpov, by(region) //When accounting for population size South Jersey has the highest rate of child poverty (18.7%), North Jersey with 15.7 and Central with 11.8 

clear //the collapse command creates issues when recalling the dataset so I cleared the data and started from where I left off prior to collapse 
use kate_ps2 //yes exactly!

//Bys:egen- great! as discussed earlier!
egen unhealthy=rowmean(muhdays puhdays) //I combined mental and physical health to create a measurement of overall poor health or unhealthy based on the means pulled by this code I see that Atlantic, Hudson, Ocean and Salem have the poorest overall health (with Camden following right behind) 
move unhealthy deaths 

egen av_deaths=mean(deaths), by(region) // this code produced the mean number of deaths for each region and shows that Central NJ has the largest average of deaths 
move av_deaths deaths 

//great; can make this section more conspicious! like:

//-------------------------------------------------------------------------------------------------
//Second Round:Cleaning dataset to merge 
//-------------------------------------------------------------------------------------------------


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

save kate_ps22, replace //didn't save as kate_ps2 because it is a different dataset

bys region: egen avgStress=mean(perstressdays_n) //shows the average percentage of stressful days per county. South Jersey has the highest average (15%), Central Jersey (10%) and North (9%) 
list //ok, but collapse would be better more clean, and max is 12 not 15!
 
//PART 2: Merging Datasets 
clear 
cd ps2
use kate_ps2
merge 1:1 County using kate_ps22
save kate_ps2final

//again can make it more conspicious!

*------------------------------------------------------------------------------------------------------------
//Cleaning 3rd data set to merge: Source: U.S. Census Bureau, 2016 American Community Survey 1-Year Estimates
*------------------------------------------------------------------------------------------------------------

clear
pwd
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCiZHRMT3BWNEZjNW8&export=download", clear 
//can also experiment with cellrange option and firstrow to get names right away into stata

keep C D H J L N P R T V AR AJ AB AN AP CB CD EN EP GZ HB IH IF JD JF LD LF QB QD QF QH QN QP RD RF RL RN 
// drop JD for some reason breaks for me here; again, important it doesnt break
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
//again, this is great, but we want to be lazy and just do bare minimum
//so could have just retained few vars--can always add more later :)

//this can work, but is dangeorus! easy to make a mistake ! better
/*
gen myCounty=""
replace myCounty= "Atlantic" if County=="Atlantic County, New Jersey"
//and so forth!
*/

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

destring *, replace
pwd
save kate_ps2census, replace

//Second Merge 
clear
pwd 
cd C:\Users\kathr\Documents\ps2\ps2
use kate_ps2final
drop _merge
merge 1:1 County using kate_ps2census //aha! some of them did not merge--need to
//investigate--we will discuss to day!!
save kate_ps2complete





//overall great job!










 





























