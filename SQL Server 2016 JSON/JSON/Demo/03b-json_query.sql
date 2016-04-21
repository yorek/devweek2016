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

--
-- JSON_QUERY with STRICT path mode
--

declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 1
select json_query(@json, 'strict $')
go

declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 1
select json_query(@json, 'strict $.address')
go

declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 1
select json_query(@json, 'strict $.phoneNumbers')
go

declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 1
select json_query(@json, 'strict $.phoneNumbers[0]')
go

declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 1
select json_query(@json, 'strict $.children')
go

declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 1
select json_query(@json, 'strict $.firstName') -- ONLY OBJECTS or ARRAYS!
go

declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 1
select json_query(@json, 'strict $.doesNotExists')
;
