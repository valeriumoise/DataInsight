CREATE OR REPLACE PROCEDURE remove_white_space (
    table_name VARCHAR2
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
BEGIN
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'SELECT * FROM ' || table_name, dbms_sql.native);
    v_ok := dbms_sql.execute(v_cursor_id);
    dbms_sql.describe_columns(v_cursor_id, v_total_coloane, v_rec_tab);
    v_nr_col := v_rec_tab.first;
    IF ( v_nr_col IS NOT NULL ) THEN
        LOOP
            BEGIN
                v_col_name := v_rec_tab(v_nr_col).col_name;
                dml_str := 'UPDATE '
                           || table_name
                           || ' SET '
                           || v_col_name
                           || ' = trim(REGEXP_REPLACE('
                           || v_col_name
                           || ', ''\s{2,}'', '' ''))';

                EXECUTE IMMEDIATE dml_str;
            EXCEPTION
                WHEN resource_busy THEN
                    dbms_output.put_line('Record locked; try again later.');
                    CONTINUE;
                WHEN OTHERS THEN
                    dbms_output.put_line('An error occured');
            END;

            v_nr_col := v_rec_tab.next(v_nr_col);
            EXIT WHEN ( v_nr_col IS NULL );
        END LOOP;
    END IF;

    dbms_sql.close_cursor(v_cursor_id);
END;