
-- Part 1: Data Cleaning
-- Step 1: The raw data are all in VARCHAR. Convert each field into suitable data type
ALTER TABLE east_asia_top_artists
ALTER COLUMN top_track_popularity TYPE INT
USING (top_track_popularity :: Decimal);

ALTER TABLE east_asia_top_artists
ALTER COLUMN top_track_duration_ms TYPE INT
USING (top_track_popularity :: Decimal);

DELETE FROM east_asia_top_artists
WHERE LENGTH (top_track_release_date) < 9; 

ALTER TABLE east_asia_top_artists
ALTER COLUMN top_track_release_date TYPE DATE
USING (top_track_release_date :: DATE);

-- Step 2: Check Null/blank -> Delete
DELETE FROM east_asia_top_artists
WHERE artist_name IS NULL
OR popularity IS NULL
OR popularity IS NULL
OR followers IS NULL
OR artist_link IS NULL
OR genres IS NULL
OR top_track IS NULL
OR top_track_album IS NULL
OR top_track_popularity IS NULL
OR top_track_release_date IS NULL
OR top_track_duration_ms IS NULL
OR top_track_explicit IS NULL
OR top_track_album_link IS NULL
OR top_track_link IS NULL
OR query_genre IS NULL;

-- Step 3: Check duplicate
SELECT a.* 
FROM east_asia_top_artists a
JOIN
(
SELECT artist_name, COUNT (*)
FROM east_asia_top_artists
GROUP BY artist_name
HAVING COUNT (*) > 1 
) AS b
ON a.artist_name = b.artist_name
-- There are multiple duplicates due to the conflict of query_genre. We will drop this column and only use distinct artist name value
ALTER TABLE east_asia_top_artists
DROP COLUMN query_genre;

DELETE FROM east_asia_top_artists
WHERE ordernumber IN 
(
	SELECT MAX(a.ordernumber)
	FROM east_asia_top_artists a
	JOIN
	(
		SELECT artist_name, COUNT (*)
		FROM east_asia_top_artists
		GROUP BY artist_name
		HAVING COUNT (*) > 1 
	) AS b
	ON a.artist_name = b.artist_name
	GROUP BY a.artist_name
	ORDER BY MAX(a.ordernumber)
)
-- Part 2: Exploratory Dataset Analysis (EDA)
-- 1. **Distribution of Popularity Scores**:
-- How does the distribution of popularity scores differ between tracks and artists across different East Asian genres?
-- Are there any outliers in the popularity scores of tracks or artists within each genre, and if so, what could be the reasons behind them?
-- Which East Asian genre tends to have the highest median popularity score for tracks, and which has the lowest?

--2. **Relationship Between Track Duration and Popularity**:
-- Is there a correlation between track duration and popularity across different East Asian genres?
-- Are shorter or longer tracks generally more popular within each genre?
-- Are there any notable trends or patterns in the relationship between track duration and popularity when comparing genres?

-- 3. **Comparison of Artist Followers Across Genres**:
-- How does the distribution of artist followers vary across different East Asian genres?
-- Which genre tends to have artists with the highest average number of followers, and which has the lowest?
-- Are there any specific genres where artists with a smaller number of followers tend to produce more popular tracks?
