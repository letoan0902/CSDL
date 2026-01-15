-- Bài 8: Đăng bình luận với savepoint

-- Tạo bảng comments
create table comments (
    comment_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id) on delete cascade,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- Thêm cột comments_count vào posts nếu chưa có
alter table posts add column comments_count int default 0;

-- Stored procedure sp_post_comment
delimiter //
create procedure sp_post_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
begin
    declare post_exists int;
    declare update_error int default 0;
    declare continue handler for sqlexception
    begin
        set update_error = 1;
    end;
    
    start transaction;
    
    insert into comments (post_id, user_id, content)
    values (p_post_id, p_user_id, p_content);
    
    savepoint after_insert;
    
    -- Kiểm tra post có tồn tại không
    select count(*) into post_exists
    from posts
    where post_id = p_post_id;
    
    if post_exists = 0 then
        rollback to savepoint after_insert;
        commit;
        signal sqlstate '45000'
        set message_text = 'Post not found';
    else
        update posts
        set comments_count = comments_count + 1
        where post_id = p_post_id;
        
        if update_error = 1 then
            rollback to savepoint after_insert;
            commit;
            signal sqlstate '45000'
            set message_text = 'Error updating comments_count';
        else
            commit;
        end if;
    end if;
end //
delimiter ;

-- Gọi procedure với trường hợp thành công
call sp_post_comment(1, 2, 'Great post!');
call sp_post_comment(1, 3, 'I agree with this.');

-- Kiểm tra kết quả
select * from comments;
select * from posts;
