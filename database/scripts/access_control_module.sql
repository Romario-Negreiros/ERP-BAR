/* ACCESS_CONTROL_MODULE */
create schema access_control;

create table access_control.role (
	id serial primary key,
	name varchar(100) not null,
	description varchar(255) not null,
	created_at timestamp not null default current_timestamp,
	updated_at timestamp
);

create table access_control.user (
	id serial primary key,
	name varchar(255) not null,
	role_id int not null,
	created_at timestamp not null default current_timestamp,
	updated_at timestamp,
	constraint fk_role 
	  foreign key (role_id)
	  references access_control.role(id)
);

create or replace function fn_upd_timestamp()
returns trigger as $$
begin 
	new.updated_at := current_timestamp;
	return new;
end;
$$ language plpgsql

create or replace trigger trg_upd_ac_user_timestamp
before update on access_control.user
for each row
execute function fn_upd_timestamp();


--DO $$ 
--DECLARE 
--    r RECORD;
--BEGIN
--    FOR r IN 
--        SELECT table_name 
--        FROM information_schema.columns 
--        WHERE column_name = 'updated_at' 
--        AND table_schema = 'access_control'
--    LOOP
--        EXECUTE format('
--            CREATE TRIGGER trg_upd_%I_timestamp
--            BEFORE UPDATE ON %I.%I
--            FOR EACH ROW
--            EXECUTE FUNCTION fn_upd_timestamp();',
--            r.table_name, 'access_control', quote_ident(r.table_name));
--    END LOOP;
--END $$;