create table products (
    product_id int primary key auto_increment,
    product_name varchar(255) not null,
    price decimal(10,2) not null
);

create table order_items (
    order_id int,
    product_id int,
    quantity int not null,
    primary key (order_id, product_id),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

insert into products (product_name, price) values
('điện thoại samsung galaxy', 15000000),
('laptop dell inspiron', 20000000),
('tai nghe bluetooth sony', 2500000),
('máy tính bảng ipad', 18000000),
('đồng hồ thông minh apple watch', 8000000),
('loa bluetooth jbl', 3500000);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 4, 3),
(4, 5, 2),
(5, 6, 1),
(6, 1, 1),
(7, 2, 2),
(8, 3, 5);

select 
    p.product_id,
    p.product_name,
    sum(oi.quantity) as tong_so_luong_ban
from products p
left join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name;

select 
    p.product_id,
    p.product_name,
    sum(oi.quantity * p.price) as doanh_thu
from products p
left join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name;

select 
    p.product_id,
    p.product_name,
    sum(oi.quantity * p.price) as doanh_thu
from products p
left join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name
having sum(oi.quantity * p.price) > 5000000;
