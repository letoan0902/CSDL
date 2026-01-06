alter table orders add column total_amount decimal(10,2);

update orders set total_amount = 5500000 where order_id = 1;
update orders set total_amount = 3200000 where order_id = 2;
update orders set total_amount = 8900000 where order_id = 3;
update orders set total_amount = 12500000 where order_id = 4;
update orders set total_amount = 2100000 where order_id = 5;
update orders set total_amount = 7800000 where order_id = 6;
update orders set total_amount = 4300000 where order_id = 7;
update orders set total_amount = 9600000 where order_id = 8;

select 
    c.customer_id,
    c.full_name,
    sum(o.total_amount) as tong_chi_tieu
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

select 
    c.customer_id,
    c.full_name,
    max(o.total_amount) as don_hang_cao_nhat
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

select 
    c.customer_id,
    c.full_name,
    sum(o.total_amount) as tong_chi_tieu
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
order by tong_chi_tieu desc;
