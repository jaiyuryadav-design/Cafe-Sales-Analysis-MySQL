CREATE DATABASE ajeyscafes;
use ajeyscafes;

CREATE TABLE cafe_orders (
    order_id VARCHAR(50),
    outlet_name VARCHAR(100),
    city VARCHAR(50),
    order_datetime VARCHAR(50),
    item_name VARCHAR(100),
    quantity VARCHAR(50),
    price VARCHAR(50),
    payment_mode VARCHAR(50),
    customer_name VARCHAR(100),
    rating VARCHAR(50),
    franchise_owner VARCHAR(100)
);

set global local_infile = 1;

-- Loading File

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ajeys_cafe_franchise_unclean_dataset.csv"
INTO TABLE cafe_orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT COUNT(*) AS total_rows
FROM cafe_orders;

select count(*) from cafe_orders;
select * from cafe_orders;
USE cafe_management;

SELECT
    SUM(TRIM(order_id) = '') AS order_id_blank,
    SUM(TRIM(outlet_name) = '') AS outlet_blank,
    SUM(TRIM(city) = '') AS city_blank,
    SUM(TRIM(order_datetime) = '') AS datetime_blank,
    SUM(TRIM(item_name) = '') AS item_blank,
    SUM(TRIM(quantity) = '') AS quantity_blank,
    SUM(TRIM(price) = '') AS price_blank,
    SUM(TRIM(payment_mode) = '') AS payment_blank,
    SUM(TRIM(customer_name) = '') AS customer_blank,
    SUM(TRIM(rating) = '') AS rating_blank,
    SUM(TRIM(franchise_owner) = '') AS owner_blank
FROM cafe_orders;

-- Task-1 Standardize names and outlets names 

SET SQL_SAFE_UPDATES = 0;

UPDATE cafe_orders
SET city =
    CASE
        WHEN LOWER(TRIM(city)) = 'ahmedabad' THEN 'Ahmedabad'

        WHEN LOWER(TRIM(city)) IN ('bangalore', 'bengaluru')
            THEN 'Bengaluru'

        WHEN LOWER(TRIM(city)) IN ('baroda', 'vadodara')
            THEN 'Vadodara'

        WHEN LOWER(TRIM(city)) IN ('delhi', 'new delhi')
            THEN 'Delhi'

        WHEN LOWER(TRIM(city)) = 'mumbai' THEN 'Mumbai'

        WHEN LOWER(TRIM(city)) = 'pune' THEN 'Pune'

        WHEN LOWER(TRIM(city)) = 'rajkot' THEN 'Rajkot'

        WHEN LOWER(TRIM(city)) = 'surat' THEN 'Surat'

        ELSE TRIM(city)
    END;
    
    SELECT city, COUNT(*) AS total_rows
FROM cafe_orders
GROUP BY city
ORDER BY city;

SELECT 
    outlet_name,
    COUNT(*) AS total_rows
FROM cafe_orders
GROUP BY outlet_name
ORDER BY outlet_name;

SELECT 
    outlet_name,
    COUNT(*) AS total_rows
FROM cafe_orders
WHERE TRIM(city) = ''
GROUP BY outlet_name
ORDER BY total_rows DESC;

SET SQL_SAFE_UPDATES = 0;

