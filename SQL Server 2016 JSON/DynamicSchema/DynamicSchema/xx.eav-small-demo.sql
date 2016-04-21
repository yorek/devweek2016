------------------------------------------------------------------------
-- Author:			Davide Mauri (SolidQ)
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
------------------------------------------------------------------------
USE DynamicSchema
GO

DROP TABLE [sample].[entity]
DROP TABLE [sample].[entity_eav]
GO

DROP SCHEMA [sample]
GO

CREATE SCHEMA [sample]
GO

CREATE TABLE [sample].[entity]
(
	id INT NOT NULL PRIMARY KEY,
	[type] NVARCHAR(100) NOT NULL,
	[name] NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE [sample].[entity_eav]  (
	[entity_id] INT NOT NULL,
	attribute_name NVARCHAR(100) NOT NULL,
	attribute_value NVARCHAR(1000) NOT NULL,
);
GO

INSERT INTO [sample].[entity] VALUES ( 1, 'Song', 'Think About You' )
INSERT INTO [sample].[entity] VALUES ( 2, 'Laptop', 'DELL M3800' )
GO

INSERT INTO [sample].[entity_eav] VALUES ( 1, 'Album', 'Appetite For Destruction' )
INSERT INTO [sample].[entity_eav] VALUES ( 1, 'Track', '8' )
INSERT INTO [sample].[entity_eav] VALUES ( 1, 'Author', 'Guns N''Roses' )
INSERT INTO [sample].[entity_eav] VALUES ( 2, 'CPU', 'i7' )
INSERT INTO [sample].[entity_eav] VALUES ( 2, 'Memory', '16GB' )
INSERT INTO [sample].[entity_eav] VALUES ( 2, 'Display', '15.4''')
INSERT INTO [sample].[entity_eav] VALUES ( 2, 'Horizontal Resolution', '1920')
INSERT INTO [sample].[entity_eav] VALUES ( 2, 'Vertical Resolution', '1080')
GO

SELECT * FROM [sample].[entity]
SELECT * FROM [sample].[entity_eav]
GO

