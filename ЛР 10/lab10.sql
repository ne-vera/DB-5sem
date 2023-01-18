--1.	Разработайте простейший анонимный блок PL/SQL (АБ), не содержащий операторов.
begin
  null;
end;
--2.	Разработайте АБ, выводящий «Hello World!». Выполните его в SQLDev и SQL+.
declare 
  x char(15) := 'Hello world!';
begin
  dbms_output.put_line(x);
end;
--3.	Продемонстрируйте работу исключения и встроенных функций sqlerrm, sqlcode.
declare 
    z number (10, 2);
begin 
    z := 5 / 0;
    dbms_output.put_line('no');
EXCEPTION
    when OTHERS
    then dbms_output.put_line('code = ' || sqlcode|| chr(10) || 'error = ' || sqlerrm);
end;
--4.	Разработайте вложенный блок. Продемонстрируйте принцип обработки исключений во вложенных блоках.
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
--5.	Выясните, какие типы предупреждения компилятора поддерживаются в данный момент.
show parameter plsql_warnings;
select name, value from v$parameter where name = 'plsql_warnings';
--6.	Разработайте скрипт, позволяющий просмотреть все спецсимволы PL/SQL.
select keyword from v$reserved_words where length = 1 and keyword != 'A';
--7.	Разработайте скрипт, позволяющий просмотреть все ключевые слова  PL/SQL.
select keyword from v$reserved_words where length > 1 and keyword!='A' order by keyword;
--8.	Разработайте скрипт, позволяющий просмотреть все параметры Oracle Server, связанные с PL/SQL. Просмотрите эти же параметры с помощью SQL+-команды show.
select name,value from v$parameter where name like 'plsql%';
show parameter plsql;
--9.	Разработайте анонимный блок, демонстрирующий (выводящий в выходной серверный поток результаты):
--10.	объявление и инициализацию целых number-переменных;
--11.	арифметические действия над двумя целыми number-переменных, включая деление с остатком;
--12.	объявление и инициализацию number-переменных с фиксированной точкой;
--13.	объявление и инициализацию number-переменных с фиксированной точкой и отрицательным масштабом (округление);
--14.	объявление и инициализацию BINARY_FLOAT-переменной;
--15.	объявление и инициализацию BINARY_DOUBLE-переменной;
--16.	объявление number-переменных с точкой и применением символа E (степень 10) при инициализации/присвоении;
--17.	объявление и инициализацию BOOLEAN-переменных. 
--18.	Разработайте анонимный блок PL/SQL содержащий объявление констант (VARCHAR2, CHAR, NUMBER). Продемонстрируйте  возможные операции константами.  
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
--19.	Разработайте АБ, содержащий объявления с опцией %TYPE. Продемонстрируйте действие опции.
--20.	Разработайте АБ, содержащий объявления с опцией %ROWTYPE. Продемонстрируйте действие опции.
--21.	Разработайте АБ, демонстрирующий все возможные конструкции оператора IF .
--22.	Разработайте АБ, демонстрирующий все возможные конструкции оператора IF .
--23.	Разработайте АБ, демонстрирующий работу оператора CASE.
--24.	Разработайте АБ, демонстрирующий работу оператора LOOP.
--25.	Разработайте АБ, демонстрирующий работу оператора WHILE.
--26.	разработайте аб, демонстрирующий работу оператора for.
