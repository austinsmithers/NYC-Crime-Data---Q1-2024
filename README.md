# NYC Crime Analysis: Q1 2024

---

### Project Overview

The goal of this project was to practice my data cleaning and EDA skills by exploring criminal behavior throughout all 5 boroughs in New York City. The data set consists of reported crimes from the NYPD spanning January - March of 2024 and includes the type of crime, location, date, and characteristics about the perpetrator (gender, age, race). I was interested in learning about how crimes and criminals differ across the boroughs.

<img width="253" alt="Screen Shot 2024-06-11 at 10 41 54 PM" src="https://github.com/austinsmithers/Project-1/assets/172429232/7fda4439-bd27-4491-86aa-dae2469ac58e">


### Data Sources

The primary dataset used for this analysis is "NYPD_Arrest_Data__Year_to_Date_.csv" containing detailed information from data.gov on crimes that occurred in New York City between January - March of 2024.

### Tools

- SQL Server - Data Analysis
- Tableau - Creating Report

### Data Cleaning/Preparation
In the initial data preparation phase, I performed the following:
1. Loaded the data and inspected it.
2. Removed duplicate rows and then checked for Null values in the borough and date columns, as I intended to use these columns in my analysis. There were no Null values.
3. Renamed the column PD_DESC to an easily identifiable name (CRIME_TYPE).
4. Replaced the values in ARREST_BORO to reflect the full names of each Borough
5. I decided to keep all columns, even if they were not used in my EDA, in case I decided to re-visit the project later.

### Exploratory Data Analysis

My EDA involved exploring the data to answer key questions:

Add viz's if possible here for EDA

- How many crimes occurred in each borough? How do these numbers compare to the population of each borough?
- Who committed the most crimes?
- What crimes were most often committed?

### Data Analysis

Through my analaysis, I employed different techniques, including aggregations, CTE's, joins, window functions, case statements, etc. to answer the above questions. The following code used a CTE and a window function to find the 5 most prevalent types of crime in each borough:

```sql
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
```

The following code used a CTE, window function, join, and standardized the percentage of crime to the population, in order to better compare the rate of crime across boroughs:

```sql
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
```

### Results/Findings

The analysis results are summarized as follows:
1. Although Manhattan and Brooklyn led with the highest crime counts between 1/1/2024-3/31/2024, the Bronx experienced the highest rate of crime when you factor in the population per borough. Additionally, although Staten Island's crime count was an outlier in that it was significantly lower than the others, it's rate of crime was still relatively comparable to the other boroughs. See below for a table that includes the population, crime count, crime count / population, and the standardization score to compare the crime rates:
2. The most likely perpetrator between 1/1/2024-3/31/2024 was a black male between the ages of 25-44.
3. The most common charge overall was "Assault 3". However, In Manhattan and Queens, Assault 3 fell slightly behind the "LARCENY,PETIT FROM OPEN AREAS" charge.

### Implications/Recommendations:

If this project were for the purpose of reducing crime in NYC, based off of the EDA, I would narrow in on the specific locations within each borough with high concentrations of crime. This would require me to pinpoint the specific areas of each borough where crime is the most prevalent. I would also want to evaluate the different "perp characteristics" (age, race, gender) across crime types. By predicting who is most likely to commit certain crimes, we could then conduct further research to determine why some crimes are committed in certain communities vs. others. Ultimately, the goal would be to provide the correct funding or support for programs, education, housing, etc. in order to reduce this crime.

### Limitations

There were a few limitations within this data set. One limitation was that it only spanned a 3 month duration. It would be beneficial to see trends over the years to get an accurate depiction of the crime rate over time. Additionally, the crime descriptions were a little vague. It's possible to look up the meaning of all of them and then add in a new column in the data set, but it would take time. Lastly, it's important to note that this data does not provide much context. It is important not to draw conclusions or form prejudices based on the common "perp profile" that was illustrated. Rather, this EDA should inspire you to learn more about why certain types of people are arrested, predisposed to criminality, and, most importantly, what can be done to help them.

### References

1. SQL for Businesses by werty
2. [Data.gov](https://data.gov/)

Thank you for reading!

| Year | Sales |
| ---------- | ---------- |
| 2010 | $1M |
| 2011 | $4M |

<!--
hello
-->
hello
