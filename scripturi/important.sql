begin
    dbms_output.put_line('records deleted: ' || remove_duplicates('studenti',STRLIST('ID','CREATED_AT','UPDATED_AT')));
end;

begin
    dbms_output.put_line('records deleted: ' || remove_duplicates('studenti'));
end;

WITH data AS
(
   SELECT 'FK_PRIETENI_ID_STUDENT1' str FROM dual
)
SELECT str,
       REGEXP_SUBSTR(str, '[^_]+$') new_str
FROM data;

select * from cursuri where rowid not in (select min(rowid) from cursuri group by titlu_curs,an,semestru,credite) and id<=1;

select * from cursuri where rowid not in (select max(rowid) from cursuri group by titlu_curs,an,semestru,credite);

SELECT cols.column_name
FROM all_constraints cons NATURAL JOIN all_cons_columns cols
WHERE cons.constraint_type = 'P' AND table_name = UPPER('&TABLE_NAME');

select table_name "table_name", REGEXP_SUBSTR(constraint_name, '[^_]+$') as "col_name",*
  from all_constraints 
 where constraint_type='R'
   and r_constraint_name in (select constraint_name 
                               from all_constraints 
                              where constraint_type in ('P','U') 
                                and table_name='STUDENTI');