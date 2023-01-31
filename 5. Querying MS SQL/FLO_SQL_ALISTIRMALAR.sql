
--------------------------------------------------------- SORULAR ---------------------------------------------------------
-- 1. Customers isimli bir veritaban� ve verilen veri setindeki de�i�kenleri i�erecek FLO isimli bir tablo olu�turunuz.	
-- Olu�turdu�umuz tabloya verileri Excel'den i�eri aktaral�m.

-- ��e aktard���m�z tabloyu inceleyelim.
SELECT * FROM FLO


-- 2. Ka� farkl� m��terinin al��veri� yapt���n� g�sterecek sorguyu yaz�n�z.
SELECT  
COUNT(DISTINCT master_id) FARKLI_MUSTERI_SAYISI 
FROM FLO


-- 3. Toplam yap�lan al��veri� say�s� ve ciroyu getirecek sorguyu yaz�n�z.
SELECT
SUM(order_num_total_ever_online + order_num_total_ever_offline)  TOPLAM_ALISVERIS_SAYISI,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  TOPLAM_CIRO
FROM FLO


-- 4. Al��veri� ba��na ortalama ciroyu getirecek sorguyu yaz�n�z.
SELECT ID, 
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) / SUM(order_num_total_ever_online + order_num_total_ever_offline) ORTALAMA_CIRO
FROM FLO
GROUP BY ID
ORDER BY ID


-- 5. En son al��veri� yap�lan kanal (last_order_channel) �zerinden yap�lan al��veri�lerin toplam ciro ve al��veri� say�lar�n� getirecek sorguyu yaz�n�z. 
SELECT last_order_channel,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  TOPLAM_CIRO,
SUM(order_num_total_ever_online + order_num_total_ever_offline) TOPLAM_ALISVERIS_SAYISI
FROM FLO
GROUP BY last_order_channel
ORDER BY last_order_channel


-- 6. Store type k�r�l�m�nda elde edilen toplam ciroyu getiren sorguyu yaz�n�z.
SELECT store_type STORE_TYPE,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  TOPLAM_CIRO
FROM FLO
GROUP BY store_type
ORDER BY store_type


-- 7. Y�l k�r�l�m�nda al��veri� say�lar�n� getirecek sorguyu yaz�n�z. (Y�l olarak m��terinin ilk al��veri� tarihi (first_order_date) y�l�n� baz al�n�z)
SELECT first_order_date ILK_ALISVERIS_TARIHI,
SUM(order_num_total_ever_online + order_num_total_ever_offline) ALISVERIS_SAYISI
FROM FLO
GROUP BY first_order_date
ORDER BY first_order_date


-- 8. En son al��veri� yap�lan kanal k�r�l�m�nda al��veri� ba��na ortalama ciroyu hesaplayacak sorguyu yaz�n�z. 
SELECT  last_order_channel, 
AVG(customer_value_total_ever_offline + customer_value_total_ever_online)  ORTALAMA_CIRO
FROM FLO
GROUP BY last_order_channel
ORDER BY last_order_channel


-- 9. Son 12 ayda en �ok ilgi g�ren kategoriyi getiren sorguyu yaz�n�z.
SELECT TOP 1 interested_in_categories_12 SON_BIR_YILDA_YAPILAN_ALISVERIS_KATEGORISI,
SUM(order_num_total_ever_online + order_num_total_ever_offline) EN_COK_ILGI_GOREN_ALISVERIS_SAYISI
FROM FLO 
GROUP BY  interested_in_categories_12
ORDER BY  SUM(order_num_total_ever_online + order_num_total_ever_offline) DESC


-- 10. En �ok tercih edilen store_type bilgisini getiren sorguyu yaz�n�z. 
SELECT TOP 1 store_type EN_COK_TERCIH_EDILEN
FROM FLO 
GROUP BY  store_type
ORDER BY  SUM(order_num_total_ever_online + order_num_total_ever_offline) DESC


