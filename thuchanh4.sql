-- minisocialnetwork
drop database if exists minisocialnetwork;
create database minisocialnetwork;
use minisocialnetwork;

-- 1. users
create table users (
    user_id int primary key auto_increment,
    username varchar(50) unique not null,
    password varchar(255) not null,
    email varchar(100) unique not null,
    created_at datetime default current_timestamp
);

-- 2. posts
create table posts (
    post_id int primary key auto_increment,
    user_id int,
    content text not null,
    created_at datetime default current_timestamp,
    like_count int default 0,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- 3. comments
create table comments (
    comment_id int primary key auto_increment,
    post_id int,
    user_id int,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id) on delete cascade,
    foreign key (user_id) references users(user_id) on delete cascade
);

-- 4. likes
create table likes (
    user_id int,
    post_id int,
    created_at datetime default current_timestamp,
    primary key (user_id, post_id),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);

-- 5. friends
create table friends (
    user_id int,
    friend_id int,
    status varchar(20) check (status in ('pending', 'accepted')) default 'pending',
    created_at datetime default current_timestamp,
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (friend_id) references users(user_id) on delete cascade
);

-- log tables
create table user_log (
    log_id int primary key auto_increment,
    user_id int,
    action varchar(50),
    log_time datetime default current_timestamp
);

create table post_log (
    log_id int primary key auto_increment,
    post_id int,
    user_id int,
    action varchar(50),
    log_time datetime default current_timestamp
);

create table friend_log (
    log_id int primary key auto_increment,
    user_id int,
    friend_id int,
    action varchar(50),
    log_time datetime default current_timestamp
);

-- bai 1: dang ky
delimiter //
create procedure sp_register_user(
    in p_username varchar(50),
    in p_password varchar(255),
    in p_email varchar(100)
)
begin
    if exists (select 1 from users where username = p_username) then
        signal sqlstate '45000' set message_text = 'username exists';
    end if;
    
    if exists (select 1 from users where email = p_email) then
        signal sqlstate '45000' set message_text = 'email exists';
    end if;
    
    insert into users (username, password, email) values (p_username, p_password, p_email);
end //

create trigger tg_user_register_log
after insert on users
for each row
begin
    insert into user_log (user_id, action) values (new.user_id, 'register');
end //
delimiter ;

-- bai 2: dang bai
delimiter //
create procedure sp_create_post(
    in p_user_id int,
    in p_content text
)
begin
    if p_content is null or trim(p_content) = '' then
        signal sqlstate '45000' set message_text = 'content empty';
    end if;
    
    insert into posts (user_id, content) values (p_user_id, p_content);
end //

create trigger tg_post_create_log
after insert on posts
for each row
begin
    insert into post_log (post_id, user_id, action) values (new.post_id, new.user_id, 'create_post');
end //
delimiter ;

-- bai 3: like
delimiter //
create trigger tg_like_increment
after insert on likes
for each row
begin
    update posts set like_count = like_count + 1 where post_id = new.post_id;
end //

create trigger tg_like_decrement
after delete on likes
for each row
begin
    update posts set like_count = like_count - 1 where post_id = old.post_id;
end //
delimiter ;

-- bai 4: gui ket ban
delimiter //
create procedure sp_send_friend_request(
    in p_sender_id int,
    in p_receiver_id int
)
begin
    if p_sender_id = p_receiver_id then
        signal sqlstate '45000' set message_text = 'cannot self request';
    end if;
    
    if exists (select 1 from friends where (user_id = p_sender_id and friend_id = p_receiver_id) 
                                      or (user_id = p_receiver_id and friend_id = p_sender_id)) then
        signal sqlstate '45000' set message_text = 'exists';
    end if;
    
    insert into friends (user_id, friend_id, status) values (p_sender_id, p_receiver_id, 'pending');
end //

create trigger tg_friend_request_log
after insert on friends
for each row
begin
    insert into friend_log (user_id, friend_id, action) values (new.user_id, new.friend_id, 'send_request');
end //
delimiter ;

-- bai 5: chap nhan ket ban
delimiter //
create procedure sp_accept_friend_request(
    in p_user_id int,
    in p_friend_id int
)
begin
    update friends 
    set status = 'accepted' 
    where user_id = p_user_id and friend_id = p_friend_id and status = 'pending';
    
    if row_count() > 0 then
         if not exists (select 1 from friends where user_id = p_friend_id and friend_id = p_user_id) then
             insert into friends (user_id, friend_id, status) values (p_friend_id, p_user_id, 'accepted');
         end if;
    else
        signal sqlstate '45000' set message_text = 'no pending request';
    end if;
end //
delimiter ;

-- bai 6: xoa ban be
delimiter //
create procedure sp_remove_friend(
    in p_user1_id int,
    in p_user2_id int
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;

    start transaction;
    
    delete from friends where user_id = p_user1_id and friend_id = p_user2_id;
    delete from friends where user_id = p_user2_id and friend_id = p_user1_id;
    
    commit;
end //
delimiter ;

-- bai 7: xoa bai viet
delimiter //
create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare v_owner_id int;
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    start transaction;
    
    select user_id into v_owner_id from posts where post_id = p_post_id;
    
    if v_owner_id is null then
        signal sqlstate '45000' set message_text = 'post not found';
    end if;
    
    if v_owner_id <> p_user_id then
        signal sqlstate '45000' set message_text = 'unauthorized';
    end if;
    
    delete from posts where post_id = p_post_id;
    
    commit;
end //
delimiter ;

-- bai 8: xoa tai khoan
delimiter //
create procedure sp_delete_user(
    in p_user_id int
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    start transaction;
    delete from users where user_id = p_user_id;
    commit;
end //
delimiter ;
