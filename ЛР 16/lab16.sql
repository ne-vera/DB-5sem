create tablespace ts_sharp_1
datafile 'C:\labs_bd\lab16\TS_SHARP_1.dbf'
size 20m
reuse autoextend on next 2M
online
extent management local;

create tablespace ts_sharp_2
datafile 'C:\labs_bd\lab16\TS_SHARP_2.dbf'
size 20m
reuse autoextend on next 2M
online
extent management local;

create tablespace ts_sharp_3
datafile 'C:\labs_bd\lab16\TS_SHARP_3.dbf'
size 20m
reuse autoextend on next 2M
online
extent management local;

create tablespace ts_sharp_4
datafile 'C:\labs_bd\lab16\TS_SHARP_4.dbf'
size 20m
reuse autoextend on next 2M
online
extent management local;
--1.	Создайте таблицу T_RANGE c диапазонным секционированием.
--Используйте ключ секционирования типа NUMBER.
create table t_range
(
  str nvarchar2(20) primary key,
  num int
)
partition by range (num)
(
  partition nums_less_10 values less than (10) tablespace TS_SHARP_1,
  partition nums_less_20 values less than (20) tablespace TS_SHARP_2,
  partition nums_less_30 values less than (30) tablespace TS_SHARP_3,
  partition nums_max values less than (maxvalue) tablespace ts_sharp_4
); 

insert into t_range values ('str 1', 8);
insert into t_range values ('str 2', 12);
insert into t_range values ('str 3', 25);
insert into t_range values ('str 4', 40);
insert into t_range values ('str 5', 4);
insert into t_range values ('str 6', 6);

select * from t_range partition (nums_less_10);
select * from t_range partition (nums_less_20);
select * from t_range partition (nums_less_30);
select * from t_range partition (nums_max);

--2.	Создайте таблицу T_INTERVAL c интервальным секционированием. 
--Используйте ключ секционирования типа DATE.
create table t_interval
(
  id int generated always as identity,
  date_id date unique
)
partition by range (date_id) 
interval (NUMTOYMINTERVAL(1, 'YEAR'))
store in (TS_SHARP_1, TS_SHARP_2, TS_SHARP_3, TS_SHARP_4)
(
  partition part_1 values less than ('01-APR-2012') tablespace TS_SHARP_1
);

insert into t_interval (date_id) values ('11/MAY/2011');
insert into t_interval (date_id) values ('19-NOV-2013');
select * from user_tab_partitions where table_name = 'T_INTERVAL';

--3.	Создайте таблицу T_HASH c хэш-секционированием. 
--Используйте ключ секционирования типа VARCHAR2
create table t_hash
(
  id int generated always as identity primary key,
  str nvarchar2(30)
)
partition by hash (str)
(
  partition part_1 tablespace ts_sharp_1,
  partition part_2 tablespace ts_sharp_2,
  partition part_3 tablespace ts_sharp_3,
  partition part_4 tablespace TS_SHARP_4
);

insert into t_hash (str) values ('str 1');
insert into t_hash (str) values ('str 2');
insert into t_hash (str) values ('str 3');
insert into t_hash (str) values ('str 4');
insert into t_hash (str) values ('str 5');
insert into t_hash (str) values ('str 6');

select * from t_hash partition (part_1);
select * from t_hash partition (part_2);
select * from t_hash partition (part_3);
select * from t_hash partition (part_4);
.
--4.	Создайте таблицу T_LIST со списочным секционированием. 
--Используйте ключ секционирования типа CHAR.
create table t_list
(
  id int generated always as identity primary key,
  str nchar(30)
)
partition by list (str)
(
  partition part_1 values ('aaa', 'bbb', 'ccc', 'fff') tablespace TS_SHARP_1,
  partition part_2 values ('ggg', 'hhh', 'iii', 'lll') tablespace TS_SHARP_2,
  partition part_3 values ('mmm', 'nnn', 'ooo', 'qqq') tablespace TS_SHARP_3,
  partition part_default values (default) tablespace ts_sharp_4
);

insert into t_list (str) values ('aaa');
insert into t_list (str) values ('ggg');
insert into t_list (str) values ('mmm');
insert into t_list (str) values ('str');

select * from t_list partition (part_1);
select * from t_list partition (part_2);
select * from t_list partition (part_3);
select * from t_list partition (part_default);

--5.	Введите с помощью операторов INSERT данные в таблицы T_RANGE, T_INTERVAL, T_HASH, T_LIST. 
--Данные должны быть такими, чтобы они разместились по всем секциям. 
--Продемонстрируйте это с помощью SELECT запроса. 
--6.	Продемонстрируйте для всех таблиц процесс перемещения строк между секциями, 
--при изменении (оператор UPDATE) ключа секционирования.
alter table t_range enable row movement;
update t_range set num = 50 where num = 8;
select * from t_range partition (nums_less_10);
select * from t_range partition (nums_max);
--7.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE MERGE.
alter table t_list merge partitions part_1, part_2
  into partition part_12;
select * from t_list partition(part_12);
--8.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE SPLIT.
alter table t_range split partition nums_less_10 into
(
  partition nums_less_5 values less than (5) tablespace TS_SHARP_1,
  partition nums_less_10 tablespace TS_SHARP_1
);
select * from t_range partition (nums_less_5);
select * from t_range partition (nums_less_10);
--9.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE EXCHANGE.
create table t_range_2
(
  str nvarchar2(20) primary key,
  num int
);

insert into t_range_2 values ('2_str_0', 100);
insert into t_range_2 values ('2_str_1', 101);
insert into t_range_2 values ('2_str_2', 102);
insert into t_range_2 values ('2_str_3', 103);
insert into t_range_2 values ('2_str_4', 104);

alter table t_range exchange partition nums_less_30
  with table t_range_2 without validation;

select * from t_range partition (nums_less_30);
select * from t_range_2;


