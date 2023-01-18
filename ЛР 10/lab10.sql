--1.	������������ ���������� ��������� ���� PL/SQL (��), �� ���������� ����������.
begin
  null;
end;
--2.	������������ ��, ��������� �Hello World!�. ��������� ��� � SQLDev � SQL+.
declare 
  x char(15) := 'Hello world!';
begin
  dbms_output.put_line(x);
end;
--3.	����������������� ������ ���������� � ���������� ������� sqlerrm, sqlcode.
declare 
    z number (10, 2);
begin 
    z := 5 / 0;
    dbms_output.put_line('no');
EXCEPTION
    when OTHERS
    then dbms_output.put_line('code = ' || sqlcode|| chr(10) || 'error = ' || sqlerrm);
end;
--4.	������������ ��������� ����. ����������������� ������� ��������� ���������� �� ��������� ������.
declare
    z number(10 , 2) := 3;
begin
    begin
        z := 5 / 0;
    exception
        when others
        then dbms_output.put_line('code = ' || sqlcode|| chr(10) || 'error = ' || sqlerrm);
    end;
    dbms_output.put_line('z = '||z);
end;
--5.	��������, ����� ���� �������������� ����������� �������������� � ������ ������.
show parameter plsql_warnings;
select name, value from v$parameter where name = 'plsql_warnings';
--6.	������������ ������, ����������� ����������� ��� ����������� PL/SQL.
select keyword from v$reserved_words where length = 1 and keyword != 'A';
--7.	������������ ������, ����������� ����������� ��� �������� �����  PL/SQL.
select keyword from v$reserved_words where length > 1 and keyword!='A' order by keyword;
--8.	������������ ������, ����������� ����������� ��� ��������� Oracle Server, ��������� � PL/SQL. ����������� ��� �� ��������� � ������� SQL+-������� show.
select name,value from v$parameter where name like 'plsql%';
show parameter plsql;
--9.	������������ ��������� ����, ��������������� (��������� � �������� ��������� ����� ����������):
--10.	���������� � ������������� ����� number-����������;
--11.	�������������� �������� ��� ����� ������ number-����������, ������� ������� � ��������;
--12.	���������� � ������������� number-���������� � ������������� ������;
--13.	���������� � ������������� number-���������� � ������������� ������ � ������������� ��������� (����������);
--14.	���������� � ������������� BINARY_FLOAT-����������;
--15.	���������� � ������������� BINARY_DOUBLE-����������;
--16.	���������� number-���������� � ������ � ����������� ������� E (������� 10) ��� �������������/����������;
--17.	���������� � ������������� BOOLEAN-����������. 
--18.	������������ ��������� ���� PL/SQL ���������� ���������� �������� (VARCHAR2, CHAR, NUMBER). �����������������  ��������� �������� �����������.  
declare
  a1 number(5);
  a2 number(5) := 10;
  b1 number (5,3);
  b2 number (5,3) := 10.333;
  c1 number (5, 2);
  c2 number (5, 2) := 99.90909;
  bf binary_float := .95f;
  bd binary_double := .95d;
  ne number(15,10) := 12345E-10;
  boo boolean := true;
begin
   dbms_output.put_line('-------- 10--------');
    dbms_output.put_line('a1 = '||a1);
    dbms_output.put_line('a2 = '||a2);
    dbms_output.put_line('-------- 11 --------');
    dbms_output.put_line('sum : a2 + 6 = '||(a2+6));
    dbms_output.put_line('reminder division : 5 / 6 = '||(a2/6));
    dbms_output.put_line('reminder : 5 / 6 = '|| mod(a2,6));
    dbms_output.put_line('-------- 12 --------');
    dbms_output.put_line('b2 = '||b2);
    dbms_output.put_line('-------- 13 --------');
    dbms_output.put_line('c2 = '||c2);
    dbms_output.put_line('-------- 14 --------');
    dbms_output.put_line('bf = '||bf);
    dbms_output.put_line('-------- 15 --------');
    dbms_output.put_line('bd = '||bd);
    dbms_output.put_line('-------- 16 --------');
    dbms_output.put_line('ne = '||ne);
    dbms_output.put_line('-------- 17 --------');
     dbms_output.put_line('boo = '||(case boo when true then 'true' else 'false' end));
end;
--19.	������������ ��, ���������� ���������� � ������ %TYPE. ����������������� �������� �����.
--20.	������������ ��, ���������� ���������� � ������ %ROWTYPE. ����������������� �������� �����.
--21.	������������ ��, ��������������� ��� ��������� ����������� ��������� IF .
--22.	������������ ��, ��������������� ��� ��������� ����������� ��������� IF .
--23.	������������ ��, ��������������� ������ ��������� CASE.
--24.	������������ ��, ��������������� ������ ��������� LOOP.
--25.	������������ ��, ��������������� ������ ��������� WHILE.
--26.	������������ ��, ��������������� ������ ��������� for.
