CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    total_sessions INT,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    enroll_date DATE DEFAULT GETDATE(),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Score (
    student_id INT,
    course_id INT,
    mid_score DECIMAL(4,2) CHECK (mid_score >= 0 AND mid_score <= 10),
    final_score DECIMAL(4,2) CHECK (final_score >= 0 AND final_score <= 10),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES 
    (1, 'Nguyen Van An', '2000-05-15', 'an.nguyen@email.com'),
    (2, 'Tran Thi Binh', '2001-03-20', 'binh.tran@email.com'),
    (3, 'Le Hoang Cuong', '2000-08-10', 'cuong.le@email.com'),
    (4, 'Pham Minh Dung', '2001-12-25', 'dung.pham@email.com'),
    (5, 'Hoang Thi Em', '2000-02-14', 'em.hoang@email.com');

INSERT INTO Teacher (teacher_id, full_name, email)
VALUES 
    (1, 'Nguyen Van Hung', 'hung.nguyen@university.edu'),
    (2, 'Tran Thi Mai', 'mai.tran@university.edu'),
    (3, 'Le Quoc Viet', 'viet.le@university.edu'),
    (4, 'Pham Thi Hoa', 'hoa.pham@university.edu'),
    (5, 'Vo Minh Tuan', 'tuan.vo@university.edu');

INSERT INTO Course (course_id, course_name, description, total_sessions, teacher_id)
VALUES 
    (1, 'Co so du lieu', 'Hoc ve thiet ke va quan ly CSDL', 15, 1),
    (2, 'Lap trinh Python', 'Nhap mon lap trinh voi Python', 20, 2),
    (3, 'Phat trien Web', 'Xay dung website voi HTML, CSS, JS', 25, 3),
    (4, 'Mang may tinh', 'Kien thuc co ban ve mang', 18, 4),
    (5, 'Tri tue nhan tao', 'Gioi thieu ve AI va Machine Learning', 22, 5);

INSERT INTO Enrollment (student_id, course_id, enroll_date)
VALUES 
    (1, 1, '2024-01-15'),
    (1, 2, '2024-01-15'),
    (2, 1, '2024-01-16'),
    (2, 3, '2024-01-17'),
    (3, 2, '2024-01-18'),
    (3, 4, '2024-01-18'),
    (4, 1, '2024-01-19'),
    (4, 5, '2024-01-20'),
    (5, 3, '2024-01-20'),
    (5, 5, '2024-01-21');

INSERT INTO Score (student_id, course_id, mid_score, final_score)
VALUES 
    (1, 1, 7.5, 8.0),
    (1, 2, 8.0, 8.5),
    (2, 1, 6.5, 7.0),
    (2, 3, 9.0, 9.5),
    (3, 2, 7.0, 7.5),
    (3, 4, 8.5, 8.0),
    (4, 1, 6.0, 6.5),
    (4, 5, 9.5, 10.0),
    (5, 3, 8.0, 8.5),
    (5, 5, 7.5, 8.0);

UPDATE Student
SET email = 'an.nguyen.updated@email.com'
WHERE student_id = 1;

UPDATE Course
SET description = 'Hoc ve thiet ke, quan ly va toi uu CSDL quan he'
WHERE course_id = 1;

UPDATE Score
SET final_score = 9.0
WHERE student_id = 2 AND course_id = 1;

DELETE FROM Score
WHERE student_id = 5 AND course_id = 5;

DELETE FROM Enrollment
WHERE student_id = 5 AND course_id = 5;

SELECT * FROM Student;

SELECT * FROM Teacher;

SELECT * FROM Course;

SELECT * FROM Enrollment;

SELECT * FROM Score;
