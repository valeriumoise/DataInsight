drop table users cascade constraints;
/
drop table user_addresses cascade constraints;
/
drop table phone_numbers cascade constraints;
/
drop table cars cascade constraints;
/
drop table tags cascade constraints;
/
drop table resources cascade constraints;
/
drop table resource_tags cascade constraints;
/
drop table user_prefered_tags cascade constraints;
/
drop table user_saved_resources cascade constraints;
/

create table users (
    id number(20) primary key,
    email varchar2(100) not null,
    fname varchar2(100) not null,
    lname varchar2(100) not null,
    birthday date
)
/

create table user_addresses (
    user_id number(20) not null,
    address varchar2(200) not null,
    constraint user_addr_user_id_fkey foreign key (user_id) references users(id)
)
/

create table phone_numbers(
    user_id number(20) constraint phone_numbers_user_id_fkey references users (id),
    phone varchar2(14)
)
/

create table cars (
    owner_id number(20) constraint car_owner_fkey references users (id),
    plate_number varchar2(20) primary key,
    make varchar(30) not null,
    model varchar(50) not null,
    fab_year number(4) not null,
    seats number(2),
    fuel_type varchar(8),
    color varchar(20)
)
/

create table tags (
    id number(20) not null primary key,
    tag_name varchar2(100) not null
)
/

create table resources (
    id number(20) not null primary key,
    title varchar2(100) not null,
    author varchar2(100) not null,
    created_at DATE default sysdate,
    description varchar2(200)
)
/

create table resource_tags (
    resource_id number(20) constraint resource_tags_resource_id_fkey references resources (id),
    tag_id number(20) constraint resource_tags_tag_id_fkey references tags (id)
)
/

create table user_prefered_tags (
    user_id number(20) constraint user_pref_tags_user_id_fkey references users (id),
    tag_id number(20) constraint user_pref2_tags_tag_id_fkey references tags (id)
)
/

