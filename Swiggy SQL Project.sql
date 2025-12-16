###########################################################
create database Swiggy_Database;
use Swiggy_Database;
###########################################################

###########################################################
-- Converting Column Names into snake_case
###########################################################

ALTER TABLE swiggy
RENAME COLUMN `State` TO state,
RENAME COLUMN `City` TO city,
RENAME COLUMN `Order Date` TO order_date,
RENAME COLUMN `Restaurant Name` TO restaurant_name,
RENAME COLUMN `Location` TO location,
RENAME COLUMN `Category` TO category,
RENAME COLUMN `Dish Name` TO dish_name,
RENAME COLUMN `Price (INR)` TO price_inr,
RENAME COLUMN `Rating` TO rating,
RENAME COLUMN `Rating Count` TO rating_count;

describe swiggy;

###########################################################
-- Data Cleaning 
-- check for NULL Values in Each Column 
###########################################################

select
sum(case when state is null then 1 else 0 end) as null_state,
sum(case when city is null then 1 else 0 end) as null_city,
sum(case when order_date is null then 1 else 0 end) as null_order_date,
sum(case when Restaurant_Name is null then 1 else 0 end) as null_restaurant,
sum(case when Location is null then 1 else 0 end) as null_location,
sum(case when Category is null then 1 else 0 end) as null_category,
sum(case when Dish_Name is null then 1 else 0 end) as null_dish,
sum(case when Price_INR is null then 1 else 0 end) as null_price,
sum(case when Rating is null then 1 else 0 end) as null_rating,
sum(case when Rating_Count is null then 1 else 0 end) as null_rating_count
from swiggy;

###########################################################
-- Blank or Empty Strings
###########################################################

select *
from swiggy
where 
state = " " or 
city = " " or 
restaurant_name = " " or 
location = " " or 
category = " " or
dish_name = " " ;

###########################################################
-- Duplicate Detection 
###########################################################

select 
state, city, order_date, restaurant_name, location, category,
dish_name, price_inr, rating, rating_count, count(*) as cnt
from swiggy
group by 
state, city, order_date, restaurant_name, location, category,
dish_name, price_inr, rating, rating_count
having count(*) > 1;

###########################################################
-- Delete duplicate records using AI-assisted logic.
-- This operation is executed via JupyterLab due to the large dataset size.
###########################################################

-- code for JupyterLab


-- ------------------------------------------------------------------
-- pip install pymysql sqlalchemy pandas
-- ------------------------------------------------------------------
-- from sqlalchemy import create_engine, text

-- engine = create_engine(
--     "mysql+pymysql://root:12345@localhost:3306/Swiggy_Database",
--     pool_pre_ping=True
-- )
-- ------------------------------------------------------------------
-- preview_query = """
-- WITH cte AS (
--     SELECT *,
--            ROW_NUMBER() OVER (
--                PARTITION BY
--                    state, city, order_date, restaurant_name, location,
--                    category, dish_name, price_inr, rating, rating_count
--                ORDER BY order_date
--            ) AS rn
--     FROM swiggy
-- )
-- SELECT *
-- FROM cte
-- WHERE rn > 1
-- LIMIT 10;
-- """
-- ------------------------------------------------------------------
-- import pandas as pd

-- df_dup = pd.read_sql(preview_query, engine)
-- df_dup
-- ------------------------------------------------------------------

-- create_temp_table = """
-- CREATE TEMPORARY TABLE swiggy_duplicates AS
-- SELECT
--     state, city, order_date, restaurant_name, location,
--     category, dish_name, price_inr, rating, rating_count
-- FROM (
--     SELECT *,
--            ROW_NUMBER() OVER (
--                PARTITION BY
--                    state, city, order_date, restaurant_name, location,
--                    category, dish_name, price_inr, rating, rating_count
--                ORDER BY order_date
--            ) AS rn
--     FROM swiggy
-- ) t
-- WHERE rn > 1;
-- """
-- ------------------------------------------------------------------
-- delete_query = """
-- DELETE s
-- FROM swiggy s
-- JOIN swiggy_duplicates d
--   ON s.state = d.state
--  AND s.city = d.city
--  AND s.order_date = d.order_date
--  AND s.restaurant_name = d.restaurant_name
--  AND s.location = d.location
--  AND s.category = d.category
--  AND s.dish_name = d.dish_name
--  AND s.price_inr = d.price_inr
--  AND s.rating = d.rating
--  AND s.rating_count = d.rating_count;
-- """
-- ------------------------------------------------------------------
-- with engine.begin() as conn:
--     conn.execute(text(create_temp_table))
--     result = conn.execute(text(delete_query))
--     print(f"Deleted rows: {result.rowcount}")
--     ------------------------------------------------------------------
-- verify_query = """
-- WITH cte AS (
--     SELECT *,
--            ROW_NUMBER() OVER (
--                PARTITION BY
--                    state, city, order_date, restaurant_name, location,
--                    category, dish_name, price_inr, rating, rating_count
--                ORDER BY order_date
--            ) AS rn
--     FROM swiggy
-- )
-- SELECT COUNT(*) AS remaining_duplicates
-- FROM cte
-- WHERE rn > 1;
-- """

