-- =====================================================
-- BÀI 6: TẠO BẢNG SCORE (Kết quả học tập)
-- =====================================================

-- Sử dụng database
USE QuanLyDaoTao;

-- =====================================================
-- GIẢ SỬ: Bảng Student và Subject đã được tạo
-- =====================================================

-- =====================================================
-- BẢNG SCORE (Kết quả học tập)
-- =====================================================
CREATE TABLE Score (
    StudentID VARCHAR(10) NOT NULL,            -- Mã sinh viên
    SubjectID VARCHAR(10) NOT NULL,            -- Mã môn học
    ProcessScore DECIMAL(4,2),                 -- Điểm quá trình
    FinalScore DECIMAL(4,2),                   -- Điểm cuối kỳ
    
    -- Khóa chính kép: Mỗi SV chỉ có 1 kết quả/môn
    PRIMARY KEY (StudentID, SubjectID),
    
    -- Khóa ngoại tới bảng Student
    CONSTRAINT FK_Score_Student 
        FOREIGN KEY (StudentID) 
        REFERENCES Student(StudentID),
    
    -- Khóa ngoại tới bảng Subject
    CONSTRAINT FK_Score_Subject 
        FOREIGN KEY (SubjectID) 
        REFERENCES Subject(SubjectID),
    
    -- Ràng buộc CHECK: Điểm quá trình từ 0 đến 10
    CONSTRAINT CHK_ProcessScore 
        CHECK (ProcessScore >= 0 AND ProcessScore <= 10),
    
    -- Ràng buộc CHECK: Điểm cuối kỳ từ 0 đến 10
    CONSTRAINT CHK_FinalScore 
        CHECK (FinalScore >= 0 AND FinalScore <= 10)
);

-- =====================================================
-- GIẢI THÍCH:
-- 
-- 1. PRIMARY KEY (StudentID, SubjectID):
--    → Khóa chính kép đảm bảo: Mỗi sinh viên chỉ có
--      MỘT bản ghi điểm cho mỗi môn học
--    → Không thể nhập trùng điểm cho cùng SV-Môn
--
-- 2. FOREIGN KEY:
--    → FK_Score_Student: Liên kết tới bảng Student
--    → FK_Score_Subject: Liên kết tới bảng Subject
--    → Chỉ nhập điểm cho SV và Môn học đang tồn tại
--
-- 3. CHECK CONSTRAINTS:
--    → CHK_ProcessScore: Điểm quá trình trong [0, 10]
--    → CHK_FinalScore: Điểm cuối kỳ trong [0, 10]
--    → Ngăn chặn nhập điểm < 0 hoặc > 10
--
-- 4. DECIMAL(4,2):
--    → Cho phép điểm có 2 chữ số thập phân
--    → VD: 8.50, 9.25, 10.00
-- =====================================================
