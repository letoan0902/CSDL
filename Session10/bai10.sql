use social_network_pro;

-- 2) tạo index trên cột username
create index idx_username on users(username);

-- 3) tạo view thống kê bài viết và bạn bè
create or replace view view_user_activity_2 as
select 
    u.user_id,
    count(distinct p.post_id) as total_posts,
    count(distinct case when f.status = 'accepted' then f.friend_id end) as total_friends
from users u
left join posts p on u.user_id = p.user_id
left join friends f on u.user_id = f.user_id
group by u.user_id;

-- 4) hiển thị view
select * from view_user_activity_2;

-- 5) truy vấn kết hợp với điều kiện và thêm các cột mô tả
select 
    u.full_name,
    v.total_posts,
    v.total_friends,
    case 
        when v.total_friends > 5 then 'Nhiều bạn bè'
        when v.total_friends >= 2 and v.total_friends <= 5 then 'Vừa đủ bạn bè'
        else 'Ít bạn bè'
    end as friend_description,
    case 
        when v.total_posts > 10 then v.total_posts * 1.1
        when v.total_posts >= 5 and v.total_posts <= 10 then v.total_posts
        else v.total_posts * 0.9
    end as post_activity_score
from view_user_activity_2 v
join users u on v.user_id = u.user_id
where v.total_posts > 0
order by v.total_posts desc;

-- xóa index
drop index idx_username on users;
