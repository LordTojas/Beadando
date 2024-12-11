CREATE OR REPLACE FUNCTION KivalasztEsemenyekRADIUSZ(p_radius IN NUMBER) RETURN SYS_REFCURSOR IS
    esemeny_cursor SYS_REFCURSOR;
BEGIN
    OPEN esemeny_cursor FOR
    SELECT id, nev, tartozkodasi_radiusz
    FROM Esemeny
    WHERE tartozkodasi_radiusz <= p_radius;

    RETURN esemeny_cursor;
END KivalasztEsemenyekRADIUSZ;
/
