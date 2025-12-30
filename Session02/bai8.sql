-- =====================================================
-- BÀI 8: CẬP NHẬT VÀ KIỂM TRA DỮ LIỆU
-- =====================================================
-- Thực hành: INSERT, UPDATE, DELETE, SELECT
-- Trên các bảng: Student, Subject, Enrollment, Score
-- =====================================================

-- Sử dụng database QuanLyDaoTao (đã tạo từ bài 7)
USE QuanLyDaoTao;

-- =====================================================
-- PHẦN 1: THÊM DỮ LIỆU MẪU CHO CÁC BẢNG CHA
-- =====================================================

-- Thêm lớp học
INSERT INTO Class (ClassID, ClassName, AcademicYear) VALUES
('CNTT01', N'Công nghệ thông tin K2024', '2024-2025'),
('KTPM01', N'Kỹ thuật phần mềm K2024', '2024-2025');

-- Thêm giảng viên
INSERT INTO Teacher (TeacherID, FullName, Email) VALUES
('GV001', N'Nguyễn Văn An', 'an.nv@university.edu.vn'),
('GV002', N'Trần Thị Bình', 'binh.tt@university.edu.vn');

-- Thêm môn học
INSERT INTO Subject (SubjectID, SubjectName, Credits, TeacherID) VALUES
('CSDL01', N'Cơ sở dữ liệu', 3, 'GV001'),
('LTC01', N'Lập trình C', 4, 'GV002'),
('MMT01', N'Mạng máy tính', 3, 'GV001');

-- =====================================================
-- PHẦN 2: THÊM SINH VIÊN MỚI
-- =====================================================

-- Thêm một sinh viên mới
INSERT INTO Student (StudentID, FullName, BirthDate, ClassID) 
VALUES ('SV001', N'Lê Minh Tuấn', '2005-03-15', 'CNTT01');

-- Thêm thêm một số sinh viên khác
INSERT INTO Student (StudentID, FullName, BirthDate, ClassID) VALUES
('SV002', N'Phạm Thị Hoa', '2005-07-22', 'CNTT01'),
('SV003', N'Hoàng Văn Nam', '2005-01-10', 'KTPM01'),
('SV004', N'Nguyễn Thị Mai', '2005-11-05', 'KTPM01');

-- =====================================================
-- PHẦN 3: ĐĂNG KÝ MÔN HỌC CHO SINH VIÊN
-- =====================================================

-- Đăng ký môn học cho sinh viên SV001 (Lê Minh Tuấn)
INSERT INTO Enrollment (StudentID, SubjectID, EnrollmentDate) VALUES
('SV001', 'CSDL01', '2024-09-01'),
('SV001', 'LTC01', '2024-09-01'),
('SV001', 'MMT01', '2024-09-05');

-- Đăng ký cho các sinh viên khác
INSERT INTO Enrollment (StudentID, SubjectID, EnrollmentDate) VALUES
('SV002', 'CSDL01', '2024-09-01'),
('SV002', 'LTC01', '2024-09-02'),
('SV003', 'CSDL01', '2024-09-01'),
('SV004', 'LTC01', '2024-09-03');

-- =====================================================
-- PHẦN 4: THÊM VÀ CẬP NHẬT ĐIỂM CHO SINH VIÊN
-- =====================================================

-- 4.1 THÊM ĐIỂM mới cho sinh viên SV001
INSERT INTO Score (StudentID, SubjectID, ProcessScore, FinalScore) VALUES
('SV001', 'CSDL01', 8.5, 7.0),
('SV001', 'LTC01', 9.0, 8.5),
('SV001', 'MMT01', 7.5, NULL);  -- Chưa có điểm cuối kỳ

-- Thêm điểm cho các sinh viên khác
INSERT INTO Score (StudentID, SubjectID, ProcessScore, FinalScore) VALUES
('SV002', 'CSDL01', 7.0, 6.5),
('SV002', 'LTC01', 8.0, 7.5),
('SV003', 'CSDL01', 9.0, 8.0),
('SV004', 'LTC01', 6.5, 7.0);

-- 4.2 CẬP NHẬT ĐIỂM cho sinh viên SV001

-- Cập nhật điểm cuối kỳ môn Mạng máy tính (trước đó chưa có)
UPDATE Score 
SET FinalScore = 8.0 
WHERE StudentID = 'SV001' AND SubjectID = 'MMT01';

-- Cập nhật điểm quá trình môn CSDL (sửa sai)
UPDATE Score 
SET ProcessScore = 9.0 
WHERE StudentID = 'SV001' AND SubjectID = 'CSDL01';

-- Cập nhật cả điểm quá trình và cuối kỳ
UPDATE Score 
SET ProcessScore = 9.5, FinalScore = 9.0 
WHERE StudentID = 'SV001' AND SubjectID = 'LTC01';

-- =====================================================
-- PHẦN 5: XÓA DỮ LIỆU
-- =====================================================

-- 5.1 Xóa điểm của một sinh viên ở một môn cụ thể
DELETE FROM Score 
WHERE StudentID = 'SV004' AND SubjectID = 'LTC01';

-- 5.2 Xóa đăng ký môn học (phải xóa Score trước nếu có)
DELETE FROM Enrollment 
WHERE StudentID = 'SV004' AND SubjectID = 'LTC01';

