
### Summary 
This analysis was completed using COVID testing data provided by Johns Hopkins University to analyze cumulative COVID testing counts in the state of New York. 

#### Data
The data was sourced from the Johns Hopkins coronavirus API and converted from a json format to a pandas dataframe. 

#### Data Exploration
The data contains 36,628 records and 14 features where 12 variables have a float data type, 1 has an int data type, and 1 contains string values. 3.9 MB are used for memory of this data.

Features:
•	date
•	state
•	people_viral_positive
•	tests_viral_positive
•	tests_viral_negative
•	encounters_viral_total
•	tests_viral_total
•	people_viral_total
•	tests_combined_total
•	cases_conf_probable
•	people_antigen_positive
•	people_antigen_total
•	cases_confirmed
•	cases_probable

The data has several columns that are missing values. The columns people_antigen_positive and people_antigen_total are missing 90%+ of values. The columns encounters_viral_total, tests_viral_negative, cases_probable, cases_confirmed, people_viral_total, and tests_viral_positive are missing between 50% and 75% of values. The remaining columns have less than 25% of values missing. Missing data can be problematic when applying machine learning models. Simpler algorithms cannot handle missing values. It's important to handle missing data effectively.

On average 4,318,515 tests are positive, 3,790,848 people test positive, and 3,823,510 tests are negative. There are strong positive correlations with majority of the individual variables. The correlation plot suggests there is multicollinearity. Multicollinearity among independent variables will result in less reliable statistical inferences. The existence of multicollinearity in a data set can lead to less reliable results due to larger standard errors. The variables tests_viral_total, tests_combined_total, and encounters_viral_total have many outliers and a wider spread of data.

The distribution of the tests_combined_total variable suggests the data is skewed to the right. When data is skewed right, the mean is larger than the median. The histogram and density plot display a pareto distribution and the mean is larger than the median. The average amount of total tests combined for the population equates to 5,424,406 tests. The median amount of total tests combined for the population equates to 1,845,335 tests.

The state of California, New York, Florida, Texas, Illinois, and Massachusetts rank as having on average the most total tests combined. This result is somewhat expected as several of these states have the largest populations in the nation. 

#### Data Preparation and New York Exploration
The data contains 654 records and 14 features. A considerably smaller amount of memory is being used for the New York Data. 76.6 KB are allocated for memory of this data. The variables tests_viral_positive, tests_viral_negative, tests_viral_total, people_viral_total, people_antigen_positive, and people_antigen_total are missing 100% of values. 

On average 2,275,027 cases were confirmed and 1,292,877 were confirmed probable. On average a total of 3,382,254 viral encounters occurred in New York.

#### New York Average tests_combined_total
The average amount of total tests combined for New York equates to 33,822,544 tests. The median amount of total tests combined for New York equates to 30,162,004 tests. Now let’s compare that to the population. The average amount of total tests combined for the population equates to 5,424,406 tests. The median amount of total tests combined for the population equates to 1,845,335 tests. New York well surpasses the population in the amount of testing. 

#### New York tests_combined_total Visualized
Analyzing the distribution of the tests_combined_total variable further for the state of New York shows there are 2 distinct clusters of data. The histogram and density plot displays a bimodal curve. The box plot shows that the majority of the total combined tests variable lies between 1,000,000 and 6,000,000 total combined tests. 
