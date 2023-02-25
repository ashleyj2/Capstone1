/*
Ashley Joyner
2/22/2023
SQL queries for week 1 of Capstone Project 1 for Masterschool course
*/

--1. How many customers do we have in the data?
SELECT COUNT(customer_name)
FROM customers;
--RESULT: 795

--2. What was the city with the most profit for the company in 2015?
SELECT SUM(d.order_profits) AS profits, o.shipping_city
FROM orders AS o
INNER JOIN order_details AS d
ON o.order_id = d.order_id
WHERE EXTRACT(year FROM o.order_date) = '2015'
GROUP BY o.shipping_city
ORDER BY profits DESC
LIMIT 5;
--RESULT: $14,753, New York City

--3. In 2015, what was the most profitable city's profit?
SELECT SUM(d.order_profits) AS profits, o.shipping_city
FROM orders AS o
INNER JOIN order_details AS d
ON o.order_id = d.order_id
WHERE EXTRACT(year FROM o.order_date) = '2015'
GROUP BY o.shipping_city
ORDER BY profits DESC
LIMIT 5;
--RESULT: $14,753, New York City

--4. How many different cities do we have in the data?
SELECT COUNT(DISTINCT(shipping_city))
FROM orders;
--RESULTS: 531

--5. Show the total spent by customers from low to high.
SELECT SUM(d.order_sales) AS total_spent, o.customer_id
FROM order_details AS d
INNER JOIN orders AS o
ON o.order_id = d.order_id
GROUP BY o.customer_id
ORDER BY total_spent
LIMIT 10;
--quiz answer ID 456

--6. What is the most profitable city in the State of Tennessee?
SELECT o.shipping_state, o.shipping_city, SUM(d.order_profits) AS profits
FROM orders AS o
JOIN order_details AS d
ON o.order_id = d.order_id
WHERE o.shipping_state = 'Tennessee'
GROUP BY o.shipping_state, o.shipping_city
ORDER BY profits DESC
LIMIT 5;
--RESULT: Lebanon, 83

--7. What’s the average annual profit for that city across all years?
SELECT AVG(d.order_profits) AS avg_annual_profit
FROM orders AS o
JOIN order_details AS d
ON o.order_id = d.order_id
WHERE o.shipping_city = 'Lebanon';
--RESULT: 27.667

--8. What is the distribution of customer types in the data?
SELECT customer_segment, COUNT(*)
FROM customers
GROUP BY customer_segment;
-- quiz answer 410

--9. What’s the most profitable product category on average in Iowa across all years?
SELECT p.product_category, AVG(d.order_profits) AS profit
FROM product AS p
JOIN order_details AS d
ON p.product_id = d.product_id
JOIN orders AS o
ON o.order_id = d.order_id
WHERE o.shipping_state = 'Iowa'
GROUP BY p.product_category
ORDER BY profit DESC;
--RESULT: Furniture

--10. What is the most popular product in that category across all states in 2016?
SELECT p.product_name, SUM(d.quantity) AS profit
FROM product AS p
JOIN order_details AS d
ON p.product_id = d.product_id
JOIN orders AS o
ON o.order_id = d.order_id
WHERE EXTRACT(year FROM o.order_date) = 2016 AND p.product_category = 'Furniture'
GROUP BY p.product_name
ORDER BY profit DESC;
--quiz answer 'Global Push Button Manager's Chair, Indigo'

--11. Which customer got the most discount in the data? (in total amount)
SELECT c.customer_id, (d.order_sales / (1 - d.order_discount))- d.order_sales AS total_discount
FROM customers AS c
JOIN orders AS o
ON c.customer_id = o.customer_id
JOIN order_details AS d
ON o.order_id = d.order_id
ORDER BY total_discount DESC
LIMIT 5;
--RESULT: 687, $22,638

--12. How widely did monthly profits vary in 2018?
SELECT EXTRACT(month FROM o.order_date) AS month,
    SUM(d.order_profits) AS month_total,
    SUM(d.order_profits) - lag(SUM(d.order_profits),1, 0) 
        OVER (ORDER BY EXTRACT(month FROM o.order_date)) AS month_diff
FROM orders AS o
JOIN order_details AS d
ON o.order_id = d.order_id
WHERE EXTRACT(year FROM o.order_date) = 2018 
GROUP BY month
ORDER BY month;
--quiz answer -5525

--13. Which order was the highest in 2015?
SELECT o.order_id, d.order_sales
FROM orders AS o
JOIN order_details AS d
ON o.order_id = d.order_id
WHERE EXTRACT(year FROM o.order_date) = 2015
ORDER BY d.order_sales DESC;
--RESULT: CA-2015-145317

--14. What was the rank of each city in the East region in 2015?
SELECT shipping_city, 
    COUNT(order_id) AS amount, 
    RANK() OVER(ORDER BY COUNT(order_id) DESC) AS ranks
FROM orders
WHERE EXTRACT(year FROM order_date) = 2015 
    AND shipping_region = 'East'
GROUP BY shipping_city
ORDER BY ranks;
--quiz answer Columbus

--15. Display customer names for customers who are in the segment ‘Consumer’ or ‘Corporate.’ 
--How many customers are there in total?
SELECT customer_name, customer_segment
FROM customers
WHERE customer_segment = 'Consumer'
or customer_segment = 'Corporate';
--RESULTS: 647 rows

--16. Calculate the difference between the largest and smallest order quantities for 
--product id ‘100.’
SELECT MAX(quantity) - MIN(quantity) AS difference
FROM order_details
WHERE product_id = 100;
--RESULT: 4

--17. Calculate the percent of products that are within the category ‘Furniture.’ 
SELECT (SELECT CAST(COUNT(product_id) AS float)
        FROM product
        WHERE product_category = 'Furniture')
    /CAST(COUNT(product_id) AS float) * 100 AS percent
FROM product;
-- quiz answer 20.54

--18. Display the number of duplicate products based on their product manufacturer.           
--Example: A product with an identical product manufacturer can be considered a duplicate.
SELECT product_manufacturer, COUNT(product_manufacturer)
FROM product
GROUP BY product_manufacturer;
--quiz answer 8

--19. Show the product_subcategory and the total number of products in the subcategory.
--Show the order from most to least products and then by product_subcategory name ascending.
SELECT product_subcategory, COUNT(product_subcategory) AS total_number
FROM product
GROUP BY product_subcategory
ORDER BY 2 DESC, 1;
--quiz answer Paper

--20. Show the product_id(s), the sum of quantities, where the total sum of its product quantities 
--is greater than or equal to 100.
SELECT product_id, SUM(quantity) AS sum_quantity
FROM order_details
GROUP BY product_id
HAVING sum(quantity) >= 100;
--quiz answer 132