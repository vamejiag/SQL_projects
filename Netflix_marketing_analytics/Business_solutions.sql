-- Netflix Data Analysis 

SELECT *
FROM netflix_tables;

-- 1. Count the number of Movies vs TV Shows
SELECT 
	kind,
	COUNT(kind)
from netflix_tables
GROUP BY kind;

-- 2. Find the most common rating for movies and TV shows
WITH rating_counts as (
 SELECT 
	kind,
    rating,
    COUNT(*) as counts # Counts all rows in each group (Same kind and rating)
FROM netflix_tables
WHERE rating IS NOT NULL and kind IS NOT NULL
group by kind, rating
ORDER by kind, rating
),
max_counts as (
SELECT
	kind,
	MAX(counts) as max_counts 
FROM  rating_counts
group by kind
)
SELECT 
mc.kind,
rc.rating,
mc.max_counts 
FROM max_counts mc
INNER JOIN rating_counts rc
ON mc.max_counts = rc.counts
;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT
title
FROM netflix_tables nt
WHERE nt.kind = 'Movie' and nt.release_year = 2020
ORDER by title;


-- 4. Find the top 5 countries with the most content on Netflix
WITH RECURSIVE countries_comma AS (
    -- Extract the first country and separate it from the rest
    SELECT
        show_id,
        title,
        TRIM(SUBSTR(country, 1, INSTR(country, ',') - 1)) AS country,  -- Extract first country
        TRIM(SUBSTR(country, INSTR(country, ',') + 1)) AS rest_country  -- Remaining countries
    FROM netflix_tables
    WHERE INSTR(country, ',') > 0  -- Only select rows with multiple countries

    UNION ALL

    --  Handle the rest of the countries
    SELECT
        show_id,
        title,
        TRIM(SUBSTR(rest_country, 1, INSTR(rest_country, ',') - 1)) AS country,  -- Extract next country
        TRIM(SUBSTR(rest_country, INSTR(rest_country, ',') + 1)) AS rest_country  -- Remaining countries
    FROM countries_comma
    WHERE INSTR(rest_country, ',') > 0  -- Continue splitting if commas remain

    UNION ALL

    -- Handle the last remaining country when no commas are left
    SELECT
        show_id,
        title,
        TRIM(rest_country) AS country,
        NULL AS rest_country
    FROM countries_comma
    WHERE INSTR(rest_country, ',') = 0  -- When no more commas remain
)

-- Final step: Select the split countries
SELECT
	country,
    COUNT(country) as content
FROM (
	SELECT title,country FROM countries_comma 
    UNION ALL
    SELECT title,TRIM(country) AS country FROM netflix_tables
    WHERE INSTR(country, ',')=0
) as total_countries
GROUP BY country
ORDER BY content DESC
LIMIT 5;

-- 5. Identify the longest movie
SELECT
	title,
    CAST( SUBSTR(duration, 1, INSTR(duration, 'min')-1) AS UNSIGNED) as max_duration
FROM netflix_tables
WHERE kind = 'Movie' 
ORDER BY max_duration desc
LIMIT 1;

-- 6. Find content added in the last 5 years
SELECT 
	*
FROM netflix_tables
WHERE date_added >= CURDATE() - INTERVAL 5 YEAR
ORDER BY date_added desc;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'
SELECT
	kind,
	title
FROM netflix_tables
WHERE director LIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
SELECT
	title,
    CAST( SUBSTR(duration, 1, INSTR(duration,'S')) AS UNSIGNED)
FROM netflix_tables
WHERE kind = 'TV Show' AND CAST( SUBSTR(duration, 1, INSTR(duration,'S')) AS UNSIGNED) > 5
ORDER BY duration;

-- using CTE for better readability
WITH season_table as (
SELECT
	title,
    CAST( SUBSTR(duration, 1, INSTR(duration,'S')) AS UNSIGNED) as seasons
FROM netflix_tables
WHERE kind = 'TV Show'
)
SELECT 
	*
FROM season_table
WHERE seasons >5
ORDER BY seasons asc;

