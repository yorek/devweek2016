------------------------------------------------------------------------
-- Topic:			JSON SQL Server 2016 Demo
-- Author:			Davide Mauri
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
-- Last Update:		2016-04-18
-- Tested On:		SQL SERVER 2016 RC1/RC2
------------------------------------------------------------------------
use DemoJSON
go

-- Create a sample table 
drop table if exists dbo.users_json_indexed
go

select id = identity(int, 1, 1), json_data into dbo.users_json_indexed from dbo.users_json order by id
go

alter table dbo.users_json_indexed
add constraint pk__users_json_indexed primary key(id)
go

insert into dbo.users_json_indexed (json_data)
select json_data from dbo.users_json_indexed where id != 3
go 16

select count(*) from dbo.users_json_indexed 
go

-- Index on scalar, well known, values
alter table dbo.users_json_indexed
add FirstName as json_value(json_data, '$.firstName')
go
alter table dbo.users_json_indexed
add LastName as json_value(json_data, '$.lastName')
go
alter table dbo.users_json_indexed
add Age as json_value(json_data, '$.age')
go

select * from dbo.users_json_indexed
go

create nonclustered index ix1 on dbo.users_json_indexed(FirstName)
go

set statistics io on
set statistics time on
go

-- With index support
select * from dbo.users_json_indexed where FirstName = 'Andy' 
go

-- Without index support
select * from dbo.users_json_indexed where LastName = 'Green' 
go

-- This works too
select * from dbo.users_json_indexed where json_value(json_data, '$.firstName') = 'Andy' 
go

/*
	Full Text
*/
create fulltext catalog json_catalog;
go

create fulltext index on dbo.users_json_indexed(json_data)
key index pk__users_json_indexed
on json_catalog;

select * from sys.fulltext_catalogs
select * from sys.dm_fts_index_population where database_id = db_id()
select * from sys.fulltext_indexes

select * from dbo.users_json_indexed where contains(json_data, 'NEAR((type, fax),1) and NEAR((number, "212 555-1234"),1)')


