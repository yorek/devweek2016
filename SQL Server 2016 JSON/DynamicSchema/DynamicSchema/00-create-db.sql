------------------------------------------------------------------------
-- Author:			Davide Mauri (SolidQ)
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
------------------------------------------------------------------------
USE [tempdb]
GO

IF (DB_ID('DynamicSchema') IS NOT NULL) BEGIN
	RAISERROR('Dropping database...', 10, 1) WITH NOWAIT
	ALTER DATABASE DynamicSchema SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE DynamicSchema
END
GO

RAISERROR('Creating database...', 10, 1) WITH NOWAIT
CREATE DATABASE DynamicSchema
GO

RAISERROR('Setting data file size...', 10, 1) WITH NOWAIT
ALTER DATABASE DynamicSchema
  MODIFY FILE
(
    NAME = N'DynamicSchema',
    SIZE = 4096000KB
)
GO

RAISERROR('Setting log file size...', 10, 1) WITH NOWAIT
ALTER DATABASE DynamicSchema
  MODIFY FILE
(
    NAME = N'DynamicSchema_log',
    SIZE = 2048000KB
)
GO

RAISERROR('Setting recovery model...', 10, 1) WITH NOWAIT
ALTER DATABASE DynamicSchema
  SET RECOVERY SIMPLE
GO

RAISERROR('Adjusting ownership...', 10, 1) WITH NOWAIT
ALTER AUTHORIZATION ON DATABASE :: DynamicSchema TO sa
GO

RAISERROR('Adding XTP filegroup...', 10, 1) WITH NOWAIT
ALTER DATABASE DynamicSchema
ADD FILEGROUP DynamicSchemaXTP CONTAINS MEMORY_OPTIMIZED_DATA
go

RAISERROR('Adding XTP file...', 10, 1) WITH NOWAIT
ALTER DATABASE DynamicSchema ADD FILE
(NAME = N'DynamicSchemaXTP', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DynamicSchemaXTP') 
TO FILEGROUP DynamicSchemaXTP 
go

RAISERROR('Done...', 10, 1) WITH NOWAIT