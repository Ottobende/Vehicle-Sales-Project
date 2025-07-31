SELECT*
FROM vehiclesale;

--- DATA SETUP
--- Duplicate the data and keep original

SELECT*
INTO vehiclesales1
FROM vehiclesale;

SELECT*
FROM vehiclesales1;

--- Check data types and change where neccesary, For the purpose of this project, we'll be changing that of saledate, odometer, mmr, sellingprice

ALTER TABLE vehiclesales1
ALTER COLUMN odometer INT;

ALTER TABLE vehiclesales1
ALTER COLUMN sellingprice INT;

ALTER TABLE vehiclesales1
ALTER COLUMN mmr INT;

ALTER TABLE vehiclesales1
ALTER COLUMN year INT;

ALTER TABLE vehiclesales1
ALTER COLUMN saledate DATE;

--- There was a problem converting the date. We'll run the query below to see which values are failing
--- DATA CLEANING

SELECT saledate
FROM vehiclesales_copy
WHERE TRY_CONVERT(DATE, saledate) IS NULL
	AND saledate IS NOT NULL;

--- The query above shows all saledate values that cannot be converted to a valid date.
--- We have to clean to all bad dates because our present saledate is not a standard sql server date format, so we'll extract the date portion before converting it to DATE.
--- Preview cleaned values

SELECT saledate,
	SUBSTRING(saledate, 5, 11) AS CleanedDate
FROM vehiclesales1;

--- We'll use CONVERT() with style 113, which works with our new cleandate format
--- Convert cleaned text to date

SELECT saledate,
	TRY_CONVERT(DATE, SUBSTRING(saledate, 5, 11), 113) AS NewDate
FROM vehiclesales1;

--- We now have our cleaned date and will now add it to our table as saledate_cleaned

ALTER TABLE vehiclesales1 ADD saledate_cleaned DATE;

--- Our new column was successfully added but as you can see all rows appeared as NULL values. To fix this, we'll use the query below

SELECT*
FROM vehiclesales1;

--- Convert to the correct type

UPDATE vehiclesales1
SET saledate_cleaned = TRY_CONVERT(DATE, SUBSTRING(saledate, 5, 11), 113);

--- We'll the cross check if all our NULL values were corectly fixed

SELECT*
FROM vehiclesales1
WHERE saledate_cleaned IS NULL;



--- We can clearly see that we still have some rows with NULL values 

SELECT saledate, SUBSTRING(saledate, 5, 11) AS ExtractedDate
FROM vehiclesales1
WHERE TRY_CONVERT(DATE, SUBSTRING(saledate, 5, 11), 113) IS NULL;

--- our extracted dates had NULL values because the 'saledate' was wrongly entered. We'll look at ths when dealing with blank and null values 
--- We'll drop all extracted dates with incorrect date formats by running the query below.

DELETE FROM vehiclesales1
WHERE TRY_CONVERT(DATE, SUBSTRING(saledate, 5, 11), 113) IS NULL;

--- Checking NULL and BLANK values. We'll begin by checking how many null and blank values we have for the respective columns by running this query.

SELECT*
FROM vehiclesales1
WHERE year IS NULL OR year = ''
	OR make IS NULL OR make = ''
	OR model IS NULL OR model = ''
	OR trim IS NULL OR trim = ''
	OR body IS NULL OR body = ''
	OR transmission IS NULL OR transmission = ''
	OR vin IS NULL OR vin = ''
	OR state IS NULL OR state = ''
	OR condition IS NULL OR condition = ''
	OR odometer IS NULL OR odometer = ''
	OR color IS NULL OR color = ''
	OR interior IS NULL OR interior = ''
	OR seller IS NULL OR seller = ''
	OR mmr IS NULL OR mmr = ''
	OR sellingprice IS NULL OR sellingprice = ''
	OR saledate_cleaned IS NULL OR saledate_cleaned = '';

--- We'll treat the NULL and BLANK values seperately per column 
--- We'll drop all sellingprice and saledate rows with null and blank values 

SELECT COUNT(sellingprice) AS TotalSellingprice
FROM vehiclesales1
WHERE sellingprice IS NULL OR sellingprice = '';

DELETE FROM vehiclesales1
WHERE sellingprice IS NULL OR sellingprice = '';

SELECT COUNT(saledate) AS Totalsaledate
FROM vehiclesales1
WHERE saledate IS NULL OR saledate = '';

--- We'll populate the Make, Model, Trim, Color and Seller columns and replace the Null and or Blank values with 'Unkown'

SELECT ISNULL(make, 'Unknown') AS make
FROM vehiclesales1;

SELECT COUNT(*) AS Total 
FROM vehiclesales1
WHERE seller IS NULL OR seller = '';

SELECT*
FROM vehiclesales1
WHERE trim = 'Unkown';

UPDATE vehiclesales1
SET model= 'Unkown'
WHERE model IS NULL OR model = '';

UPDATE vehiclesales1
SET make = 'Unkown'
WHERE make IS NULL OR make = '';

UPDATE vehiclesales1
SET trim = 'Unkown'
WHERE trim IS NULL OR trim = '';

UPDATE vehiclesales1
SET color = 'Unkown'
WHERE color IS NULL OR color = '';

UPDATE vehiclesales1
SET color = 'Unkown'
WHERE color IS NULL OR color = '';

UPDATE vehiclesales1
SET transmission = 'Unkown'
WHERE transmission IS NULL OR transmission = '';

