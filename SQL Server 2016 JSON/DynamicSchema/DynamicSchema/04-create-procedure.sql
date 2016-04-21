------------------------------------------------------------------------
-- Author:			Davide Mauri (SolidQ)
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
------------------------------------------------------------------------
USE DynamicSchema
GO

DROP PROCEDURE IF EXISTS dbo.stp_insert_custom_product_data_sparse;
DROP PROCEDURE IF EXISTS dbo.stp_insert_custom_product_data_json_xtp;
DROP PROCEDURE IF EXISTS dbo.stp_insert_custom_product_data_eav_xtp_nc;
DROP PROCEDURE IF EXISTS dbo.stp_insert_custom_product_data_eav_xtp;
DROP PROCEDURE IF EXISTS dbo.stp_insert_custom_product_data_json;
DROP PROCEDURE IF EXISTS dbo.stp_insert_custom_product_data_blob;
DROP PROCEDURE IF EXISTS dbo.stp_insert_custom_product_data_eav_string;
DROP PROCEDURE IF EXISTS dbo.stp_insert_custom_product_data_eav;
GO


DROP TYPE IF EXISTS dbo.eav_payload_type_xtp;
DROP TYPE IF EXISTS dbo.eav_string_payload_type;
DROP TYPE IF EXISTS dbo.eav_payload_type;
GO


CREATE PROCEDURE dbo.stp_insert_custom_product_data_sparse
@product_name VARCHAR(100),
@product_custom_data AS XML
AS
SET XACT_ABORT ON
BEGIN TRAN 
INSERT INTO dbo.products (name) VALUES (@product_name)
INSERT INTO dbo.products_custom_data_sparse (product_id, eav_data) VALUES (SCOPE_IDENTITY(), @product_custom_data)
COMMIT TRAN
GO


CREATE TYPE dbo.eav_payload_type AS TABLE
(
	[attribute_id] [int] NOT NULL,
	[numeric_value] [numeric](38, 16) NULL,
	[string_value] [varchar](max) NULL,
	[date_value] [date] NULL,
	[time_value] [time](7) NULL
)
GO


CREATE PROCEDURE dbo.stp_insert_custom_product_data_eav
@product_name VARCHAR(100),
@product_custom_data AS dbo.eav_payload_type READONLY
AS
SET XACT_ABORT ON
BEGIN TRAN 
INSERT INTO dbo.products (name) VALUES (@product_name)
INSERT INTO dbo.products_custom_data_eav 
	([product_id], [attribute_id], [numeric_value], [string_value], [date_value], [time_value])
SELECT
	SCOPE_IDENTITY(), [attribute_id], [numeric_value], [string_value], [date_value], [time_value]
FROM
	@product_custom_data
COMMIT TRAN
GO


CREATE TYPE dbo.eav_string_payload_type AS TABLE
(
	[attribute_id] [int] NOT NULL,
	[string_value] [varchar](max) NULL
)
GO


CREATE PROCEDURE dbo.stp_insert_custom_product_data_eav_string
@product_name VARCHAR(100),
@product_custom_data AS dbo.eav_string_payload_type READONLY
AS
SET XACT_ABORT ON
BEGIN TRAN 
INSERT INTO dbo.products (name) VALUES (@product_name)
INSERT INTO dbo.products_custom_data_eav_string
	([product_id], [attribute_id], [attribute_value])
SELECT
	SCOPE_IDENTITY(), [attribute_id], [string_value]
FROM
	@product_custom_data
COMMIT TRAN
GO


CREATE PROCEDURE dbo.stp_insert_custom_product_data_blob
@product_name VARCHAR(100),
@product_custom_data AS NVARCHAR(MAX)
AS
SET XACT_ABORT ON
BEGIN TRAN 
INSERT INTO dbo.products (name) VALUES (@product_name)
INSERT INTO dbo.products_custom_data_blob
	([product_id], [product_data])
VALUES
	(SCOPE_IDENTITY(), @product_custom_data)
COMMIT TRAN
GO

CREATE PROCEDURE dbo.stp_insert_custom_product_data_json
@product_name VARCHAR(100),
@product_custom_data AS NVARCHAR(MAX)
AS
SET XACT_ABORT ON
BEGIN TRAN 
INSERT INTO dbo.products (name) VALUES (@product_name)
INSERT INTO dbo.products_custom_data_json
	([product_id], [product_data])
VALUES
	(SCOPE_IDENTITY(), @product_custom_data)
COMMIT TRAN
GO

CREATE TYPE dbo.eav_payload_type_xtp AS TABLE
(	
	[attribute_id] [int] NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1000),
	[numeric_value] [numeric](38, 16) NULL,
	[string_value] [varchar](1000) NULL,
	[date_value] [date] NULL,
	[time_value] [time](7) NULL
) WITH (MEMORY_OPTIMIZED = ON)
GO

CREATE PROCEDURE dbo.stp_insert_custom_product_data_eav_xtp
@product_name VARCHAR(100),
@product_custom_data AS dbo.eav_payload_type_xtp READONLY
AS
SET XACT_ABORT ON
BEGIN TRAN 
INSERT INTO dbo.products_xtp (name) VALUES (@product_name)
INSERT INTO dbo.products_custom_data_eav_xtp
	([product_id], [attribute_id], [numeric_value], [string_value], [date_value], [time_value])
SELECT
	SCOPE_IDENTITY(), [attribute_id], [numeric_value], [string_value], [date_value], [time_value]
FROM
	@product_custom_data
COMMIT TRAN
GO


CREATE PROCEDURE dbo.stp_insert_custom_product_data_eav_xtp_nc
@product_name VARCHAR(100),
@product_custom_data AS dbo.eav_payload_type_xtp READONLY
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL=SNAPSHOT, LANGUAGE=N'US_ENGLISH')
	INSERT INTO dbo.products_xtp (name) VALUES (@product_name)
	INSERT INTO dbo.products_custom_data_eav_xtp_nc
		([product_id], [attribute_id], [numeric_value], [string_value], [date_value], [time_value])
	SELECT
		SCOPE_IDENTITY(), [attribute_id], [numeric_value], [string_value], [date_value], [time_value]
	FROM
		@product_custom_data
END
GO


CREATE PROCEDURE dbo.stp_insert_custom_product_data_json_xtp
@product_name VARCHAR(100),
@product_custom_data AS NVARCHAR(MAX)
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL=SNAPSHOT, LANGUAGE=N'US_ENGLISH')
INSERT INTO dbo.products_xtp (name) VALUES (@product_name)
INSERT INTO dbo.products_custom_data_json_xtp
	([product_id], [product_data])
VALUES
	(SCOPE_IDENTITY(), @product_custom_data)
END
GO
