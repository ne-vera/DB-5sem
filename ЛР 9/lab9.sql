select * from user_tables;
--1.	���������� ������� ��������� � ������� ������ ������������ ����������� �����.
grant create sequence to PVVCORE;
grant create table to PVVCORE;
grant create cluster to PVVCORE;
grant create synonym to pvvcore;
grant create public synonym to pvvcore;
grant create materialized view to PVVCORE;
--2.	�������� ������������������ S1 (SEQUENCE), �� ���������� ����������������: 
--��������� �������� 1000; 
--���������� 10; 
--��� ������������ ��������;
--��� ������������� ��������; 
--�� �����������; 
--�������� �� ���������� � ������; 
--���������� �������� �� �������������.
create sequence S1
  start with 1000
  increment by 10
  nominvalue
  nomaxvalue
  nocycle
  nocache
  noorder;
--�������� ��������� �������� ������������������. 
select S1.nextval from dual;
--�������� ������� �������� ������������������.
select S1.currval from dual;
--3.	�������� ������������������ S2 (SEQUENCE), �� ���������� ����������������: 
--��������� �������� 10; 
--���������� 10; 
--������������ �������� 100; 
--�� �����������. 
create sequence S2
  start with 10
  increment by 10
  maxvalue 100
  nocycle;
--�������� ��� �������� ������������������. 
select S2.nextval from dual;
select S2.currval from dual;
--����������� �������� ��������, ��������� �� ������������ ��������.
--5.	�������� ������������������ S3 (SEQUENCE), �� ���������� ����������������: 
--��������� �������� 10; 
--���������� -10; 
--����������� �������� -100; 
--�� �����������; 
--������������� ���������� ��������. 
--�������� ��� �������� ������������������. 
--����������� �������� ��������, ������ ������������ ��������.
create sequence S3
  start with 10
  increment by -10
  maxvalue 11 --SQL Error: ORA-04008: START WITH cannot be more than MAXVALUE
  minvalue -100
  nocycle
  order;
--�������� ��� �������� ������������������. 
select S3.nextval from dual;
select S3.currval from dual;
--����������� �������� ��������, ������ ������������ ��������.
--6.	�������� ������������������ S4 (SEQUENCE), �� ���������� ����������������: 
--��������� �������� 1; 
--���������� 1; 
--����������� �������� 10; 
--�����������; 
--���������� � ������ 5 ��������; 
--���������� �������� �� �������������. 
create sequence S4
  start with 1
  increment by 1
  --minvalue 10 --SQL Error: ORA-04015: ascending sequences that CYCLE must specify MAXVALUE
  maxvalue 10
  cycle
  cache 5
  noorder;
--����������������� ����������� ��������� �������� ������������������� S4.
select S4.nextval from dual;
select S4.currval from dual;
--7.	�������� ������ ���� ������������������� � ������� ���� ������, ���������� ������� �������� ������������ XXX.
select * from user_sequences;
--8.	�������� ������� T1, 
--������� ������� N1, N2, N3, N4, 
--���� NUMBER (20), 
--���������� 
--� ������������� � �������� ���� KEEP.
create table T1 (
        N1 NUMBER(20),
        N2 NUMBER(20),
        N3 NUMBER(20),
        N4 NUMBER(20)) cache storage(buffer_pool keep);
--� ������� ��������� INSERT �������� 7 �����, 
--�������� �������� ��� �������� ������ ������������� � ������� ������������������� S1, S2, S3, S4.
begin
  for i in 1..7 loop
  insert into T1(N1, N2, N3, N4) values (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
  end loop;
end;
select * from t1;
--9.	�������� ������� ABC, ������� hash-��� (������ 200) � ���������� 2 ����: X (NUMBER (10)), V (VARCHAR2(12)).
create cluster abc ( 
                    x number (10), 
                    v varchar2(12)) 
        hashkeys 200;
--10.	�������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table A(XA number(10),
               VA varchar2(12), 
               aa number(10))
cluster ABC (XA, VA);
--11.	�������� ������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.
create table B(xb number(10),
               VB varchar2(12), 
               bb number(10))
cluster ABC (XB, VB);
--12.	�������� ������� �, ������� ������� X� (NUMBER (10)) � V� (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������. 
create table c(XC number(10),
               VC varchar2(12), 
               cc number(10))
cluster ABC (XC, VC);
--13.	������� ��������� ������� � ������� � �������������� ������� Oracle.
select * from user_tables;
select * from user_clusters;
--14.	�������� ������� ������� ��� ������� XXX.� � ����������������� ��� ����������.
create synonym sc for pvvcore.c;
select * from sc;
select * from user_synonyms;
--15.	�������� ��������� ������� ��� ������� XXX.B � ����������������� ��� ����������.
create public synonym sb for pvvcore.b;
select * from sb;

--16.	�������� ��� ������������ ������� A � B (� ��������� � ������� �������), ��������� �� �������, �������� ������������� V1, ���������� �� SELECT... FOR A inner join B. ����������������� ��� �����������������.
create table A1(x number(10), y varchar(12),constraint x_pk primary key (x));
create table B1(x number(10),y varchar(12), constraint x_fk foreign key (x) references A1(x));

insert into A1 (x, y) values (1,'a');
insert into A1 (x, y) values (2,'b');
insert into A1 (x, y) values (3,'c');
insert into B1 (x, y) values (1,'d');
insert into B1 (x, y) values (2,'e');
insert into B1 (x, y) values (3,'f');

select * from a1;
select * from b1;

create view V1 as select A1.y as ay, B1.y as byf, A1.x from A1 inner join B1 on A1.x=B1.x;
select * from V1;
--17.	�� ������ ������ A � B �������� ����������������� ������������� MV, ������� ����� ������������� ���������� 2 ������. ����������������� ��� �����������������.
create materialized view MV
build immediate 
refresh complete on demand next sysdate + numtodsinterval(2, 'minute') 
as select * from A1;

select * from MV;    

insert into a1 (x, y) values (4,'aa');
insert into A1 (x, y) values (5,'bb');
commit;