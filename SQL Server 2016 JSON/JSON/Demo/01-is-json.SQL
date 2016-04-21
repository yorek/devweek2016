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

-- Test ISJSON function
select * from
( values 
	(null, isjson(null)),
	('', isjson(N'')),
	('{}', isjson(N'{}')),
	('[]', isjson(N'[]')),
	('[{}]', isjson(N'[{}]')),
	('{"conference": "devweek"}', isjson(N'{"conference": "devweek"}')),
	('{"conference"}', isjson(N'{"conference"}')),
	('{"conference": devweek}', isjson(N'{"conference": devweek}')),
	('{"year": "2016"}', isjson(N'{"year": "2016"}')),
	('{"year": 2016}', isjson(N'{"year": 2016}')),
	('{year: 2016}', isjson(N'{year: 2016}')),
	('{"year": ''2016''}', isjson(N'{"year": ''2016''}')),
	('{"years": [2016]}', isjson(N'{"years": [2016]}')),
	('{"years": {2016}}', isjson(N'{"years": {2016}}')),
	('{"years": {"year": 2016}}', isjson(N'{"years": {"year": 2016}}')),
	('{"false": false}', isjson(N'{"false": false}')),
	('{"true": true}', isjson(N'{"true": true}')),
	('{"null": null}', isjson(N'{"null": null}'))
) test (string, is_json)
go

-- ISJSON is perfect in Check Constraints:
drop table if exists dbo.products;
create table dbo.products
(
	id int not null constraint pk__products primary key,
	name nvarchar(100) not null,
	code bigint not null,
	[data] nvarchar(max) not null constraint ck__data check(isjson([data])=1)
)
go

insert into dbo.products values (1, 'SoundLink® Mini Bluetooth® speaker II', 123456,
N'{
  "dimensions": {
    "speaker": {
      "height": 5.1,
      "width": 18,
      "depth": 5.8,
      "weight": 0.67
    },
    "charging cradle": {
      "height": 1.59,
      "width": 15.75,
      "depth": 5.1,
      "weight": 80
    }
  }
}')
go

insert into dbo.products values (2, 'SoundLink® Mini Bluetooth® speaker II', 123456,
N'{
  "dimensions": {
    "speaker": {
      "height": 5.1,
      "width": 18,
      "depth": 5.8,
      "weight": 0.67
    },
    "charging cradle": {
      "height": 1.59,
      "width: 15.75, -- ERROR HERE
      "depth": 5.1,
      "weight": 80
    }
  }
}')
go

select * from dbo.products
go

update dbo.products set [data] = replace([data], '{', '') where id = 1
go

select * from dbo.products
go
