CREATE OR REPLACE FUNCTION merge_duplicates (
    in_table_name   VARCHAR2,
    ignore_cols     IN              strlist DEFAULT strlist('')
) RETURN NUMBER IS

    TYPE arr IS
        TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
    TYPE t_keys IS RECORD (
        key_min           VARCHAR2(200),
        key_upd           VARCHAR2(200)
    );
    dup_rec           t_keys;
    TYPE t_col_tab IS RECORD (
        tab_name          VARCHAR2(200),
        col_name          VARCHAR2(200)
    );
    tab_rec           t_col_tab;
    resource_busy EXCEPTION;
    PRAGMA exception_init ( resource_busy, -00054 );
    v_cursor_id       NUMBER;
    v_ok              NUMBER;
    v_rec_tab         dbms_sql.desc_tab;
    v_nr_col          NUMBER;
    v_total_coloane   NUMBER;
    deleted_records   NUMBER := 0;
    merged_records    NUMBER := 0;
    v_col_name        VARCHAR2(32767);
    dml_str           VARCHAR2(32767);
    group_by_str      VARCHAR2(32767) := '';
    table_refs        arr;
    col_refs          arr;
    refs_cursor       SYS_REFCURSOR;
    v_index           NUMBER := 0;
    table_pk          VARCHAR2(32767);
    id_to_stay        VARCHAR2(32767);
    dups_cursor       SYS_REFCURSOR;
    on_str            VARCHAR2(5000) := ' ';
BEGIN
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'SELECT * FROM ' || in_table_name, dbms_sql.native);
    v_ok := dbms_sql.execute(v_cursor_id);
    dbms_sql.describe_columns(v_cursor_id, v_total_coloane, v_rec_tab);
    v_nr_col := v_rec_tab.first;
    IF ( v_nr_col IS NOT NULL ) THEN
        LOOP
            v_col_name := v_rec_tab(v_nr_col).col_name;
            IF NOT ( v_col_name MEMBER OF ignore_cols ) THEN
                IF ( v_nr_col = 1 ) THEN
                    group_by_str := group_by_str
                                    || v_col_name
                                    || ', ';
                    on_str := on_str
                              || 't1.'
                              || v_col_name
                              || '=t2.'
                              || v_col_name
                              || ' and ';

                ELSE
                    group_by_str := group_by_str
                                    || v_col_name
                                    || ', ';
                    on_str := on_str
                              || 't1.'
                              || v_col_name
                              || '=t2.'
                              || v_col_name
                              || ' and ';

                END IF;

            END IF;

            v_nr_col := v_rec_tab.next(v_nr_col);
            EXIT WHEN ( v_nr_col IS NULL );
        END LOOP;
    END IF;

    group_by_str := substr(group_by_str, 1, length(group_by_str) - 2);
    on_str := substr(on_str, 1, length(on_str) - 5);
    SELECT
        cols.column_name
    INTO table_pk
    FROM
        all_constraints    cons
        NATURAL JOIN all_cons_columns   cols
    WHERE
        cons.constraint_type = 'P'
        AND table_name = upper(in_table_name);

    on_str := on_str
              || ' and t1.'
              || table_pk
              || '<t2.'
              || table_pk;
    dbms_output.put_line('gby: ' || group_by_str);
    dbms_output.put_line('onstr: ' || on_str);
    deleted_records := remove_duplicates(in_table_name, ignore_cols);
    dbms_output.put_line(table_pk);
    dbms_output.put_line(in_table_name);
    dbms_output.put_line('select t1.'
                         || table_pk
                         || ' ,t2.'
                         || table_pk
                         || ' from '
                         || in_table_name
                         || ' t1 join '
                         || in_table_name
                         || ' t2 on '
                         || on_str);

    OPEN dups_cursor FOR 'select t1.'
                         || table_pk
                         || ' ,t2.'
                         || table_pk
                         || ' from '
                         || in_table_name
                         || ' t1 join '
                         || in_table_name
                         || ' t2 on '
                         || on_str;

    OPEN refs_cursor FOR 'select table_name, REGEXP_SUBSTR(constraint_name, ''[^_]+_[^_]+$'',1,1) as "col_name"
        from all_constraints 
        where constraint_type=''R''
        and r_constraint_name in (select constraint_name 
                                   from all_constraints 
                                  where constraint_type in (''P'',''U'') 
                                    and table_name= '''
                         || in_table_name
                         || ''')';

    LOOP
        FETCH dups_cursor INTO dup_rec;
        EXIT WHEN dups_cursor%notfound;
        dbms_output.put_line('inside loop of cursor after not found');
        dbms_output.put_line('dup_rec.key_min: ' || dup_rec.key_min);
        dbms_output.put_line('dup_rec.key_upd: ' || dup_rec.key_upd);
        LOOP
            FETCH refs_cursor INTO tab_rec;
            EXIT WHEN refs_cursor%notfound;
            dbms_output.put_line('tab_rec.tab_name: ' || tab_rec.tab_name);
            dbms_output.put_line('tab_rec.col_name: ' || tab_rec.col_name);
            dml_str := 'update '
                       || tab_rec.tab_name
                       || ' set '
                       || tab_rec.col_name
                       || ' = '
                       || dup_rec.key_min
                       || ' where '
                       || tab_rec.col_name
                       || ' = '
                       || dup_rec.key_upd;

            dbms_output.put_line('dml_str: ' || dml_str);
            EXECUTE IMMEDIATE dml_str;
            merged_records := merged_records + SQL%rowcount;
        END LOOP;

    END LOOP;
    deleted_records := remove_duplicates(in_table_name, ignore_cols);

    RETURN merged_records;
    dbms_sql.close_cursor(v_cursor_id);
END;