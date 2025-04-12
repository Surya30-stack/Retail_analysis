CREATE schema retail_sales;

USE retail_sales;

CREATE TABLE Retail_sales (
    transaction_id int,
    transaction_date date,
    transaction_time time,
    transaction_qty int,
    store_id int,
    store_location varchar(100),
    product_id int,
    unit_price double,
    product_category varchar(100),
    product_type varchar(100),
    product_detail varchar(100)
);

LOAD DATA INFILE "D:\\Surya\\Office and resume\\Programming study material\\Projects\\Retail_sales analysis\\Retail_Dataset.csv"
INTO TABLE retail_sales
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS  
 (transaction_id, @transaction_date, transaction_time, transaction_qty, store_id, store_location, product_id, unit_price, product_category, product_type, product_detail)
SET transaction_date = STR_TO_DATE(@transaction_date, '%d-%m-%Y');

select * from retail_sales;


ALTER TABLE retail_sales
MODIFY COLUMN transaction_date date;

ALTER TABLE retail_sales
MODIFY COLUMN transaction_time time;

# Calculate the total sales for each respective month 

SELECT 
monthname(transaction_date) AS Month, 
concat(round(sum(unit_price*transaction_qty)/1000,1),"K") AS total_sales
FROM retail_sales 
GROUP BY monthname(transaction_date)
ORDER BY Total_sales DESC;

# Calculate the total number of orders for each respective month.

SELECT 
monthname(transaction_date) AS Month, 
count(transaction_id) AS total_orders
FROM retail_sales 
GROUP BY monthname(transaction_date)
ORDER BY Total_orders DESC;

# Calculate the total quantity sold for each respective month.

SELECT 
monthname(transaction_date) AS Month, 
sum(transaction_qty) AS total_quantity_sold
FROM retail_sales 
GROUP BY monthname(transaction_date)
ORDER BY total_quantity_sold DESC;


# ﻿Determine the month-on-month increase or decrease in sales. 

WITH cte AS(
         SELECT MONTH(transaction_date) AS Month_number, 
concat(round(sum(unit_price*transaction_qty)/1000,1),"K") AS total_sales ,
concat(round((sum(unit_price * transaction_qty) - LAG(sum(unit_price * transaction_qty),1)
OVER (ORDER BY MONTH(transaction_date))) / LAG(sum(unit_price * transaction_qty),1)
OVER (ORDER BY MONTH(transaction_date)) * 100 ),"%")AS mom_sales
         FROM retail_sales 
         GROUP BY MONTH(transaction_date)
         ORDER BY MONTH(transaction_date) ASC)
 
SELECT *,
CASE WHEN mom_sales > LAG(mom_sales) OVER (ORDER BY month_number) THEN 'Increased' 
     WHEN mom_sales < LAG(mom_sales) OVER (ORDER BY month_number) THEN 'Decreased' 
     ELSE '-' END AS Sales_status
FROM cte;


# ﻿Determine the month-on-month increase or decrease in the number of orders. 

WITH Order_cte AS(
         SELECT MONTH(transaction_date) AS Month_number, 
         count(transaction_id) AS total_orders,
concat(round((count(transaction_id) - LAG(count(transaction_id),1)
OVER(ORDER BY MONTH(transaction_date))) / LAG(count(transaction_id),1)
OVER(ORDER BY MONTH(transaction_date)) *100),'%') AS mom_order
FROM  retail_sales 
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date) ASC)

SELECT *,
CASE WHEN mom_order > LAG(mom_order) OVER (ORDER BY month_number) THEN 'Increased' 
	 WHEN mom_order < LAG(mom_order) OVER (ORDER BY month_number) THEN 'Decreased' 
     ELSE '-' END AS Sales_status FROM order_cte;


# ﻿Determine the month-on-month increase or decrease in the total quantity sold. 

WITH sold_cte AS(
           SELECT MONTH(transaction_date) AS month_number, 
           sum(transaction_qty) AS total_qty_sold,
round((sum(transaction_qty) - LAG(sum(transaction_qty),1)
OVER (ORDER BY MONTH(transaction_date))) / LAG(sum(transaction_qty),1)
OVER(ORDER BY MONTH(transaction_date)) *100) AS mom_qty_sold
           FROM retail_sales 
           GROUP BY MONTH(transaction_date)
		   ORDER BY MONTH(transaction_date))

