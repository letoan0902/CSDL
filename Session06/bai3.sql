select 
    order_date,
    sum(total_amount) as tong_doanh_thu
from orders
where status = 'completed'
group by order_date;

select 
    order_date,
    count(order_id) as so_luong_don
from orders
where status = 'completed'
group by order_date;

select 
    order_date,
    sum(total_amount) as tong_doanh_thu
from orders
where status = 'completed'
group by order_date
having sum(total_amount) > 10000000;
