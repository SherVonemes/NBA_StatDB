DROP TABLE IF EXISTS schools;
DROP TABLE IF EXISTS pupils;
DROP TABLE IF EXISTS parents;

CREATE TABLE schools(
	school_id NUMERIC(3) PRIMARY KEY,
  	school_name VARCHAR(255) NOT NULL
);

INSERT INTO schools VALUES(001, 'Школа № 763');
INSERT INTO schools VALUES(002, 'Школа № 123');
INSERT INTO schools VALUES(003, 'Школа № 245');

CREATE TABLE pupils(
	pupil_id NUMERIC(3) PRIMARY KEY,
  	school_num NUMERIC(5) REFERENCES schools(school_name),
  	pupil_name VARCHAR(255),
  	birth_date Date,
  	score NUMERIC(3)
);

INSERT INTO pupils VALUES(1, 1, 'Петров Юрий Борисович', '20.02.2004', 99);
INSERT INTO pupils VALUES(2, 1, 'Козлов Иван Петрович', '112.03.2002', 85);
INSERT INTO pupils VALUES(3, 2, 'Иванова Анна Сергеевна', '23.04.2004', 83);
INSERT INTO pupils VALUES(4, 3, 'Селиванова Ольга Петровна', '12.05.2005', 100);
INSERT INTO pupils VALUES(5, 3, 'Барсуков Илья Борисович', '13.07.2003', 34);
INSERT INTO pupils VALUES(6, 3, 'Сидорова Мария Викторовна', '02.06.2001', 56);

CREATE TABLE parents(
	pupil_id NUMERIC(5)	REFERENCES pupils(pupil_id),
  	parent_name VARCHAR(255), 
  	parent_sex VARCHAR(1)
);

INSERT INTO parents VALUES(1, 'Петров Борис', 'м');
INSERT INTO parents VALUES(1, 'Петрова Ольга', 'ж');
INSERT INTO parents VALUES(2, 'Козлов Пётр', 'м');
INSERT INTO parents VALUES(2, 'Козлова Инна', 'ж');
INSERT INTO parents VALUES(3, 'Иванов Сергей', 'м');
INSERT INTO parents VALUES(3, 'Иванова Алла', 'ж');
INSERT INTO parents VALUES(4, 'Селиванова Инна', 'ж');
INSERT INTO parents VALUES(5, 'Барсуков Борис', 'м');
INSERT INTO parents VALUES(5, 'Кузнецова Ольга', 'ж');
INSERT INTO parents VALUES(6, 'Сидорова Анна', 'ж');


--- 1) Сколько учеников в базе данных?
SELECT COUNT(pupils.pupil_name) AS pupil_num FROM pupils;

--- 2) Каков минимальный и максимальный балл по всем ученикам?
SELECT MIN(pupils.score) AS min_score from pupils;
SELECT MAX(pupils.score) AS max_score FROM pupils;

--- 3) Какой средний балл у учеников Школы № 123?
SELECT AVG(pupils.score) FROM pupils, schools WHERE pupils.school_num = schools.school_id AND schools.school_name = 'Школа № 123';

--- 4) Какой средний балл по каждой школе?
SELECT schools.school_name, AVG(pupils.score)
FROM pupils, schools WHERE pupils.school_num = schools.school_id GROUP BY pupils.school_num;

--- 5) Сколько учеников в каждой школе?
SELECT schools.school_name, COUNT(pupils.pupil_id) AS pupil_num
FROM pupils, schools WHERE pupils.school_num = schools.school_id GROUP BY pupils.school_num;

--- 6) Выведите название школ, в которых учатся больше 2-х учеников?
SELECT schools.school_name 
FROM schools join pupils on (pupils.school_num = schools.school_id) 
GROUP BY schools.school_name
HAVING COUNT(pupils.pupil_name) > 2;

--- 7) Выведите таблицу с двумя колонками. В первой колонке ФИО ученика, а во второй его родителя.
SELECT pupils.pupil_name, parents.parent_name 
FROM pupils join parents ON pupils.pupil_id = parents.pupil_id;

--- 8) Выведите таблицу с двумя колонками. В первой колонке ФИО ученика, 
--- а во второй количество родителей, по которым есть информация в базе данных.

SELECT pupils.pupil_name, COUNT(parents.parent_name)
FROM pupils join parents ON pupils.pupil_id = parents.pupil_id
GROUP BY pupils.pupil_name;



5 Запросов

