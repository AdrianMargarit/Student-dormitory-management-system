------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-------------------------------------------- ADRIAN MARGARIT -----------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
--------------------------------- STUDENT DORMITORY MANAGEMENT SYSTEM --------------------------------------
---------------------------------------------- EXERCISES ---------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------


-- INNER JOIN -- EXERCITIUL 1

SELECT STUDENT.COD_STUDENT, STUDENT.NUME_STUDENT, STUDENT.PRENUME_STUDENT, FACULTATE.NUME_FACULTATE, FACULTATE.SECTIE_FACULTATE
FROM STUDENT
INNER JOIN FACULTATE
ON STUDENT.COD_STUDENT = FACULTATE.COD_STUDENT
ORDER BY STUDENT.NUME_STUDENT;

-- INNER JOIN MULTIPLU -- EXERCITIUL 2

SELECT STUDENT.NUME_STUDENT, STUDENT.PRENUME_STUDENT, CONTACT.NR_TELEFON_STUDENT, CONTACT.EMAIL_STUDENT, CONTACT.ADRESA_STUDENT, JURNAL_STUDENT.DATA_CAZARII,
JURNAL_STUDENT.STAREA_CAMEREI_PRIMIRE, JURNAL_STUDENT.DATA_DECAZARII, JURNAL_STUDENT.STAREA_CAMEREI_PLECARE, JURNAL_STUDENT.ABATERI_REGULAMENT
FROM STUDENT
INNER JOIN CONTACT
ON STUDENT.COD_STUDENT = CONTACT.COD_STUDENT
INNER JOIN JURNAL_STUDENT
ON STUDENT.COD_STUDENT = JURNAL_STUDENT.COD_STUDENT
ORDER BY STUDENT.NUME_STUDENT;

-- OUTER JOIN -- EXERCITIUL 3

SELECT SALARIAT.COD_SALARIAT, SALARIAT.SALARIU_RON, SALARIAT.SEX_SALARIAT, TELEFON.NR_TELEFON_SALARIAT
FROM SALARIAT
FULL OUTER JOIN TELEFON
ON SALARIAT.COD_SALARIAT = TELEFON.COD_SALARIAT
ORDER BY SALARIAT.SALARIU_RON;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- QUERY NO. 1 --

SELECT SALARIAT.COD_SALARIAT, SALARIAT.SALARIU_RON, SALARIAT.SEX_SALARIAT, CORP_CAMIN.COD_CORP_CAMIN, CORP_CAMIN.COD_CAMIN, DEPARTAMENT.COD_DEPARTAMENT, DEPARTAMENT.NUME_DEPARTAMENT
FROM SALARIAT
INNER JOIN SALARIAT_LUCREAZA_IN
ON SALARIAT.COD_SALARIAT = SALARIAT_LUCREAZA_IN.COD_SALARIAT
INNER JOIN CORP_CAMIN
ON SALARIAT_LUCREAZA_IN.COD_CORP_CAMIN = CORP_CAMIN.COD_CORP_CAMIN
FULL OUTER JOIN DEPARTAMENT
ON CORP_CAMIN.COD_DEPARTAMENT = DEPARTAMENT.COD_DEPARTAMENT
WHERE SALARIAT.SALARIU_RON > ALL (SELECT SALARIAT.SALARIU_RON
                                    FROM SALARIAT
                                    WHERE SALARIAT.SALARIU_RON = 3500)
ORDER BY SALARIAT.SALARIU_RON DESC;

-- QUERY NO. 2 --

SELECT SALARIAT.COD_SALARIAT, SALARIAT.SALARIU_RON, SALARIAT.SEX_SALARIAT, CORP_CAMIN.COD_CORP_CAMIN, CORP_CAMIN.COD_CAMIN, DEPARTAMENT.COD_DEPARTAMENT, DEPARTAMENT.NUME_DEPARTAMENT
FROM SALARIAT
INNER JOIN SALARIAT_CONDUCE
ON SALARIAT.COD_SALARIAT = SALARIAT_CONDUCE.COD_SALARIAT
INNER JOIN CORP_CAMIN
ON SALARIAT_CONDUCE.COD_CORP_CAMIN = CORP_CAMIN.COD_CORP_CAMIN
FULL OUTER JOIN DEPARTAMENT
ON CORP_CAMIN.COD_DEPARTAMENT = DEPARTAMENT.COD_DEPARTAMENT
WHERE DEPARTAMENT.NUME_DEPARTAMENT IN (SELECT DEPARTAMENT.NUME_DEPARTAMENT
                                        FROM DEPARTAMENT
                                        WHERE DEPARTAMENT.NUME_DEPARTAMENT = 'Administratie');
                                        
