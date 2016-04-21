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

create database Datasets
go

use Datasets
go

drop table if exists [dbo].[Iris];
create table [dbo].[Iris]
(
	[id] [int] not null,
	[sepal_length_in_cm] [decimal](3, 1) null,
	[sepal_width_in_cm] [decimal](3, 1) null,
	[petal_length_in_cm] [decimal](3, 1) null,
	[petal_width_in_cm] [decimal](3, 1) null,
	[class] [varchar](40) null,
	[use_for_training] bit null,
	constraint [PK_Iris] primary key clustered 
	(
		[id] asc
	)
)
go

INSERT INTO [dbo].[Iris]
VALUES
( 1, 5.1, 3.5, 1.4, 0.2, N'Iris-setosa', 1), 
( 2, 4.9, 3.0, 1.4, 0.2, N'Iris-setosa', 1), 
( 3, 4.7, 3.2, 1.3, 0.2, N'Iris-setosa', 1), 
( 4, 4.6, 3.1, 1.5, 0.2, N'Iris-setosa', 1), 
( 5, 5.0, 3.6, 1.4, 0.2, N'Iris-setosa', 1), 
( 6, 5.4, 3.9, 1.7, 0.4, N'Iris-setosa', 1), 
( 7, 4.6, 3.4, 1.4, 0.3, N'Iris-setosa', 1), 
( 8, 5.0, 3.4, 1.5, 0.2, N'Iris-setosa', 1), 
( 9, 4.4, 2.9, 1.4, 0.2, N'Iris-setosa', 1), 
( 10, 4.9, 3.1, 1.5, 0.1, N'Iris-setosa', 1), 
( 11, 5.4, 3.7, 1.5, 0.2, N'Iris-setosa', 1), 
( 12, 4.8, 3.4, 1.6, 0.2, N'Iris-setosa', 1), 
( 13, 4.8, 3.0, 1.4, 0.1, N'Iris-setosa', 1), 
( 14, 4.3, 3.0, 1.1, 0.1, N'Iris-setosa', 1), 
( 15, 5.8, 4.0, 1.2, 0.2, N'Iris-setosa', 1), 
( 16, 5.7, 4.4, 1.5, 0.4, N'Iris-setosa', 1), 
( 17, 5.4, 3.9, 1.3, 0.4, N'Iris-setosa', 1), 
( 18, 5.1, 3.5, 1.4, 0.3, N'Iris-setosa', 1), 
( 19, 5.7, 3.8, 1.7, 0.3, N'Iris-setosa', 1), 
( 20, 5.1, 3.8, 1.5, 0.3, N'Iris-setosa', 1), 
( 21, 5.4, 3.4, 1.7, 0.2, N'Iris-setosa', 1), 
( 22, 5.1, 3.7, 1.5, 0.4, N'Iris-setosa', 1), 
( 23, 4.6, 3.6, 1.0, 0.2, N'Iris-setosa', 1), 
( 24, 5.1, 3.3, 1.7, 0.5, N'Iris-setosa', 1), 
( 25, 4.8, 3.4, 1.9, 0.2, N'Iris-setosa', 1), 
( 26, 5.0, 3.0, 1.6, 0.2, N'Iris-setosa', 1), 
( 27, 5.0, 3.4, 1.6, 0.4, N'Iris-setosa', 1), 
( 28, 5.2, 3.5, 1.5, 0.2, N'Iris-setosa', 1), 
( 29, 5.2, 3.4, 1.4, 0.2, N'Iris-setosa', 1), 
( 30, 4.7, 3.2, 1.6, 0.2, N'Iris-setosa', 1), 
( 31, 4.8, 3.1, 1.6, 0.2, N'Iris-setosa', 1), 
( 32, 5.4, 3.4, 1.5, 0.4, N'Iris-setosa', 1), 
( 33, 5.2, 4.1, 1.5, 0.1, N'Iris-setosa', 1), 
( 34, 5.5, 4.2, 1.4, 0.2, N'Iris-setosa', 1),
( 35, 4.9, 3.1, 1.5, 0.1, N'Iris-setosa', 1),
( 36, 5.0, 3.2, 1.2, 0.2, N'Iris-setosa', 1),
( 37, 5.5, 3.5, 1.3, 0.2, N'Iris-setosa', 1),
( 38, 4.9, 3.1, 1.5, 0.1, N'Iris-setosa', 1),
( 39, 4.4, 3.0, 1.3, 0.2, N'Iris-setosa', 1),
( 40, 5.1, 3.4, 1.5, 0.2, N'Iris-setosa', 1),
( 41, 5.0, 3.5, 1.3, 0.3, N'Iris-setosa', 1),
( 42, 4.5, 2.3, 1.3, 0.3, N'Iris-setosa', 1),
( 43, 4.4, 3.2, 1.3, 0.2, N'Iris-setosa', 1),
( 44, 5.0, 3.5, 1.6, 0.6, N'Iris-setosa', 1),
( 45, 5.1, 3.8, 1.9, 0.4, N'Iris-setosa', 1),
( 46, 4.8, 3.0, 1.4, 0.3, N'Iris-setosa', 1),
( 47, 5.1, 3.8, 1.6, 0.2, N'Iris-setosa', 1),
( 48, 4.6, 3.2, 1.4, 0.2, N'Iris-setosa', 1),
( 49, 5.3, 3.7, 1.5, 0.2, N'Iris-setosa', 1),
( 50, 5.0, 3.3, 1.4, 0.2, N'Iris-setosa', 1),
( 51, 7.0, 3.2, 4.7, 1.4, N'Iris-versicolor', 1), 
( 52, 6.4, 3.2, 4.5, 1.5, N'Iris-versicolor', 1), 
( 53, 6.9, 3.1, 4.9, 1.5, N'Iris-versicolor', 1), 
( 54, 5.5, 2.3, 4.0, 1.3, N'Iris-versicolor', 1), 
( 55, 6.5, 2.8, 4.6, 1.5, N'Iris-versicolor', 1), 
( 56, 5.7, 2.8, 4.5, 1.3, N'Iris-versicolor', 1), 
( 57, 6.3, 3.3, 4.7, 1.6, N'Iris-versicolor', 1), 
( 58, 4.9, 2.4, 3.3, 1.0, N'Iris-versicolor', 1), 
( 59, 6.6, 2.9, 4.6, 1.3, N'Iris-versicolor', 1), 
( 60, 5.2, 2.7, 3.9, 1.4, N'Iris-versicolor', 1), 
( 61, 5.0, 2.0, 3.5, 1.0, N'Iris-versicolor', 1), 
( 62, 5.9, 3.0, 4.2, 1.5, N'Iris-versicolor', 1), 
( 63, 6.0, 2.2, 4.0, 1.0, N'Iris-versicolor', 1), 
( 64, 6.1, 2.9, 4.7, 1.4, N'Iris-versicolor', 1),
( 65, 5.6, 2.9, 3.6, 1.3, N'Iris-versicolor', 1),
( 66, 6.7, 3.1, 4.4, 1.4, N'Iris-versicolor', 1),
( 67, 5.6, 3.0, 4.5, 1.5, N'Iris-versicolor', 1),
( 68, 5.8, 2.7, 4.1, 1.0, N'Iris-versicolor', 1),
( 69, 6.2, 2.2, 4.5, 1.5, N'Iris-versicolor', 1),
( 70, 5.6, 2.5, 3.9, 1.1, N'Iris-versicolor', 1),
( 71, 5.9, 3.2, 4.8, 1.8, N'Iris-versicolor', 1),
( 72, 6.1, 2.8, 4.0, 1.3, N'Iris-versicolor', 1),
( 73, 6.3, 2.5, 4.9, 1.5, N'Iris-versicolor', 1),
( 74, 6.1, 2.8, 4.7, 1.2, N'Iris-versicolor', 1),
( 75, 6.4, 2.9, 4.3, 1.3, N'Iris-versicolor', 1),
( 76, 6.6, 3.0, 4.4, 1.4, N'Iris-versicolor', 1),
( 77, 6.8, 2.8, 4.8, 1.4, N'Iris-versicolor', 1),
( 78, 6.7, 3.0, 5.0, 1.7, N'Iris-versicolor', 1),
( 79, 6.0, 2.9, 4.5, 1.5, N'Iris-versicolor', 1),
( 80, 5.7, 2.6, 3.5, 1.0, N'Iris-versicolor', 1),
( 81, 5.5, 2.4, 3.8, 1.1, N'Iris-versicolor', 1),
( 82, 5.5, 2.4, 3.7, 1.0, N'Iris-versicolor', 1),
( 83, 5.8, 2.7, 3.9, 1.2, N'Iris-versicolor', 1),
( 84, 6.0, 2.7, 5.1, 1.6, N'Iris-versicolor', 1),
( 85, 5.4, 3.0, 4.5, 1.5, N'Iris-versicolor', 1),
( 86, 6.0, 3.4, 4.5, 1.6, N'Iris-versicolor', 1),
( 87, 6.7, 3.1, 4.7, 1.5, N'Iris-versicolor', 1),
( 88, 6.3, 2.3, 4.4, 1.3, N'Iris-versicolor', 1),
( 89, 5.6, 3.0, 4.1, 1.3, N'Iris-versicolor', 1),
( 90, 5.5, 2.5, 4.0, 1.3, N'Iris-versicolor', 1),
( 91, 5.5, 2.6, 4.4, 1.2, N'Iris-versicolor', 1),
( 92, 6.1, 3.0, 4.6, 1.4, N'Iris-versicolor', 1),
( 93, 5.8, 2.6, 4.0, 1.2, N'Iris-versicolor', 1), 
( 94, 5.0, 2.3, 3.3, 1.0, N'Iris-versicolor', 1), 
( 95, 5.6, 2.7, 4.2, 1.3, N'Iris-versicolor', 1), 
( 96, 5.7, 3.0, 4.2, 1.2, N'Iris-versicolor', 1), 
( 97, 5.7, 2.9, 4.2, 1.3, N'Iris-versicolor', 1), 
( 98, 6.2, 2.9, 4.3, 1.3, N'Iris-versicolor', 1), 
( 99, 5.1, 2.5, 3.0, 1.1, N'Iris-versicolor', 1), 
( 100, 5.7, 2.8, 4.1, 1.3, N'Iris-versicolor', 1),
( 101, 6.3, 3.3, 6.0, 2.5, N'Iris-virginica', 1),
( 102, 5.8, 2.7, 5.1, 1.9, N'Iris-virginica', 1),
( 103, 7.1, 3.0, 5.9, 2.1, N'Iris-virginica', 1),
( 104, 6.3, 2.9, 5.6, 1.8, N'Iris-virginica', 1),
( 105, 6.5, 3.0, 5.8, 2.2, N'Iris-virginica', 1),
( 106, 7.6, 3.0, 6.6, 2.1, N'Iris-virginica', 1),
( 107, 4.9, 2.5, 4.5, 1.7, N'Iris-virginica', 1),
( 108, 7.3, 2.9, 6.3, 1.8, N'Iris-virginica', 1),
( 109, 6.7, 2.5, 5.8, 1.8, N'Iris-virginica', 1),
( 110, 7.2, 3.6, 6.1, 2.5, N'Iris-virginica', 1),
( 111, 6.5, 3.2, 5.1, 2.0, N'Iris-virginica', 1),
( 112, 6.4, 2.7, 5.3, 1.9, N'Iris-virginica', 1),
( 113, 6.8, 3.0, 5.5, 2.1, N'Iris-virginica', 1),
( 114, 5.7, 2.5, 5.0, 2.0, N'Iris-virginica', 1),
( 115, 5.8, 2.8, 5.1, 2.4, N'Iris-virginica', 1),
( 116, 6.4, 3.2, 5.3, 2.3, N'Iris-virginica', 1),
( 117, 6.5, 3.0, 5.5, 1.8, N'Iris-virginica', 1),
( 118, 7.7, 3.8, 6.7, 2.2, N'Iris-virginica', 1),
( 119, 7.7, 2.6, 6.9, 2.3, N'Iris-virginica', 1),
( 120, 6.0, 2.2, 5.0, 1.5, N'Iris-virginica', 1),
( 121, 6.9, 3.2, 5.7, 2.3, N'Iris-virginica', 1),
( 122, 5.6, 2.8, 4.9, 2.0, N'Iris-virginica', 1),
( 123, 7.7, 2.8, 6.7, 2.0, N'Iris-virginica', 1),
( 124, 6.3, 2.7, 4.9, 1.8, N'Iris-virginica', 1), 
( 125, 6.7, 3.3, 5.7, 2.1, N'Iris-virginica', 1), 
( 126, 7.2, 3.2, 6.0, 1.8, N'Iris-virginica', 1), 
( 127, 6.2, 2.8, 4.8, 1.8, N'Iris-virginica', 1), 
( 128, 6.1, 3.0, 4.9, 1.8, N'Iris-virginica', 1), 
( 129, 6.4, 2.8, 5.6, 2.1, N'Iris-virginica', 1), 
( 130, 7.2, 3.0, 5.8, 1.6, N'Iris-virginica', 1), 
( 131, 7.4, 2.8, 6.1, 1.9, N'Iris-virginica', 1), 
( 132, 7.9, 3.8, 6.4, 2.0, N'Iris-virginica', 1), 
( 133, 6.4, 2.8, 5.6, 2.2, N'Iris-virginica', 1), 
( 134, 6.3, 2.8, 5.1, 1.5, N'Iris-virginica', 1), 
( 135, 6.1, 2.6, 5.6, 1.4, N'Iris-virginica', 1),
( 136, 7.7, 3.0, 6.1, 2.3, N'Iris-virginica', 1),
( 137, 6.3, 3.4, 5.6, 2.4, N'Iris-virginica', 1),
( 138, 6.4, 3.1, 5.5, 1.8, N'Iris-virginica', 1),
( 139, 6.0, 3.0, 4.8, 1.8, N'Iris-virginica', 1),
( 140, 6.9, 3.1, 5.4, 2.1, N'Iris-virginica', 1),
( 141, 6.7, 3.1, 5.6, 2.4, N'Iris-virginica', 1),
( 142, 6.9, 3.1, 5.1, 2.3, N'Iris-virginica', 1),
( 143, 5.8, 2.7, 5.1, 1.9, N'Iris-virginica', 1),
( 144, 6.8, 3.2, 5.9, 2.3, N'Iris-virginica', 1),
( 145, 6.7, 3.3, 5.7, 2.5, N'Iris-virginica', 1),
( 146, 6.7, 3.0, 5.2, 2.3, N'Iris-virginica', 1),
( 147, 6.3, 2.5, 5.0, 1.9, N'Iris-virginica', 1),
( 148, 6.5, 3.0, 5.2, 2.0, N'Iris-virginica', 1), 
( 149, 6.2, 3.4, 5.4, 2.3, N'Iris-virginica', 1), 
( 150, 5.9, 3.0, 5.1, 1.8, N'Iris-virginica', 1)
go

with cte as
(
	select top (45) * from dbo.Iris order by NEWID()
)
update cte set use_for_training = 0
go

create table dbo.SavedModels
(
	[id] int not null primary key,
	[model] varbinary(max) not null
)
go