-- 9. Count the number of content items in each genre
WITH RECURSIVE rows_comma AS (
    -- Extract the first argument and separate it from the rest
    SELECT
        show_id,
        TRIM(SUBSTR(listed_in, 1, INSTR(listed_in, ',') - 1)) AS genre,  -- Extract first argument
        TRIM(SUBSTR(listed_in, INSTR(listed_in, ',') + 1)) AS rest_genre  -- Remaining arguments
    FROM netflix_tables
    WHERE INSTR(listed_in, ',') > 0  -- Only select rows with multiple arguments

    UNION ALL

    --  Handle the rest of the arguments
    SELECT
        show_id,
        TRIM(SUBSTR(rest_genre, 1, INSTR(rest_genre, ',') - 1)) AS genre,  -- Extract next country
        TRIM(SUBSTR(rest_genre, INSTR(rest_genre, ',') + 1)) AS rest_genre  -- Remaining countries
    FROM rows_comma
    WHERE INSTR(rest_genre, ',') > 0  -- Continue splitting if commas remain

    UNION ALL

    -- Handle the last remaining arguments when no commas are left
    SELECT
        show_id,
        TRIM(rest_genre) AS genre,
        NULL AS rest_genre
    FROM rows_comma
    WHERE INSTR(rest_genre, ',') = 0  -- When no more commas remain
)

-- Final step: Select the split countries
SELECT
	COUNT(genre) as content,
    genre
FROM (
	SELECT show_id,genre FROM rows_comma 
    UNION ALL
    SELECT show_id,TRIM(listed_in) AS genre FROM netflix_tables
    WHERE INSTR(listed_in, ',')=0
) as total_genre
GROUP BY genre
ORDER BY content asc;

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- only content released in India
SELECT
	show_id,
	release_year
FROM netflix_tables
WHERE country LIKE '%India%';

-- genre, released year and how many times the content was in that year only in India
WITH RECURSIVE rows_comma AS (
    -- Extract the first argument and separate it from the rest
    SELECT
        show_id,
        release_year,
        country,
        TRIM(SUBSTR(listed_in, 1, INSTR(listed_in, ',') - 1)) AS genre,  -- Extract first argument
        TRIM(SUBSTR(listed_in, INSTR(listed_in, ',') + 1)) AS rest_genre  -- Remaining arguments
    FROM netflix_tables
    WHERE INSTR(listed_in, ',') > 0  -- Only select rows with multiple arguments

    UNION ALL

    --  Handle the rest of the arguments
    SELECT
        show_id,
        release_year,
        country,
        TRIM(SUBSTR(rest_genre, 1, INSTR(rest_genre, ',') - 1)) AS genre,  -- Extract next country
        TRIM(SUBSTR(rest_genre, INSTR(rest_genre, ',') + 1)) AS rest_genre  -- Remaining countries
    FROM rows_comma
    WHERE INSTR(rest_genre, ',') > 0  -- Continue splitting if commas remain

    UNION ALL

    -- Handle the last remaining arguments when no commas are left
    SELECT
        show_id,
        release_year,
        country,
        TRIM(rest_genre) AS genre,
        NULL AS rest_genre
    FROM rows_comma
    WHERE INSTR(rest_genre, ',') = 0  -- When no more commas remain
)
-- Final step: Select the split countries
SELECT
	genre,
    date_added,
    COUNT(genre) as content
FROM (
	SELECT show_id,date_added,country,genre FROM rows_comma 
    UNION ALL
    SELECT show_id,date_added,country,TRIM(listed_in) AS genre FROM netflix_tables
    WHERE INSTR(listed_in, ',')=0
) as total_genre
WHERE country LIKE '%India%'
GROUP BY genre, release_year
ORDER BY content desc;

-- return top 5 year with highest avg content release
WITH RECURSIVE rows_comma AS (
    -- Extract the first argument and separate it from the rest
    SELECT
        show_id,
        date_added,
        country,
        TRIM(SUBSTR(listed_in, 1, INSTR(listed_in, ',') - 1)) AS genre,  -- Extract first argument
        TRIM(SUBSTR(listed_in, INSTR(listed_in, ',') + 1)) AS rest_genre  -- Remaining arguments
    FROM netflix_tables
    WHERE INSTR(listed_in, ',') > 0  -- Only select rows with multiple arguments

    UNION ALL

    --  Handle the rest of the arguments
    SELECT
        show_id,
        date_added,
        country,
        TRIM(SUBSTR(rest_genre, 1, INSTR(rest_genre, ',') - 1)) AS genre,  -- Extract next country
        TRIM(SUBSTR(rest_genre, INSTR(rest_genre, ',') + 1)) AS rest_genre  -- Remaining countries
    FROM rows_comma
    WHERE INSTR(rest_genre, ',') > 0  -- Continue splitting if commas remain

    UNION ALL

    -- Handle the last remaining arguments when no commas are left
    SELECT
        show_id,
        date_added,
        country,
        TRIM(rest_genre) AS genre,
        NULL AS rest_genre
    FROM rows_comma
    WHERE INSTR(rest_genre, ',') = 0  -- When no more commas remain
)
-- Final step: Select the split countries
SELECT
	genre,
    EXTRACT(YEAR FROM date_added) as released_year,
    COUNT(genre) as content
