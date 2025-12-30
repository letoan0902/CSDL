CREATE TABLE Enrollment (
    student_id INT,
    subject_id INT,
    enroll_date DATE DEFAULT GETDATE(),
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES 
    (1, 1, '2024-01-15'),
    (1, 2, '2024-01-15'),
    (1, 3, '2024-01-16');

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES 
    (2, 1, '2024-01-15'),
    (2, 4, '2024-01-17');

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES 
    (3, 2, '2024-01-16'),
    (3, 5, '2024-01-18');

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES 
    (4, 1, '2024-01-17');

SELECT * FROM Enrollment;
