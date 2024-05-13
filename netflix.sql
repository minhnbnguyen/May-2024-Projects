-- Adding table
CREATE TABLE Netflix
(
	show_id VARCHAR PRIMARY KEY,
	type_ VARCHAR,
	title VARCHAR,
	director VARCHAR,
	cast_ VARCHAR,
	country VARCHAR,
	date_added DATE,
	release_year VARCHAR,
	rating ENUM VARCHAR,
  duration_ VARCHAR,
  listed_in VARCHAR,
  description VARCHAR
)
-- EAD: 1. Geography Analysis
-- What content is available in different countries? What content is the most popular? How many shows in each country?
WITH show_categories AS
(
	SELECT
	show_id,
	regexp_split_to_table(listed_in, E', ') AS show_type
	FROM netflix_titles
),
show_country AS
(
	SELECT show_id,
	regexp_split_to_table(TRIM (country_), E', ') AS show_country
	FROM
	(
	SELECT show_id,
		CASE
		WHEN LEFT (country,1) = ',' THEN RIGHT (country,LENGTH(country)-1)
		WHEN RIGHT (country,1) = ',' THEN LEFT (country, LENGTH(country)-1)
		ELSE country
		END AS country_
	FROM netflix_titles
	) AS a
)
SELECT
*
FROM
show_country AS b JOIN show_categories AS c
ON b.show_id = c.show_id
-- Few insights: United States has the most shows, with dramas being the most popular genre. Lack of shows based in Africa. 
