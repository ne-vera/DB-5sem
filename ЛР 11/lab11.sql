--������� �������
--1. ������������ ��, ��������������� ������ ��������� SELECT � ������ ��������. 
declare 
  faculty_rec faculty%rowtype;
begin 
  select * into faculty_rec from faculty where faculty = 'TOV';
  dbms_output.put_line(faculty_rec.faculty ||' '||faculty_rec.faculty_name);
  exception
  when others
    then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;
--2. ������������ ��, ��������������� ������ ��������� SELECT � �������� ������ ��������. ����������� ����������� WHEN OTHERS ������ ���������� � ���������� ������� SQLERRM, SQLCODE ��� ���������������� �������� �������. 
declare 
  faculty_rec faculty%rowtype;
begin 
  select * into faculty_rec from faculty;
  dbms_output.put_line(faculty_rec.faculty ||' '||faculty_rec.faculty_name);
  exception
  when others
    then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;
--3. ������������ ��, ��������������� ������ ����������� WHEN TO_MANY_ROWS ������ ���������� ��� ���������������� �������� �������. 
declare
    faculty_rec faculty%rowtype;
begin
    select * into faculty_rec from faculty;
    dbms_output.put_line(faculty_rec.faculty || '  ' || faculty_rec.faculty_name);
exception
    when too_many_rows
    then dbms_output.put_line('caught: ' || sqlcode || ' ' || sqlerrm );
end;
--4. ������������ ��, ��������������� ������������� � ��������� ���������� NO_DATA_FOUND. ������������ ��, ��������������� ���������� ��������� �������� �������.
declare
    faculty_rec faculty%rowtype;
begin
    select * into faculty_rec from faculty where faculty='FIT';
   dbms_output.put_line(faculty_rec.faculty || '  ' || faculty_rec.faculty_name);
exception
    when no_data_found 
    then dbms_output.put_line('caught: ' || sqlcode || ' ' || sqlerrm );
end;
--5. ������������ ��, ��������������� ���������� ��������� update ��������� � ����������� commit/rollback. 
declare 
    n BOOLEAN :=  true;
    auditorium_rec auditorium%rowtype;
begin
    update auditorium set auditorium = '206-3',
                          auditorium_name = '206-3',
                          auditorium_capacity = 90,
                          auditorium_type = 'LK'
                        where auditorium = '206-1';
    if n then commit;
        else rollback;
    end if;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;

select * from auditorium where auditorium like '206%';
select * from AUDITORIUM_TYPE;
--6. ����������������� �������� UPDATE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
declare 
    auditorium_rec auditorium%rowtype;
begin
    update auditorium set auditorium_capacity = 'anything'
                        where auditorium = '206-1';
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;
--7. ������������ ��, ��������������� ���������� ��������� INSERT ��������� � ����������� COMMIT/ROLLBACK.
declare 
    auditorium_rec auditorium%rowtype;
begin
    insert into auditorium VALUES ('206-4','206-4', 90, 'LK');
    commit;
    insert into auditorium VALUES ('206-6','206-6', 90, 'LK');
    rollback;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;

select * from auditorium where auditorium like '206%';
delete from auditorium where auditorium = '206-4';
--8. ����������������� �������� INSERT, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
declare 
    auditorium_rec auditorium%rowtype;
begin
    insert into auditorium VALUES ('206-4','206-4', 'nan', 'LK');
    commit;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;
--9. ������������ ��, ��������������� ���������� ��������� DELETE ��������� � ����������� COMMIT/ROLLBACK.
select * from auditorium where auditorium like '206%';

declare 
    auditorium_rec auditorium%rowtype;
begin
    delete from auditorium where auditorium = '206-4';
    commit;
    delete from auditorium where auditorium like '206%';
    rollback;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;
--10. ����������������� �������� delete, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
declare 
    auditorium_rec auditorium%rowtype;
begin
    delete from auditorium_type where auditorium_type = 'LB-K';
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;

select * from auditorium_type;


--����� �������
--11. �������� ��������� ����, ��������������� ������� TEACHER � ����������� ������ ������� LOOP-�����. ��������� ������ ������ ���� �������� � ����������, ����������� � ����������� ����� %TYPE.
declare 
    cursor curs_teachers is select *from teacher;
    m_teacher   teacher.teacher%type;
    m_teacher_name   teacher.teacher_name%type;
    m_pulpit   teacher.pulpit%type;
