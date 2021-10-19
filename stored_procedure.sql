USE TSQLV4
GO  -- begins a new batch
;

CREATE PROC numOfOrdersPerCustomer
AS 
BEGIN
    SELECT count(Distinct orderid) AS numoforders
    FROM Sales.Orders
    GROUP BY custid
    ORDER BY custid
END
;

EXECUTE numOfOrdersPerCustomer;

-- to make modifications
ALTER PROC numOfOrdersPerCustomer;

-- to delete a procedure
DROP PROC numOfOrdersPerCustomer;

----------------------------------------
-- ADD PARAMETERS
----------------------------------------
USE Movies
GO

ALTER PROC dbo.spFilmCriteria
(
    @MinLength AS INT = NULL,   -- NULL is the default value
    @MaxLength AS INT = NULL,   -- NULL is the default
    @Title AS VARCHAR(MAX)
)
AS 
BEGIN
    SELECT FilmName, FilmRunTimeMinutes
    FROM tblFilm
    WHERE 
        (@MinLength IS NULL OR FilmRunTimeMinutes >= @MinLength) AND
        (@MaxLength IS NULL OR FilmRunTimeMinutes <= @MaxLength) AND
        FilmName LIKE '%'+@Title+'%'
    ORDER BY FilmRunTimeMinutes ASC 
END;

EXECUTE dbo.spFilmCriteria @Title = 'star'

----------------------------------------
-- Variables
----------------------------------------

DECLARE @MyDate AS DATETIME    -- declare a variable


SET @MyDate = '1970-01-01'       -- set value to variable

SELECT FilmName AS Name, FilmReleaseDate AS Date, 'Film' AS Type
FROM tblFilm
WHERE FilmReleaseDate >= @MyDate

----------------------------------------
-- Storing results in variables
----------------------------------------

DECLARE @NumFilms AS INT;
SET @NumFilms = 
(
    SELECT COUNT(*) 
    FROM tblFilm 
    WHERE FilmReleaseDate >= @MyDate
);

SELECT 'Number of Films', @NumFilms 

----------------------------------------
-- Select results into variables
----------------------------------------
DECLARE @ID INT
DECLARE @Name VARCHAR(MAX)
DECLARE @Date DATETIME

SELECT TOP(1) 
    @ID = ActorID,
    @Name = ActorName,
    @Date = ActorDOB
FROM 
    tblActor
WHERE 
    ActorDOB >= '19700101'
ORDER BY 
    ActorDOB
;


----------------------------------------
-- Select results into a List variable
----------------------------------------

DECLARE @NameList VARCHAR(MAX)
SET @NameList = ''

SELECT 
    @NameList = @NameList + ActorName + ', '
FROM 
    tblActor
WHERE 
    YEAR(ActorDOB) = 1970

PRINT @NameList 


----------------------------------------
-- Global Variables
----------------------------------------
SELECT @@VariableName -- predefined


----------------------------------------
-- Output Parameters 
----------------------------------------
USE MOVIES
GO

ALTER PROC spFilmsInYear
(
    @YEAR INT,
    @FilmList VARCHAR(MAX) OUTPUT,  -- output parameters
    @FilmCOUNT INT OUTPUT
)
AS 
BEGIN
    DECLARE @Films VARCHAR(MAX)  -- declare variable to store list
    SET @Films = ''              -- declare variable to store list

    SELECT @Films = @Films + FilmName + ', '
    FROM tblFilm
    WHERE YEAR(FilmReleaseDate) = @YEAR
    ORDER BY FilmName 

    SET @FilmCOUNT = @@ROWCOUNT
    SET @FilmList = @Films 
END

DECLARE @Names VARCHAR(MAX)   -- declare variable to accept output
DECLARE @COUNT INT

EXEC spFilmsInYear 
    @YEAR = 2000,
    @FilmList = @Names OUTPUT,
    @FilmCOUNT = @COUNT OUTPUT

-- Display Results
SELECT @Names AS 'Number of Films'


----------------------------------------
-- IF STATEMENT
----------------------------------------

DECLARE @NumFilms INT

SET @NumFilms = (SELECT COUNT(*) FROM tblFilm WHERE FilmGenreID = 3)

IF @NumFilms > 5
    -- if you have multiple statements, use BEGIN -- END to envelope them
    PRINT 'There are at least 1 romantic film in the database'
ELSE
    PRINT 'There are no more than 5 romantic film in the database'


-- use if statements in select
USE Movies
GO

ALTER PROC spVariableData
(
    @InfoType VARCHAR(9)     -- this can be ALL, AWARD, or FINANCIAL
)
AS
BEGIN
    IF @InfoType = 'ALL'
        BEGIN
            (SELECT * FROM tblFilm)
            RETURN      -- stop executing the procedure
        END

    IF @InfoType = 'AWARD'
        BEGIN
            (SELECT FilmName, FilmOscarWins, FilmOscarNominations FROM tblFilm)
        END
    
    -- if previous two fails
    SELECT 'You must choose ALL, AWARD or FINANCIAL'
END 


----------------------------------------
-- WHILE LOOP
----------------------------------------

DECLARE @COUNTER INT 
DECLARE @MaxOscars INT
DECLARE @NumFilms INT

SET @COUNTER = 0
SET @MaxOscars = (SELECT MAX(FilmOscarWins) FROM tblFilm)

WHILE @COUNTER <= @MaxOscars
    BEGIN 
        SET @NumFilms = 
        (
            SELECT COUNT(*) FROM tblFilm WHERE FilmOscarWins = @COUNTER
        )
        IF @NumFilms = 0 BREAK    -- exit out of the loop
    
        PRINT CAST(@NumFilms AS VARCHAR(3)) + ' films have won ' + CAST(@COUNTER AS VARCHAR(2)) + ' Oscars.'

        SET @COUNTER = @COUNTER + 1
    END


