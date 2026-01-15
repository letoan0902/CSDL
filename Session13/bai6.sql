-- Bài 6: Tạo bảng friendships, triggers và view user_profile

-- Tạo bảng friendships
create table friendships (
    follower_id int,
    followee_id int,
    status enum('pending', 'accepted') default 'accepted',
    primary key (follower_id, followee_id),
    foreign key (follower_id) references users(user_id) on delete cascade,
    foreign key (followee_id) references users(user_id) on delete cascade
);

-- Trigger after insert trên friendships
delimiter //
create trigger trg_after_insert_friendship
after insert on friendships
for each row
begin
    if new.status = 'accepted' then
        update users 
        set follower_count = follower_count + 1 
        where user_id = new.followee_id;
    end if;
end //
delimiter ;

-- Trigger after delete trên friendships
delimiter //
create trigger trg_after_delete_friendship
after delete on friendships
for each row
begin
    if old.status = 'accepted' then
        update users 
        set follower_count = follower_count - 1 
        where user_id = old.followee_id;
    end if;
end //
delimiter ;

-- Trigger after update trên friendships (khi status thay đổi)
delimiter //
create trigger trg_after_update_friendship
after update on friendships
for each row
begin
    if old.status != new.status then
        if new.status = 'accepted' and old.status = 'pending' then
            update users 
            set follower_count = follower_count + 1 
            where user_id = new.followee_id;
        elseif new.status = 'pending' and old.status = 'accepted' then
            update users 
            set follower_count = follower_count - 1 
            where user_id = new.followee_id;
        end if;
    end if;
end //
delimiter ;

-- Procedure follow_user
delimiter //
create procedure follow_user(
    in p_follower_id int,
    in p_followee_id int,
    in p_status enum('pending', 'accepted')
)
begin
    if p_follower_id = p_followee_id then
        signal sqlstate '45000'
        set message_text = 'Cannot follow yourself';
    end if;
    
    if exists (select 1 from friendships 
               where follower_id = p_follower_id 
               and followee_id = p_followee_id) then
        signal sqlstate '45000'
        set message_text = 'Friendship already exists';
    end if;
    
    insert into friendships (follower_id, followee_id, status)
    values (p_follower_id, p_followee_id, p_status);
end //
delimiter ;

-- View user_profile
create view user_profile as
select 
    u.user_id,
    u.username,
    u.follower_count,
    u.post_count,
    coalesce(sum(p.like_count), 0) as total_likes,
    group_concat(
        concat(p.post_id, ': ', left(p.content, 50))
        order by p.created_at desc
        separator ' | '
    ) as recent_posts
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

-- Test follow/unfollow
call follow_user(2, 1, 'accepted');
call follow_user(3, 1, 'accepted');
call follow_user(1, 2, 'accepted');

-- Kiểm tra follower_count
select * from users;

-- Kiểm tra view user_profile
select * from user_profile;

-- Test unfollow
delete from friendships where follower_id = 2 and followee_id = 1;

-- Kiểm tra lại
select * from users;
select * from user_profile;

