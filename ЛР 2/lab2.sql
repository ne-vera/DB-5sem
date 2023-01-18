--Создайте табличное пространство для постоянных данных
create tablespace TS_PVV
datafile 'C:\labs_bd\lab 2\TS_PVV.dbf'
size 7m
autoextend on next 5m
maxsize 20m
extent management local;

--drop tablespace TS_PVV_TEMP including contents and datafiles;

--Создайте табличное пространство для временных данных 
create temporary tablespace TS_PVV_TEMP
tempfile 'C:\labs_bd\lab 2\TS_PVV_TEMP.dbf'
size 5m
autoextend on next 3m
maxsize 30m
extent management local;

--Получите список всех табличных пространств, 
--списки всех файлов с помощью select-запроса к словарю.
select tablespace_name, status, contents logging from SYS.dba_tablespaces;

alter session set "_ORACLE_SCRIPT"=true;
--Создайте роль с именем RL_XXXCORE
create role RL_PVVCORE;
--разрешение на соединение с сервером;
grant create session to RL_PVVCORE;
--разрешение создавать и удалять таблицы, 
grant create table to RL_PVVCORE;
--представления,
grant create view to RL_PVVCORE;
-- процедуры и функции.
grant create procedure to RL_PVVCORE;
--Найдите с помощью select-запроса роль в словаре. 
select * from dba_roles where role like '%RL_PVVCORE';
--Найдите с помощью select-запроса все системные привилегии, назначенные роли. 
select * from dba_sys_privs where grantee = 'RL_PVVCORE';

--Создайте профиль безопасности с именем PF_XXXCORE
create profile PF_PVVCORE limit
  password_life_time 180
  sessions_per_user 3
  failed_login_attempts 7
  password_lock_time 1
  password_reuse_time 10
  password_grace_time default
  connect_time 180
  idle_time 30;
  
--Получите список всех профилей БД
select * from dba_profiles;
--Получите значения всех параметров профиля PF_XXXCORE.
select * from dba_profiles where profile = 'PF_PVVCORE';
--Получите значения всех параметров профиля DEFAULT.
select * from dba_profiles where profile = 'DEFAULT';

--Создайте пользователя с именем XXXCORE 
create user PVVCORE identified by 12345
default tablespace TS_PVV quota unlimited on TS_PVV
temporary tablespace TS_PVV_TEMP
profile PF_PVVCORE
account unlock
password expire;

grant RL_PVVCORE to PVVCORE;

--Соединитесь с сервером Oracle с помощью sqlplus и введите новый пароль для пользователя XXXCORE.  
--Создайте любую таблицу и любое представление
create table PVV_T1(num int, name varchar2(20));
create view T1_ALL as select * from PVV_T1;

--Создайте табличное пространство с именем XXX_QDATA (10m). 
create tablespace PVV_QDATA
datafile 'C:\labs_bd\lab 2\PVV_QDATA.dbf'
size 10m
autoextend on next 5m
maxsize 20m
extent management local;

--При создании установите его в состояние offline
alter tablespace PVV_QDATA offline;

--Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA
alter user PVVCORE quota 2m on PVV_QDATA;

--От имени пользователя XXX создайте таблицу в пространстве XXX_T1
create table PVVCORE_T2(num int, teacher varchar2(40)) tablespace PVV_QDATA;

--В таблицу добавьте 3 строки.
alter tablespace PVV_QDATA online;
insert into PVVCORE_T2 values (1, 'Teacher1');
insert into PVVCORE_T2 values (2, 'Teacher2');
insert into PVVCORE_T2 values (3, 'Teacher3');
