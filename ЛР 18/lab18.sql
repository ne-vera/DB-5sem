--1.	�������� ��������� ����, ���������� ������ ��� ������� (20 �����, ���������� �����, ������ � ����). 
--2.	��������� ������, ��������������� �������� ������, �� ����� ����� � ���� ������ ��� ������ SQL*Loader.
--3.	������ ������ ���� ��������� � ���� ���� ����� ���������, ����� ��������� �� �����.
--4.	��������� ���������� ������ select-������� �� ������� ���� ����� ��������.
drop table lab18;
create table lab18(
  id number(10) primary key, 
  text varchar2(20), 
  date_value date check (extract(month from date_value)= 12)
);

delete from lab18;
select * from lab18;
commit;

-- sqlldr userid=PVVCORE/qwerty control=control.ctl