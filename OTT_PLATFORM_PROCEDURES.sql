create sequence userid_seq
start with 21
increment by 1

--- Adding New User in Table
create or Replace package PKG_AddNewUser
as
    PROCEDURE PRC_NEWUSER(P_loginid in Login.login_id%type,P_Password in Login.password%type,
                          P_firstname in users.first_name%type,P_lastname in users.last_name%type,P_DOB in Users.DOB%type,
                          P_mobile in Users.Mobile_NO%type,P_emailid in Users.EMAIL_ID%type,P_country in users.country%type);
end;

create or Replace package body PKG_AddNewUser
as
    PROCEDURE PRC_NEWUSER(P_loginid in Login.login_id%type,P_Password in Login.password%type,
                          P_firstname in users.first_name%type,P_lastname in users.last_name%type,P_DOB in Users.DOB%type,
                          P_mobile in Users.Mobile_NO%type,P_emailid in Users.EMAIL_ID%type,P_country in users.country%type)
is
begin
insert into login values(P_loginid,P_Password,null,null,'USER');
insert into users values('U'||lpad(USERID_SEQ.nextval,6,'0'),P_loginid,P_firstname,P_lastname,P_DOB,P_mobile,P_emailid,null,P_country);
end;
end;

--- fetching details of login client for validation
create or REPLACE package fetch_loginDetails 
as 
    Procedure login_prc(p_password out login.password%type,p_login_type out login.login_type%type,p_login_id in login.login_id%type);
end fetch_loginDetails;

create or REPLACE package body fetch_loginDetails 
as 
    Procedure login_prc(p_password out login.password%type,p_login_type out login.login_type%type,p_login_id in login.login_id%type)
    is
    begin
    select password,login_type into p_password,p_login_type from login where login_id=p_login_id;
    end;
end fetch_loginDetails;


--- updating login_time in login table
create or REPLACE package update_logindetails 
as 
    Procedure SignIn_prc(p_login_id in login.login_id%type);
end update_logindetails;

create or REPLACE package body update_logindetails 
as 
    Procedure SignIn_prc(p_login_id in login.login_id%type)
    is
    begin
    update login set Login_Time=systimestamp where Login_Id=p_login_id;
    end;
end update_logindetails;


--- getting details of logged in User
create or replace package PKG_USERDETAILS
as
    Procedure PRC_GetUserDetails(P_Name out varchar,P_DOB out users.dob%type,P_Mobile_NO out users.mobile_no%type,P_Email_ID out users.email_id%type,
                                 P_SUBSCRIPTION out subscription.subscription_type%type,P_loginid in users.user_id%type);
end PKG_USERDETAILS;

create or replace package body PKG_USERDETAILS
as
    Procedure PRC_GetUserDetails(P_Name out varchar,P_DOB out users.dob%type,P_Mobile_NO out users.mobile_no%type,P_Email_ID out users.email_id%type,
                                 P_SUBSCRIPTION out subscription.subscription_type%type,P_loginid in users.user_id%type)
    is
    v_userdetails users%rowtype;
    v_validate varchar(10);
    begin
    select * into v_userdetails from users where login_id=P_loginid;
    P_Name:=v_userdetails.first_name||' '||v_userdetails.last_name;
    P_DOB:=v_userdetails.DOB;
    P_Mobile_NO:=v_userdetails.Mobile_No;
    P_Email_ID:=v_userdetails.email_id;
    select subscription_id into v_validate from users where login_id=P_loginid;
    if(v_validate is null) then
        P_SUBSCRIPTION:='FREE';
    else
        select subscription_type into P_SUBSCRIPTION from subscription where subscription_id=(select subscription_id from users where login_id=P_loginid);
    end if;
    end;
end PKG_USERDETAILS;

--- Check Membership validity
create or replace package PKG_Membership_Validity 
as
PROCEDURE PRC_VALIDITY(P_Validity out date,P_LOGINID in users.login_id%type);
end PKG_Membership_Validity;

create or replace package body PKG_Membership_Validity 
as
PROCEDURE PRC_VALIDITY(P_Validity out date,P_LOGINID in users.login_id%type)
is
begin
select add_months(subscription_date,12) into P_Validity from subscription where subscription_id=(select subscription_id from users where login_id=P_LOGINID);
End;
end PKG_Membership_Validity;


--- Upgrade User Membership
create or replace package PKG_Membership_Upgrade 
as
PROCEDURE PRC_UPGRADE(P_loginId in users.login_id%type,P_membership in subscription.subscription_type%type);
end PKG_Membership_Upgrade;

