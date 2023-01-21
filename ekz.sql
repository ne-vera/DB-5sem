--список продавцов, отсортировать по убыванию общей стоимости заказа. 
--параметры - дата начала периода, конец периода.
create or replace procedure peroid_salesreps(start_date varchar, end_date varchar)
is
cursor curs_periods_reps
is
select orders.rep, sum(orders.amount) as sum0 from orders where orders.order_date between to_date(start_date, 'yyyy-mm-dd') and to_date(end_date, 'yyyy-mm-dd')
group by orders.rep order by sum(orders.amount) desc;
begin
for row_c in curs_periods_reps loop
  sys.dbms_output.put_line(row_c.rep||' '||row_c.sum0);
end loop;
EXCEPTION
 when others 
  then sys.dbms_output.put_line('code error: ' || sqlcode || 'msg oracle: ' || sqlerrm);
end;

begin
 peroid_salesreps('2007-12-17', '2008-02-10');
end;

--список заказов определённого заказчика, где стоимость заказа выше определённого значения. 
--Параметры: имя заказчика и само значение
create or replace procedure salesreps_sales(rep_name varchar, am number)
is
cursor curs_salesreps_sales
is
select * from orders
join salesreps on salesreps.empl_num = orders.rep
where salesreps.name = rep_name
and orders.amount > am;
begin
for row_c in curs_salesreps_sales loop
sys.dbms_output.put_line(row_c.name || ' '||row_c.cust|| ' '||row_c.product || ' '|| row_c.amount);
end loop;
exception
when others
  then sys.dbms_output.put_line('code error: ' || sqlcode || 'msg oracle: ' || sqlerrm);
end;

execute  salesreps_sales('Sam Clark', 10000);

--процедуру, которая выводит стоимость заказов у определенного продавца в порядке убывания.
--Параметр -- продавец. Обработать ошибки
create or replace procedure salesreps_amount(rep_num number)
is
cursor curs_salesreps_amount
is
select * from orders where orders.rep = rep_num
order by orders.amount desc;
begin
for row_c in curs_salesreps_amount loop
SYS.dbms_output.put_line(row_c.rep || ' ' || row_c.amount);
end loop;
exception
when others
then SYS.dbms_output.put_line('code error: ' || sqlcode || 'msq oracle: ' || sqlerrm);
end;

execute salesreps_amount(105);

--Процедура, увеличивающая цену товара на n процентов
create or replace procedure increase(n number, pr_id products.mfr_id%type, des products.description%type)
is
old_price products.price%type;
new_price products.price%type;
begin
select products.price into old_price from products where products.mfr_id = pr_id and products.description = des;
new_price := old_price * (100+n) / 100;
update products set price = new_price where products.mfr_id = pr_id and products.description = des;
SYS.DBMS_OUTPUT.PUT_LINE('Old price: ' || old_price || ', new price: ' || new_price);
EXCEPTION
 WHEN OTHERS
  then sys.dbms_output.put_line('ERROR SQLCODE: ' || sqlcode ||', SQLERRM: '|| sqlerrm);
end;

execute increase(10,'BIC','Plate');

--Создать функцию, которая выводит количество заказов в определённый период времени. 
--Параметры - производитель, дата начала периода, дата окончания периода. Обработать возможные ошибки
create function orders_amount(mfr_id orders.mfr%type, start_date varchar, end_date varchar)
return number
as sum_amount number;
begin 
select count(*) into sum_amount from orders where orders.mfr = mfr_id and
orders.order_date between to_date(start_date, 'yyyy-mm-dd') and to_date(end_date, 'yyyy-mm-dd');
return sum_amount;
exception
when no_data_found
then dbms_output.put_line('no data found');
when not_logged_on
then dbms_output.put_line('not logged on');
when timeout_on_resource
then dbms_output.put_line('timeout on resource');
when others
then dbms_output.put_line('code error: '|| sqlcode || ' ' || 'msg: ' || sqlerrm);
end;

begin
  SYS.DBMS_OUTPUT.PUT_LINE(orders_amount('REI', '2007-12-17', '2008-02-10'));
end;

select * from orders;

--Параметр стоимость заказа. Написать процедуру, которая удаляет заказы, стоимость которых меньше заданной в параметре,
--а все оставшиеся выводит списком. Ну и возможные ошибки обработать.
create or replace procedure del_lower(criteria number)
is
cursor curs_del_lower is
select * from orders order by amount;
begin
delete from orders where orders.amount < criteria;
for row_c in  curs_del_lower loop
SYS.DBMS_OUTPUT.PUT_LINE(row_c.order_num || ' ' || row_c.amount);
end loop;
end;

execute del_lower(650);

--процедура выводит n самых молодых сотрудyников офиса
--параметр код офиса
create or replace procedure youngest_reps(n number, office_num number)
is
cursor curs_youngest_reps
is
select * from (select * from salesreps join offices 
on offices.office = salesreps.rep_office
where offices.office = office_num
order by salesreps.age)
where rownum < ( n + 1);
begin
for row_c in curs_youngest_reps loop
sys.dbms_output.put_line(row_c.name || ' ' || row_c.age || ' ' || row_c.office);
end loop;
end;

execute youngest_reps(2, 12);

--функция, подсчитывает кол-во продавцов определенного товара
--параметры - наименование, производитель
create or replace function sum_reps(mfr_id varchar, pr_id varchar)
return number
as amount_reps number;
begin
select distinct count(rep) into amount_reps from orders where orders.mfr = mfr_id and orders.product = pr_id;
return amount_reps;
end;

begin
dbms_output.put_line(sum_reps('REI', '2A45C'));
end;

--процедура, которая удаляет продавцов, стоимость заказов которых меньше определенного значения
--вывести список оставшихся
create or replace procedure del_reps(criteria number)
is
cursor curs_reps
is select * from orders order by amount;
cursor curs_del is select orders.rep from orders where orders.amount < criteria;
current_rep curs_del%rowtype;
begin
  open curs_del;
  fetch curs_del into current_rep;
  while curs_del%found loop
    delete from orders where rep = current_rep.rep;
    delete from salesreps where empl_num = current_rep.rep;
    fetch curs_del into current_rep;
  end loop;
  for row_c in curs_reps loop
  dbms_output.put_line(row_c.rep || ' ' || row_c.amount);
  end loop;
end;

execute del_reps(700);