UPDATE vehiclesales1
SET body = 'Unkown'
WHERE body IS NULL OR body = '';

UPDATE vehiclesales1
SET condition = 'Unkown'
WHERE condition IS NULL OR condition = '';

UPDATE vehiclesales1
SET interior='Unkown'
WHERE interior IS NULL OR interior = '';

--- We'll drop null and blank rows for odometer, sellingprice, salesdate

SELECT*
FROM vehiclesales1
WHERE odometer IS NULL OR odometer = '';

DELETE FROM vehiclesales1
WHERE odometer IS NULL OR odometer = '';

SELECT*
FROM vehiclesales1
WHERE saledate_cleaned IS NULL OR saledate_cleaned = '';

--- Checking duplicates, We'll be excluding vin from this 

SELECT  make, model,year, trim, body, transmission,state, condition, odometer, color, interior, seller, mmr, sellingprice, saledate_cleaned, COUNT(*) AS Count
FROM vehiclesales1
GROUP BY make, model,year, trim, body, transmission,state, condition, odometer, color, interior, seller, mmr, sellingprice, saledate_cleaned
HAVING COUNT(*) > 1;

--- DATA EXPLORATION 
--- Questions
--- Q1. What are the most common car makes and models

SELECT TOP 10 make, model, COUNT(*) AS Most_Common
FROM vehiclesales1
GROUP BY make, model
ORDER BY Most_Common DESC;

--- Q2. What is the average selling price by make and model

SELECT make, model,
		COUNT(*) AS Carslisted,
		AVG(sellingprice) AS AvgSellingPrice
FROM vehiclesales1
GROUP BY make, model
ORDER BY AvgSellingPrice DESC;

--- Q3. How does mileage (odometer) affect price?

WITH mileage AS (
	SELECT
		CASE
			WHEN odometer < 20000 THEN 'Under 20k' 
			WHEN odometer BETWEEN 20000 AND 49999 THEN '20K - 49K'
			WHEN odometer BETWEEN 50000 AND 99999 THEN '50K - 99K'
			WHEN odometer BETWEEN 100000 AND 149999 THEN '100K - 149K'
			ELSE '150K+'
		END AS MileageRange,
		sellingprice
	FROM vehiclesales1
	WHERE odometer IS NOT NULL AND sellingprice IS NOT NULL
)
SELECT 
	MileageRange,
	COUNT(*) AS Cars_in_Range,
	AVG(CAST(sellingprice AS FLOAT)) AS Avg_Selling_Price
FROM Mileage
GROUP BY MileageRange
ORDER BY 
	CASE
		WHEN MileageRange = 'Under 20k' THEN 1 
		WHEN MileageRange = '20K - 49K' THEN 2 
		WHEN MileageRange = '50K - 99K' THEN 3 
		WHEN MileageRange = '100K - 149K' THEN 4
		ELSE 5
	END;

--- Q4. How do car condtion affect prices

SELECT 
	condition, 
	COUNT(*) AS Cars_in_Condition,
	AVG(sellingprice) AS Avg_Price
FROM vehiclesales1
WHERE sellingprice IS NOT NULL AND condition IS NOT NULL
GROUP BY condition
ORDER BY Avg_Price DESC ;

--- Q5 What is the price trend over time(monthly)

WITH MonthlyPrice AS (
	SELECT 
		FORMAT(saledate_cleaned, 'yyyy-MM') AS Sale_Month,
		CAST(sellingprice AS float ) AS SellingPrice
	FROM vehiclesales1
	WHERE saledate_cleaned IS NOT NULL AND sellingprice IS NOT NULL
)
SELECT 
	Sale_Month,
	COUNT(*) AS Cars_Sold,
	AVG(sellingprice) as Avg_Selling_Price
FROM MonthlyPrice
GROUP BY Sale_Month
ORDER BY Sale_Month;

--- Q6 Which states have the highest average prices?

SELECT
	state,
	COUNT(*) AS Cars_Sold,
	AVG(sellingprice) AS Highest_Avg_Price
FROM vehiclesales1
WHERE state IS NOT NULL AND sellingprice IS NOT NULL
GROUP BY state
ORDER BY  Highest_Avg_Price DESC;

--- Q7 Sellers with the highest average prices

SELECT
	seller,
	COUNT(*) AS Cars_Sold,
	AVG(sellingprice) AS Highest_Avg_Price
FROM vehiclesales1
WHERE seller IS NOT NULL AND sellingprice IS NOT NULL
GROUP BY seller
HAVING COUNT(*) >= 10
ORDER BY  Highest_Avg_Price DESC;

--- Q8 Compare expected price(mmr) vs actual selling price

SELECT
	make, model,
	AVG(mmr) AS Avg_Expected_Price,
	AVG(sellingprice) AS Avg_Selliing_Price,
	AVG(sellingprice - mmr) AS Avg_Price_Difference
FROM vehiclesales1
WHERE mmr IS NOT NULL AND sellingprice is not null
GROUP BY make, model
ORDER BY Avg_Price_Difference DESC;

--- We'll delete our original saledate colun and keep the new one which is in the SQL format

ALTER TABLE vehiclesales1
DROP COLUMN saledate;

--- We'll rename our saledate_cleaned column 

EXEC sp_rename 'vehiclesales_copy.saledate_cleaned', 'Saledate', 'COLUMN';

SELECT*
FROM vehiclesales1;

--- END of Query
