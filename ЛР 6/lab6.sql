--1.	Определите общий размер области SGA.
select sum(value) from v$sga;
--2.	Определите текущие размеры основных пулов SGA.
select * from v$sga;
--3.	Определите размеры гранулы для каждого пула.
select component, granule_size from v$sga_dynamic_components;
--4.	Определите объем доступной свободной памяти в SGA.
select current_size from v$sga_dynamic_free_memory;
--5.	Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша
select component, min_size, current_size, max_size from v$sga_dynamic_components where component like '%buffer cache%';
--6.	Создайте таблицу, которая будут помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.
create table keeptbl (k int) storage(buffer_pool keep) tablespace users;
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where segment_name='KEEPTBL';
--7.	Создайте таблицу, которая будут кэшироваться в пуле default. Продемонстрируйте сегмент таблицы. 
create table deftbl (k int) storage(buffer_pool default) tablespace users;
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where segment_name='DEFTBL';
--8.	Найдите размер буфера журналов повтора.
show parameter log_buffer;
--9.	Найдите 10 самых больших объектов в разделяемом пуле.
select * from (select name, bytes from v$sgastat where pool = 'shared pool' order by bytes) where rownum <= 10;
--10.	Найдите размер свободной памяти в большом пуле.
select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';
--11.	Получите перечень текущих соединений с инстансом. 
select username, service_namer from v$session where username is not null;
--12.	Определите режимы текущих соединений с инстансом (dedicated, shared).
select username, service_name, server from v$session where username is not null;
--13.	*Найдите самые часто используемые объекты в базе данных.
select name,type,executions from v$db_object_cache order by executions desc ;