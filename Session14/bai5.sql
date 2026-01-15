-- Bài 5: Đăng bài viết mới bằng transaction

-- Tạo bảng users
create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null,
    posts_count int default 0
);

-- Tạo bảng posts
create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- Thêm dữ liệu mẫu
insert into users (username) values
('alice'),
('bob'),
('charlie');

-- Trường hợp thành công (commit)
start transaction;

insert into posts (user_id, content) values (1, 'First post by Alice');

update users
set posts_count = posts_count + 1
where user_id = 1;

commit;

-- Kiểm tra kết quả
select * from users;
select * from posts;

-- Trường hợp thất bại (rollback) - user_id không tồn tại
start transaction;

insert into posts (user_id, content) values (999, 'Post by non-existent user');

update users
set posts_count = posts_count + 1
where user_id = 999;

-- Nếu có lỗi, MySQL sẽ tự động rollback do foreign key constraint
-- Hoặc có thể kiểm tra và rollback thủ công
rollback;

-- Kiểm tra sau rollback (dữ liệu không thay đổi)
select * from users;
select * from posts;