FROM (
	SELECT show_id,date_added,country,genre FROM rows_comma 
    UNION ALL
    SELECT show_id,date_added,country,TRIM(listed_in) AS genre FROM netflix_tables
    WHERE INSTR(listed_in, ',')=0
) as total_genre
WHERE country LIKE '%India%'
GROUP BY genre, released_year
ORDER BY released_year desc;

-- 11. List all movies that are documentaries
SELECT
	*
FROM netflix_tables
WHERE listed_in LIKE '%documentaries%' AND kind = 'Movie';

-- 12. Find all content without a director
SELECT
	title,
	listed_in
FROM netflix_tables
WHERE director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT
	COUNT(*) as total_movies
FROM netflix_tables
WHERE kind = 'Movie' AND 
cast LIKE '%Salman Khan%' AND
date_added >= CURDATE() - INTERVAL 10 YEAR;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India

-- Extract individual actors from the cast and filter for Indian movies
SELECT
	title,
	cast,
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1)) AS actor1,
    numbers.n
FROM netflix_tables
-- create table numbered from 1 to 10 to allocate and match with the cast member
JOIN (	SELECT 1 as n 
		UNION SELECT 2 
		UNION SELECT 3 
		UNION SELECT 4 
		UNION SELECT 5 
		UNION SELECT 6 
		UNION SELECT 7 
		UNION SELECT 8 
		UNION SELECT 9 
		UNION SELECT 10) numbers
ON CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= numbers.n - 1 -- number of commas >= number of members
WHERE kind = 'Movie' 
AND country LIKE '%India%'  -- Filter for movies produced in India
AND cast IS NOT NULL ;      -- Ensure cast column is not null

-- Use the table to calculate the top 10
WITH actor_movies_india AS (
    -- Extract individual actors from the cast and filter for Indian movies
    SELECT
        title,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', numbers.n), ',', -1)) AS actor
    FROM netflix_tables
    JOIN (SELECT 1 as n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
          UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
    ON CHAR_LENGTH(cast) - CHAR_LENGTH(REPLACE(cast, ',', '')) >= numbers.n - 1
    WHERE kind = 'Movie' 
      AND country LIKE '%India%'  -- Filter for movies produced in India
      AND cast IS NOT NULL        -- Ensure cast column is not null
)
-- Group by actors and count their appearances in Indian movies
SELECT
    actor,
    COUNT(actor) AS movie_count -- (*) takes NULLS 
FROM actor_movies_india
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;

-- 15. How many items are considered high-risk due to violence
/*Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category. */

SELECT
	CASE -- takes into account kill,killer,killing, etc
		WHEN (`description`LIKE '%kill%' OR `description` LIKE '%violence%') THEN 'bad'
        ELSE 'good'
	END AS category,
    COUNT(*) as counts
FROM netflix_tables
GROUP BY category;

ALTER TABLE netflix_tables ADD FULLTEXT(description);
SELECT
    CASE -- only takes into account kill word
        WHEN MATCH(description) AGAINST ('kill violence' IN BOOLEAN MODE) THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS counts
FROM netflix_tables
GROUP BY category;

-- 16. What is the second highest-rated movie from each country, and in which genre does it belong?

-- title and ranking per country
WITH clean_country AS ( -- some country rows start and end with a comma
	SELECT
		title,
        rating,
        listed_in as genre,
        TRIM(BOTH ',' FROM country) as country
	FROM netflix_tables
    WHERE kind = 'Movie' AND country IS NOT NULL
),
rank_country as (
 -- Extract individual countries from the country 
SELECT
	title,
    rating,
    genre,
	TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1)) AS country,
    ROW_NUMBER() OVER (PARTITION BY TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1)) ORDER BY rating) as ranking
FROM clean_country
JOIN (SELECT 1 as n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
	UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) numbers
ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= numbers.n - 1) 
SELECT 
	country,
    ranking,
    title,
    genre
FROM rank_country
WHERE ranking <=2
ORDER BY country;


-- notes
/* 
- SUBSTR(text, start,end) = segmented text 
- INSTR(text,instance) = position of the instance in the text
- SUBSTRING_INDEX(text,instance,which instance (the first or second and ignore the first, thrid,...) = segmented text
*/

