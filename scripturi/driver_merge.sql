insert into note values (200004,200000,1,10,sysdate,sysdate,sysdate);
insert into note values (200005,200000,1,10,sysdate,sysdate,sysdate);

select * from studenti where id>=200000;
select * from note where id>=200000;

begin
    dbms_output.put_line('records merged: ' || merge_duplicates('STUDENTI',strlist('ID','NR_MATRICOL','UPDATED_AT','CREATED_AT')));
end;

begin
    dbms_output.put_line('records deleted: ' || remove_duplicates('STUDENTI',strlist('ID','NR_MATRICOL','UPDATED_AT','CREATED_AT')));
end;
