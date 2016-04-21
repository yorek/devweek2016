------------------------------------------------------------------------
-- Topic:			JSON SQL Server 2016 Demo
-- Author:			Davide Mauri
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
-- Last Update:		2016-03-29
-- Tested On:		SQL SERVER 2016 RC1
------------------------------------------------------------------------
use DemoJSON
go

declare @json varchar(max)
set @json = 
N'{
  "firstName": "John",
  "lastName": "Smith",
  "isAlive": true,
  "age": 25,
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021-3100"
  },
  "phoneNumbers": [
    {
      "type": "home",
      "number": "212 555-1234"
    },
    {
      "type": "office",
      "number": "646 555-4567"
    },
    {
      "type": "mobile",
      "number": "123 456-7890"
    }
  ],
  "children": [],
  "spouse": null
}';

--
-- JSON_VALUE
--
select * from
( values 
	('$.firstName', json_value(@json, '$.firstName')),	
	('$.address.streetAddress', json_value(@json, '$.address.streetAddress')),	
	('$.phoneNumbers[0].number', json_value(@json, '$.phoneNumbers[0].number')),	
	('$.isAlive', json_value(@json, '$.isAlive')),	
	('$.isalive', json_value(@json, '$.isalive')),	-- CASE SENSITIVE!
	('$.children[0]', json_value(@json, '$.children[0]')),
	('$.someName', json_value(@json, '$.someName')),
	('$.phoneNumbers[10].number', json_value(@json, '$.phoneNumbers[10].number')),
	('$.spouse', json_value(@json, '$.spouse')),
	('$.address', json_value(@json, '$.address')) -- SCALAR ONLY!
) test ([path], [result])
;

-- Not possibile jet
-- but it would be nice to have the JSON_VALUE to support variables/columns for the JSON Path parameter
/*
select [path], JSON_VALUE(@json, [path]) from
( values 
	('$.firstName'),	
	('$.address.streetAddress')
) test ([path])
*/
