CREATE TABLE schools(
  school_id INT PRIMARY KEY, 
  school_name VARCHAR(255) NOT NULL
);
INSERT INTO schools 
VALUES 
  (1, 'Школа № 763');
INSERT INTO schools 
VALUES 
  (2, 'Школа № 123');
INSERT INTO schools 
VALUES 
  (3, 'Школа № 245');
-- /*
-- */
CREATE TABLE pupils(
  pupil_id INT PRIMARY KEY, 
  school_id INT REFERENCES schools(school_id), 
  full_name VARCHAR2(255) NOT NULL, 
  birth_date DATE, 
  scores INT
);
INSERT INTO pupils 
VALUES 
  (
    1, 1, 'Петров Юрий Борисович', 
    DATE '2004-02-01', 99
  );
INSERT INTO pupils 
VALUES 
  (
    2, 1, 'Козлов Иван Петрович', 
    DATE '2002-03-12', 85
  );
INSERT INTO pupils 
VALUES 
  (
    3, 2, 'Иванова Анна Сергеевна', 
    DATE '2004-04-23', 83
  );
INSERT INTO pupils 
VALUES 
  (
    4, 3, 'Селиванова Ольга Петровна', 
    DATE '2005-05-12', 100
  );
INSERT INTO pupils 
VALUES 
  (
    5, 3, 'Барсуков Илья Борисович', 
    DATE '2003-07-13', 34
  );
INSERT INTO pupils 
VALUES 
  (
    6, 3, 'Сидорова Мария Викторовна', 
    DATE '2001-06-02', 56
  );
CREATE TABLE parents(
  pupil_id INT REFERENCES pupils(pupil_id), 
  parent_name VARCHAR(255), 
  gender VARCHAR(7) CHECK (
    gender IN ('м', 'ж')
  ), 
  PRIMARY KEY (pupil_id, parent_name)
);
INSERT INTO parents 
VALUES 
  (
    1, 'Петров Борис', 'м'
  );
INSERT INTO parents 
VALUES 
  (
    1, 'Петрова Ольга', 'ж'
  );
INSERT INTO parents 
VALUES 
  (2, 'Козлов Пётр', 'м');
INSERT INTO parents 
VALUES 
  (
    2, 'Козлова Инна', 'ж'
  );
INSERT INTO parents 
VALUES 
  (
    3, 'Иванов Сергей', 'м'
  );
INSERT INTO parents 
VALUES 
  (
    3, 'Иванова Алла', 'ж'
  );
INSERT INTO parents 
VALUES 
  (
    4, 'Селиванова Инна', 
    'ж'
  );
INSERT INTO parents 
VALUES 
  (
    5, 'Барсуков Борис', 
    'м'
  );
INSERT INTO parents 
VALUES 
  (
    5, 'Кузнецова Ольга', 
    'ж'
  );
INSERT INTO parents 
VALUES 
  (
    6, 'Сидорова Анна', 'ж'
  );
/*Больше всего напрашивается таблица про предметы, где каждый ученик может иметь оценки по разным предметам. Внешний ключ, составной ключ и тд присутствует*/
CREATE TABLE subjects(
  PupilNum INT REFERENCES pupils, 
  SubjectName VARCHAR(100) NOT NULL, 
  Score INT CHECK (
    Score BETWEEN 1 
    AND 5
  ), 
  PRIMARY KEY (PupilNum, SubjectName)
);
INSERT INTO subjects 
VALUES 
  (1, 'Математика', 5);
INSERT INTO subjects 
VALUES 
  (3, 'Биология', 2);
INSERT INTO subjects 
VALUES 
  (4, 'Химия', 5);
INSERT INTO subjects 
VALUES 
  (5, 'Математика', 3);
INSERT INTO subjects 
VALUES 
  (1, 'География', 5);
INSERT INTO subjects 
VALUES 
  (1, 'Литература', 4);
INSERT INTO subjects 
VALUES 
  (2, 'Физика', 5);
INSERT INTO subjects 
VALUES 
  (3, 'Химия', 3);
INSERT INTO subjects 
VALUES 
  (4, 'Биология', 5);
INSERT INTO subjects 
VALUES 
  (5, 'География', 2);
