CREATE TABLE nobel (
	full_name text,
	born DATE,
	died date,
	born_country text,
	born_country_code text,
	died_country text,
	died_country_code text,
	gender text,
	year integer,
	category text,
	motivation text,
	organization_name TEXT,
	organization_city TEXT,
	organization_country TEXT
);


-- Creating winning_age column
ALTER TABLE nobel
ADD COLUMN winning_age INTEGER;

UPDATE nobel
SET winning_age = year - EXTRACT(YEAR FROM born);


-- Nations with more winners
SELECT born_country_code, COUNT(*) AS "numbers_of_winners"
FROM Nobel
WHERE born_country_code IS NOT NULL
GROUP BY born_country_code
ORDER BY COUNT(*) DESC
LIMIT 5;

WITH winners_nations AS (
	SELECT born_country_code,
		CASE WHEN born_country_code = 'US' THEN 'United States'
			 WHEN born_country_code = 'GB' THEN 'Great Britain'
			 WHEN born_country_code  = 'DE' THEN 'Germany'
			 WHEN born_country_code = 'FR' THEN 'France'
			 WHEN born_country_code  = 'SE' THEN 'Sweden'
		END AS country_name,
		COUNT(*) AS numbers_of_winners
	FROM nobel
	WHERE born_country_code IS NOT NULL
	GROUP BY born_country_code
	ORDER BY COUNT(*) DESC
	LIMIT 5
)

SELECT country_name, numbers_of_winners
FROM winners_nations;


-- Calculating the top 10 universities with most winners
SELECT COUNT(*) AS winners_per_univesity, organization_name_standard, organization_country
FROM nobel
WHERE organization_name_standard IS NOT NULL
GROUP BY organization_name_standard, organization_country
ORDER BY COUNT(*) DESC
LIMIT 10;


-- Grouping leading organizations by category
SELECT DISTINCT category, COUNT(*), organization_name_standard
FROM nobel
WHERE organization_name_standard IS NOT NULL
GROUP BY category, organization_name_standard
ORDER BY COUNT(*) DESC
LIMIT 5;

SELECT category, COUNT(*), organization_name_standard
FROM nobel
WHERE category = 'Peace' AND organization_name_standard IS NOT NULL
GROUP BY category, organization_name_standard
ORDER BY COUNT(*) DESC;

SELECT full_name, organization_name_standard
FROM nobel
WHERE category = 'Literature' -- No Literature laureate is associated to an organization


-- Youngest and oldest winner
(
	SELECT full_name, winning_age, year, category, motivation
	FROM nobel
	WHERE gender !=  'org'
	ORDER BY winning_age ASC
	LIMIT 1
)
UNION ALL
(
	SELECT full_name, winning_age, year, category, motivation
	FROM nobel
	WHERE gender != 'org'
	ORDER BY winning_age DESC
	LIMIT 1
);


-- Calculating the average age across categories
SELECT category, ROUND(AVG(winning_age)::numeric)
FROM nobel
GROUP BY category
ORDER BY AVG(winning_age) DESC;


-- Distribution between genders
SELECT COUNT(*), gender, round(
		(COUNT(*)::numeric * 100 / SUM(COUNT(*)) OVER()) , 
		0
	) AS percentage
FROM nobel
WHERE gender != 'org'
GROUP BY gender
ORDER BY COUNT(*) DESC;


-- Comparing the time elapsed between the first winners and the first female winner
( 
	SELECT full_name, gender, year, category, motivation 
	FROM nobel
	ORDER BY year ASC
	LIMIT 1
) 
UNION ALL
( 
	SELECT full_name, gender, year, category, motivation 
	FROM nobel
	WHERE gender = 'female'
	ORDER BY year ASC
	LIMIT 1
);


-- Tracking female laureates in time

-- First I will create a new table for years when no woman was awarded
CREATE TABLE no_women
AS 
SELECT DISTINCT year
FROM nobel
EXCEPT
SELECT DISTINCT year
FROM nobel
WHERE gender = 'female'
ORDER BY year;

ALTER TABLE no_women
ADD count bigint;

UPDATE no_women
SET count = 0;

-- Now I union with a query that shows the years when at least one woman was awarded
(
	SELECT year, count(*) from nobel
WHERE gender = 'female'
GROUP BY year
ORDER BY year
)
UNION ALL
(
	SELECT * FROM no_women
)
ORDER BY year; -- Final result


-- Calculating the female distribution across categories
SELECT category, COUNT(*) FROM nobel
WHERE gender = 'female'
GROUP BY category
ORDER BY COUNT(*) DESC;

SELECT * FROM nobel
LIMIT 1;


-- Checking repeated laureates
SELECT full_name, year, category, motivation
FROM nobel
WHERE full_name IN (
		SELECT full_name
		FROM nobel
		GROUP BY full_name
		HAVING COUNT(*) > 1
)
ORDER BY full_name, year;

