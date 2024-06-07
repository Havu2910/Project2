--1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select 
FORMAT_DATE("%Y-%m", created_at) AS Month_Year,
SUM(DISTINCT user_id) AS total_user,
SUM(DISTINCT order_id) AS total_order
from bigquery-public-data.thelook_ecommerce.orders
WHERE created_at between '2019-01-01' and '2022-04-30'
GROUP BY created_at
ORDER BY created_at
--insight: 
