create table products (
    id int primary key auto_increment,
    name varchar(255) not null,
    price decimal(10,2) not null
);

create table order_items (
    order_id int,
    product_id int,
    quantity int not null,
    primary key (order_id, product_id),
    foreign key (order_id) references orders(id),
    foreign key (product_id) references products(id)
);

insert into products (name, price) values
('điện thoại samsung galaxy', 15000000),
('laptop dell inspiron', 20000000),
('tai nghe bluetooth sony', 2500000),
('máy tính bảng ipad', 18000000),
('đồng hồ thông minh apple watch', 8000000),
('loa bluetooth jbl', 3500000),
('chuột gaming logitech', 1500000);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 4, 3),
(4, 5, 2),
(5, 6, 1),
(6, 1, 1);

select * from products
where id in (select product_id from order_items);
