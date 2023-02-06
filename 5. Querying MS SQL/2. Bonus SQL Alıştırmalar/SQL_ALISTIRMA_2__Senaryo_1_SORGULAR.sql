-- 1. Customers isimli bir veritabaný oluþturunuz.
-- CUSTOMERS adýnda bir veritabaný oluþturuldu.

-- Veritabaný içinde oluþturulan tablolar:
SELECT * FROM CUSTOMERS
SELECT * FROM CITIES
SELECT * FROM DISTRICT


-- 2. Customers tablosundan adý ‘A’ harfi ile baþlayan kiþileri çeken sorguyu yazýnýz.
SELECT * FROM CUSTOMERS WHERE NAMESURNAME LIKE 'A%'


-- 3. 1990 ve 1995 yýllarý arasýnda doðan müþterileri çekiniz. 1990 ve 1995 yýllarý dahildir
SELECT * FROM CUSTOMERS 
WHERE BIRTHDATE BETWEEN  '1990-01-01' AND '1995-12-31'
ORDER BY BIRTHDATE


-- 4. Ýstanbul’da yaþayan kiþileri Join kullanarak getiren sorguyu yazýnýz.
SELECT * FROM CUSTOMERS C JOIN CITIES CT ON CT.ID = C.CITYID WHERE CT.CITY = 'ÝSTANBUL'


-- 5. Ýstanbul’da yaþayan kiþileri subquery kullanarak getiren sorguyu yazýnýz
SELECT 
(SELECT CITY FROM CITIES WHERE CITIES.ID = C.CITYID) AS CITY,
*
FROM CUSTOMERS C
WHERE C.CITYID = 34
ORDER BY CITYID


-- 6. Hangi þehirde kaç müþterimizin olduðu bilgisini getiren sorguyu yazýnýz.
SELECT CT.CITY,  COUNT(CT.ID) AS MUSTERISAYISI
FROM CUSTOMERS C JOIN CITIES CT ON CT.ID = C.CITYID 
GROUP BY CT.CITY
ORDER BY CT.CITY


-- 7. 10’dan fazla müþterimiz olan þehirleri müþteri sayýsý ile birlikte müþteri sayýsýna göre fazladan aza doðru  
-- sýralý þekilde getiriniz
SELECT CT.CITY,  COUNT(CT.ID) AS MÜÞTERISAYISI
FROM CUSTOMERS C JOIN CITIES CT ON CT.ID = C.CITYID 
GROUP BY CT.CITY
HAVING COUNT(CT.ID)>10
ORDER BY COUNT(CT.ID) DESC


-- 8. Hangi þehirde kaç erkek, kaç kadýn müþterimizin olduðu bilgisini getiren sorguyu yazýnýz
SELECT CT.CITY, C.GENDER, COUNT(C.GENDER) AS KISISAYISI
FROM CUSTOMERS C JOIN CITIES CT ON CT.ID = C.CITYID 
GROUP BY CT.CITY, C.GENDER
ORDER BY CT.CITY


-- 9. Customers tablosuna yaþ grubu için yeni bir alan ekleyiniz. 
-- Bu iþlemi hem management studio ile hem de sql kodu ile yapýnýz. 
-- Alaný adý AGEGROUP veritipi Varchar(50)
-- Management studio ile yapýldý. (Design kýsmýndan)
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


-- 10. Customers tablosuna eklediðiniz AGEGROUP alanýný 20-35 yaþ arasý,36-45 yaþ arasý,46-55 yaþ arasý,55-65 yaþ
-- arasý ve 65 yaþ üstü olarak güncelleyiniz. 
-- AGEGROUP tablosu için:
UPDATE CUSTOMERS SET AGEGROUP = '20-35 yaþ' WHERE AGE BETWEEN 20 AND 35
UPDATE CUSTOMERS SET AGEGROUP = '36-45 yaþ' WHERE AGE BETWEEN 36 AND 45
UPDATE CUSTOMERS SET AGEGROUP = '46-55 yaþ' WHERE AGE BETWEEN 46 AND 55
UPDATE CUSTOMERS SET AGEGROUP = '55-65 yaþ' WHERE AGE BETWEEN 55 AND 65
UPDATE CUSTOMERS SET AGEGROUP = '65 yaþ üstü' WHERE AGE >= 65
SELECT * FROM CUSTOMERS

-- Ayný iþlemi bir de oluþturduðumuz diðer alan olan AGEGROUP2 alaný için yapalým:
UPDATE CUSTOMERS SET AGEGROUP2 = '20-35 yaþ' WHERE AGE BETWEEN 20 AND 35
UPDATE CUSTOMERS SET AGEGROUP2 = '36-45 yaþ' WHERE AGE BETWEEN 36 AND 45
UPDATE CUSTOMERS SET AGEGROUP2 = '46-55 yaþ' WHERE AGE BETWEEN 46 AND 55
UPDATE CUSTOMERS SET AGEGROUP2 = '55-65 yaþ' WHERE AGE BETWEEN 55 AND 65
UPDATE CUSTOMERS SET AGEGROUP2 = '65 yaþ üstü' WHERE AGE >= 65
SELECT * FROM CUSTOMERS


