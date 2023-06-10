--- Login Table Creation
create table login(login_id varchar(20) constraint login_loginid_pk primary key, password varchar(20) constraint login_password_nn not null,
                   login_type varchar(10) constraint login_logintype_ck check(login_type in('ADMIN','USER')),
                   login_time date,logout_time date)
alter table login add login_type varchar(10) constraint login_logintype_ck check(login_type in('ADMIN','USER'))
alter table login modify login_time timestamp with time zone

--- User Table Creation
create table users(user_id varchar(8) constraint users_userid_pk primary key, 
                    login_id varchar(20),
                   first_name varchar(20) constraint users_first_name_nn not null,
                   last_name varchar(20) constraint users_last_name_nn not null,
                   DOB date, 
                   mobile_no number(10) constraint users_mobileno_uknn unique not null,
                   email_id varchar(35) constraint users_emailid_uknn unique not null,
                   subscription_id varchar(10) constraint users_subscription_uknn unique ,
                   country varchar(20) constraint users_country_nn not null,
                   constraint users_loginid_fk foreign key(login_id) REFERENCES login(login_id))  
--- Admin Table Creation                  
create table Admin(Admin_id varchar(20) constraint admin_userid_pk primary key, 
                   first_name varchar(20) constraint admin_first_name_nn not null,
                   last_name varchar(20) constraint admin_last_name_nn not null,
                   mobile_no number(10) constraint admin_mobileno_uknn unique not null,
                   email_id varchar(35) constraint admin_emailid_uknn unique not null,
                   Role varchar(20) constraint admin_role_nn not null,
                   constraint admin_loginid_fk foreign key(Admin_id) REFERENCES login(login_id))
--- Subscription Table Creation        
create table subscription( subscription_id varchar(10) constraint sub_subscriptionid_pk primary key,
                           subscription_type varchar(20) constraint sub_subscriptiontype_cc check(subscription_type in('VIP','PREMIUM')),
                           subscription_date date constraint sub_subscriptiondate_nn not null,
                           transaction_id number(10) constraint sub_transactionid_uknn unique not null,
                           constraint sub_subscriptionid_fk foreign key(subscription_id) references users(subscription_id))
                           
--- Content Table Creation 
create table content_table(content_id varchar(6) constraint content_content_id_pk primary key,
                           content_name varchar(20) constraint content_content_name_nn not null,
                           content_type varchar(10) constraint content_content_name_ck check ( content_type in('TV_SHOWS','SERIES','MOVIES')),
                           release_date date,
                           IMDB_rating number(2,1) constraint content_imdb_ck check(IMDB_rating<=10),
                           director_name varchar(20),
                           censor_certificate char(3) constraint content_censorcertificate_ck check(censor_certificate in('U','U/A','A')),
                           access_type varchar(10) constraint content_accesstype_ck check(access_type in('FREE','VIP','PREMIUM')))
                           
--- SHOWS_SERIES Table Creation
create table shows_series_table(content_id varchar(6),season_no number(3),episode_no number(5),
                                episode_name varchar(30) CONSTRAINT shows_episode_nn not null,
                                length varchar(6),
                                constraint shows_compositekey primary key(content_id,season_no,episode_no),
                                constraint shows_contentid_fk foreign key(content_id) references content_table(content_id))

--- Cast Table Creation
create table cast(cast_id number(6),cast_name varchar(20) constraint cast_cast_name_nn not null,
                  constraint cast_castid_pk primary key(cast_id))
                  
--- Role Table Creation
create table role_table(content_id varchar(6),cast_id number(6),
                        role_name varchar(20) constraint role_rolename_nn not null,
                        constraint role_compositekey primary key(content_id,cast_id),
                        constraint role_content_id_fk foreign key(content_id) REFERENCES content_table(content_id),
                        constraint role_castid_fk foreign key(cast_id) REFERENCES cast(cast_id))
                        
--- Language Table Creation
create table language(language_id number(3),language_name varchar(20) constraint language_language_name_nn not null,
                  constraint language_language_id_pk primary key(language_id))
                  
