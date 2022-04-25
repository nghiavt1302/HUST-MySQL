-- Count tables rows
SELECT "category" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`category` UNION 
SELECT "class" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`class` UNION 
SELECT "class_student" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`class_student` UNION 
SELECT "class_weekday" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`class_weekday` UNION 
SELECT "course" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`course` UNION 
SELECT "language" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`language` UNION 
SELECT "level" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`level` UNION 
SELECT "student" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`student` UNION 
SELECT "student_account" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`student_account` UNION 
SELECT "teacher" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`teacher` UNION 
SELECT "teacher_account" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`teacher_account` UNION 
SELECT "weekday" AS table_name, COUNT(*) AS exact_row_count FROM `educationdata`.`weekday` 

--2 Ghep String CONCAT name, state
SELECT 
	CONCAT(last_name,' ', first_name, ',', state) 
AS Name_and_state 
FROM student 
ORDER BY last_name ASC

--3 Dem so student o bang giong nhau
SELECT 
	state, count(state) as Number_of_student
FROM student
GROUP BY state
order by state ASC

--4 teacher active
select 
	t.first_name, t.last_name, t.email, ta.is_active
from teacher as t
inner join teacher_account as ta on t.id = ta.id
where  ta.is_active = 1

--5 class in week and 4h
select 
	c.id as class_id, c.name as class_name, w.name as weekday, cw.hours
from class_weekday as cw
inner join class as c on c.id = cw.class_id
inner join weekday as w on w.id = cw.weekday_id
where w.id in(2,3,4,5,6) and cw.hours = 4

--6 dem so class moi student tham gia 
SELECT 
	cs.student_id, s.first_name, s.last_name, count(cs.class_id) as number_of_class_joined
FROM class_student as cs
INNER JOIN student as s ON  cs.student_id = s.id 
INNER JOIN student_account as sa ON s.id = sa.id
WHERE sa.is_active = 1 and cs.student_id <50000
GROUP BY s.id;

--7 dem so student ma moi teacher da day
select 
	t.id, t.first_name, t.last_name, count(cs.student_id) as number_of_students_taught
from teacher as t
inner join class as c on t.id = c.teacher_id
inner join class_student as cs on cs.class_id = c.id
inner join teacher_account as ta on t.id = ta.id
where ta.is_active = 1
group by t.id 

--8 liet ke course theo cac tinh chat
SELECT
	cr.id AS course_id, cgr.name AS category, lg.name AS language, lv.name AS level
FROM course AS cr
INNER JOIN category AS cgr ON cr.category_id = cgr.id
INNER JOIN language AS lg ON cr.language_id = lg.id
INNER JOIN level AS lv ON cr.level_id = lv.id
WHERE cgr.name = 'Computer Science & Programming' AND lg.name = 'ENGLISH [ENG]' AND lv.name = 'Master'
--9 so tien ma moi student da chi tra
SELECT 
	s.id, s.first_name, s.last_name, sum(c.price) AS total_price
FROM class_student AS cs
INNER JOIN student AS s ON cs.student_id = s.id
INNER JOIN class AS c ON c.id = cs.class_id
WHERE cs.student_id < 25000
GROUP BY s.id
ORDER BY total_price DESC

--10 thoi gian ket thuc lop hoc
select 
	c.id, 
    c.name,
    c.start_date,
    cr.term_by_months,
    DATE_ADD(c.start_date, interval cr.term_by_months month) as end_date
from class as c 
inner join course as cr on c.course_id = cr.id

-- procedure insert
DELIMITER //
CREATE PROCEDURE insert_student(
	IN id INT,
    IN state VARCHAR(30),
    IN first_name VARCHAR(50),
    IN last_name VARCHAR(50),
    IN email VARCHAR(50),
    IN phone VARCHAR(15))
BEGIN
	INSERT INTO student
    VALUES (id, state, first_name, last_name, email, phone);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE insert_class(
	IN id INT,
    IN name VARCHAR(30),
    IN start_date DATE,
    IN price INT,
    IN teacher_id INT,
    IN course_id INT)
