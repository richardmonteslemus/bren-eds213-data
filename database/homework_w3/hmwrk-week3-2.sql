
-- Part 1 

-- Return site with largest Area

-- Test incorrect query 
SELECT Site_name, MAX(Area) FROM Site;

-- This query is incorrect because it is attempting to calculate the maximum area (MAX(Area))
-- for the entirety of the Site_name column. This cant be done, the Site_column is
-- an entire column worth of characters and you cannot calculate a single maximum area 
-- corresponding to an entire column. You would need to specify this action is actually 
-- calculating the maximum area of every unique value in Site_name. Using GROUP BY allows this 
-- correct calculation to occur, it calculates maximum area per Site_name group 
-- (aka unique character in Site_name).  

-- Part 2 
-- Correctly calculate maximum area per Site_name
-- Return the top Site_name and maximum area
SELECT Site_name, MAX(Area) AS Max_area 
    FROM Site 
    GROUP BY Site_name
    ORDER BY Max_area DESC
    LIMIT 1;

-- Part 3
-- Use a nested query to return the top Site_name and maximum area 
SELECT Site_name, Area 
FROM Site 
WHERE Area = (SELECT MAX(Area) FROM Site);
