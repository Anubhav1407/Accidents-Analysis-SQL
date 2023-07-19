                                                                                                                 -- ACCIDENT ANALYSIS

--Q1. How many accidents have occured in urban areas versus rural areas?

Select Area, COUNT(AccidentIndex) AS 'Total Accidents'
FROM [dbo].[accident#csv$]
GROUP BY Area

--Q2. Which day of the week has the highest number of accidents?

Select Day, COUNT(AccidentIndex) AS 'Total Accidents'
FROM [dbo].[accident#csv$]
GROUP BY Day
ORDER BY 'Total Accidents' DESC

--Q3. What is the average age of vehicles involved in accidents based on their type?

Select VehicleType, COUNT(AccidentIndex) AS 'Total Accidents',
AVG(AgeVehicle) AS 'Avg Age'
FROM [dbo].[vehicle#csv$]
WHERE [AgeVehicle] IS NOT NULL
GROUP BY VehicleType
ORDER BY 'Total Accidents' DESC

--Q4.  Can we identify any trends in accidents based on the age of vehicles involved?

Select AgeGroup, COUNT([AccidentIndex]) AS 'Total Accidents',
AVG([AgeVehicle]) AS 'Average Year'
FROM (
SELECT [AccidentIndex], [AgeVehicle],
CASE
	WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN 'New'
	WHEN [AgeVehicle] BETWEEN 6 AND 10 THEN 'Regular'
	ELSE 'Old'
END AS 'AgeGroup'
FROM [dbo].[vehicle#csv$]
) AS SubQuery
GROUP BY
AgeGroup

--Q5. Are there any specific weather conditions that contribute to severe accidents?

DECLARE @Severity varchar(100)
SET @Severity = 'Fatal'

Select [WeatherConditions], COUNT(AccidentIndex) AS 'Total Accidents'
FROM [dbo].[accident#csv$]
WHERE [Severity] = @Severity
GROUP BY  [WeatherConditions]
ORDER BY 'Total Accidents' DESC

--Q6. Do accidents often involve impacts on the left hand side of the vehicles?

SELECT [LeftHand], COUNT([AccidentIndex]) AS 'Total Accident'
FROM [dbo].[vehicle#csv$]
GROUP BY [LeftHand]
HAVING [LeftHand] IS NOT NULL

--Q7. Are there any relationships between journey purposes and the severity of accidents?

SELECT V.[JourneyPurpose], COUNT(A.[Severity]) AS 'Total Accident',
CASE 
WHEN COUNT(A.[Severity]) BETWEEN 0 AND 1000 THEN 'Low'
WHEN COUNT(A.[Severity]) BETWEEN 1000 AND 2000 THEN 'Moderate'
ELSE 'High'
END AS 'Level'
FROM 
[dbo].[accident#csv$] A
JOIN 
[dbo].[vehicle#csv$] V ON V.AccidentIndex = A.AccidentIndex
GROUP BY V.[JourneyPurpose]
ORDER BY  'Total Accident'

--Q8. Calculate the average age of vehicles involved in accidents, considering Day light and point of impact?

SELECT A.[LightConditions], V.[PointImpact], AVG(V.[AgeVehicle]) AS 'Average Year'
FROM  [dbo].[accident#csv$] A
JOIN [dbo].[vehicle#csv$] V
ON V.[AccidentIndex] = A.[AccidentIndex]
GROUP BY  A.[LightConditions], V.[PointImpact]
HAVING [PointImpact] = 'Front' AND [LightConditions] = 'Darkness'
