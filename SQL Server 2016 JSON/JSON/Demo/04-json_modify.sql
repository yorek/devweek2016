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
set @json = 
N'{
  "firstName": "John",
  "lastName": "Smith",
  "children": []
}';

select * from
( values  
	('Update existing value', json_modify(@json, '$.firstName', 'Davide')),
	('Insert scalar value', json_modify(@json, '$.isAlive', 'true')),
	('Insert array (wrong)', json_modify(@json, '$.preferredColors', '["Blue", "Black"]')), -- Wrong way, due to automatic escaping
	('Insert array (right)', json_modify(@json, '$.preferredColors', json_query('["Blue", "Black"]'))), 
	('Append to array', json_modify(@json, 'append $.children', 'Annette')), 
	('Replace an array with a scalar', json_modify(@json, '$.children', 'Annette')),
	('Add an object', json_modify(@json, '$.phoneNumbers', json_query('{"type": "home","number": "212 555-1234"}'))),
	('Remove an object', json_modify(@json, '$.firstName', null))
) t([action], result)
go

-- Add a new sample user
insert into dbo.users_json
select 3, json_data = json_modify(json_data, '$.firstName', 'Andy') from dbo.users_json where id = 1
go

-- Update last name
update 
	dbo.users_json
set
	json_data = 
		json_modify(
			json_modify(json_data, '$.lastName', 'Green'),
			'append $.phoneNumbers',
			json_query('{"type": "fax","number": "212 555-1234"}')
			)
where 
	json_value(json_data, '$.firstName') = 'Andy'
go

-- View result
select * from dbo.users_json where id = 3
go