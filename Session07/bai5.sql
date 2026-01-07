insert into customers (name, email) values
('trịnh văn quang', 'quang@gmail.com'),
('mai thị rạng', 'rang@gmail.com'),
('cao văn sơn', 'son@gmail.com'),
('đinh thị tuyết', 'tuyet@gmail.com'),
('phùng văn uy', 'uy@gmail.com');

insert into orders (customer_id, order_date, total_amount) values
(13, '2024-04-01', 25000000),
(13, '2024-04-05', 18000000),
(14, '2024-04-10', 9500000),
(15, '2024-04-15', 14000000),
(16, '2024-04-20', 6800000);

select * from customers
where id = (
    select customer_id from orders
    group by customer_id
    having sum(total_amount) = (
        select max(tong_tien) from (
            select sum(total_amount) as tong_tien
            from orders
            group by customer_id
        ) as tong_theo_khach
    )
);
