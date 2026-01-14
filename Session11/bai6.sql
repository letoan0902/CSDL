use social_network_pro;

delimiter //
create procedure NotifyFriendsOnNewPost(
    in p_user_id int,
    in p_content text
)
begin
    declare v_post_id int;
    declare v_full_name varchar(100);
    declare v_notification_content varchar(255);
    
    select full_name into v_full_name
    from users
    where user_id = p_user_id;
    
    insert into posts (user_id, content, created_at)
    values (p_user_id, p_content, now());
    
    set v_post_id = last_insert_id();
    
    set v_notification_content = concat(v_full_name, ' đã đăng một bài viết mới');
    
    insert into notifications (user_id, type, content, is_read, created_at)
    select 
        friend_id,
        'new_post',
        v_notification_content,
        false,
        now()
    from friends
    where user_id = p_user_id 
      and status = 'accepted'
      and friend_id != p_user_id;
    
    insert into notifications (user_id, type, content, is_read, created_at)
    select 
        user_id,
        'new_post',
        v_notification_content,
        false,
        now()
    from friends
    where friend_id = p_user_id 
      and status = 'accepted'
      and user_id != p_user_id;
      
end //
delimiter ;

call NotifyFriendsOnNewPost(1, 'Xin chào mọi người! Đây là bài viết test procedure Session 11');

select 
    n.notification_id,
    n.user_id,
    u.full_name as 'Người nhận thông báo',
    n.type,
    n.content,
    n.is_read,
    n.created_at
from notifications n
join users u on n.user_id = u.user_id
where n.type = 'new_post'
  and n.content like '%Nguyễn Văn An%'
order by n.created_at desc
limit 20;

select * from posts where user_id = 1 order by created_at desc limit 1;

drop procedure if exists NotifyFriendsOnNewPost;
