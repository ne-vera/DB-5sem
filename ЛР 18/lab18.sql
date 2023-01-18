--1.	Создайте текстовый файл, содержащий данные для импорта (20 строк, содержащий числа, строки и даты). 
--2.	Загрузите данные, соответствующие текущему месяцу, из этого файла в базу данных при помощи SQL*Loader.
--3.	Строки должны быть приведены к виду «Все буквы заглавные», числа округлены до сотых.
--4.	выгрузить результаты любого select-запроса во внешний файл любым способом.
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