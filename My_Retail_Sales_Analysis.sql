-- Retail Sales Analysis P2 - Beginner Level
-- Database Creation
CREATE DATABASE Retail_Sales_Analysis;

-- Table Creation
-- CREATE TABLE
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

-- Data Exploration
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

-- DATA ANALYSIS
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05.

Select * from salesdata;

Select * from salesdata
where sale_date = '2022-11-05'
order by sale_time;

/* 2. Write a SQL query to retrieve all transactions where the category 
is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022. */

Select * from salesdata
Where category = 'Clothing' and quantity >= 4 and To_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

Select 
Category, 
	Sum(Total_sale) as Total_sales,
	Count(*) as Total_orders
from Salesdata
group by category
order by 2 desc;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

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

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select * from salesdata 
where Total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select 
	Category,
	Gender,
	Count(Transactions_id) as Total_Trans
From Salesdata
Group by Category, Gender
order by 3 desc;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

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

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales .

Select * from Salesdata;

Select customer_id, sum(total_sale) as Total_sale from salesdata
group by customer_id
order by Total_sale desc
Limit 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

Select 
	Category,
	Count(Distinct Customer_id) as Unique_cus
from Salesdata
group by 1;

-- 10. Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17).

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

-- The End -- 