UPDATE cafe_orders
SET outlet_name =
CASE
    WHEN LOWER(outlet_name) LIKE '%surat%'
        THEN 'Ajey''s Cafe - Surat'

    WHEN LOWER(outlet_name) LIKE '%pune%'
        THEN 'Ajey''s Cafe - Pune'

    WHEN LOWER(outlet_name) LIKE '%rajkot%'
        THEN 'Ajey''s Cafe - Rajkot'

    WHEN LOWER(outlet_name) LIKE '%ahmedabad%'
         OR LOWER(outlet_name) LIKE '%ahmadabad%'
        THEN 'Ajey''s Cafe - Ahmedabad'

    WHEN LOWER(outlet_name) LIKE '%bangalore%'
         OR LOWER(outlet_name) LIKE '%banglore%'
         OR LOWER(outlet_name) LIKE '%bengaluru%'
        THEN 'Ajey''s Cafe - Bengaluru'

    WHEN LOWER(outlet_name) LIKE '%delhi%'
        THEN 'Ajey''s Cafe - Delhi'

    WHEN LOWER(outlet_name) LIKE '%mumbai%'
        THEN 'Ajey''s Cafe - Mumbai'

    WHEN LOWER(outlet_name) LIKE '%vadodara%'
         OR LOWER(outlet_name) LIKE '%baroda%'
        THEN 'Ajey''s Cafe - Vadodara'

    ELSE TRIM(outlet_name)
END;

SELECT DISTINCT outlet_name
FROM cafe_orders
ORDER BY outlet_name;

UPDATE cafe_orders
SET city =
CASE
    WHEN outlet_name = 'Ajey''s Cafe - Ahmedabad' THEN 'Ahmedabad'
    WHEN outlet_name = 'Ajey''s Cafe - Bengaluru' THEN 'Bengaluru'
    WHEN outlet_name = 'Ajey''s Cafe - Delhi' THEN 'Delhi'
    WHEN outlet_name = 'Ajey''s Cafe - Mumbai' THEN 'Mumbai'
    WHEN outlet_name = 'Ajey''s Cafe - Pune' THEN 'Pune'
    WHEN outlet_name = 'Ajey''s Cafe - Rajkot' THEN 'Rajkot'
    WHEN outlet_name = 'Ajey''s Cafe - Surat' THEN 'Surat'
    WHEN outlet_name = 'Ajey''s Cafe - Vadodara' THEN 'Vadodara'
END
WHERE TRIM(city) = '';

SELECT COUNT(*) AS blank_city
FROM cafe_orders
WHERE TRIM(city) = '';


SELECT 
    order_id,
    outlet_name,
    city,
    order_datetime,
    item_name,
    quantity,
    price,
    payment_mode,
    customer_name,
    rating,
    franchise_owner,
    COUNT(*) AS duplicate_count
FROM cafe_orders
GROUP BY
    order_id,
    outlet_name,
    city,
    order_datetime,
    item_name,
    quantity,
    price,
    payment_mode,
    customer_name,
    rating,
    franchise_owner
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

