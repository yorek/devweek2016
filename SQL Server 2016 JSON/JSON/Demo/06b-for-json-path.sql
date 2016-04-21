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
-- FOR JSON - PATH - The very basics
--
select * from dbo.users for json path
go

select firstName, lastName, isAlive, age from dbo.users for json path
go

-- Create specific objects using columns alias
select firstName, lastName, isAlive, age as 'user.age' from dbo.users for json path
go
select firstName, lastName, isAlive, age as 'user.personalData.age' from dbo.users for json path
go

-- Arrays is always created unless you explicity ask NOT to create it.
-- NOTE! Invalid json may be created!
select firstName, lastName, isAlive, age as 'user.age' from dbo.users for json path, without_array_wrapper
go

select firstName, lastName, isAlive, age as 'user.age' from dbo.users for json path, root('user')
go

-- Null values can be generated too
select * from dbo.user_addresses for json path, include_null_values
go

-- Arrays are always generated even if TOP 1 is specified
select top 1 firstName, lastName, isAlive, age from dbo.users for json path
go

select top 1 firstName, lastName, isAlive, age from dbo.users for json path, root('user')
go

--
-- FOR JSON - Nested objects
--

-- No array now on Address!
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
	json path
go


-- No array now on Address!
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
	json path
go


-- No array at all :)
select 
	u.firstName,
	u.lastName,
	u.isAlive,
	u.age,
	[address].streetAddress as 'address.streetAddress',
	[address].city as 'address.city',
	[address].[state] as 'address.state',
	[address].postalCode as 'address.postalCode'
from 
	dbo.users u 
inner join 
	dbo.user_addresses as [address] on u.id = [address].[user_id] 
for 
	json path
go

-- No array at all...no really!
select 
	u.firstName,
	u.lastName,
	u.isAlive,
	u.age,
	ua.streetAddress as 'address.streetAddress',
	ua.city as 'address.city',
	ua.[state] as 'address.state',
	ua.postalCode as 'address.postalCode',
	up.[type] as 'phoneNumbers.type',
	up.number as 'phoneNumbers.number'
from 
	dbo.users u 
inner join 
	dbo.user_addresses as ua on ua.[user_id] = u.id
inner join
	dbo.user_phones as up on up.[user_id] = u.id
where
	u.id = 1
for 
	json path
go

-- Here's the arrays!
select 
	u.firstName,
	u.lastName,
	u.isAlive,
	u.age,
	json_query((select top 1 streetAddress, city, state, postalCode from dbo.user_addresses where [user_id] = u.id for json path, without_array_wrapper)) as 'address',
	json_query((select [type], number from dbo.user_phones where [user_id] = u.id for json path)) as 'phoneNumbers',
	json_query('[]') as children,
	null as 'spouse'
from 
	dbo.users u 	
where
	u.id = 1
for 
	json path, without_array_wrapper, include_null_values
go

