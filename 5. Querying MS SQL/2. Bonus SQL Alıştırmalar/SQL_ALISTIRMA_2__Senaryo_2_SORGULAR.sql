-- 1. HR isimli bir veritaban� olu�turunuz.
-- Olu�turdu�umuz Tablolar� Sorgulayal�m:
SELECT * FROM PERSON
SELECT * FROM DEPARTMENT
SELECT * FROM POSITION


-- 2. �irketimizde halen �al��maya devam eden �al��anlar�n listesini getiren sorgu hangisidir?
-- Not: ��ten ��k�� tarihi bo� olanlar �al��maya devam eden �al��anlard�r.
SELECT * FROM PERSON
WHERE OUTDATE IS NULL


-- 3. �irketimizde departman bazl� halen �al��maya devam eden �al��an say�s�n� getiren sorguyu yaz�n�z?
SELECT 
D.DEPARTMENT,
COUNT(D.DEPARTMENT) AS CALISANSAYISI
FROM PERSON P 

JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID

WHERE OUTDATE IS NULL
GROUP BY D.DEPARTMENT
ORDER BY D.DEPARTMENT


-- 4. �irketimizde departman bazl� halen �al��maya devam KADIN ve ERKEK say�lar�n� getiren sorguyu yaz�n�z.
SELECT 
D.DEPARTMENT,
P.GENDER,
COUNT(P.GENDER) AS CALISANSAYISI_GENDER

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID

WHERE OUTDATE IS NULL
GROUP BY D.DEPARTMENT, P.GENDER
ORDER BY D.DEPARTMENT


-- 5. �irketimizin Planlama departman�na yeni bir �ef atamas� yap�ld� ve maa��n� belirlemek istiyoruz. 
-- Planlama departman� i�in minimum,maximum ve ortalama �ef maa�� getiren sorgu hangisidir? 
-- (Not:i�ten ��km�� olan personel maa�lar� da dahildir.) 
-- Planlama �efi planlama departman�na de�ilde y�netim departman�na ba�l� oldu�u i�in y�netim departman� 
-- k�r�l�m�nda i�lemler yap�lm��t�r.


SELECT
D.DEPARTMENT,
PS.POSITION,
MIN(P.SALARY) AS MIN_SALARY,
MAX(P.SALARY) AS MAX_SALARY,
AVG(P.SALARY) AS AVG_SALARY

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
JOIN POSITION PS ON PS.ID = P.POSITIONID

WHERE D.DEPARTMENT = 'Y�NET�M' AND PS.POSITION = 'PLANLAMA �EF�'
GROUP BY  D.DEPARTMENT, PS.POSITION


-- 6. Her bir pozisyonda mevcut halde �al��anlar olarak ka� ki�i ve ortalama maa�lar�n�n ne kadar oldu�unu
-- listelettirmek istiyoruz. 
-- Sonucu getiren sorguyu yaz�n�z.
SELECT

PS.POSITION,
COUNT(P.ID) AS EMPLOYEE_NUMBER,
MIN(P.SALARY) AS MIN_SALARY,
MAX(P.SALARY) AS MAX_SALARY,
AVG(P.SALARY) AS AVG_SALARY

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
JOIN POSITION PS ON PS.ID = P.POSITIONID

WHERE OUTDATE IS NULL
GROUP BY PS.POSITION
ORDER BY PS.POSITION


-- 7. Y�llara g�re i�e al�nan personel say�s�n� kad�n ve erkek baz�nda listelettiren sorguyu yaz�n�z.
SELECT
P.INDATE,
P.GENDER,
COUNT(P.ID) AS ISE_ALINAN_KISI_SAYISI

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
JOIN POSITION PS ON PS.ID = P.POSITIONID

GROUP BY P.INDATE, P.GENDER
ORDER BY P.INDATE


-- 8. Maa� ortalamas� 5.500 TL�den fazla olan departmanlar� listeleyecek sorguyu yaz�n�z.
SELECT
D.DEPARTMENT,
MIN(P.SALARY) AS MIN_SALARY,
AVG(P.SALARY) AS AVG_SALARY

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
JOIN POSITION PS ON PS.ID = P.POSITIONID

WHERE P.SALARY > 5500
GROUP BY D.DEPARTMENT
ORDER BY D.DEPARTMENT


-- 9. Departmanlar�n ortalama k�demini ay olarak hesaplayacak sorguyu yaz�n�z.
-- SENIORITY ad�nda bir de�i�ken olu�turup daha �nce bizden �al���p ��km�� ve halen �al��an 
-- ki�ilerin k�demlerini ay baz�nda tutal�m.
SELECT * FROM PERSON

UPDATE PERSON SET SENIORITY = DATEDIFF(MONTH, INDATE, OUTDATE)
UPDATE PERSON SET SENIORITY = DATEDIFF(MONTH, INDATE, '2023-02-05') WHERE OUTDATE IS NULL

SELECT D.DEPARTMENT,
AVG(P.SENIORITY) AS AVG_SENIORITY

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
JOIN POSITION PS ON PS.ID = P.POSITIONID

GROUP BY D.DEPARTMENT