SELECT COUNT(*) AS duplicate_groups
FROM (
    SELECT
        order_id,
        outlet_name,
        city,
        order_datetime,
        item_name,
        quantity,
        price,
        payment_mode,
        customer_name,
        rating,
        franchise_owner
    FROM cafe_orders
    GROUP BY
        order_id,
        outlet_name,
        city,
        order_datetime,
        item_name,
        quantity,
        price,
        payment_mode,
        customer_name,
        rating,
        franchise_owner
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT 
    duplicate_count,
    COUNT(*) AS groups_count
FROM (
    SELECT 
        order_id,
        outlet_name,
        city,
        order_datetime,
        item_name,
        quantity,
        price,
        payment_mode,
        customer_name,
        rating,
        franchise_owner,
        COUNT(*) AS duplicate_count
    FROM cafe_orders
    GROUP BY
        order_id, outlet_name, city, order_datetime,
        item_name, quantity, price, payment_mode,
        customer_name, rating, franchise_owner
    HAVING COUNT(*) > 1
) 
GROUP BY duplicate_count;

CREATE TABLE cafe_orders_backup AS
SELECT * FROM cafe_orders;
SELECT COUNT(*) 
FROM cafe_orders_backup;

CREATE TABLE cafe_orders_clean AS
SELECT DISTINCT *
FROM cafe_orders;

SELECT COUNT(*) AS cleaned_rows
FROM cafe_orders_clean;

use ajeyscafes;

select * from cafe_orders_clean;

SET SQL_SAFE_UPDATES = 0;

UPDATE cafe_orders_clean
SET quantity = NULL
WHERE TRIM(quantity) = '';

UPDATE cafe_orders_clean
SET price = NULL
WHERE TRIM(price) = '';

UPDATE cafe_orders_clean
SET quantity = NULL
WHERE CAST(quantity AS DECIMAL(10,2)) <= 0;

UPDATE cafe_orders_clean
SET price = NULL
WHERE CAST(price AS DECIMAL(10,2)) <= 0;

SELECT
    COUNT(*) AS total_rows,
    SUM(quantity IS NULL) AS invalid_quantity,
    SUM(price IS NULL) AS invalid_price
FROM cafe_orders_clean;

-- Date&Time format 

select * from cafe_orders_clean;

SELECT order_datetime
FROM cafe_orders_clean
WHERE TRIM(order_datetime) <> ''
LIMIT 30;

SELECT COUNT(*) AS blank_dates
FROM cafe_orders_clean
WHERE TRIM(order_datetime) = '';

ALTER TABLE cafe_orders_clean
ADD COLUMN clean_order_datetime DATETIME;

UPDATE cafe_orders_clean
SET clean_order_datetime =
CASE

    -- Format: 2023-07-18 07:14
    WHEN order_datetime LIKE '____-__-__ __:__'
    THEN STR_TO_DATE(order_datetime, '%Y-%m-%d %H:%i')

    -- Format: 26/11/2023 05:31
    WHEN order_datetime LIKE '__/__/____ __:__'
    THEN STR_TO_DATE(order_datetime, '%d/%m/%Y %H:%i')

    -- Format: 05-Dec-2022
    WHEN order_datetime LIKE '__-___-____'
    THEN STR_TO_DATE(order_datetime, '%d-%b-%Y')

    ELSE NULL

END;

SELECT
    order_datetime,
    clean_order_datetime
FROM cafe_orders_clean
LIMIT 30;

SELECT
    COUNT(*) AS total_rows,
    SUM(clean_order_datetime IS NULL) AS missing_or_invalid_dates
FROM cafe_orders_clean;

ALTER TABLE cafe_orders_clean
ADD COLUMN order_date DATE,
ADD COLUMN order_time TIME;

UPDATE cafe_orders_clean
SET
    order_date = DATE(clean_order_datetime),
    order_time = TIME(clean_order_datetime);
    
select * from cafe_orders_clean;

-- Customer_name cleaning
SELECT
    COUNT(*) AS total_rows,
    SUM(TRIM(customer_name) = '') AS blank_customer_names
FROM cafe_orders_clean;

UPDATE cafe_orders_clean
SET customer_name = NULL
WHERE TRIM(customer_name) = '';

UPDATE cafe_orders_clean
SET customer_name = LOWER(TRIM(customer_name))
WHERE customer_name IS NOT NULL;

SELECT customer_name, COUNT(*) AS total
FROM cafe_orders_clean
GROUP BY customer_name
ORDER BY total DESC
LIMIT 20;

SELECT
    SUM(customer_name IS NULL) AS missing_customer_names
FROM cafe_orders_clean;

-- Rating cleaning
SELECT
    rating,
    COUNT(*) AS total_rows
FROM cafe_orders_clean
GROUP BY rating
ORDER BY CAST(NULLIF(rating, '') AS DECIMAL(10,1));

UPDATE cafe_orders_clean
SET rating = NULL
WHERE TRIM(rating) = ''
   OR CAST(rating AS DECIMAL(3,1)) NOT BETWEEN 1 AND 5;
   
   SELECT
    rating,
    COUNT(*) AS total_rows
FROM cafe_orders_clean
GROUP BY rating
ORDER BY rating;

select * from cafe_orders_clean;

ALTER TABLE cafe_orders_clean
ADD COLUMN rating_status VARCHAR(20);

SELECT
    franchise_owner,
    COUNT(*) AS total_rows
FROM cafe_orders_clean
GROUP BY franchise_owner
ORDER BY total_rows DESC;


UPDATE cafe_orders_clean
SET rating_status =
CASE
    WHEN rating IS NULL THEN 'Invalid/Missing'
    ELSE 'Valid'
END;

SELECT
    franchise_owner,
    COUNT(*) AS total_rows
FROM cafe_orders_clean
GROUP BY franchise_owner;

UPDATE cafe_orders_clean
SET franchise_owner = 'Ajey Shah'
WHERE franchise_owner IS NOT NULL
  AND TRIM(franchise_owner) <> '';
  
UPDATE cafe_orders_clean
SET franchise_owner = NULL
WHERE TRIM(franchise_owner) = '';

SELECT
    franchise_owner,
    COUNT(*) AS total_rows
FROM cafe_orders_clean
GROUP BY franchise_owner;

select * from cafe_orders_clean;

-- EDA - TASK 8 — Calculate Total Revenue for Each Outlet (City-wise)
SELECT
    outlet_name,
    city,
    SUM(CAST(quantity AS DECIMAL(10,2)) * CAST(price AS DECIMAL(10,2))) AS total_revenue
FROM cafe_orders_clean
WHERE quantity IS NOT NULL
  AND price IS NOT NULL
GROUP BY outlet_name, city
ORDER BY total_revenue DESC;

UPDATE cafe_orders_clean
SET city =
CASE
    WHEN outlet_name = 'Ajey''s Cafe - Ahmedabad' THEN 'Ahmedabad'
    WHEN outlet_name = 'Ajey''s Cafe - Bengaluru' THEN 'Bengaluru'
    WHEN outlet_name = 'Ajey''s Cafe - Delhi' THEN 'Delhi'
    WHEN outlet_name = 'Ajey''s Cafe - Mumbai' THEN 'Mumbai'
    WHEN outlet_name = 'Ajey''s Cafe - Pune' THEN 'Pune'
    WHEN outlet_name = 'Ajey''s Cafe - Rajkot' THEN 'Rajkot'
    WHEN outlet_name = 'Ajey''s Cafe - Surat' THEN 'Surat'
    WHEN outlet_name = 'Ajey''s Cafe - Vadodara' THEN 'Vadodara'
    ELSE city
END;

SELECT
    outlet_name,
    city,
    COUNT(*) AS total_rows
FROM cafe_orders_clean
GROUP BY outlet_name, city
ORDER BY outlet_name;

-- total_revenue task 8 
SELECT
    outlet_name,
    city,
    ROUND(
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ), 2
    ) AS total_revenue