-- 11. Ýstanbul’da yaþayýp ilçesi ‘Kadýköy’ dýþýnda olanlarý listeleyiniz.
SELECT  DISTINCT  C.*
FROM CUSTOMERS C 
JOIN CITIES CT ON CT.ID = C.CITYID 
JOIN DISTRICT D ON D.CITYID = CT.ID
WHERE CT.CITY = 'ÝSTANBUL' AND D.DISTRICT NOT IN  ('KADIKÖY')


-- 12. Müþterilerimizin telefon numalarýnýn operatör bilgisini getirmek istiyoruz. TELNR1 ve TELNR2 alanlarýnýn yanýna
-- operatör numarasýný (532),(505) gibi getirmek istiyoruz. Bu sorgu için gereken SQL cümlesini yazýnýz.

SELECT 
*, 
LEFT(TELNR1, 5) AS TELNR1_ALANKODU,
LEFT(TELNR2, 5) AS TELNR1_ALANKODU
FROM CUSTOMERS 


-- 13. Müþterilerimizin telefon numaralarýnýn operatör bilgisini getirmek istiyoruz. 
-- Örneðin telefon numaralarý “50”  ya da “55” ile baþlayan “X” operatörü “54” ile baþlayan “Y” operatörü 
-- “53” ile baþlayan “Z” operatörü olsun. 
-- Burada hangi operatörden ne kadar müþterimiz olduðu bilgisini getirecek sorguyu yazýnýz.
-- Bunun için bir deðiþken oluþturalým. (OPERATORS)
-- Öncelikle sorgu çalýþtýralým.
SELECT 
* 
FROM CUSTOMERS 
WHERE TELNR1 LIKE '(53%' 

-- Oluþturduðumuz yeni OPERATORS_TELNR1 deðiþkenine TELNR1'den X, Y ve Z atamalarý yapalým.
UPDATE CUSTOMERS SET OPERATORS_TELNR1 = 'X' WHERE TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%'
UPDATE CUSTOMERS SET OPERATORS_TELNR1 = 'Y' WHERE TELNR1 LIKE '(54%'
UPDATE CUSTOMERS SET OPERATORS_TELNR1 = 'Z' WHERE TELNR1 LIKE '(53%'

SELECT * FROM CUSTOMERS 

-- Oluþturduðumuz yeni OPERATORS_TELNR2 deðiþkenine TELNR2'den X, y ve Z atamalarý yapalým.
UPDATE CUSTOMERS SET OPERATORS_TELNR2 = 'X' WHERE TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%'
UPDATE CUSTOMERS SET OPERATORS_TELNR2 = 'Y' WHERE TELNR2 LIKE '(54%'
UPDATE CUSTOMERS SET OPERATORS_TELNR2 = 'Z' WHERE TELNR2 LIKE '(53%'

SELECT * FROM CUSTOMERS 


-- TELNR1 için:
SELECT 
OPERATORS_TELNR1, 
COUNT(OPERATORS_TELNR1) OPERATÖRSAYISI_TELNR1

FROM CUSTOMERS
GROUP BY OPERATORS_TELNR1


-- TELNR2 için:
SELECT 
OPERATORS_TELNR2, 
COUNT(OPERATORS_TELNR2) OPERATÖRSAYISI_TELNR2

FROM CUSTOMERS
GROUP BY OPERATORS_TELNR2


-- 14. Her ilde en çok müþteriye sahip olduðumuz ilçeleri müþteri sayýsýna göre çoktan aza doðru sýralý þekilde
-- þekildeki gibi getirmek için gereken sorguyu yazýnýz.

SELECT 
CT.CITY,
D.DISTRICT,
COUNT(CT.ID) AS MÜÞTERISAYISI
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
JOIN DISTRICT D ON D.CITYID = CT.ID
GROUP BY CT.CITY, D.DISTRICT
ORDER BY COUNT(CT.ID) DESC


-- 15. Müþterilerin doðum günlerini haftanýn günü (Pazartesi, Salý, Çarþamba..) olarak getiren sorguyu yazýnýz.
SELECT

-- DoðumTarihi:
BIRTHDATE,

-- Doðum Ayý
DATENAME(MONTH, BIRTHDATE) as BIRTHMONTH,

-- Doðum Günü:
DATENAME(DW, BIRTHDATE) as BIRTHDAY

FROM CUSTOMERS
