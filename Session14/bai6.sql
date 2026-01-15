-- Bài 6: Like bài viết bằng transaction

-- Tạo bảng likes
create table likes (
    like_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    foreign key (post_id) references posts(post_id) on delete cascade,
    foreign key (user_id) references users(user_id) on delete cascade,
    unique key unique_like (post_id, user_id)
);

-- Thêm cột likes_count vào bảng posts nếu chưa có
alter table posts add column likes_count int default 0;

-- Thêm dữ liệu mẫu posts nếu chưa có
insert into posts (user_id, content) values
(1, 'Post 1 by Alice'),
(2, 'Post 1 by Bob');

-- Trường hợp thành công (like lần đầu)
start transaction;

insert into likes (post_id, user_id) values (1, 2);

update posts
set likes_count = likes_count + 1
where post_id = 1;

commit;

-- Kiểm tra kết quả
select * from likes;
select * from posts;

-- Trường hợp thất bại (like trùng - vi phạm unique constraint)
start transaction;

insert into likes (post_id, user_id) values (1, 2);

update posts
set likes_count = likes_count + 1
where post_id = 1;

commit;

-- Kiểm tra sau rollback
select * from likes;
select * from posts;

