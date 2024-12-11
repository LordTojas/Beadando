CREATE OR REPLACE TRIGGER trg_felhasznalo_id
BEFORE INSERT ON Felhasznalo
FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT felhasznalo_seq.NEXTVAL INTO :NEW.id FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_esemeny_id
BEFORE INSERT ON Esemeny
FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT esemeny_seq.NEXTVAL INTO :NEW.id FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_esemeny_kedveles_id
BEFORE INSERT ON Esemeny_Kedveles
FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT esemeny_kedveles_seq.NEXTVAL INTO :NEW.id FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_esemeny_regisztracio_id
BEFORE INSERT ON Esemeny_Regisztracio
FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT esemeny_regisztracio_seq.NEXTVAL INTO :NEW.id FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_helyszin_id
BEFORE INSERT ON Helyszin
FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT helyszin_seq.NEXTVAL INTO :NEW.id FROM DUAL;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_kedvelt_kategoriak_id
BEFORE INSERT ON Kedvelt_Kategoriak
FOR EACH ROW
BEGIN
    IF :NEW.id IS NULL THEN
        SELECT kedvelt_kategoriak_seq.NEXTVAL INTO :NEW.id FROM DUAL;
    END IF;
END;
/
