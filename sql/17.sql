/*
 * Compute the total revenue for each film.
 * The output should include another new column "total revenue" that shows the sum of all the revenue of all previous films.
 *
 * HINT:
 * My solution starts with the solution to problem 16 as a subquery.
 * Then I combine the SUM function with the OVER keyword to create a window function that computes the total.
 * You might find the following stackoverflow answer useful for figuring out the syntax:
 * <https://stackoverflow.com/a/5700744>.
 */

WITH ranked AS (
    SELECT
        rank() OVER (ORDER BY COALESCE(revenue, 0.00) DESC) AS rank,
        title,
        COALESCE(revenue, 0.00) AS revenue
    FROM (
        SELECT
            f.title,
            SUM(p.amount) AS revenue
        FROM
            film f
        LEFT JOIN inventory i ON f.film_id = i.film_id
        LEFT JOIN rental r ON i.inventory_id = r.inventory_id
        LEFT JOIN payment p ON r.rental_id = p.rental_id
        GROUP BY f.title
    ) t
)
SELECT
    r.rank,
    r.title,
    r.revenue,
    SUM(ranked_sum) OVER (ORDER BY r.rank) AS "total revenue"
FROM (
    SELECT
        rank,
        MIN(revenue) AS ranked_sum
    FROM ranked
    GROUP BY rank
) s
JOIN ranked r USING(rank)
ORDER BY r.rank, r.title;
