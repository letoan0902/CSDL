create table products (
    product_id int primary key,
    product_name varchar(255),
    price decimal(10,2),
    stock int,
    status enum('active', 'inactive')
);

select * from products;

select * from products where status = 'active';

select * from products where price > 1000000;

select * from products where status = 'active' order by price asc;
