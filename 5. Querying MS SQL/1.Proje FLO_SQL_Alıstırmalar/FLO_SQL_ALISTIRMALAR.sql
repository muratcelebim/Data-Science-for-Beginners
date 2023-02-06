
--------------------------------------------------------- SORULAR ---------------------------------------------------------
-- 1. Customers isimli bir veritabaný ve verilen veri setindeki deðiþkenleri içerecek FLO isimli bir tablo oluþturunuz.	
-- Oluþturduðumuz tabloya verileri Excel'den içeri aktaralým.

-- Ýçe aktardýðýmýz tabloyu inceleyelim.
SELECT * FROM FLO


-- 2. Kaç farklý müþterinin alýþveriþ yaptýðýný gösterecek sorguyu yazýnýz.
SELECT  
COUNT(DISTINCT master_id) FARKLI_MUSTERI_SAYISI 
FROM FLO


-- 3. Toplam yapýlan alýþveriþ sayýsý ve ciroyu getirecek sorguyu yazýnýz.
SELECT
SUM(order_num_total_ever_online + order_num_total_ever_offline)  TOPLAM_ALISVERIS_SAYISI,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  TOPLAM_CIRO
FROM FLO


-- 4. Alýþveriþ baþýna ortalama ciroyu getirecek sorguyu yazýnýz.
SELECT ID, 
SUM(customer_value_total_ever_offline + customer_value_total_ever_online) / SUM(order_num_total_ever_online + order_num_total_ever_offline) ORTALAMA_CIRO
FROM FLO
GROUP BY ID
ORDER BY ID


-- 5. En son alýþveriþ yapýlan kanal (last_order_channel) üzerinden yapýlan alýþveriþlerin toplam ciro ve alýþveriþ sayýlarýný getirecek sorguyu yazýnýz. 
SELECT last_order_channel,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  TOPLAM_CIRO,
SUM(order_num_total_ever_online + order_num_total_ever_offline) TOPLAM_ALISVERIS_SAYISI
FROM FLO
GROUP BY last_order_channel
ORDER BY last_order_channel


-- 6. Store type kýrýlýmýnda elde edilen toplam ciroyu getiren sorguyu yazýnýz.
SELECT store_type STORE_TYPE,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  TOPLAM_CIRO
FROM FLO
GROUP BY store_type
ORDER BY store_type


-- 7. Yýl kýrýlýmýnda alýþveriþ sayýlarýný getirecek sorguyu yazýnýz. (Yýl olarak müþterinin ilk alýþveriþ tarihi (first_order_date) yýlýný baz alýnýz)
SELECT first_order_date ILK_ALISVERIS_TARIHI,
SUM(order_num_total_ever_online + order_num_total_ever_offline) ALISVERIS_SAYISI
FROM FLO
GROUP BY first_order_date
ORDER BY first_order_date


-- 8. En son alýþveriþ yapýlan kanal kýrýlýmýnda alýþveriþ baþýna ortalama ciroyu hesaplayacak sorguyu yazýnýz. 
SELECT  last_order_channel, 
AVG(customer_value_total_ever_offline + customer_value_total_ever_online)  ORTALAMA_CIRO
FROM FLO
GROUP BY last_order_channel
ORDER BY last_order_channel


-- 9. Son 12 ayda en çok ilgi gören kategoriyi getiren sorguyu yazýnýz.
SELECT TOP 1 interested_in_categories_12 SON_BIR_YILDA_YAPILAN_ALISVERIS_KATEGORISI,
SUM(order_num_total_ever_online + order_num_total_ever_offline) EN_COK_ILGI_GOREN_ALISVERIS_SAYISI
FROM FLO 
GROUP BY  interested_in_categories_12
ORDER BY  SUM(order_num_total_ever_online + order_num_total_ever_offline) DESC


-- 10. En çok tercih edilen store_type bilgisini getiren sorguyu yazýnýz. 
SELECT TOP 1 store_type EN_COK_TERCIH_EDILEN
FROM FLO 
GROUP BY  store_type
ORDER BY  SUM(order_num_total_ever_online + order_num_total_ever_offline) DESC


-- 11. En son alýþveriþ yapýlan kanal (last_order_channel) bazýnda, en çok ilgi gören kategoriyi ve bu kategoriden ne kadarlýk alýþveriþ yapýldýðýný getiren 
-- sorguyu yazýnýz.
SELECT 
last_order_channel ALIS_VERIS_YAPILAN_KANALLAR,
interested_in_categories_12 SON_BIR_YILDA_YAPILAN_ALISVERIS_KATEGORISI,
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  YAPILAN_ALISVERIS

FROM FLO 
GROUP BY  last_order_channel, interested_in_categories_12
ORDER BY  last_order_channel DESC, interested_in_categories_12 


-- 12. En çok alýþveriþ yapan kiþinin ID’ sini getiren sorguyu yazýnýz. 
-- Öncelikle yeni bir alan oluþturup online ve offline alýþveriþ sayýlarýný toplayarak bu alana atayalým.
ALTER TABLE FLO ADD SUM_ORDER FLOAT
UPDATE FLO SET SUM_ORDER = order_num_total_ever_online + order_num_total_ever_offline

SELECT TOP 1 
ID   EN_COK_ALISVERIS_ID, 
MAX(SUM_ORDER)  ALISVERIS_SAYISI
FROM FLO
GROUP BY  ID
ORDER BY  MAX(SUM_ORDER) DESC


-- 13. En çok alýþveriþ yapan kiþinin alýþveriþ baþýna ortalama cirosunu ve alýþveriþ yapma gün ortalamasýný (alýþveriþ sýklýðýný) getiren sorguyu yazýnýz.
-- Öncelikle müþterilerin son alýþveriþ yaptýðý ve ilk alýþveriþ yaptýðý tarihin arasýndaki farký gün bazlý olarak alalým.
ALTER TABLE FLO ADD COUNT_ORDER_DAY FLOAT
UPDATE FLO SET COUNT_ORDER_DAY = DATEDIFF(DAY, first_order_date, last_order_date) 

SELECT TOP 1  
ID, 
SUM_ORDER ALIÞVERIÞ_SAYISI,
AVG(customer_value_total_ever_offline + customer_value_total_ever_online)  ORTALAMA_CIRO,
SUM(COUNT_ORDER_DAY) / SUM(order_num_total_ever_online + order_num_total_ever_offline) AS ORTALAMA_ALISVERIS_GUN_SAY
FROM FLO
GROUP BY  ID, SUM_ORDER
ORDER BY  MAX(SUM_ORDER) DESC


-- 14. En çok alýþveriþ yapan (ciro bazýnda) ilk 100 kiþinin alýþveriþ yapma gün ortalamasýný (alýþveriþ sýklýðýný) getiren sorguyu  yazýnýz. 
SELECT TOP 100
ID, 
SUM(customer_value_total_ever_offline + customer_value_total_ever_online)  CIRO,
SUM(COUNT_ORDER_DAY) / SUM(order_num_total_ever_online + order_num_total_ever_offline) AS ORTALAMA_ALISVERIS_GUN_SAY
FROM FLO
GROUP BY  ID, SUM_ORDER
ORDER BY  SUM(customer_value_total_ever_offline + customer_value_total_ever_online) DESC


-- 15. En son alýþveriþ yapýlan kanal (last_order_channel) kýrýlýmýnda en çok alýþveriþ yapan müþteriyi getiren sorguyu yazýnýz.
SELECT 
TOP 1
last_order_channel EN_SIN_ALISVERIS_YAPILAN_KANAL, 
master_id ESSIZ_MUSTERI_NO, 
SUM_ORDER ALISVERIS_SAYISI
FROM FLO 
GROUP BY last_order_channel, SUM_ORDER, master_id
ORDER BY SUM_ORDER DESC


-- 16. En son alýþveriþ yapan kiþinin ID’ sini getiren sorguyu yazýnýz. (Max son tarihte birden fazla alýþveriþ yapan ID bulunmakta.  Bunlarý da getiriniz.)
SELECT 
ID, 
master_id ESSIZ_MUSTERI_NO, 
last_order_date SON_ALISVERIS_YAPILAN_TARIH
FROM FLO
WHERE last_order_date=(SELECT MAX(last_order_date) FROM FLO)
ORDER BY ID 
