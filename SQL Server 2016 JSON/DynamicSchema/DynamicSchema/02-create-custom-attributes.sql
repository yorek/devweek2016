------------------------------------------------------------------------
-- Author:			Davide Mauri (SolidQ)
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
------------------------------------------------------------------------
USE DynamicSchema
GO

SET NOCOUNT ON;
GO

TRUNCATE TABLE dbo.custom_attributes ;
GO

DECLARE @i INT = 1;
DECLARE @r INT = 0;
DECLARE @t CHAR(1) = '';

WHILE (@i <= 100)
BEGIN
	SET @r = FLOOR(RAND() * 4);
	SET @t = CASE 
				WHEN @r = 0 THEN 'S' 
				WHEN @r = 1 THEN 'N' 
				WHEN @r = 2 THEN 'D' 
				WHEN @r = 3 THEN 'T' 
			END

	INSERT INTO dbo.custom_attributes ([name], [datatype])
	VALUES ('custom_' + CAST(@i AS VARCHAR(9)), @t);

	SET @i += 1;
END
GO

SELECT * FROM dbo.custom_attributes 

