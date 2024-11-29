# Team_Project_Online_Retail
Repo for team project Online Retail II

## Project Overview

### Objective: Analyzing Revenue and Customer Uniqueness Across Countries

The project aims to gain insights into the factors affecting global retail sales by analyzing two key metrics across countries: total revenue generated and the number of unique customers. The analysis will help identify the highest revenue-generating countries and understand customer diversity across different markets.

![Online-retail-sector-in-Australia-continues-to-mature](https://github.com/user-attachments/assets/aaa419c5-83de-4ea8-a20e-a7d8d95bb93f)
###### Image Source: [Inside Small Business](https://insidesmallbusiness.com.au/marketing/online-retail-sector-in-australia-continues-to-mature)

## Team Members

* Carlos Gonzalez-Dao []()
* Liya Paul [liyapaul24](https://github.com/liyapaul24/Team_Project_Online_Retail)
* Nicole Yu [nicolexyu](https://github.com/nicolexyu/Team_Project_Online_Retail)
* Viktoriia Peleshko [PeleshkoV](https://github.com/PeleshkoV/Team_Project_Online_Retail)

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

[File for SQL code](https://github.com/nicolexyu/Team_Project_Online_Retail/blob/main/src/Revenue%20Metric/revenue_sql_code.sql)

### Customer Metric

For analysis, we used a combined CSV file with information about online retail in 2009-2011.  

All manipulation with data we have done in a Python environment.

Overview:   The original dataset contains 1067371 rows without null values.   
We have identified the following problems:  
- 243007 rows (22,8%) with missing Customer ID data - significant number!  
Customer ID is the critical field of our second research but rows with such missing data will not be useful for analysis.   
- 4382 rows (0,41%) do not have Descriptions (these are the same rows without Customer IDs).   
- 26479 duplicated rows;  
- irrelevant names of Countries: 'Unspecified‘ – 521 rows, "European Community“ – 61 rows.   

For accurate analysis, we have deleted the missing values and duplicates using 'dropna' function. Also, we removed rows with irrelevant data using loc- function.  
Cleaning these rows avoids potential misinterpretations or mislinking of data.   
The final Dataset contains 797303 rows.

## Data Analysis

### Revenue Metric

We analyzed the data using Python and visualized the results.

Top 10 Countries by Total Revenue for All Years:

```python
# Calculate total revenue per country for all years
data['TotalRevenue'] = data['Quantity'] * data['Price']
country_revenue = data.groupby('Country')['TotalRevenue'].sum().reset_index()

# Sort the countries by revenue in descending order
country_revenue = country_revenue.sort_values(by='TotalRevenue', ascending=False)
```

Top 10 Countries by Revenue for Each Year:

```python
# Extract the year from InvoiceDate: extracts the year from the InvoiceDate and creates a new column for it.
data['Year'] = data['InvoiceDate'].dt.year

# Group by 'Year' and 'Country' to calculate total revenue per country per year
yearly_revenue = data.groupby(['Year', 'Country'])['TotalRevenue'].sum().reset_index()

# Sort the results by year and then by total revenue: The results are sorted first by Year and then by TotalRevenue within each year in descending order.
yearly_revenue = yearly_revenue.sort_values(by=['Year', 'TotalRevenue'], ascending=[True, False])

# Function to get top 10 countries per year
def get_top_countries_per_year(df, top_n=10):
    top_countries_per_year = df.groupby('Year').head(top_n)
    return top_countries_per_year

# Get the top 10 countries for each year
top_10_countries_per_year = get_top_countries_per_year(yearly_revenue, top_n=10)
```

Top 10 Countries with the Highest Revenue Trend (regression model):

```python
# Initialize dictionary to store the results
country_trends = {}

# Group by country and fit a linear regression model for each
for country, group in data.groupby('Country'):
    # Prepare the features and target variable
    X = group['Year'].values.reshape(-1, 1)  # Year as feature
    y = group['TotalRevenue'].values  # Total revenue as target

    # Split the data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Initialize and fit the linear regression model on the training data
    model = LinearRegression()
    model.fit(X_train, y_train)
    
    # Predict the revenue trend on both training and test data
    y_train_pred = model.predict(X_train)
    y_test_pred = model.predict(X_test)
    
    # Store the model parameters and prediction results
    country_trends[country] = {
        'intercept': model.intercept_,
        'coefficient': model.coef_[0],
        'years': group['Year'],
        'total_revenue': group['TotalRevenue'],
        'trend_line': model.predict(X.reshape(-1, 1)),  # Full trend line
        'train_pred': y_train_pred,
        'test_pred': y_test_pred,
        'train_true': y_train,
        'test_true': y_test
    }

# Convert the results to a DataFrame for easier analysis
trends_df = pd.DataFrame.from_dict(country_trends, orient='index')

# Sort the DataFrame by 'Coefficient' in descending order to find the top 10 countries
top_countries = trends_df.sort_values(by='coefficient', ascending=False).head(10)
```

Intersection of the United Kingdom (UK) and Nigeria in the regression model

```python
# Find the intersection of the two regression lines

# The equation of the regression lines is:
# y_uk = intercept_uk + coefficient_uk * x
# y_nigeria = intercept_nigeria + coefficient_nigeria * x

# Extract the coefficients and intercepts
intercept_uk, coef_uk = country_trends['United Kingdom']['intercept'], country_trends['United Kingdom']['coefficient']
intercept_nigeria, coef_nigeria = country_trends['Nigeria']['intercept'], country_trends['Nigeria']['coefficient']

# Solve for the intersection point (x)
# intercept_uk + coef_uk * x = intercept_nigeria + coef_nigeria * x
# x = (intercept_nigeria - intercept_uk) / (coef_uk - coef_nigeria)

# Ensure the lines are not parallel (i.e., coefficients are different)
if coef_uk != coef_nigeria:
    # Calculate the x-coordinate of the intersection point
    intersection_x = (intercept_nigeria - intercept_uk) / (coef_uk - coef_nigeria)
    
    # Calculate the y-coordinate by substituting the x value into one of the linear equations (use the UK model)
    intersection_y = intercept_uk + coef_uk * intersection_x
    
    print(f"The intersection point of the UK and Nigeria trend lines is at: x = {intersection_x:.2f}, y = {intersection_y:.2f}")
```

[File for Python code](https://github.com/nicolexyu/Team_Project_Online_Retail/blob/main/src/Revenue%20Metric/revenue_python_code.ipynb)

### Customer Metric

We divided our research into two parts.   
Part 1 - Determined Customer Uniqueness Across Countries.  
Part 2 - Predict the most valuable customers in upcoming years to increase efficiency.

#### Part 1
1. Define the unique Customers in each country's market.

```python
# Group the unique Customers by Country per year:
group_df = (df.groupby(["Country", "Year"])["Customer ID"]
        .nunique()  
        .reset_index(name="Total_Customers"))  

# Structurize the data frame by creating the pivot table 
group_pivot = group_df.pivot(index="Country", columns="Year", values="Total_Customers")

# Calculate the Total amount of the unique company's Customers each year and add values to the pivot table.
    total_customers = group_pivot.sum()
    group_pivot.loc['Total'] = total_customers
```

2. Find Top 10 Countries by the number of unique Customers each year.

```python 
# Visualize the Top 10 based on the pivot table through the subplot function.
def plot_top_10(group_pivot, year, ax):
    year_data = group_pivot[year] 
    top_10 = year_data.nlargest(10)

    bars = ax.bar(top_10.index, top_10.values, color='blue') 
    ax.bar_label(bars, fontsize=10, padding=0, color='red') 
    ax.set_title(f'Top 10 Countries in {year}', fontsize=16, loc='right', y=0.8, x=0.9) 
    ax.set_ylabel('Number of Customers')  
    ax.set_xlabel('Country', fontsize=9) 
    ax.set_xticks(top_10.index) 
    ax.set_xticklabels(top_10.index, rotation=80) 

fig, axes = plt.subplots(1, 3, figsize=(15, 5), sharey=True)

for i, year in enumerate([2009, 2010, 2011]):
        plot_top_10(group_pivot, year, axes[i])
```

3. Define how the number of clients has changed over the 2009 - 2011. Add the values of Absolute Growth to the pivot table. 
We do not use the Normalized Absolute Growth or % -comparing because there are big differences in numbers which give us not relevant results

```python
# Calculate the Absolute Growth of unique Customers between 2011 and 2009.
group_pivot['Absolute_Growth'] = group_pivot[2011] - group_pivot[2009]

# Extract data frame with the Top 10 countries by the absolute growth of customers
growth_top10 = growth.sort_values(by='Absolute_Growth', ascending=False).head(10)
```

[File for Python code](https://github.com/PeleshkoV/Team_Project_Online_Retail/blob/main/src/Customer%20Metric/Part%201_BS2_Valuable_Customer.ipynb)

#### Part 2
Predicting the most valuable customers in upcoming years to increase efficiency. 

For the exploration of customer behavior, we use RFM analysis.

1. Create the new features for our data frame: Total Spend, Recency, Frequency.

```python
#Calculate the total amount of money that the customers spent during each interaction.
#Created a new feature in the column 'TotalSpend'. 
    df['TotalSpend'] = df['Quantity'] * df['Price']

#Group by both 'Customer ID' and 'Country'. Use an RFM analysis to calculate Recency, Frequency and Monetary for each client.
rfm_df = df.groupby(['Customer ID','Country']).agg({
    'InvoiceDate': lambda x: (df['InvoiceDate'].max() - x.max()).days,  
    'Invoice': 'nunique',  
    'TotalSpend': 'sum' 
    }).reset_index()    
```

2. Visualize the distribution of numerical data from the rfm_df using the boxplots function and interquartile range (IQR) method. Find and remove outliers.

```python
# Boxplot to identify outliers
for i in rfm_df.select_dtypes(include="number").columns:
        sns.boxplot(data=rfm_df, x=i)
        plt.show()

# Calculate the Interquartile Range and identify the values that fall below the boundaries
Q1 = rfm_df['Quantity'].quantile(0.25)
Q3 = rfm_df['Quantity'].quantile(0.75)
IQR = Q3 - Q1

lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR

outliers_iqr = df[(df['Quantity'] < lower_bound) | (df['Quantity'] > upper_bound)]
```

3. Choose a Machine Learning Model for prediction.   
Proceed with a Linear Regression with a Standard Scaler.  
Features for the model: Recency and Frequency. Target variable: Monetary value 

```python
# Initialize the StandardScaler
scaler = StandardScaler()

# Select the features that need to be scaled
features_to_scale = ['Recency', 'Frequency', 'Monetary']

# Fit and transform the selected features
rfm_df_scaled = rfm_df.copy()  
rfm_df_scaled[features_to_scale] = scaler.fit_transform(rfm_df[features_to_scale])
```

4. Fit, train and test LinearRegression model. Make predictions.

```python
# Sort by predicted monetary value to identify the most valuable customers
most_valuable_customers = rfm_df_scaled.sort_values(by='Predicted_Monetary', ascending=False)
```

[File for Python code](https://github.com/PeleshkoV/Team_Project_Online_Retail/blob/main/src/Customer%20Metric/BS2_Valuable_Customer.ipynb)

## Summary of Findings

### Findings Revenue Metric
### What country has highest revenue in the last years? - Carlos & Nicole

We generated the results for the top 10 countries by total revenue for all three years, and for each individual year based on the raw data.

#### Top 10 Countries by Total Revenue for All Years:

![all years](https://github.com/user-attachments/assets/52b90699-9c20-4612-a554-fe362b09136a)

- United Kingdom leads by a significant margin with almost 16 million in total revenue. This could indicate that the UK is the most important market for the business during this period.
- EIRE (Ireland) and Netherlands are second and third, but their revenue is much lower, indicating a different market structure where the UK is dominant.
- Countries like Germany, France, and Australia show lower revenues, but still contribute significantly to the overall dataset.

#### Top 10 Countries by Revenue for Each Year:

![each year](https://github.com/user-attachments/assets/ab5accd9-26d1-489d-81d6-9d7cdd9e6f07)

For 2009:
- The United Kingdom remains the leader in 2009 with a significant share of revenue.
- The revenue for other countries like Germany, France, and Spain is notably lower in 2009 compared to later years, which could indicate growth in these markets in the subsequent years.

For 2010:
- The United Kingdom continues to dominate in 2010 with a massive revenue spike compared to 2009.
- EIRE, Netherlands, and Germany show noticeable increases in revenue in 2010.
- Countries like France and Sweden also show growth, albeit not as high as the UK.

For 2011:
- The United Kingdom remains the top revenue-generating country in 2011, but its revenue decreased slightly compared to 2010.
- EIRE and Netherlands remain strong, though slightly lower than in 2010.
- Germany and France maintain consistent contributions, while countries like Belgium and Sweden show improvement.

Summary: 
The United Kingdom shows strong dominance in all three years, suggesting it is a stable market. However, the decline from 2010 to 2011 could indicate market saturation or other external factors. Observing this trend helps us understand how the performance of different countries changes over time. 

This analysis helps in segmenting the data. We can consider focusing on countries with significant revenue growth (e.g., Netherlands and Germany) to identify key features that drive market expansion.
Countries that consistently perform poorly (e.g., Cyprus or Portugal) might not be as relevant for predicting future revenue and could be excluded from your regression model.

By analyzing the top 10 countries by revenue both across all years and for each year, we're gaining valuable insights into the data before we proceed with building the regression model. 

#### Top 10 Countries with the Highest Revenue Trend (regression model):

![Screenshot 2024-11-10 151921](https://github.com/user-attachments/assets/fba90e6a-5c65-4f57-b310-75b079ecd3ca)

Countries with a higher coefficient (like Nigeria and Australia) are seeing a more significant increase in their revenue trend. This suggests that these countries are experiencing rapid growth in revenue, and any further investment or strategy in these regions may yield higher returns.

- Nigeria has the highest coefficient (78.34), meaning that for every unit increase in the predictor, the revenue trend increases significantly. 
- Australia follows closely with a coefficient of 62.95, suggesting that Australia's revenue trend is also growing at a strong rate, though not as quickly as Nigeria's.

Based on the results, businesses or analysts might prioritize countries with higher coefficients for expansion, marketing, or resource allocation, as they are seeing a stronger revenue trend.

#### Raw Data vs Regression Model

Raw Data (Top Country for All Years and Each Year):
- United Kingdom (UK) is the top country in terms of total revenue for all years, as well as for each individual year, based on the raw data. This suggests that, historically, the UK has consistently generated the highest revenue across all years.

Regression Model (Top Country for Revenues):
- Nigeria is identified as the top country in terms of revenue trend based on the regression model. This means that, according to the model, Nigeria exhibits the highest growth or upward revenue trend among all countries.

Why the Discrepancy?

- Total Revenue vs. Growth: The raw data highlights total revenue over all years, which can be influenced by long-standing, well-established markets like the UK, where the base revenue may already be large. On the other hand, the regression model evaluates growth over time, giving more weight to countries like Nigeria that may have smaller total revenues but are experiencing significant growth in recent years.
- Emerging Markets: Countries like Nigeria may be in a period of rapid economic or business growth, causing their revenue trend to spike even though their total revenue is not the highest. In contrast, countries like the UK may have reached a plateau or slower growth, thus not appearing as high in the regression results even though they have historically had large revenue totals.

Implications for Business Strategy:

- For the Raw Data (UK): The UK remains a key market with the highest total revenue, so continuing business in this region is likely crucial for sustaining overall sales performance.
- For the Regression Model (Nigeria): The strong growth trend in Nigeria indicates potential for future expansion or investment. If your goal is to target countries with the highest growth potential, Nigeria would be a key area for strategic focus, as it is showing the highest increase in revenue, which could lead to larger market share over time.

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

During 2009 - 2011 the Company significantly developed the business. The total number of Customers increased by 4 times.

![All_Customers](https://github.com/PeleshkoV/Team_Project_Online_Retail/blob/ab35a2b07a426fdbda9172791d760dba661746a5/src/Customer%20Metric/Total_output.png)

2009: The base for growth  
The number of customers was at its lowest level during the analyzed period, reaching only 1045 clients. This may indicate the initial stage of business development or other factors that affected the low customer base in that year.

2010: Business Expansion  
There was a significant growth by 4 times in the number of customers to 4290 clients. This indicates successful marketing campaigns, improved service quality, or other positive changes in the company's operations.

2011: Stability  
The number of customers remained at a high level and reached 4246 clients. A slight decline compared to 2010 may be due to seasonal fluctuations, market changes, or other external factors.

Next, explore what Countries had the largest Customer base and made the biggest impact on the business. 

#### Top 10 markets: domestic customers are a priority

The Company is present in 39 countries worldwide.
The analysis shows the widest markets for all 3 years were the UK, Germany, France, and Spain. 

![Top_Customers](https://github.com/PeleshkoV/Team_Project_Online_Retail/blob/ab35a2b07a426fdbda9172791d760dba661746a5/src/Customer%20Metric/Top_10_years.png)

In 2009-2011, the United Kingdom had an overwhelmingly larger number of customers compared to other countries. This is a native, well-known market for the Company.   
Germany, France, and Spain appear in the Top 10 across all years but with much lower customer counts compared to the UK. The number of clients for these countries remains under 100 each year.  
Countries like Belgium, Australia, and Austria have minimal representation, typically fewer than 30 customers annually.

Outside of the Top 10, there are some non-European countries with a small number of customers. Examples: Bahrain (2), Brazil (1), Canada (4), RSA (1), Singapore (1), United Arab Emirates (2) etc. It seems that the company's strategy doesn't include expansion into American, Asian or African markets in the near future. The appearance of several clients there is more likely an accident or a trial.

#### Growing European markets 

The analysis of Absolute Growth confirms the trend: the strategy of the Company in 2009-2011 was rapid expansion in the UK market and slight development in some other European countries. 

![Dominant UK](https://github.com/PeleshkoV/Team_Project_Online_Retail/blob/ab35a2b07a426fdbda9172791d760dba661746a5/src/Customer%20Metric/UK_Total.png)

Absolute Growth leader - United Kingdom. The number of UK clients increased by 2849 names in 2011 compared with 2009 – 4 times! In 2009, UK clients accounted for 94.4% of the whole company's customer base. It declined to 92% in 2010 and 90.3% in 2011. The main reason for this slight decrease is the expansion into other European countries.

![Absolure Growth](https://github.com/PeleshkoV/Team_Project_Online_Retail/blob/ab35a2b07a426fdbda9172791d760dba661746a5/src/Customer%20Metric/Growth_rate.png)

The client’s bases significantly increased in Germany (+82 customers) and in France (+71) but their sizes remain small. 
3 more countries added 20+ customers for the observation period: Spain, Belgium, and  Switzerland.

Opportunities for Growth  
The Company is not making enough efforts to develop new markets, although it already has a global market structure.  
The Company may increase its expansion into European markets while continuing to develop new products and offerings for the local UK market. For this goal, the Company should focus on deeper market analysis to understand regional customer preferences and identify high-potential segments in Europe.

#### Insights about Customers 

In the next part of the exploration, we try to understand customer behavior.  
For the analysis, used the RFM method that is common in marketing. It helps businesses categorize customers into segments, enabling targeted and personalized marketing strategies (Learn more https://www.optimove.com/resources/learning-center/rfm-segmentation)   
This analysis is based on three key factors:  
- Recency is the amount of days since the customer's last purchase.
- Frequency is the total number of purchases made by the customer.
- Monetary is the Sum of the customer's total spend (during a defined period). 

These new features were calculated and distributed. We received detailed information with useful insights about each of Customers. 

![Customer_range](https://github.com/PeleshkoV/Team_Project_Online_Retail/blob/ab35a2b07a426fdbda9172791d760dba661746a5/src/Customer%20Metric/RFM_Customers.png)

Why is it important? 
RFM analysis can help businesses focus on retaining and growing relationships with customers who contribute the most to their profitability.

Based on the data we received, were created Linear Regression for the prediction of the most valuable customers in upcoming years to increase efficiency.

![Valuable_Customers](https://github.com/PeleshkoV/Team_Project_Online_Retail/blob/ab35a2b07a426fdbda9172791d760dba661746a5/src/Customer%20Metric/Valuable%20Customers.png)

These customers may spend more amount in the future, hence considering them as the most valuable clients. All of them are located in the UK which underlines the importance of this market for the Сompany. 

Take care of valuable Customers  
Focus on retaining and nurturing the most valuable Customers by offering personalized rewards / promotions and exclusive deals to maximize their lifetime value and re-engage inactive customers with special offers to increase their spending.

## Video Links

* Carlos Gonzalez-Dao
* Liya Paul
* Nicole Yu
* Viktoriia Peleshko 

## Reference

[Data Folder](https://github.com/nicolexyu/Team_Project_Online_Retail/tree/main/data)