-- QUERY NO. 3 --

SELECT SALARIAT.COD_SALARIAT, SALARIAT.SALARIU_RON, SALARIAT.SEX_SALARIAT, CORP_CAMIN.COD_CORP_CAMIN, CORP_CAMIN.COD_CAMIN, DEPARTAMENT.COD_DEPARTAMENT, DEPARTAMENT.NUME_DEPARTAMENT
FROM SALARIAT
INNER JOIN SALARIAT_LUCREAZA_IN
ON SALARIAT.COD_SALARIAT = SALARIAT_LUCREAZA_IN.COD_SALARIAT
INNER JOIN CORP_CAMIN
ON SALARIAT_LUCREAZA_IN.COD_CORP_CAMIN = CORP_CAMIN.COD_CORP_CAMIN
FULL OUTER JOIN DEPARTAMENT
ON CORP_CAMIN.COD_DEPARTAMENT = DEPARTAMENT.COD_DEPARTAMENT
WHERE SALARIAT.SALARIU_RON IN (SELECT AVG(SALARIAT.SALARIU_RON)
                                FROM SALARIAT
                                WHERE SALARIAT.SALARIU_RON <= 6000
                                GROUP BY SALARIAT.SALARIU_RON)
ORDER BY SALARIAT.SALARIU_RON DESC;

-- QUERY NO. 4 --

SELECT STUDENT.NUME_STUDENT, STUDENT.PRENUME_STUDENT, FACULTATE.NUME_FACULTATE, FACULTATE.SECTIE_FACULTATE,
CONTACT.NR_TELEFON_STUDENT, CONTACT.EMAIL_STUDENT, CONTACT.ADRESA_STUDENT, JURNAL_STUDENT.ABATERI_REGULAMENT
FROM STUDENT
FULL OUTER JOIN FACULTATE
ON STUDENT.COD_STUDENT = FACULTATE.COD_STUDENT
INNER JOIN CONTACT
ON STUDENT.COD_STUDENT = CONTACT.COD_STUDENT
INNER JOIN JURNAL_STUDENT
ON STUDENT.COD_STUDENT = JURNAL_STUDENT.COD_STUDENT
WHERE JURNAL_STUDENT.ABATERI_REGULAMENT IN (SELECT JURNAL_STUDENT.ABATERI_REGULAMENT
                                            FROM JURNAL_STUDENT
                                            GROUP BY JURNAL_STUDENT.ABATERI_REGULAMENT)
ORDER BY STUDENT.NUME_STUDENT ASC;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- CURSOR --

SET SERVEROUTPUT ON;

DECLARE 
    N_NUME_STUDENT STUDENT.NUME_STUDENT%TYPE;
    P_PRENUME_STUDENT STUDENT.PRENUME_STUDENT%TYPE;
    A_ADRESA_STUDENT CONTACT.ADRESA_STUDENT%TYPE;
BEGIN
    SELECT NUME_STUDENT, PRENUME_STUDENT, ADRESA_STUDENT
        INTO N_NUME_STUDENT, P_PRENUME_STUDENT, A_ADRESA_STUDENT
        FROM STUDENT, CONTACT
        WHERE STUDENT.COD_STUDENT = CONTACT.COD_STUDENT
            AND STUDENT.COD_STUDENT = 167543;
    DBMS_OUTPUT.PUT_LINE(
        N_NUME_STUDENT ||' '||
        P_PRENUME_STUDENT ||
        ' are adresa ' ||
        A_ADRESA_STUDENT);
END;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNCTIE --

SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION NUMELE_CAMINULUI(nume IN VARCHAR2)
RETURN VARCHAR2
IS
NUME_CAMIN VARCHAR2(30);

BEGIN
    BEGIN
        SELECT NUME_CORP_CAMIN
        INTO NUME_CAMIN
        FROM CAMIN
        WHERE CAMIN.NUME_CORP_CAMIN = nume
        AND CAMIN.NUME_CORP_CAMIN = 'CORP A';
        EXCEPTION
            WHEN too_many_rows THEN
            dbms_output.put_line('Errors fetching are more than one');
    END;
