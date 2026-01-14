-- === setup he thong (bai 1) ===
drop database if exists social_network;
create database social_network;
use social_network;

-- 1. tao bang users
create table users (
    user_id int auto_increment primary key,
    username varchar(50) unique not null,
    password varchar(255) not null,
    email varchar(100) unique not null,
    created_at datetime default current_timestamp
);

-- 2. tao bang posts
create table posts (
    post_id int auto_increment primary key,
    user_id int,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);

-- 3. tao bang comments
create table comments (
    comment_id int auto_increment primary key,
    post_id int,
    user_id int,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

-- 4. tao bang friends
create table friends (
    user_id int,
    friend_id int,
    status varchar(20) check (status in ('pending','accepted')),
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id),
    foreign key (friend_id) references users(user_id)
);

-- 5. tao bang likes
create table likes (
    user_id int,
    post_id int,
    primary key (user_id, post_id),
    foreign key (user_id) references users(user_id),
    foreign key (post_id) references posts(post_id)
);

-- insert du lieu mau co ban
insert into users (username, password, email) values 
('admin', '123456', 'admin@gmail.com'),
('student', '123456', 'student@gmail.com'),
('teacher', '123456', 'teacher@gmail.com');

-- === muc do trung binh (bai 2, 3) ===

-- bai 2: view ho so cong khai
create view vw_public_users as
select user_id, username, created_at from users;

-- bai 3: index cho username
create index idx_username on users(username);

-- === muc do kha (bai 4, 5, 6, 7) ===

delimiter //

-- bai 4: procedure dang bai viet
create procedure sp_create_post(
    in p_user_id int,
    in p_content text
)
begin
    if exists (select 1 from users where user_id = p_user_id) then
        insert into posts (user_id, content) values (p_user_id, p_content);
    else
        signal sqlstate '45000' set message_text = 'user khong ton tai';
    end if;
end //

-- bai 7: procedure thong ke hoat dong
create procedure sp_count_posts(
    in p_user_id int,
    out p_total int
)
begin
    select count(*) into p_total from posts where user_id = p_user_id;
end //

delimiter ;

-- bai 5: view news feed (7 ngay gan nhat)
create view vw_recent_posts as
select p.post_id, p.content, p.created_at, u.username
from posts p
join users u on p.user_id = u.user_id
where p.created_at >= date_sub(now(), interval 7 day);

-- bai 6: index toi uu va composite index
create index idx_post_user on posts(user_id);
create index idx_posts_user_time on posts(user_id, created_at);

-- === muc do gioi (bai 8, 9, 10, 11) ===

-- bai 8: view co check option
create view vw_active_users as
select * from users where user_id > 0 -- gia su logic loc user ao
with check option;

-- bai 11: view top posts va index likes
create view vw_top_posts as
select p.post_id, p.content, count(l.user_id) as like_count
from posts p
left join likes l on p.post_id = l.post_id
group by p.post_id
order by like_count desc
limit 5;

create index idx_likes_post on likes(post_id);

delimiter //

-- bai 9: procedure ket ban (chan tu ket ban voi minh)
create procedure sp_add_friend(
    in p_user_id int,
    in p_friend_id int
)
begin
    if p_user_id != p_friend_id then
        insert into friends (user_id, friend_id, status) 
        values (p_user_id, p_friend_id, 'pending');
    else
        signal sqlstate '45000' set message_text = 'khong the ket ban voi chinh minh';
    end if;
end //

-- bai 10: procedure goi y ban be (dung while)
create procedure sp_suggest_friends(
    in p_user_id int,
    inout p_limit int
)
begin
    -- tao bang tam de luu goi y
    create temporary table if not exists temp_suggest (uid int);
    
    -- logic while demo theo yeu cau de bai (thuc te nen dung cau lenh select truc tiep)
    while p_limit > 0 do
        insert into temp_suggest 
        select user_id from users 
        where user_id != p_user_id 
        and user_id not in (select friend_id from friends where user_id = p_user_id)
        limit 1;
        
        set p_limit = p_limit - 1;
    end while;
    
    select * from temp_suggest;
    drop temporary table temp_suggest;
end //

delimiter ;

-- === muc xuat sac (bai 12, 13, 14) ===

-- view bo tro cho bai 12, 13
create view vw_post_comments as
select c.content, u.username, c.created_at
from comments c join users u on c.user_id = u.user_id;

create view vw_post_likes as
select post_id, count(*) as total_likes from likes group by post_id;

delimiter //

-- bai 12: procedure them binh luan (kiem tra user va post ton tai)
create procedure sp_add_comment(
    in p_user_id int,
    in p_post_id int,
    in p_content text
)
begin
    declare v_user_ok int;
    declare v_post_ok int;
    
    select count(*) into v_user_ok from users where user_id = p_user_id;
    select count(*) into v_post_ok from posts where post_id = p_post_id;
    
    if v_user_ok > 0 and v_post_ok > 0 then
        insert into comments (post_id, user_id, content) 
        values (p_post_id, p_user_id, p_content);
    else
        signal sqlstate '45000' set message_text = 'du lieu khong hop le';
    end if;
end //

-- bai 13: procedure like bai viet (chong like trung lap)
create procedure sp_like_post(
    in p_user_id int,
    in p_post_id int
)
begin
    if not exists (select 1 from likes where user_id = p_user_id and post_id = p_post_id) then
        insert into likes (user_id, post_id) values (p_user_id, p_post_id);
    end if;
end //

-- bai 14: procedure tim kiem da nang
create procedure sp_search_social(
    in p_option int,
    in p_keyword varchar(100)
)
begin
    if p_option = 1 then
        -- option 1: tim user
        select * from users where username like concat('%', p_keyword, '%');
    elseif p_option = 2 then
        -- option 2: tim bai viet
        select * from posts where content like concat('%', p_keyword, '%');
    else
        signal sqlstate '45000' set message_text = 'option khong hop le';
    end if;
end //

delimiter ;

-- === test thu mot so chuc nang ===
call sp_create_post(1, 'hello world sql');
call sp_add_comment(2, 1, 'bai viet hay qua');
call sp_like_post(2, 1);
call sp_search_social(1, 'admin');