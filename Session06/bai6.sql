select 
    p.product_name as ten_san_pham,
    sum(oi.quantity) as tong_so_luong_ban,
    sum(oi.quantity * p.price) as tong_doanh_thu,
    avg(p.price) as gia_ban_trung_binh
from products p
inner join order_items oi on p.product_id = oi.product_id
inner join orders o on oi.order_id = o.order_id
where o.status = 'completed'
group by p.product_id, p.product_name
having sum(oi.quantity) >= 10
order by tong_doanh_thu desc
limit 5;
