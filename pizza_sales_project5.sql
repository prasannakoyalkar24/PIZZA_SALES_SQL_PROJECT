CREATE DATABASE pizza_store;
USE pizza_store;

-- CREATING TABLES
DROP TABLE IF EXISTS pizza_types;
CREATE TABLE pizza_types (
	pizza_type_id  varchar(50) PRIMARY KEY,
	name	       varchar(50),
    category	   varchar(30),
    ingredients    varchar(350)
);

DROP TABLE IF EXISTS pizzas;
CREATE TABLE pizzas (
	pizza_id        varchar(100) PRIMARY KEY,
	pizza_type_id   varchar(50),
	size	        varchar(10),
    price           float,
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);

DROP TABLE IF EXISTS ORDERS;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    order_time TIME
);

DROP TABLE IF EXISTS ORDER_DETAILS;
CREATE TABLE ORDER_DETAILS (
		order_details_id  int PRIMARY KEY,
		order_id          INT, 
		pizza_id	      VARCHAR(100),
		quantity          INT
);

ALTER TABLE order_details
ADD CONSTRAINT fk_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_pizzas
FOREIGN KEY (pizza_id)
REFERENCES pizzas(pizza_id);

SELECT * FROM pizza_types;
SELECT * FROM pizzas;
SELECT * FROM orders;
SELECT * FROM ORDER_DETAILS;

-- PROBLEMS 
-- Q1.Retrieve the total number of orders placed.
SELECT COUNT(order_id) 
FROM orders;

-- Q2.Calculate the total revenue generated from pizza sales.
SELECT 
ROUND( 
SUM(od.quantity * p.price), 3) as revenue
FROM order_details as od 
JOIN pizzas as p 
ON od.pizza_id = p.pizza_id;

-- Q3. Identify the highest-priced pizza.
SELECT * FROM pizzas 
ORDER BY price DESC
LIMIT 1;

-- Q4.Identify the most common pizza size ordered.
SELECT size, COUNT(order_details_id) 
FROM pizzas as p
JOIN order_details as od
ON p.pizza_id = od.pizza_id
GROUP BY SIZE
;

-- Q5.List the top 5 most ordered pizza types along with their quantities.
SELECT pt.name , p.pizza_type_id, SUM(quantity) 
FROM pizza_types as pt
JOIN pizzas as p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details as od
ON p.pizza_id = od.pizza_id 
GROUP BY pt.name, p.pizza_type_id
ORDER BY SUM(quantity) DESC
LIMIT 5;

-- Q6.Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category, sum(quantity) as total_quantity_ordered
FROM pizza_types as pt
JOIN pizzas as p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details as od
ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY 2 DESC;

-- Q7.Determine the distribution of orders by hour of the day.
SELECT DISTINCT hour(order_time) as hours, count(order_id) 
FROM orders
GROUP BY hours
ORDER BY hours;

-- Q8.Join relevant tables to find the category-wise distribution of pizzas.
SELECT category , COUNT(name)
 FROM pizza_types
GROUP BY category;

-- Q9.Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
ROUND(
avg(orders_per_day),0) as avg_orders FROM
(SELECT  order_date , sum(quantity) as orders_per_day
FROM orders as o
JOIN order_details as od
ON o.order_id = od.order_id
GROUP BY order_date) as order_quantity;

-- Q10.Determine the top 3 most ordered pizza types based on revenue.
SELECT name , SUM(od.quantity * p.price) as revenue
FROM pizza_types as pt
JOIN pizzas as p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details as od
ON p.pizza_id = od.pizza_id
GROUP BY name 
ORDER BY  revenue DESC
LIMIT 3;

-- Q11.Calculate the percentage contribution of each pizza type to total revenue.
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

-- Q12.Analyze the cumulative revenue generated over time.
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

-- Q13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT category ,name, sum(quantity * price) as revenue 
FROM pizza_types as pt
JOIN pizzas as p
ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details as od 
ON od.pizza_id = p.pizza_id
GROUP BY category , name 
ORDER BY revenue DESC
LIMIT 3;











    
