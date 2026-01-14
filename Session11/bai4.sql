use social_network_pro;

delimiter //
create procedure CreatePostWithValidation(
    in p_user_id int,
    in p_content text,
    out result_message varchar(255)
)
begin
    if char_length(p_content) < 5 then
        set result_message = 'Nội dung quá ngắn';
    else
        insert into posts (user_id, content, created_at)
        values (p_user_id, p_content, now());
        
        set result_message = 'Thêm bài viết thành công';
    end if;
end //
delimiter ;

set @msg = '';
call CreatePostWithValidation(1, 'Hi', @msg);
select @msg as 'Kết quả trường hợp 1 (nội dung ngắn)';

set @msg = '';
call CreatePostWithValidation(1, 'Đây là bài viết test với nội dung đủ dài', @msg);
select @msg as 'Kết quả trường hợp 2 (nội dung hợp lệ)';

select post_id, user_id, content, created_at 
from posts 
where user_id = 1 
order by created_at desc 
limit 5;

drop procedure if exists CreatePostWithValidation;