RETURN NUME_CAMIN;
END;
    
CREATE OR REPLACE FUNCTION CAMERE_CAMIN(camere IN VARCHAR2)
RETURN VARCHAR2
IS
NUMAR_CAMERA VARCHAR2(20);

BEGIN
    BEGIN
        SELECT CAMERA.NR_CAMERA
        INTO NUMAR_CAMERA
        FROM CAMERA
        INNER JOIN OCUPANTI
        ON CAMERA.NR_CAMERA = OCUPANTI.NR_CAMERA
        WHERE CAMERA.NR_CAMERA = camere
        AND CAMERA.NR_CAMERA = 'A_101';
        EXCEPTION
            WHEN too_many_rows THEN
            dbms_output.put_line('Errors fetching are more than one');
    END;
RETURN NUMAR_CAMERA;
END;

CREATE OR REPLACE FUNCTION NUMAR_OCUPANTI(ocupanti_pe_camera IN NUMBER)
RETURN NUMBER
IS
CAMERA_OCUPANTI NUMBER;

BEGIN
    BEGIN
        SELECT NR_OCUPANTI
        INTO CAMERA_OCUPANTI
        FROM OCUPANTI
        INNER JOIN CAMERA
        ON OCUPANTI.NR_CAMERA = CAMERA.NR_CAMERA
        WHERE OCUPANTI.NR_OCUPANTI = ocupanti_pe_camera
        AND OCUPANTI.NR_OCUPANTI = 5;
        EXCEPTION
            WHEN too_many_rows THEN
            dbms_output.put_line('Errors fetching are more than one');
    END;
RETURN CAMERA_OCUPANTI;
END;

SET SERVEROUTPUT ON;

DECLARE 
    N_NUME VARCHAR2(30);
    N_CAMERA VARCHAR2(20);
    N_OCUPANTI NUMBER(10);
BEGIN
    N_NUME := NUMELE_CAMINULUI('CORP A');
    DBMS_OUTPUT.PUT_LINE('Corpul caminului unde se afla camera este: ' ||N_NUME);
    N_CAMERA := CAMERE_CAMIN('A_101');
    DBMS_OUTPUT.PUT_LINE('Camera este: ' ||N_CAMERA);
    N_OCUPANTI := NUMAR_OCUPANTI(5);
    DBMS_OUTPUT.PUT_LINE('In camera stau: ' ||N_OCUPANTI||' studenti.');
END;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- PROCEDURA --

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE SALARIU_ANGAJAT(total_salariu IN OUT SALARIAT.SALARIU_RON%TYPE)
IS

BEGIN
    SELECT SALARIU_RON
    INTO total_salariu
    FROM SALARIAT
    INNER JOIN VANZATOARE
    ON SALARIAT.COD_SALARIAT = VANZATOARE.COD_SALARIAT
    WHERE SALARIAT.SALARIU_RON = total_salariu
    AND SALARIAT.SALARIU_RON = 3500;
END;
/

CREATE OR REPLACE PROCEDURE S_VANZATOARE(nume_vanzatoare IN OUT VANZATOARE.NUME_SALARIAT%TYPE, prenume_vanzatoare IN OUT VANZATOARE.PRENUME_SALARIAT%TYPE)
IS

BEGIN
    SELECT NUME_SALARIAT, PRENUME_SALARIAT
    INTO nume_vanzatoare, prenume_vanzatoare
    FROM VANZATOARE
    INNER JOIN SALARIAT
    ON VANZATOARE.COD_SALARIAT = SALARIAT.COD_SALARIAT
    WHERE VANZATOARE.NUME_SALARIAT = nume_vanzatoare
    AND VANZATOARE.PRENUME_SALARIAT = prenume_vanzatoare
    AND VANZATOARE.NUME_SALARIAT = 'Grama'
    AND VANZATOARE.PRENUME_SALARIAT = 'Diana';
END;
/

CREATE OR REPLACE PROCEDURE NR_TEL (numar_tel IN OUT TELEFON.NR_TELEFON_SALARIAT%TYPE)
IS

BEGIN
    SELECT NR_TELEFON_SALARIAT
    INTO numar_tel
    FROM TELEFON
    INNER JOIN SALARIAT
    ON TELEFON.COD_SALARIAT = SALARIAT.COD_SALARIAT
    WHERE TELEFON.NR_TELEFON_SALARIAT = numar_tel
    AND TELEFON.NR_TELEFON_SALARIAT = 0721743768;
