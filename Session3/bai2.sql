UPDATE Student
SET email = 'cuong.le.updated@email.com'
WHERE student_id = 3;

UPDATE Student
SET date_of_birth = '2001-04-15'
WHERE student_id = 2;

DELETE FROM Student
WHERE student_id = 5;

SELECT * FROM Student;
