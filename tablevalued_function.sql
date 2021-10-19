USE Movies
GO

-------------------------------------
-- Single-valued table function
-------------------------------------

CREATE FUNCTION FilmsInYear
(
    @FilmYear INT
)
RETURNS TABLE 
AS
    RETURN 
        SELECT FilmName, FilmReleaseDate, FilmRunTimeMinutes
        FROM tblFilm
        WHERE YEAR(FilmReleaseDate) = @FilmYear
GO
-- call the function
SELECT FilmName, FilmReleaseDate, FilmRunTimeMinutes
FROM dbo.FilmsInYear(1999);

-------------------------------------
-- Multi-valued table function
-------------------------------------

GO
CREATE FUNCTION PeopleInYear
(
    @BirthYear INT

)
RETURNS @t TABLE    -- define the table (with multiple columns)
(
    PersonName VARCHAR(MAX),
    PersonDOB DATETIME,
    PersonJOB VARCHAR(8)
)
AS 
BEGIN
    -- 1
    INSERT INTO @t
    SELECT
        DirectorName,
        DirectorDOB,
        'Director'
    FROM tblDirector
    WHERE YEAR(DirectorDOB) = @BirthYear


    -- 2
    INSERT INTO @t
    SELECT
        actorName,
        actorDOB,
        'Actor'
    FROM tblActor
    WHERE YEAR(actorDOB) = @BirthYear

    RETURN
END  

-- call the function
GO

SELECT * 
FROM dbo.PeopleInYear(1945);

