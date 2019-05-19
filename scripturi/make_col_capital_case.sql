CREATE OR REPLACE PROCEDURE make_col_capital_case (
    table_name VARCHAR2,
    col_name VARCHAR2
) IS
    dml_str VARCHAR2(32767);
BEGIN
    dml_str := 'UPDATE '
               || table_name
               || ' SET '
               || col_name
               || ' = initcap('
               || col_name
               || ')';

    EXECUTE IMMEDIATE dml_str;
END;