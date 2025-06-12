-- sql retail sales analysis - project 1

select * from retail_sales
limit 10;

-- count the total no of data in table

select count(*)
from retail_sales

--- Data Cleaning

-- to check in column has any null values 

select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

-- check the diff between = and is

-- IS NULL checks if a value is a null value, while = is used for comparing values. 

-- so instead of doning one by one columns we can apply where or conditions

select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or 
	customer_id is null
	or 
	gender is null
	or 
	age is null
	or 
	category is null
	or
	quantiy is null
	or 
	price_per_unit is null
	or 
	cogs is null
	or
	total_sale is null

-- delete records which conatins null value

DELETE from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or 
	customer_id is null
	or 
	gender is null
	or 
	age is null
	or 
	category is null
	or
	quantiy is null
	or 
	price_per_unit is null
	or 
	cogs is null
	or
	total_sale is null

-- Data Exploartion

-- How many sales we have or how many records we have ?

select count(*) as total_sale
from retail_sales

---- How many customers we have ?

select count(customer_id) as total_customer
from retail_sales

---- How many uniuque customers we have ?

select  distinct count(customer_id) as unique_customer
from retail_sales -- 1987 -- this is not the correct way to find distinct from perticular column

select  count(distinct customer_id) as unique_customer
from retail_sales  -- 155

--  How many category we have ?

select count(category) as category
from retail_sales -- 1987


--  How many unique category we have ?

select count(distinct category) as unique_category
from retail_sales -- 3

-- if i want to show out the category name then 

select distinct category
from retail_sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



---- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category
--is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select transactions_id, category, quantiy
from retail_sales
where (category = 'Clothing' and quantiy >= 4)
and to_char(sale_date, 'YYYY-MM') = '2022-11'  -- 17 rows


select *
from retail_sales
where 
	category = 'Clothing'
	and 
	to_char(sale_date, 'YYYY-MM') = '2022-11'
	and
	quantiy >= 4 -- 17 rows (same output as above) (ie both are correct)
	

--  Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by category

	
select
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders -- count apply on category 
from retail_sales
group by 1  -- both having same output (here 1 may be index or column which is category 1)


select
	category,
	count(*) as total_orders,
	sum(total_sale) as net_sale
from retail_sales
group by 1  


-- Q.4 Write a SQL query to find the average age of customers who purchased items from 
--the 'Beauty' category.

select avg(age) as ave_age
from retail_sales
where category = 'Beauty' -- 40.4157119476268412

-- if we want only 2 decimal then use round --> which round the demical value according to use case

select 
	round(avg(age),2) as ave_age
from retail_sales
where category = 'Beauty' -- 40.42


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000 -- 306 rows

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each 
-- gender in each category.

select 
	category,
	gender,
	count(*) as total_transaction
from retail_sales
group by
	category,
	gender
order by 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling 
-- month in each year

select  
	year,
	month,
	avg_sale
from
(
select	
	EXTRACT(year from sale_date) as year,
	EXTRACT(month from sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() over(partition by EXTRACT(year from sale_date) order by AVG(total_sale) DESC) as rnk
from retail_sales
group by year,month
) as t1
where rnk =1
order by 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales DESC
limit 5

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each
-- category.

select 
	category,
	count(distinct customer_id) as cnt_unique_cust
from retail_sales
group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, 
-- Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


-- End project
