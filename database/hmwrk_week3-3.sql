-- Part 1 

-- Calculate average egg volume per Nest in Bird_eggs dataset

-- Observe the data first 
SELECT * FROM Bird_eggs LIMIT 20;

-- Create table with egg volume per nest
-- Colums are Nest_ID and egg_volume
SELECT Nest_ID, (pi()/6) * (Width ^ 2 * Length) AS egg_volume
    FROM Bird_eggs;


-- Calculate average egg colume per Nest_ID and create temp table
CREATE TEMP TABLE Averages AS 
    SELECT Nest_ID , AVG(egg_volume) AS Avg_volume
        FROM (
            SELECT Nest_ID, (3.14/6) * (Width ^ 2 * Length) AS egg_volume
                FROM Bird_eggs
                ) AS egg_volumes
        GROUP BY Nest_ID;

-- Observe the temp averages data 
SELECT * FROM Averages LIMIT 20;

-- Observe the Bird_nests data 
SELECT * FROM Bird_nests LIMIT 20;

-- Join Averages Table to Bird_Nests to obtain temp max averages data
CREATE TEMP TABLE code_max_avg AS
    SELECT Species, MAX(Avg_volume) as Max_avg
        FROM Bird_nests JOIN Averages USING (Nest_ID)
        GROUP BY Species;

-- Observe the temp max averages data 
SELECT * FROM code_max_avg LIMIT 20;

-- Observe the Species data 
SELECT * FROM Species LIMIT 20;

-- Join scientific name to species codes
-- Return table ordered by maximum egg volume average
SELECT Scientific_name, Max_avg
        FROM code_max_avg CM LEFT JOIN Species S
        ON CM.Species = S.Code
        ORDER BY Max_avg DESC;


