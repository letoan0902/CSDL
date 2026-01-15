-- Bài 4: Quản lý đăng ký học phần

-- Tạo bảng students
create table students (
    student_id int primary key auto_increment,
    student_name varchar(50) not null
);

-- Tạo bảng courses
create table courses (
    course_id int primary key auto_increment,
    course_name varchar(100) not null,
    available_seats int default 0
);

-- Tạo bảng enrollments
create table enrollments (
    enrollment_id int primary key auto_increment,
    student_id int,
    course_id int,
    enrollment_date datetime default now(),
    foreign key (student_id) references students(student_id) on delete cascade,
    foreign key (course_id) references courses(course_id) on delete cascade
);

-- Thêm dữ liệu mẫu
insert into students (student_name) values
('Nguyễn Văn An'),
('Trần Thị Bảy'),
('Lê Văn Cường');

insert into courses (course_name, available_seats) values
('Cơ sở dữ liệu', 30),
('Lập trình Java', 25),
('Mạng máy tính', 20);

-- Stored Procedure đăng ký học phần
delimiter //
create procedure enroll_student(
    in p_student_name varchar(50),
    in p_course_name varchar(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_available_seats int;
    declare exit handler for sqlexception
    begin
        rollback;
        resignal;
    end;
    
    start transaction;
    
    select student_id into v_student_id
    from students
    where student_name = p_student_name;
    
    select course_id, available_seats into v_course_id, v_available_seats
    from courses
    where course_name = p_course_name;
    
    if v_available_seats <= 0 then
        rollback;
        signal sqlstate '45000'
        set message_text = 'No available seats';
    end if;
    
    insert into enrollments (student_id, course_id, enrollment_date)
    values (v_student_id, v_course_id, now());
    
    update courses
    set available_seats = available_seats - 1
    where course_id = v_course_id;
    
    commit;
end //
delimiter ;

-- Gọi stored procedure
call enroll_student('Nguyễn Văn An', 'Cơ sở dữ liệu');
call enroll_student('Trần Thị Bảy', 'Lập trình Java');
call enroll_student('Lê Văn Cường', 'Cơ sở dữ liệu');

-- Kiểm tra kết quả
select * from courses;
select * from enrollments;

