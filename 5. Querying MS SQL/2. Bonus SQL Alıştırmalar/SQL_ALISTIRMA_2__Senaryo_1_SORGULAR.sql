-- 1. Customers isimli bir veritaban� olu�turunuz.
-- CUSTOMERS ad�nda bir veritaban� olu�turuldu.

-- Veritaban� i�inde olu�turulan tablolar:
SELECT * FROM CUSTOMERS
SELECT * FROM CITIES
SELECT * FROM DISTRICT


-- 2. Customers tablosundan ad� �A� harfi ile ba�layan ki�ileri �eken sorguyu yaz�n�z.
SELECT * FROM CUSTOMERS WHERE NAMESURNAME LIKE 'A%'


-- 3. 1990 ve 1995 y�llar� aras�nda do�an m��terileri �ekiniz. 1990 ve 1995 y�llar� dahildir
SELECT * FROM CUSTOMERS 
WHERE BIRTHDATE BETWEEN  '1990-01-01' AND '1995-12-31'
ORDER BY BIRTHDATE


-- 4. �stanbul�da ya�ayan ki�ileri Join kullanarak getiren sorguyu yaz�n�z.
SELECT * FROM CUSTOMERS C JOIN CITIES CT ON CT.ID = C.CITYID WHERE CT.CITY = '�STANBUL'


-- 5. �stanbul�da ya�ayan ki�ileri subquery kullanarak getiren sorguyu yaz�n�z
SELECT 
(SELECT CITY FROM CITIES WHERE CITIES.ID = C.CITYID) AS CITY,
*
FROM CUSTOMERS C
WHERE C.CITYID = 34
ORDER BY CITYID


-- 6. Hangi �ehirde ka� m��terimizin oldu�u bilgisini getiren sorguyu yaz�n�z.
SELECT CT.CITY,  COUNT(CT.ID) AS MUSTERISAYISI
FROM CUSTOMERS C JOIN CITIES CT ON CT.ID = C.CITYID 
GROUP BY CT.CITY
ORDER BY CT.CITY


-- 7. 10�dan fazla m��terimiz olan �ehirleri m��teri say�s� ile birlikte m��teri say�s�na g�re fazladan aza do�ru  
-- s�ral� �ekilde getiriniz
SELECT CT.CITY,  COUNT(CT.ID) AS M��TERISAYISI
FROM CUSTOMERS C JOIN CITIES CT ON CT.ID = C.CITYID 
GROUP BY CT.CITY
HAVING COUNT(CT.ID)>10
ORDER BY COUNT(CT.ID) DESC


-- 8. Hangi �ehirde ka� erkek, ka� kad�n m��terimizin oldu�u bilgisini getiren sorguyu yaz�n�z
SELECT CT.CITY, C.GENDER, COUNT(C.GENDER) AS KISISAYISI
FROM CUSTOMERS C JOIN CITIES CT ON CT.ID = C.CITYID 
GROUP BY CT.CITY, C.GENDER
ORDER BY CT.CITY


-- 9. Customers tablosuna ya� grubu i�in yeni bir alan ekleyiniz. 
-- Bu i�lemi hem management studio ile hem de sql kodu ile yap�n�z. 
-- Alan� ad� AGEGROUP veritipi Varchar(50)
-- Management studio ile yap�ld�. (Design k�sm�ndan)
SELECT * FROM CUSTOMERS

ALTER TABLE CUSTOMERS 
ADD AGEGROUP Varchar(50)

-- Sql kodu ile AGEGROUP2:
ALTER TABLE CUSTOMERS 
ADD AGEGROUP2 Varchar(50)

ALTER TABLE CUSTOMERS 
ADD AGE Varchar(50)

UPDATE CUSTOMERS 
SET AGE = DATEDIFF(YEAR, BIRTHDATE, '2023-02-05')
SELECT * FROM CUSTOMERS


-- 10. Customers tablosuna ekledi�iniz AGEGROUP alan�n� 20-35 ya� aras�,36-45 ya� aras�,46-55 ya� aras�,55-65 ya�
-- aras� ve 65 ya� �st� olarak g�ncelleyiniz. 
-- AGEGROUP tablosu i�in:
UPDATE CUSTOMERS SET AGEGROUP = '20-35 ya�' WHERE AGE BETWEEN 20 AND 35
UPDATE CUSTOMERS SET AGEGROUP = '36-45 ya�' WHERE AGE BETWEEN 36 AND 45
UPDATE CUSTOMERS SET AGEGROUP = '46-55 ya�' WHERE AGE BETWEEN 46 AND 55
UPDATE CUSTOMERS SET AGEGROUP = '55-65 ya�' WHERE AGE BETWEEN 55 AND 65
UPDATE CUSTOMERS SET AGEGROUP = '65 ya� �st�' WHERE AGE >= 65
SELECT * FROM CUSTOMERS

