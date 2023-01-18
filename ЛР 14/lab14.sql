alter pluggable database all open;

-- SYSTEM_to_orcl
create table system_table ( num int primary key, str nvarchar2(20) );
insert into system_table values (1, 'str 1');
commit;
select * from system_table;

---------- CREATE ---------- from sys_to_orcl
create database link to_system_orcl
connect to system
identified by qwerty
using 'ORCL';

---------- CHECK ---------- 
select * from dba_db_links;

-- SELECT, INSERT, UPDATE
select * from system_table@to_system_orcl; -- remote_db_table@db_link_name
insert into system_table@to_system_orcl values (2, 'str 2');
update system_table@to_system_orcl set str = 'HELLO' where num = 2;

select * from system_table@to_system_orcl;
delete from system_table@to_system_orcl where num = 2;



---------- CREATE GLOBAL ---------- from sys_to_orcl
create public database link to_system_global_orcl
connect to system
identified by qwerty
using 'ORCL';



---------- SELECT, INSERT, UPDATE ---------- from sys_to_orcl
select * from system_table@to_system_global_orcl;
insert into system_table@to_system_global_orcl values (2, 'str 2');
update system_table@to_system_global_orcl set str = 'HELLO' where num = 2;
select * from system_table@to_system_global_orcl;
delete from system_table@to_system_global_orcl where num = 2;
  

-- alter session close database link anotherdb;

drop database link to_system_orcl;
drop public database link to_system_global_orcl;



