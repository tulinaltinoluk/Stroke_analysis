USE strokeproject;
SELECT * FROM stroke;


-- ADDING id column to table 

ALTER TABLE stroke
ADD COLUMN id INT NOT NULL auto_increment Primary Key;

-- Changing position of id column

ALTER TABLE stroke
MODIFY COLUMN gender text
AFTER id;


-- searching for missing values

select count(*) as missig_values_ht from stroke where hypertension = "";
select count(*) as missig_values_age from stroke where age = "";

-- cleaning missing values

UPDATE stroke SET hypertension = 0 where hypertension = "";
SELECT distinct hypertension from stroke;


-- Data type conversion
ALTER TABLE stroke MODIFY hypertension INTEGER;

-- Checking after data type conversion
SELECT hypertension, count(*) as total_number  from stroke
group by  hypertension;

-- -- Comma was replaced with dot.
update stroke set bmi = replace (bmi, ",", ".") ;
update stroke set avg_glucose_level = replace (avg_glucose_level, ",", ".") ;

-- we had a value with date format to be corrected.

update stroke set bmi =  replace (bmi, "20.May", "20.4") 
where bmi ="20.May";


-- Having done cleaining, I converted data type to float.
ALTER TABLE stroke MODIFY bmi float;
ALTER TABLE stroke MODIFY heart_disease VARCHAR(10);
ALTER TABLE stroke MODIFY hypertension VARCHAR(10);
ALTER TABLE stroke MODIFY  avg_glucose_level float (8,3);
ALTER TABLE stroke MODIFY  bmi INTEGER;
ALTER TABLE stroke MODIFY stroke VARCHAR(10);



-- Cleaning irregular text spacing in this column.

UPDATE stroke
SET 
gender = TRIM(gender),
age = TRIM(age),
hypertension = TRIM(hypertension),
heart_disease = TRIM(heart_disease),
ever_married = TRIM(ever_married),
work_type = TRIM(work_type),
Residence_type = TRIM(Residence_type),
avg_glucose_level = TRIM(avg_glucose_level),
bmi = TRIM(bmi),
smoking_status = TRIM(smoking_status),
stroke = TRIM(stroke);

--  Checking for missing values

SELECT * FROM stroke
WHERE 
gender = "not known" OR
age = "" OR
hypertension = "" OR
heart_disease = ""  OR
ever_married = "" OR
work_type = "" OR
Residence_type = "" OR
avg_glucose_level = "" OR
bmi = "" OR
smoking_status = "" OR
stroke = "" ; 

-- Deleting unwanted values if necessary.

DELETE from stroke where 
ever_married = "" or gender = "not known" or smoking_status = "";



-- cleaining null values using IFNULL

UPDATE stroke
set ever_married =
  ifnull(ever_married, "No" );

-- checking for null values

SELECT * FROM stroke
WHERE  gender IS NULL or
age IS NULL or
hypertension IS NULL or
heart_disease IS NULL or
ever_married IS NULL or
work_type IS NULL or
Residence_type IS NULL or
avg_glucose_level IS NULL or
bmi IS NULL or
smoking_status IS NULL or
stroke IS NULL;



-- checking for duplicates 

SELECT DISTINCT id, COUNT(id) as duplicated
FROM stroke
GROUP BY id
HAVING COUNT(id) > 1 ;

-- double check for duplicates with another code

SELECT avg_glucose_level, gender, age,
stroke, heart_disease, Residence_type, work_type, ever_married, 
hypertension, smoking_status, bmi, count(*) as c 
from stroke
group by avg_glucose_level, age, gender, stroke, heart_disease,
Residence_type, work_type, ever_married, hypertension, smoking_status, bmi
having c > 1 ;



-- Null values can be seen using these two alternative queries below:

SELECT distinct
CASE WHEN
ever_married = "Yes" then "Yes"
else "No"
end as result
from stroke;


 select distinct ifnull(ever_married, "No" ) as result from stroke;
 
 
 -- Deleting unwanted values if necessary.

DELETE from stroke where 
ever_married = "" or gender = "not known" or smoking_status = "";
