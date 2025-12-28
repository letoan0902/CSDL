-- =====================================================
-- BÀI 3: TẠO BẢNG STUDENT VÀ SUBJECT (CHƯA LIÊN KẾT)
-- =====================================================

-- Tạo database (nếu chưa có)
CREATE DATABASE IF NOT EXISTS QuanLyDaoTao;
USE QuanLyDaoTao;

-- =====================================================
-- BẢNG 1: STUDENT (Sinh viên)
-- =====================================================
CREATE TABLE Student (
    StudentID VARCHAR(10) PRIMARY KEY,         -- Khóa chính (duy nhất)
    FullName NVARCHAR(100) NOT NULL            -- Họ tên (bắt buộc)
);

-- =====================================================
-- BẢNG 2: SUBJECT (Môn học)
-- =====================================================
CREATE TABLE Subject (
    SubjectID VARCHAR(10) PRIMARY KEY,         -- Khóa chính (duy nhất)
    SubjectName NVARCHAR(100) NOT NULL,        -- Tên môn học (bắt buộc)
    Credits INT NOT NULL,                       -- Số tín chỉ
    
    -- Ràng buộc: Số tín chỉ phải lớn hơn 0
    CONSTRAINT CHK_Credits_Positive 
        CHECK (Credits > 0)
);

-- =====================================================
-- GIẢI THÍCH CÁC RÀNG BUỘC:
-- 1. PRIMARY KEY: Mã sinh viên và mã môn học là duy nhất
-- 2. NOT NULL: Họ tên và tên môn học bắt buộc nhập
-- 3. CHECK: Số tín chỉ phải > 0 (không thể là 0 hoặc âm)
-- 
-- LƯU Ý: Bài này CHƯA tạo liên kết giữa 2 bảng
-- Việc liên kết sẽ được thực hiện ở Bài 4
-- =====================================================