--5 запросов
--Найти школы, в которых все ученики имеют балл ниже 70
SELECT school_name 
FROM schools
WHERE school_id IN (SELECT school_num FROM pupils WHERE score < 70);


--Дети полноценных семей для определенеия или неполноты данных, или определения неполных семей
SELECT pupil_name
FROM pupils
WHERE pupil_id IN (
    SELECT pupil_id
    FROM parents
    GROUP BY pupil_id
    HAVING COUNT(parent_name) > 1
);

-- сколько учеников обладают баллами выше среднего 
SELECT COUNT(*)
FROM pupils
WHERE score > (SELECT AVG(score) FROM pupils);

-- Выбор школы с минимальной разницей между максимальным и минимальным баллом
SELECT school_name
FROM schools
WHERE school_id IN (
    SELECT school_num
    FROM pupils
    GROUP BY school_num
    ORDER BY (MAX(score) - MIN(score))
    LIMIT 1
);

--Школы, где нет учеников выше 90
SELECT school_name
FROM schools
WHERE school_id IN (
    SELECT school_num
    FROM pupils
    GROUP BY school_num
    HAVING MAX(score) < 90
);

--Что-то дополнительное
--Найти учеников, у которых родители не являются родителями других учеников в базе данных:
SELECT pupil_name
FROM pupils
WHERE pupil_id in (
    SELECT pupil_id
    FROM parents
    WHERE parent_name IN (
        SELECT parent_name
        FROM parents
        WHERE pupil_id <> pupils.pupil_id
    )
);
--Понимаем, что их нет, придумаем тогда
--Добавление братьев и сестер 
INSERT INTO pupils VALUES(7, 3, 'Семенов Владислав Алексеевич', '09.03.2002', 70);
INSERT INTO pupils VALUES(8, 3, 'Семенова Диана Алексеевна', '15.01.2005', 85);
INSERT INTO parents VALUES(7, 'Ващейкина Наталья', 'ж');
INSERT INTO parents VALUES(7, 'Семенов Алексей', 'м');
INSERT INTO parents VALUES(8, 'Ващейкина Наталья', 'ж');
INSERT INTO parents VALUES(8, 'Семенов Алексей', 'м');

--SELECT * from pupils
--Исправим запрос и добавим ограничение на одну школу и посчитаем кол-во братьев и сестер
SELECT COUNT(*)
FROM pupils
WHERE pupil_id IN (
    SELECT pupil_id
    FROM parents
    WHERE parent_name IN (
        SELECT parent_name
        FROM parents
        WHERE (pupil_id <> pupils.pupil_id AND school_num = pupils.school_num)
    )
);
--и имена
SELECT pupil_name
FROM pupils
WHERE pupil_id IN (
    SELECT pupil_id
    FROM parents
    WHERE parent_name IN (
        SELECT parent_name
        FROM parents
        WHERE (pupil_id <> pupils.pupil_id AND school_num = pupils.school_num)
    )
);
-- определим медиану для каждой школы
SELECT
    school_num,
    AVG(score) AS median_score
FROM (
    SELECT
        p.school_num,
        p.score,
        (SELECT COUNT(*) FROM pupils WHERE school_num = p.school_num) AS total_rows,
        (SELECT COUNT(*) FROM pupils WHERE school_num = p.school_num AND score <= p.score) AS row_num
    FROM pupils p
) AS subquery
WHERE
    row_num IN ((total_rows + 1) / 2, (total_rows + 2) / 2) -- из-за нечетности - чтобы было точное значение
GROUP BY school_num;





--2 ЧАСТЬ

DROP TABLE IF EXISTS school;
DROP TABLE IF EXISTS school2;
DROP TABLE IF EXISTS pupils;

---Создаём таблицу «Школы»
CREATE TABLE school (
	schoolno NUMERIC(3) CONSTRAINT pk_sch PRIMARY KEY,
	name VARCHAR(80) NOT NULL);
    
---Заполняем данными таблицу «Школы»
insert into school values(001, 'Школа № 763' );
insert into school values(002, 'Школа № 123' );
insert into school values(003, 'Школа № 245' );
insert into school values(004, 'Школа № 145' );
insert into school values(005, 'Школа № 255' );

---Создаём таблицу «Школы2»
CREATE TABLE school2 (
	schoolno NUMERIC(3),
	name VARCHAR(80) NOT NULL);
