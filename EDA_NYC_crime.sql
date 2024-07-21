--EXPLORATORY DATA ANALYSIS:

--Crime vs Population by borough
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


--Percentage of crime by borough
SELECT 
   BOROUGH
   ,count(*) / (sum(count(*)) OVER()) as pct
FROM  
   `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
GROUP BY 
   BOROUGH
ORDER BY pct DESC


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


--Check total NYC population
SELECT SUM(POPULATION_2024)
FROM `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024`


--Standardize crime and population by borough
SELECT
    a.BOROUGH,
    COUNT(*) AS crime_count,
    SUM(b.POPULATION_2024) AS total_population,
    -- Standard scaling for crime count
    (COUNT(*) - AVG(COUNT(*)) OVER()) / STDDEV(COUNT(*)) OVER() AS crime_std_scale,
    -- Standard scaling for population
    (SUM(b.POPULATION_2024) - AVG(SUM(b.POPULATION_2024)) OVER()) / STDDEV(SUM(b.POPULATION_2024)) OVER() AS population_2024_std_scale
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final` AS a
JOIN `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024` AS b ON a.BOROUGH = b.BOROUGH
GROUP BY a.BOROUGH;


--Standardized crime rate per borough based on population per borough
WITH t AS (
  SELECT
    a.BOROUGH,
    b.POPULATION_2024,
    COUNT(*) AS crime_count,
    (COUNT(*) / b.POPULATION_2024) AS pct_crime_to_pop
  FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final` AS a
  JOIN `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024` AS b
  ON a.BOROUGH = b.BOROUGH
  GROUP BY a.BOROUGH, b.POPULATION_2024
)
SELECT
  t.BOROUGH,
  (t.pct_crime_to_pop - AVG(t.pct_crime_to_pop) OVER()) / STDDEV(t.pct_crime_to_pop) OVER() AS crime_std_scale
FROM t;


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


--Top 5 crime types in NYC
SELECT CRIME_TYPE, COUNT(*) AS crime_count
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
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
GROUP BY Month --Not much change in crime levels per month. Might be beneficial to look at crime levels over a full year of data.


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


--Perp profiles, ranked by most common
SELECT AGE_GROUP, PERP_RACE, PERP_SEX, CRIME_TYPE, COUNT(*) as count,
ROW_NUMBER() OVER (PARTITION BY BOROUGH, AGE_GROUP, PERP_RACE, PERP_SEX, CRIME_TYPE ORDER BY COUNT(*) DESC) AS rn
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
GROUP BY BOROUGH, AGE_GROUP, PERP_RACE, PERP_SEX, CRIME_TYPE
ORDER BY count DESC

