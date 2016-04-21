------------------------------------------------------------------------
-- Topic:			R With SQL Server 2016 Demo
-- Author:			Davide Mauri
-- Credits:			-
-- Copyright:		Attribution-NonCommercial-ShareAlike 2.5
-- Tab/indent size:	4
-- Last Update:		2016-04-18
-- Tested On:		SQL SERVER 2016 RC1/RC2
------------------------------------------------------------------------
use Datasets
go

execute sp_execute_external_script 
@language = N'R', 
@script = N'
library(e1071)
iris = InputDataSet
nbc = naiveBayes(iris[,2:5], iris[,6])
OutputDataSet <- InputDataSet;',
@input_data_1 = N'select * from dbo.Iris where use_for_training = 1'
with result sets (
	(
		[id] int not null,
		[sepal_length_in_cm] decimal(3, 1) null,
		[sepal_width_in_cm] decimal(3, 1) null,
		[petal_length_in_cm] decimal(3, 1) null,
		[petal_width_in_cm] decimal(3, 1) null,
		[class] varchar(40) null,
		[use_for_training] bit null
	)
);

select * from dbo.SavedModels;
go

declare @model varbinary(max);
select @model = [model] from dbo.SavedModels where id = 1;

execute sp_execute_external_script 
@language = N'R', 
@script = N'
library(e1071);
iris = InputDataSet[,1:5];
model = unserialize(as.raw(model));
result = predict(model, iris);
result.df = as.data.frame(result)
iris.final = cbind(iris, InputDataSet[6])
iris.final = cbind(iris.final, result.df)
OutputDataSet = iris.final;
',
@input_data_1 = N'select * from dbo.Iris where use_for_training = 0',
@params = N'@model varbinary(max)',
@model = @model
with result sets 
(	
	(		
		[id] int not null,
		[sepal_length_in_cm] decimal(3, 1) null,
		[sepal_width_in_cm] decimal(3, 1) null,
		[petal_length_in_cm] decimal(3, 1) null,
		[petal_width_in_cm] decimal(3, 1) null,
		[known_class] varchar(40) null,
		[predicted_class] varchar(40) null
	)
)
