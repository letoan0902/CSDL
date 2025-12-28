-- =====================================================
-- BÀI 5: TẠO BẢNG TEACHER VÀ CẬP NHẬT SUBJECT
-- Mối quan hệ: Một giảng viên dạy nhiều môn (1-N)
--              Mỗi môn chỉ có một giảng viên phụ trách
-- =====================================================

-- Sử dụng database
USE QuanLyDaoTao;

-- =====================================================
-- BẢNG TEACHER (Giảng viên)
-- =====================================================
CREATE TABLE Teacher (
    TeacherID VARCHAR(10) PRIMARY KEY,         -- Khóa chính
    FullName NVARCHAR(100) NOT NULL,           -- Họ tên (bắt buộc)
    Email VARCHAR(100) UNIQUE                  -- Email (duy nhất)
);

-- =====================================================
-- CẬP NHẬT BẢNG SUBJECT: Thêm cột TeacherID
-- =====================================================
ALTER TABLE Subject
ADD TeacherID VARCHAR(10);

-- Thêm ràng buộc FOREIGN KEY cho cột mới
ALTER TABLE Subject
ADD CONSTRAINT FK_Subject_Teacher 
    FOREIGN KEY (TeacherID) 
    REFERENCES Teacher(TeacherID);

-- =====================================================
-- GIẢI THÍCH:
-- 
-- 1. BẢNG TEACHER:
--    → TeacherID: Khóa chính, định danh duy nhất
--    → FullName: Bắt buộc (NOT NULL)
--    → Email: Duy nhất (UNIQUE) - mỗi GV có email riêng
--
-- 2. CẬP NHẬT SUBJECT:
--    → Thêm cột TeacherID để liên kết với Teacher
--    → FOREIGN KEY đảm bảo chỉ gán GV đang tồn tại
--
-- 3. MỐI QUAN HỆ:
--    → Một giảng viên → Dạy NHIỀU môn
--    → Một môn học → Chỉ có MỘT giảng viên phụ trách
-- =====================================================
