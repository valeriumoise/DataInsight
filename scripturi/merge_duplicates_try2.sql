CREATE OR REPLACE FUNCTION merge_duplicates (
    in_table_name    VARCHAR2,
    ignore_cols   IN strlist DEFAULT strlist('')
) RETURN NUMBER IS
    type arr is table of varchar2(200) index by binary_integer;
    resource_busy EXCEPTION;
    PRAGMA exception_init ( resource_busy, -00054 );
    v_cursor_id       NUMBER;
    v_ok              NUMBER;
    v_rec_tab         dbms_sql.desc_tab;
    v_nr_col          NUMBER;
    v_total_coloane   NUMBER;
    deleted_records   NUMBER;
    v_col_name        VARCHAR2(32767);
    dml_str           VARCHAR2(32767);
    group_by_str      VARCHAR2(32767) := '';
    table_refs arr;
    col_refs arr;
    cursor refs is 
        select in_table_name "table_name", REGEXP_SUBSTR(constraint_name, '[^_]+$') as "col_name"
        from all_constraints 
        where constraint_type='R'
        and r_constraint_name in (select constraint_name 
                                   from all_constraints 
                                  where constraint_type in ('P','U') 
                                    and table_name= in_table_name);
        v_index  number :=0;    
    table_pk varchar2(32767);
    dup_cursor sys_refcursor;
    V_STMT_STR varchar2(32767);
--    type ty is table of in_table_name%rowtype;
--    dups_temp ty;
BEGIN
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'SELECT * FROM ' || in_table_name, dbms_sql.native);
    v_ok := dbms_sql.execute(v_cursor_id);
    dbms_sql.describe_columns(v_cursor_id, v_total_coloane, v_rec_tab);
    v_nr_col := v_rec_tab.first;
    IF ( v_nr_col IS NOT NULL ) THEN
        LOOP
            v_col_name := v_rec_tab(v_nr_col).col_name;IF NOT ( v_col_name MEMBER OF ignore_cols ) THEN
                IF ( v_nr_col > 1 ) THEN
                    group_by_str := concat(concat(group_by_str, v_col_name), ', ');
                ELSE
                    group_by_str := v_col_name || ', ';
                END IF;

            END IF;

--            dbms_output.put_line(group_by_str);

            v_nr_col := v_rec_tab.next(v_nr_col);
            EXIT WHEN ( v_nr_col IS NULL );
        END LOOP;
    END IF;
    group_by_str := substr(group_by_str, 1, length(group_by_str) - 2);
    
    deleted_records := remove_duplicates(in_table_name,ignore_cols);
    
    SELECT cols.column_name into table_pk
    FROM all_constraints cons NATURAL JOIN all_cons_columns cols
    WHERE cons.constraint_type = 'P' AND table_name = UPPER(in_table_name);
    
    v_stmt_str := 'select * from ' || in_table_name || ' where rowid not in (select max(rowid) from ' || in_table_name || ' group by ' || group_by_str || ')';
--    open dup_cursor for v_stmt_str;
--    loop
--        fetch dup_cursor into 
--        for ref_row in refs loop
--            table_refs(1) := 'note';
--        end loop;
--    end loop;
    
--    table_refs(1) := 'note';
--    col_refs(1) := 'id_student';
--    dbms_output.put_line(table_refs.count || ' varchar2s ');
--    dbms_output.put_line(col_refs.count || ' varchar2s ');
    
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'SELECT * FROM ' || in_table_name, dbms_sql.native);
    v_ok := dbms_sql.execute(v_cursor_id);
    dbms_sql.describe_columns(v_cursor_id, v_total_coloane, v_rec_tab);
    v_nr_col := v_rec_tab.first;
    dbms_output.put_line('OH: ' || ignore_cols(1));
    RETURN deleted_records;

    IF ( v_nr_col IS NOT NULL ) THEN
        LOOP
            v_col_name := v_rec_tab(v_nr_col).col_name;
            -- col by col code
            v_nr_col := v_rec_tab.next(v_nr_col);
            EXIT WHEN ( v_nr_col IS NULL );
        END LOOP;
    END IF;

    dbms_sql.close_cursor(v_cursor_id);
end;