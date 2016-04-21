------------------------------------------------------------------------
-- Author:			Davide Mauri (SolidQ)
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Version:			SQL Server 2008 RTM
-- Tab/indent size:	4
------------------------------------------------------------------------
USE DynamicSchema
go

select test = 'EAV (String)', product_count = count(distinct product_id) from [dbo].[products_custom_data_eav_string]
union all
select test = 'EAV', product_count = count(distinct product_id) from [dbo].[products_custom_data_eav]
union all
select test = 'EAV (XTP, NC)', product_count = count(distinct product_id) from [dbo].[products_custom_data_eav_xtp_nc]
union all
select test = 'EAV (XTP)', product_count = count(distinct product_id) from [dbo].[products_custom_data_eav_xtp]
union all
select test = 'JSON (BLOB)', product_count = count(distinct product_id) from [dbo].[products_custom_data_blob]
union all
select test = 'JSON (BLOB + CHECK)', product_count = count(distinct product_id) from [dbo].[products_custom_data_json]
union all
select test = 'BLOB (BLOB, XTP)', product_count = count(distinct product_id) from [dbo].[products_custom_data_json_xtp]
union all
select test = 'Sparse', product_count = count(distinct product_id) from [dbo].[products_custom_data_sparse]