--- Content_Language Table Creation
create table content_language(content_id varchar(6),language_id number(6),
                        constraint conlanguage_compositekey primary key(content_id,language_id),
                        constraint conlanguage_content_id_fk foreign key(content_id) REFERENCES content_table(content_id),
                        constraint conlanguage_castid_fk foreign key(language_id) REFERENCES language(language_id))

--- Genre Table Creation
create table genre(genre_id number(3),genre_name varchar(20) constraint genre_genre_name_nn not null,
                  constraint genre_genre_id_pk primary key(genre_id))

---  Content_Genre Table Creation
create table content_genre(content_id varchar(6),genre_id number(3),
                        constraint contentgenre_compositekey primary key(content_id,genre_id),
                        constraint contentgenre_content_id_fk foreign key(content_id) REFERENCES content_table(content_id),
                        constraint contentgenre_castid_fk foreign key(genre_id) REFERENCES genre(genre_id))
                        
--- Director Table Creation
create table producers(producer_id number(6), producer_name varchar(20) constraint producer_producer_name_nn not null,
                      constraint producer_producer_id_pk primary key(producer_id))

--- ProducedBy Table Creation
create table producedby(content_id varchar(6),producer_id number(6),
                        constraint contentproducer_compositekey primary key(content_id,producer_id),
                        constraint contentproducer_content_id_fk foreign key(content_id) REFERENCES content_table(content_id),
                        constraint contentproducer_producerid_fk foreign key(producer_id) REFERENCES producers(producer_id))
                        
--- inserting values in LOGIN Table

insert into login values('A00001','S@nn@123',null,null,'ADMIN');
insert into login values('A00002','M#$k@543',null,null,'ADMIN');
insert into login values('A00003','Ang%l^na@387',null,null,'ADMIN');
insert into login values('A00004','Prad#!p007',null,null,'ADMIN');
insert into login values('A00005','L*v*lina145',systimestamp,null,'ADMIN');
insert into login values('A00006','D@vid@832',systimestamp,null,'ADMIN');
insert into login values('A00007','S@m872',systimestamp,null,'ADMIN');
insert into login values('A00008','Sam**r@123',systimestamp,null,'ADMIN');
insert into login values('A00009','Rav#n@90',systimestamp,null,'ADMIN');
insert into login values('A00010','Br$ad750',systimestamp,null,'ADMIN');
insert into login values('shreesh12','Shreesh@18',systimestamp,systimestamp,'USER');
insert into login values('margot91','m@rgot12',systimestamp,null,'USER');
insert into login values('sandy45','s@nd#5',systimestamp,null,'USER');
insert into login values('lenin99','le*in@99',systimestamp,null,'USER');
insert into login values('sakshi98','s@kshi@98',systimestamp,null,'USER');
insert into login values('cameronw','wcam*r*n@18',systimestamp,null,'USER');
insert into login values('shamshim1999','1999@shamshi',systimestamp,null,'USER');
insert into login values('kartikgouda1999','gouda@kartik',systimestamp,null,'USER');
insert into login values('aliabhatt143','alia@1995',systimestamp,null,'USER');
insert into login values('virat18','virat@18',systimestamp,null,'USER');
insert into login values('anushkavirat18','nush@18',systimestamp,null,'USER');
insert into login values('harbhajan19','harbhajan@1985',systimestamp,null,'USER');
insert into login values('ravindraj','jadeja@333',systimestamp,null,'USER');
insert into login values('sandy45','s@nd#5',systimestamp,null,'USER');
insert into login values('mayuri1999','mayuri@99',systimestamp,null,'USER');
insert into login values('sam93','sam@1993',null,null,'USER');
insert into login values('Davidbrown','br@wnd#vid',systimestamp,null,'USER');
insert into login values('eshaguha12','esha@12',systimestamp,null,'USER');
insert into login values('tylor85','tylorwood@12',systimestamp,null,'USER');
insert into login values('bradhoge19','brad@1999',systimestamp,null,'USER');
insert into login values('bishop178','bishop@11',null,null,'USER');

-------------------------------------------------------------------------------------------------------------------
create sequence userid_seq
start with 1
increment by 1
cache 50

