--CREATE TABLE Tabla01
--(
--	Codigo INT IDENTITY(1,1),
--	Valor CHAR(10)
--)

--INSERT INTO Tabla01
--VALUES(REPLICATE('A',10))
--,(REPLICATE('B',10))
--,(REPLICATE('C',10))
--,(REPLICATE('D',10))
--,(REPLICATE('E',10))

-- verificamos las paginas que ha sido ocupadas con la data de la tabla
--DBCC ind('MemoryTest','Tabla01',0)

----checkpoin para bajar las paginas "dirty"
--CHECKPOINT
----limpiamos el buffer cache de las páginas "Clean"
--DBCC DROPCLEANBUFFERS

SELECT
(
	CASE WHEN ([database_id] = 32767)
			THEN 'Resourse DataBase'
		 ELSE DB_NAME([database_id])
	END
) AS [DataBaseName],
COUNT 
(
	CASE WHEN is_modified = 1 THEN is_modified
	ELSE NULL
	END
) AS [DirtyPages]
,
COUNT 
(
	CASE WHEN is_modified = 0 THEN is_modified
	ELSE NULL
	END
) AS [CleanPages]
FROM sys.dm_os_buffer_descriptors
WHERE database_id = DB_ID('MemoryTest')
GROUP BY database_id

--SELECT * FROM Tabla01

-- ahora veremos a mas detalle todas las páginas que se encuentran en memoria
SELECT *
FROM sys.dm_os_buffer_descriptors
WHERE database_id = DB_ID('MemoryTest')
ORDER BY page_id

DBCC TRACEON(3604)
DBCC PAGE('MemoryTest',1,528,3)