
-- DROP DATABASE IF EXISTS student_db;
-- CREATE DATABASE student_db;

USE student_db;

-- Create tables
-- Table: student, course, section, grade_report, prerequisite

DROP TABLE IF EXISTS student;

CREATE TABLE student (
  student_id int NOT NULL AUTO_INCREMENT,
  student_name varchar(45),
  -- student_first_name varchar(45),
  -- student_last_name varchar(45),
  student_number int,
  student_class varchar(45),
  student_major varchar(45),
  -- student_gender varchar(45),  
  PRIMARY KEY (student_id) -- ,
  -- FOREIGN KEY (student_id) REFERENCES course(course_id)
);

INSERT INTO student (student_name, student_number, student_class, student_major) VALUES
('John Doe', 75, 'Data modelling and database programming', 'Informatics'),
('Max Ruin', 85, 'Data modelling and database programming', 'Informatics'),
('John Rob', 55, 'Data modelling and database programming', 'Informatics'),
('Krish Star', 60, 'Data modelling and database programming', 'Informatics');

SELECT * FROM student;

DROP TABLE IF EXISTS course;

CREATE TABLE course (
    course_id int NOT NULL AUTO_INCREMENT,
    course_number varchar(45), 
    course_hours INT, -- NOT NULL,
    course_name varchar(45),
    -- course_department int,
    course_department varchar(45),
    PRIMARY KEY (course_id) 
    -- FOREIGN KEY (course_id) REFERENCES student(student_id)
);

INSERT INTO course (course_number, course_hours, course_name, course_department) VALUES
('DSDD00100', 150, 'Data modelling and database programming', 'Informatics'),
('DSPRAXP300', 150, 'Practical project III', 'Informatics');

SELECT * FROM course;

DROP TABLE IF EXISTS student_course;

CREATE TABLE student_course (
	student_course_id int NOT NULL AUTO_INCREMENT,
	course_id int,
	student_id int,
	-- date,
	PRIMARY KEY (student_course_id),
	FOREIGN KEY (course_id) REFERENCES course(course_id),
	FOREIGN KEY (student_id) REFERENCES student(student_id)
);

INSERT INTO student_course (student_id, course_id) VALUES
(1,1),
(1,2),
(2,1),
(2,2),
(3,1),
(3,2),
(4,1),
(4,2);

SELECT * FROM student_course;

SELECT 
	s.*, 
	c.* 
FROM student s 
JOIN student_course sc ON s.student_id = sc.student_id -- INNER JOIN, OUTER JOIN, LEFT JOIN, RIGHT JOIN 
JOIN course c ON c.course_id = sc.course_id
WHERE c.course_id = 1
ORDER BY s.student_number ASC
LIMIT 200; -- DESC


-- Index Structures
-- Clustered and Non-Clustered Index Structures
-- Unique and Non-Unique Index Structures 

CREATE TABLE student (
  student_id int(11) NOT NULL AUTO_INCREMENT,
  -- Many tables use a numeric ID field as a primary key. 
  -- The AUTO_INCREMENT attribute can be used to generate a unique identity for new rows, 
  -- and is commonly-used with primary keys. 
  student_name varchar(45) DEFAULT NULL,
  student_number int(11) DEFAULT NULL,
  student_class varchar(45) DEFAULT NULL,
  student_major varchar(45) DEFAULT NULL,
  PRIMARY KEY (student_id), -- A primary key is unique and can never be null.
  UNIQUE KEY (student_number)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
-- InnoDB creates a 6-bytes clustered index which is invisible to the user. 

CREATE UNIQUE INDEX idx_student_major
ON student (student_major);