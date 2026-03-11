/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
 */

WITH film_revenue AS (
    SELECT
        f.film_id,
        f.title,
        COALESCE(SUM(p.amount), 0.00) AS revenue
    FROM film f
    LEFT JOIN inventory i ON i.film_id = f.film_id
    LEFT JOIN rental r ON r.inventory_id = i.inventory_id
    LEFT JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY f.film_id, f.title
),
ranked AS (
    SELECT
        RANK() OVER (ORDER BY revenue DESC) AS rank,
        title,
        revenue
    FROM film_revenue
),
ranked_sum AS (
    SELECT
        rank,
        MIN(revenue) AS revenue_per_rank
    FROM ranked
    GROUP BY rank
),
cumulative AS (
    SELECT
        r.rank,
        r.title,
        r.revenue,
        SUM(rs.revenue_per_rank) OVER (ORDER BY r.rank) AS "total revenue",
        SUM(rs.revenue_per_rank) OVER () AS total_all_revenue
    FROM ranked r
    JOIN ranked_sum rs USING(rank)
)
SELECT
    rank,
    title,
    revenue,
    "total revenue",
    TO_CHAR(
    100.0 * "total revenue" / total_all_revenue,
    CASE
        WHEN 100.0 * "total revenue" / total_all_revenue < 100 THEN 'FM00.00'
        ELSE 'FM999.00'
    END
) AS "percent revenue"
FROM cumulative
ORDER BY rank, title;
