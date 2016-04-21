------------------------------------------------------------------------
-- Author:			Davide Mauri (SolidQ)
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
------------------------------------------------------------------------
USE DynamicSchema
GO

DROP TABLE IF EXISTS  dbo.products;
CREATE TABLE dbo.products
(
	product_id INT IDENTITY NOT NULL PRIMARY KEY,
	[name] VARCHAR(100) NOT NULL 
)
go

DROP TABLE IF EXISTS  dbo.custom_attributes;
CREATE TABLE dbo.custom_attributes
(
	attribute_id INT NOT NULL IDENTITY,
	[name] SYSNAME NOT NULL,
	[datatype] CHAR(1) NOT NULL CHECK([datatype] IN ('S', 'N', 'D', 'T'))-- String, Number, Date, Time
)
GO

DROP TABLE IF EXISTS  dbo.products_custom_data_sparse;
CREATE TABLE dbo.products_custom_data_sparse
(
	product_id INT NOT NULL, 
	eav_data XML COLUMN_SET FOR ALL_SPARSE_COLUMNS,	
	CONSTRAINT [pk__product_custom_data_sparse] PRIMARY KEY NONCLUSTERED 
	(
		product_id ASC
	)
)
go

DROP TABLE IF EXISTS  dbo.products_custom_data_eav;
CREATE TABLE dbo.products_custom_data_eav
(
	product_id INT NOT NULL, 
	attribute_id INT NOT NULL,
	numeric_value NUMERIC(38,16) NULL,
	string_value VARCHAR(MAX) NULL,
	date_value DATE NULL,
	time_value TIME(7) NULL,
	CONSTRAINT [pk__product_custom_data_eav] PRIMARY KEY NONCLUSTERED 
	(
		product_id ASC,
		attribute_id ASC
	)
)
go

DROP TABLE IF EXISTS  dbo.products_custom_data_eav_string;
CREATE TABLE dbo.products_custom_data_eav_string
(
	product_id INT NOT NULL, 
	attribute_id INT NOT NULL,
	attribute_value VARCHAR(MAX) NOT NULL
	CONSTRAINT [pk__product_custom_data_eav_string] PRIMARY KEY NONCLUSTERED 
	(
		product_id ASC,
		attribute_id ASC
	)
)
GO

DROP TABLE IF EXISTS  dbo.products_custom_data_blob;
CREATE TABLE dbo.products_custom_data_blob
(
	product_id INT NOT NULL, 	
	product_data NVARCHAR(MAX) NULL ,	
	CONSTRAINT [pk__pproducts_custom_data_blob] PRIMARY KEY NONCLUSTERED 
	(
		product_id ASC
	)
)
GO

DROP TABLE IF EXISTS dbo.products_custom_data_json;
CREATE TABLE dbo.products_custom_data_json
(
	product_id INT NOT NULL, 	
	product_data NVARCHAR(MAX) NULL CHECK(ISJSON(product_data)=1),	
	CONSTRAINT [pk__products_custom_data_json] PRIMARY KEY NONCLUSTERED 
	(
		product_id ASC
	)
)
GO

DROP TABLE IF EXISTS  dbo.products_xtp;
CREATE TABLE dbo.products_xtp
(
	product_id INT IDENTITY NOT NULL PRIMARY KEY NONCLUSTERED HASH (product_id) WITH (BUCKET_COUNT = 10000),
	[name] VARCHAR(100) NOT NULL 
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_ONLY)
go

DROP TABLE IF EXISTS  dbo.products_custom_data_eav_xtp
CREATE TABLE dbo.products_custom_data_eav_xtp
(
	product_id INT NOT NULL, 
	attribute_id INT NOT NULL,
	numeric_value NUMERIC(38,16) NULL,
	string_value VARCHAR(1000) NULL,
	date_value DATE NULL,
	time_value TIME(7) NULL,
	CONSTRAINT [pk__product_custom_data_eav_xtp] PRIMARY KEY NONCLUSTERED HASH 
	(
		product_id ,
		attribute_id 
	) WITH (BUCKET_COUNT = 1000000),
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA)
GO

DROP TABLE IF EXISTS dbo.products_custom_data_eav_xtp_nc
CREATE TABLE dbo.products_custom_data_eav_xtp_nc
(
	product_id INT NOT NULL, 
	attribute_id INT NOT NULL,
	numeric_value NUMERIC(38,16) NULL,
	string_value VARCHAR(1000) NULL,
	date_value DATE NULL,
	time_value TIME(7) NULL,
	CONSTRAINT [pk__product_custom_data_eav_xtp_nc] PRIMARY KEY NONCLUSTERED HASH 
	(
		product_id ,
		attribute_id 
	) WITH (BUCKET_COUNT = 1000000)
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA)
GO

DROP TABLE IF EXISTS  dbo.products_custom_data_json_xtp;
CREATE TABLE dbo.products_custom_data_json_xtp
(
	product_id INT NOT NULL, 	
	product_data NVARCHAR(MAX) NULL,	
	--product_data NVARCHAR(MAX) NULL CHECK(ISJSON(product_data)=1),	 -- ISJSON IS NOT YET SUPPORTED IN XTP
    CONSTRAINT [pk__products_custom_data_json_xtp] PRIMARY KEY NONCLUSTERED HASH 
	(
		product_id 
	) WITH (BUCKET_COUNT = 1000000)
) WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_ONLY)
GO