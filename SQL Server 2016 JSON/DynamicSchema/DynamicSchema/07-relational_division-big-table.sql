------------------------------------------------------------------------
-- Author:			Davide Mauri (SolidQ)
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Version:			SQL Server 2008 RTM
-- Tab/indent size:	4
------------------------------------------------------------------------
USE [TPC-H_2_14_3-10GB]
go

SET STATISTICS IO ON
SET STATISTICS TIME ON
GO

/*
 Indexing for best performances (SYS2 on Codeplex)
*/
SELECT * FROM sys2.indexes(null) 
/*
CREATE NONCLUSTERED INDEX ix__LINEITEM__RD2 ON dbo.LINEITEM (L_PARTKEY) INCLUDE (L_ORDERKEY)
CREATE NONCLUSTERED INDEX ix__LINEITEM__RD2 ON dbo.PART (P_PARTKEY) 
*/
go

-- Show table size
SELECT row_count = FORMAT(row_count, '#,0'), size_in_gb = FORMAT(used_page_count * 8. / 1024 / 1024, '#,0.00')
FROM sys.dm_db_partition_stats WHERE object_id = OBJECT_ID('dbo.LINEITEM') AND index_id = 0  
go

-- Use the alternate version
WITH cte AS
(
	SELECT P_PARTKEY FROM dbo.PART WHERE P_PARTKEY IN (570784, 1160600)
)
SELECT 
	T1.L_ORDERKEY
FROM 
	dbo.LINEITEM AS T1
INNER JOIN
	cte AS S ON	T1.L_PARTKEY = S.P_PARTKEY
GROUP BY 
	T1.L_ORDERKEY
HAVING 
	COUNT(T1.L_PARTKEY) = (SELECT COUNT(P_PARTKEY) FROM cte)
GO

SELECT * FROM dbo.LINEITEM WHERE L_ORDERKEY = 583235
GO
