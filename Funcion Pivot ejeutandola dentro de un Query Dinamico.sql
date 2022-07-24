
CREATE VIEW ventascategoria
AS
SELECT c.CategoryName,datepart(yyyy,o.OrderDate) as a�o
,d.UnitPrice*d.Quantity AS total
FROM Categories AS c
INNER JOIN Products AS p
ON c.CategoryID=p.CategoryID
INNER JOIN [Order Details] AS d
ON p.ProductID=d.ProductID
inner join Orders as o
on o.OrderID=d.OrderID
GO

declare @a�ios nvarchar(400)
set @a�ios=''

select @a�ios=@a�ios+'['+T.anio+'],' from
(select distinct CAST((DATEPART(YYYY,OrderDate)) as varchar(150)) as anio 
from Orders) as T
set @a�ios=left(@a�ios,len(@a�ios)-1)
--select @a�ios

execute ('select * from ventascategoria pivot(sum(total) 
for a�o in('+@a�ios+')) as pvt')