# Team_Project_Online_Retail
Repo for team project Online Retail II

## Project Overview

### Objective: Analyzing Revenue and Customer Uniqueness Across Countries

The project aims to gain insights into the factors affecting global retail sales by analyzing two key metrics across countries: total revenue generated and the number of unique customers. The analysis will help identify the highest revenue-generating countries and understand customer diversity across different markets.

![Online-retail-sector-in-Australia-continues-to-mature](https://github.com/user-attachments/assets/aaa419c5-83de-4ea8-a20e-a7d8d95bb93f)
###### Image Source: [Inside Small Business](https://insidesmallbusiness.com.au/marketing/online-retail-sector-in-australia-continues-to-mature)

## Team Members

* Carlos GD []()
* Liya Paul [liyapaul24](https://github.com/liyapaul24/Team_Project_Online_Retail)
* Nicole Yu [nicolexyu](https://github.com/nicolexyu/Team_Project_Online_Retail)
* Viktoriia Peleshko []()

## Table of Contents

1. [Introduction](#Introduction)
2. [Data Preparation](#Data-Preparation)
3. [Data Analysis](#Data-Analysis)
4. [Summary of Findings: What country has highest revenue in the last years? - Carlos & Nicole](#Findings-Revenue-Metric)
5. [Summary of Findings: How many unique customers per country in the last years? - Viktoriia & Liya](#Findings-Customer-Metric)
7. [Video Links](#video-links)
8. [Reference](#reference)

## Introduction

The Team Project aims to enhance your ability to deliver business value in a practical setting. This project should be included in your portfolio, and you should feel confident presenting it to prospective employers as a showcase of your skills.

The Team Project is divided into two modules, each requiring participants to utilize the skills you've acquired thus far. The first module focuses on analyzing a dataset and developing a basic program for this purpose. In the second module, teams will reconvene to implement the skills gained from the data science or machine learning foundations certificate streams. Teams will either produce a data visualization or develop a machine learning model.

## Data Preparation

The team is working with a substantial dataset that required splitting into two separate files due to its size, covering data from two consecutive years. This dataset includes key variables such as Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer ID, and Country. By leveraging this comprehensive information, the team aims to conduct an in-depth analysis to uncover valuable insights and trends over the specified time period.

We used SQL to combine data: Two CSV files (online_retail_2009_2010 and online_retail_2010_2011) are imported into the database and combined using a UNION ALL query.

### Revenue Metric

We used SQL to clean the data:
1. Identify Duplicates: This is done by grouping all columns and counting occurrences, returning rows where the count is greater than 1 (duplicates).
2. Create a Table with Unique Records: This step removes duplicates while retaining only unique records.
3. Identify Missing Values: The query counts how many missing values exist in each column.  
4. Handle Missing Values for Description: The Description and the Customer ID columns' NULL values are replaced with the string 'unknown'.

The results indicate that the dataset is mostly complete, with no missing values for key columns like Invoice, StockCode, Quantity, InvoiceDate, Price, and Country. However, there are a significant number of missing values in the Description (4,275 missing) and Customer ID (235,151 missing) columns. 

Since the Customer ID and Description columns are not involved in the revenue calculation, the missing data in those columns won't impact the results of the revenue analysis. However, this could be an area of focus for further data cleaning or investigation, especially for the large number of missing customer IDs.

[Link to the folder for SQL code](https://github.com/nicolexyu/Team_Project_Online_Retail/tree/main/src/Revenue%20Metric)

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

### Findings Revenue Metric
### What country has highest revenue in the last years? - Carlos & Nicole

We generated the results for the top 10 countries by total revenue for all three years, and for each individual year based on the raw data.

#### Top 10 Countries by Total Revenue for All Years:

![all years](https://github.com/user-attachments/assets/52b90699-9c20-4612-a554-fe362b09136a)

• United Kingdom leads by a significant margin with almost 16 million in total revenue. This could indicate that the UK is the most important market for the business during this period.

• EIRE (Ireland) and Netherlands are second and third, but their revenue is much lower, indicating a different market structure where the UK is dominant.

• Countries like Germany, France, and Australia show lower revenues, but still contribute significantly to the overall dataset.

#### Top 10 Countries by Revenue for Each Year:

![each year](https://github.com/user-attachments/assets/ab5accd9-26d1-489d-81d6-9d7cdd9e6f07)

For 2009:
• The United Kingdom remains the leader in 2009 with a significant share of revenue.
• The revenue for other countries like Germany, France, and Spain is notably lower in 2009 compared to later years, which could indicate growth in these markets in the subsequent years.

For 2010:
• The United Kingdom continues to dominate in 2010 with a massive revenue spike compared to 2009.
• EIRE, Netherlands, and Germany show noticeable increases in revenue in 2010.
• Countries like France and Sweden also show growth, albeit not as high as the UK.

For 2011:
• The United Kingdom remains the top revenue-generating country in 2011, but its revenue decreased slightly compared to 2010.
• EIRE and Netherlands remain strong, though slightly lower than in 2010.
• Germany and France maintain consistent contributions, while countries like Belgium and Sweden show improvement.

Summary: 
The United Kingdom shows strong dominance in all three years, suggesting it is a stable market. However, the decline from 2010 to 2011 could indicate market saturation or other external factors. Observing this trend helps us understand how the performance of different countries changes over time. 

This analysis helps in segmenting the data. We can consider focusing on countries with significant revenue growth (e.g., Netherlands and Germany) to identify key features that drive market expansion.
Countries that consistently perform poorly (e.g., Cyprus or Portugal) might not be as relevant for predicting future revenue and could be excluded from your regression model.

By analyzing the top 10 countries by revenue both across all years and for each year, we're gaining valuable insights into the data before we proceed with building the regression model. 

#### Top 10 Countries with the Highest Revenue Trend (regression model):

![Screenshot 2024-11-10 151921](https://github.com/user-attachments/assets/ef385fa9-d8c4-48ce-a318-2fbfc12affdd)

Countries with a higher coefficient (like Nigeria and Australia) are seeing a more significant increase in their revenue trend. This suggests that these countries are experiencing rapid growth in revenue, and any further investment or strategy in these regions may yield higher returns.

Nigeria has the highest coefficient (78.34), meaning that for every unit increase in the predictor, the revenue trend increases significantly. 

Australia follows closely with a coefficient of 62.95, suggesting that Australia's revenue trend is also growing at a strong rate, though not as quickly as Nigeria's.

Based on the results, businesses or analysts might prioritize countries with higher coefficients for expansion, marketing, or resource allocation, as they are seeing a stronger revenue trend.

#### Raw Data vs Regression Model

Raw Data (Top Country for All Years and Each Year):
United Kingdom (UK) is the top country in terms of total revenue for all years, as well as for each individual year, based on the raw data. This suggests that, historically, the UK has consistently generated the highest revenue across all years.

Regression Model (Top Country for Revenues):
Nigeria is identified as the top country in terms of revenue trend based on the regression model. This means that, according to the model, Nigeria exhibits the highest growth or upward revenue trend among all countries.

Why the Discrepancy?

Total Revenue vs. Growth: The raw data highlights total revenue over all years, which can be influenced by long-standing, well-established markets like the UK, where the base revenue may already be large. On the other hand, the regression model evaluates growth over time, giving more weight to countries like Nigeria that may have smaller total revenues but are experiencing significant growth in recent years.

Emerging Markets: Countries like Nigeria may be in a period of rapid economic or business growth, causing their revenue trend to spike even though their total revenue is not the highest. In contrast, countries like the UK may have reached a plateau or slower growth, thus not appearing as high in the regression results even though they have historically had large revenue totals.

Implications for Business Strategy:

For the Raw Data (UK): The UK remains a key market with the highest total revenue, so continuing business in this region is likely crucial for sustaining overall sales performance.

For the Regression Model (Nigeria): The strong growth trend in Nigeria indicates potential for future expansion or investment. If your goal is to target countries with the highest growth potential, Nigeria would be a key area for strategic focus, as it is showing the highest increase in revenue, which could lead to larger market share over time.

#### Intersection of the United Kingdom (UK) and Nigeria in the regression model

![intersection](https://github.com/user-attachments/assets/f0a768fc-cad5-466d-955f-20c0d398970f)

The intersection point, with x = 2010.16, represents the year where the revenue trends for Nigeria and the United Kingdom would theoretically be equal based on the regression model's projection.

This intersection indicates that, by around 2010, Nigeria was on a high growth path that might make it an important market to watch or invest in. The UK’s steady revenue growth suggests stability, but Nigeria’s high coefficient means its revenue could potentially increase much faster, making it a potential priority for future investments.

While the UK may still have a larger total revenue, this projection shows that Nigeria could reach comparable growth rates sooner than expected, depending on sustained factors such as market demand and economic conditions.

With Nigeria’s strong coefficient, future periods post-2010 could show Nigeria surpassing the UK in revenue growth rate if trends continue. For business strategy, this could highlight the importance of supporting or expanding operations in Nigeria to capture this growth, while the UK may offer more predictable returns due to its stability.

This gives us a clearer picture of the data's structure and prepares us for better feature selection, handling of outliers, and addressing any trends or patterns that could inform the model.

This intersection point illustrates the divergence in growth dynamics between a mature market (UK) and an emerging, high-growth market (Nigeria), guiding strategic decisions based on these contrasting trends.

### Findings Customer Metric
### How many unique customers per country in the last years? - Viktoriia & Liya

## Video Links

* Carlos GD
* Liya Paul
* Nicole Yu
* Viktoriia Peleshko 

## Reference

[Data Folder](https://github.com/nicolexyu/Team_Project_Online_Retail/tree/main/data)