--- inserting values in User Table
insert into users values('U00000'||userid_seq.nextval,'shreesh12','shreesh','badiger','12-10-98',9008004675,'imshreesh18@gmail.com','1544319853','INDIA')
insert into users values('U00000'||userid_seq.nextval,'margot91','margot','robie','16-08-85',9275397001,'margot1985@gmail.com','1594314883','USA')
insert into users values('U00000'||userid_seq.nextval,'kartikgouda1999','kartik','patil','03-08-99',9265428901,'kartikpatil99@gmail.com','1544319653','INDIA')
insert into users values('U00000'||userid_seq.nextval,'lenin99','lenin','jackson','12-10-99',8431006795,'leninj99@gmail.com','1544319765','UK')
insert into users values('U00000'||userid_seq.nextval,'sandy45','sandeep','p','21-11-99',9776587354,'sandyp45@gmail.com','1544319423','INDIA')
insert into users values('U00000'||userid_seq.nextval,'sakshi98','sakshi','mehta','23-05-98',9008854675,'sakshimehta98@gmail.com','1544319979','INDIA')
insert into users values('U00000'||userid_seq.nextval,'cameronw','cameron','white','11-09-83',9764389739,'cameronwhite12@gmail.com','1536319876','AUSTRALIA')
insert into users values('U00000'||userid_seq.nextval,'shamshim1999','shamshi','maksood','21-07-99',9005603175,'shamshi1999@gmail.com','1544317654','QATAR')
insert into users values('U00000'||userid_seq.nextval,'aliabhatt143','alia','bhatt','28-07-95',9007432871,'aliabhatt14@gmail.com','1544316523','INDIA')
insert into users values('U00000'||userid_seq.nextval,'virat18','virat','kohli','05-11-89',9276541900,'viratkohli@gmail.com','1544319562','INDIA')
insert into users values('U00000'||userid_seq.nextval,'anushkavirat18','anushka','sharma','14-05-90',9008008742,'nushsharma@gmail.com',null,'INDIA')
insert into users values('U00000'||userid_seq.nextval,'ravindraj','ravindra','jadeja','20-07-90',9727700711,'sirjaddu@gmail.com',null,'INDIA')
insert into users values('U00000'||userid_seq.nextval,'harbhajan19','harbhajan','singh','16-03-83',9005375602,'harbhajan333@gmail.com',null,'INDIA')
insert into users values('U00000'||userid_seq.nextval,'sam93','sam','billings','23-02-93',9008317895,'sam93billings@gmail.com',null,'UK');
insert into users values('U00000'||userid_seq.nextval,'mayuri1999','mayuri','sankal','21-01-99',8752074004,'mayurisankal@gmail.com','1544319848','INDIA');
insert into users values('U00000'||userid_seq.nextval,'Davidbrown','david','brown','09-04-82',9237639166,'davidbrown12@gmail.com','1544319898','AUSTRALIA');
insert into users values('U00000'||userid_seq.nextval,'eshaguha12','esha','guha','04-05-85',9128905421,'eshaguha54@gmail.com',null,'UK');
insert into users values('U00000'||userid_seq.nextval,'tylor85','tylor','swift','16-05-85',8735554675,'swifttaylor85@gmail.com','1544319874','USA');
insert into users values('U00000'||userid_seq.nextval,'bradhoge19','brad','hoge','12-01-80',8638904675,'bardh19@gmail.com',null,'AUSTRALIA');
insert into users values('U00000'||userid_seq.nextval,'bishop178','bishop','ian','09-12-64',9093574125,'bishop178@gmail.com','1644619853','JAMAICA');

