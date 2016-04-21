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

declare @json varchar(max)
select top (1) @json = json_data from dbo.users_json where id = 1

--
-- JSON_QUERY
--
select * from
( values 
	('$', json_query(@json, '$')),	
	('$.address', json_query(@json, '$.address')),	
	('$.phoneNumbers', json_query(@json, '$.phoneNumbers')),
	('$.phoneNumbers[0]', json_query(@json, '$.phoneNumbers[0]')),
	('$.children', json_query(@json, '$.children')),
	('$.firstName', json_query(@json, '$.firstName')), -- ONLY OBJECTS or ARRAYS!
	('$.doesNotExists', json_query(@json, '$.doesNotExists')) 
) test ([path], [result])
;
