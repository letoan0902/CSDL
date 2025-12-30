CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE
);

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES 
    (1, 'Nguyen Van An', '2000-05-15', 'an.nguyen@email.com'),
    (2, 'Tran Thi Binh', '2001-03-20', 'binh.tran@email.com'),
    (3, 'Le Hoang Cuong', '2000-08-10', 'cuong.le@email.com'),
    (4, 'Pham Minh Dung', '2001-12-25', 'dung.pham@email.com'),
    (5, 'Hoang Thi Em', '2000-02-14', 'em.hoang@email.com');

SELECT * FROM Student;

SELECT student_id, full_name FROM Student;
