CREATE TABLE Score (
    student_id INT,
    subject_id INT,
    mid_score DECIMAL(4,2) CHECK (mid_score >= 0 AND mid_score <= 10),
    final_score DECIMAL(4,2) CHECK (final_score >= 0 AND final_score <= 10),
    PRIMARY KEY (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES 
    (1, 1, 7.5, 8.0),
    (1, 2, 8.0, 8.5),
    (1, 3, 6.5, 7.0);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES 
    (2, 1, 8.5, 9.0),
    (2, 4, 7.0, 7.5);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES 
    (3, 2, 9.0, 9.5),
    (3, 5, 6.0, 6.5);

UPDATE Score
SET final_score = 8.5
WHERE student_id = 1 AND subject_id = 1;

SELECT * FROM Score;

SELECT * FROM Score WHERE final_score >= 8;
