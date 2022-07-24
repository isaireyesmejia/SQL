
CREATE VIEW ventascategoria
AS
SELECT c.CategoryName,datepart(yyyy,o.OrderDate) as año
,d.UnitPrice*d.Quantity AS total
FROM Categories AS c
INNER JOIN Products AS p
ON c.CategoryID=p.CategoryID
INNER JOIN [Order Details] AS d
ON p.ProductID=d.ProductID
inner join Orders as o
on o.OrderID=d.OrderID
GO

declare @añios nvarchar(400)
set @añios=''

select @añios=@añios+'['+T.anio+'],' from
(select distinct CAST((DATEPART(YYYY,OrderDate)) as varchar(150)) as anio 
from Orders) as T
set @añios=left(@añios,len(@añios)-1)
--select @añios

execute ('select * from ventascategoria pivot(sum(total) 
for año in('+@añios+')) as pvt')