begin
    open curs_teachers;
    dbms_output.put_line('rowcount = ' || curs_teachers%rowcount);
    loop
    fetch curs_teachers into m_teacher, m_teacher_name, m_pulpit;
    exit when curs_teachers%notfound;
    dbms_output.put_line(' ' || curs_teachers%rowcount || ' ' || m_teacher || ' ' || m_teacher_name || 
                        ' ' || m_pulpit);
    end loop;
    dbms_output.put_line('rowcount = ' || curs_teachers%rowcount);
    close curs_teachers;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);    
end;
--12. �������� ��, ��������������� ������� SUBJECT � ����������� ������ ������� �WHILE-�����. ��������� ������ ������ ���� �������� � ������ (RECORD), ����������� � ����������� ����� %ROWTYPE.
declare 
    cursor curs_subject is select* from subject;
    rec_subject subject%rowtype;
begin
    open curs_subject;
    dbms_output.put_line('rowcount = ' || curs_subject%rowcount);
    fetch curs_subject into rec_subject;
    while curs_subject%found
    loop
    dbms_output.put_line(' ' || curs_subject%rowcount || ' ' || rec_subject.subject || ' ' ||
                        rec_subject.subject_name || ' ' || rec_subject.pulpit);
    fetch curs_subject into rec_subject;
    end loop;
    dbms_output.put_line('rowcount = ' || curs_subject%rowcount);
    close curs_subject;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);   
end;
--13. �������� ��, ��������������� ��� ������� (������� PULPIT) � ������� ���� �������������� (TEACHER) �����������, ���������� (JOIN) PULPIT � TEACHER � � ����������� ������ ������� � FOR-�����.
declare
  cursor curs_pulpit is select pulpit.pulpit, teacher.teacher_name
  from pulpit inner join teacher on pulpit.pulpit=teacher.pulpit;
  rec curs_pulpit%rowtype;
begin
    for rec in curs_pulpit
    loop
        dbms_output.put_line(curs_pulpit%rowcount||' '||rec.teacher_name||' '||rec.pulpit);
    end loop;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm); 
end;
--14. �������� ��, ��������������� ��������� ������ ���������: ��� ��������� (������� AUDITORIUM) � ������������ ������ 20, �� 21-30, �� 31-60, �� 61 �� 80, �� 81 � ����. ��������� ������ � ����������� � ��� ������� ����������� ����� �� ������� �������.
declare 
    cursor curs (capacity auditorium.auditorium_capacity%type, capacity1 auditorium.auditorium_capacity%type)
        is select auditorium, auditorium_capacity, auditorium_type
        from auditorium
        where auditorium_capacity >= capacity and auditorium_capacity <= capacity1;
    --aum curs%rowtype;
begin
    dbms_output.put_line('capacity < 20 :');
    for aum in curs(0,20)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
     
    dbms_output.put_line('21 < capacity < 30 :');
    for aum in curs(21,30)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
     
    dbms_output.put_line('31 < capacity < 60 :');
    for aum in curs(31,60)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
     
    dbms_output.put_line('61 < capacity < 80 :');
    for aum in curs(61,80)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
     
    dbms_output.put_line('81 < capacity:');
    for aum in curs(81,1000)
    loop dbms_output.put_line(aum.auditorium||' '); 
    end loop;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);
end;

--16. �������� a�. ����������������� ������� ��������� ���������?
declare 
  cursor curs_aut is select auditorium_type,
      cursor (select auditorium from auditorium aum
          where aut.auditorium_type = aum.auditorium_type)
      from auditorium_type aut;
  curs_aum sys_refcursor;
  aut auditorium_type.auditorium_type%type;
  txt varchar2(1000);
  aum auditorium.auditorium%type;
begin
  open curs_aut;
   fetch curs_aut into aut, curs_aum;
   while(curs_aut%found)
      loop
        txt:=rtrim(aut)||':';
        loop
          fetch curs_aum into aum;
          exit when curs_aum%notfound;
          txt := txt||','||rtrim(aum);
        end loop;
        dbms_output.put_line(txt);
        fetch curs_aut into aut, curs_aum;
      end loop;
  close curs_aut;
  exception
  when others
      then dbms_output.put_line(sqlerrm);
