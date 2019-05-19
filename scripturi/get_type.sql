 
CREATE OR REPLACE FUNCTION getType(v_rec_tab DBMS_SQL.DESC_TAB, v_nr_col int) RETURN VARCHAR2 AS
  v_tip_coloana VARCHAR2(200);
  v_precizie VARCHAR2(40);
BEGIN
     CASE (v_rec_tab(v_nr_col).col_type)
        WHEN 1 THEN v_tip_coloana := 'VARCHAR2'; v_precizie := '(' || v_rec_tab(v_nr_col).col_max_len || ')';
        WHEN 2 THEN v_tip_coloana := 'NUMBER'; v_precizie := '(' || v_rec_tab(v_nr_col).col_precision || ',' || v_rec_tab(v_nr_col).col_scale || ')';
        WHEN 12 THEN v_tip_coloana := 'DATE'; v_precizie := '';
        WHEN 96 THEN v_tip_coloana := 'CHAR'; v_precizie := '(' || v_rec_tab(v_nr_col).col_max_len || ')';
        WHEN 112 THEN v_tip_coloana := 'CLOB'; v_precizie := '';
        WHEN 113 THEN v_tip_coloana := 'BLOB'; v_precizie := '';
        WHEN 109 THEN v_tip_coloana := 'XMLTYPE'; v_precizie := '';
        WHEN 101 THEN v_tip_coloana := 'BINARY_DOUBLE'; v_precizie := '';
        WHEN 100 THEN v_tip_coloana := 'BINARY_FLOAT'; v_precizie := '';
        WHEN 8 THEN v_tip_coloana := 'LONG'; v_precizie := '';
        WHEN 180 THEN v_tip_coloana := 'TIMESTAMP'; v_precizie :='(' || v_rec_tab(v_nr_col).col_scale || ')';
        WHEN 181 THEN v_tip_coloana := 'TIMESTAMP' || '(' || v_rec_tab(v_nr_col).col_scale || ') ' || 'WITH TIME ZONE'; v_precizie := '';
        WHEN 231 THEN v_tip_coloana := 'TIMESTAMP' || '(' || v_rec_tab(v_nr_col).col_scale || ') ' || 'WITH LOCAL TIME ZONE'; v_precizie := '';
        WHEN 114 THEN v_tip_coloana := 'BFILE'; v_precizie := '';
        WHEN 23 THEN v_tip_coloana := 'RAW'; v_precizie := '(' || v_rec_tab(v_nr_col).col_max_len || ')';
        WHEN 11 THEN v_tip_coloana := 'ROWID'; v_precizie := '';
        WHEN 109 THEN v_tip_coloana := 'URITYPE'; v_precizie := '';
      END CASE;
      RETURN v_tip_coloana||v_precizie;
END;
/