--- inserting values in Admin Table
insert into admin values('A00001','sana','joseph',8735701267,'sanaj@ott.com','DBA');
insert into admin values('A00002','mark','wood',8651096364,'mark12@ott.com','CENSOR MANAGER');
insert into admin values('A00003','angelina','cook',9064250022,'angelinac@ott.com','DBA');
insert into admin values('A00004','pradeep','patil',9775632175,'pradeepp@ott.com','INDIAN_DBA');
insert into admin values('A00005','lovalina','stark',7004883218,'lovalina@ott.com','DBA');
insert into admin values('A00006','david','joseph',8738774332,'davidj@ott.com','DBA');
insert into admin values('A00007','sam','corda',8735007551,'samc@ott.com','CENSOR_MANAGER');
insert into admin values('A00008','sameer','patel',8735742166,'sameerp@ott.com','SHOWS_MANAGER');
insert into admin values('A00009','raveena','pandit',9006701267,'raveenap@ott.com','SHOWS_MANAGER');
insert into admin values('A00010','straut','board',8735551267,'strautb@ott.com','INDIAN_DBA');

--- inserting values in Subscription Table
insert into subscription values('1544319853','VIP','25-10-2020','1564382643');
insert into subscription values('1594314883','PREMIUM','15-08-2021','4527864589');
insert into subscription values('1544319653','VIP','05-04-2021','4573091187');
insert into subscription values('1544319765','VIP','21-12-2020','1892028238');
insert into subscription values('1544319423','PREMIUM','11-01-2021','1892890688');
insert into subscription values('1544319979','PREMIUM','21-02-2020','6632890012');
insert into subscription values('1544317654','VIP','18-03-2021','6643786543');
insert into subscription values('1536319876','PREMIUM','09-05-2021','5623890034');
insert into subscription values('1544316523','VIP','17-05-2020','4476221367');
insert into subscription values('1544319562','VIP','15-01-2021','7623908564');
insert into subscription values('1544319848','PREMIUM','21-12-2020','6890775432');
insert into subscription values('1544319898','VIP','08-07-2021','6543769801');
insert into subscription values('1644619853','PREMIUM','21-08-2021','1892632190');
insert into subscription values('1544319874','PREMIUM','11-06-2021','7692200979');

--- creating sequence for Content Table
create sequence content_id_seq
start with 1
increment by 1
cache 50

--- inserting values in Content Table
insert into content_table values('C'||lpad(content_id_seq.currval,5,'0'),'KGF- CHAPTER 1','MOVIES','20-12-2018',8.3,'prashant neel','U/A','VIP');
insert into content_table values('C'||lpad(content_id_seq.nextval,5,'0'),'SHERSHAAH','MOVIES','12-08-2021',8.9,'vishnuvardhan','U/A','PREMIUM');
insert into content_table values('C'||lpad(content_id_seq.nextval,5,'0'),'THE EMPIRE','SERIES','27-08-2021',3.4,'mitakshara kumar','A','PREMIUM');
insert into content_table values('C'||lpad(content_id_seq.nextval,5,'0'),'TAARAK MEHTA KA OOLTAH CHASHMAH','TV_SHOWS','28-07-2008',8.2,'dharmesh mehta','U','FREE');
insert into content_table values('C'||lpad(content_id_seq.nextval,5,'0'),'96','MOVIES','04-10-2018',8.6,'c prem kumar','U','VIP');

--- inserting values in Shows_Series_Table Table
insert into shows_series_table values('C00052',1,1,'NOT THE KING BUT THE KINGMAKER','40:33');
insert into shows_series_table values('C00052',1,2,'THE PANTHERS PROWL','41:41');
insert into shows_series_table values('C00052',1,3,'THE SEPARATION','51:57');
insert into shows_series_table values('C00052',1,4,'ALLIANCES','44:11');
insert into shows_series_table values('C00052',1,5,'The Roar Of The Lion','42:47');
insert into shows_series_table values('C00052',1,6,'REQUIEM','40:15');
insert into shows_series_table values('C00052',1,7,'PANIPAT','43:23');
insert into shows_series_table values('C00052',1,8,'The Beginning','30:34');
insert into shows_series_table values('C00053',1,3103,'Sodhi Poses As Crorepati', null);
insert into shows_series_table values('C00053',1,3104,'Jethalal Meets Bhogilal', null);
insert into shows_series_table values('C00053',1,3115,'Bhogilal Is Sundars Client', null);
insert into shows_series_table values('C00053',1,3116,'Gokuldham Against Bhogilal', null);
insert into shows_series_table values('C00053',1,3117,'Bhogilal Arrives', null);
insert into shows_series_table values('C00053',1,3118,'Bhogilal Meets Bapuji', null);
insert into shows_series_table values('C00053',1,3119,'Bapuji Signs The Papers', null);
insert into shows_series_table values('C00053',1,3120,'Bhagwaan Bhogilal Ka BhalaKare', null);

