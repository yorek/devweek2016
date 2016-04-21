------------------------------------------------------------------------
-- Topic:			R With SQL Server 2016 Demo
-- Author:			Davide Mauri
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
-- Last Update:		2016-04-18
-- Tested On:		SQL SERVER 2016 RC1/RC2
------------------------------------------------------------------------
use tempdb
go

exec sp_configure 'external scripts enabled', 1
go

reconfigure with override
go

execute sp_execute_external_script
  @language = N'R'
, @script = N' OutputDataSet <- InputDataSet;'
, @input_data_1 = N' SELECT ''Test'' AS Column1;'
with result sets (([Column1] varchar(100) NOT NULL));
go



