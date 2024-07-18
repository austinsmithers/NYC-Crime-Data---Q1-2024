--DATA CLEANING:

SELECT *
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`

SELECT *
FROM `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024`
--Populations found here: https://metropolismoving.com/blog/new-york-city-population-in-2022/

--Remove Duplicates
CREATE OR REPLACE TABLE `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
AS
SELECT DISTINCT * FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`

--Checking for Nulls in ARREST_BORO and ARREST_DATE
SELECT *
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
WHERE ARREST_BORO IS NULL
--no nulls

SELECT *
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
WHERE ARREST_DATE IS NULL
--no nulls

--Rename PD_DESC
ALTER TABLE `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`
  RENAME COLUMN PD_DESC TO CRIME_TYPE;

--Rename values in ARREST_BORO
CREATE OR REPLACE TABLE `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final` AS
SELECT *,
   CASE WHEN ARREST_BORO = 'M' THEN 'Manhattan'
        WHEN ARREST_BORO = 'K' THEN 'Brooklyn'
        WHEN ARREST_BORO = 'B' THEN 'Bronx'
        WHEN ARREST_BORO = 'Q' THEN 'Queens'
        WHEN ARREST_BORO = 'S' THEN 'Staten Island'
    ELSE ARREST_BORO  -- Keep unchanged values
  END AS BOROUGH
FROM `polar-ray-420915.Portfolio_Data_Sets.Arrest_Data_Final`

--Rename values in POP table
CREATE OR REPLACE TABLE `polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024` AS
SELECT
   CASE WHEN ARREST_BORO = 'M' THEN 'Manhattan'
        WHEN ARREST_BORO = 'K' THEN 'Brooklyn'
        WHEN ARREST_BORO = 'B' THEN 'Bronx'
        WHEN ARREST_BORO = 'Q' THEN 'Queens'
        WHEN ARREST_BORO = 'S' THEN 'Staten Island'
    ELSE ARREST_BORO  -- Keep unchanged values
  END AS BOROUGH,
  POPULATION_2024
FROM
`polar-ray-420915.Portfolio_Data_Sets.NYC_Pop_2024`
