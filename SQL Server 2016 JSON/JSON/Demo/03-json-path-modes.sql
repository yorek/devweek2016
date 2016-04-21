declare @json varchar(max)
set @json = 
N'{
	"conference":
	{
		"name":"devweek",	
		"speaker": {
			"name": "Davide",
			"surname": "Mauri",
			"age": 38,
			"editions": [2010, 2016]
		}		
	}
}';


--
-- LAX / STRICT path mode
--

-- lax
select JSON_VALUE(@json, 'lax$.speaker');

-- strict
select JSON_VALUE(@json, 'strict$.speaker');

-- invalid
select JSON_VALUE(@json, 'dunno$.speaker');


