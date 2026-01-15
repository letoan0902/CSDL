-- Bài 4: Tạo bảng post_history và trigger lưu lịch sử chỉnh sửa

-- Tạo bảng post_history
create table post_history (
    history_id int primary key auto_increment,
    post_id int,
    old_content text,
    new_content text,
    changed_at datetime,
    changed_by_user_id int,
    foreign key (post_id) references posts(post_id) on delete cascade
);

-- Trigger before update trên posts: Lưu lịch sử khi content thay đổi
delimiter //
create trigger trg_before_update_post
before update on posts
for each row
begin
    if old.content != new.content then
        insert into post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
        values (old.post_id, old.content, new.content, now(), old.user_id);
    end if;
end //
delimiter ;

-- update nội dung một số bài đăng
update posts set content = 'Updated: Hello world from Alice!' where post_id = 1;
update posts set content = 'Updated: Bob first post - edited' where post_id = 3;

-- Xem lịch sử chỉnh sửa
select * from post_history;

-- Kiểm tra trigger like_count vẫn hoạt động khi update post
-- (Cập nhật post không ảnh hưởng đến like_count, chỉ khi update likes)
select * from posts;

