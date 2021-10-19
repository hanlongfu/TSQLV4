----------------------------------------
-- User Defined Function
----------------------------------------
USE Movies
GO

ALTER FUNCTION fnLongDate    -- user CREATE FUNCTION <functionName>
(
    @FullDate AS DATETIME
)
RETURNS VARCHAR(MAX)    -- different from stored procedure, a return statement is always needed
AS 
BEGIN
    RETURN DATENAME(DW, @FullDate) + ' ' + 
           DATENAME(D, @FullDate) + 
           CASE 
             WHEN DAY(@FullDate) IN (1, 21, 31) THEN 'st'
             WHEN DAY(@FullDate) IN (2, 22) THEN 'nd'
             WHEN DAY(@FullDate) IN (3, 23) THEN 'rd'
             ELSE 'th'
            END
            + ' ' +
           DATENAME(M, @FullDate) + ' ' + 
           DATENAME(YY, @FullDate) 
END

GO
-- call the function
SELECT 
    FilmName
    ,FilmReleaseDate
    ,dbo.fnLongDate(FilmReleaseDate)
FROM tblFilm;



GO
-- create a function to separate full name into first and last name
CREATE FUNCTION fnFirstName
(
    @FullName AS VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS 
BEGIN
    DECLARE @SpacePosition AS INT 
    DECLARE @Answer AS VARCHAR(MAX)

    SET @SpacePosition = CHARINDEX(' ', @FullName)
    
    --use if to handle individuals with just a first name
    IF @SpacePosition = 0
        SET @Answer = @FullName
    ELSE 
        SET @Answer = LEFT(@FullName, @SpacePosition -1)

    RETURN @Answer
END

GO
-- call the function again
SELECT 
    ActorName
    ,dbo.fnFirstName(ActorName)   -- function is attached to a schema
FROM tblActor
