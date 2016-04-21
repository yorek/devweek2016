use [AdventureWorks2012]
go

select h.[OrderDate] ,
       case h.[OnlineOrderFlag] when 0 then 'Store' else 'Online' end as OrderType,
       h.[SubTotal] ,
       h.[TaxAmt] ,
       h.[Freight] ,
       h.[TotalDue],
	   t.[TerritoryID],
	   t.[Name],
	   t.[Group],
	   sm.[Name] as ShipMethod
from   [Sales].[SalesOrderHeader] h
inner join	[Sales].[SalesTerritory] t on h.[TerritoryID] = t.[TerritoryID]
inner join [Purchasing].[ShipMethod] sm on h.[ShipMethodID] = [sm].[ShipMethodID]