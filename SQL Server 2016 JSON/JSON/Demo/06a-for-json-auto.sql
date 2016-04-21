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
-- FOR JSON - AUTO - The very basics
--
select * from dbo.users for json auto
go

select firstName, lastName, isAlive, age from dbo.users for json auto
go

-- Arrays is always created unless you explicity ask NOT to create it.
-- NOTE! Invalid json may be created!
select firstName, lastName, isAlive, age from dbo.users for json auto, without_array_wrapper
go

select firstName, lastName, isAlive, age from dbo.users for json auto, root('user')
go

-- Null values can be generated too
select * from dbo.user_addresses for json auto, include_null_values
go

-- Arrays are always generated, even if you specify TOP 1
select top 1 firstName, lastName, isAlive, age from dbo.users for json auto
go

select top 1 firstName, lastName, isAlive, age from dbo.users for json auto, root('user')
go

--
-- FOR JSON - Nested objects
--
select 
	u.firstName,
	u.lastName,
	u.isAlive,
	u.age,
	[address].streetAddress,
	[address].city,
	[address].[state],
	[address].postalCode
from 
	dbo.users u 
inner join 
	dbo.user_addresses as [address] on u.id = [address].[user_id] 
for 
	json auto
go

select 
	u.firstName,
	u.lastName,
	u.isAlive,
	u.age,
	[address].streetAddress,
	[address].city,
	[address].[state],
	[address].postalCode
from 
	dbo.users u 
cross apply
	(select top 1 * from dbo.user_addresses where [user_id] = u.id) as [address] 
for 
	json auto
go


