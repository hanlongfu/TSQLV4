-- temporary tables are stored inside the systems database
-- temporary tables are specific to a connection (deleted when disconnected)
-- use ##tempTableName to create global temporary table 

-------------------------------
-- Temporary Tables Approach 1
-------------------------------
USE Movies
GO

SELECT FilmName, FilmReleaseDate
INTO #tmpFilms                      -- temporary table
FROM tblFilm
WHERE FilmName LIKE '%star%';

SELECT * FROM #tmpFilms;


-------------------------------
-- Temporary Tables Approach 2
-------------------------------
CREATE TABLE #tmpFilms2
(
    Title VARCHAR(MAX),
    ReleaseDate DATETIME
)
INSERT INTO #tmpFilms2
SELECT FilmName, FilmReleaseDate
FROM tblFilm
WHERE FilmName LIKE '%star%';

SELECT * FROM #tmpFilms2;