FROM cafe_orders_clean
WHERE quantity IS NOT NULL
  AND price IS NOT NULL
GROUP BY outlet_name, city
ORDER BY total_revenue DESC;

select * from cafe_orders_clean;

-- Task=9 Highest selling product
SELECT
    item_name,
    SUM(CAST(quantity AS DECIMAL(10,2))) AS total_quantity_sold
FROM cafe_orders_clean
WHERE quantity IS NOT NULL
GROUP BY item_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- Every city's highest selling product

WITH item_sales AS (
    SELECT
        outlet_name,
        item_name,
        SUM(CAST(quantity AS DECIMAL(10,2))) AS total_quantity_sold
    FROM cafe_orders_clean
    WHERE quantity IS NOT NULL
    GROUP BY outlet_name, item_name
),

ranked_items AS (
    SELECT
        outlet_name,
        item_name,
        total_quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY outlet_name
            ORDER BY total_quantity_sold DESC
        ) AS item_rank
    FROM item_sales
)

SELECT
    outlet_name,
    item_name AS best_selling_item,
    total_quantity_sold
FROM ranked_items
WHERE item_rank = 1
ORDER BY outlet_name;

--  Task 10 — Month-wise / Year-wise Sales Trend karte hain.

SELECT
    YEAR(order_date) AS sales_year,
    ROUND(
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ), 2
    ) AS total_sales
