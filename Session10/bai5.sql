use social_network_pro;

-- 2) tạo index trên cột hometown
create index idx_hometown on users(hometown);

-- 3) truy vấn kết hợp với posts
select 
    u.user_id,
    u.username,
    u.full_name,
    p.post_id,
    p.content
from users u
join posts p on u.user_id = p.user_id
where u.hometown = 'Hà Nội'
order by u.username desc
limit 10;

-- 4) kiểm tra kế hoạch thực thi trước và sau khi có index
-- trước khi có index (chạy sau khi drop)
explain analyze
select 
    u.user_id,
    u.username,
    u.full_name,
    p.post_id,
    p.content
from users u
join posts p on u.user_id = p.user_id
where u.hometown = 'Hà Nội'
order by u.username desc
limit 10;

-- xóa index
drop index idx_hometown on users;