-- pd.read_sql(verify_query, engine)
------------------------------------------------------------------

###########################################################
-- Creating schema 
-- Dimension tables
###########################################################

-- dim_date
CREATE TABLE dim_date(
    date_id INT AUTO_INCREMENT PRIMARY KEY,
    full_date DATE,
    year INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    day INT,
    week INT
);


-- dim_location
CREATE TABLE dim_location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    state varchar(100),
    city varchar(100),
    location varchar(200)
);


-- dim restaurant
CREATE TABLE dim_restaurant (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name varchar(200)
);


-- dim category
create table dim_category(
	category_id int auto_increment primary key,
    category varchar(200)
);


-- dim dish
create table dim_dish(
	dish_id int auto_increment primary key,
    dish varchar(200)
);


-- fact table 
-- CREATE FACT TABLE

CREATE TABLE fact_swiggy_orders (
    order_id INT auto_increment PRIMARY KEY,

    date_id INT,
    Price_INR DECIMAL(10,2),
    Rating DECIMAL(4,2),
    Rating_Count INT,

    location_id INT,
    restaurant_id INT,
    category_id INT,
    dish_id INT,

    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (location_id) REFERENCES dim_location(location_id),
    FOREIGN KEY (restaurant_id) REFERENCES dim_restaurant(restaurant_id),
    FOREIGN KEY (category_id) REFERENCES dim_category(category_id),
    FOREIGN KEY (dish_id) REFERENCES dim_dish(dish_id)
);

select * from fact_swiggy_orders;

###########################################################
-- insert data in all tables
###########################################################

-- dim_date

INSERT INTO dim_date (
    full_date,
    `year`,
    `month`,
    month_name,
    quarter,
    `day`,
    `week`
)
SELECT DISTINCT
    order_date AS full_date,
    YEAR(order_date) AS `year`,
    MONTH(order_date) AS `month`,
    MONTHNAME(order_date) AS month_name,
    QUARTER(order_date) AS quarter,
    DAY(order_date) AS `day`,
    WEEK(order_date) AS `week`
FROM swiggy
WHERE order_date IS NOT NULL;

SELECT * FROM dim_date;

-- dim_location

insert into dim_location(state, city, location)
select distinct
	state,
    city,
    location
from swiggy;

-- dim_restaurant
insert into dim_restaurant(restaurant_name)
select distinct
	restaurant_name
from swiggy;

-- dim_category
insert into dim_category(category)
select distinct
	category
from swiggy;

-- dim_dish
insert into dim_dish(dish)
select distinct 
	dish_name
from swiggy;

select * from dim_dish;

###########################################################
-- insert data into fact table
########################################################### 

-- INSERT INTO FACT TABLE

INSERT INTO fact_swiggy_orders (
    date_id,
    Price_INR,
    Rating,
    Rating_Count,
    location_id,
    restaurant_id,
    category_id,
    dish_id
)
SELECT
    dd.date_id,
    s.Price_INR,
    s.Rating,
    s.Rating_Count,
    dl.location_id,
    dr.restaurant_id,
    dc.category_id,
    dsh.dish_id
FROM swiggy s

JOIN dim_date dd
    ON dd.Full_Date = s.Order_Date

JOIN dim_location dl
    ON dl.State = s.State
   AND dl.City = s.City
   AND dl.Location = s.Location

JOIN dim_restaurant dr
    ON dr.Restaurant_Name = s.Restaurant_Name

JOIN dim_category dc
    ON dc.category = s.category

JOIN dim_dish dsh
    ON dsh.dish = s.dish_name;
    

select count(*) from fact_swiggy_orders;

select * from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
join dim_location l on f.location_id = l.location_id
join dim_restaurant r on f.restaurant_id = r.restaurant_id
join dim_category c on f.category_id = c.category_id
join dim_dish di on f.dish_id = di.dish_id; 

###########################################################
-- KPI's
###########################################################

-- Total Orders
select count(*) as total_orders
from fact_swiggy_orders;

-- Total Revenue (INR Million)

SELECT 
    ROUND(SUM(Price_INR) / 1000000, 2) AS total_revenue_mn_inr
FROM
    fact_swiggy_orders;
    
 -- Average Dish Price
 
