-- Part 1 

-- Create temporary table for sql analysis 
Create TEMP TABLE mytable (
    Real_Num REAL 
);

-- Insert values into column 
INSERT INTO mytable (Real_Num)
VALUES (2), (6), (8), (10), (NULL);

-- Calculating average without modifications
SELECT AVG(Real_Num)
    FROM mytable;

-- Calculating average after filtering NULL
SELECT AVG(Real_Num)
    FROM mytable
    WHERE Real_Num IS NOT NULL;


-- By Default, using the AVG function on a column will calculate the average
-- for the column excluding NULLS. I confirmed this by using the AVG function 
-- on the column of interest after filtering out NULLS. This computed the same
-- value as using AVG without excluding NULLS, 6.5. This calculations would look
-- as follows (2 + 6 + 8 + 10)/4 = 6.5. If NULL was included and being treated as 0, the 
-- average would have computed to (2 + 6 + 8 + 10 + 0)/5 = 5.2. This experiment 
-- confirmed the AVG function by default excludes NULL in the column's 
-- average calculation since the average is equivalent the calculation that 
-- explicitly excludes NULL in the average calculation. 

-- Part 2 

-- Testing manual algebraic equations for calculating average 
SELECT SUM(Real_Num)/COUNT(*) FROM mytable;

SELECT SUM(Real_Num)/COUNT(Real_Num) FROM mytable;

-- The second query is correct because it only includes non-null values in the Real_Num column for the average 
-- calculation. It uses the number of non-null values to calculate num_val in this equation (sum(num)/num_val)
-- to calculate average. 

-- The first query on the other hand would include the total number of rows in the Real_Num column for the average 
-- calculation. It uses both the number of null and non_null value to calculate null_val in this equation (sum(num)/num_val) 
-- This means it would include the rows with NULL to calculate average. It is wrong for this calculation to include 
-- NULL in this calculation because the average calculation with AVG purposely excluded NULL and NULL shouldnt be 
-- treated as a number used for this calculation, it signifies an empty value. 
