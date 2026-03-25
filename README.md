# PIZZA SALES Project using SQL

## Project Overview

**Project Title**: Pizza Sales  
**Database**: `Pizza_Store`

**Tools Used
SQL (MySQL)
GitHub**

The objective of this project is to analyze pizza sales data using SQL to understand overall sales performance and revenue trends. The analysis aims to identify the most popular and least popular pizzas, examine sales distribution across different pizza categories and sizes, and determine peak ordering times. Also, the project focuses on analyzing daily and monthly sales trends and generating useful business insights that can help improve sales strategies and decision-making.

## Objectives

1. **Set up the Pizza Sales Database**: Create and populate the database with tables for pizza_types, pizzas, orders,    order_details.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup

- **Database Creation**: Created a database named `Pizza_store`.
- **Table Creation**: Created tables for pizza_types, pizzas, orders,order_details. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE pizza_store;
USE pizza_store;

-- CREATING TABLES
-- Create table "pizza_types"
DROP TABLE IF EXISTS pizza_types;
CREATE TABLE pizza_types (
	          pizza_type_id  varchar(50) PRIMARY KEY,
	          name	   varchar(50),
              category	   varchar(30),
              ingredients    varchar(350)
);


-- Create table "Pizzas"
DROP TABLE IF EXISTS pizzas;
CREATE TABLE pizzas (
	        pizza_id        varchar(100) PRIMARY KEY,
	        pizza_type_id   varchar(50),
            size	    varchar(10),
            price           float,
            FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);


-- Create table "Orders"
DROP TABLE IF EXISTS ORDERS;
CREATE TABLE orders (
           order_id INT      PRIMARY KEY,
           order_date        DATE,
           order_time        TIME
);


-- Create table "ORDER_DETAILS"
DROP TABLE IF EXISTS ORDER_DETAILS;
CREATE TABLE ORDER_DETAILS (
           order_details_id  int PRIMARY KEY,
           order_id          INT, 
           pizza_id	     VARCHAR(100),
           quantity          INT
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `pizzas` table.
- **Read**:   Retrieved and displayed data from various tables.
- **Update**: Updated records in the `orders` table.
- **Delete**: Removed records from the `pizza_types` table as needed.

**Task 1. Retrieve the total number of orders placed.**

```sql
SELECT COUNT(order_id) 
FROM orders;
```
**Task 2: Calculate the total revenue generated from pizza sales.**

```sql
SELECT 
ROUND( 
SUM(od.quantity * p.price), 3) as revenue
FROM order_details as od 
JOIN pizzas as p 
ON od.pizza_id = p.pizza_id;

```

**Task 3: Identify the highest-priced pizza.**

```sql
SELECT * FROM pizzas 
ORDER BY price DESC
LIMIT 1;

```

**Task 4: Identify the most common pizza size ordered**

```sql
SELECT size, COUNT(order_details_id) 
FROM pizzas as p
JOIN order_details as od
ON p.pizza_id = od.pizza_id
GROUP BY SIZE;

```

**Task 5: List the top 5 most ordered pizza types along with their quantities.**

```sql
SELECT pt.name , p.pizza_type_id, SUM(quantity) 
FROM pizza_types as pt
JOIN pizzas as p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details as od
ON p.pizza_id = od.pizza_id 
GROUP BY pt.name, p.pizza_type_id
ORDER BY SUM(quantity) DESC
LIMIT 5;
```

**Task 6: Join the necessary tables to find the total quantity of each pizza category ordered.**

```sql
SELECT pt.category, sum(quantity) as total_quantity_ordered
FROM pizza_types as pt
JOIN pizzas as p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details as od
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY 2 DESC;
```

**Task 7: Determine the distribution of orders by hour of the day.**:

```sql
SELECT DISTINCT hour(order_time) as hours, count(order_id) 
FROM orders
GROUP BY hours
ORDER BY hours;
```

 **Task 8: Join relevant tables to find the category-wise distribution of pizzas.**:

```sql
SELECT category , COUNT(name)
 FROM pizza_types
GROUP BY category;
```

**Task 9: Group the orders by date and calculate the average number of pizzas ordered per day.**:
   
```sql
SELECT 
ROUND(
avg(orders_per_day),0) as avg_orders FROM
(SELECT  order_date , sum(quantity) as orders_per_day
FROM orders as o
JOIN order_details as od
ON o.order_id = od.order_id
GROUP BY order_date) as order_quantity;
```

**Task 10: Determine the top 3 most ordered pizza types based on revenue**:

```sql
SELECT name , SUM(od.quantity * p.price) as revenue
FROM pizza_types as pt
JOIN pizzas as p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details as od
ON p.pizza_id = od.pizza_id
GROUP BY name 
ORDER BY  revenue DESC
LIMIT 3;
```

 **Task 11: Calculate the percentage contribution of each pizza type to total revenue**:

```sql
SELECT category , 
ROUND(
sum(od.quantity * p.price)  /(SELECT 
ROUND( 
SUM(od.quantity * p.price), 3)
FROM order_details as od 
JOIN pizzas as p 
ON od.pizza_id = p.pizza_id) * 100 , 2) as percentage
FROM  pizza_types as pt 
JOIN pizzas as p 
ON pt.pizza_type_id = p.pizza_type_id 
JOIN order_details as od 
ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY percentage DESC;

```

 **Task 12: Analyze the cumulative revenue generated over time.**

```sql
SELECT order_date , 
sum(revenue) over(order by order_date) as cum_revenue
FROM
(SELECT order_date , sum(quantity * price) as revenue 
FROM order_details as od 
JOIN pizzas as p 
ON od.pizza_id = p.pizza_id 
JOIN orders as o
ON o.order_id = od.order_id
GROUP BY order_date) as sales;
```

**Task 13: Determine the top 3 most ordered pizza types based on revenue for each pizza category.**  

```sql
SELECT category ,name, sum(quantity * price) as revenue 
FROM pizza_types as pt
JOIN pizzas as p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details as od 
ON od.pizza_id = p.pizza_id
GROUP BY category , name 
ORDER BY revenue DESC
LIMIT 3;

```

## Key Insights
-  Large-sized pizzas contributed the most to total revenue.
-  Sales are higher during evening hours
-  Classic category pizzas generated the highest number of orders

  
## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into pizza categories, pizza sales, orders, and revenue.
- **Summary Reports**: Aggregated data on high-demand pizzas and revenue generated.

## Conclusion

This project analyzed pizza sales data using SQL to gain meaningful insights into sales performance and customer preferences. The analysis helped identify the most popular pizza types, revenue contribution by different categories and sizes, and peak ordering periods. These insights can help businesses make better decisions related to menu planning, inventory management, and sales strategies to improve overall business performance.

