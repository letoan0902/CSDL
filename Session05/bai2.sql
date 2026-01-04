create table customers (
    customer_id int primary key,
    full_name varchar(255),
    email varchar(255),
    city varchar(255),
    status enum('active', 'inactive')
);

select * from customers;

select * from customers where city = 'TP.HCM';

select * from customers where status = 'active' and city = 'Hà Nội';

select * from customers order by full_name asc;
