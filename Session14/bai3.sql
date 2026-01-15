-- Bài 3: Quản lý quỹ công ty và trả lương nhân viên

-- Tạo bảng employees
create table employees (
    emp_id int primary key auto_increment,
    emp_name varchar(100) not null,
    salary decimal(10,2) not null
);

-- Tạo bảng company_funds
create table company_funds (
    fund_id int primary key auto_increment,
    balance decimal(10,2) default 0.00
);

-- Tạo bảng payroll
create table payroll (
    payroll_id int primary key auto_increment,
    emp_id int,
    amount decimal(10,2) not null,
    payment_date datetime default now(),
    foreign key (emp_id) references employees(emp_id) on delete cascade
);

-- Thêm dữ liệu mẫu
insert into employees (emp_name, salary) values
('Nguyễn Văn A', 10000000.00),
('Trần Thị B', 8000000.00),
('Lê Văn C', 12000000.00);

insert into company_funds (balance) values (50000000.00);

-- Stored Procedure trả lương
delimiter //
create procedure pay_salary(
    in p_emp_id int
)
begin
    declare v_salary decimal(10,2);
    declare v_balance decimal(10,2);
    declare bank_error int default 0;
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    start transaction;
    
    select salary into v_salary
    from employees
    where emp_id = p_emp_id;
    
    select balance into v_balance
    from company_funds
    where fund_id = 1;
    
    if v_balance < v_salary then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Insufficient company funds';
    end if;
    
    update company_funds
    set balance = balance - v_salary
    where fund_id = 1;
    
    insert into payroll (emp_id, amount, payment_date)
    values (p_emp_id, v_salary, now());
    
    -- Giả lập kiểm tra hệ thống ngân hàng
    -- Nếu có lỗi, set bank_error = 1
    -- Ở đây giả sử hệ thống hoạt động bình thường
    -- Để test lỗi, có thể uncomment dòng dưới:
    -- set bank_error = 1;
    
    if bank_error = 1 then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Bank system error';
    end if;
    
    commit;
end //
delimiter ;

-- Gọi stored procedure
call pay_salary(1);
call pay_salary(2);

-- Kiểm tra kết quả
select * from company_funds;
select * from payroll;

