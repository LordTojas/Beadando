CREATE OR REPLACE VIEW Hasonlo_Erdek_Felhasznalok AS
SELECT 
    f1.id AS felh_id,
    f1.nev AS felh_nev,
    k1.kategoria AS erdeklodes
FROM 
    Kedvelt_Kategoriak k1
JOIN 
    Felhasznalo f1 ON k1.felhasznalo_id = f1.id
WHERE 
    EXISTS (
        SELECT 1
        FROM Kedvelt_Kategoriak k2
        WHERE 
            k2.kategoria = k1.kategoria 
            AND k2.felhasznalo_id != k1.felhasznalo_id
    )
GROUP BY 
    f1.id, f1.nev, k1.kategoria
ORDER BY 
    k1.kategoria, f1.id;

