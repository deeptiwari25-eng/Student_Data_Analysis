-- 🎓 Mini Project: Student Data Analysis using PostgreSQL
-- 📌 Author: (your name)
-- 🗃️ Description: Student database with departments & marks + analysis queries


-- ===========================
-- 1) DROP OLD TABLES (optional)
-- ===========================
DROP TABLE IF EXISTS marks;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS department;


-- ===========================
-- 2) CREATE TABLES
-- ===========================

CREATE TABLE department (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(60) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
    age INT CHECK (age > 0),
    dept_id INT REFERENCES department(dept_id)
);

CREATE TABLE marks (
    mark_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES student(student_id),
    subject VARCHAR(50),
    marks INT CHECK (marks BETWEEN 0 AND 100)
);


-- ===========================
-- 3) INSERT SAMPLE DATA
-- ===========================

INSERT INTO department (dept_name) VALUES
('Computer Science'),
('Mechanical'),
('Electrical');

INSERT INTO student (student_name, gender, age, dept_id) VALUES
('Aman', 'Male', 20, 1),
('Riya', 'Female', 19, 1),
('Sohan', 'Male', 21, 2),
('Priya', 'Female', 22, 3);

INSERT INTO marks (student_id, subject, marks) VALUES
(1, 'Maths', 78),
(1, 'DBMS', 85),
(2, 'Maths', 92),
(2, 'DBMS', 88),
(3, 'Thermodynamics', 67),
(4, 'Circuits', 75);


-- ===========================
-- 4) ANALYSIS QUERIES
-- ===========================

-- a) Show all students with department
SELECT s.student_id, s.student_name, s.gender, s.age, d.dept_name
FROM student s
JOIN department d ON s.dept_id = d.dept_id;

-- b) Highest marks per student
SELECT student_id, MAX(marks) AS highest_marks
FROM marks
GROUP BY student_id;

-- c) Average marks per student
SELECT student_id, AVG(marks) AS average_marks
FROM marks
GROUP BY student_id;

-- d) Department-wise student count
SELECT d.dept_name, COUNT(s.student_id) AS total_students
FROM department d
LEFT JOIN student s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- e) Students scoring above 80
SELECT s.student_name, m.subject, m.marks
FROM student s
JOIN marks m ON s.student_id = m.student_id
WHERE m.marks > 80;


-- ===========================
-- 5) VIEW FOR REPORT
-- ===========================

CREATE VIEW student_performance AS
SELECT s.student_name, d.dept_name, AVG(m.marks) AS avg_marks
FROM student s
JOIN department d ON s.dept_id = d.dept_id
JOIN marks m ON s.student_id = m.student_id
GROUP BY s.student_name, d.dept_name;

-- To see the view:
SELECT * FROM student_performance;