END;
/

CREATE OR REPLACE PROCEDURE NUME_DEP(denumire_departament IN OUT DEPARTAMENT.NUME_DEPARTAMENT%TYPE)
IS

BEGIN
    SELECT NUME_DEPARTAMENT
    INTO denumire_departament
    FROM DEPARTAMENT
    WHERE DEPARTAMENT.NUME_DEPARTAMENT = denumire_departament
    AND DEPARTAMENT.NUME_DEPARTAMENT = 'Cantina';
END;
/

CREATE OR REPLACE PROCEDURE N_CORP(nm_crp_cmn IN OUT CAMIN.NUME_CORP_CAMIN%TYPE)
IS

BEGIN
    SELECT NUME_CORP_CAMIN
    INTO nm_crp_cmn
    FROM CAMIN
    WHERE CAMIN.NUME_CORP_CAMIN = nm_crp_cmn
    AND CAMIN.NUME_CORP_CAMIN = 'Corp A';
END;
/

SET SERVEROUTPUT ON;

DECLARE
    nume_vanzatoare VANZATOARE.NUME_SALARIAT%TYPE := 'Grama';
    prenume_vanzatoare VANZATOARE.PRENUME_SALARIAT%TYPE := 'Diana';
    denumire_departament DEPARTAMENT.NUME_DEPARTAMENT%TYPE := 'Cantina';
    total_salariu SALARIAT.SALARIU_RON%TYPE := 3500;
    numar_tel TELEFON.NR_TELEFON_SALARIAT%TYPE := 0721743768;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Salariata ' ||nume_vanzatoare||' '||prenume_vanzatoare||' lucreaza ca vanzatoare in cadrul departamentului '||denumire_departament||', pe un salariu de '||total_salariu||'RON.');
    DBMS_OUTPUT.PUT_LINE(nume_vanzatoare||' '||prenume_vanzatoare||' are numarul de telefon '||numar_tel||'.');
END;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TRIGGER LA NIVEL DE LINIE --

CREATE TABLE audit_studenti (
    cod_audit NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nume_tabel VARCHAR2(300),
    nume_prenume_student VARCHAR2(60),
    by_user VARCHAR2(30),
    data_schimbarii DATE
);

CREATE OR REPLACE TRIGGER trigg_audit_studenti
    AFTER
    UPDATE OR DELETE
    ON JURNAL_STUDENT
    FOR EACH ROW
DECLARE
    l_np_student VARCHAR2(60);
BEGIN
    l_np_student := CASE
        WHEN UPDATING THEN 'UPDATE'
        WHEN DELETING THEN 'DELETE'
    END;
    INSERT INTO audit_studenti(nume_tabel, nume_prenume_student, by_user, data_schimbarii)
    VALUES ('JURNAL_STUDENT', l_np_student, USER, SYSDATE);
END;
/
    
UPDATE
    JURNAL_STUDENT
SET
    STAREA_CAMEREI_PLECARE = 'Stare proasta'
WHERE
    COD_STUDENT = 121542;

SELECT * FROM audit_studenti;    
    
DELETE FROM JURNAL_STUDENT
WHERE COD_STUDENT = 121542; 

SELECT * FROM audit_studenti;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TRIGGER LA NIVEL DE COMANDA --

CREATE TABLE audit_salariati (
    cod_audit NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    nume_tabel VARCHAR2(300),
    nume_prenume_salariat VARCHAR2(60),
    by_user VARCHAR2(30),
    data_schimbarii DATE
);

CREATE OR REPLACE TRIGGER trigg_audit_salariati
    AFTER
    UPDATE OR DELETE
    ON SALARIAT
DECLARE
    l_np_salariat VARCHAR2(60);
BEGIN
    l_np_salariat := CASE
        WHEN UPDATING THEN 'UPDATE'
        WHEN DELETING THEN 'DELETE'
    END;
    INSERT INTO audit_salariati(nume_tabel, nume_prenume_salariat, by_user, data_schimbarii)
    VALUES ('JURNAL_STUDENT', l_np_salariat, USER, SYSDATE);
END;
/
    
UPDATE
    SALARIAT
SET
    SALARIU_RON = 5500
WHERE
    COD_SALARIAT = 300423;

SELECT * FROM audit_salariati;
    