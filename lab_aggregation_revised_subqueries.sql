USE sakila;

# Q1: Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT DISTINCT first_name, last_name, email
FROM customer
JOIN rental USING (customer_id);

# Q2: What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, AVG(p.amount) AS avg_payment
FROM customer c
JOIN rental r USING (customer_id)
JOIN payment p USING (customer_id)
GROUP BY c.customer_id, customer_name;

# Q3: Select the name and email address of all the customers who have rented the "Action" movies.

# Write the query using multiple join statements
SELECT DISTINCT CONCAT(first_name, ' ', last_name) AS customer_name, email
FROM customer 
JOIN rental USING (customer_id)
JOIN inventory i USING (inventory_id)
JOIN film_category USING (film_id)
JOIN category USING (category_id)
WHERE category.name = "Action";

# Write the query using sub queries with multiple WHERE clause and IN condition
SELECT CONCAT(first_name, ' ', last_name) AS customer_name, email
FROM customer
WHERE customer_id IN (
  SELECT DISTINCT customer_id
  FROM rental
  WHERE inventory_id IN (
    SELECT inventory_id
    FROM inventory
    WHERE film_id IN (
      SELECT film_id
      FROM film_category
      WHERE category_id IN (
        SELECT category_id
        FROM category
        WHERE name = 'Action'))));

# Verify if the above two queries produce the same results or not
# --> Yes.

# Q4: Use the case statement to create a new column classifying existing columns as either low or high value transactions based on the amount of payment. 
#     If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
SELECT payment_id, customer_id, amount,
  CASE
    WHEN amount BETWEEN 0 AND 2 THEN 'low'
    WHEN amount BETWEEN 2 AND 4 THEN 'medium'
    ELSE 'high'
  END AS transaction_value
FROM payment;