--узнаем родителя двоичника
SELECT 
  parent_name, 
  gender 
FROM 
  parents 
WHERE 
  pupil_id = 6;
--оценки по предмету второго интересуюещго нас ученика
SELECT 
  SubjectName, 
  Score 
FROM 
  subjects 
WHERE 
  PupilNum = 1;
--для других учеников, которые плохо учатся
SELECT 
  pupils.pupil_id, 
  pupils.full_name, 
  subjects.SubjectName, 
  subjects.Score 
FROM 
  subjects 
  JOIN pupils ON subjects.PupilNum = pupils.pupil_id 
WHERE 
  subjects.Score < 4;
-- тоже самое, но с отличниками по предмету (те, у кого есть пятерки)
SELECT 
  pupils.pupil_id, 
  pupils.full_name 
FROM 
  subjects 
  JOIN pupils ON subjects.PupilNum = pupils.pupil_id 
GROUP BY 
  pupils.pupil_id, 
  pupils.full_name 
HAVING 
  MIN(subjects.Score) = 5;
-- проводим собрание и нужно соответствие учеников и их родителей
SELECT 
  pupils.full_name AS pupil_name, 
  parents.parent_name 
FROM 
  pupils 
  JOIN parents ON pupils.pupil_id = parents.pupil_id;
--кол-во учеников в первых двух школах 
SELECT 
  (
    SELECT 
      COUNT(*) 
    FROM 
      pupils 
    WHERE 
      school_id = 1
  ) AS count_763, 
  (
    SELECT 
      COUNT(*) 
    FROM 
      pupils 
    WHERE 
      school_id = 2
  ) AS count_123 
from 
  pupils;
--криво хз как переделать - гугли про limit 1 ток в sql oracle 
-- кол-во лучших в каждой школе
SELECT 
  schools.school_name, 
  COUNT(pupils.pupil_id) AS top_performers 
FROM 
  schools 
  JOIN pupils ON schools.school_id = pupils.school_id 
WHERE 
  pupils.scores > 80 
GROUP BY 
  schools.school_name;
-- средний балл по предмету
SELECT 
  SubjectName, 
  AVG(Score) AS Average_Score 
FROM 
  subjects 
GROUP BY 
  SubjectName;
-- максимальный балл
SELECT 
  schools.school_name, 
  pupils.full_name, 
  pupils.scores 
FROM 
  pupils 
  JOIN schools ON pupils.school_id = schools.school_id 
WHERE 
  pupils.scores IN (
    SELECT 
      MAX(scores) 
    FROM 
      pupils 
    WHERE 
      school_id = schools.school_id
  );
-- школы выше среднего по баллам
SELECT 
  schools.school_name 
FROM 
  schools 
  JOIN pupils ON schools.school_id = pupils.school_id 
GROUP BY 
  schools.school_name 
HAVING 
  AVG(pupils.scores) > (
    SELECT 
      AVG(scores) 
    FROM 
      pupils
  );
-- школа хочет заработать на учениках, которые плохо учатся давайте поможем ей - если оценка ученика за предмет ниже 3, он обязан ходить на дополнительные платные курсы. Посчитаем выручку школы
SELECT 
  schools.school_name, 
  COUNT(subjects.PupilNum) * 4 AS monthly_sessions, 
  COUNT(subjects.PupilNum) * 4000 AS potential_revenue 
FROM 
  subjects 
  JOIN pupils ON subjects.PupilNum = pupils.pupil_id 
  JOIN schools ON pupils.school_id = schools.school_id 
WHERE 
  subjects.Score < 3 
GROUP BY 
  schools.school_name;
-- Список учеников и стоимость их дополнительных занятий
SELECT 
  pupils.full_name, 
  COUNT(subjects.SubjectName) * 4000 AS total_monthly_fee 
FROM 
  subjects 
  JOIN pupils ON subjects.PupilNum = pupils.pupil_id 
WHERE 
  subjects.Score < 3 
GROUP BY 
  pupils.full_name;
-- Список предметов и выручка по ним
SELECT 
  subjects.SubjectName, 
  COUNT(subjects.PupilNum) * 4000 AS potential_revenue 
FROM 
  subjects 
WHERE 
  subjects.Score < 3 
GROUP BY 
  subjects.SubjectName;