FROM cafe_orders_clean
WHERE order_date IS NOT NULL
  AND quantity IS NOT NULL
  AND price IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY sales_year;

-- Month wise total sales
SELECT
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS month_no,
    MONTHNAME(order_date) AS sales_month,
    ROUND(
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ), 2
    ) AS total_sales
FROM cafe_orders_clean
WHERE order_date IS NOT NULL
  AND quantity IS NOT NULL
  AND price IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY
    sales_year,
    month_no;


-- 11. Payment mode ka distribution (UPI vs Cash vs Card) nikaalo

SELECT
    payment_mode,
    COUNT(*) AS total_orders
FROM cafe_orders_clean
WHERE payment_mode IS NOT NULL
  AND TRIM(payment_mode) <> ''
GROUP BY payment_mode
ORDER BY total_orders DESC;

SELECT
    payment_mode,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM cafe_orders_clean
         WHERE payment_mode IS NOT NULL
           AND TRIM(payment_mode) <> ''),
        2
    ) AS percentage
FROM cafe_orders_clean
WHERE payment_mode IS NOT NULL
  AND TRIM(payment_mode) <> ''
GROUP BY payment_mode
ORDER BY total_orders DESC;

UPDATE cafe_orders_clean
SET payment_mode =
CASE
    WHEN LOWER(TRIM(payment_mode)) = 'upi' THEN 'UPI'
    WHEN LOWER(TRIM(payment_mode)) = 'cash' THEN 'Cash'

    WHEN LOWER(TRIM(payment_mode)) IN
         ('card', 'credit card', 'debit card')
    THEN 'Card'

    WHEN LOWER(TRIM(payment_mode)) = 'netbanking'
    THEN 'Net Banking'

    ELSE payment_mode
END;

SELECT
    payment_mode,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM cafe_orders_clean
         WHERE payment_mode IS NOT NULL
           AND TRIM(payment_mode) <> ''),
        2
    ) AS percentage
FROM cafe_orders_clean
WHERE payment_mode IS NOT NULL
  AND TRIM(payment_mode) <> ''
GROUP BY payment_mode
ORDER BY total_orders DESC;


-- TASK 12 — Calculate Average Order Value (AOV) per Outlet
SELECT
    outlet_name,

    ROUND(
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ), 2
    ) AS total_revenue,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value

FROM cafe_orders_clean
WHERE quantity IS NOT NULL
  AND price IS NOT NULL

GROUP BY outlet_name
ORDER BY average_order_value DESC;

-- TASK 13 — Check Correlation Between Rating and Sales
SELECT
    CAST(rating AS DECIMAL(3,1)) AS rating,
    COUNT(*) AS total_records,
    ROUND(
        AVG(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ), 2
    ) AS average_sales,
    ROUND(
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ), 2
    ) AS total_sales
FROM cafe_orders_clean
WHERE rating IS NOT NULL
  AND quantity IS NOT NULL
  AND price IS NOT NULL
GROUP BY CAST(rating AS DECIMAL(3,1))
ORDER BY rating;

SELECT
    ROUND(
        (
            COUNT(*) * SUM(rating_num * sales)
            - SUM(rating_num) * SUM(sales)
        )
        /
        SQRT(
            (
                COUNT(*) * SUM(rating_num * rating_num)
                - POWER(SUM(rating_num), 2)
            )
            *
            (
                COUNT(*) * SUM(sales * sales)
                - POWER(SUM(sales), 2)
            )
        ),
        4
    ) AS correlation
FROM
(
    SELECT
        CAST(rating AS DECIMAL(10,2)) AS rating_num,
        CAST(quantity AS DECIMAL(10,2))
        * CAST(price AS DECIMAL(10,2)) AS sales
    FROM cafe_orders_clean
    WHERE rating IS NOT NULL
      AND quantity IS NOT NULL
      AND price IS NOT NULL
) AS x;
-- The correlation coefficient between rating and sales is -0.0028, indicating almost no linear relationship between customer ratings and sales.
use  ajeyscafes; 

