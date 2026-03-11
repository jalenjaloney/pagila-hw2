/*
 * Management wants to send coupons to customers who have previously rented one of the top-5 most profitable movies.
 * Your task is to list these customers.
 *
 * HINT:
 * In problem 16 of pagila-hw1, you ordered the films by most profitable.
 * Modify this query so that it returns only the film_id of the top 5 most profitable films.
 * This will be your subquery.
 * 
 * Next, join the film, inventory, rental, and customer tables.
 * Use a where clause to restrict results to the subquery.
 */

SELECT DISTINCT c.customer_id
FROM customer c
JOIN rental r
    ON c.customer_id = r.customer_id
JOIN inventory i
    ON r.inventory_id = i.inventory_id
WHERE i.film_id IN (
    SELECT 
        film_id
    FROM (
        SELECT 
            film_id,
            SUM(p.amount) AS profit
        FROM payment p
        JOIN rental r
            ON p.rental_id = r.rental_id
        JOIN inventory i
            ON r.inventory_id = i.inventory_id
        GROUP BY film_id
        ORDER BY profit DESC
        LIMIT 5
    ) AS profitable_films
)
ORDER BY c.customer_id;

