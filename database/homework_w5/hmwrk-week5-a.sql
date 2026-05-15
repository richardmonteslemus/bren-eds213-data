--- EDS 213 Week 5 Hmwrk 1 

-- Part 1

-- Step 1

CREATE TABLE Nests_big AS SELECT * FROM 'nests_big.csv';

CREATE TABLE Eggs_big AS SELECT * FROM 'eggs_big.csv';

-- Check tables 
rows 
SELECT COUNT(*) FROM Nests_big;
SELECT COUNT(*) FROM Eggs_big;

-- Sample rows 
SELECT * FROM Nests_big LIMIT 10;
SELECT * FROM Eggs_big LIMIT 10;
SELECT * FROM Species LIMIT 10;

-- Check column names and data types
DESCRIBE Nests_big; 
DESCRIBE Eggs_big; 

-- Step 2
SELECT * FROM Eggs_big AS EB 
    JOIN Nests_big AS NB USING (Nest_ID)
    JOIN Species AS S ON NB.Species = S.Code
    WHERE Scientific_name == 'Calidris alpina';

-- Step 3
SELECT NB.Site,
       3.14 / 6 * (EB.Width * EB.Width * EB.Length) AS Volume
FROM Eggs_big AS EB
    JOIN Nests_big AS NB USING (Nest_ID)
    JOIN Species ON NB.Species = Species.Code
WHERE Species.Scientific_name = 'Calidris alpina';

-- Step 4
CREATE VIEW Site_volume AS 
    SELECT NB.Site,
       3.14 / 6 * (EB.Width * EB.Width * EB.Length) AS Volume
FROM Eggs_big AS EB
    JOIN Nests_big AS NB USING (Nest_ID)
    JOIN Species ON NB.Species = Species.Code
WHERE Species.Scientific_name = 'Calidris alpina';

SELECT S.Longitude, SV.Volume
    FROM Site_volume AS SV
        JOIN Site AS S ON SV.Site = S.Code;

--- Step 5

-- Check max and min Longitude
SELECT MIN(S.Longitude), MAX(S.Longitude), MIN(SV.Volume)
    FROM Site_volume AS SV
        JOIN Site AS S ON SV.Site = S.Code;

-- Use case when to fix longitude issues 

SELECT CASE WHEN S.Longitude > 0 THEN S.Longitude - 360 ELSE S.Longitude END AS Longitude,
       SV.Volume
    FROM Site_volume AS SV
        JOIN Site AS S ON SV.Site = S.Code;

-- Step 6
CREATE VIEW Long_Vol AS 
    SELECT CASE WHEN S.Longitude > 0 THEN S.Longitude - 360 ELSE S.Longitude END AS Longitude,
       SV.Volume
        FROM Site_volume AS SV
            JOIN Site AS S ON SV.Site = S.Code;

--- Step 7
SELECT regr_slope(Volume, Longitude) AS Slope, 
       corr(Volume, Longitude) AS PCC
    FROM Long_Vol;


-- PART 2
-- 1) No, it does not guarantee that the Nest_ID column from Nests_big matches
-- the Nest_ID column from Eggs_big. This is because the tables were simply 
-- loaded in from csv files, I didnt add constaints like a foreign key for one 
-- of them, which would have guaranteed they exist in both. 

-- 2) I used the following queries 
-- Check max and min Longitude
SELECT MIN(S.Longitude), MAX(S.Longitude), MIN(SV.Volume)
    FROM Site_volume AS SV
        JOIN Site AS S ON SV.Site = S.Code;

-- 3) Since the Pearson correlation coefficient is - 0.1, I would say there is a very 
-- weak negative correlation between egg volume and longitude for Calidris alpina. Since 
-- it is close to zero we cannot reject the possibility that there is no correlation between 
-- egg volume and longitude, the correlation is not significant. 