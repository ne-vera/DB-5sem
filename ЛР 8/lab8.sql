--1.	������� �� ���������� ���������������� ����� SQLNET.ORA � TNSNAMES.ORA 
--� ������������ � �� ����������
--C:\app\ora_install_user\product\12.1.0\dbhome_2\NETWORK\ADMIN

--2. �������� ���������� ���������� Oracle
show parameter instance;

--3.����������� ��� ������ sqlplus � ������������ ����� ������ ��� ������������ SYSTEM, 
-- connect system/qwerty/localhost:1521/PVV_PDB.be.by
--�������� ������ ��������� �����������, 
select tablespace_name from dba_tablespace;
--������ ��������� �����������,
select file_name, tablespace_name from dba_data_files;
--����� 
select role from dba_roles;
--� �������������
select username from dba_users;

--4.	������������ � ����������� � HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE �� ����� ����������.
--regedit

--6.	������������ � ������� sqlplus ��� ����������� ������������� � � ����������� �������������� ������ �����������
--connect system/qwerty@system_pvv_pdb

--7.	��������� select � ����� �������, ������� ������� ��� ������������. 
select * from net_tbl;

--8.	������������ � �������� HELP.�������� ������� �� ������� TIMING. 
help
help timing
--�����������, ������� ������� ������ select � ����� �������.
timing start
select * from net_tbl;
timing stop;

--9.	������������ � �������� DESCRIBE.
help describe
--�������� �������� �������� ����� �������
describe net_tbl

--10.	�������� �������� ���� ���������, ���������� ������� �������� ��� ������������
select * from user_segmets;

--11.	�������� �������������, � ������� �������� ���������� ���� ���������, 
--���������� ���������, 
--������ ������ 
--� ������ � ����������, ������� ��� ��������.
create or replace view Lab08 as
select count(*) as count,
    sum(extents) as sum_extents,
    sum(blocks) as sum_blocks,
    sum(bytes) as Kb from user_segments;
    
select * from Lab08;