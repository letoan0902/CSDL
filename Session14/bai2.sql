-- Bài 2: Quản lý đặt hàng và tồn kho

-- Tạo bảng products
create table products (
    product_id int primary key auto_increment,
    product_name varchar(100) not null,
    stock int default 0,
    price decimal(10,2) not null
);

-- Tạo bảng orders
create table orders (
    order_id int primary key auto_increment,
    product_id int,
    quantity int not null,
    order_date datetime default now(),
    foreign key (product_id) references products(product_id) on delete cascade
);

-- Thêm dữ liệu mẫu
insert into products (product_name, stock, price) values
('Laptop', 10, 15000000.00),
('Mouse', 50, 200000.00),
('Keyboard', 30, 500000.00);

-- Stored Procedure đặt hàng
delimiter //
create procedure place_order(
    in p_product_id int,
    in p_quantity int
)
begin
    declare v_stock int;
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    start transaction;
    
    select stock into v_stock
    from products
    where product_id = p_product_id;
    
    if v_stock < p_quantity then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Insufficient stock';
    end if;
    
    insert into orders (product_id, quantity, order_date)
    values (p_product_id, p_quantity, now());
    
    update products
    set stock = stock - p_quantity
    where product_id = p_product_id;
    
    commit;
end //
delimiter ;

-- Gọi stored procedure
call place_order(1, 2);
call place_order(2, 5);

-- Kiểm tra kết quả
select * from products;
select * from orders;

