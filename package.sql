CREATE OR REPLACE PACKAGE FelhasznaloEsemenyKezeles AS
    PROCEDURE Felhasznalo_Regisztracio(
        p_nev IN VARCHAR2,
        p_email IN VARCHAR2,
        p_erdeklodesi_kor IN VARCHAR2,
        p_tartozkodasi_radiusz IN NUMBER,
        p_regisztracio_ideje IN DATE DEFAULT SYSDATE
    );

    PROCEDURE Felhasznalo_Torles(
        p_felhasznalo_id IN NUMBER
    );

    PROCEDURE Esemeny_Felvetel(
        p_nev IN VARCHAR2,
        p_korhatar IN NUMBER,
        p_erdeklodesi_kor IN VARCHAR2,
        p_tartozkodasi_radiusz IN NUMBER,
        p_esemeny_kezdete IN DATE,
        p_esemeny_vege IN DATE
    );

    PROCEDURE TorolEsemeny(
        p_esemeny_id IN NUMBER
    );
END FelhasznaloEsemenyKezeles;
/

CREATE OR REPLACE PACKAGE BODY FelhasznaloEsemenyKezeles AS
    PROCEDURE Felhasznalo_Regisztracio(
        p_nev IN VARCHAR2,
        p_email IN VARCHAR2,
        p_erdeklodesi_kor IN VARCHAR2,
        p_tartozkodasi_radiusz IN NUMBER,
        p_regisztracio_ideje IN DATE DEFAULT SYSDATE
    ) AS
    BEGIN
        INSERT INTO Felhasznalo (nev, email, erdeklodesi_kor, tartozkodasi_radiusz, regisztracio_ideje)
        VALUES (p_nev, p_email, p_erdeklodesi_kor, p_tartozkodasi_radiusz, p_regisztracio_ideje);
        DBMS_OUTPUT.PUT_LINE('Felhasználó sikeresen regisztrálva: ' || p_nev);
    END Felhasznalo_Regisztracio;

    PROCEDURE Felhasznalo_Torles(
        p_felhasznalo_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM Esemeny_Kedveles
        WHERE felhasznalo_id = p_felhasznalo_id;

        DELETE FROM Esemeny_Regisztracio
        WHERE felhasznalo_id = p_felhasznalo_id;

        DELETE FROM Kedvelt_Kategoriak
        WHERE felhasznalo_id = p_felhasznalo_id;

        DELETE FROM Felhasznalo
        WHERE id = p_felhasznalo_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Felhasználó törölve, ID: ' || p_felhasznalo_id);
    END Felhasznalo_Torles;

    PROCEDURE Esemeny_Felvetel(
        p_nev IN VARCHAR2,
        p_korhatar IN NUMBER,
        p_erdeklodesi_kor IN VARCHAR2,
        p_tartozkodasi_radiusz IN NUMBER,
        p_esemeny_kezdete IN DATE,
        p_esemeny_vege IN DATE
    ) AS
    BEGIN
        INSERT INTO Esemeny (nev, korhatar, erdeklodesi_kor, tartozkodasi_radiusz, esemeny_kezdete, esemeny_vege, statusz)
        VALUES (p_nev, p_korhatar, p_erdeklodesi_kor, p_tartozkodasi_radiusz, p_esemeny_kezdete, p_esemeny_vege, 'Aktív');
    END Esemeny_Felvetel;

    PROCEDURE TorolEsemeny(
        p_esemeny_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM Helyszin
        WHERE esemeny_id = p_esemeny_id;

        DELETE FROM Esemeny_Kedveles
        WHERE esemeny_id = p_esemeny_id;

        DELETE FROM Esemeny_Regisztracio
        WHERE esemeny_id = p_esemeny_id;

        DELETE FROM Esemeny
        WHERE id = p_esemeny_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Esemény törölve.');
    END TorolEsemeny;
END FelhasznaloEsemenyKezeles;
/

CREATE OR REPLACE PACKAGE EsemenyAjanlas AS
    PROCEDURE Ajanlott_Esemenyek(
        p_felhasznalo_id IN NUMBER,
        p_ajanlott_1 OUT NUMBER,
        p_ajanlott_2 OUT NUMBER
    );

    FUNCTION KivalasztEsemenyekRADIUSZ(
        p_radius IN NUMBER
    ) RETURN SYS_REFCURSOR;
END EsemenyAjanlas;
/

CREATE OR REPLACE PACKAGE BODY EsemenyAjanlas AS
    PROCEDURE Ajanlott_Esemenyek(
        p_felhasznalo_id IN NUMBER,
        p_ajanlott_1 OUT NUMBER,
        p_ajanlott_2 OUT NUMBER
    ) AS
    BEGIN
        SELECT e1.id, e2.id
        INTO p_ajanlott_1, p_ajanlott_2
        FROM Esemeny e1, Esemeny e2
        WHERE e1.erdeklodesi_kor = (
            SELECT kk.kategoria
            FROM Kedvelt_Kategoriak kk
            WHERE kk.felhasznalo_id = p_felhasznalo_id
        )
        AND e2.erdeklodesi_kor = e1.erdeklodesi_kor
        AND e1.id <> e2.id
        AND ROWNUM = 1;
    END Ajanlott_Esemenyek;

    FUNCTION KivalasztEsemenyekRADIUSZ(
        p_radius IN NUMBER
    ) RETURN SYS_REFCURSOR IS
        esemeny_cursor SYS_REFCURSOR;
    BEGIN
        OPEN esemeny_cursor FOR
        SELECT id, nev, tartozkodasi_radiusz
        FROM Esemeny
        WHERE tartozkodasi_radiusz <= p_radius;

        RETURN esemeny_cursor;
    END KivalasztEsemenyekRADIUSZ;
END EsemenyAjanlas;
/
