use social_network_pro;

-- 1) chạy mã nguồn tạo database social_network_pro (đã import)

-- 2) tạo view hiển thị người dùng có họ "nguyễn"
create or replace view view_users_firstname as
select 
    user_id,
    username,
    full_name,
    email,
    created_at
from users
where full_name like 'Nguyễn%';

-- 3) hiển thị view vừa tạo
select * from view_users_firstname;

-- 4) thêm nhân viên mới có họ "nguyễn"
insert into users (username, full_name, gender, email, password, birthdate, hometown)
values ('nguyen_test', 'Nguyễn Văn Test', 'Nam', 'nguyentest@gmail.com', '123', '1995-05-15', 'Hà Nội');

-- kiểm tra view sau khi thêm
select * from view_users_firstname;

-- 5) xóa nhân viên vừa thêm
delete from users where username = 'nguyen_test';

-- kiểm tra view sau khi xóa
select * from view_users_firstname;
