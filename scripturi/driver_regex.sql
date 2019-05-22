begin
    dbms_output.put_line('rows affected: ' || regex_update_with('CURSURI','TITLU_CURS','BD','Baze de date'));
end;

begin
    dbms_output.put_line('rows affected: ' || regex_update_in_col('CURSURI','TITLU_CURS','elevi','studenti'));
end;
