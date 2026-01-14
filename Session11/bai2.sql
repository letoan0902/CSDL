use social_network_pro;

delimiter //
create procedure CalculatePostLikes(
    in p_post_id int,
    out total_likes int
)
begin
    select count(*) into total_likes
    from likes
    where post_id = p_post_id;
end //
delimiter ;

set @likes_count = 0;
call CalculatePostLikes(101, @likes_count);
select @likes_count as 'Tổng số likes của bài viết 101';

call CalculatePostLikes(102, @likes_count);
select @likes_count as 'Tổng số likes của bài viết 102';

drop procedure if exists CalculatePostLikes;
