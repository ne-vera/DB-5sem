
grant 
select * from teacher;

-- 1. Разработайте локальную процедуру 
-- GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
-- Процедура должна выводить список преподавателей из таблицы TEACHER (в стандартный серверный вывод), 
-- работающих на кафедре заданной кодом в параметре. 
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
create or replace procedure GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
is
  cursor pteachers is select * from teacher where pulpit = pcode;
  pteacher pteachers%rowtype;
begin
  open pteachers;
  loop
    fetch pteachers into pteacher;
    exit when pteachers%notfound;
    dbms_output.put_line(pteacher.teacher_name||' '||pteacher.pulpit);
  end loop;
  
  close pteachers;
end;

begin
  get_teachers('ISIT');
end;

--2. Разработайте локальную функцию 
-- GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
-- RETURN NUMBER
-- Функция должна выводить количество преподавателей из таблицы TEACHER, работающих на кафедре заданной кодом в параметре. 
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры.

create or replace function GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER
is
  count_teachers number;
begin
  select count(*) into count_teachers from teacher where pulpit = pcode;
  return count_teachers;
end;

begin
  dbms_output.put_line('count of teachers '||get_num_teachers('ISIT'));
end;
--3. Разработайте процедуры:
-- GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- Процедура должна выводить список преподавателей из таблицы TEACHER (в стандартный серверный вывод), работающих на факультете, заданным кодом в параметре. 
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры.

create or replace procedure GET_TEACHERS_BY_FACULTY (FCODE FACULTY.FACULTY%TYPE)
is
  cursor fteachers is select teacher.teacher_name, teacher.pulpit from teacher
  inner join pulpit on pulpit.pulpit = teacher.pulpit 
  where pulpit.faculty = fcode;
  
  fteacher fteachers%rowtype;
begin
  open fteachers;
  loop
    fetch fteachers into fteacher;
    exit when fteachers%notfound;
    dbms_output.put_line(fteacher.teacher_name||' '||fteacher.pulpit);
  end loop;
  close fteachers;
end;

begin
  get_teachers_by_faculty('PAP');
end;  

-- GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
-- Процедура должна выводить список дисциплин из таблицы SUBJECT, закрепленных за кафедрой, заданной кодом кафедры в параметре. 
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
create or replace procedure GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
is
  cursor sub is select * from subject where pulpit = pcode;
  psubject sub%rowtype;
begin 
  open sub;
  loop
    fetch sub into psubject;
    exit when sub%notfound;
    dbms_output.put_line(psubject.subject_name||' '||psubject.pulpit);
  end loop;
  close sub;
end;

begin
  get_subjects('ISIT');
end;

-- 4. Разработайте локальную функцию 
-- GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- RETURN NUMBER
-- Функция должна выводить количество преподавателей из таблицы TEACHER, работающих на факультете, заданным кодом в параметре.
--  Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
create or replace function GET_NUM_TEACHERS_BY_FAC (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER
is
  count_teachers number;
begin
  select count(*) into count_teachers from teacher
  inner join pulpit on teacher.pulpit = pulpit.pulpit 
  where pulpit.faculty = fcode;
  return count_teachers;
end;

begin
  dbms_output.put_line('count of teachers '||GET_NUM_TEACHERS_BY_FAC('PAP'));
end; 

-- GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
-- RETURN NUMBER 
-- Функция должна выводить количество дисциплин из таблицы SUBJECT, закрепленных за кафедрой, заданной кодом кафедры параметре. 
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры. 
create or replace function GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
is
  count_subjects number;
begin
  select count(*) into count_subjects from subject where subject.pulpit = pcode;
  return count_subjects;
end;

begin
  dbms_output.put_line('count of subjects '||get_num_subjects('PEAIPS'));
end;

--5. Разработайте пакет TEACHERS, содержащий процедуры и функции:
-- GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
-- GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
create or replace package TEACHERS as
  PROCEDURE GET_TEACHERS_BY_FACULTY(FCODE FACULTY.FACULTY%TYPE);
  PROCEDURE GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE);
  FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER;
  FUNCTION GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER;
end TEACHERS;

create or replace package body TEACHERS as

    function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) return number is tcount_number number;
    begin 
        select count(*)into tcount_number from teacher join pulpit on teacher.pulpit = pulpit.pulpit where pulpit.faculty = FCODE;
        return tcount_number;
    end GET_NUM_TEACHERS;
  
    function GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) return number is s_number number;
    begin 
        select count(*) into s_number from subject where subject.pulpit = PCODE;
        return s_number;
    end GET_NUM_SUBJECTS;
          
    procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) is 
    cursor subject_cursor is select subject, pulpit from subject where pulpit = PCODE;
    c_subject subject.subject%type;
    c_pulpit subject.pulpit%type;
    begin 
        open subject_cursor;
        fetch subject_cursor into c_subject, c_pulpit;
        loop
            dbms_output.put_line(' ' || c_subject || ' ---> ' || c_pulpit);
            fetch subject_cursor into c_subject, c_pulpit;
            exit when subject_cursor%notfound;
        end loop;
        close subject_cursor;
    end GET_SUBJECTS;

    procedure GET_TEACHERS_BY_FACULTY (FCODE FACULTY.FACULTY%TYPE) 
    is cursor teacher_cursor 
        is select teacher.teacher_name, pulpit.faculty from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit where pulpit.faculty = FCODE;

    teach_curs teacher.teacher_name%type;
    facult_cursor pulpit.faculty%type;
begin 
    open teacher_cursor;
    fetch teacher_cursor into teach_curs, facult_cursor;
    
    loop 
        dbms_output.put_line(' ' || teach_curs || ' ---> ' || facult_cursor);
        fetch teacher_cursor into teach_curs, facult_cursor;
        exit when teacher_cursor%notfound;
    end loop;
    close teacher_cursor;    
end GET_TEACHERS_BY_FACULTY;

END TEACHERS;
--6. Разработайте анонимный блок и продемонстрируйте выполнение процедур и функций пакета TEACHERS.
begin
  teachers.get_teachers_by_faculty('PAP');
end;