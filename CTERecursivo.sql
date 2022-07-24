WITH DirectReports(ManagerID,EmployeeID,Title,Name
,EmployeeLevel
) AS
(
	SELECT ReportsTo,EmployeeID,Title,FirstName+' '+LastName AS Name
	,10
	FROM Employees
	WHERE ReportsTo IS NULL
	UNION ALL
	SELECT e.ReportsTo,e.EmployeeID,e.Title,FirstName+' '+LastName AS Name
	,EmployeeLevel - 1
	FROM Employees AS e
	INNER JOIN DirectReports AS d
	ON e.ReportsTo=d.EmployeeID
)
SELECT ManagerID,EmployeeID,Title,Name
,EmployeeLevel
FROM DirectReports
ORDER BY ManagerID

--SELECT EmployeeID,ReportsTo,* FROM Employees