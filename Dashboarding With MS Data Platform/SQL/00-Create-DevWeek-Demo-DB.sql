create database DevweekDemo
go

use DevweekDemo
go

drop assembly [Devweek.Utility.SQL]
go
create assembly [Devweek.Utility.SQL] from 'C:\Work\Conferenze\DevWeek\2016\Dashboarding\Devweek.Utility.SQL\Devweek.Utility.SQL\bin\Release\Devweek.Utility.SQL.dll'
go
select * from sys.[assemblies]
go

create function dbo.SplitString (@instr nvarchar(max), @delimiter nchar(1))
returns table ([output] nvarchar(4000))
as external name [Devweek.Utility.SQL].[Devweek.Utility.SQL.SplitString].Split
go

select * from dbo.[SplitString]('1,2,3,4', ',')
go

select
	h.[OrderDate],
	h.[TerritoryID],
	d.[OrderQty],
	d.[LineTotal],
	s.[Name] as ProductSubcategoryName,
	c.[Name] as ProductCategoryName,
	p.[Name] as ProductName
into dbo.SalesOrderDetail
from [AdventureWorks2012].[Sales].[SalesOrderHeader] h
inner join [AdventureWorks2012].[Sales].[SalesOrderDetail] d on h.[SalesOrderID] = d.[SalesOrderID]
inner join [AdventureWorks2012].[Production].[Product] p on d.[ProductID] = p.[ProductID]
inner join [AdventureWorks2012].[Production].[ProductSubcategory] s on p.[ProductSubcategoryID] = s.[ProductSubcategoryID]
inner join [AdventureWorks2012].[Production].[ProductCategory] c on s.[ProductCategoryID] = c.[ProductCategoryID]
go

create clustered columnstore index ixccs on  dbo.SalesOrderDetail
go

with cte as
(
	select
		[OrderDate],
		[TerritoryID],
		Quantity = sum([OrderQty]),
		[LineTotal],
		ProductSubcategoryName,
		ProductCategoryName,
		ProductName
	from  dbo.SalesOrderDetail
	group by 
		[OrderDate],
		[TerritoryID],
		[OrderQty],
		[LineTotal],
		ProductSubcategoryName,
		ProductCategoryName,
		ProductName
)
select * from cte where [TerritoryID] in (select [output] from dbo.[SplitString]('1,2,3,4', ','))