-- Ayn� i�lemi bir de olu�turdu�umuz di�er alan olan AGEGROUP2 alan� i�in yapal�m:
UPDATE CUSTOMERS SET AGEGROUP2 = '20-35 ya�' WHERE AGE BETWEEN 20 AND 35
UPDATE CUSTOMERS SET AGEGROUP2 = '36-45 ya�' WHERE AGE BETWEEN 36 AND 45
UPDATE CUSTOMERS SET AGEGROUP2 = '46-55 ya�' WHERE AGE BETWEEN 46 AND 55
UPDATE CUSTOMERS SET AGEGROUP2 = '55-65 ya�' WHERE AGE BETWEEN 55 AND 65
UPDATE CUSTOMERS SET AGEGROUP2 = '65 ya� �st�' WHERE AGE >= 65
SELECT * FROM CUSTOMERS


-- 11. �stanbul�da ya�ay�p il�esi �Kad�k�y� d���nda olanlar� listeleyiniz.
SELECT  DISTINCT  C.*
FROM CUSTOMERS C 
JOIN CITIES CT ON CT.ID = C.CITYID 
JOIN DISTRICT D ON D.CITYID = CT.ID
WHERE CT.CITY = '�STANBUL' AND D.DISTRICT NOT IN  ('KADIK�Y')


-- 12. M��terilerimizin telefon numalar�n�n operat�r bilgisini getirmek istiyoruz. TELNR1 ve TELNR2 alanlar�n�n yan�na
-- operat�r numaras�n� (532),(505) gibi getirmek istiyoruz. Bu sorgu i�in gereken SQL c�mlesini yaz�n�z.

SELECT 
*, 
LEFT(TELNR1, 5) AS TELNR1_ALANKODU,
LEFT(TELNR2, 5) AS TELNR1_ALANKODU
FROM CUSTOMERS 


-- 13. M��terilerimizin telefon numaralar�n�n operat�r bilgisini getirmek istiyoruz. 
-- �rne�in telefon numaralar� �50�  ya da �55� ile ba�layan �X� operat�r� �54� ile ba�layan �Y� operat�r� 
-- �53� ile ba�layan �Z� operat�r� olsun. 
-- Burada hangi operat�rden ne kadar m��terimiz oldu�u bilgisini getirecek sorguyu yaz�n�z.
-- Bunun i�in bir de�i�ken olu�tural�m. (OPERATORS)
-- �ncelikle sorgu �al��t�ral�m.
SELECT 
* 
FROM CUSTOMERS 
WHERE TELNR1 LIKE '(53%' 

-- Olu�turdu�umuz yeni OPERATORS_TELNR1 de�i�kenine TELNR1'den X, Y ve Z atamalar� yapal�m.
UPDATE CUSTOMERS SET OPERATORS_TELNR1 = 'X' WHERE TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%'
UPDATE CUSTOMERS SET OPERATORS_TELNR1 = 'Y' WHERE TELNR1 LIKE '(54%'
UPDATE CUSTOMERS SET OPERATORS_TELNR1 = 'Z' WHERE TELNR1 LIKE '(53%'

SELECT * FROM CUSTOMERS 

-- Olu�turdu�umuz yeni OPERATORS_TELNR2 de�i�kenine TELNR2'den X, y ve Z atamalar� yapal�m.
UPDATE CUSTOMERS SET OPERATORS_TELNR2 = 'X' WHERE TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%'
UPDATE CUSTOMERS SET OPERATORS_TELNR2 = 'Y' WHERE TELNR2 LIKE '(54%'
UPDATE CUSTOMERS SET OPERATORS_TELNR2 = 'Z' WHERE TELNR2 LIKE '(53%'

SELECT * FROM CUSTOMERS 


-- TELNR1 i�in:
SELECT 
OPERATORS_TELNR1, 
COUNT(OPERATORS_TELNR1) OPERAT�RSAYISI_TELNR1

FROM CUSTOMERS
GROUP BY OPERATORS_TELNR1


-- TELNR2 i�in:
SELECT 
OPERATORS_TELNR2, 
COUNT(OPERATORS_TELNR2) OPERAT�RSAYISI_TELNR2

FROM CUSTOMERS
GROUP BY OPERATORS_TELNR2


-- 14. Her ilde en �ok m��teriye sahip oldu�umuz il�eleri m��teri say�s�na g�re �oktan aza do�ru s�ral� �ekilde
-- �ekildeki gibi getirmek i�in gereken sorguyu yaz�n�z.

SELECT 
CT.CITY,
D.DISTRICT,
COUNT(CT.ID) AS M��TERISAYISI
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
JOIN DISTRICT D ON D.CITYID = CT.ID
GROUP BY CT.CITY, D.DISTRICT
ORDER BY COUNT(CT.ID) DESC


-- 15. M��terilerin do�um g�nlerini haftan�n g�n� (Pazartesi, Sal�, �ar�amba..) olarak getiren sorguyu yaz�n�z.
SELECT

-- Do�umTarihi:
BIRTHDATE,

-- Do�um Ay�
DATENAME(MONTH, BIRTHDATE) as BIRTHMONTH,

-- Do�um G�n�:
DATENAME(DW, BIRTHDATE) as BIRTHDAY

FROM CUSTOMERS
