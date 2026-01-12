use social_network_pro;

-- 1) sử dụng lại database

-- 2) tạo view thống kê số bài viết mỗi user
create or replace view view_user_post as
select 
    user_id,
    count(post_id) as total_user_post
from posts
group by user_id;

-- 3) hiển thị view
select * from view_user_post;

-- 4) kết hợp view với bảng users
select 
    u.full_name,
    v.total_user_post
from view_user_post v
join users u on v.user_id = u.user_id;