---Заполняем данными таблицу «Школы2»
insert into school2 values(001, 'Школа № 763' );
insert into school2 values(002, 'Школа № 123' );
insert into school2 values(333, 'Школа № 845' );
insert into school2 values(444, 'Школа № 245' );
insert into school2 values(555, 'Школа № 655' );

---Создаём таблицу «Ученики»
create table pupils(
  	pupnum NUMERIC(3,0) constraint pk_pup primary key,
	schoolno NUMERIC(3,0),
	pupname varchar2(50) NOT NULL,
	born date,
	grade NUMERIC(10,1)
);
---Заполняем данными таблицу «Ученики»
insert into pupils values(001, 001, 'Петров Юрий Борисович', '01-FEB-2004', 99);
insert into pupils values(002, 001, 'Козлов Иван Петрович', '12-MAR-2002', 85);
insert into pupils values(003, 002, 'Иванова Анна Сергеевна', '23-APR-2004', 83);
insert into pupils values(004, 003, 'Селиванова Ольга Петровна', '12-MAY-2005', 100);
insert into pupils values(005, 003, 'Барсуков Илья Борисович', '13-JUL-2003', 34);
insert into pupils values(006, 003, 'Сидорова Мария Викторовна', '02-JUN-2001', 56);
insert into pupils values(007, 012, 'Спиридов Василий Иванович', '01-JUL-2001', 96);
insert into pupils values(777, 013, 'Васильев Иван Петрович', '02-AUG-2001', 86);



--- 1) Соединить таблицы «Школы» и «Ученики» на основе декартова произведения таблиц
SELECT *
FROM school CROSS JOIN pupils;

--- 2) Соединить таблицы «Школы» и «Ученики» по ключу “schoolno”

SELECT *
FROM school JOIN pupils ON school.schoolno = pupils.schoolno;

--- 3) Объединить в одну таблицу данные из таблиц «Школы» и «Школы2» без дублирования
--- одинаковых записей.

SELECT * FROM school
UNION
SELECT * FROM school2;


--- 4) Отобразить название школ, которые есть в таблице «Школы», но отсутствуют в таблице «Школы2»

SELECT name from school
	where schoolno NOT IN (
    SELECT schoolno from school2
    );

--- 5) Отобразить названия школ, которые есть и в таблице «Школы», и в таблице «Школы2»

select name from school
where school.schoolno IN (
SELECT schoolno from school2
);

--- 6) Отобразить в одной таблице информацию из таблиц «Школы» и «Ученики». Если в школе нет учеников, то информация о ней отображается в таблице, а в столбцах про учеников стоят пропуски (null). Если у ученика отсутствует информация по его школе, то он не отображается в таблице.

SELECT * FROM school LEFT JOIN pupils
ON school.schoolno = pupils.schoolno;

--- 7) Отобразить в одной таблице информацию из таблиц «Школы» и «Ученики». Если у ученика отсутствует информация по его школе, то информация об ученике отображается в таблице, а в столбцах про школы стоят пропуски (null). Если у школы отсутствуют ученики, то информация о ней не отображается в таблице.

SELECT * FROM school RIGHT JOIN pupils
ON school.schoolno = pupils.schoolno;

--- 8) Отобразить в одной таблице информацию о школе и учениках. В таблице должны
присутствовать и школы, в которых нет учеников, и ученики, для которых информация об
их школах отсутствует в базе данных. Пропущенные ячейки будут помечены как null.

SELECT * FROM school FULL OUTER JOIN pupils
ON school.schoolno = pupils.schoolno;

--- 9) Отобразить названия только тех школ из таблицы «Школы», в которых есть ученики.

SELECT DISTINCT school.name
from school inner join pupils 
on school.schoolno = pupils.schoolno;

—5 простых запросов на join

SELECT DISTINCT s.name
FROM school s
JOIN pupils p ON s.schoolno = p.schoolno
WHERE p.grade > 90;


SELECT DISTINCT s.name
FROM school s
JOIN pupils p ON s.schoolno = p.schoolno
WHERE p.born > '2003-01-01';


SELECT s.name, p.pupname, p.grade
FROM school s
JOIN pupils p ON s.schoolno = p.schoolno
WHERE p.grade = (SELECT MAX(grade) FROM pupils);


SELECT s.name, p.pupname, p.grade
FROM school s
JOIN pupils p ON s.schoolno = p.schoolno
WHERE p.grade < (SELECT AVG(grade) FROM pupils);


SELECT s.name
FROM school s
LEFT JOIN pupils p ON s.schoolno = p.schoolno
WHERE p.pupnum IS NULL;
