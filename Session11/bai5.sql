use social_network_pro;

delimiter //
create procedure CalculateUserActivityScore(
    in p_user_id int,
    out activity_score int,
    out activity_level varchar(50)
)
begin
    declare post_count int default 0;
    declare comment_count int default 0;
    declare like_count int default 0;
    
    select count(*) into post_count
    from posts
    where user_id = p_user_id;
    
    select count(*) into comment_count
    from comments
    where user_id = p_user_id;
    
    select count(*) into like_count
    from likes l
    join posts p on l.post_id = p.post_id
    where p.user_id = p_user_id;
    
    set activity_score = (post_count * 10) + (comment_count * 5) + (like_count * 3);
    
    case
        when activity_score > 500 then
            set activity_level = 'Rất tích cực';
        when activity_score >= 200 then
            set activity_level = 'Tích cực';
        else
            set activity_level = 'Bình thường';
    end case;
end //
delimiter ;

set @score = 0;
set @level = '';
call CalculateUserActivityScore(1, @score, @level);
select @score as 'Điểm hoạt động', @level as 'Mức độ hoạt động';

call CalculateUserActivityScore(3, @score, @level);
select @score as 'Điểm hoạt động user 3', @level as 'Mức độ user 3';

call CalculateUserActivityScore(7, @score, @level);
select @score as 'Điểm hoạt động user 7', @level as 'Mức độ user 7';

drop procedure if exists CalculateUserActivityScore;
