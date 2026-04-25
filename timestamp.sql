declare @salida nvarchar(150)

DECLARE @tiemposalida timestamp

DECLARE @tiempoentrada varchar(100)
set @tiempoentrada=0x0000A83B00E6A297

set @tiemposalida=CAST(@tiempoentrada AS BINARY(8)); 

select cast(@tiemposalida as datetime)

--set @salida=CAST (@tiemposalida  as datetime) 
--print @salida


select cast(0x0000A83B00E8A55F as datetime)

--0x000000000FD33F5D

SELECT CAST(0x0000A83B00E98CD0 AS BINARY(8));  

SELECT CAST( 8 AS BINARY(2) );  


SELECT CONVERT(varbinary(8), CAST(CONVERT(DATETIME, GETDATE()) AS TIMESTAMP))