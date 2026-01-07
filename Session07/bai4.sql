insert into customers (name, email) values
('ngô văn hùng', 'hung@gmail.com'),
('bùi thị lan', 'lan@gmail.com'),
('đỗ văn minh', 'minh@gmail.com'),
('hồ thị ngọc', 'ngoc@gmail.com'),
('lý văn phát', 'phat@gmail.com');

insert into orders (customer_id, order_date, total_amount) values
(8, '2024-03-05', 8800000),
(9, '2024-03-10', 5500000),
(10, '2024-03-15', 12000000),
(11, '2024-03-20', 3300000),
(12, '2024-03-25', 7700000);

select 
    c.name,
    (select count(*) from orders o where o.customer_id = c.id) as so_don_hang
from customers c;
