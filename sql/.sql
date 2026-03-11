SELECT title 
FROM film 
WHERE special_features IS NOT NULL 
AND 'Deleted Scenes' = ANY(unnest(special_features)) 
AND rental_duration > 4 
AND rating = 'NC-17' 
AND category_id NOT IN (7, 5)
