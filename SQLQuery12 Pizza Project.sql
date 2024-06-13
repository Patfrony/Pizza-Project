-- To answer the business question, what is the total number of orders placed?
select count(distinct order_id) as 'Total Orders' from orders;


-- To calculate the total revenue generated from pizza sales.
-- First let’s join the order_details and pizzas table to see the details
select order_details.pizza_id, order_details.quantity, pizzas.price
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id


-- to get the total revenue
select cast(sum(order_details.quantity * pizzas.price) as decimal(10,2)) as 'Total Revenue'
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id






--INVENTORY MANAGEMENT
-- Determine the distribution of orders by hour of the day.

SELECT 
    DATEPART(hour, time) AS 'Hour of the day', 
    COUNT(DISTINCT order_id) AS 'No of Orders'
FROM 
    orders
GROUP BY 
    DATEPART(hour, time)
ORDER BY 
    [No of Orders] DESC;


	-- To answer the business question- Which ingredients are most frequently used and should be stocked more regularly?
-- Step 1: Create a CTE to split the ingredients
WITH IngredientCTE AS (
    SELECT
        pt.pizza_type_id,
        pt.name,
        LTRIM(RTRIM(value)) AS ingredient
    FROM 
        pizza_types pt
    CROSS APPLY STRING_SPLIT(pt.ingredients, ',')
)

-- Step 2: Join the split ingredients with order details and calculate usage
SELECT
    ic.ingredient,
    SUM(od.quantity) AS ingredient_usage
FROM
    IngredientCTE ic
JOIN
    pizzas p ON ic.pizza_type_id = p.pizza_type_id
JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY
    ic.ingredient
ORDER BY
    ingredient_usage DESC;


	

	--Customer Preferences
--To answer the business question what are the top 5 most ordered pizza types along with their quantities.

select top 5 pizza_types.name as 'Pizza', sum(quantity) as 'Total Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name 
order by sum(quantity) desc


--To answer the business question what is the total quantity of each pizza category ordered

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select top 5 pizza_types.category, sum(quantity) as 'Total Quantity Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category 
order by sum(quantity)  desc


--To answer the business question what is the category-wise distribution of pizzas?
select category, count(distinct pizza_type_id) as [No of pizzas]
from pizza_types
group by category
order by [No of pizzas]


--To answer the business question what are the peak hours and days for orders?
SELECT
    DATENAME(WEEKDAY, date) AS DayOfWeek,
    DATEPART(HOUR, time) AS Hour,
    COUNT(order_id) AS NumberOfOrders
FROM
    orders
GROUP BY
    DATENAME(WEEKDAY, date),
    DATEPART(WEEKDAY, date),
    DATEPART(HOUR, time)
ORDER BY
    NumberOfOrders DESC;
