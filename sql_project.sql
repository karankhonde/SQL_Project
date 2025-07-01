-- --------------------------------------------------------------Customer---------------------------------------------------------------------------------

-- How many unique customer types does the data have?
select distinct customer_type as ct from sales

-- How many unique payment methods does the data have?
select distinct payment from sales

-- What is the most common customer type?
select count(customer_type) as ct,customer_type from sales
group by customer_type
order by ct desc

-- Which customer type buys the most?
select customer_type,sum(total) from sales
group by customer_type
order by sum(total) desc 

-- What is the gender of most of the customers?
select gender,count(*) from sales
group by gender
order by count(*) desc 

-- What is the gender distribution per branch?

select gender,branch,count(gender) from sales
group by branch,gender
order by count(gender) desc 

-- Which time of the day do customers give most ratings?
select time_of_day,count(rating) from sales
group by time_of_day
order by count(rating) desc 

-- Which time of the day do customers give most ratings per branch?
select branch,time_of_day,count(rating) from sales
group by branch,time_of_day
order by count(rating) desc

-- Which day of the week has the best avg ratings?

select day_name,avg(rating) from sales
group by day_name
order by avg(rating) desc 

-- Which day of the week has the best average ratings per branch?

select branch,day_name,avg(rating) from sales
group by branch,day_name
order by avg(rating) desc 


