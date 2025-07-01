
# 🛒 Walmart Sales Data Exploration with SQL

Hey there! 👋 In this project, I explored Walmart's sales dataset using SQL to uncover business insights and answer real-world questions. This dataset simulates retail transactions across different branches and cities, helping me practice SQL skills for business analysis.

---

## 📂 Dataset Overview

The dataset contains:
- Branch and City details
- Customer type and Gender
- Product lines and sales amounts
- Payment methods
- Ratings
- Date, Time of purchase
- Revenue, Tax, COGS (Cost of Goods Sold), Gross Profit, etc.

The table structure looks like this:

```sql
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
```

---

## 💡 Business Questions Answered

### Generic
- How many unique cities does the data have?  
- Which city is each branch located in?  

### Product Analysis
- How many unique product lines are available?  
- What is the most common payment method?  
- Which product line sells the most?  
- Total revenue by month and which month had the highest COGS  
- Product line with the highest revenue  
- City with the largest revenue  
- Product line contributing the most VAT (tax)  
- Flagging product lines as "Good" or "Bad" based on average sales  
- Branches selling more than average product quantity  
- Most popular product line by gender  
- Average rating of each product line  

### Sales Analysis
- Number of sales made during different times of day for each weekday  
- Which customer type brings the most revenue?  
- City with the highest tax percentage (VAT)  
- Which customer type contributes most to VAT?  

### Customer Insights
- Number of unique customer types  
- Number of unique payment methods  
- Most common customer type  
- Which customer type buys the most  
- Gender distribution overall and per branch  
- Peak time of day for customer ratings  
- Branch-wise rating trends by time of day  
- Best day of the week based on average ratings  
- Best-rated day of the week per branch  

---

## 💵 Revenue & Profit Calculations

Key formulas used in the analysis:

```
COGS = unit_price * quantity  
VAT = 5% * COGS  
Total (Gross Sales) = VAT + COGS  
Gross Profit = Total - COGS  
Gross Margin % = Gross Profit / Total Revenue  
```

**Example Calculation:**

Given:  
- Unit Price = 45.79  
- Quantity = 7  

**Calculations:**  
- COGS = 45.79 × 7 = 320.53  
- VAT = 5% × 320.53 = 16.0265  
- Total = 320.53 + 16.0265 = 336.5565  
- Gross Margin % ≈ (16.0265 / 336.5565) × 100 = 4.76%  

---

## 🛠️ Tools & Technologies
- SQL (MySQL/PostgreSQL)  
- Data cleaning and analysis  
- Business problem-solving with SQL  

---

## 📂 Files
- `sql_project.sql` → Contains all the SQL queries used in the project  

---

## 🚀 Summary

This project helped me improve my SQL skills and taught me how to analyze sales, customer behavior, and revenue trends. It simulates real-world scenarios where businesses use data to make informed decisions.

Feel free to explore the queries and modify them for your own practice! 😊
