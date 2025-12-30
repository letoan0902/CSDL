INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES (6, 'Vo Thi Hoa', '2001-07-20', 'hoa.vo@email.com');

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES 
    (6, 1, '2024-02-01'),
    (6, 2, '2024-02-01'),
    (6, 4, '2024-02-02');

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES 
    (6, 1, 7.0, 7.5),
    (6, 2, 8.0, 8.5);

UPDATE Score
SET final_score = 9.0
WHERE student_id = 6 AND subject_id = 2;

DELETE FROM Enrollment
WHERE student_id = 6 AND subject_id = 4;

SELECT * FROM Student;
SELECT * FROM Enrollment;
SELECT * FROM Score;
