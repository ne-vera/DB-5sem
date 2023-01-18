--1.	Создайте таблицу, имеющую несколько атрибутов, один из которых первичный ключ.
create table lab15 (
    num1 int primary key,
    num2 int,
);

drop table lab15;
FLASHBACK table lab15 TO BEFORE DROP;

--2.	Заполните таблицу строками (10 шт.).
begin
    for k in 0..9
    loop
    insert into lab15 VALUES (k, k*2);
    end loop;
end;

select * from lab15;

--3.	Создайте BEFORE – триггер уровня оператора на события INSERT, DELETE и UPDATE. 
create or replace trigger before_operation_trigger
before insert or update or delete on lab15
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('Insert trigger');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('Delete trigger');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('Update trigger');
    end if;
end;

insert into lab15 values (11, 22);
update lab15 set num2 = 100 where num1 = 11;
delete lab15 where num1 = 11;

--4.	Этот и все последующие триггеры должны выдавать сообщение на серверную консоль (DMS_OUTPUT) со своим собственным именем. 

--5.	Создайте BEFORE-триггер уровня строки на события INSERT, DELETE и UPDATE.
create or replace trigger before_row_trigger
before insert or update or delete on lab15  for each row
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('Insert before_row_trigger');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('Update before_row_trigger');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('Delete before_row_trigger');
    end if;
end;

--6.	Примените предикаты INSERTING, UPDATING и DELETING.
--7.	Разработайте AFTER-триггеры уровня оператора на события INSERT, DELETE и UPDATE.
create or replace trigger after_operator_trigger
after insert or update or delete on lab15
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('Insert after_operator_trigger');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('Update after_operator_trigger');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('Delete after_operator_trigger');
    end if;
end;

--8.	Разработайте AFTER-триггеры уровня строки на события INSERT, DELETE и UPDATE.
create or replace trigger after_row_trigger
after insert or update or delete on lab15  for each row
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('Insert after_row_trigger');
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('Update after_row_trigger');
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('Delete after_row_trigger');
    end if;
end;

--9.	Создайте таблицу с именем AUDIT. Таблица должна содержать поля: 
create table audit(
OperationDate date,
OperationType varchar2(10),
TriggerName varchar2(25),
Data varchar2(50)
);

select * from audits;
drop table audits;

--10.	Измените триггеры таким образом, чтобы они регистрировали все операции с исходной таблицей в таблице AUDIT.
create or replace trigger before_operation_trigger
before insert or update or delete on lab15
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('Insert before_operation_trigger');
    insert into audits values(sysdate, 'Insert', 'before_operation_trigger', concat(lab15.num1, lab15.num2));
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('Update before_operation_trigger');
    insert into audits values(sysdate, 'Update', 'before_operation_trigger', concat(lab15.num1, lab15.num2));
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('Delete before_operation_trigger');
    insert into audits values(sysdate, 'Delete', 'before_operation_trigger', concat(lab15.num1, lab15.num2));
    end if;
end;

create or replace trigger before_row_trigger
before insert or update or delete on lab15 for each row
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('Insert before_row_trigger');
    insert into audits values(sysdate, 'insert', 'before_row_trigger', concat(lab15.num1, lab15.num2));
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('Update before_row_trigger');
    insert into audits values(sysdate, 'update', 'before_row_trigger', concat(lab15.num1, lab15.num2));
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('Delete before_row_trigger');
    insert into audits values(sysdate, 'delete', 'before_row_trigger', concat(lab15.num1, lab15.num2));
    end if;
end;

create or replace trigger after_operator_trigger
after insert or update or delete on lab15
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('Insert after_operator_trigger');
    insert into audits values(sysdate, 'insert', 'after_operator_trigger', concat(lab15.num1, lab15.num2));
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('Update after_operator_trigger');
     insert into audits values(sysdate, 'update', 'after_operator_trigger', concat(lab15.num1, lab15.num2));
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('Delete after_operator_trigger');
    insert into audits values(sysdate, 'delete', 'after_operator_trigger', concat(lab15.num1, lab15.num2));
    end if;
end;

create or replace trigger after_row_trigger
after insert or update or delete on lab15 for each row
begin 
    if inserting then
    DBMS_OUTPUT.PUT_LINE('Insert after_row_trigger');
    insert into audits values(sysdate, 'insert', 'after_row_trigger', concat(lab15.num1, lab15.num2));
    elsif updating then
    DBMS_OUTPUT.PUT_LINE('Update after_row_trigger');
    insert into audits values(sysdate, 'update', 'after_row_trigger', concat(lab15.num1, lab15.num2));
    elsif deleting then
    DBMS_OUTPUT.PUT_LINE('Delete after_row_trigger');
    insert into audits values(sysdate, 'delete', 'after_row_trigger', concat(lab15.num1, lab15.num2));
    end if;
end;


select * from audits;

--11.	Выполните операцию, нарушающую целостность таблицы по первичному ключу. 
insert into lab15 values (11, 22);
update lab15 set num2 = 100 where num1 = 11;
delete lab15 where num1 = 11;

--12.	Удалите (drop) исходную таблицу. Объясните результат. 
drop table lab15;
FLASHBACK table lab15 TO BEFORE DROP;

--Добавьте триггер, запрещающий удаление исходной таблицы.
create or replace trigger enable_drop
before drop on SCHEMA
begin
    if SYS.dictionary_obj_name = 'LAB15'
    then raise_application_error(-20000, 'я вам запрещаю удалять таблицу');
    end if;
end;

--13.	Удалите (drop) таблицу AUDIT. Просмотрите состояние триггеров с помощью SQL-DEVELOPER. 
select * from audits;
drop table audits;
FLASHBACK table audits TO BEFORE DROP;

--14.	Создайте представление над исходной таблицей.
create view lab_view as SELECT * FROM lab15;

--Разработайте INSTEADOF INSERT-триггер. 
--Триггер должен добавлять строку в таблицу.  
CREATE OR REPLACE TRIGGER instead_trigg
instead of insert on lab_view
BEGIN
    if inserting then
        dbms_output.put_line('insert');
        insert into lab15 VALUES (100, 500);
    end if;
END instead_trigg;

insert into lab_view values(12, 12);
delete lab15 where a = 100;
select * from lab_view;
select * from lab15;