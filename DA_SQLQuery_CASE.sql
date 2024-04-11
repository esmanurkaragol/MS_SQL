------------   FLO DATABASE   ------------------

-- 1. FLO tablosunu getirecek sorguyu yazınız.
SELECT *FROM dbo.flo

--2. Kaç farklı müşterinin alışveriş yaptığını gösterecek sorguyu yazınız.
--master_id: eşsiz müşteri sayıdı bunun diretkt count alarak bulabilirm.
SELECT COUNT(master_id) FROM flo --19945kişi


--3. Toplam yapılan alışveriş adedini ve ciroyu getirecek sorguyu yazınız.
SELECT
SUM(order_num_total_ever_online) + SUM(order_num_total_ever_offline) AS ToplamAlışverişAdeti,
SUM(customer_value_total_ever_offline) + SUM(Customer_value_total_ever_online) AS ToplamCiro
FROM flo


-- 4. Alışveriş başına ortalama ciroyu getirecek sorguyu yazınız. (bir kişinin)
--order_num_total_ever_online (adet)
--order_num_total_ever_offline (adet)
--customer_value_total_ever_offline (ücret)
--customer_value_total_ever_online (ücret)

SELECT master_id, 
SUM(order_num_total_ever_online) + SUM(order_num_total_ever_offline) as frequency,
SUM(customer_value_total_ever_offline) + SUM(Customer_value_total_ever_online) AS monetary,
    (SUM(customer_value_total_ever_offline) + SUM(customer_value_total_ever_online)) /
    (SUM(order_num_total_ever_online) + SUM(order_num_total_ever_offline)) AS basketSıze
FROM flo
GROUP BY master_id


--5. En  son  alışveriş  yapılan  kanal  (last_order_channel)  üzerinden  yapılan  alışverişlerin  toplam  ciro  ve  alışveriş  sayılarını getirecek sorguyu yazınız
SELECT last_order_channel,
SUM(order_num_total_ever_online) + SUM(order_num_total_ever_offline) as ToplamAlışverişAdeti,
SUM(customer_value_total_ever_offline) + SUM(Customer_value_total_ever_online) AS ToplamCiro
FROM flo 
GROUP BY last_order_channel

--6.Yıl kırılımında alışveriş sayılarını getirecek sorguyu yazınız (Yıl olarak müşterinin ilk alışveriş tarihi (first_order_date) yılını baz alınız). 
SELECT YEAR(first_order_date) AS Yıl, COUNT(master_id) AS ToplamAlısverisSayisi
FROM flo
GROUP BY YEAR(first_order_date)


--7.En son alışveriş yapılan kanal kırılımında alışveriş başına ortalama ciroyu hesaplayacak sorguyu yazınız.
SELECT order_channel, SUM(customer_value_total_ever_offline) + SUM(Customer_value_total_ever_online) AS ToplamCiro
FROM flo
GROUP BY order_channel

--8.Online ve offline alışveriş yapan müşterilerin toplam cirolarını ayrı ayrı getiren sorguyu yazınız
--genel
SELECT
SUM(Customer_value_total_ever_online) AS OnlineToplamCiro,
SUM(customer_value_total_ever_offline) AS OfflineToplamCiro
FROM flo 
--müşteri bazında
SELECT master_id,
SUM(Customer_value_total_ever_online) AS OnlineToplamCiro,
SUM(customer_value_total_ever_offline) AS OfflineToplamCiro
FROM flo 
GROUP BY master_id


-- 9. FLO tablosundaki master_id ve order_channel kolonlarını getiren sorguyu yazınız
SELECT master_id, order_channel FROM flo

--10. FLO tablosundan 'Offline' olmayan sipariş kanalına sahip kayıtları getiren sorguyu yazınız.
SELECT * FROM flo WHERE last_order_channel != 'Offline'
--veya
SELECT * FROM flo WHERE last_order_channel NOT LIKE '%Offline%'
--veya
SELECT * FROM flo WHERE last_order_channel <> 'Offline'


--11.FLO tablosundan sipariş kanalı 'Offline' olmayan ve online alışverişlerinde ödediği toplam ücret 1000'den fazla olan kayıtları getiren  sorguyu yazınız
SELECT *
FROM flo 
WHERE last_order_channel NOT LIKE '%Offline%' AND Customer_value_total_ever_online >1000


--12.FLO  tablosundan  alışveriş  yapılan  platforma  ait  sipariş  kanalı  ‘Mobile‘  olan,  online  ve  offline  alışveriş  yapan müşterilerin toplam cirolarını getiren sorguyu yazınız
SELECT
SUM(Customer_value_total_ever_online) AS OnlineToplamCiro,
SUM(customer_value_total_ever_offline) AS OfflineToplamCiro
FROM flo 
WHERE order_channel LIKE '%Mobile%'

