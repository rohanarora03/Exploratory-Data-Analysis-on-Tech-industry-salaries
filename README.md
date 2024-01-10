# Tech-industry-salaries

Goal: Perform exploratory data analysis on the prospects of tech jobs using this dataset: https://www.kaggle.com/datasets/thedevastator/know-your-worth-tech-salaries-in-2016

GitHub Repository Description:

**Title: Exploratory Data Analysis on 2016 Hacker News Salary Survey**

**Description:**
This repository contains an exploratory data analysis (EDA) on the 2016 Hacker News Salary Survey dataset, conducted to gain insights into the global salary and experience landscape based on user survey responses.

**Key Highlights:**
- **Dataset Overview:** The dataset comprises approximately 1655 responses across 19 parameters from the 2016 Hacker News Salary Survey, offering insights into pay rates, geographical distribution, job titles, and their categories.

- **Data Cleaning and Preparation:** The dataset was cleaned by addressing issues in the 'location_name' and 'annual_base_pay' columns. Notable steps include splitting the 'location_name' column into 'city' and 'state', removing outliers from 'annual_base_pay' using a QQ-plot, and merging similar city categories.

- **Data Analysis:** The analysis focuses on exploring the variation in average annual base salaries among different cities. The top 15-20 cities were selected for visualization, and the remaining were grouped into the 'Other' category.

- **Statistical Hypothesis Testing:** The analysis includes a statistical hypothesis test comparing the mean annual base salaries of the top three cities - "San Jose," "Mountain View," and "Vancouver." The null hypothesis suggests that the means are equal, while the alternative hypothesis suggests inequality.

- **Conclusion:** The plotted confidence intervals for the top three cities overlap, leading to the conclusion that there is insufficient evidence to reject the null hypothesis. In other words, the sample means are likely drawn from populations with the same mean.

**Dataset Citation:**
- Telle, B. (2018, June 9). 2016 Hacker News Salary Survey Results. [Dataset Link](https://data.world/brandon-telle/2016-hacker-news-salary-survey-results)
