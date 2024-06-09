--создали таблицу и заполнили ее данными

CREATE TABLE emp (TabNo int, DepNo int, Name Varchar(30),
                                             Post Varchar(40),
                                                  Salary number (7, 1),
                                                         born Date, phone Varchar(30));


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (988, 1, 'Промин В.И.', 'начальник отдела', 48500.0, '02-FEB-1970', '115-26-12');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (909, 1, 'Серова Т.Б.', 'вед. программист', 48500.0, '20-OCT-1981', '115-91-19');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (829, 1, 'Дурова А.Б.', 'экономист', 43500.0, '03-OCT-1978', '115-26-12');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (819, 1, 'Тамм Л.В.', 'экономист', 43500.0, '13-NOV-1985', '115-91-19');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (100, 2, 'Волков Л.Д.', 'программист', 46500.0, '16-OCT-1982', NULL);


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (110, 2, 'Буров Г.О.', 'бухгалтер', 42880.0, '22-MAY-1975', '115-46-32');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (023, 2, 'Малова Л.А.', 'гл. бухгалтер', 59240.0, '24-NOV-1954', '114-24-55');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (130, 2, 'Лукьяна Н.Н.', 'бухгалтер', 42880.0, '12-JUL-1979', '115-46-32');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (034, 3, 'Перова К.В.', 'делопроизводитель', 32000.0, '24-APR-1988', NULL);


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (002, 3, 'Сухова К.А.', 'начальник отдела', 48500.0, '08-JUN-1948', '115-12-69');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (056, 5, 'Павлов А.А.', 'директор', 80000.0, '05-MAY-1968', '115-33-44');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (087, 5, 'Котова И.М.', 'секретарь', 35000.0, '16-SEP-1990', '115-33-65');


INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Born, Phone)
VALUES (088, 5, 'Кроль А.П.', 'зам.директора', 70000.0, '18-APR-1974', '115-33-01');

--описали структуру
DESC emp;

--общая проверка

SELECT *
FROM emp;

--добавили кол-во детей

ALTER TABLE emp ADD children_number int;

--добавили пол сотрудника

ALTER TABLE emp ADD gender varchar(5);

--убрали колонку born

ALTER TABLE emp
DROP COLUMN born;

--добавили данные о новом сотруднике (мне)

INSERT INTO emp (TabNo, DepNo, Name, Post, Salary, Phone, children_number, gender)
VALUES (101, 2, 'Семенов В.А.', 'программист', 46500.0, '468-77-05', 0, 'М');

--добавили ограниченные данные о новом сотруднике

INSERT INTO emp (TabNo, Name)
VALUES (102, 'Сальников И.С.');

--удалили сотрудников-бухгалтеров

DELETE
FROM emp
WHERE post like '%бухгалтер%';

--вместо зп - зп с подоходным налогом

UPDATE emp
SET salary=0.87*salary ;

--Назначем Дурову на должность главного бухгалтера

UPDATE emp
SET post='гл.бухгалтер'
WHERE tabno=829; --зп не менял)); можно еще по name='Дурова А.Б.' или name like '%Дурова%'

--Придумаем 5 простых запросов к базе данных, постараемся не повторяться, с прошлыми запросами
 --Добавим детей у сотрудников (додумаем, и оставим пробелы, тк это информация не самая очевидная)) и расставим пол правильно

UPDATE emp
SET children_number=0
WHERE tabno in (988,
                829);


UPDATE emp
SET children_number=1
WHERE tabno in (2,
                56);


UPDATE emp
SET children_number=2
WHERE tabno in (819,
                34);


UPDATE emp
SET children_number=3
WHERE tabno in (88);

--пол (две фамилии я не смог расшифровать))

UPDATE emp
SET gender='M'
WHERE tabno in (988,
                909,
                829,
                100,
                56,
                101,
                102);


UPDATE emp
SET gender='Ж'
WHERE tabno in (909,
                829,
                34,
                2,
                87);

--Добавили стаж каждого работника в этой компании, чтобы можно было получить больше информации - укажем дату найма и заполним ее для некоторых пользователей

ALTER TABLE emp ADD Hire DATE;


UPDATE emp
SET Hire = '15-jan-2020'
WHERE tabno in (56,
                829,
                988);

--Добавим лист подчинения, создав еще один столбец, куда мы запишем непосредственного начальника человека, если такого нет, то оставим пропуск

ALTER TABLE emp ADD head varchar(30);


UPDATE emp
SET head='Павлов А.А.'
WHERE post in ('начальник отдела',
               'зам.директора',
               'секретарь');


UPDATE emp
SET head='Промин В.И.'
WHERE depno=1
  AND name!='Промин В.И.'; --да, можно по другому, но так - наглядно

UPDATE emp
SET head='Сухова К.А.'
WHERE depno=3
  AND name!='Сухова К.А.';

--Предположим, что нам нужны сотрудники только с номерами телефонов, там, где null - удалим эти строки

DELETE
FROM emp
WHERE phone IS NULL;

/* Рассчитаем премии по итогам года, а потом по телефону работникам об этом сообщим;
 добавим их в таблицу, будем считать, что лучше всего работает департамент 2, затем 3,1,5. А еще учтем процент от зп в премию. */
ALTER TABLE emp ADD bonus int;


UPDATE emp
SET bonus=0.5*salary+10000
WHERE depno=2;


UPDATE emp
SET bonus=0.4*salary+7500
WHERE depno=3;


UPDATE emp
SET bonus=0.3*salary+5000
WHERE depno=1;


UPDATE emp
SET bonus=0.2*salary+2500
WHERE depno=5;

--select * from emp;
 --Теперь будем выполнять задания на 10 (⌐▀͡ ̯ʖ▀)
--Посчитаем через select несколько интересных вещей
--Выведем всех сотрудников по доходам в конце месяца (где доход это зарплата плюс бонус) в порядке убывания:

SELECT Name,
       (salary + bonus) AS money_earned
FROM emp
ORDER BY money_earned DESC;

--Выясним сколько потратили на премии всего

SELECT SUM(bonus) AS bonus_paid
FROM emp
ORDER BY bonus_paid DESC;

/* Выведем только женщин, имеющих детей, чтобы посчитать количество подарков,
которое необходимо мамам купить как поощрение от компании (традиционные ценности), добавим к ним людей,
пол которых мы не определили, чтобы подарков точно хватило (некоторые из них могут оказаться женщиными)*/
SELECT SUM(children_number) AS gifts
FROM emp
WHERE gender = 'Ж'
  OR gender IS NULL
  AND children_number > 0;

--сколько в процентном соотношении родителей, относительно тех, про кого точно известно сколько у них детей

SELECT ROUND(
               (SELECT COUNT(*)
                FROM emp
                WHERE children_number > 0) * 100.0 /
               (SELECT COUNT(*)
                FROM emp
                WHERE children_number IS NOT NULL) , 2) AS parent_percent
FROM emp FETCH FIRST ROW ONLY; --я писал limit 1 и у меня ничего не работало, пока я не понял, что я в oracle

--Выведем бюджет всех департаментов

SELECT DepNo,
       SUM(salary + bonus) AS DepNo_budget
FROM emp
GROUP BY DepNo;

--бюджет на одного сотрудника

SELECT DepNo,
       AVG(salary + bonus) AS DepNo_budget_per_worker
FROM emp
GROUP BY DepNo;

--очистить записи таблицы

DELETE
FROM emp;

--удалить таблицу

DROP TABLE emp;

