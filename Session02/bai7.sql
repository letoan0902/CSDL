-- =====================================================
-- BÀI 7: CSDL HOÀN CHỈNH - QUẢN LÝ ĐÀO TẠO
-- =====================================================
-- Bao gồm: Sinh viên, Lớp học, Môn học, Giảng viên,
--          Đăng ký môn học, Kết quả học tập
-- =====================================================

-- Tạo database
DROP DATABASE IF EXISTS QuanLyDaoTao;
CREATE DATABASE QuanLyDaoTao;
USE QuanLyDaoTao;

-- =====================================================
-- 1. BẢNG CLASS (Lớp học)
-- =====================================================
CREATE TABLE Class (
    ClassID VARCHAR(10) PRIMARY KEY,
    ClassName NVARCHAR(100) NOT NULL,
    AcademicYear VARCHAR(9) NOT NULL
);

-- =====================================================
-- 2. BẢNG TEACHER (Giảng viên)
-- =====================================================
CREATE TABLE Teacher (
    TeacherID VARCHAR(10) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

-- =====================================================
-- 3. BẢNG STUDENT (Sinh viên)
-- =====================================================
CREATE TABLE Student (
    StudentID VARCHAR(10) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    BirthDate DATE,
    ClassID VARCHAR(10),
    
    CONSTRAINT FK_Student_Class 
        FOREIGN KEY (ClassID) 
        REFERENCES Class(ClassID)
);

-- =====================================================
-- 4. BẢNG SUBJECT (Môn học)
-- =====================================================
CREATE TABLE Subject (
    SubjectID VARCHAR(10) PRIMARY KEY,
    SubjectName NVARCHAR(100) NOT NULL,
    Credits INT NOT NULL,
    TeacherID VARCHAR(10),
    
    CONSTRAINT CHK_Credits_Positive 
        CHECK (Credits > 0),
    
    CONSTRAINT FK_Subject_Teacher 
        FOREIGN KEY (TeacherID) 
        REFERENCES Teacher(TeacherID)
);

-- =====================================================
-- 5. BẢNG ENROLLMENT (Đăng ký môn học)
-- =====================================================
CREATE TABLE Enrollment (
    StudentID VARCHAR(10) NOT NULL,
    SubjectID VARCHAR(10) NOT NULL,
    EnrollmentDate DATE DEFAULT (CURRENT_DATE),
    
    PRIMARY KEY (StudentID, SubjectID),
    
    CONSTRAINT FK_Enrollment_Student 
        FOREIGN KEY (StudentID) 
        REFERENCES Student(StudentID),
    
    CONSTRAINT FK_Enrollment_Subject 
        FOREIGN KEY (SubjectID) 
        REFERENCES Subject(SubjectID)
);

-- =====================================================
-- 6. BẢNG SCORE (Kết quả học tập)
-- =====================================================
CREATE TABLE Score (
    StudentID VARCHAR(10) NOT NULL,
    SubjectID VARCHAR(10) NOT NULL,
    ProcessScore DECIMAL(4,2),
    FinalScore DECIMAL(4,2),
    
    PRIMARY KEY (StudentID, SubjectID),
    
    CONSTRAINT FK_Score_Student 
        FOREIGN KEY (StudentID) 
        REFERENCES Student(StudentID),
    
    CONSTRAINT FK_Score_Subject 
        FOREIGN KEY (SubjectID) 
        REFERENCES Subject(SubjectID),
    
    CONSTRAINT CHK_ProcessScore 
        CHECK (ProcessScore >= 0 AND ProcessScore <= 10),
    
    CONSTRAINT CHK_FinalScore 
        CHECK (FinalScore >= 0 AND FinalScore <= 10)
);

-- =====================================================
-- TỔNG KẾT CÁC BẢNG VÀ RÀNG BUỘC:
-- =====================================================
/*
┌─────────────────────────────────────────────────────────────────┐
│                    SƠ ĐỒ QUAN HỆ                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────┐         ┌───────────┐         ┌─────────┐        │
│   │  Class  │ 1 ── N │  Student  │ N ── M │ Subject │        │
│   └─────────┘         └───────────┘         └─────────┘        │
│                              │                    │             │
│                              │                    │ N           │
│                              │                    │             │
│                              │                    │ 1           │
│                              ▼                    ▼             │
│                       ┌───────────┐         ┌─────────┐        │
│                       │Enrollment │         │ Teacher │        │
│                       │  (N-N)    │         └─────────┘        │
│                       └───────────┘                             │
│                              │                                  │
│                              ▼                                  │
│                       ┌───────────┐                             │
│                       │   Score   │                             │
│                       └───────────┘                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘

DANH SÁCH RÀNG BUỘC:
═══════════════════

PRIMARY KEY (6):
  • Class.ClassID
  • Teacher.TeacherID
  • Student.StudentID
  • Subject.SubjectID
  • Enrollment.(StudentID, SubjectID) - Composite
  • Score.(StudentID, SubjectID) - Composite

FOREIGN KEY (6):
  • Student.ClassID → Class.ClassID
  • Subject.TeacherID → Teacher.TeacherID
  • Enrollment.StudentID → Student.StudentID
  • Enrollment.SubjectID → Subject.SubjectID
  • Score.StudentID → Student.StudentID
  • Score.SubjectID → Subject.SubjectID

UNIQUE (1):
  • Teacher.Email

CHECK (3):
  • Subject.Credits > 0
  • Score.ProcessScore BETWEEN 0 AND 10
  • Score.FinalScore BETWEEN 0 AND 10

NOT NULL (nhiều cột trong các bảng)

THỨ TỰ TẠO BẢNG (Quan trọng!):
  1. Class, Teacher (bảng cha, không phụ thuộc)
  2. Student (phụ thuộc Class)
  3. Subject (phụ thuộc Teacher)
  4. Enrollment (phụ thuộc Student, Subject)
  5. Score (phụ thuộc Student, Subject)
*/
