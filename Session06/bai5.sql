select 
    c.customer_id,
    c.full_name,
    count(o.order_id) as tong_so_don_hang,
    sum(o.total_amount) as tong_tien_da_chi,
    avg(o.total_amount) as gia_tri_don_hang_trung_binh
from customers c
inner join orders o on c.customer_id = o.customer_id
where o.status = 'completed'
group by c.customer_id, c.full_name
having count(o.order_id) >= 3 and sum(o.total_amount) > 10000000
order by tong_tien_da_chi desc;
