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
-- OPENJSON - The very basics
--
declare @json varchar(max) 
select @json = json_data from dbo.users_json where id = 1
select 
	* 
from 
	openjson(@json)
go



--
-- OPENJSON - Explict Schema
--
declare @json varchar(max);
select @json = json_data from dbo.users_json where id = 1;
select * from openjson(@json)
with ( firstName nvarchar(100) )
go

declare @json varchar(max);
select @json = json_data from dbo.users_json where id = 1;
select * from openjson(@json)
with ( 
		firstName nvarchar(100),
		lastName nvarchar(100),
		isAlive bit,
		age int
	)
go

declare @json varchar(max);
select @json = json_data from dbo.users_json where id = 1;
select * from openjson(@json)
with ( 
		firstName nvarchar(100),
		lastName nvarchar(100),
		isAlive bit,
		age int,
		streetAddress nvarchar(1000) '$.address.streetAddress',
		phoneNumbers nvarchar(max) '$.phoneNumbers' as json
	)
go

--
-- OPENJSON - With JSON Path
--
declare @json varchar(max);
select @json = json_data from dbo.users_json where id = 1;
select * from openjson(@json, '$.phoneNumbers')
go

declare @json varchar(max);
select @json = json_data from dbo.users_json where id = 1;
select * from openjson(@json, '$.phoneNumbers')
with 
	(
		[type] nvarchar(100),
		number nvarchar(100)
	)
go

--
-- OPENJSON - With relational data
--
select
	u.id,
	j.*
from
	dbo.users_json as u
cross apply
	openjson(json_data) as j
go

select
	u.id,
	j.*
from
	dbo.users_json as u
cross apply
	openjson(json_data) with 
		(
			firstName nvarchar(100),
			lastName nvarchar(100)
		) as j
go

select
	u.id,
	j.*
from
	dbo.users_json as u
cross apply
	openjson(json_data, '$.phoneNumbers') with 
		(
			[type] nvarchar(100),
			number nvarchar(100)
		) as j
go

select
	u.id,
	j.*,
	j2.*
from
	dbo.users_json as u
cross apply
	openjson(json_data) with 
		(
			firstName nvarchar(100),
			lastName nvarchar(100)
		) as j
cross apply
	openjson(json_data, '$.phoneNumbers') with 
		(
			[type] nvarchar(100),
			number nvarchar(100)
		) as j2
go

--
-- OPENJSON - Very interesting to turn arrays into tables
--
declare @json nvarchar(100) = '[1,2,3,4]'
select [value] from openjson(@json)
go

declare @json nvarchar(100) = '[1,2,3,4]'
select * from sys.objects where object_id in (select cast([value] as int) from openjson(@json))

--
-- OPENJSON - Bulk Load Data
--
select 
	j.* 
from 
	openrowset(bulk N'Z:\Work\_Conferenze\DevWeek - London\2016\SQL Server 2016 JSON\JSON\sample.json', single_clob) t
cross apply 
	openjson(t.BulkColumn) j
go

select 
	j.* 
from 
	openrowset(bulk N'Z:\Work\_Conferenze\DevWeek - London\2016\SQL Server 2016 JSON\JSON\sample.json', single_clob) t
cross apply 
	openjson(t.BulkColumn) with 
		(
			[firstName] nvarchar(100),
			[lastName] nvarchar(100),
			[streetAddress] nvarchar(100) '$.address.streetAddress'
		) as j
go