SELECT 
    ROUND(AVG(price_inr), 2) AS Avg_Dish_Price
FROM
    fact_swiggy_orders;
    
-- Average Rating

SELECT 
    ROUND(AVG(Rating), 1) AS avg_rating
FROM
    fact_swiggy_orders;
    
###########################################################
-- Deep Dive Business Analysis
###########################################################    

------------------------------------
-- Monthly Order Trends
------------------------------------

select d.year, d.month, d.month_name, count(*) as total_orders
from fact_swiggy_orders f
join dim_date d
on f.date_id = d.date_id
group by d.year, d.month, d.month_name
order by d.month;
    
select d.year, d.month, d.month_name, sum(price_inr) as total_revenue
from fact_swiggy_orders f
join dim_date d
on f.date_id = d.date_id
group by d.year, d.month, d.month_name
order by d.month;

-- Quarterly Order Trends

select d.year,d.quarter, count(*) as Total_orders
from fact_swiggy_orders f
join dim_date d
on f.date_id = d.date_id
group by d.year,d.quarter
order by d.quarter;

-- Orders by Day of Week (Mon-Sun)

select dayofweek(d.full_date) as day_number,
dayname(d.full_date) as day_name,
count(*) as total_orders
from fact_swiggy_orders f
join dim_date d
on d.date_id = f.date_id
group by dayname(d.full_date),dayofweek(d.full_date)
order by dayofweek(d.full_date);

------------------------------------
-- Location-Based Analysis
------------------------------------

-- Top 10 Cities by Order Voulme

SELECT 
    l.city, 
    COUNT(*) AS total_order
FROM fact_swiggy_orders f
JOIN dim_location l
    ON l.location_id = f.location_id
GROUP BY l.city
ORDER BY count(*) DESC
LIMIT 10;

-- Top 10 Cities by total revenue

SELECT 
    l.city, 
    sum(Price_INR) AS total_order
FROM fact_swiggy_orders f
JOIN dim_location l
    ON l.location_id = f.location_id
GROUP BY l.city
ORDER BY sum(Price_INR) DESC
LIMIT 10;

-- Revenue Contribution by States

SELECT 
l.state, sum(price_inr) as total_revenue
from fact_swiggy_orders f 
join dim_location l 
on l.location_id = f.location_id
group by l.state
order by l.state;

------------------------------------
-- Food Performance
------------------------------------

-- Top 10 restaurants by orders

select r.restaurant_name, count(*) as total_orders
from fact_swiggy_orders f
join dim_restaurant r
on r.restaurant_id = f.restaurant_id
group by r.restaurant_name
order by count(*) desc
limit 10;

-- Top 10 restaurants by total revenue

select r.restaurant_name, sum(Price_INR) as total_revenue
from fact_swiggy_orders f
join dim_restaurant r
on r.restaurant_id = f.restaurant_id
group by r.restaurant_name
order by sum(Price_INR) desc
limit 10;

-- Top Categories (Indian, Chinese, etc) by Order Volume

select c.category, count(*) as total_orders
from fact_swiggy_orders f
join dim_category c
on c.category_id = f.category_id
group by c.category
order by count(*) desc
limit 10;

-- Most Ordered Dishes

select d.dish, count(*) as total_orders
from fact_swiggy_orders f
join dim_dish d
on d.dish_id = f.dish_id
group by d.dish
order by count(*) desc
limit 5; 

-- Cuisine Performance (Orders + Avg Rating)

select c.category, count(*) as total_orders,
round(avg(f.rating),1) as avg_rating
from fact_swiggy_orders f
join dim_category c
on f.category_id = c.category_id
group by c.category
order by total_orders desc, round(avg(f.rating),1);

------------------------------------
-- Customer Spending Insights
------------------------------------

select
	case
		when price_inr < 100 then "under 100"
        when price_inr between 100 and 199 then "100 - 199"
        when price_inr between 200 and 299 then "200 - 299"
        when price_inr between 300 and 399 then "300 - 399"
        when price_inr between 400 and 499 then "400 - 499"
        else "500+"
	end as price_range,
    count(*) as total_orders
from fact_swiggy_orders
group by
	case
		when price_inr < 100 then "under 100"
        when price_inr between 100 and 199 then "100 - 199"
        when price_inr between 200 and 299 then "200 - 299"
        when price_inr between 300 and 399 then "300 - 399"
        when price_inr between 400 and 499 then "400 - 499"
        else "500+"
	end 
order by count(*) desc;
	
------------------------------------
-- Rating Count Distribution (1-5)
------------------------------------

select rating, count(*) as rating_count
from fact_swiggy_orders f
group by rating
order by count(*) desc;



















