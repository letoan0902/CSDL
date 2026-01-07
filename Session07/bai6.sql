insert into orders (customer_id, order_date, total_amount) values
(17, '2024-04-25', 11500000),
(1, '2024-05-01', 8200000),
(2, '2024-05-05', 16000000),
(3, '2024-05-10', 4900000),
(4, '2024-05-15', 13500000);

select customer_id, sum(total_amount) as tong_tien
from orders
group by customer_id
having sum(total_amount) > (
    select avg(tong_tien_moi_khach) from (
        select sum(total_amount) as tong_tien_moi_khach
        from orders
        group by customer_id
    ) as trung_binh_khach
);
