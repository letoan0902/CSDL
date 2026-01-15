-- Bài 1: Tạo bảng users và posts với triggers

-- Tạo bảng users
create table users (
    user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    created_at date,
    follower_count int default 0,
    post_count int default 0
);

-- Tạo bảng posts
create table posts (
    post_id int primary key auto_increment,
    user_id int,
    content text,
    created_at datetime,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- Thêm dữ liệu mẫu vào users
insert into users (username, email, created_at) values
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- Trigger after insert trên posts
delimiter //
create trigger trg_after_insert_post
after insert on posts
for each row
begin
    update users 
    set post_count = post_count + 1 
    where user_id = new.user_id;
end //
delimiter ;

-- Trigger after delete trên posts
delimiter //
create trigger trg_after_delete_post
after delete on posts
for each row
begin
    update users 
    set post_count = post_count - 1 
    where user_id = old.user_id;
end //
delimiter ;

-- Thêm các bài đăng
insert into posts (user_id, content, created_at) values
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

-- Kiểm tra bảng users
select * from users;

-- Xóa một bài đăng (post_id = 2)
delete from posts where post_id = 2;

-- Kiểm tra lại bảng users
select * from users;