end;
--17. �������� A�. ��������� ����������� ���� ��������� (������� AUDITORIUM) ������������ �� 40 �� 80 �� 10%. ����������� ����� ������ � �����������, ���� FOR, ����������� UPDATE CURRENT OF. 
declare 
  cursor curs_auditorium(capacity auditorium.auditorium%type, capac auditorium.auditorium%type)
    is select auditorium, auditorium_capacity
      from auditorium
      where auditorium_capacity >=capacity and AUDITORIUM_CAPACITY <= capac for update;
  aum auditorium.auditorium%type;
  cty auditorium.auditorium_capacity%type;
begin
  open curs_auditorium(40,80);
  fetch curs_auditorium into aum, cty;
  while(curs_auditorium%found)
    loop
      cty := cty * 0.9;
      update auditorium
      set auditorium_capacity = cty
      where current of curs_auditorium;
      dbms_output.put_line(' '||aum||' '||cty);
      fetch curs_auditorium into aum, cty;
    end loop;
  close curs_auditorium;
  rollback;
  exception
  when others
    then dbms_output.put_line(sqlerrm);
end;

select * from auditorium;
--18. �������� A�. ������� ��� ��������� (������� AUDITORIUM) ������������ �� 0 �� 20. ����������� ����� ������ � �����������, ���� WHILE, ����������� UPDATE CURRENT OF. 
declare 
  cursor cur(cap auditorium.auditorium%type,cap1 auditorium.auditorium%type)
  is select auditorium, auditorium_capacity from auditorium
  where auditorium_capacity between cap and cap1 for update;
  aum auditorium.auditorium%type;
  cap auditorium.auditorium_capacity%type;
begin
  open cur(0,20);
  fetch cur into aum, cap;
  while(cur%found)
      loop
          delete auditorium where current of cur;
          fetch cur into aum, cap;
      end loop;
  close cur;
      
  for a in cur(0,120) loop
     dbms_output.put_line(a.auditorium||' '||a.auditorium_capacity);
  end loop; 
  rollback;
end;
--19. �������� A�. ����������������� ���������� ������������� ROWID � ���������� UPDATE � DELETE. 
declare
  cursor cur(capacity auditorium.auditorium%type)
  is select auditorium, auditorium_capacity, rowid
  from auditorium where auditorium_capacity >=capacity for update;
  aum auditorium.auditorium%type;
  cap auditorium.auditorium_capacity%type;
begin
  for xxx in cur(80)
      loop
     if xxx.auditorium_capacity >= 90
          then delete auditorium where rowid = xxx.rowid and xxx.auditorium_capacity >= 90;
    elsif xxx.auditorium_capacity >= 40
          then update auditorium
          set auditorium_capacity = auditorium_capacity+3
          where rowid = xxx.rowid;
        end if;
      end loop;
  for yyy in cur(80)
      loop
        dbms_output.put_line(yyy.auditorium||' '||yyy.auditorium_capacity);
      end loop; 
      rollback;
end;
--20. ������������ � ����� ����� ���� �������������� (teacher), �������� �������� �� ��� (�������� ������ ������ -------------). 
declare 
    cursor curs_teachers is select *from teacher;
    m_teacher   teacher.teacher%type;
    m_teacher_name   teacher.teacher_name%type;
    m_pulpit   teacher.pulpit%type;
begin
    open curs_teachers;
    dbms_output.put_line('rowcount = ' || curs_teachers%rowcount);
    loop
    fetch curs_teachers into m_teacher, m_teacher_name, m_pulpit;
    exit when curs_teachers%notfound;
    dbms_output.put_line(' ' || curs_teachers%rowcount || ' ' || m_teacher || ' ' || m_teacher_name || 
                        ' ' || m_pulpit);
    if (mod(curs_teachers%rowcount, 3) = 0) then dbms_output.put_line('-----------------------');
    end if;
    end loop;
    dbms_output.put_line('rowcount = ' || curs_teachers%rowcount);
    close curs_teachers;
exception
      when others
        then dbms_output.put_line(sqlcode||' '||sqlerrm);    
end;