--1.	���������� ����� ������ ������� SGA.
select sum(value) from v$sga;
--2.	���������� ������� ������� �������� ����� SGA.
select * from v$sga;
--3.	���������� ������� ������� ��� ������� ����.
select component, granule_size from v$sga_dynamic_components;
--4.	���������� ����� ��������� ��������� ������ � SGA.
select current_size from v$sga_dynamic_free_memory;
--5.	���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����
select component, min_size, current_size, max_size from v$sga_dynamic_components where component like '%buffer cache%';
--6.	�������� �������, ������� ����� ���������� � ��� ���P. ����������������� ������� �������.
create table keeptbl (k int) storage(buffer_pool keep) tablespace users;
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where segment_name='KEEPTBL';
--7.	�������� �������, ������� ����� ������������ � ���� default. ����������������� ������� �������. 
create table deftbl (k int) storage(buffer_pool default) tablespace users;
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where segment_name='DEFTBL';
--8.	������� ������ ������ �������� �������.
show parameter log_buffer;
--9.	������� 10 ����� ������� �������� � ����������� ����.
select * from (select name, bytes from v$sgastat where pool = 'shared pool' order by bytes) where rownum <= 10;
--10.	������� ������ ��������� ������ � ������� ����.
select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';
--11.	�������� �������� ������� ���������� � ���������. 
select username, service_namer from v$session where username is not null;
--12.	���������� ������ ������� ���������� � ��������� (dedicated, shared).
select username, service_name, server from v$session where username is not null;
--13.	*������� ����� ����� ������������ ������� � ���� ������.
select name,type,executions from v$db_object_cache order by executions desc ;