CREATE OR REPLACE TYPE strlist IS
    TABLE OF VARCHAR2(32767);
/

CREATE OR REPLACE PROCEDURE remove_duplicates (
    table_name    VARCHAR2,
    ignore_cols   IN            strlist DEFAULT strlist('')
) IS

    resource_busy EXCEPTION;
    PRAGMA exception_init ( resource_busy, -00054 );
    v_cursor_id       NUMBER;
    v_ok              NUMBER;
    v_rec_tab         dbms_sql.desc_tab;
    v_nr_col          NUMBER;
    v_total_coloane   NUMBER;
    v_col_name        VARCHAR2(32767);
    dml_str           VARCHAR2(32767);
    group_by_str      VARCHAR2(32767) := '';
BEGIN
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'SELECT * FROM ' || table_name, dbms_sql.native);
    v_ok := dbms_sql.execute(v_cursor_id);
    dbms_sql.describe_columns(v_cursor_id, v_total_coloane, v_rec_tab);
    v_nr_col := v_rec_tab.first;
    dbms_output.put_line(group_by_str);
    IF ( v_nr_col IS NOT NULL ) THEN
        LOOP
            v_col_name := v_rec_tab(v_nr_col).col_name;
            dbms_output.put_line('colname: '
                                 || v_col_name
                                 || ', v_nr_col: : '
                                 || v_nr_col);
            IF NOT ( v_col_name MEMBER OF ignore_cols ) THEN
                IF ( v_nr_col > 1 ) THEN
                    group_by_str := concat(concat(group_by_str, v_col_name), ', ');
                ELSE
                    group_by_str := v_col_name || ', ';
                END IF;
            END IF;

            dbms_output.put_line(group_by_str);
            v_nr_col := v_rec_tab.next(v_nr_col);
            EXIT WHEN ( v_nr_col IS NULL );
        END LOOP;
    END IF;

    group_by_str := substr(group_by_str, 1, length(group_by_str) - 2);
    dbms_output.put_line(group_by_str);
    dml_str := 'DELETE FROM '
               || table_name
               || ' WHERE rowid NOT IN ( SELECT MAX(ROWID) FROM '
               || table_name
               || ' GROUP BY '
               || group_by_str
               || ' )';

    dbms_output.put_line(dml_str);
    EXECUTE IMMEDIATE dml_str;
    dbms_sql.close_cursor(v_cursor_id);
END;