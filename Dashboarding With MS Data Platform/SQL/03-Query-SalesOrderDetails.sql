use DevweekDemo
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
select * from cte where [TerritoryID] in (select [output] from dbo.[SplitString]('{{ @TerritoryID }}', ','))
