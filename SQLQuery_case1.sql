--1:Veri seti serverda kuruldu.
SELECT*FROM flo_hatali
--2:
SELECT 
DISTINCT(COUNT(master_id)) AS KisiSayisi
FROM flo_hatali
--3:
SELECT 
SUM(order_num_total_ever_offline+order_num_total_ever_online) AS ToplamSiparisSayısı,
SUM(customer_value_total_ever_offline+customer_value_total_ever_online) AS ToplamCiro
FROM flo_hatali
--4:
SELECT 
SUM(customer_value_total_ever_offline+customer_value_total_ever_online)/
SUM(order_num_total_ever_offline+order_num_total_ever_online)
FROM flo_hatali
--5:
SELECT last_order_channel,
SUM(order_num_total_ever_offline+order_num_total_ever_online) AS ToplamSiparisSayısı,
SUM(customer_value_total_ever_offline+customer_value_total_ever_online) AS ToplamCiro
FROM flo_hatali
GROUP BY last_order_channel
--6: store_type -->order_channel
SELECT order_channel,
SUM(customer_value_total_ever_offline+customer_value_total_ever_online) AS ToplamCiro
FROM flo_hatali
GROUP BY order_channel
--7:
SELECT YEAR(first_order_date) AS Yıl, COUNT(master_id) AS ToplamAlısverisSayisi
FROM flo_hatali
GROUP BY YEAR(first_order_date)
--8:
SELECT order_channel, SUM(customer_value_total_ever_offline) + SUM(Customer_value_total_ever_online) AS ToplamCiro
FROM flo_hatali
GROUP BY order_channel
--9:
SELECT interested_in_categories_12,
COUNT(*)
FROM flo_hatali
GROUP BY interested_in_categories_12
--10: store_type yerine order_channel kullanıldı.
SELECT order_channel,
COUNT(Order_channel)
FROM flo_hatali
GROUP BY order_channel
ORDER BY 2 DESC
--11:
SELECT  last_order_channel, interested_in_categories_12, 
SUM(order_num_total_ever_offline+order_num_total_ever_online) as ToplamAlisverisAdet,
SUM(customer_value_total_ever_offline+customer_value_total_ever_online) as ToplamCiro
FROM flo_hatali
GROUP BY last_order_channel, interested_in_categories_12
--veya subquery kullanarak her kategori birimi özelinde inceleme:
SELECT DISTINCT last_order_channel,
    (SELECT TOP 1 interested_in_categories_12 
    FROM flo_hatali
    WHERE last_order_channel = flo_hatali.last_order_channel
    GROUP BY interested_in_categories_12
    ORDER BY SUM(order_num_total_ever_offline+order_num_total_ever_online) DESC) AS Kategori,
    (SELECT TOP 1 
    SUM(order_num_total_ever_offline+order_num_total_ever_online)
    FROM flo_hatali
    WHERE last_order_channel = flo_hatali.last_order_channel
    GROUP BY interested_in_categories_12
    ORDER BY SUM(order_num_total_ever_offline + order_num_total_ever_online) DESC) AS AlisverisSayisi
FROM flo_hatali

--12:
SELECT
TOP 1 master_id
FROM flo_hatali
ORDER BY(customer_value_total_ever_offline+customer_value_total_ever_online) DESC
--13:
SELECT
TOP 1 master_id,
SUM(customer_value_total_ever_offline+customer_value_total_ever_online)/
SUM(order_num_total_ever_offline+order_num_total_ever_online) AS OrtCiro,
SUM(order_num_total_ever_offline+order_num_total_ever_online) AS SiparisSayisi
FROM flo_hatali
GROUP BY master_id
ORDER BY SiparisSayisi DESC
--14:
SELECT TOP 100 master_id, 
SUM(order_num_total_ever_online) + SUM(order_num_total_ever_offline) as frequency,
SUM(customer_value_total_ever_offline+customer_value_total_ever_online) as monetary,
DATEDIFF(DAY, first_order_date,last_order_date)
FROM flo_hatali
GROUP BY master_id
ORDER BY 3 DESC
--15:
SELECT  last_order_channel, master_id, 
SUM(order_num_total_ever_offline+order_num_total_ever_online) as ToplamAlisverisAdet
FROM flo_hatali
GROUP BY last_order_channel, master_id
ORDER BY 3 DESC
--16:
SELECT TOP 1 master_id,
MAX(last_order_date)
FROM flo_hatali
GROUP BY master_id
ORDER BY 2 ASC