-- 13.«interested_in_categories_12» kategorisinde içerisinde “SPOR” geçen verileri getirecek sorguyu yazınız.
SELECT *
FROM flo
WHERE interested_in_categories_12 LIKE '%SPOR%'

--14.Müşterinin offline alışverişlerinde ödediği ücretin 0 ile 10.000 arasında olduğu kayıtları getiren sorguyu yazınız.
SELECT *
FROM flo 
WHERE customer_value_total_ever_offline>0 AND customer_value_total_ever_offline<10000

--15.«interested_in_categories_12» ve order_channel bazında online sipariş adetlerini toplayan sorguyu yazınız.
SELECT interested_in_categories_12, order_channel,
SUM(order_num_total_ever_online) AS OnlineSiparisAdet
FROM flo
GROUP BY interested_in_categories_12, order_channel

--16. En  son  alışveriş  yapılan  kanal  (last_order_channel)  bazında,  her  bir    kategoriden(interested_in_categories_12)  kaç adet alışveriş yapıldığını getiren sorguyu yazınız ve adet sayısına göre büyükten küçüğe doğru sıralayanız.
SELECT  last_order_channel, interested_in_categories_12, 
SUM(order_num_total_ever_offline+order_num_total_ever_online) as ToplamAlisverisAdet
FROM flo
GROUP BY last_order_channel, interested_in_categories_12

--17.En çok alışveriş yapan 50 kişinin ID’ sini getiren sorguyu yazınız.
SELECT TOP 50 master_id, 
SUM(order_num_total_ever_online) + SUM(order_num_total_ever_offline) as frequency
FROM flo
GROUP BY master_id
ORDER BY 2 DESC

--18. First Order Date e  göre yıl bazında müşteri sayısını getiren sorgu
SELECT YEAR(first_order_date) AS Yıl, 
COUNT(master_id) AS MüşteriSayısı
FROM flo
GROUP BY YEAR(first_order_date)

--19.Last order date i 2020 olan müşterilerin sayısını getiren sorgu
SELECT 
COUNT(master_id) AS MüşteriSayısı
FROM flo
WHERE YEAR(last_order_date) = 2020

--20.Sadece  [AKTIFSPOR]  dan  alışveriş  yapmış  kişilerin  Order  Channel’larını  sağ  tarafa  kolon  olarak  ekleyen  sorguyu yazınız.
SELECT master_id, interested_in_categories_12, order_channel
FROM flo
WHERE interested_in_categories_12 = '[AKTIFSPOR]'


--21.İçerisinde [AKTIFSPOR] dan alışveriş yapmış kişilerin Order Channel’larını sağ tarafa kolon olarak ekleyen sorguyu yazınız. 
SELECT master_id, interested_in_categories_12, order_channel
FROM flo
WHERE interested_in_categories_12 LIKE '%AKTIFSPOR%'


--22  2018/2019  yılları  arasında  arası  her  ay  yeni  gelen  müşteri  sayısını  yıl  ve  ay  kolonları  ile  birlikte  getiren  sorguyu yazınız.
SELECT YEAR(first_order_date) AS YIL, MONTH(first_order_date) AS AY, COUNT(master_id) AS MusteriSayisi
FROM flo
WHERE YEAR(first_order_date) BETWEEN 2018 AND 2019
GROUP BY YEAR(first_order_date), MONTH(first_order_date)

--23.Order_channel'da mobile veya desktop siparişlerinde interested_in_categories_12 de 'AKTIFSPOR' olmayan kayıtları getiren sorguyu yazınız.
SELECT *
FROM flo
WHERE order_channel IN ('mobile', 'desktop') AND interested_in_categories_12 NOT LIKE '%AKTIFSPOR%'

--24.Order_channel'da 'Mobile' veya 'Desktop' siparişlerin kayıtlarını getiren sorguyu yazınız.
SELECT *
FROM flo
WHERE order_channel IN ('mobile', 'desktop')


--25.Onlinedaki en çok siparişin olduğu ayı ve bu aydaki toplam siparişi(ciro) getiren sorguyu yazınız.
SELECT top 1 MONTH(first_order_date) AS Ay, SUM(customer_value_total_ever_online) AS AylıkToplamCiro_Online 
FROM flo
GROUP BY MONTH(first_order_date)
ORDER BY 2 DESC

------------------------------ NORTHWIND DATABASE ------------------------------------

-- 26.  Müşteriler ve onların verdiği siparişlerin detaylarını listeyecek sorguyu inner join ile yazınız.
--customers ve ordersDetail tablolarını birleştireceğiz
SELECT *
FROM Customers c INNER JOIN Orders o
ON c.CustomerID = o.CustomerID


-- 27.  Müşteriler ve onların verdiği siparişlerin detaylarını listeyecek sorguyu left join ile yazınız.
SELECT *
FROM Customers c LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID

-- 28.  Müşteriler ve onların verdiği siparişlerin detaylarını listeyecek sorguyu right join ile yazınız.
SELECT *
FROM Customers c RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID

