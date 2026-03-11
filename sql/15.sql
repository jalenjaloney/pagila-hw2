/*
 * Compute the total revenue for each film.
 */

SELECT
    f.title,
    COALESCE(SUM(p.amount), 0.00) AS revenue
FROM
    film f
LEFT JOIN
    inventory i ON i.film_id = f.film_id
LEFT JOIN
    rental r ON r.inventory_id = i.inventory_id
LEFT JOIN
    payment p ON p.rental_id = r.rental_id
GROUP BY
    f.title
ORDER BY
    revenue DESC, title;
