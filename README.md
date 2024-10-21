# Team_Project_Online_Retail
Repo for team project Online Retail II

## Project Overview

### Objective: Analyzing Revenue and Customer Uniqueness Across Countries

The project aims to gain insights into the factors affecting global retail sales by analyzing two key metrics across countries: total revenue generated and the number of unique customers. The analysis will help identify the highest revenue-generating countries and understand customer diversity across different markets.

![Online-retail-sector-in-Australia-continues-to-mature](https://github.com/user-attachments/assets/aaa419c5-83de-4ea8-a20e-a7d8d95bb93f)
###### Image Source: [Inside Small Business](https://insidesmallbusiness.com.au/marketing/online-retail-sector-in-australia-continues-to-mature)

## Team Members

* Carlos GD
* Liya Paul
* Nicole Yu [nicolexyu](https://github.com/nicolexyu)
* Viktoriia Peleshko 

## Table of Contents

1. xxx
2. What country has highest revenue in the last years? - Carlos & Nicole
3. How many unique customers per country in the last years? - Viktoriia & Liya
4. [Video Links](#video-links)
5. [Reference](#reference)

## What country has highest revenue in the last years? - Carlos & Nicole

### Methodology

#### Data Extraction
We extracted total revenue by country using the following SQL query:

```sql
SELECT 
    Country, 
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM sales_data
WHERE InvoiceDate >= 'YYYY-01-01'
GROUP BY Country
ORDER BY TotalRevenue DESC
LIMIT 1;

#### Data Analysis

import pandas as pd
import matplotlib.pyplot as plt

# Load revenue data into a DataFrame
df_revenue = pd.read_sql(sql_query, engine)

# Plotting total revenue by country
plt.figure(figsize=(10, 6))
plt.bar(df_revenue['Country'], df_revenue['TotalRevenue'], color='blue')
plt.xticks(rotation=45)
plt.xlabel('Country')
plt.ylabel('Total Revenue')
plt.title('Total Revenue by Country')
plt.show()




## How many unique customers per country in the last years? - Viktoriia & Liya

## Video Links

* Carlos GD
* Liya Paul
* Nicole Yu
* Viktoriia Peleshko 

## Reference

[Data Folder](https://github.com/nicolexyu/Team_Project_Online_Retail/tree/main/data)
