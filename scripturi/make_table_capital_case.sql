CREATE OR REPLACE PROCEDURE make_table_capital_case (
    table_name VARCHAR2
) IS

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
            v_col_name := v_rec_tab(v_nr_col).col_name;
            if ( is_string(v_rec_tab,v_nr_col) ) then
                make_col_capital_case(table_name,v_col_name);
            end if;
            v_nr_col := v_rec_tab.next(v_nr_col);
            EXIT WHEN ( v_nr_col IS NULL );
        END LOOP;
    END IF;

    dbms_sql.close_cursor(v_cursor_id);
END;