BEGIN
	INSERT INTO class
    VALUES (id, name, start_date, price, teacher_id, course_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE update_student_rank(IN student_id INT)
BEGIN
	   DECLARE temp INT DEFAULT 0;
	   SELECT number_of_class_joined INTO temp
       FROM countclassesjoined as ccj WHERE ccj.student_id = student_id;
    IF (temp < 3) THEN UPDATE student SET student.rank = 'Bronze' WHERE id = student_id;
	ELSEIF (temp >= 3 AND temp <= 5) THEN UPDATE student SET student.rank = 'Silver' WHERE id = student_id;
	ELSEIF (temp > 5) THEN UPDATE student SET student.rank = 'Gold' WHERE id = student_id;
	END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE delete_student(IN student_id INT)
BEGIN
	   DECLARE is_active BIT(1) DEFAULT 1;
	   SELECT sa.is_active INTO is_active
	   FROM student_account AS sa
	   WHERE sa.student_id = student_id;
    IF (is_active = 0) THEN 
    DELETE FROM class_student AS cs WHERE cs.student_id = student_id;
    DELETE FROM student_account AS sa WHERE sa.id = student_id;
    DELETE FROM student AS s WHERE s.id = student_id;
	END IF;
END //
DELIMITER ;

-- create sql
SELECT CONCAT(
	'INSERT INTO educationdata2.', 
    table_name,
    ' SELECT * FROM educationdata.',
    table_name,
    ";"
    )
FROM INFORMATION_SCHEMA.TABLES 
WHERE table_schema = 'educationdata'



---------------- Nang cap -------------------
-- Liệt kê các student đã tham gia từ 6 khoá học trở lên
SELECT 
	s.id AS student_id,
    s.first_name,
    s.last_name, 
    count(cs.student_id) AS number_of_class_joined
FROM student AS s 
INNER JOIN class_student as cs ON s.id = cs.student_id
GROUP BY s.id
HAVING number_of_class_joined >=6 ORDER BY number_of_class_joined ASC

-- Số học sinh đã tham gia các khoá học thuộc chuyên ngành Computer Science & Programming
SELECT count(s.id) AS number_of_students FROM student AS s WHERE id IN
(
	(SELECT s.id AS student_id
	FROM student AS s
	INNER JOIN class_student AS cs ON cs.student_id = s.id
	INNER JOIN class AS c ON c.id = cs.class_id
	WHERE c.course_id IN
		(SELECT
			cr.id AS course_id
		FROM course AS cr
		INNER JOIN category AS cgr ON cr.category_id = cgr.id
		WHERE cgr.name = 'Computer Science & Programming')
	)
);

-- Thêm một course mới, tạo class mới thuộc course đó
START TRANSACTION;
SELECT @course_id:=MAX(id) + 1 FROM course;
SELECT @category_id:= id FROM category WHERE name = 'Advertising';
SELECT @language_id:= id FROM language WHERE name = 'ENGLISH [ENG]';
SELECT @level_id:= id FROM level WHERE name = 'Master';

INSERT INTO course VALUES(@course_id, 40, 'Test course', 32, @language_id, @level_id, @category_id);
SELECT @class_id:=MAX(id) + 1 FROM class;
INSERT INTO class VALUES(@class_id, 'New class 1', CURDATE(), 500, 32000, @course_id);
COMMIT;
SELECT * FROM course WHERE description = 'Test course';

-- Chuyển lớp
DELIMITER //
CREATE PROCEDURE changeClass(IN stu_id INT, IN oldC INT, IN newC INT)
BEGIN
	START TRANSACTION;
		SELECT @cs_id:= id FROM class_student WHERE student_id = stu_id AND class_id = oldC; -- Lấy ra id của bản ghi chứa thông tin đăng kí lớp cũ trong bảng class_student
		SELECT @cr_id:= course_id FROM class WHERE id = oldC; -- Lấy mã khoá học của lớp cũ
		DELETE FROM class_student WHERE student_id = stu_id AND class_id = oldC; -- Xoá đăng kí lớp cũ
		INSERT INTO class_student VALUES(@cs_id, newC, stu_id); -- Đăng kí student 330509 sang lớp 530001
		SELECT @crs_id:= course_id FROM class WHERE id = newC; -- Lấy mã khoá học của lớp mới
		IF (@crs_id != @cr_id) -- Kiểm tra lớp mới có cùng khoá học với lớp cũ không
			THEN ROLLBACK;
		END IF;
	COMMIT;
END //
DELIMITER ;

-- Xoá một student ra khỏi hệ thống
DELIMITER //
CREATE PROCEDURE deleteStudentTransaction(IN stu_id INT)
BEGIN
	START TRANSACTION;
		SELECT @checks:= count(id) FROM student WHERE id = stu_id;
        IF (@checks = 0)
			THEN ROLLBACK;
		END IF;
        DELETE FROM class_student WHERE student_id = stu_id;
        DELETE FROM student_account WHERE id = stu_id;
        DELETE FROM student WHERE id = stu_id;
	COMMIT;
END //
DELIMITER ;