-- TASK 14 — Kaunsa outlet sabse zyada growing hai Year-over-Year?
WITH yearly_sales AS (
    SELECT
        outlet_name,
        YEAR(order_date) AS sales_year,
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ) AS total_revenue
    FROM cafe_orders_clean
    WHERE order_date IS NOT NULL
      AND quantity IS NOT NULL
      AND price IS NOT NULL
    GROUP BY
        outlet_name,
        YEAR(order_date)
),

previous_year_sales AS (
    SELECT
        outlet_name,
        sales_year,
        total_revenue,

        LAG(total_revenue) OVER (
            PARTITION BY outlet_name
            ORDER BY sales_year
        ) AS previous_year_revenue

    FROM yearly_sales
)

SELECT
    outlet_name,
    sales_year,
    ROUND(total_revenue, 2) AS current_year_revenue,
    ROUND(previous_year_revenue, 2) AS previous_year_revenue,

    ROUND(
        ((total_revenue - previous_year_revenue)
        / previous_year_revenue) * 100,
        2
    ) AS yoy_growth_percentage

FROM previous_year_sales
ORDER BY outlet_name, sales_year;

-- Ajey's Cafe - Bengaluru recorded the highest YoY revenue growth in 2025 at 3.19%, increasing from ₹3.47M in 2024 to ₹3.58M in 2025.

-- TASK 15 — Weekday vs Weekend Sales Pattern
WITH daily_sales AS (
    SELECT
        order_date,

        CASE
            WHEN DAYOFWEEK(order_date) IN (1, 7)
                THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type,

        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ) AS daily_revenue

    FROM cafe_orders_clean

    WHERE order_date IS NOT NULL
      AND quantity IS NOT NULL
      AND price IS NOT NULL

    GROUP BY order_date
)

SELECT
    day_type,
    COUNT(*) AS total_days,
    ROUND(AVG(daily_revenue), 2) AS avg_daily_sales

FROM daily_sales

GROUP BY day_type
ORDER BY avg_daily_sales DESC;

-- Weekend average daily sales are slightly higher than weekday sales, but the difference is very small. This indicates that sales remain relatively stable throughout the week.

-- TASK 16 — Low-Rated but High-Selling Items
SELECT
    item_name AS Item,

    CAST(
        SUM(CAST(quantity AS DECIMAL(10,2)))
        AS UNSIGNED
    ) AS Quantity_Sold,

    ROUND(
        AVG(CAST(rating AS DECIMAL(3,1))),
        2
    ) AS Average_Rating

FROM cafe_orders_clean

WHERE quantity IS NOT NULL
  AND rating IS NOT NULL

GROUP BY item_name
ORDER BY Quantity_Sold DESC;

-- Burger is a high-selling but relatively low-rated item, making it a key candidate for improvement.

-- TASK 17 — Customer Repeat-Purchase Pattern
SELECT
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM cafe_orders_clean
WHERE customer_name IS NOT NULL
  AND TRIM(customer_name) <> ''
GROUP BY customer_name
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC;

SELECT
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN total_orders > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage

FROM (
    SELECT
        customer_name,
        COUNT(DISTINCT order_id) AS total_orders
    FROM cafe_orders_clean
    WHERE customer_name IS NOT NULL
    GROUP BY customer_name
) AS customer_orders;

-- All 11 identified customers are repeat customers. Ravi Patel is the most frequent repeat customer with 70,563 orders.

-- Task 18 — Rank Each Outlet by Revenue using Window Function
WITH outlet_revenue AS (
    SELECT
        outlet_name,
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ) AS total_revenue
    FROM cafe_orders_clean
    WHERE quantity IS NOT NULL
      AND price IS NOT NULL
    GROUP BY outlet_name
)