-- 11. En son al��veri� yap�lan kanal (last_order_channel) baz�nda, en �ok ilgi g�ren kategoriyi ve bu kategoriden ne kadarl�k al��veri� yap�ld���n� getiren 
-- sorguyu yaz�n�z.
SELECT 
last_order_channel ALIS_VERIS_YAPILAN_KANALLAR,
interested_in_categories_12 SON_BIR_YILDA_YAPILAN_ALISVERIS_KATEGORISI,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  YAPILAN_ALISVERIS

FROM FLO 
GROUP BY  last_order_channel, interested_in_categories_12
ORDER BY  last_order_channel DESC, interested_in_categories_12 


-- 12. En �ok al��veri� yapan ki�inin ID� sini getiren sorguyu yaz�n�z. 
-- �ncelikle yeni bir alan olu�turup online ve offline al��veri� say�lar�n� toplayarak bu alana atayal�m.
ALTER TABLE FLO ADD SUM_ORDER FLOAT
UPDATE FLO SET SUM_ORDER = order_num_total_ever_online + order_num_total_ever_offline

SELECT TOP 1 
ID   EN_COK_ALISVERIS_ID, 
MAX(SUM_ORDER)  ALISVERIS_SAYISI
FROM FLO
GROUP BY  ID
ORDER BY  MAX(SUM_ORDER) DESC


-- 13. En �ok al��veri� yapan ki�inin al��veri� ba��na ortalama cirosunu ve al��veri� yapma g�n ortalamas�n� (al��veri� s�kl���n�) getiren sorguyu yaz�n�z.
-- �ncelikle m��terilerin son al��veri� yapt��� ve ilk al��veri� yapt��� tarihin aras�ndaki fark� g�n bazl� olarak alal�m.
ALTER TABLE FLO ADD COUNT_ORDER_DAY FLOAT
UPDATE FLO SET COUNT_ORDER_DAY = DATEDIFF(DAY, first_order_date, last_order_date) 

SELECT TOP 1  
ID, 
SUM_ORDER ALI�VERI�_SAYISI,
AVG(customer_value_total_ever_offline + customer_value_total_ever_online)  ORTALAMA_CIRO,
SUM(COUNT_ORDER_DAY) / SUM(order_num_total_ever_online + order_num_total_ever_offline) AS ORTALAMA_ALISVERIS_GUN_SAY
FROM FLO
GROUP BY  ID, SUM_ORDER
ORDER BY  MAX(SUM_ORDER) DESC


-- 14. En �ok al��veri� yapan (ciro baz�nda) ilk 100 ki�inin al��veri� yapma g�n ortalamas�n� (al��veri� s�kl���n�) getiren sorguyu  yaz�n�z. 
SELECT TOP 100
ID, 
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  CIRO,
SUM(COUNT_ORDER_DAY) / SUM(order_num_total_ever_online + order_num_total_ever_offline) AS ORTALAMA_ALISVERIS_GUN_SAY
FROM FLO
GROUP BY  ID, SUM_ORDER
ORDER BY  SUM(customer_value_total_ever_offline + customer_value_total_ever_online) DESC


-- 15. En son al��veri� yap�lan kanal (last_order_channel) k�r�l�m�nda en �ok al��veri� yapan m��teriyi getiren sorguyu yaz�n�z.
SELECT 
TOP 1
last_order_channel EN_SIN_ALISVERIS_YAPILAN_KANAL, 
master_id ESSIZ_MUSTERI_NO, 
SUM_ORDER ALISVERIS_SAYISI
FROM FLO 
GROUP BY last_order_channel, SUM_ORDER, master_id
ORDER BY SUM_ORDER DESC


-- 16. En son al��veri� yapan ki�inin ID� sini getiren sorguyu yaz�n�z. (Max son tarihte birden fazla al��veri� yapan ID bulunmakta.  Bunlar� da getiriniz.)
SELECT 
ID, 
master_id ESSIZ_MUSTERI_NO, 
last_order_date SON_ALISVERIS_YAPILAN_TARIH
FROM FLO
WHERE last_order_date=(SELECT MAX(last_order_date) FROM FLO)
ORDER BY ID 
