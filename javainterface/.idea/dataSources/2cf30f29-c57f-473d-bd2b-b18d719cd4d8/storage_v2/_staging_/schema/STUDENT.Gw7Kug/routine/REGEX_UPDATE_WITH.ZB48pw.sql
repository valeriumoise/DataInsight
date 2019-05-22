create or replace procedure regex_update_with (
    table_name     VARCHAR2,
    col_name       VARCHAR2,
    regex          VARCHAR2,
    paste_string   VARCHAR2
) --RETURN NUMBER IS
IS
    rows_affected   NUMBER :=0;
    rec             VARCHAR2(32767);
    dml_str         VARCHAR2(32767);
    group_by_str    VARCHAR2(32767) := '';
    col_cursor      SYS_REFCURSOR;
    regex_data        return_type;
BEGIN
    OPEN col_cursor FOR 'select '
        || col_name
        || ' from '
        || table_name;

    LOOP
        FETCH col_cursor INTO rec;
        dbms_output.put_line('after fetch');
        EXIT WHEN col_cursor%notfound;
        regex_data := check_where_regexp(regex,rec);
        --        dbms_output.put_line(rec);
--        dbms_output.put_line('start: ' || regex_data.poz_start);
--        dbms_output.put_line('end: ' || regex_data.poz_finish);
        if (regex_data.poz_start>0) then
            dml_str := 'update ' || table_name
                || ' set ' || col_name || '=''' ||  paste_string
                || ''' where ' || col_name || '=''' || rec || '''';
            dbms_output.put_line(dml_str);
            execute immediate dml_str;
            rows_affected := rows_affected + SQL%rowcount;
        end if;
    END LOOP;
    --return rows_affected;
END;
/

