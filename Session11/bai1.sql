use social_network_pro;

delimiter //
create procedure GetUserPosts(in p_user_id int)
begin
    select 
        post_id as PostID,
        content as 'Nội dung',
        created_at as 'Thời gian tạo'
    from posts
    where user_id = p_user_id
    order by created_at desc;
end //
delimiter ;

call GetUserPosts(1);

drop procedure if exists GetUserPosts;
