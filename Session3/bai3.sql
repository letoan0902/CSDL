CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name NVARCHAR(100) NOT NULL,
    credit INT CHECK (credit > 0)
);

INSERT INTO Subject (subject_id, subject_name, credit)
VALUES 
    (1, 'Co so du lieu', 3),
    (2, 'Lap trinh C++', 4),
    (3, 'Toan roi rac', 3),
    (4, 'Mang may tinh', 3),
    (5, 'He dieu hanh', 4);

UPDATE Subject
SET credit = 5
WHERE subject_id = 2;

UPDATE Subject
SET subject_name = 'Toan roi rac nang cao'
WHERE subject_id = 3;

SELECT * FROM Subject;
