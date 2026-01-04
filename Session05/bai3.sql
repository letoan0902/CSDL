create table orders (
    order_id int primary key,
    customer_id int,
    total_amount decimal(10,2),
    order_date date,
    status enum('pending', 'completed', 'cancelled')
);

select * from orders where status = 'completed';

select * from orders where total_amount > 5000000;

select * from orders order by order_date desc limit 5;

select * from orders where status = 'completed' order by total_amount desc;
