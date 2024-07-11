# NYC Crime Analysis: Q1 2024

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)

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
5. I decided to keep all columns, even if they were not used in my EDA, in case I decided to re-visit the project.

### Exploratory Data Analysis

EDA involved exploring the crime data to answer key questions:

Add viz's if possible here for EDA

- How many crimes occur in the 5 boroughs? How do these numbers compare to the population of each borough?
- What is the most common criminal description?
- What crimes were most often committed in the 5 boroughs?

### Data Analysis

Include some interesting code/features worked with

Include subquery, CTE, window function, etc.

```sql
SELECT * FROM table1
WHERE cond = 2;
```

### Results/Findings

The analysis results are summarized as follows:
1. The company's sales have been steadily increasing over the past year, with a noticeable peak during the hoy season.
2. Product A cis best performing category in terms of sales and revenue.
3. Customer segments with high lifetime value (LTV) should be targetted for maketing efforts

### Recommendations:

Based on the analysis done, we recommend the following actions:
- Invest
- Focus
- Implement

### Limitations

I had to remove certain records from analysis because they would have affected the accuracy of my conclusions

### References

1. SQL for Businesses by werty
2. [Stack Overflow](https://stack.com)

Thank you for reading!

| Year | Sales |
| ---------- | ---------- |
| 2010 | $1M |
| 2011 | $4M |

<!--
hello
-->
hello
