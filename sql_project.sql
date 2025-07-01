-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------Generic ---------------------------------------------------------------------------
-- How many unique cities does the data have?
select distinct city from sales

-- In which city is each branch?
select distinct city, branch from sales

-- ---------------------------------------------Product---------------------------------------------------------------------------------------

-- How many unique product lines does the data have?
select distinct product_line from sales

-- What is the most common payment method?
select count(payment),payment from sales
group by payment
order by count(payment) desc
limit 1

-- What is the most selling product line?
select count(product_line),product_line from sales
group by product_line
order by count(product_line) desc
limit 1

-- What is the total revenue by month?
select sum(total),month_name from sales
group by month_name
order by sum(total) desc

select * from sales

-- -------------------------------
-- GENERIC QUESTIONS
-- -------------------------------

-- 1. How many unique cities does the data have?
SELECT COUNT(DISTINCT city) AS unique_cities FROM sales;

-- 2. In which city is each branch?
SELECT DISTINCT branch, city FROM sales;

-- -------------------------------
-- PRODUCT QUESTIONS
-- -------------------------------

-- 3. How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line) AS unique_product_lines FROM sales;

-- 4. What is the most common payment method?
SELECT payment, COUNT(*) AS total
FROM sales
GROUP BY payment
ORDER BY total DESC
LIMIT 1;

-- 5. What is the most selling product line?
SELECT product_line, SUM(quantity) AS total_sold
FROM sales
GROUP BY product_line
ORDER BY total_sold DESC
LIMIT 1;

-- 6. What is the total revenue by month?
SELECT MONTHNAME(date) AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;

-- 7. What month had the largest COGS?
SELECT MONTHNAME(date) AS month, SUM(cogs) AS total_cogs
FROM sales
GROUP BY month
ORDER BY total_cogs DESC
LIMIT 1;

-- 8. What product line had the largest revenue?
SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

-- 9. What is the city with the largest revenue?
SELECT city, SUM(total) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;

-- 10. What product line had the largest VAT?
SELECT product_line, SUM(cogs * tax_pct) AS total_vat
FROM sales
GROUP BY product_line
ORDER BY total_vat DESC
LIMIT 1;

-- 11. Fetch each product line and show "Good" or "Bad" based on average sales
WITH cte_avg AS (
    SELECT 
        product_line,
        AVG(total) AS avg_sales_per_product_line,
        (SELECT AVG(total) FROM sales) AS overall_avg_sales
    FROM sales
    GROUP BY product_line
)
SELECT *,
    CASE 
        WHEN avg_sales_per_product_line > overall_avg_sales THEN 'Good'
        ELSE 'Bad'
    END AS performance
FROM cte_avg;

-- 12. Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS total_sold
FROM sales
GROUP BY branch
HAVING total_sold > (SELECT AVG(quantity) FROM sales);

-- 13. Most common product line by gender
SELECT gender, product_line, COUNT(*) AS total_sales
FROM sales
GROUP BY gender, product_line
ORDER BY gender, total_sales DESC;

-- 14. Average rating of each product line
SELECT product_line, ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line;

-- -------------------------------
-- SALES QUESTIONS
-- -------------------------------

-- 15. Number of sales made in each time of the day per weekday
SELECT day_name, time_of_day, COUNT(*) AS total_sales
FROM sales
GROUP BY day_name, time_of_day
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- 16. Which customer type brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1;

-- 17. Which city has the largest tax percent/ VAT?
SELECT city, AVG(tax_pct) * 100 AS avg_tax_percent
FROM sales
GROUP BY city
ORDER BY avg_tax_percent DESC
LIMIT 1;

-- 18. Which customer type pays the most in VAT?
SELECT customer_type, SUM(cogs * tax_pct) AS total_vat_paid
FROM sales
GROUP BY customer_type
ORDER BY total_vat_paid DESC
LIMIT 1;

-- -------------------------------
-- CUSTOMER QUESTIONS
-- -------------------------------

-- 19. How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) AS unique_customer_types FROM sales;

-- 20. How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) AS unique_payment_methods FROM sales;

-- 21. What is the most common customer type?
SELECT customer_type, COUNT(*) AS total
FROM sales
GROUP BY customer_type
ORDER BY total DESC
LIMIT 1;

-- 22. Which customer type buys the most (total quantity)?
SELECT customer_type, SUM(quantity) AS total_quantity
FROM sales
GROUP BY customer_type
ORDER BY total_quantity DESC
LIMIT 1;

-- 23. What is the gender of most of the customers?
SELECT gender, COUNT(*) AS total_customers
FROM sales
GROUP BY gender
ORDER BY total_customers DESC
LIMIT 1;

-- 24. What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) AS total_customers
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender;

-- 25. Which time of the day do customers give most ratings?
SELECT time_of_day, COUNT(rating) AS total_ratings
FROM sales
GROUP BY time_of_day
ORDER BY total_ratings DESC
LIMIT 1;

-- 26. Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, COUNT(rating) AS total_ratings
FROM sales
GROUP BY branch, time_of_day
ORDER BY total_ratings DESC;

-- 27. Which day of the week has the best average ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC
LIMIT 1;

-- 28. Which day of the week has the best average ratings per branch?
SELECT branch, day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY branch, day_name
ORDER BY avg_rating DESC;
