-- Create the database
create database pizza_projects;

-- Select the pizza_projects database to work on
use pizza_projects;

-- Create the table orders and assign the data type
create table orders (
order_id int not null,
order_Date datetime not null,
order_time time not null,
primary key (order_id)
);

-- Create the table order_details and assign the data type
create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int);

-- The Tables 
select * from pizza_types;
select * from pizzas;
select * from orders;
select * from order_details;


-- Questions 1:
-- Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id)
FROM
    orders;

------------------------------------------------------------------ 
-- Questions 2:
-- Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(p.price * od.quantity)) AS total_revenue
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id; 
    
------------------------------------------------------------------ 
-- Questions 3:
-- Identify the highest-priced pizza.
SELECT 
    p.pizza_type_id, p.price
FROM
    pizzas p
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

------------------------------------------------------------------ 
-- Questions 4:
-- Identify the most common pizza size ordered.
SELECT 
    p.size AS pizza_size, COUNT(p.size) AS count
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY COUNT(p.size) DESC
LIMIT 1;

------------------------------------------------------------------ 
-- Questions 5:
-- List the top 5 most ordered pizza types along with their quantities
SELECT 
    pt.name, 
    SUM(od.quantity) AS quantity
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY quantity DESC
LIMIT 5;

------------------------------------------------------------------ 
-- Questions 6:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, 
    SUM(od.quantity) AS quantity
FROM
    pizzas p
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY quantity DESC;

------------------------------------------------------------------ 
-- Questions 7:
-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) as Hours, COUNT(order_id) as orders_counts
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY orders_counts DESC;
-- another solution >>>>>>>
SELECT 
    COUNT(order_id) AS counts,
    CASE
        WHEN order_time < '16:00:0' THEN 'Day'
        WHEN order_time > '16:00:00' THEN 'Night'
    END day_night
FROM
    orders
GROUP BY day_night;

------------------------------------------------------------------
-- Questions 8:
-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT
  pt.category,
  count(p.pizza_id) as counts
from
  pizza_types pt
  JOIN pizzas p on pt.pizza_type_id = p.pizza_type_id
  JOIN order_details od on od.pizza_id = P.pizza_id
GROUP BY
  category
ORDER BY
  counts DESC

------------------------------------------------------------------
-- Questions 9:
-- Group the orders by date and calculate the average number of pizzas ordered per day.

select
  round(avg(x.counts)) as 'avarage pizza ordered per day'
from
(
    select
      order_Date,
      count(order_id) as counts
    from
      orders
    Group by
      order_Date
  ) x
-- Answer 9:
59.6
------------------------------------------------------------------
-- Questions 10:
-- Determine the top 3 most ordered pizza types based on revenue

select
  sum(x.revenue) as revenues,
  x.name
from
  (
    select
      pt.name,
      (p.price * od.quantity) as revenue
    from
      order_details od
      join pizzas p on od.pizza_id = p.pizza_id
      join pizza_types pt on pt.pizza_type_id = P.pizza_type_id
  ) x
Group by
  x.name
order by
  revenues DESC
LIMIT 3

------------------------------------------------------------------
-- Questions 11:
-- Calculate the percentage contribution of each pizza type to total revenue.
select
  pt.category,
  round(sum(od.quantity * p.price)) / (
    select
      round(sum(od.quantity * p.price), 2) as total_sales
    from
      order_details od
      join pizzas p on p.pizza_id = od.pizza_id
  ) * 100 as revenue
from
  pizza_types pt
  join pizzas p on pt.pizza_type_id = p.pizza_type_id
  join order_details od on od.pizza_id = p.pizza_id
Group by
  pt.category
order by
  revenue DESC

------------------------------------------------------------------
-- Questions 12:
-- Analyze the cumulative revenue generated over time
select
  order_Date,
  sum(revenue) over(
    order by
      order_Date
  ) as cum_rev
from
  (
    select
      o.order_Date,
      sum(od.quantity * p.price) as revenue
    from
      order_details od
      join pizzas p on od.pizza_id = p.pizza_id
      join orders o on o.order_id = od.order_id
    Group by
      order_Date
  ) as sales

















