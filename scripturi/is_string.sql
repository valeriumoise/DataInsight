CREATE OR REPLACE FUNCTION is_string (
    v_rec_tab   dbms_sql.desc_tab,
    v_nr_col    INT
) RETURN BOOLEAN AS
is_string boolean;
BEGIN
    CASE ( v_rec_tab(v_nr_col).col_type )
        WHEN 1 THEN
            is_string := TRUE;
        WHEN 96 THEN
            is_string := TRUE;
        WHEN 112 THEN
            is_string := TRUE;
        ELSE is_string :=FALSE;    
    END CASE;
    
    RETURN is_string;
END;
