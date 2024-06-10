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
with cte1(
select 
a.name as product_name,
round(a.cost) as cost,
round(sum(a.retail_price-a.cost)) AS profit
from bigquery-public-data.thelook_ecommerce.products as a
JOIN bigquery-public-data.thelook_ecommerce.order_items as b
ON a.id = b.id
WHERE 
b.status = 'Complete'
group by 1,2), 
cte2 as (
select prduct_id,
FORMAT_DATE("%Y-%m", created_at) AS Month_Year
from bigquery-public-data.thelook_ecommerce.order_items),
cte3 as(
SELECT  *,
DEnse RANK() OVER (ORDER BY profit DESC) AS rank_per_month
FROM cte1
where rank_per_month <= 5)
select *
from cte1
union all
select * from cte 2
union all
select * from cte3

--5.Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
SELECT
FORMAT_DATE("%Y-%m-%d", oi.created_at) AS dates,
category AS product_category,
ROUND(SUM(sale_price * num_of_item), 2) AS revenue,
FROM bigquery-public-data.thelook_ecommerce.order_items oi
INNER JOIN bigquery-public-data.thelook_ecommerce.orders o
ON oi.order_id = o.order_id
INNER JOIN bigquery-public-data.thelook_ecommerce.products p
ON oi.product_id = p.id
WHERE oi.status NOT IN ('cancelled', 'Returned') and oi.created_at BETWEEN '2022-02-15' AND '2022-04-15'
GROUP BY category, oi.created_at 
ORDER BY revenue DESC
