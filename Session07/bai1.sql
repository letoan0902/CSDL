create table customers (
    id int primary key auto_increment,
    name varchar(255) not null,
    email varchar(255)
);

create table orders (
    id int primary key auto_increment,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    foreign key (customer_id) references customers(id)
);

insert into customers (name, email) values
('nguyễn văn an', 'an@gmail.com'),
('trần thị bình', 'binh@gmail.com'),
('lê văn cường', 'cuong@gmail.com'),
('phạm thị dung', 'dung@gmail.com'),
('hoàng văn em', 'em@gmail.com'),
('vũ thị phương', 'phuong@gmail.com'),
('đặng văn giang', 'giang@gmail.com');

insert into orders (customer_id, order_date, total_amount) values
(1, '2024-01-15', 5500000),
(1, '2024-01-20', 3200000),
(2, '2024-01-18', 8900000),
(3, '2024-01-22', 12500000),
(4, '2024-01-25', 2100000),
(5, '2024-02-01', 7800000),
(2, '2024-02-05', 4300000);

select * from customers
where id in (select customer_id from orders);