-- 5.3 Xóa sinh viên (phải xóa Score và Enrollment trước)
-- Bước 1: Xóa điểm của sinh viên SV004
DELETE FROM Score WHERE StudentID = 'SV004';
-- Bước 2: Xóa đăng ký của sinh viên SV004
DELETE FROM Enrollment WHERE StudentID = 'SV004';
-- Bước 3: Xóa sinh viên SV004
DELETE FROM Student WHERE StudentID = 'SV004';

-- =====================================================
-- PHẦN 6: TRUY VẤN DỮ LIỆU (SELECT)
-- =====================================================

-- 6.1 Lấy danh sách tất cả sinh viên
SELECT * FROM Student;

-- 6.2 Lấy thông tin sinh viên theo lớp
SELECT s.StudentID, s.FullName, s.BirthDate, c.ClassName
FROM Student s
INNER JOIN Class c ON s.ClassID = c.ClassID
WHERE c.ClassID = 'CNTT01';

-- 6.3 Lấy danh sách môn học sinh viên đã đăng ký
SELECT 
    s.StudentID,
    s.FullName,
    sub.SubjectID,
    sub.SubjectName,
    e.EnrollmentDate
FROM Student s
INNER JOIN Enrollment e ON s.StudentID = e.StudentID
INNER JOIN Subject sub ON e.SubjectID = sub.SubjectID
WHERE s.StudentID = 'SV001';

-- 6.4 Lấy bảng điểm của sinh viên
SELECT 
    s.StudentID,
    s.FullName,
    sub.SubjectName,
    sub.Credits,
    sc.ProcessScore AS N'Điểm QT',
    sc.FinalScore AS N'Điểm CK',
    ROUND((sc.ProcessScore * 0.3 + sc.FinalScore * 0.7), 2) AS N'Điểm TB'
FROM Student s
INNER JOIN Score sc ON s.StudentID = sc.StudentID
INNER JOIN Subject sub ON sc.SubjectID = sub.SubjectID
WHERE s.StudentID = 'SV001';

-- 6.5 Lấy điểm trung bình tổng của sinh viên
SELECT 
    s.StudentID,
    s.FullName,
    ROUND(AVG(sc.ProcessScore * 0.3 + sc.FinalScore * 0.7), 2) AS N'Điểm TB chung'
FROM Student s
INNER JOIN Score sc ON s.StudentID = sc.StudentID
WHERE sc.FinalScore IS NOT NULL
GROUP BY s.StudentID, s.FullName;

-- 6.6 Lấy danh sách sinh viên có điểm giỏi (>= 8.0)
SELECT 
    s.StudentID,
    s.FullName,
    sub.SubjectName,
    (sc.ProcessScore * 0.3 + sc.FinalScore * 0.7) AS DiemTB
FROM Student s
INNER JOIN Score sc ON s.StudentID = sc.StudentID
INNER JOIN Subject sub ON sc.SubjectID = sub.SubjectID
WHERE (sc.ProcessScore * 0.3 + sc.FinalScore * 0.7) >= 8.0;

-- 6.7 Thống kê số lượng sinh viên theo lớp
SELECT 
    c.ClassID,
    c.ClassName,
    COUNT(s.StudentID) AS N'Số SV'
FROM Class c
LEFT JOIN Student s ON c.ClassID = s.ClassID
GROUP BY c.ClassID, c.ClassName;

-- 6.8 Thống kê số môn đăng ký của mỗi sinh viên
SELECT 
    s.StudentID,
    s.FullName,
    COUNT(e.SubjectID) AS N'Số môn ĐK'
FROM Student s
LEFT JOIN Enrollment e ON s.StudentID = e.StudentID
GROUP BY s.StudentID, s.FullName;

-- =====================================================
-- TỔNG KẾT CÁC CÂU LỆNH ĐÃ SỬ DỤNG:
-- =====================================================
/*
┌─────────────────────────────────────────────────────────────────┐
│                    TỔNG KẾT THAO TÁC DML                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. INSERT - Thêm dữ liệu:                                      │
│     • INSERT INTO table (columns) VALUES (values)               │
│     • INSERT INTO table (columns) VALUES (...), (...), (...)    │
│                                                                 │
│  2. UPDATE - Cập nhật dữ liệu:                                  │
│     • UPDATE table SET column = value WHERE condition           │
│     • UPDATE table SET col1 = val1, col2 = val2 WHERE ...       │
│                                                                 │
│  3. DELETE - Xóa dữ liệu:                                       │
│     • DELETE FROM table WHERE condition                         │
│     • Lưu ý: Xóa theo thứ tự (bảng con trước, bảng cha sau)    │
│                                                                 │
│  4. SELECT - Truy vấn dữ liệu:                                  │
│     • SELECT * FROM table                                       │
│     • SELECT columns FROM table WHERE condition                 │
│     • SELECT với JOIN, GROUP BY, HAVING, ORDER BY               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

THỨ TỰ THAO TÁC (Quan trọng!):
═══════════════════════════════
  • Thêm: Bảng cha trước → Bảng con sau
    (Class/Teacher → Student/Subject → Enrollment → Score)
    
  • Xóa: Bảng con trước → Bảng cha sau  
    (Score → Enrollment → Student/Subject → Class/Teacher)
*/
