use pizzahut;

create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));
select * from pizzahut.orders;

create table orders_details(
order_details_id int not null,
order_id int not null,
pizza_id  text not null,
quantity int  not null,
primary key(order_details_id));
select * from pizzahut. orders_details;
 select * from pizzahut.pizza_types;
  select * from pizzahut.pizzas;
  -- 1.Retrieve the total number of orders placed. --
 SELECT 
    COUNT(order_id) AS total_orders
  FROM
    orders;
  -- 2. Calculate the total revenue generated from pizza sales.--
SELECT ROUND(SUM(orders_details.quantity * pizzas.price),
2) AS total_sales
FROM orders_details
JOIN pizzas ON pizzas.pizza_id = orders_details.pizza_id;
-- 3.Identify the highest-priced pizza.--
SELECT 
pizza_types.name, pizzas.price
FROM
pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC LIMIT 1;
-- 4.Identify the most common pizza size ordered.--
select pizzas.size, 
count(orders_details.order_details_id) as order_count
from pizzas join orders_details
on pizzas.pizza_id = orders_details.pizza_id
group by pizzas.size order by order_count desc;
-- 5.List the top 5 most ordered pizza types along with their quantities.--
SELECT pizza_types.name, SUM(orders_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC LIMIT 5;
-- 6. Join the necessary tables to find the total quantity of each pizza category ordered --.
select pizza_types.category,
sum(orders_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;

-- 7. Determine the distribution of orders by hour of the day.--
select hour(order_time) as hour ,count(order_id)as order_count from orders
group by hour(order_time);

-- 8 Join relevant tables to find the category-wise distribution of pizzas.--
select category,count(name) from pizza_types
group by category;

-- 9. Group the orders by date and calculate the average number of pizzas ordered per day--
select round(avg(quantity) ,0) as avg_pizza_orderd_per_day from
(select orders.order_date,sum(orders_details.quantity) as quantity
from orders join orders_details
on orders.order_id = orders_details.order_id
group by  orders.order_date) as order_qantity;

-- 10.-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,
sum(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join orders_details
on orders_details.pizza_id  =  pizzas.pizza_id 
group by pizza_types.name order by revenue desc limit 3;