--- inserting in genre table
insert into genre values(1,'ACTION');
insert into genre values(2,'ROMANCE');
insert into genre values(3,'DRAMA');
insert into genre values(4,'THRILLER');
insert into genre values(5,'ADVENTURE');
insert into genre values(6,'HISTORICAL FICTION');
insert into genre values(7,'SCI-FI');
insert into genre values(8,'WAR');
insert into genre values(9,'ROMANCE');
insert into genre values(10,'COMEDY');
insert into genre values(11,'DOCUMENTARY');
insert into genre values(12,'MELODRAMA');
insert into genre values(13,'CHILDREN FILM');
insert into genre values(14,'SITCOM');

--- inserting values in Content_Genre
insert into content_genre values('C00001',1);
insert into content_genre values('C00001',2);
insert into content_genre values('C00001',3);
insert into content_genre values('C00001',4);
insert into content_genre values('C00001',5);
insert into content_genre values('C00051',1);
insert into content_genre values('C00051',8);
insert into content_genre values('C00052',3);
insert into content_genre values('C00052',6);
insert into content_genre values('C00053',3);
insert into content_genre values('C00053',14);
insert into content_genre values('C00053',13);
insert into content_genre values('C00053',10);
insert into content_genre values('C00054',3);
insert into content_genre values('C00054',2);

create sequence cast_castid_seq
start with 1
increment by 1

--- inserting values into cast
insert into cast values(cast_castid_seq.nextval,'YASH');
insert into cast values(cast_castid_seq.nextval,'SRINIDHI SHETTY');
insert into cast values(cast_castid_seq.nextval,'ANANT NAG');
insert into cast values(cast_castid_seq.nextval,'VASISHTA SIMHA');
insert into cast values(cast_castid_seq.nextval,'RAMACHANDRA RAJU');
insert into cast values(cast_castid_seq.nextval,'MALVIKA');
insert into cast values(cast_castid_seq.nextval,'ARCHANA JOIS');
insert into cast values(cast_castid_seq.nextval,'DINESH MANGALURU');
insert into cast values(cast_castid_seq.nextval,'ACHYUTH KUMAR');
insert into cast values(cast_castid_seq.nextval,'SIDHARTH MALHOTRA');
insert into cast values(cast_castid_seq.nextval,'KIARA ADVANI');
insert into cast values(cast_castid_seq.nextval,'SHIV PANDIT');
insert into cast values(cast_castid_seq.nextval,'NIKTHIN DEER');
insert into cast values(cast_castid_seq.nextval,'MANMEET KAUR');
insert into cast values(cast_castid_seq.nextval,'SAHIL VAID');
insert into cast values(cast_castid_seq.nextval,'KUNAL KAPOOR');
insert into cast values(cast_castid_seq.nextval,'SAHHER BAMBBA');
insert into cast values(cast_castid_seq.nextval,'DINO MOREA');
insert into cast values(cast_castid_seq.nextval,'DRHASTI DHAMI');
insert into cast values(cast_castid_seq.nextval,'RAHUL DEV');
insert into cast values(cast_castid_seq.nextval,'ADITYA SEAL');
insert into cast values(cast_castid_seq.nextval,'SHABANA AZMI');
insert into cast values(cast_castid_seq.nextval,'VIJAY SETUPATHI');
insert into cast values(cast_castid_seq.nextval,'TRISHA');
insert into cast values(cast_castid_seq.nextval,'DILIP JOSHI');
insert into cast values(cast_castid_seq.nextval,'DISHA VAKANI');
insert into cast values(cast_castid_seq.nextval,'BHAVYA GANDHI');
insert into cast values(cast_castid_seq.nextval,'MUNMUN DATTA');
insert into cast values(cast_castid_seq.nextval,'NEHA MEHTA');
insert into cast values(cast_castid_seq.nextval,'SHAILESH LODHA');
insert into cast values(cast_castid_seq.nextval,'NIDHI BHANUSHALI');

