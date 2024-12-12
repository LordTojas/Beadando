CREATE OR REPLACE TRIGGER trg_felhasznalo_aktiv_statusz
BEFORE INSERT ON Felhasznalo
FOR EACH ROW
BEGIN
   
    IF :NEW.statusz IS NULL THEN
        :NEW.statusz := 'Aktiv';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_esemeny_aktiv_statusz
BEFORE INSERT ON Esemeny
FOR EACH ROW
BEGIN
   
    IF :NEW.statusz IS NULL THEN
        :NEW.statusz := 'Aktiv';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_esemeny_inaktiv_statusz
AFTER UPDATE OF idotartam ON Esemeny
FOR EACH ROW
BEGIN
    
    IF SYSDATE > :NEW.idotartam THEN
        UPDATE Esemeny
        SET statusz = 'Inaktiv'
        WHERE id = :NEW.id;
    END IF;
END;
/
