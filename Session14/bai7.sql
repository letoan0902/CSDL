-- Bài 7: Follow user bằng stored procedure với transaction

-- Tạo bảng followers
create table followers (
    follower_id int not null,
    followed_id int not null,
    primary key (follower_id, followed_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followed_id) references users(user_id) on delete cascade
);

-- Thêm cột following_count và followers_count vào users
alter table users add column following_count int default 0;
alter table users add column followers_count int default 0;

-- Tạo bảng follow_log để ghi log lỗi
create table follow_log (
    log_id int primary key auto_increment,
    follower_id int,
    followed_id int,
    error_message text,
    log_date datetime default current_timestamp
);

-- Stored procedure sp_follow_user
delimiter //
create procedure sp_follow_user(
    in p_follower_id int,
    in p_followed_id int
)
begin
    declare v_follower_exists int;
    declare v_followed_exists int;
    declare v_already_follows int;
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    start transaction;
    
    -- Kiểm tra follower có tồn tại không
    select count(*) into v_follower_exists
    from users
    where user_id = p_follower_id;
    
    -- Kiểm tra followed có tồn tại không
    select count(*) into v_followed_exists
    from users
    where user_id = p_followed_id;
    
    if v_follower_exists = 0 or v_followed_exists = 0 then
        insert into follow_log (follower_id, followed_id, error_message)
        values (p_follower_id, p_followed_id, 'User does not exist');
        rollback;
        signal sqlstate '45000'
        set message_text = 'User does not exist';
    end if;
    
    -- Kiểm tra không tự follow chính mình
    if p_follower_id = p_followed_id then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Cannot follow yourself';
    end if;
    
    -- Kiểm tra chưa follow trước đó
    select count(*) into v_already_follows
    from followers
    where follower_id = p_follower_id
    and followed_id = p_followed_id;
    
    if v_already_follows > 0 then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Already following this user';
    end if;
    
    -- Thực hiện follow
    insert into followers (follower_id, followed_id)
    values (p_follower_id, p_followed_id);
    
    update users
    set following_count = following_count + 1
    where user_id = p_follower_id;
    
    update users
    set followers_count = followers_count + 1
    where user_id = p_followed_id;
    
    commit;
end //
delimiter ;

-- Gọi procedure với trường hợp thành công
call sp_follow_user(1, 2);
call sp_follow_user(2, 3);
call sp_follow_user(3, 1);

-- Kiểm tra kết quả
select * from followers;
select * from users;

