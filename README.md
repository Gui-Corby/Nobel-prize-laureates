
# Nobel Prize laureates

## Overview
Personal project to analyse the winners of the Nobel prize untill 2024, running queries to identify interesing insights, such as:

## In this project, I run some queries to identify interesting insights, such as:
- What nations provided most laureates?
- What are the top winning universities?
- How is the gender distribution across winners?
- Who was the youngest and oldest laureates?
- And more!

## Dataset
Data source: [Nobel Prize Dataset](https://www.kaggle.com/datasets/joebeachcapital/nobel-prize)

## Notes on Data Cleaning
- I created a new column `organization_name_standard` to merge different schools/campuses under a single institution name for clarity.
- In the `born_country` column, some countries no longer exist, such as Prussia and the Soviet Union. The source made the `born_country_code` reflect which these countries are today, and that was my criteria for analysing the nations with more winners.
- The dataset ranges from 1901-2022. I manually added the 2023 and 2024 winners, following the informations at the Nobel Prize official website.# Nobel-prize-laureates
