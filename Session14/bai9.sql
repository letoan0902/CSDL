-- Bài 9: Xóa bài viết hoàn toàn bằng stored procedure

-- Tạo bảng delete_log
create table delete_log (
    log_id int primary key auto_increment,
    post_id int,
    deleted_at datetime default current_timestamp,
    deleted_by int
);

-- Stored procedure sp_delete_post
delimiter //
create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare v_post_owner_id int;
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    start transaction;
    
    -- Kiểm tra bài viết tồn tại và thuộc về user
    select user_id into v_post_owner_id
    from posts
    where post_id = p_post_id;
    
    if v_post_owner_id is null then
        rollback;
        signal sqlstate '45000'
        set message_text = 'Post does not exist';
    end if;
    
    if v_post_owner_id != p_user_id then
        rollback;
        signal sqlstate '45000'
        set message_text = 'You do not have permission to delete this post';
    end if;
    
    -- Xóa likes
    delete from likes
    where post_id = p_post_id;
    
    -- Xóa comments
    delete from comments
    where post_id = p_post_id;
    
    -- Xóa post
    delete from posts
    where post_id = p_post_id;
    
    -- Giảm posts_count
    update users
    set posts_count = posts_count - 1
    where user_id = p_user_id;
    
    -- Ghi log
    insert into delete_log (post_id, deleted_by)
    values (p_post_id, p_user_id);
    
    commit;
end //
delimiter ;

-- Thêm dữ liệu mẫu để test
insert into posts (user_id, content) values
(1, 'Post to be deleted by Alice'),
(2, 'Post by Bob');

insert into likes (post_id, user_id) values
(1, 2),
(1, 3);

insert into comments (post_id, user_id, content) values
(1, 2, 'Comment 1'),
(1, 3, 'Comment 2');

-- Kiểm tra trước khi xóa
select * from posts;
select * from likes;
select * from comments;
select * from users;

-- Gọi procedure với trường hợp hợp lệ
call sp_delete_post(1, 1);

-- Kiểm tra sau khi xóa
select * from posts;
select * from likes;
select * from comments;
select * from users;
select * from delete_log;