SELECT
    outlet_name,
    ROUND(total_revenue, 2) AS total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM outlet_revenue
ORDER BY revenue_rank;

-- Surat outlet ranks 1st in revenue with ₹15.92M, followed by Delhi and Ahmedabad. Pune has the lowest revenue among the 8 outlets.

-- Task 19 — Month-over-Month (MoM) Growth % using LAG()
WITH monthly_sales AS (
    SELECT
        YEAR(order_date) AS sales_year,
        MONTH(order_date) AS sales_month,
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ) AS monthly_revenue
    FROM cafe_orders_clean
    WHERE order_date IS NOT NULL
      AND quantity IS NOT NULL
      AND price IS NOT NULL
    GROUP BY YEAR(order_date), MONTH(order_date)
),

previous_month AS (
    SELECT
        sales_year,
        sales_month,
        monthly_revenue,

        LAG(monthly_revenue) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_month_revenue

    FROM monthly_sales
)

SELECT
    sales_year,

    CASE sales_month
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS month_name,

    ROUND(monthly_revenue, 2) AS current_month_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,

    ROUND(
        ((monthly_revenue - previous_month_revenue)
        / previous_month_revenue) * 100,
        2
    ) AS mom_growth_percentage

FROM previous_month
ORDER BY sales_year, sales_month;

-- Monthly sales fluctuate throughout the period. The highest MoM growth was 11.05% in March 2025, while the largest decline was -11.96% in February 2025.

-- Task 20 — Outlets Whose Revenue is Below Average
WITH outlet_revenue AS (
    SELECT
        outlet_name,
        SUM(
            CAST(quantity AS DECIMAL(10,2)) *
            CAST(price AS DECIMAL(10,2))
        ) AS total_revenue
    FROM cafe_orders_clean
    WHERE quantity IS NOT NULL
      AND price IS NOT NULL
    GROUP BY outlet_name
)

SELECT
    outlet_name,
    ROUND(total_revenue, 2) AS total_revenue
FROM outlet_revenue
WHERE total_revenue < (
    SELECT AVG(total_revenue)
    FROM outlet_revenue
)
ORDER BY total_revenue DESC;

-- Rajkot, Bengaluru, and Pune have total revenue below the average revenue of all outlets.

-- Task 21 — Find Repeat Customers using EXISTS
SELECT DISTINCT
    c1.customer_name AS repeated_customers
FROM cafe_orders_clean c1
WHERE c1.customer_name IS NOT NULL

AND EXISTS (
    SELECT 1
    FROM cafe_orders_clean c2
    WHERE c2.customer_name = c1.customer_name
      AND c2.order_id <> c1.order_id
)

ORDER BY repeated_customers;

-- All 11 identified customers have placed multiple orders and are repeat customers.

-- Task 22 — Monthly Report for Any Outlet
DELIMITER //

CREATE PROCEDURE GetMonthlyOutletReport(
    IN p_outlet_name VARCHAR(100)
)
BEGIN

    SELECT
        YEAR(order_date) AS sales_year,
        MONTH(order_date) AS month_no,
        MONTHNAME(order_date) AS sales_month,

        COUNT(DISTINCT order_id) AS total_orders,

        ROUND(
            SUM(
                CAST(quantity AS DECIMAL(10,2)) *
                CAST(price AS DECIMAL(10,2))
            ),
            2
        ) AS total_revenue

    FROM cafe_orders_clean

    WHERE outlet_name = p_outlet_name
      AND order_date IS NOT NULL
      AND quantity IS NOT NULL
      AND price IS NOT NULL

    GROUP BY
        YEAR(order_date),
        MONTH(order_date),
        MONTHNAME(order_date)

    ORDER BY
        sales_year,
        month_no;

END //

DELIMITER ;

CALL GetMonthlyOutletReport('Ajey''s Cafe - Surat');

-- The stored procedure successfully generates a monthly sales report for any selected outlet, showing year, month, total orders, and total revenue.