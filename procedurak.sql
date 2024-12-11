CREATE OR REPLACE PROCEDURE Ajanlott_Esemenyek(
    p_felhasznalo_id IN NUMBER,
    p_ajanlott_1 OUT NUMBER,
    p_ajanlott_2 OUT NUMBER
) AS
BEGIN
    SELECT e1.id, e2.id
    INTO p_ajanlott_1, p_ajanlott_2
    FROM Esemeny e1, Esemeny e2
    WHERE e1.kategoria = (
        SELECT kk.kategoria
        FROM Kedvelt_Kategoriak kk
        WHERE kk.felhasznalo_id = p_felhasznalo_id
    )
    AND e2.kategoria = e1.kategoria
    AND e1.id <> e2.id
    AND ROWNUM = 1;
END;
/

CREATE OR REPLACE PROCEDURE Felhasznalo_Regisztracio(
    p_nev IN VARCHAR2,
    p_email IN VARCHAR2,
    p_erdeklodesi_kor IN VARCHAR2,
    p_tartozkodasi_radiusz IN NUMBER
) AS
BEGIN
    INSERT INTO Felhasznalo (nev, email, erdeklodesi_kor, tartozkodasi_radiusz)
    VALUES (p_nev, p_email, p_erdeklodesi_kor, p_tartozkodasi_radiusz);
END;
/

CREATE OR REPLACE PROCEDURE Esemeny_Felvetel(
    p_marka IN VARCHAR2,
    p_tipus IN VARCHAR2,
    p_kategoria IN VARCHAR2,
    p_idotartam IN INTERVAL DAY TO SECOND,
    p_helyszin_id IN NUMBER
) AS
BEGIN
    INSERT INTO Esemeny (marka, tipus, kategoria, idotartam, helyszin_id)
    VALUES (p_marka, p_tipus, p_kategoria, p_idotartam, p_helyszin_id);
END;
/

CREATE OR REPLACE PROCEDURE TorolFelhasznalo (p_felhasznalo_id IN NUMBER) IS
    v_count NUMBER;
BEGIN
    -- Nézetben érintett rekordok száma törlés elõtt
    SELECT COUNT(*)
    INTO v_count
    FROM Hasonlo_Erdek_Felhasznalok
    WHERE felh_id = p_felhasznalo_id;

    DBMS_OUTPUT.PUT_LINE('A nézetben érintett rekordok száma: ' || v_count);

    -- Kapcsolódó kedvelések törlése
    DELETE FROM Esemeny_Kedveles
    WHERE felhasznalo_id = p_felhasznalo_id;

    -- Kapcsolódó regisztrációk törlése
    DELETE FROM Esemeny_Regisztracio
    WHERE felhasznalo_id = p_felhasznalo_id;

    -- Kedvelt kategóriák törlése
    DELETE FROM Kedvelt_Kategoriak
    WHERE felhasznalo_id = p_felhasznalo_id;

    -- Felhasználó törlése
    DELETE FROM Felhasznalo
    WHERE id = p_felhasznalo_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Felhasználó törölve.');
END TorolFelhasznalo;
/

CREATE OR REPLACE PROCEDURE TorolEsemeny (p_esemeny_id IN NUMBER) IS
BEGIN
    -- Kapcsolódó helyszínek törlése
    DELETE FROM Helyszin
    WHERE esemeny_id = p_esemeny_id;

    -- Kapcsolódó kedvelések törlése
    DELETE FROM Esemeny_Kedveles
    WHERE esemeny_id = p_esemeny_id;

    -- Kapcsolódó regisztrációk törlése
    DELETE FROM Esemeny_Regisztracio
    WHERE esemeny_id = p_esemeny_id;

    -- Esemény törlése
    DELETE FROM Esemeny
    WHERE id = p_esemeny_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Esemény törölve.');
END TorolEsemeny;
/
