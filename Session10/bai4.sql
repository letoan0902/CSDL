use social_network_pro;

-- 2) tạo composite index

-- truy vấn trước khi tạo index
explain analyze
select post_id, content, created_at 
from posts 
where year(created_at) = 2026 and user_id = 1;

-- tạo composite index
create index idx_created_at_user_id on posts(created_at, user_id);

-- truy vấn sau khi tạo index
explain analyze
select post_id, content, created_at 
from posts 
where year(created_at) = 2026 and user_id = 1;

-- 3) tạo unique index

-- truy vấn trước khi tạo index
explain analyze
select user_id, username, email 
from users 
where email = 'an@gmail.com';

-- tạo unique index
create unique index idx_email on users(email);

-- truy vấn sau khi tạo index
explain analyze
select user_id, username, email 
from users 
where email = 'an@gmail.com';

-- 4) xóa các index
drop index idx_created_at_user_id on posts;
drop index idx_email on users;
