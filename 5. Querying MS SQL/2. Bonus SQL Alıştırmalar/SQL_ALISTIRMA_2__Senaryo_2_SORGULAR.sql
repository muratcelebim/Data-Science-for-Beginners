-- 1. HR isimli bir veritabaný oluþturunuz.
-- Oluþturduðumuz Tablolarý Sorgulayalým:
SELECT * FROM PERSON
SELECT * FROM DEPARTMENT
SELECT * FROM POSITION


-- 2. Þirketimizde halen çalýþmaya devam eden çalýþanlarýn listesini getiren sorgu hangisidir?
-- Not: Ýþten çýkýþ tarihi boþ olanlar çalýþmaya devam eden çalýþanlardýr.
SELECT * FROM PERSON
WHERE OUTDATE IS NULL


-- 3. Þirketimizde departman bazlý halen çalýþmaya devam eden çalýþan sayýsýný getiren sorguyu yazýnýz?
SELECT 
D.DEPARTMENT,
COUNT(D.DEPARTMENT) AS CALISANSAYISI
FROM PERSON P 

JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID

WHERE OUTDATE IS NULL
GROUP BY D.DEPARTMENT
ORDER BY D.DEPARTMENT


-- 4. Þirketimizde departman bazlý halen çalýþmaya devam KADIN ve ERKEK sayýlarýný getiren sorguyu yazýnýz.
SELECT 
D.DEPARTMENT,
P.GENDER,
COUNT(P.GENDER) AS CALISANSAYISI_GENDER

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID

WHERE OUTDATE IS NULL
GROUP BY D.DEPARTMENT, P.GENDER
ORDER BY D.DEPARTMENT


-- 5. Þirketimizin Planlama departmanýna yeni bir þef atamasý yapýldý ve maaþýný belirlemek istiyoruz. 
-- Planlama departmaný için minimum,maximum ve ortalama þef maaþý getiren sorgu hangisidir? 
-- (Not:iþten çýkmýþ olan personel maaþlarý da dahildir.) 
-- Planlama Þefi planlama departmanýna deðilde yönetim departmanýna baðlý olduðu için yönetim departmaný 
-- kýrýlýmýnda iþlemler yapýlmýþtýr.


SELECT
D.DEPARTMENT,
PS.POSITION,
MIN(P.SALARY) AS MIN_SALARY,
MAX(P.SALARY) AS MAX_SALARY,
AVG(P.SALARY) AS AVG_SALARY

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
JOIN POSITION PS ON PS.ID = P.POSITIONID

WHERE D.DEPARTMENT = 'YÖNETÝM' AND PS.POSITION = 'PLANLAMA ÞEFÝ'
GROUP BY  D.DEPARTMENT, PS.POSITION


-- 6. Her bir pozisyonda mevcut halde çalýþanlar olarak kaç kiþi ve ortalama maaþlarýnýn ne kadar olduðunu
-- listelettirmek istiyoruz. 
-- Sonucu getiren sorguyu yazýnýz.
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


-- 7. Yýllara göre iþe alýnan personel sayýsýný kadýn ve erkek bazýnda listelettiren sorguyu yazýnýz.
SELECT
P.INDATE,
P.GENDER,
COUNT(P.ID) AS ISE_ALINAN_KISI_SAYISI

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
JOIN POSITION PS ON PS.ID = P.POSITIONID

GROUP BY P.INDATE, P.GENDER
ORDER BY P.INDATE


-- 8. Maaþ ortalamasý 5.500 TL’den fazla olan departmanlarý listeleyecek sorguyu yazýnýz.
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


-- 9. Departmanlarýn ortalama kýdemini ay olarak hesaplayacak sorguyu yazýnýz.
-- SENIORITY adýnda bir deðiþken oluþturup daha önce bizden çalýþýp çýkmýþ ve halen çalýþan 
-- kiþilerin kýdemlerini ay bazýnda tutalým.
SELECT * FROM PERSON

UPDATE PERSON SET SENIORITY = DATEDIFF(MONTH, INDATE, OUTDATE)
UPDATE PERSON SET SENIORITY = DATEDIFF(MONTH, INDATE, '2023-02-05') WHERE OUTDATE IS NULL

SELECT D.DEPARTMENT,
AVG(P.SENIORITY) AS AVG_SENIORITY

FROM PERSON P 
JOIN DEPARTMENT D ON D.ID = P.DEPARTMENTID
JOIN POSITION PS ON PS.ID = P.POSITIONID

GROUP BY D.DEPARTMENT