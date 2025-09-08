# 🛒 Retail Sales Analysis | SQL Data Exploration

## Introduction

In today’s competitive retail environment, data-driven insights are essential for optimizing sales strategies, inventory management, and customer targeting. This project focuses on **analyzing retail sales data** using SQL. The dataset includes detailed transactions across multiple stores, products, and time periods. Using **SQL**, this project explores patterns in **monthly sales trends**, **order volumes**, **product performance**, **store-level insights**, and **weekday/weekend behaviors**.

The primary goal is to derive actionable business insights from transactional data using SQL queries, transformations, and aggregations.

##  Project Objectives

-  **Data Cleaning & Transformation**: Load and clean retail transaction data including conversion of dates, times, and removing inconsistencies.
-  **Monthly Trends Analysis**: Examine how sales, order volume, and quantity sold change over time.
-  **Month-on-Month Growth**: Analyze performance increases or declines in key metrics like sales, orders, and quantity sold.
-  **Time-Based Segmentation**: Compare sales during weekdays vs. weekends, and hourly trends.
-  **Store Performance**: Identify top-performing store locations and how sales differ across them.
-  **Product Category & Type Analysis**: Understand which product categories/types contribute the most to revenue.
-  **Daily Sales Behavior**: Detect above or below average performance on a daily level with average line comparison.

## Tools Used

- **SQL (MySQL)** – Primary tool for data extraction, transformation, and analysis.
- **Excel** – Used for initial data inspection and cleanup (optional).
- **GitHub** – For version control and project sharing.

## Data Transformation Process

- Created a **SQL schema and table** to store retail sales data.
- Used `LOAD DATA INFILE` to import the dataset from a `.csv` file.
- Converted date strings to proper `DATE` format using `STR_TO_DATE()`.
- Converted `transaction_time` and other fields to appropriate data types.

## Key Analyses and Insights

### 1. **Monthly Sales Overview**
- Calculated **total monthly sales**, **total orders**, and **total quantity sold** using `GROUP BY` on `MONTHNAME(transaction_date)`.
- Used formatting like `'K'` for thousands to enhance readability.

### 2. **Month-on-Month (MoM) Growth Analysis**
- Built **CTEs** with `LAG()` window functions to calculate **MoM % changes** in:
  - Sales
  - Order count
  - Quantity sold
- Used `CASE` logic to label growth trends as **'Increased'**, **'Decreased'**, or **'-'**.

### 3. **Weekday vs Weekend Performance**
- Used `DAYOFWEEK()` to categorize transactions as **Weekday** or **Weekend**.
- Segmented sales by day type for each month and specifically for **March**.

### 4. **Store-Level Sales Analysis**
- Grouped sales by `store_location` to find the best-performing locations.
- Compared sales across stores in a given month (e.g., March).

### 5. **Hourly Sales Trend**
- Used `HOUR(transaction_time)` to evaluate **peak sales hours** within a selected month.
- Identified peak retail hours and patterns during the day.

### 6. **Daily Sales vs Monthly Average**
- Created average sales line using nested CTEs.
- Compared **each day’s sales** to **monthly average** and labeled them as:
  - `AboveAvg`
  - `BelowAvg`
  - `EqualAvg`

### 7. **Product Category & Type Performance**
- Analyzed **total sales per product category** and per **product type** within selected months.
- Filtered by product categories like "Beauty" to drill deeper.

### 8. **Sales by Day of the Week**
- Used `DAYOFWEEK()` and `CASE` statements to label days (Monday–Sunday).
- Aggregated sales to find which day of the week drives the most revenue.

## Key insights:

- March emerged as one of the highest-performing months in both sales volume and order count.
- Weekends generally showed higher sales compared to weekdays, especially in certain months.
- Peak hours for sales were consistently observed in the late morning to early afternoon.
- Specific store locations consistently outperformed others, indicating high foot traffic or effective local marketing.
- Product categories like Beauty and Electronics had higher per-transaction revenue.
- Clear upward and downward trends were visible month-on-month, aiding seasonal planning.

## Conclusion

This SQL-based retail sales analysis provides actionable business insights by uncovering patterns in monthly sales, customer buying behavior, store performance, and product categories. The use of advanced SQL techniques such as window functions, CTEs, and conditional logic enabled robust exploratory data analysis (EDA) without needing additional tools.
