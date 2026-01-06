create table customers (
    customer_id int primary key auto_increment,
    full_name varchar(255) not null,
    city varchar(255)
);

create table orders (
    order_id int primary key auto_increment,
    customer_id int,
    order_date date,
    status enum('pending', 'completed', 'cancelled'),
    foreign key (customer_id) references customers(customer_id)
);

insert into customers (full_name, city) values
('nguyễn văn an', 'hà nội'),
('trần thị bình', 'hồ chí minh'),
('lê văn cường', 'đà nẵng'),
('phạm thị dung', 'hải phòng'),
('hoàng văn em', 'cần thơ'),
('vũ thị phương', 'hà nội');

insert into orders (customer_id, order_date, status) values
(1, '2024-01-15', 'completed'),
(1, '2024-01-20', 'completed'),
(2, '2024-01-18', 'pending'),
(3, '2024-01-22', 'completed'),
(4, '2024-01-25', 'cancelled'),
(1, '2024-02-01', 'completed'),
(2, '2024-02-05', 'completed'),
(5, '2024-02-10', 'pending');

select 
    o.order_id,
    c.full_name,
    o.order_date,
    o.status
from orders o
inner join customers c on o.customer_id = c.customer_id;

select 
    c.customer_id,
    c.full_name,
    count(o.order_id) as so_don_hang
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;

select 
    c.customer_id,
    c.full_name,
    count(o.order_id) as so_don_hang
from customers c
inner join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
having count(o.order_id) >= 1;
