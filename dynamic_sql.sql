
-- Using dynamic SQL

EXEC ('SELECT * FROM tblFilm')

-- or (more efficient)
EXEC sp_executesql N'SELECT * FROM tblFilm'


GO
DECLARE @TableName NVARCHAR(128)
DECLARE @SQLString NVARCHAR(MAX)

SET @TableName = N'tblFilm'
SET @SQLString = N'SELECT * FROM ' + @TableName

EXEC sp_executesql @SQLString


-- Dynamic SQL and the IN operator
GO
CREATE PROC spFilmYears
(
    @YearList NVARCHAR(MAX)
)
AS 
BEGIN
    DECLARE @SQLString NVARCHAR(MAX)

    SET @SQLString = 
        'SELECT *
        FROM tblFilm
        WHERE YEAR(FilmReleaseDate) IN (' + @YearList + ')
        ORDER BY FilmReleaseDate'
    
    EXEC sp_executesql @SQLString
END

EXEC spFilmYears '2000, 2001, 2002'