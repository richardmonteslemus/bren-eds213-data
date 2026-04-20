# open DuckDB on database file
.table

-- find out whats inside 
.schema 

-- Select location in order
SELECT DISTINCT Location
    FROM Site
    ORDER BY Location
    LIMIT 3;

-- write query in file, use .read to execute it
-- good idea to capture schema in SQL file to recreate database, for documentation

-- FILTERING

SELECT * FROM Site WHERE Area < 200;

SELECT Area FROM Site WHERE Area < 200;


-- ...AND Latitude > 60,
-- not equals: classic is <>, but everybody supports != nowadays
-- string matching
-- double up single quotes to create a single quote: 'I don''t like this'
-- LIKE '...', % for wildcard
-- string matching might be case (in)sensitive, check database settings
-- DuckDB: ILIKE for case-insensitive
-- regexp usually supported via functions

-- EXPRESSIONS
SELECT Site_name, Area*2.47 FROM Site;
    -- AS name to give name to computed column
-- || to concatenate strings


AGGREGATION & GROUPING
SELECT COUNT(*) FROM Species;
-- number of rows
SELECT COUNT(Scientific_name) FROM Species;
-- number of non-NULL values
SELECT COUNT(DISTINCT Relevance) FROM Species;
-- same as SELECT DISTINCT, but see how many rows are returned

SELECT Location, AVG(Area) FROM Site; 

SELECT Location, AVG(Area) FROM Site GROUP BY Location;

SELECT Location, COUNT(*) FROM Site GROUP BY Location;
-- for comparison 
-- Site %>% group_by(Location) &>& summarize(count=n())

-- We can site have WHERE clauses 
SELECT Location, COUNT(*)
    FROM Site 
    WHERE Location LIKE '%Canada' -- old style pattern-matching, NOT full regex, just wildcard (%)
    GROUP BY Location;

-- The order of the clauses reflect the order of the processing 
-- But, what if you want to do some filtering on your groups, i.e., *after* you;ve done the grouping? 

SELECT Location, MAX(Area) AS Max_area
    FROM Site 
    WHERE Location Like '%Canada'
    GROUP BY Location 
    HAVING Max_area > 200
    ORDER BY Max_area DESC;

## Relational Algebra 
-- Everything is a table 
-- Every query, every statement actaully, returns a table 

SELECT COUNT(*) FROM Site;
-- you can save tables, you can nest queries
SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM Site );

-- you can nest queries 
SELECT DISTINCT Species FROM Bird_nests;

-- Return 80 rows 
SELECT Code FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);


## NULL Processing 
-- NULL is infectious 
-- In a table, NULL means no data, the absence of a value 
-- In an expression, NULL means unknown 
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = 'float';

-- Use <> to return those not float 
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod <> 'float';

-- This won't work, but you will try it by accident 
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod = NULL;
-- The ONLY WAY 
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NULL;
SELECT COUNT(*) FROM Bird_nests WHERE ageMethod IS NOT NULL;
-- So called "tri-value" logic
-- JOINS 
-- 90% of the time, we'll join tables based on a foreign key relationship 
SELECT * FROM Camp_assignment; 
SELECT * FROM Camp_assignment JOIN Personnel 
    ON Observer = Abbreviation 
    LIMIT 10;

-- Join is a very general table operation, can be applied to any tables, with any expression joining them 
-- fundamentally, joins always start with Cartesian product of the table 
-- CROSS JOIN = Cartesian product 
SELECT * FROM Site CROSS JOIN Species; 
SELECT COUNT(*) FROM Site; 
SELECT COUNT(*) FROM Species;
SELECT 99*16;

-- *any* condition can be expression, we have complete freedom here 
-- but when there is a foreign key relationship, then what happens?
-- the result is the same as the table with the foreign key, but augmented with additonal columns 
SELECT * FROM Bird_nests BN JOIN Species S
    ON BN.Species = S.Code
    LIMIT 5;

-- Still have the same number of rows that Bird_nests had 
SELECT COUNT(*) FROM Bird_nests BN JOIN Species s
    ON BN.Species = S.Code;

-- Table aliases
-- Sometimes if column names are ambiguous we qualify the name 
SELECT * FROM Bird_nests JOIN Species
    ON Bird_nests.Species = Species.Code;

-- Longer name verison 
SELECT * FROM Bird_nests AS BN JOIN Species AS S
    ON BN.Species = S.Code;







