create or replace procedure reduce(percent_n number, pr_id products.mfr_id%TYPE, name_product products.description%TYPE) is
old_price products.price%type;
new_price products.price%type;
begin
  select price into old_price from products
                where products.mfr_id = pr_id and
                      products.description = name_product;
  new_price:= (100 - percent_n) * old_price / 100;
  update products set products.price = new_price 
  where products.mfr_id = pr_id and
        products.description = name_product;
  sys.dbms_output.put_line('Old price: ' || old_price || ', new price: ' || new_price);
  exception
  when others
    then sys.dbms_output.put_line('ERROR SQLCODE: ' || sqlcode ||', SQLERRM: '|| sqlerrm);
end;

select * from products;

execute reduce(10, 'REI', 'Ratchet Link');

create or replace function max_order(p_office_name varchar2, p_year number)
return number
is
max_sum number := 0 ;
begin
select max(amount) into max_sum 
        from orders where rep in 
          ( select empl_num from salesreps where rep_office in (
              select office from offices where city = p_office_name)) 
        and to_char(order_date, 'YYYY') = p_year;
return max_sum;
exception
 when others
  then sys.dbms_output.put_line('ERROR SQLCODE: ' || sqlcode ||', SQLERRM: '     || sqlerrm);
end;

select * from offices;
select * from orders;

begin
  sys.dbms_output.put_line(max_order('Los Angeles', 2008));
end;



