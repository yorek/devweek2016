------------------------------------------------------------------------
-- Author:			Davide Mauri (SolidQ)
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
------------------------------------------------------------------------
USE DynamicSchema
go

DECLARE C CURSOR FAST_FORWARD
FOR
SELECT 
	cmd = N'ALTER TABLE products_custom_data_sparse ADD ' + QUOTENAME([name]) + ' ' + 
	CASE [datatype] 
		WHEN 'S' THEN 'VARCHAR(MAX)'
		WHEN 'N' THEN 'NUMERIC(38,16)'
		WHEN 'D' THEN 'DATE'
		WHEN 'T' THEN 'TIME(7)'
	END + 
	' SPARSE NULL'
FROM 
	dbo.custom_attributes
;

DECLARE @cmd NVARCHAR(MAX);

OPEN C;

FETCH NEXT FROM C INTO @cmd;
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @cmd
	EXECUTE (@cmd);

	FETCH NEXT FROM C INTO @cmd;
END

CLOSE C
DEALLOCATE C
;

--CREATE NONCLUSTERED INDEX ix_1 ON dbo.products_custom_data_sparse (custom_1) WHERE (custom_1 IS NOT NULL)
--CREATE NONCLUSTERED INDEX ix_2 ON dbo.products_custom_data_sparse (custom_3) WHERE (custom_3 IS NOT NULL)
--CREATE NONCLUSTERED INDEX ix_3 ON dbo.products_custom_data_sparse (custom_4) WHERE (custom_4 IS NOT NULL)
--GO