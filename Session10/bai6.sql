use social_network_pro;

-- 2) tạo view thống kê số bài viết
create or replace view view_users_summary as
select 
    u.user_id,
    u.username,
    count(p.post_id) as total_posts
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username;

-- 3) truy vấn người dùng có total_posts > 5
select 
    user_id,
    username,
    total_posts
from view_users_summary
where total_posts > 5;
