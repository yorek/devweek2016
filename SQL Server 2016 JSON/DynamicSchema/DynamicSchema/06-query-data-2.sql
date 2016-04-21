------------------------------------------------------------------------
-- Author:			Davide Mauri (SolidQ)
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Version:			SQL Server 2008 RTM
-- Tab/indent size:	4
------------------------------------------------------------------------
USE DynamicSchema
go

SET STATISTICS IO ON
SET STATISTICS TIME ON


-- Check Data Type
SELECT * FROM dbo.custom_attributes where attribute_id in (42, 79)

-- Test Sparse
CREATE NONCLUSTERED INDEX ix1 on dbo.products_custom_data_sparse(custom_42) WHERE (custom_42 IS NOT NULL) 
--WITH DROP_EXISTING
GO
SELECT * FROM dbo.products_custom_data_sparse where custom_42 = '20160419'
GO

-- Test EAV
CREATE NONCLUSTERED INDEX ix1 on dbo.products_custom_data_eav(attribute_id, [date_value]) 
INCLUDE (product_id) 
WHERE ([date_value] IS NOT NULL)
--WITH DROP_EXISTING
GO

-- Get some values to use as filter
select top 1 * from products_custom_data_eav where attribute_id = 42
select top 1 * from products_custom_data_eav where attribute_id = 79
go

DECLARE @t AS dbo.eav_payload_type;
INSERT INTO 
	@T (attribute_id, numeric_value, string_value, date_value, time_value)
VALUES 
	(42, NULL, NULL, '20151029', NULL),
	(79, 620127, NULL, NULL, NULL);
;
WITH cte AS
(
	SELECT * FROM @t 
)
SELECT 
	T1.product_id
FROM 
	dbo.products_custom_data_eav AS T1
INNER JOIN
	cte AS S ON	T1.attribute_id = S.attribute_id
		AND (T1.[numeric_value] = S.[numeric_value] OR S.[numeric_value] IS NULL)
		AND (T1.[string_value] = S.[string_value] OR S.[string_value] IS NULL)
		AND (T1.[date_value] = S.[date_value] OR S.[date_value] IS NULL)
		AND (T1.[time_value] = S.[time_value] OR S.[time_value] IS NULL)  
GROUP BY 
	T1.product_id
HAVING 
	COUNT(T1.attribute_id) = (SELECT COUNT(attribute_id) FROM cte)
GO

-- Test JSON

-- Bad performances :(
SELECT * FROM dbo.products_custom_data_json WHERE product_data LIKE '%"custom_42": "20151029"%' AND product_data LIKE '%"custom_79": "620127"%'
GO

DROP FULLTEXT CATALOG [json_catalog];
GO

CREATE FULLTEXT CATALOG [json_catalog];
GO

CREATE FULLTEXT INDEX ON dbo.products_custom_data_json(product_data)
KEY INDEX [pk__products_custom_data_json]
ON json_catalog;
GO

-- Great performances! :) 
SELECT * FROM dbo.products_custom_data_json WHERE contains(product_data, 'NEAR((custom_42, 20151029),1)')
GO
SELECT * FROM dbo.products_custom_data_json WHERE contains(product_data, 'NEAR((custom_42, 20151029),1) AND NEAR((custom_14, 20151127),1)')

