CREATE OR REPLACE PACKAGE my_public_package IS
  my_index number;
END;
/
CREATE OR REPLACE FUNCTION check_escape(
    exp varchar2,
    poz number
) RETURN boolean
IS
BEGIN
    if(poz<1) then
        return false;
    end if;
    if(SUBSTR(exp,poz,1)='\') then
        return true;
    end if;
    return false;
END;
/
CREATE OR REPLACE FUNCTION check_square_parenthesis(
    square varchar2,
    mydata varchar2,
    dataindex number
) RETURN boolean
IS
    indexx number;
    square_size number;
BEGIN
    indexx := 1;
    square_size := length(square);
    --dbms_output.put_line(square);
    LOOP
        if (indexx + 1<square_size+1) then
            --dbms_output.put_line('intrare if 1');
            if((SUBSTR(square,indexx+1,1)='-') AND (check_escape(square, indexx)=false)) then
                --dbms_output.put_line('intrare if 2');
                if(SUBSTR(square,indexx,1)<=SUBSTR(mydata,dataindex,1) AND SUBSTR(square,indexx+2,1)>=SUBSTR(mydata,dataindex,1)) then
                    --dbms_output.put_line('intrare if 3 true');
                    return true;
                else
                    --dbms_output.put_line('intrare else 3.1');
                    indexx := indexx+2;
                end if;
            elsif(INSTR(square,SUBSTR(mydata,dataindex,1),1,1)<>0) then
                --dbms_output.put_line('intrare if 2.1 true');
                return true;
            end if;
        elsif (INSTR(square,SUBSTR(mydata,dataindex,1),1,1)<>0) then
            --dbms_output.put_line('intrare if 1.1 true');
            return true;
        end if;
        indexx := indexx+1;
        --dbms_output.put_line(indexx);
    EXIT WHEN(indexx>square_size);
    END LOOP;
    return false;
END;
/
CREATE OR REPLACE FUNCTION check_square_parenthesis_rev(
    square varchar2,
    mydata varchar2,
    dataindex number
) RETURN boolean
IS
    indexx number;
    square_size number;
BEGIN
    indexx := 1;
    square_size := length(square);
    LOOP
        if (indexx + 1<square_size+1) then
            if((SUBSTR(square,indexx+1,1)='-') AND (check_escape(square, indexx)=false)) then
                if(SUBSTR(square,indexx,1)<=SUBSTR(mydata,dataindex,1) AND SUBSTR(square,indexx+2,1)>=SUBSTR(mydata,dataindex,1)) then
                    return false;
                else
                    indexx := indexx+2;
                end if;
            elsif(INSTR(square,SUBSTR(mydata,dataindex,1),1,1)<>0) then
                return false;
            end if;
        elsif (INSTR(square,SUBSTR(mydata,dataindex,1),1,1)<>0) then
                return false;
        end if;
        indexx := indexx+1;
    EXIT WHEN(indexx>square_size);
    END LOOP;
    return true;
END;
/
CREATE OR REPLACE FUNCTION edit_col_by_regexp_f (
    regexp varchar2,
    mydatafirst varchar2
) RETURN boolean 
IS
    v_curr_r varchar2(2);
    v_curr_d varchar2(2);
    v_length_regexp number;
    v_length_mydatafirst number;
    poz_exp number;
    --my_public_package.my_index number;
    square_p varchar2(50);
    normal_p varchar2(50);
    v_reverse boolean;
    reset_index number;
BEGIN
    poz_exp := 1;
    --my_public_package.my_index := 1;
    v_length_regexp := length(regexp);
    v_length_mydatafirst := length(mydatafirst);
    
--    for elem in 1 .. v_length_regexp loop
--        v_curr := SUBSTR(regexp,elem,1);
--        dbms_output.put_line(v_curr);
--    end loop;
    LOOP
        if(poz_exp > v_length_regexp) then
            --dbms_output.put_line('true 1');
            return true;
        elsif((SUBSTR(regexp,poz_exp,1)='[') AND (check_escape(regexp, poz_exp-1)=false)) then
            v_reverse := false;
            poz_exp := poz_exp+1;
            square_p := '';
            if(substr(regexp,poz_exp,1)='^') then
                v_reverse := true;
                poz_exp := poz_exp+1;
            end if;
            LOOP
                if(substr(regexp,poz_exp,1)<>'\') then
                    square_p := square_p || SUBSTR(regexp,poz_exp,1);
                end if;
                poz_exp := poz_exp+1;
            EXIT WHEN ((SUBSTR(regexp,poz_exp,1) = ']') AND (check_escape(regexp, poz_exp-1)=false));
            END LOOP;
            if (v_reverse=false) then
                if(check_square_parenthesis(square_p, mydatafirst, my_public_package.my_index) = false) then                
                    --dbms_output.put_line('false 1');
                    return false;
                end if;
            else
                if(check_square_parenthesis_rev(square_p, mydatafirst, my_public_package.my_index) = false) then
                    --dbms_output.put_line('false 2');
                    return false;
                end if;
            end if;
            poz_exp := poz_exp+1;
        elsif(SUBSTR(regexp,poz_exp,1)='.') then
            if(SUBSTR(mydatafirst,my_public_package.my_index,1)='\n') then
                --dbms_output.put_line('false 3');
                return false;
            end if;
            poz_exp := poz_exp+1;
        elsif ((SUBSTR(regexp,poz_exp,1)='(')AND(check_escape(regexp, poz_exp-1)=false)) then
            normal_p := '';
            poz_exp := poz_exp+1;
            LOOP
                if (SUBSTR(regexp,poz_exp,1) <> '\') then
                    normal_p :=normal_p || SUBSTR(regexp,poz_exp,1);
                end if;
                poz_exp := poz_exp+1;
            EXIT WHEN ((SUBSTR(regexp,poz_exp,1)=')') AND (check_escape(regexp, poz_exp-1)=false));
            END LOOP;
            poz_exp := poz_exp+1;
            reset_index := my_public_package.my_index;
            if (SUBSTR(regexp,poz_exp,1)='*') then
                WHILE (edit_col_by_regexp_f(normal_p,mydatafirst)=true) LOOP
                    reset_index := my_public_package.my_index;
                END LOOP;
                my_public_package.my_index := reset_index;
                my_public_package.my_index := my_public_package.my_index-1;
            elsif (SUBSTR(regexp,poz_exp,1)='+') then
                if (edit_col_by_regexp_f(normal_p,mydatafirst)=false) then
                    return false;
                end if;
                WHILE (edit_col_by_regexp_f(normal_p,mydatafirst)=true) LOOP
                    reset_index := my_public_package.my_index;
                END LOOP;
                my_public_package.my_index := reset_index;
                my_public_package.my_index := my_public_package.my_index -1;
            end if;
            poz_exp := poz_exp+1;
        else
            if((SUBSTR(mydatafirst,my_public_package.my_index,1) <>  SUBSTR(regexp,poz_exp,1)) AND substr(regexp,poz_exp,1)<>'\') then
                --dbms_output.put_line('false 4' || ' ' || SUBSTR(mydatafirst,my_public_package.my_index,1) || ' ' || SUBSTR(regexp,poz_exp,1));
                return false;
            end if;
            if(substr(regexp,poz_exp,1)='\') then
                my_public_package.my_index := my_public_package.my_index-1;
            end if;
            
            poz_exp := poz_exp+1;
        end if;
        my_public_package.my_index := my_public_package.my_index+1;
    EXIT WHEN my_public_package.my_index>v_length_mydatafirst;
    END LOOP;
    if (v_length_regexp>poz_exp+1) then
        --dbms_output.put_line('false 5' || ' ' || v_length_regexp || ' ' || poz_exp+1 || ' ' ||my_public_package.my_index);
        return false;
    end if;
    --dbms_output.put_line('true 2');
    return true;
END;
/
CREATE OR REPLACE TYPE return_type as object(poz_start number, poz_finish number);
/
CREATE OR REPLACE FUNCTION check_where_regexp(
    regexp varchar2,
    mydatafirst varchar2
) return return_type
IS
    v_length_mydatafirst number;
    v_this_index number;
    v_current_data varchar2(200);
    return_data return_type;
BEGIN
    return_data := return_type(0,0);
    my_public_package.my_index := 1;
--    return_data.poz_start := 0;
--    return_data.poz_finish := 0;
    v_length_mydatafirst := length(mydatafirst);
    v_this_index := 1;
    v_current_data := '';
    WHILE (v_this_index <= v_length_mydatafirst) LOOP
        v_current_data := SUBSTR(mydatafirst,v_this_index,(v_length_mydatafirst-v_this_index+1));
        if(edit_col_by_regexp_f(regexp,v_current_data)=true) then
            return_data.poz_start := v_this_index;
            return_data.poz_finish := my_public_package.my_index-1+v_this_index-1;
            return return_data;
        end if;
        v_current_data := '';
        v_this_index := v_this_index+1;
    END LOOP;   
    return return_data;
END;
/   
set serveroutput on;
DECLARE
    new_data return_type;
BEGIN
    new_data := check_where_regexp('aaa.','aazac');
        dbms_output.put_line('start: ' || new_data.poz_start);
        dbms_output.put_line('end: ' || new_data.poz_finish);
END;