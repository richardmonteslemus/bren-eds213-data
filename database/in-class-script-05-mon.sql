## Recap: Views 

-- view is a kind of virtual table 
-- Stored in the database 
-- Executed everytime it's referenced 
-- Ineffect, a view is a kind of shortcut 
-- It's similar to a function in a programming language 

-- Example: Supposed we want to look at bird nests, but we always would rather see scientific names not species codes 

CREATE VIEW Nest_view AS 
    SELECT Book_page, Year, Site, Nest_ID, Scientific_name, Observer
    FROM Bird_nests JOIN species 
    ON Species = Code; 

SELECT * FROM Nest_view LIMIT 1; 
-- for comparison 
SELECT * FROM Bird_nests LIMIT 1; 

-- Let's use our view for a more substantial purpose 
SELECT Nest_ID, ANY_VALUE(Scientific_name), COUNT(*) AS Num_eggs
    FROM Nest_view JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID; 

View compared to temp tables: 
-- Temp table is more like a variable ion a programming language 
-- As the name suggests, "TEMP" table only lasts for the session

-- Another option: Use a WITH clause 
WITH x AS (
SELECT Nest_ID, ANY_VALUE(Scientific_name) AS Scientific_name, COUNT(*) AS Num_eggs
    FROM Nest_view JOIN Bird_eggs
    USING (Nest_ID)
    GROUP BY Nest_ID; 
) SELECT Scientific_name, AVG(Num_eggs) AS AVG(Num_eggs) AS Avg_num_eggs FROM x
  GROUP BY Scientific_name;   

-- The variable ("x" in this case) only lasts for the statement; it's really a kind of abbreviation 

-- Does not exist
SELECT * FROM x;

-- You could use view info in the main table without actually exposing information to the table 

--  SET OPERATIONS
-- Recall that tables are **sets** of rows, not ordered lists 
-- We can do set operations on tables 
-- UNION, INTERSECT, EXCEPT (set difference)
-- One note: These are set operations so duplicates are eliminated in UNIONS 
-- But, if you did want to preserve all rows, UNION ALL

-- Example of a UNION: Let's go back to last week's quiz 
-- We want a table of bird nests and egg counts, but we also want entries for nests that have no eggs 
-- They should have a count of 0

SELECT Nest_ID, COUNT(Egg_num) AS Num_eggs
    FROM Bird_nests LEFT JOIN Bird_eggs 
    USING (Nest_ID)
    GROUP BY Nest_ID; 

-- Let's try solving the same problem, but using UNION 
SELECT Nest_ID, COUNT(*) AS Num_eggs
    FROM Bird_eggs
    GROUP BY Nest_ID;

-- UNION
SELECT Nest_ID, 0 AS Num_eggs
    FROM Bird_nests
    WHERE Nest_ID NOT IN (SELECT DISTINCT Nest_ID FROM Bird_eggs);

-- Join conditions on a foreign key, two ways 
- ... ON Species = Code 
-... ON Bird_nests.NEST_ID = Bird_eggs.NEST_ID
- but just more compact to say ... USING (Nest_ID)
- you can get away with *not* prefixing columns if they are unambiguous 
- but if the names are ambiguous, you need prefix them 

-- Note on UNION: SQL will UNION any two tables that have the same number of columns 
-- and compatible data types 

-- Example of when you might want to use EXCEPT: 
-- Question: Which species do we *not* have data for? 
-- Three ways 

-- Way #1 
SELECT Code from Species 
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
-- All of these 80 + species are not in Bird_nests but are in Species 

-- Way # 2 
SELECT Code
    FROM Bird_nests RIGHT JOIN Species
    On Species = Code 
    WHERE Species IS NULL; 
-- The resulting join will lead to some rows with NULL and then you return rows containing that NULL 

-- Way # 3 
SELECT Code FROM Species
EXCEPT 
SELECT DISTINCT Species FROM Bird_nests; 

-- Enough with SELECT!  Data Management Statements 

-- INSERT statements 
SELECT * FROM Personnel;
INSERT INTO Personnel VALUES ('rlemus', 'Richard Lemus');
SELECT * FROM Personnel; 

-- Good practice for safer code: name the columns 
INSERT INTO Personnel(Abbreviation, Name) VALUES('rmontes', 'Richard Montes');
-- Also, when you insert a row into a table you don't necessarily have to specify all 
-- the values; anything not specified will either be filled with NULL or a default value 
-- So that's another reason for spelling out the column names 

SELECT * FROM Bird_nests LIMIT 10;
UPDATE Bird_nests SET floatAge = 6.5, ageMethod = 'float'
    WHERE Nest_ID = '14HPE1';

SELECT * FROM Bird_nests LIMIT 10;

-- DELETE FROM Bird_nests WHERE ...; 

-- The above two commands (UPDATE, DELETE) are the just incrediblt dangerous 

-- The weird/terirble behavior: if no WHERE clause, they operate on *all* rows in the table 

-- Dont run 
UPDATE Bird_nests SET floatAge = NULL; 
SELECT * FROM Bird_nests;  -- makes floatAGE NULL fully 
.exit
git restore database.duckdb
duckdb database.duckdb

-- Whats the strategy to not make this terribel mistake ? 
-- One idea: 

-- First do a select to confirm the rows you want to operate on, then edit 
-- The statement to do an UPDATE 
SELECT * FROM Bird_nests WHERE Nest_ID = '98nome7';

-- Another idea 
-- Use a fake table_name, then change to the real name 
-- UPDATE Bird_nestsXXX SET ... WHERE ...; 

