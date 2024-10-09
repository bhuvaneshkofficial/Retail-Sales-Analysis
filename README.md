# Retail Sales Analysis SQL Project 2 - Beginner Level

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `Retail_Sales_Analysis`
**Project**: P2

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_Sales_Analysis`.
- **Table Creation**: A table named `SALESDATA` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Retail_Sales_Analysis;

CREATE TABLE SALESDATA (
	transactions_id INT,
	sale_date DATE,
	sale_time TIME,	
	customer_id INT,	
	gender VARCHAR(15),	
	age	INT,
	category VARCHAR(30),	
	quantity INT,	
	price_per_unit INT,	
	cogs FLOAT,
	total_sale INT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
Select * from Salesdata;

Select Count(*) from salesdata;

Select Distinct Category from salesdata;

Select Count(Distinct Customer_id)
From Salesdata;

Select * from salesdata
where total_sale IS NULL;

Select * from salesdata
where COGS IS NULL;

Select * from Salesdata
Where 
	Transactions_id IS NULL OR
	Sale_date IS NULL OR
	customer_id IS NULL OR
	gender IS NULL OR
	category IS NULL OR 
	quantity IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;

DELETE from Salesdata
Where 
	Transactions_id IS NULL OR
	Sale_date IS NULL OR
	customer_id IS NULL OR
	gender IS NULL OR
	category IS NULL OR 
	quantity IS NULL OR
	price_per_unit IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
Select * from salesdata;

Select * from salesdata
where sale_date = '2022-11-05'
order by sale_time;
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
Select * from salesdata
Where category = 'Clothing' and quantity >= 4 and To_CHAR(sale_date, 'YYYY-MM') = '2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
Select 
Category, 
	Sum(Total_sale) as Total_sales,
	Count(*) as Total_orders
from Salesdata
group by category
order by 2 desc;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
Select * from salesdata;

-- Method 1
Select 
	Round(avg(age)) as Age
from salesdata
where Category = 'Beauty';

-- Method 2
Select
	Category,
	Round(avg(age)) as Age
from salesdata
Group by Category
order by Age desc;

-- Method 3
Select 
	Category,
	Round(avg(age)) as Age
from salesdata
Group by Category
Having Category = 'Beauty'
order by Age desc;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**

```sql
Select * from salesdata 
where Total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
Select 
	Category,
	Gender,
	Count(Transactions_id) as Total_Trans
From Salesdata
Group by Category, Gender
order by 3 desc;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
Select * from salesdata;

Select * from 
(Select 
	Extract (Year from sale_date) as year,
	Extract (Month from sale_date) as month,
	Avg(total_sale) as Avg_sale,
	Rank() over (partition by Extract (Year from sale_date) order by Avg(total_sale) desc)
From Salesdata
group by year, Month) as Table1 
where rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
Select * from Salesdata;

Select customer_id, sum(total_sale) as Total_sale from salesdata
group by customer_id
order by Total_sale desc
Limit 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
Select 
	Category,
	Count(Distinct Customer_id) as Unique_cus
from Salesdata
group by 1;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
Select * from salesdata;

-- with Altering the table
Select sale_time,  
	(case when sale_time between '00:00:00' and '12:00:00' then 'Morning'
			when sale_time between '12:01:00' and '17:00:00' then 'Afternoon'
		    Else 'Evening'
		End) as Time_of_day 
from Salesdata;

Alter table salesdata add column time_of_day varchar(30);

Select * from salesdata;

update salesdata set time_of_day = (case when sale_time between '00:00:00' and '12:00:00' then 'Morning'
			when sale_time between '12:01:00' and '17:00:00' then 'Afternoon'
		    Else 'Evening'
		End);

Select time_of_day, count(Transactions_id) as no_of_ord
from salesdata
group by 1
order by 2 desc;

-- Without altering the table, using cte

Alter table salesdata drop column time_of_day;

select * from salesdata;

With Timely_sales as
(Select *,  
	(case when sale_time between '00:00:00' and '12:00:00' then 'Morning'
			when sale_time between '12:01:00' and '17:00:00' then 'Afternoon'
		    Else 'Evening'
		End) as Time_of_day 
from Salesdata)
Select time_of_day, count(*) from Timely_sales
Group by 1
order by 2 desc;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for us data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

