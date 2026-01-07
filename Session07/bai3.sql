insert into orders (customer_id, order_date, total_amount) values
(6, '2024-02-10', 9600000),
(7, '2024-02-15', 15000000),
(3, '2024-02-20', 6200000),
(1, '2024-02-25', 11000000),
(4, '2024-03-01', 4500000);

select * from orders
where total_amount > (select avg(total_amount) from orders);
