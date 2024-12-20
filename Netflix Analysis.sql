-- Netflix SQL Project
DROP TABLE IF EXISTS Netflix;
CREATE TABLE Netflix
(
show_id	VARCHAR (6),
type VARCHAR (10),	
title VARCHAR (150),	
director VARCHAR (250),	
casts VARCHAR (1000),
country	VARCHAR (150),
date_added VARCHAR (50),
release_year INT,
rating VARCHAR (10),
duration VARCHAR (15),	
listed_in VARCHAR (100),
description VARCHAR (250)
);
Select * from Netflix;

SELECT 
	count (*) as total_content
	from Netflix;
SELECT 
	DISTINCT type
from Netflix;

-- Problem 1 Count the Number of Movies and TV shows
select 
	type,
	count (*) as total_content
from Netflix
group by type

-- Problem 2 Find the most common rating for Movies and TV Shows
SELECT 
	type,
	 rating
FROM
(SELECT 
    type,
    rating,
    COUNT(*) AS count,
    RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM Netflix
GROUP BY type, rating
) as t1 
where 
ranking = 1 

-- Problem 3 List all the Movies released in 2020
select * from Netflix
where 
	type = 'Movie'
	and 
	release_year = 2020
	
-- Problem 4 Find the Top 5 Countries with Most Content on Netflix

SELECT 
    UNNEST(string_to_array(country, ',')) AS new_country,
    COUNT(show_id) AS total_content
FROM Netflix
GROUP BY new_country
order by total_content desc
limit 5 
 
-- Problem 5 Identify the longest Movie
SELECT * 
FROM Netflix
WHERE 
    type = 'Movie'
    AND 
    CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) = (
        SELECT MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER))
        FROM Netflix
        WHERE type = 'Movie'
    );

		

-- Problem 6 Find the content added in the last 5 years 
select * from Netflix
where 
	TO_DATE(date_added, 'Month dd, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- Problem 7 Find all the Movie/TV Shows by Director 'Rajiv Chilaka'
select * from Netflix
where director LIKE '%Rajiv Chilaka%'

-- Problem 8 List all TV Shows with more than 5 seasons
select * from Netflix
where 
	type = 'TV Show'
	and 
	SPLIT_PART(duration, ' ', 1 ):: numeric > 5 

-- Problem 9 Count the number of Content items in each genre 
select 
	unnest (string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
	from Netflix
	group by genre

--	Problem 10. Find each year and the average number of content release by india on netflix
--  return top 5 year with highest avg content release 
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

 -- Problem 11 List all the Content which is a documentary
 SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries'
	

-- Problem 12 Find all the content without Director
SELECT * 
FROM netflix
WHERE director IS NULL

-- Problem 13 Find out in how many movies salman khan appeared in last 10 years
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- Problem 14 Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Problem 15 Categorize content as Parental Guidance Content when there is Presence of keywords like 'Kill' and 'Violence' 
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Parental Guidance Content'
            ELSE 'Normal'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;




















