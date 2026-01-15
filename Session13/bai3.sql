-- Bài 3: Cập nhật triggers trên likes với kiểm tra self-like

-- Xóa triggers cũ nếu tồn tại
drop trigger if exists trg_before_insert_like;
drop trigger if exists trg_after_insert_like;
drop trigger if exists trg_after_delete_like;
drop trigger if exists trg_after_update_like;

-- Trigger before insert: Kiểm tra không cho phép self-like
delimiter //
create trigger trg_before_insert_like
before insert on likes
for each row
begin
    declare post_owner_id int;
    select user_id into post_owner_id 
    from posts 
    where post_id = new.post_id;
    
    if new.user_id = post_owner_id then
        signal sqlstate '45000'
        set message_text = 'Cannot like your own post';
    end if;
end //
delimiter ;

-- Trigger after insert: Cập nhật like_count
delimiter //
create trigger trg_after_insert_like
after insert on likes
for each row
begin
    update posts 
    set like_count = like_count + 1 
    where post_id = new.post_id;
end //
delimiter ;

-- Trigger after delete: Cập nhật like_count
delimiter //
create trigger trg_after_delete_like
after delete on likes
for each row
begin
    update posts 
    set like_count = like_count - 1 
    where post_id = old.post_id;
end //
delimiter ;

-- Trigger after update: Điều chỉnh like_count khi đổi post_id
delimiter //
create trigger trg_after_update_like
after update on likes
for each row
begin
    if old.post_id != new.post_id then
        update posts set like_count = like_count - 1 where post_id = old.post_id;
        update posts set like_count = like_count + 1 where post_id = new.post_id;
    end if;
end //
delimiter ;

-- Test 1: Thử like bài của chính mình (phải báo lỗi)
-- insert into likes (user_id, post_id, liked_at) values (1, 1, now());

-- Test 2: Thêm like hợp lệ
insert into likes (user_id, post_id, liked_at) values (2, 3, now());
select * from posts where post_id = 3;

-- Test 3: update một like sang post khác
update likes set post_id = 4 where user_id = 2 and post_id = 3;
select * from posts where post_id in (3, 4);

-- Test 4: Xóa like
delete from likes where user_id = 2 and post_id = 4;
select * from posts where post_id = 4;

-- Kiểm chứng posts và user_statistics
select * from posts;
select * from user_statistics;