SELECT *,
CASE WHEN mom_qty_sold > LAG(mom_qty_sold) OVER (ORDER BY month_number) THEN 'Increased' 
     WHEN mom_qty_sold < LAG(mom_qty_sold) OVER (ORDER BY month_number) THEN 'Decreased' 
     ELSE '-' END AS Sales_status FROM sold_cte;


# Segment sales data into weekdays and weekends to analyze performance variations of everry month
 
SELECT 
    MONTHNAME(transaction_date) AS month_name,
    IF(DAYOFWEEK(transaction_date) IN (1, 7), 'Weekend', 'Weekdays') AS daytype,
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1), 'K') AS total_sales
FROM retail_sales
GROUP BY MONTH(transaction_date), daytype, MONTHNAME(transaction_date)
ORDER BY MONTH(transaction_date), daytype;

# Segment sales data into weekdays and weekends to analyze performance variations particularly in march

SELECT 
  IF(DAYOFWEEK(transaction_date) IN (1,7), 'Weekend', 'Weekdays') AS daytype,
  CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1), 'K') AS total_sales
FROM retail_sales
WHERE MONTH(transaction_date) = 3
GROUP BY daytype;


# Total sales, total orders, total quantity sold for a particular date

SELECT 
concat(round(sum(unit_price*transaction_qty)/1000,1),"K") AS total_sales,
count(transaction_id) AS total_orders,
sum(transaction_qty) AS total_quantity_sold 
FROM retail_sales
WHERE transaction_date = '2023-03-28';

SELECT 
round(sum(unit_price*transaction_qty)) AS total_sales,
count(transaction_id) AS total_orders,
sum(transaction_qty) AS total_quantity_sold 
FROM retail_sales
WHERE MONTH(transaction_date) = 5 AND
dayofweek(transaction_date) = 6 AND
hour(transaction_time) = 8;


# hourly sales trend for a particular month

SELECT 
hour(transaction_time) AS hour, 
round(sum(unit_price*transaction_qty)) AS total_sales
FROM retail_sales
WHERE MONTH(transaction_date) = 3
GROUP BY hour
ORDER BY hour;

# Total sales by different store locations for a particular month. 

SELECT 
store_location, concat(round(sum(unit_price*transaction_qty)/1000,1),"K") 
AS total_sales
FROM retail_sales
WHERE MONTH(transaction_date) = 3
GROUP BY store_location
ORDER BY sum(unit_price*transaction_qty) DESC;



# Daily Sales Analysis with Average Line: 

                 WITH cte AS(SELECT (round(AVG(total_sales),1)) AS AvgSales 
FROM (SELECT sum(unit_price*transaction_qty) AS total_sales
FROM retail_sales 
WHERE MONTH(transaction_date) = 1
GROUP BY transaction_date) x),

				  cte2 AS (SELECT DAY(transaction_date) AS Day,
round(sum(unit_price*transaction_qty),1) AS total_sales
FROM retail_sales
WHERE MONTH(transaction_date) = 4
GROUP BY transaction_date
ORDER BY transaction_date)

SELECT 
day, total_sales, AvgSales AS Month_AvgSales,
CASE WHEN total_sales > AvgSales THEN 'AboveAvg'
	 WHEN total_sales < AvgSales THEN 'BelowAvg'
     ELSE 'EqualAvg' END AS status
FROM cte, cte2;


# Total sales by product category 

SELECT 
DISTINCT product_category, 
round(sum(unit_price*transaction_qty)) AS total_sales
FROM retail_sales
WHERE month(transaction_date) = 3 
GROUP BY product_category;

# total sales by product type

SELECT 
DISTINCT product_type, 
round(sum(unit_price*transaction_qty)) AS total_sales
FROM retail_sales
WHERE month(transaction_date) = 5 AND product_category = 'Beauty'
GROUP BY product_type;



# sales calculation by days for a particular month

SELECT CASE WHEN dayofweek(transaction_date) = 2 THEN 'Monday'
			WHEN dayofweek(transaction_date) = 3 THEN 'Tuesday'
			WHEN dayofweek(transaction_date) = 4 THEN 'Wednesday'
			WHEN dayofweek(transaction_date) = 5 THEN 'Thursday'
			WHEN dayofweek(transaction_date) = 6 THEN 'Friday'
			WHEN dayofweek(transaction_date) = 7 THEN 'Saturday'
			ELSE 'Sunday' END AS DayName, 
            round(sum(transaction_qty*unit_price)) AS total_sales
FROM retail_sales
WHERE month(transaction_date) = 3
GROUP BY dayName;




















