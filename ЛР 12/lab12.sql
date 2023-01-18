--1. �������� � ������� TEACHERS ��� ������� BIRTHDAY� SALARY, ��������� �� ����������.
select * from teacher;
alter table teacher add (birthday date, salary int);

update teacher set birthday = to_date('19.01.2000', 'DD.MM.YYYY'),
                    salary = 10
                    where pulpit like 'P%';

update teacher set birthday = to_date('10.01.1000', 'DD.MM.YYYY'),
                    salary = 100000
                    where pulpit like 'IS%';

update teacher set birthday = to_date('11.01.2001', 'DD.MM.YYYY'),
                    salary = 1
                    where pulpit like 'O%';
                    
update teacher set birthday = to_date('11.01.1993', 'DD.MM.YYYY'),
                    salary = 13
                    where pulpit like 'T%';

update teacher set birthday = to_date('11.12.1986', 'DD.MM.YYYY'),
                    salary = 17
                    where salary is null and birthday is null;
commit;
--2. �������� ������ �������������� � ���� ������� �.�.
select * from teacher;
select substr(teacher_name ,1,  regexp_instr(teacher_name, '\s', 1, 1) + 1)||'. '||
      substr(regexp_substr(teacher_name,'\s\S',1, 2),2, 1)||'. ' as teachers, teacher as initials from teacher;
      
--3. �������� ������ ��������������, ���������� � �����������.
select * from teacher where TO_CHAR(birthday, 'd') = 2; --Monday
select * from teacher where to_char(birthday, 'd') = 4; --Wednesday
--4. �������� �������������, � ������� ��������� ������ ��������������, ������� �������� � ��������� ������.

create or replace view nextmonth as 
  select teacher_name, birthday from teacher 
  where to_char(sysdate,'mm')+1 = to_char(birthday, 'mm') 
  or (to_char(sysdate,'mm') = 12 
  and TO_CHAR(birthday, 'mm') = 1);

select * from NextMonth;

--5. 5. �������� �������������, � ������� ��������� ���������� ��������������, ������� �������� � ������ ������.
create or replace view everymonth as 
  select to_char(birthday,'mon') as month, 
          count(*) as count 
  from teacher 
  group by to_char(birthday,'mon');

select * from everymonth;

--6. ������� ������ � ������� ������ ��������������, � ������� � ��������� ���� ������.
cursor anniversary(teacher%rowtype) return teacher%rowtype is
  select * from teacher
  where mod((to_char(sysdate,'yyyy') - to_char(birthday, 'yyyy')+1), 10)=0;
--7. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����, 
--������� ������� �������� �������� ��� ������� ���������� � ��� ���� ����������� � �����.
cursor salary(teacher%rowtype) return salary%type is
  select pulpit, floor(avg(salary)) from teacher
  group by pulpit;

--8. �������� ����������� ��� PL/SQL-������ (record) � ����������������� ������ � ���. 
--����������������� ������ � ���������� ��������. ����������������� � ��������� �������� ����������
declare
    type contacts is record
    ( 
        adress VARCHAR2(50),
        phone number(13)
    );
    type person is record
    (
       name teacher.teacher_name%type,
       pulpit teacher.pulpit%type,
       contact contacts
    );
    rec person;
begin
    rec.name := 'Name Lastanme';
    rec.pulpit := 'FIT';
    rec.contact.adress := 'City Street Block';
    rec.contact.phone := 80291111111;
    dbms_output.put_line('Name: '||rec.name|| chr(10) ||'Pulpit: '|| rec.pulpit || chr(10)|| 'Phone number: '|| rec.contact.phone);
exception
  when others
      then dbms_output.put_line(sqlerrm);
end;
