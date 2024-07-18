--EXPLORATORY DATA ANALYSIS:

--Pulling together crime vs pop by borough
SELECT
   a.BOROUGH, COUNT(*) AS crime, b.POPULATION_2024, 100*(COUNT(*)/POPULATION_2024) AS pct_crime
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final` AS a
JOIN `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024` AS b
ON a.BOROUGH = b.BOROUGH
GROUP BY a.BOROUGH, b.POPULATION_2024

--Number of crimes per borough
SELECT BOROUGH, COUNT(*) AS crime
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
GROUP BY BOROUGH

--Number of crimes in Manhattan with a CTE
WITH manhattan AS (
  SELECT COUNT(*) AS total_m
  FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
  WHERE BOROUGH = 'Manhattan')
SELECT *
FROM manhattan

--Percentage of crime by borough
SELECT 
   BOROUGH
   ,count(*) / (sum(count(*)) OVER()) as pct
FROM  
   `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
GROUP BY 
   BOROUGH
ORDER BY pct DESC

--Top PERP_RACE by borough
WITH a AS (
    SELECT BOROUGH,
           PERP_RACE,
           COUNT(*) AS race_count,
           ROW_NUMBER() OVER (PARTITION BY BOROUGH ORDER BY COUNT(*) DESC) AS rn
    FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
    GROUP BY BOROUGH, PERP_RACE
)
SELECT BOROUGH, PERP_RACE, race_count
FROM a
WHERE rn = 1;

--Race ranked by crime count for each borough
WITH a AS (
    SELECT BOROUGH,
           PERP_RACE,
           COUNT(*) AS race_count,
           ROW_NUMBER() OVER (PARTITION BY BOROUGH ORDER BY COUNT(*) DESC) AS rn
    FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
    GROUP BY BOROUGH, PERP_RACE
)
SELECT BOROUGH, PERP_RACE, race_count
FROM a
WHERE rn BETWEEN 1 AND 7;

--Percentage of crime by age group
SELECT 
   AGE_GROUP
   ,count(*) / (sum(count(*)) OVER()) as pct
FROM  
   `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
GROUP BY 
   AGE_GROUP

--Age ranked by borough. Bronx is the only borough where 18-24 age ranked is ranked second, but onnly by a slight margin.
WITH a AS (
    SELECT BOROUGH,
           AGE_GROUP,
           COUNT(*) AS age_count,
           ROW_NUMBER() OVER (PARTITION BY BOROUGH ORDER BY COUNT(*) DESC) AS rn
    FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
    GROUP BY BOROUGH, AGE_GROUP
)
SELECT BOROUGH, AGE_GROUP, age_count
FROM a
WHERE rn BETWEEN 1 AND 7;

--Percentage of crime by sex
SELECT 
   PERP_SEX
   ,count(*) / (sum(count(*)) OVER()) as pct
FROM  
   `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
GROUP BY 
   PERP_SEX

--Percentage per CRIME_TYPE
SELECT 
   CRIME_TYPE
   ,count(*) / (sum(count(*)) OVER()) as pct
FROM  
   `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
GROUP BY 
   CRIME_TYPE

--Join these two tables and use the population to determine the relative crime rate per borough
SELECT *
FROM `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024`

SELECT SUM(POPULATION_2024)
FROM `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024`

--Just standardized crime and population by borough
Select
  DISTINCT a.BOROUGH,
  ML.STANDARD_SCALER(COUNT(*)) OVER() AS crime_std_scale,
  ML.STANDARD_SCALER(SUM(POPULATION_2024)) OVER() AS POPULATION_2024_std_scale 
from `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final` AS a
JOIN `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024` AS b
ON a.BOROUGH = b.BOROUGH
GROUP BY a.BOROUGH

--Standardized crime rate per borough based on population size per borough
WITH t AS (
  SELECT
    a.BOROUGH,
    b.POPULATION_2024,
    COUNT(*) AS crime,
    (COUNT(*) / b.POPULATION_2024) AS pct_crime_to_pop
  FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final` AS a
  JOIN `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024` AS b
  ON a.BOROUGH = b.BOROUGH
  GROUP BY a.BOROUGH, b.POPULATION_2024
)
SELECT
  t.BOROUGH,
  ML.STANDARD_SCALER(pct_crime_to_pop) OVER() AS crime_std_scale,
from t

--Top 5 crime types per borough
WITH ranked_strings AS (
    SELECT BOROUGH,
           CRIME_TYPE,
           COUNT(*) AS occurrence_count,
           ROW_NUMBER() OVER (PARTITION BY BOROUGH ORDER BY COUNT(*) DESC) AS rn
    FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
    GROUP BY BOROUGH, CRIME_TYPE
)
SELECT BOROUGH, CRIME_TYPE, occurrence_count
FROM ranked_strings
WHERE rn BETWEEN 1 AND 5;

--Top crime type by borough
WITH ranked_strings AS (
    SELECT BOROUGH,
           CRIME_TYPE,
           COUNT(*) AS occurrence_count,
           ROW_NUMBER() OVER (PARTITION BY BOROUGH ORDER BY COUNT(*) DESC) AS rn
    FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
    GROUP BY BOROUGH, CRIME_TYPE
)
SELECT BOROUGH, CRIME_TYPE, occurrence_count
FROM ranked_strings
WHERE rn = 1;

--Top 5 crime types in NYC
SELECT CRIME_TYPE, COUNT(*) AS crime_count
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
GROUP BY CRIME_TYPE
ORDER BY crime_count DESC
LIMIT 5

--Top 5 crime types in Bronx
SELECT CRIME_TYPE, COUNT(*) AS crime_count
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
WHERE BOROUGH = 'Bronx'
GROUP BY CRIME_TYPE
ORDER BY crime_count DESC
LIMIT 5

--Analyze crime per month
SELECT
   CASE WHEN ARREST_DATE BETWEEN '2024-01-01' AND '2024-01-31' THEN 'January'
        WHEN ARREST_DATE BETWEEN '2024-02-01' AND '2024-02-29' THEN 'February'
        WHEN ARREST_DATE BETWEEN '2024-03-01' AND '2024-03-31' THEN 'March'
        END AS Month,
   COUNT(*)
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
GROUP BY Month --Not much change in crime levels per month, so won't do deeper exploration here. Might be beneficial to look at crime levels over a full year of data.



