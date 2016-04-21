alter table dbo.[products_custom_data_sparse]
ADD custom_a INT SPARSE NULL 
GO

alter table dbo.[products_custom_data_sparse]
ADD custom_b DATETIME2 SPARSE NULL 
GO

alter table dbo.[products_custom_data_sparse]
ADD custom_c VARCHAR(100) SPARSE NULL 
GO
