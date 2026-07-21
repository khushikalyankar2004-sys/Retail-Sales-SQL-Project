-- ============================================================================
-- DATABASE CREATION
-- ============================================================================

DROP DATABASE IF EXISTS retail_profitability;

CREATE DATABASE retail_profitability;

USE retail_profitability;

-- ============================================================================
-- TABLE CREATION
-- ============================================================================

CREATE TABLE retail_sales (

    row_id INT,
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),

    customer_id VARCHAR(30),
    customer_name VARCHAR(100),
    segment VARCHAR(50),

    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),

    retail_sales_people VARCHAR(100),

    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(100),
    product_name VARCHAR(255),

    returned VARCHAR(10),

    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2)

);

-- ============================================================================
-- DATA EXPLORATION
-- ============================================================================

-- Display complete dataset

SELECT *
FROM retail_sales;


-- Total records available

SELECT COUNT(*) AS total_records
FROM retail_sales;


-- Identify duplicate transactions

SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_count
FROM retail_sales
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- Minimum & Maximum values

SELECT

    MIN(sales) AS minimum_sales,
    MAX(sales) AS maximum_sales,

    MIN(profit) AS minimum_profit,
    MAX(profit) AS maximum_profit,

    MIN(discount) AS minimum_discount,
    MAX(discount) AS maximum_discount

FROM retail_sales;


-- Count unique entities

SELECT

    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT category) AS total_categories,
    COUNT(DISTINCT region) AS total_regions

FROM retail_sales;

-- ============================================================================
-- BUSINESS PERFORMANCE ANALYSIS
-- ============================================================================

-- Overall sales and profit

SELECT

    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit

FROM retail_sales;


-- Total orders & customers

SELECT

    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers

FROM retail_sales;

-- ============================================================================
-- SALES ANALYSIS
-- ============================================================================

-- Category-wise sales

SELECT

    category,
    ROUND(SUM(sales),2) AS total_sales

FROM retail_sales

GROUP BY category

ORDER BY total_sales DESC;


-- Monthly sales trend

SELECT

    DATE_FORMAT(order_date,'%Y-%m') AS month,
    ROUND(SUM(sales),2) AS total_sales

FROM retail_sales

GROUP BY DATE_FORMAT(order_date,'%Y-%m')

ORDER BY month;

-- ============================================================================
-- CUSTOMER ANALYSIS
-- ============================================================================

-- Top 10 customers by sales

SELECT

    customer_name,

    ROUND(SUM(sales),2) AS total_sales

FROM retail_sales

GROUP BY customer_name

ORDER BY total_sales DESC

LIMIT 10;

-- ============================================================================
-- PRODUCT ANALYSIS
-- ============================================================================

-- Product profit ranking

SELECT

    product_name,

    SUM(profit) AS total_profit,

    RANK() OVER
    (
        ORDER BY SUM(profit) DESC
    ) AS profit_rank

FROM retail_sales

GROUP BY product_name;


-- Most profitable products

SELECT

    product_name,

    ROUND(SUM(profit),2) AS total_profit

FROM retail_sales

GROUP BY product_name

ORDER BY total_profit DESC

LIMIT 10;

-- ============================================================================
-- PRODUCT PERFORMANCE ANALYSIS
-- ============================================================================

-- Products generating losses

SELECT

    product_name,

    ROUND(SUM(profit),2) AS total_profit

FROM retail_sales

GROUP BY product_name

HAVING SUM(profit) < 0

ORDER BY total_profit;


-- Discount vs Average Profit

SELECT

    ROUND(discount,2) AS discount_rate,

    ROUND(AVG(profit),2) AS average_profit

FROM retail_sales

GROUP BY discount

ORDER BY discount_rate;

-- ============================================================================
-- SALES REPRESENTATIVE ANALYSIS
-- ============================================================================

-- Best performing salesperson

SELECT

    retail_sales_people,

    ROUND(SUM(sales),2) AS total_sales

FROM retail_sales

GROUP BY retail_sales_people

ORDER BY total_sales DESC;

-- ============================================================================
-- REGIONAL PERFORMANCE ANALYSIS
-- ============================================================================

-- Profit by region

SELECT

    region,

    ROUND(SUM(profit),2) AS total_profit

FROM retail_sales

GROUP BY region

ORDER BY total_profit DESC;


-- Most profitable state

SELECT

    state,

    ROUND(SUM(profit),2) AS total_profit

FROM retail_sales

GROUP BY state

ORDER BY total_profit DESC;


-- Top 5 cities by profit

SELECT

    city,

    ROUND(SUM(profit),2) AS total_profit

FROM retail_sales

GROUP BY city

ORDER BY total_profit DESC

LIMIT 5;

-- ============================================================================
-- CATEGORY PERFORMANCE
-- ============================================================================

-- Categories with highest sales and profit

SELECT

    category,

    ROUND(SUM(sales),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit

FROM retail_sales

GROUP BY category

ORDER BY total_sales DESC;

-- ============================================================================
-- CUSTOMER SEGMENTATION
-- ============================================================================

-- Segment customers based on total sales

SELECT

    customer_name,

    ROUND(SUM(sales),2) AS total_sales,

    CASE

        WHEN SUM(sales) >= 10000 THEN 'High Value'

        WHEN SUM(sales) >= 5000 THEN 'Medium Value'

        ELSE 'Low Value'

    END AS customer_segment

FROM retail_sales

GROUP BY customer_name

ORDER BY total_sales DESC;

-- ============================================================================
-- ADVANCED SQL
-- Common Table Expression (CTE)
-- ============================================================================

-- Top customer in each region

WITH customer_sales AS
(

    SELECT

        region,

        customer_name,

        ROUND(SUM(sales),2) AS total_sales,

        RANK() OVER
        (
            PARTITION BY region
            ORDER BY SUM(sales) DESC
        ) AS sales_rank

    FROM retail_sales

    GROUP BY region, customer_name

)

SELECT

    region,

    customer_name,

    total_sales

FROM customer_sales

WHERE sales_rank = 1;

-- ============================================================================
-- VIEW CREATION
-- ============================================================================

-- Category performance summary

CREATE VIEW category_sales_summary AS

SELECT

    category,

    ROUND(SUM(sales),2) AS total_sales,

    ROUND(SUM(profit),2) AS total_profit

FROM retail_sales

GROUP BY category;


-- Display the view

SELECT *

FROM category_sales_summary;

-- ============================================================================
-- BUSINESS RECOMMENDATIONS
-- ============================================================================

/*
Business Recommendations:-

1. Review products that consistently generate losses and evaluate pricing,
   sourcing, or discontinuation strategies.

2. Optimize discount policies to increase revenue without significantly
   reducing profit margins.

3. Build loyalty programs for high-value customers to improve customer
   retention and lifetime value.

4. Focus marketing and expansion efforts on consistently profitable
   regions and states.

5. Ensure adequate inventory for top-performing products to avoid lost sales.

6. Monitor salesperson performance regularly and identify best practices
   that can be replicated across the sales team.

===============================================================================
                              END OF PROJECT
===============================================================================
*/
