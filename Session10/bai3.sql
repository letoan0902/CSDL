use social_network_pro;

-- 1) import database social_network_pro (đã import)

-- 2) truy vấn tìm user ở hà nội - trước khi có index
explain analyze
select * from users where hometown = 'Hà Nội';

-- 3) tạo index cho cột hometown
create index idx_hometown on users(hometown);

-- 4) chạy lại truy vấn sau khi có index
explain analyze
select * from users where hometown = 'Hà Nội';

-- so sánh: 
-- trước khi có index: full table scan
-- sau khi có index: sử dụng index lookup, nhanh hơn

-- 6) xóa index
drop index idx_hometown on users;
