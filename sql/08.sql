/*
 * Select the title of all 'G' rated movies that have the 'Trailers' special feature.
 * Order the results alphabetically.
 *
 * HINT:
 * Use `unnest(special_features)` in a subquery.
 */
SELECT title
FROM (
  SELECT title, rating
  FROM film
  WHERE rating = 'G' AND special_features @> ARRAY['Trailers']
) AS t
ORDER BY title;
