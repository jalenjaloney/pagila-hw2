/*
 * Count the number of movies that contain each type of special feature.
 * Order the results alphabetically be the special_feature.
 */

SELECT feature AS special_features, COUNT(*)
FROM film
CROSS JOIN unnest(special_features) AS feature
GROUP BY feature
ORDER BY feature;
