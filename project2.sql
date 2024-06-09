--1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select 
FORMAT_DATE("%Y-%m", created_at) AS Month_Year,
SUM(DISTINCT user_id) AS total_user,
SUM(DISTINCT order_id) AS total_order
from bigquery-public-data.thelook_ecommerce.orders
WHERE created_at between '2019-01-01' and '2022-04-30'
GROUP BY created_at
ORDER BY created_at

--2. Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select 
FORMAT_DATE("%Y-%m", created_at) AS Month_Year,
ROUND((SUM(sale_price)/COUNT(DISTINCT order_id)),2) AS average_order_value,
Sum(DISTINCT user_id) as distinct_users
from bigquery-public-data.thelook_ecommerce.order_items
WHERE created_at between '2019-01-01' and '2022-04-30'
group by created_at
order by created_at

--3. Nhóm khách hàng theo độ tuổi
SELECT first_name, last_name, gender, age,
  CASE
    WHEN age = 12 THEN 'youngest'
    WHEN age = 70 THEN 'oldest'
    END AS tag
from bigquery-public-data.thelook_ecommerce.users;
select 
count(age)
from bigquery-public-data.thelook_ecommerce.users
where age > 69
--insight: Độ tuổi nhỏ nhất là 12, với 1724 khách hàng. Độ tuổi lớn nhất là 70, với 1588 khách hàng.

--4.Top 5 sản phẩm mỗi tháng
