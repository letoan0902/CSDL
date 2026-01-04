alter table products add column sold_quantity int;

select * from products order by sold_quantity desc limit 10;

select * from products order by sold_quantity desc limit 5 offset 10;

select * from products where price < 2000000 order by sold_quantity desc;
