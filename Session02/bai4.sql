-- =====================================================
-- BÀI 4: TẠO BẢNG ENROLLMENT (ĐĂNG KÝ MÔN HỌC)
-- Mối quan hệ: Nhiều-Nhiều (N-N) giữa Student và Subject
-- =====================================================

-- Sử dụng database
USE QuanLyDaoTao;

-- =====================================================
-- GIẢ SỬ: Bảng Student và Subject đã được tạo từ Bài 3
-- =====================================================

-- =====================================================
-- BẢNG ENROLLMENT (Đăng ký môn học) - BẢNG TRUNG GIAN
-- =====================================================
CREATE TABLE Enrollment (
    StudentID VARCHAR(10) NOT NULL,            -- Mã sinh viên
    SubjectID VARCHAR(10) NOT NULL,            -- Mã môn học
    EnrollmentDate DATE DEFAULT (CURRENT_DATE),-- Ngày đăng ký (mặc định: hôm nay)
    
    -- Khóa chính kép (Composite Primary Key)
    -- Đảm bảo: Một sinh viên KHÔNG thể đăng ký trùng một môn
    PRIMARY KEY (StudentID, SubjectID),
    
    -- Khóa ngoại tới bảng Student
    CONSTRAINT FK_Enrollment_Student 
        FOREIGN KEY (StudentID) 
        REFERENCES Student(StudentID),
    
    -- Khóa ngoại tới bảng Subject
    CONSTRAINT FK_Enrollment_Subject 
        FOREIGN KEY (SubjectID) 
        REFERENCES Subject(SubjectID)
);

-- =====================================================
-- GIẢI THÍCH:
-- 
-- 1. PRIMARY KEY (StudentID, SubjectID):
--    → Khóa chính kép giúp ngăn sinh viên đăng ký trùng môn
--    → Mỗi cặp (StudentID, SubjectID) chỉ xuất hiện 1 lần
--
-- 2. FOREIGN KEY:
--    → FK_Enrollment_Student: Liên kết tới bảng Student
--    → FK_Enrollment_Subject: Liên kết tới bảng Subject
--    → Đảm bảo: Chỉ đăng ký được nếu SV và Môn học tồn tại
--
-- 3. MỐI QUAN HỆ N-N:
--    → Một sinh viên có thể đăng ký NHIỀU môn
--    → Một môn học có thể có NHIỀU sinh viên
--    → Bảng Enrollment là bảng trung gian "phá" quan hệ N-N
-- =====================================================
