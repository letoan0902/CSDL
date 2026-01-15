-- Bài 1: Quản lý tài khoản ngân hàng và chuyển tiền

-- Tạo bảng accounts
create table accounts (
    account_id int primary key auto_increment,
    account_name varchar(100) not null,
    balance decimal(10,2) default 0.00
);

-- Thêm dữ liệu mẫu
insert into accounts (account_name, balance) values 
('Nguyễn Văn An', 1000.00),
('Trần Thị Bảy', 500.00);

-- Stored Procedure chuyển tiền
delimiter //
create procedure transfer_money(
    in from_account int,
    in to_account int,
    in amount decimal(10,2)
)
begin
    declare from_balance decimal(10,2);
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    start transaction;
    
    select balance into from_balance
    from accounts
    where account_id = from_account;
    
    if from_balance < amount then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Insufficient balance';
    end if;
    
    update accounts
    set balance = balance - amount
    where account_id = from_account;
    
    update accounts
    set balance = balance + amount
    where account_id = to_account;
    
    commit;
end //
delimiter ;

-- Gọi stored procedure
call transfer_money(1, 2, 200.00);

-- Kiểm tra kết quả
select * from accounts;

