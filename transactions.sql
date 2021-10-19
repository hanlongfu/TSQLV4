USE Movies;
GO;

-- Commiting Transactions

BEGIN TRANSACTION AddIronMan3;

INSERT 
    INTO tblFilm(FilmName, FilmReleaseDate) 
VALUES
    ('Iron Man 3', '20130425');

COMMIT TRANSACTION AddIronMan3;


-- Rolling Back Transactions
BEGIN TRANSACTION RollBackOps;

INSERT 
    INTO tblFilm(FilmName, FilmReleaseDate) 
VALUES
    ('Iron Man 3', '20130425');

SELECT * FROM tblFilm WHERE FilmName = 'Iron Man 3'

ROLLBACK TRANSACTION RollBackOps;

SELECT * FROM tblFilm WHERE FilmName = 'Iron Man 3'

-- Conditional Rolling Back

DECLARE @IRONMAN INT 

BEGIN TRAN AddIronMan3

INSERT INTO tblFilm(FilmName, FilmReleaseDate)
VALUES('Iron Man 3', '20130425');

SELECT @IRONMAN = COUNT(*) FROM tblFilm WHERE FilmName = 'Iron Man 3';

IF @IRONMAN > 1
    BEGIN
        ROLLBACK TRAN AddIronMan3
        PRINT 'Iron Man 3 already existed in the database'
    END
ELSE 
    BEGIN
        COMMIT TRAN AddIronMan3
        PRINT 'Iron Man 3 added to database'
    END

-- Error Handling
-- if two operations occur at the same time and one fails, both rolled back by default by SQL
-- USE TRY CATCH Block
GO
BEGIN TRY
    BEGIN TRAN AddIM

    -- operation 1
    INSERT INTO tblFilm(FilmName, FilmReleaseDate)
    VALUES('Iron Man 3', '20130425')

    --operation 2
    UPDATE tblFilm
    SET FilmDirectorID = 'Shane Black'
    WHERE FilmName = 'Iron Man 3'

    COMMIT TRAN AddIM

END TRY
BEGIN CATCH
    ROLLBACK TRAN AddIM
    PRINT 'Adding IRON Man Failed - Check data types'
END CATCH

SELECT * FROM tblFilm WHERE FilmName = 'Iron Man 3';

-- Rollback to a save point
GO
CREATE PROC spGetDirector
(
    @DirectorName VARCHAR(MAX)
)
AS 
BEGIN
    DECLARE @ID INT 

    SAVE TRAN AddDirector

    INSERT INTO tblDirector (DirectorName)
    VALUES (@DirectorName)

    IF (SELECT COUNT(*) FROM tblDirector WHERE DirectorName = @DirectorName) > 1
        BEGIN
            PRINT 'Director Already existed'
            ROLLBACK TRAN AddDirector
        END
    
    SELECT @ID = DirectorID FROM tblDirector WHERE DirectorName = @DirectorName

    RETURN @ID
END

EXEC spGetDirector 'Shane Black'