create or replace package body PKG_Membership_Upgrade 
as
PROCEDURE PRC_UPGRADE(P_loginId in users.login_id%type,P_membership in subscription.subscription_type%type)
is
    v_subscriptionID users.subscription_id%type;
    Begin
        if(P_membership='FREE') then
            v_subscriptionID:=round(dbms_random.value(1000000000,9999999999));
            update users set subscription_id=v_subscriptionID  where login_id=P_loginId;
            insert into subscription values(to_char(v_subscriptionID),P_membership,sysdate,null);
        else
            update subscription set subscription_type=P_membership where subscription_id=(select subscription_id from users where login_id=P_loginId);
        end if;
End;
end PKG_Membership_Upgrade;


--- Fetching the Content from Content Table

create or replace package PKG_FetchContent
is
procedure PRC_CONTENT(rc_cursor out SYS_REFCURSOR);
end;

create or replace package body PKG_FetchContent
is
procedure PRC_CONTENT(rc_cursor out SYS_REFCURSOR)
as
begin
open rc_cursor for select content_name,content_type,IMDB_RATING,ACCESS_TYPE from content_table;
end;
end;

--- Fetching the cast from table
create or replace package PKG_fetchCAST
is
procedure PRC_CAST(rc_cursor out SYS_REFCURSOR,P_ContentName content_table.content_name%type);
end;

create or replace package body PKG_FetchCAST
is
procedure PRC_CAST(rc_cursor out SYS_REFCURSOR,P_ContentName content_table.content_name%type)
as
begin
open rc_cursor for select rt.role_name , cs.cast_name from content_table ct 
                   join role_table rt on rt.content_id=ct.content_id 
                   join cast cs on cs.cast_id=rt.cast_id where ct.content_name=P_ContentName;
end;
end;

--- Fetching the Language from table
create or replace package PKG_fetchLanguage
is
procedure PRC_LANGUAGE(rc_cursor out SYS_REFCURSOR,P_ContentName content_table.content_name%type);
end;

create or replace package body PKG_FetchLanguage
is
procedure PRC_LANGUAGE(rc_cursor out SYS_REFCURSOR,P_ContentName content_table.content_name%type)
as
begin
open rc_cursor for select l.language_name from content_table ct 
                   join content_language cl on cl.content_id=ct.content_id 
                   join language l on l.language_id=cl.language_id where ct.content_name=P_ContentName;
end;
end;

--- fetching Content Genre
create or replace package PKG_fetchGenre
is
procedure PRC_Genre(rc_cursor out SYS_REFCURSOR,P_ContentName content_table.content_name%type);
end;

create or replace package body PKG_FetchGenre
is
procedure PRC_Genre(rc_cursor out SYS_REFCURSOR,P_ContentName content_table.content_name%type)
as
begin
open rc_cursor for select g.genre_name from content_table ct 
                   join content_genre cg on cg.content_id=ct.content_id 
                   join genre g on g.genre_id=cg.genre_id where ct.content_name=P_ContentName;
end;
end;

--- fetching users log
create or replace package PKG_FetchUsers
is
procedure PRC_USERSLOG(rc_cursor out SYS_REFCURSOR);
end;

create or replace package body PKG_FetchUsers
is
procedure PRC_USERSLOG(rc_cursor out SYS_REFCURSOR)
as
begin
open rc_cursor for select u.first_name ||' '|| u.last_name, l.login_time from login l 
                   join users u on l.login_id=u.login_id where l.login_type='USER';
end;
end;

create sequence content_id_seq
start with 55
increment by 1

--- adding New Content in Content Table 
create or Replace package PKG_AddNewContent
as
    PROCEDURE PRC_NEWContent(P_ContentName in content_table.content_name%type,P_ContentType in content_table.content_type%type,
                          P_releasedate in content_table.release_date%type,P_rating in content_table.imdb_rating%type,P_Censor in content_table.censor_certificate%type,
                          P_Access in content_table.access_type%type);
end;

create or Replace package body PKG_AddNewContent
as
    PROCEDURE PRC_NEWContent(P_ContentName in content_table.content_name%type,P_ContentType in content_table.content_type%type,
                          P_releasedate in content_table.release_date%type,P_rating in content_table.imdb_rating%type,P_Censor in content_table.censor_certificate%type,
                          P_Access in content_table.access_type%type)
    is
    begin
    insert into content_table values('C'||lpad(content_id_seq.nextval,5,0),P_ContentName,P_ContentType,P_releasedate,P_rating,null,P_Censor,P_Access);
    end;
end;