create table user_saved_resources (
    user_id number(20) constraint user_saved_uid_fkey references users (id),
    resource_id number(20) constraint user_saved_res_id_fkey references resources (id)
)
/
set serveroutput on;
declare
    -- resources
    type arr_author is varray(1000) of resources.author%type;
    type arr_title is varray(1000) of resources.title%type;
    type arr_description is varray(1000) of resources.description%type;
    authors arr_author := arr_author('Wing Moses', 'Jesse Mcintyre', 'Gisela Humphrey', 'Aimee Grant', 'Elmo Phillips', 'Clinton Lawrence'
    , 'Macy Dorsey', 'Ezra Cohen', 'Byron Beard', 'Imelda Andrews', 'Imogene Freeman', 'Keelie Cain', 'Raymond Murray', 'Jaime Simon'
    , 'Lana Kim', 'Dylan Austin', 'Uma Griffith', 'Baxter Martin', 'Winter Butler', 'Lars Hamilton', 'Hyatt Holmes', 'Guy Alvarado'
    , 'Cameran Rose', 'Jacqueline Talley', 'Aimee Boyer', 'Alfonso Schwartz', 'Nichole Roman', 'Ciaran Ortiz', 'Shay Snider', 'Dominic Kemp'
    , 'Serena Harper', 'Daria Hodge', 'Lewis Steele', 'Stella Rhodes', 'Xandra Huff', 'Candice Hayes', 'Lydia Pennington', 'Mechelle Wynn'
    , 'Mikayla Haynes', 'Sylvia Meadows', 'Dennis Lowery', 'Lilah Baird', 'Otto Armstrong', 'Warren Greer', 'Asher Wilcox', 'Myles French'
    , 'Adam Tanner', 'Reece Head', 'Xander Washington');
    titles arr_title := arr_title('Donec non justo.', 'arcu. Nunc mauris. Morbi non', 'dictum sapien. Aenean', 'nulla. Donec', 'mauris'
    , 'eu enim. Etiam imperdiet', 'Phasellus vitae mauris', 'natoque penatibus et ,magnis dis', 'litora torquent per', 'neque. Morbi quis urna. Nunc'
    , 'vitae erat vel pede', 'malesuada vel', 'Phasellus fermentum convallis ligula. Donec', 'dis parturient montes', 'ac mattis semper'
    , 'auctor. Mauris vel', 'egestas ligula. Nllam feugiat placerat', 'neque. Sed eget lacus.vulputate', 'diam luctus lobortis. Class aptent'
    , 'eget lacus. Mauris non duinulla. In', 'parturient montessemper', 'Ut tinciduntvitae', 'vitae aliquam eros turpis', 'In nec orci. Donec'
    , 'tempor arcu. Vestibulumante.', 'enim. Sed', 'diam at pretium', 'rhoncus. Nullam velit', 'venenatis vel', 'convallis', 'augue. Sed'
    , 'eget mollis');
    

    
    descriptions arr_description := arr_description(
    'sit amet	 risus. Donec nibh enim	 gravida sit amet	 dapibus id	 blandit at	 nisi. Cum sociis natoque penatibus et '
    , 'Nunc sed orci lobortis augue scelerisque mollis. Phasellus libero mauris	 aliquam eu	 accumsan sed	 facilisis vitae'
    , ' Phasellus dapibus quam quis diam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames '
    , 'Proin velit. Sed malesuada augue ut lacus. Nulla tincidunt	 neque vitae semper egestas	 urna justo faucibus lectus	 a sollicitudin orci												'
    , 'ultrices	 mauris ipsum porta elit	 a feugiat tellus lorem eu metus. In lorem. Donec elementum	 lorem ut aliquam iaculis	 '
    , 'lacus pede sagittis augue	 eu tempor erat neque non quam. Pellentesque habitant morbi tristique senectus et netus et'
    , 'Duis risus odio	 auctor vitae	 aliquet nec	 imperdiet nec	 leo. Morbi neque tellus	 imperdiet non	 vestibulum'
    , 'mollis non	 cursus non	 egestas a	 dui. Cras pellentesque. Sed dictum. Proin eget odio. Aliquam vulputate ullamcorper magna.												'
    , 'nunc id enim. Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus. Nunc ac sem ut dolor da'
    , 'scelerisque ', 'vulputate dui	 nec tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor.'
    , 'viverra. Maecenas iaculis aliquet diam. Sed diam lorem	 auctor quis	 tristique ac	 eleifend vitae	 erat. Vivamus nis'
    , 'consequat nec	 mollis vitae	 posuere at	 velit. Cras lorem lorem	 luctus ut	 pellentesque eget	 dictum placerat'
    , 'sociosqu ad litora torquent per conubia nostra	 per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. '
    , 'quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam fringilla '
    , 'molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat '
    , 'felis ullamcorper viverra. Maecenas iaculis aliquet diam. Sed diam lorem	 auctor quis	 tristique ac	 eleifend vitae	 '
    , 'et netus et malesuada fames ac turpis															'
    , 'non sapien molestie orci tincidunt adipiscing. Mauris molestie pharetra nibh'
    , 'magna sed dui. Fusce aliquam	 enim nec tempus scelerisque	 lorem ipsum sodales purus	'
    , 'in molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus '
    , 'magna. Cras convallis convallis dolor. Quisque tincidunt pede ac urna. Ut tincidunt vehicula risus.'
    , 'Nulla eget metus eu erat semper rutrum. Fusce dolor quam	 '
    , 'lobortis	 nisi nibh lacinia orci	 consectetuer euismod est arcu ac orci. Ut semper pretium neque.			'
    , 'massa rutrum magna. Cras convallis convallis dolor'
    , 'tempor	 est ac mattis semper	 dui lectus rutrum urna	 nec luctus felis purus ac tellus. Suspendisse sed dolor.'
    , 'diam at pretium aliquet	 metus urna convallis erat	 eget tincidunt dui augue eu tellus. Phasellus elit pede	 '
    , 'fringilla ornare placerat	 orci lacus vestibulum lorem	 sit amet ultricies sem magna nec quam. '
    , 'Mauris vestibulum	 neque sed dictum eleifend	 nunc risus varius orci	 in consequat enim diam vel arcu'
    , 'Lorem ipsum dolor sit amet	 consectetuer adipiscing elit. Etiam laoreet	 libero 	', 'mi	 ac matti'
    , 'ut	 sem. Nulla interdum. Curabitur dictum. Phasellus in felis. Nulla tempor augue ac ipsum. Phasellus vit'
    );
    -- tags
    TYPE arr_tag IS
        VARRAY(5000) OF VARCHAR2(100);
    tag_list arr_tag := arr_tag('correctly', 'half', 'whole', 'worried', 'tip', 'protection', 'fall', 'radio', 'likely', 'rather', 'excellent'
    , 'sometime', 'class', 'command', 'yet', 'beyond', 'identity', 'beneath', 'smaller', 'making', 'brave', 'pack', 'direction', 'box'
    , 'weigh', 'science', 'connected');
    
    
    -- users
    TYPE arr_email IS
        VARRAY(1000) OF users.email%TYPE;
    TYPE arr_fname IS
        VARRAY(1000) OF users.fname%TYPE;
    TYPE arr_lname IS
        VARRAY(1000) OF users.lname%TYPE;
    TYPE arr_address IS
        VARRAY(1000) OF user_addresses.address%TYPE;
    TYPE arr_phone IS
        VARRAY(1000) OF phone_numbers.phone%TYPE;
    emails arr_email := arr_email('luctus.sit@urnaetarcu.co.uk', 'et.pede@leo.edu', 'lectus@semper.edu', 'Sed.diam@loremluctusut.org'
    , 'scelerisque.sed@quisaccumsan.co.uk', 'parturient@tempuslorem.co.uk', 'vulputate.mauris@velitjusto.co.uk', 'Duis.volutpat.nunc@atpedeCras.edu'
    , 'Nullam.enim@at.co.uk', 'ultricies@arcuet.co.uk', 'at.libero@convallisligula.edu', 'dictum.eu@nonnisi.com', 'Cum.sociis.natoque@eueleifendnec.com'
    , 'libero.Proin@dolor.co.uk', 'neque.vitae.semper@scelerisque.ca', 'placerat.velit.Quisque@et.ca', 'placerat.orci@dolorsit.edu'
    , 'lacus.Etiam.bibendum@DuisgravidaPraesent.edu', 'dictum.Phasellus@non.co.uk', 'ipsum@suscipitestac.org', 'est@augueeu.edu',
    'neque.Nullam@lobortisClass.edu', 'ultrices.mauris.ipsum@Donecegestas.net', 'natoque.penatibus@et.co.uk', 'tempor.augue@acturpis.ca'
    , 'Duis@at.com', 'quis.urna.Nunc@sedfacilisisvitae.org', 'malesuada@nuncsed.org', 'vel@purusinmolestie.net', 'cubilia.Curae@pharetrafelis.edu'
    , 'risus@risusDuis.com', 'Nam.ligula.elit@liberoProinsed.ca', 'orci.luctus.et@varius.org', 'nec.eleifend.non@laoreet.co.uk', 'porttitor.eros@laciniaorciconsectetuer.org'
    , 'semper@magnaNam.net', 'parturient@aliquamarcuAliquam.net', 'in.molestie.tortor@erosnon.com', 'odio@tellus.org', 'non.sollicitudin.a@Mauris.org'
    , 'eget.venenatis.a@convallis.edu', 'primis@Aliquamtincidunt.ca', 'bibendum@diamvelarcu.com', 'massa.lobortis.ultrices@dolornonummyac.com'
    , 'et.malesuada.fames@duinec.co.uk', 'ligula.elit.pretium@sedsemegestas.org', 'tristique.pharetra.Quisque@maurisipsum.edu', 'auctor.velit.eget@sociis.net'
    , 'Lorem@magnisdis.co.uk');
    fnames arr_fname := arr_fname('Lacy', 'Salvador', 'Elliott', 'Amal', 'Nayda', 'Kaitlin', 'Sybil', 'Adria', 'Addison', 'Uriel'
    , 'Kirestin', 'Cathleen', 'Constance', 'Hedley', 'Thane', 'Colby', 'Sage', 'Laurel', 'Zelda', 'Teegan', 'Whoopi', 'Nelle', 'Kadeem'
    , 'Basil', 'Hadley', 'Riley', 'Sage', 'Grant', 'Steel', 'Jason', 'Bruno', 'Lenore', 'Rina', 'Sarah', 'Aidan', 'Lois', 'Meghan'
    , 'Scott', 'Tatyana', 'Guinevere', 'Madeson', 'Brielle', 'Irene', 'Elton', 'Reese', 'Quinlan', 'Tallulah', 'Igor', 'Maisie', 'Hyacinth'
    , 'Kyle', 'Raja', 'Briar', 'Ori', 'Vance', 'Eaton', 'Mark', 'Rinah', 'Colleen', 'Harlan', 'Jasmine', 'Venus');
    lnames arr_lname := arr_lname('Doyle', 'Ayala', 'Franks', 'Howard', 'Conway', 'Black', 'Armstrong', 'Oneil', 'Jennings', 'Skinner'
    , 'Conner', 'Barlow', 'Mcpherson', 'Petersen', 'Knight', 'Fischer', 'Norris', 'Watkins', 'Knox', 'Serrano', 'Holman', 'Hahn',
    'Bowman', 'Oliver', 'Leach', 'Klein', 'Eaton', 'Rosa', 'Kinney', 'Whitaker', 'Richmond', 'Greene', 'Hobbs', 'Woodard', 'Richmond'
    , 'Spence', 'Fisher', 'Macdonald', 'Klein', 'Lott', 'Cook', 'Mosley', 'Rush', 'Kent', 'Spence', 'Dorsey', 'Wilder', 'Mccoy', 'Johns'
    );
    addresses arr_address := arr_address('756-8493 Suspendisse Avenue', '4153 Nunc St.', '4605 Ut', '933-1839 Est', '377-2324 Sem Road'
    , 'Ap #764-2085 Laoreet Road', '701-9283 Purus', '680-3538 Ornare Street', '964-4781 Elit Avenue', 'P.O. Box 273', 'P.O. Box 315'
    , '9013 Et,', 'P.O. Box 955', '903-7237 Pellentesque Road', 'Ap #382-2441 Eu', '659-9159 Tempor Street', 'Ap #835-3987 Rutrum'
    , '9771 Tincidunt Ave', '469-7774 Ipsum Road', 'P.O. Box 215', '556-8248 Rutrum Rd.', '9544 Magna Road', 'Ap #765-454 Mauris St.'
    , '125-5915 Cursus Rd.', '550-6788 Ante. Ave', 'Ap #264-278 Est', '982-677 Montes', 'Ap #503-2662 Quisque St.', 'P.O. Box 414'
    , '9587 Mauris Rd.');
    phones arr_phone := arr_phone('(178) 285-7498', '(056) 506-4836', '(504) 721-1566', '(523) 815-8731', '(683) 710-9561', '(775) 449-0126'
    , '(615) 717-9499', '(418) 451-2199', '(323) 484-9393', '(758) 991-5821', '(791) 428-1790', '(054) 974-8728', '(053) 553-7003'
    , '(802) 901-7991', '(503) 212-6567', '(025) 460-0240', '(340) 830-9569', '(718) 139-3585', '(358) 955-6091', '(244) 010-1070'
    , '(445) 130-9523', '(062) 967-4101', '(656) 774-0072', '(797) 601-8203', '(618) 410-9987', '(190) 096-1833', '(126) 656-5591'
    , '(258) 737-3830', '(131) 852-6926', '(404) 215-1901', '(998) 734-4166', '(276) 761-4669', '(994) 744-3651', '(888) 299-1041'
    , '(714) 914-9812', '(151) 625-5380', '(310) 216-5078', '(040) 858-6265');  

    TYPE arr_make IS
        VARRAY(500) OF cars.make%TYPE;
        
    TYPE arr_model IS
        VARRAY(500) OF cars.model%TYPE;

    TYPE arr_color IS
        VARRAY(500) OF cars.color%TYPE;

    type arr_fuel is varray(3) of cars.fuel_type%type;

        
            make_list arr_make := arr_make('Audi', 'Dacia', 'Hyundai Motors', 'Daihatsu', 'Mazda', 'Daihatsu', 'Isuzu', 'Nissan', 'Toyota'
    , 'JLR', 'Volkswagen', 'Buick', 'Hyundai Motors', 'Isuzu', 'Subaru', 'Renault', 'Citroën', 'Kia Motors', 'Lexus', 'Renault',
    'Citroën', 'Vauxhall', 'Volvo');
    model_list arr_model := arr_model('A4', 'Logan', 'Sonata', 'DeLorean', '6', 'Copen', 'D-max', 'Patrol', 'Hilux', 'C-type', 'Passat'
    , 'Special', 'Accent', 'Trooper', 'Legacy', 'Clio', 'DS', 'Cee`d', 'LFA', 'Zoe', 'C5', 'Viva', 'Amazon');
    color_list arr_color := arr_color('Emerald', 'Red', 'Blue', 'yellow', 'green', 'Yellow', 'Pink', 'Black', 'White', 'Orange', 'Brown'
    , 'Lightgrey', 'Wheat', 'Lightblue', 'Purple', 'Aquamarine', 'Lion', 'Limen', 'Orchid', 'Rose', 'Fucsia', 'Ash grey', 'Azure mist'
    , 'Burnt Umber');
    
    v_fuel arr_fuel := arr_fuel ('Disel','Gasoline');
    
    -- counts
    v_tags_count number(38);
    v_resources_count number(38);
    v_users_count number(38);
    v_phone_numbers_count number(38);
    v_resource_tags_count number(38);
    v_user_addresses_count number(38);
    v_user_prefered_tags_count number(38);
    v_cars_count number(38);

    -- file work
