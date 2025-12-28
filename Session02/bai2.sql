-- =====================================================
-- BÀI 2: TẠO BẢNG CLASS VÀ STUDENT
-- Mối quan hệ: Một lớp có nhiều sinh viên (1-N)
-- =====================================================

-- Tạo database (nếu chưa có)
CREATE DATABASE IF NOT EXISTS QuanLyDaoTao;
USE QuanLyDaoTao;

-- =====================================================
-- BẢNG 1: CLASS (Lớp học) - Bảng CHA
-- =====================================================
CREATE TABLE Class (
    ClassID VARCHAR(10) PRIMARY KEY,           -- Khóa chính
    ClassName NVARCHAR(100) NOT NULL,          -- Tên lớp (bắt buộc)
    AcademicYear VARCHAR(9) NOT NULL           -- Năm học (VD: 2024-2025)
);

-- =====================================================
-- BẢNG 2: STUDENT (Sinh viên) - Bảng CON
-- =====================================================
CREATE TABLE Student (
    StudentID VARCHAR(10) PRIMARY KEY,         -- Khóa chính
    FullName NVARCHAR(100) NOT NULL,           -- Họ tên (bắt buộc)
    BirthDate DATE,                            -- Ngày sinh
    ClassID VARCHAR(10),                       -- Khóa ngoại tới Class
    
    -- Thiết lập mối quan hệ với bảng Class
    CONSTRAINT FK_Student_Class 
        FOREIGN KEY (ClassID) 
        REFERENCES Class(ClassID)
);

-- =====================================================
-- GIẢI THÍCH:
-- 1. Bảng Class được tạo TRƯỚC vì là bảng Cha
-- 2. Bảng Student chứa ClassID làm FOREIGN KEY
-- 3. Mỗi sinh viên thuộc về 1 lớp (ClassID)
-- 4. Một lớp có thể có nhiều sinh viên
-- =====================================================
