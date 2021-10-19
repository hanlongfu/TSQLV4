USE Movies;
GO;
-- Declaring a cursor

DECLARE FilmCursor CURSOR
    FOR SELECT FilmID, FilmName, FilmReleaseDate FROM tblFilm;

-- open cursor
OPEN FilmCursor

    -- do something
    FETCH NEXT FROM FilmCursor

    WHILE @@FETCH_STATUS = 0  -- successful returns 0
        FETCH NEXT FROM FilmCursor

-- close cursor
CLOSE FilmCursor
DEALLOCATE FilmCursor
