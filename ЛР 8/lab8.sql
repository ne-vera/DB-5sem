--1.	Найдите на компьютере конфигурационные файлы SQLNET.ORA и TNSNAMES.ORA 
--и ознакомьтесь с их содержимым
--C:\app\ora_install_user\product\12.1.0\dbhome_2\NETWORK\ADMIN

--2. перечень параметров экземпляра Oracle
show parameter instance;

--3.Соединитесь при помощи sqlplus с подключаемой базой данных как пользователь SYSTEM, 
-- connect system/qwerty/localhost:1521/PVV_PDB.be.by
--получите список табличных пространств, 
select tablespace_name from dba_tablespace;
--файлов табличных пространств,
select file_name, tablespace_name from dba_data_files;
--ролей 
select role from dba_roles;
--и пользователей
select username from dba_users;

--4.	Ознакомьтесь с параметрами в HKEY_LOCAL_MACHINE/SOFTWARE/ORACLE на вашем компьютере.
--regedit

--6.	Подключитесь с помощью sqlplus под собственным пользователем и с применением подготовленной строки подключения
--connect system/qwerty@system_pvv_pdb

--7.	Выполните select к любой таблице, которой владеет ваш пользователь. 
select * from net_tbl;

--8.	Ознакомьтесь с командой HELP.Получите справку по команде TIMING. 
help
help timing
--Подсчитайте, сколько времени длится select к любой таблице.
timing start
select * from net_tbl;
timing stop;

--9.	Ознакомьтесь с командой DESCRIBE.
help describe
--Получите описание столбцов любой таблицы
describe net_tbl

--10.	Получите перечень всех сегментов, владельцем которых является ваш пользователь
select * from user_segmets;

--11.	Создайте представление, в котором получите количество всех сегментов, 
--количество экстентов, 
--блоков памяти 
--и размер в килобайтах, которые они занимают.
create or replace view Lab08 as
select count(*) as count,
    sum(extents) as sum_extents,
    sum(blocks) as sum_blocks,
    sum(bytes) as Kb from user_segments;
    
select * from Lab08;