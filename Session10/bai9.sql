use social_network_pro;

-- 2) tạo index trên cột gender
create index idx_user_gender on users(gender);

-- 3) tạo view tổng bài viết và bình luận
create or replace view view_user_activity as
select 
    u.user_id,
    count(distinct p.post_id) as total_posts,
    count(distinct c.comment_id) as total_comments
from users u
left join posts p on u.user_id = p.user_id
left join comments c on u.user_id = c.user_id
group by u.user_id;

-- 4) hiển thị view
select * from view_user_activity;

-- 5) truy vấn kết hợp với điều kiện
select 
    u.user_id,
    u.username,
    u.full_name,
    v.total_posts,
    v.total_comments
from view_user_activity v
join users u on v.user_id = u.user_id
where v.total_posts > 5 and v.total_comments > 20
order by v.total_comments desc
limit 5;

-- xóa index
drop index idx_user_gender on users;