--- inserting values in role table
insert into role_table values('C00001',1,'SHANTAMMA(ROCKY MOM)');
insert into role_table values('C00001',2,'ROCKY BHAI');
insert into role_table values('C00001',3,'REENA(ROCKY GF)');
insert into role_table values('C00001',4,'ANAND INGALGI');
insert into role_table values('C00001',5,'KAMAL(DON)');
insert into role_table values('C00001',6,'GARUDA(VILLAN)');
insert into role_table values('C00001',7,'DEEPA HEGDE');
insert into role_table values('C00001',8,'SHETTY(DON)');
insert into role_table values('C00001',9,'GURU PANDIAN');
insert into role_table values('C00051',10,'VIKRAM BATRA');
insert into role_table values('C00051',11,'DIMPLE CHEEMA');
insert into role_table values('C00051',12,'SINGH JASROTIA');
insert into role_table values('C00051',13,'MONA');
insert into role_table values('C00051',14,'AMIT');
insert into role_table values('C00052',15,'BABUR');
insert into role_table values('C00052',16'MAHAM BEGUM');
insert into role_table values('C00052',17,'SHAYBANI KHAN');
insert into role_table values('C00052',18,'KHANZADA');
insert into role_table values('C00052',19,'WAZIR KHAN');
insert into role_table values('C00052',20,'HUMAYUN');
insert into role_table values('C00052',21,'ASAIN DAULAT BEGUM');
insert into role_table values('C00054',22,'JANU');
insert into role_table values('C00054',25,'RAM');
insert into role_table values('C00053',23,'JETHALAL GADA');
insert into role_table values('C00053',24,'DAYA GADA');
insert into role_table values('C00053',26,'TEPENDRA aka TAPPU');
insert into role_table values('C00053',27,'BABITHA IYER');
insert into role_table values('C00053',28,'ANJALI MEHTA');
insert into role_table values('C00053',29,'TAARAK MEHTA');
insert into role_table values('C00053',30,'SONU BHIDE');

--- inserting values into Language
insert into language values(1,'KANNADA');
insert into language values(2,'HINDI');
insert into language values(3,'TAMIL');
insert into language values(4,'TELUGU');
insert into language values(5,'MALAYALAM');
insert into language values(6,'ENGLISH');
insert into language values(7,'FRENCH');
insert into language values(8,'SPANISH');
insert into language values(9,'MARATHI');
--- inserting values into Content_Language
insert into content_language values('C00001',1);
insert into content_language values('C00001',2);
insert into content_language values('C00001',3);
insert into content_language values('C00001',4);
insert into content_language values('C00001',5);
insert into content_language values('C00051',2);
insert into content_language values('C00052',1);
insert into content_language values('C00052',2);
insert into content_language values('C00052',3);
insert into content_language values('C00052',4);
insert into content_language values('C00052',5);
insert into content_language values('C00052',9);
insert into content_language values('C00053',2);
insert into content_language values('C00054',3);

--- inserting values in Producers
insert into producers values(1,'HOMBALE FILMS');
insert into producers values(2,'EXCEL CINEMAS');
insert into producers values(3,'DHARMA PRODUCTION');
insert into producers values(4,'KAASH ENTERTAINMENT');
insert into producers values(5,'EMMAY ENTERTAINMENT');
insert into producers values(6,'ASIT KUMAR MODI');
insert into producers values(7,'MADRAS ENTERPRISES');
insert into producers values(8,'AA FILMS');

--- inserting values in Producedby Table
insert into producedby values('C00001',1);
insert into producedby values('C00001',2);
insert into producedby values('C00001',8);
insert into producedby values('C00051',3);
insert into producedby values('C00051',4);
insert into producedby values('C00052',5);
insert into producedby values('C00053',6);
insert into producedby values('C00054',7);