select * from orders 
where status != 'cancelled' 
order by order_date desc 
limit 5 offset 0;

select * from orders 
where status != 'cancelled' 
order by order_date desc 
limit 5 offset 5;

select * from orders 
where status != 'cancelled' 
order by order_date desc 
limit 5 offset 10;
