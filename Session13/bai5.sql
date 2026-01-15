-- Bài 5: Tạo Stored Procedure và trigger validation cho users

-- Stored Procedure add_user
delimiter //
create procedure add_user(
    in p_username varchar(50),
    in p_email varchar(100),
    in p_created_at date
)
begin
    insert into users (username, email, created_at)
    values (p_username, p_email, p_created_at);
end //
delimiter ;

-- Trigger before insert trên users: Validation
delimiter //
create trigger trg_before_insert_user
before insert on users
for each row
begin
    if new.email not like '%@%.%' then
        signal sqlstate '45000'
        set message_text = 'Email must contain @ and .';
    end if;
    
    if new.username not regexp '^[a-zA-Z0-9_]+$' then
        signal sqlstate '45000'
        set message_text = 'Username must contain only letters, numbers, and underscore';
    end if;
end //
delimiter ;

-- Test với dữ liệu hợp lệ
call add_user('david', 'david@example.com', '2025-01-15');

-- Test với dữ liệu không hợp lệ (email)
-- call add_user('eve', 'eveexample.com', '2025-01-16');

-- Test với dữ liệu không hợp lệ (username)
-- call add_user('frank!', 'frank@example.com', '2025-01-17');

-- Kiểm tra kết quả
select * from users;

