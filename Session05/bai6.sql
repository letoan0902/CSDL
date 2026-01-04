select * from products 
where status = 'active' 
    and price >= 1000000 
    and price <= 3000000 
order by price asc 
limit 10 offset 0;

select * from products 
where status = 'active' 
    and price >= 1000000 
    and price <= 3000000 
order by price asc 
limit 10 offset 10;

select * from products 
where status = 'active' 
    and price between 1000000 and 3000000 
order by price asc 
limit 10 offset 0;

select * from products 
where status = 'active' 
    and price between 1000000 and 3000000 
order by price asc 
limit 10 offset 10;
