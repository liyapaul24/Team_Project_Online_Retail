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
* Nicole Yu [nicolexyu](x)
* Viktoriia Peleshko 

## Table of Contents

1. Introduction
2. Data Collection
3. Data Preparation
4. Data Analysis
5. Summary of Findings - What country has highest revenue in the last years? - Carlos & Nicole
7. Summary of Findings - How many unique customers per country in the last years? - Viktoriia & Liya
8. [Video Links](#video-links)
9. [Reference](#reference)

## Introduction

The Team Project aims to enhance your ability to deliver business value in a practical setting. This project should be included in your portfolio, and you should feel confident presenting it to prospective employers as a showcase of your skills.

The Team Project is divided into two modules, each requiring participants to utilize the skills you've acquired thus far. The first module focuses on analyzing a dataset and developing a basic program for this purpose. In the second module, teams will reconvene to implement the skills gained from the data science or machine learning foundations certificate streams. Teams will either produce a data visualization or develop a machine learning model.

## Data Collection

The team is working with a substantial dataset that required splitting into two separate files due to its size, covering data from two consecutive years. This dataset includes key variables such as Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer ID, and Country. By leveraging this comprehensive information, the team aims to conduct an in-depth analysis to uncover valuable insights and trends over the specified time period.

## Data Preparation

### Revenue Metric

1. We extracted total revenue by country using the following SQL query

```sql
SELECT 
    Country, 
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM sales_data
WHERE InvoiceDate >= 'YYYY-01-01'
GROUP BY Country
ORDER BY TotalRevenue DESC
LIMIT 1;
```

### Customer Metric

1. We extracted ...

## Data Analysis

### Revenue Metric

1. We analyzed the data using Python and visualized the results

```python
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
```

### Customer Metric

1. We analyzed ...

## Summary of Findings

### What country has highest revenue in the last years? - Carlos & Nicole

### How many unique customers per country in the last years? - Viktoriia & Liya

## Video Links

* Carlos GD
* Liya Paul
* Nicole Yu
* Viktoriia Peleshko 

## Reference

[Data Folder](https://github.com/nicolexyu/Team_Project_Online_Retail/tree/main/data)
