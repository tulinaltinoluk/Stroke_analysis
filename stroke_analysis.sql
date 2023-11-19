
 
 -- descriptive statistics of numeric values
 
 SELECT count(age) as count, MAX(age) as max_age, MIN(age) as min_age, ROUND(AVG(age),2) as mean_age, ROUND(STDDEV(age),2) as std_dev_age
from stroke;

 SELECT count(bmi) as count, MAX(bmi) as max_bmi, MIN(bmi) as min_bmi, ROUND(AVG(bmi),2) as mean_bmi, ROUND(STDDEV(bmi),2) as std_dev_bmi
 from stroke;
 
 SELECT count(avg_glucose_level) as count, MAX(avg_glucose_level) as max_glucose, MIN(avg_glucose_level) as min_glucose, ROUND(AVG(avg_glucose_level),2) as mean_glucose, ROUND(STDDEV(avg_glucose_level),2) as std_dev_glucose
 from stroke;
 
  -- age distribution for later use of histogram chart 
  
  SELECT distinct age, count(id) as frequency FROM stroke
  GROUP BY age;
  
  
  -- creating age bins and grouping people by HT status - USING CASE WHEN

select 
CASE WHEN age >= 18 and age <= 39 THEN "Young Adult"
WHEN age >= 40 and age <=59 THEN "Middle-Aged Adult"
WHEN age >= 60 and age <= 89 THEN "Old Adult"
END AS Age_bins, count(id) count, hypertension as HT
from stroke group by Age_bins, hypertension;
  
  
  
  -- proportions of health conditions
  
  SELECT  SUM(hypertension) as total_hypertension, SUM(heart_disease) as total_heart_disease, SUM(stroke) as total_stroke
  FROM stroke;
 
  -- average values 

SELECT gender, ROUND(AVG(bmi),1) as avg_bmi, ROUND(AVG(avg_glucose_level),1) AS avg_glucose, ROUND(AVG(age),0) as avg_age
FROM stroke
GROUP BY gender;

-- gender proportion

SELECT gender, count(id) as count 
FROM stroke
GROUP BY gender;


-- residence type proportion

SELECT Residence_type, count(*) as count
FROM stroke
GROUP BY Residence_type;


-- Does sex affect disease risk? -  USING WINDOW FUNCTIONS

select distinct gender,
SUM(heart_disease) over(partition by gender) as HD,
SUM(hypertension) over(partition by gender) as HT,
SUM(stroke) over(partition by gender) as stroke_status
from stroke;

-- How does residence type affect health? -  USING WINDOW FUNCTIONS

select distinct Residence_type,
SUM(heart_disease) over(partition by Residence_type) as HD,
SUM(hypertension) over(partition by Residence_type) as HT,
SUM(stroke) over(partition by Residence_type) as stroke_status
from stroke;

-- Evaluating residence type and work type together on disease  -  USING WINDOW FUNCTIONS

SELECT distinct work_type,  Residence_type, 
 SUM(hypertension) over(partition by  Residence_type, work_type) as HT,
 SUM(heart_disease) over(partition by Residence_type, work_type) as HD,
 SUM(stroke)  over(partition by Residence_type, work_type) as stroke
from stroke; 




 --  effect of residence type on diseases
 
SELECT  Residence_type, SUM(hypertension) as hypertension_status, SUM(stroke) as stroke_status,
SUM(heart_disease) as heart_disease_status
from stroke group by Residence_type;

-- effect of work type on diseases
SELECT   work_type, SUM(hypertension) as hypertension_status, SUM(stroke) as stroke_status,
SUM(heart_disease) as heart_disease_status
from stroke GROUP by work_type;


 -- smoking and health conditions association
 
 SELECT  smoking_status , SUM(hypertension) as hypertension_status, SUM(stroke) as stroke_status,
SUM(heart_disease) as heart_disease_status
from stroke GROUP by smoking_status; 

-- people who never smoked seem healthier, we need to check if there is an imbalance among groups.




-- smoking status proportion (checking for imbalance)
SELECT count(id) as count, smoking_status from stroke
GROUP BY smoking_status;


-- marriage status proportion
SELECT ever_married, count(id) from stroke
group by ever_married;


-- residence type and marriage status proportion association

SELECT Residence_type,  ever_married, count(id) as count from stroke
group by Residence_type, ever_married order by 1,2 asc;

 -- marriage status and health conditions association

SELECT  ever_married, SUM(hypertension) as hypertension_status, SUM(stroke) as stroke_status,
SUM(heart_disease) as heart_disease_status
from stroke group by ever_married ;


 -- stroke patients vs. healthy adults proportion as percentage
SELECT stroke, 
round( count(*) * 100.0 / sum(count(*)) over () , 0 ) as percentage
from stroke
GROUP BY stroke ;


-- exploring the effects of smoking on health parameters

SELECT smoking_status, ROUND(avg(bmi),1) as average_bmi, ROUND(avg(age),1) as average_age, 
ROUND(avg(avg_glucose_level),1) as average_glucose 
FROM stroke group by smoking_status;


-- exploring the effects of work type on health parameters
SELECT work_type, ROUND(avg(bmi),1) as average_bmi, ROUND(avg(age),1) as average_age, 
ROUND(avg(avg_glucose_level),1) as average_glucose 
FROM stroke group by work_type;

-- exploring the effects of marriage status on health parameters (The minimum underage marriage age is 18 in the US)
SELECT ever_married, age,  ROUND(avg(bmi),1) as average_bmi, ROUND(avg(age),1) as average_age, 
ROUND(avg(avg_glucose_level),1) as average_glucose 
FROM stroke group by ever_married, age
HAVING age > 18
order by ever_married desc;


--  average age of stroke patients grouped by gender

SELECT gender, round(avg(age),0) as average_age
from stroke
group by gender, stroke
having stroke = "1";

 -- gender proportion of stroke patients
 
 SELECT gender, count(*) as stroke_patient
from stroke
group by gender, stroke
having stroke = "1";

select stroke, round(avg(avg_glucose_level), 2) as average_glucose
from stroke
group by stroke;



-- exploring the effect of hypertension, heart disease on stroke

select stroke, hypertension, count(hypertension) as hypertension_patients
from stroke
group by stroke, hypertension;

select stroke , heart_disease, count(heart_disease) as heart_disease_patients
from stroke
group by stroke, heart_disease;


























