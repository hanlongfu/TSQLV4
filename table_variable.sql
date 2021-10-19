-------------------------------
-- Table Variables
-------------------------------

DECLARE @TempPeople TABLE 
(
    PersonName VARCHAR(MAX),
    PersonDate DATETIME
)

INSERT INTO @TempPeople
SELECT ActorName, ActorDOB
FROM tblActor
WHERE ActorDOB < '19500101'

SELECT * FROM @TempPeople