--    create or replace procedure reading is
--    v_file utl_file.file_type;
    v_line varchar2(1024);
    v_index integer :=1;
    v_plate varchar2(20);

    -- randoms
    rng PLS_INTEGER;
    rng2 PLS_INTEGER;
    rng3 PLS_INTEGER;
    rng4 PLS_INTEGER;
    rng5 PLS_INTEGER;
    rng6 PLS_INTEGER;
    rng7 PLS_INTEGER;
    rng8 PLS_INTEGER;
    rdg date;
    
    

begin
--
--    v_file := utl_file.fopen ('DIR_TMP','author.csv','r');
--    loop
--        utl_file.get_line (v_file, v_line);
----        dbms_output.putline(v_line);
--        authors.extend;
--        authors(v_index) := v_line;
--        v_index := v_index + 1;                
--    end loop;
--    utl_file.fclose(v_file);
--
--    -- csvs please
--    
--    -- read 'tags.cvs'
--    v_index := 1;
--    v_file := utl_file.fopen ('DIR_TMP','tags.csv','r');
--    loop
--        utl_file.get_line (v_file, v_line);
----        dbms_output.putline(v_line);
--        tags.extend;
--        tags(v_index) := v_line;
--        v_index := v_index + 1;                
--    end loop;
--    utl_file.fclose(v_file);
--

    for v_i in 1..200000 loop
        rng := trunc(dbms_random.value(0,tag_list.count)+1);

        insert into tags values (v_i,rng);
    end loop;

    select count(*) into v_tags_count from tags;


    -- populate resources
    for v_i in 1..200000 loop
        rng := trunc(dbms_random.value(0,titles.count)+1);
        rng2 := trunc(dbms_random.value(0,authors.count)+1);
        rng3 := trunc(dbms_random.value(0,descriptions.count)+1);
        rdg := to_date(trunc(dbms_random.value(to_char(date '2000-01-01','J')
                                    ,to_char(date '2019-12-31','J'))),'J');

        insert into resources values(v_i,titles(rng),authors(rng2), rdg, descriptions(rng3));
        
        -- resource has 0..5 tags
        rng := trunc(dbms_random.value(0,6));
        while rng > 0 loop
            rng2 := trunc(dbms_random.value(0,v_tags_count)+1);
            insert into resource_tags values (v_i, rng2);
            rng := rng - 1;
        end loop;

    end loop;

    select count(*) into v_resources_count from resources;
    
    for v_i in 1..200000 loop
        rng := trunc(dbms_random.value(0,emails.count)+1);
        rng4 := trunc(dbms_random.value(0,fnames.count)+1);
        rng2 := trunc(dbms_random.value(0,lnames.count)+1);
        rdg :=to_date(trunc(dbms_random.value(to_char(date '1950-01-01','J')
                                    ,to_char(date '2006-12-31','J'))),'J');

        insert into users values (v_i, emails(rng), fnames(rng4),lnames(rng2),rdg);

        -- user has 0,1 or 2 addresses
        rng := trunc(dbms_random.value(0,3));
        while rng > 0 loop
            rng5 := trunc(dbms_random.value(0,addresses.count)+1);
            insert into user_addresses values (v_i,addresses(rng5));
            rng := rng - 1;
        end loop;

        -- user has 0,1 or 2 phone numbers
        rng := trunc(dbms_random.value(0,3));
        while rng > 0 loop
            rng6 := trunc(dbms_random.value(0,phones.count)+1);
            insert into phone_numbers values (v_i,phones(rng6));
            rng := rng - 1;
        end loop;

        -- user has 0..5 prefered tags
        rng := trunc(dbms_random.value(0,6));
        while rng > 0 loop
            rng7 := trunc(dbms_random.value(0,v_tags_count)+1);
            insert into user_prefered_tags values (v_i,rng7);
            rng := rng - 1;
        end loop;

        -- user has 0..5 saved resources
        rng := trunc(dbms_random.value(0,6));
        while rng > 0 loop
            rng8 := trunc(dbms_random.value(0,v_resources_count)+1);
            insert into user_saved_resources values (v_i, rng8);
            rng := rng - 1;
        end loop;
        
    end loop;

    select count(*) into v_users_count from users;

    for v_i in 1..50000 loop
        rng := trunc(dbms_random.value(1,22));
        rng3 := trunc(dbms_random.value(1,color_list.count));
        rng4 := trunc(dbms_random.value(1,v_users_count));
        rng5 := trunc(dbms_random.value(1999,2020));
        rng6 := trunc(dbms_random.value(1,5));
        rng7 := trunc(dbms_random.value(0,2)+1);
    
                                
        insert into cars values (rng4,dbms_random.string('x',7),make_list(rng),model_list(rng),rng5,rng6,v_fuel(rng7) ,color_list(rng3));
        
    end loop;

    select count(*) into v_cars_count from cars;
    select count(*) into v_phone_numbers_count from phone_numbers;
    select count(*) into v_resource_tags_count from resource_tags;
    select count(*) into v_resources_count from resources;
    select count(*) into v_tags_count from tags;
    select count(*) into v_user_addresses_count from user_addresses;
    select count(*) into v_user_prefered_tags_count from user_prefered_tags;
    select count(*) into v_users_count from users;
    
    dbms_output.put_line('Tabela USERS are ' || v_users_count || ' inregistrari.');
    dbms_output.put_line('Tabela PHONE_NUMBERS are ' || v_phone_numbers_count || ' inregistrari.');
    dbms_output.put_line('Tabela USER_ADDRESSES are ' || v_user_addresses_count || ' inregistrari.');
    dbms_output.put_line('Tabela USER_PREFERED_TAGS are ' || v_user_prefered_tags_count|| ' inregistrari.');
    dbms_output.put_line('Tabela RESOURCES are ' || v_resources_count || ' inregistrari.');
    dbms_output.put_line('Tabela RESOURCE_TAGS are ' || v_resource_tags_count || ' inregistrari.');
    dbms_output.put_line('Tabela TAGS are ' || v_tags_count || ' inregistrari.');
    
exception
when no_data_found then
    dbms_output.put_line ('End file');
end;


