---- Select Rows From Tables 
SELECT * FROM A;
SELECT * FROM B;
---- CROSS JOIN REVIEW
---- Join should have sum of rows from both tables 
---- Same as cartesian product of all rows 
SELECT * FROM A CROSS JOIN B;

---- SELECT always select columns from the output computed after the FROM
SELECT acol1, acol2 FROM (SELECT * FROM A CROSS JOIN B);

---- Difference between COUNT(*) === number of row and COUNT(column) == Non-NULL values in that column or groups 
SELECT acol1, ANY_VALUE(acol2), COUNT(*)
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1;

---- COUNT(*) gets number of rows COUNT(bcol3) gets number of rows excluding NULL
SELECT acol1, ANY_VALUE(acol2), COUNT(bcol3)
    FROM (SELECT * FROM A CROSS JOIN B)
    GROUP BY acol1;

--- Using a condition 

SELECT * FROM A JOIN B ON acol1 < bcol1;

-- INNER or OUTER JOINS
-- Lets use a key to join these 
SELECT * FROM Student; 
SELECT * FROM House; 

-- INNER by default 
SELECT * FROM Student AS S JOIN HOUSE AS H ON S.House_ID = H.House_ID;

--- Requires the same column names 
SELECT * FROM Student JOIN House USING (House_ID);

-- OUTER JOINS 
SELECT * FROM Student FULL JOIN House USING (House_ID);

-- LEFT JOINS 
-- Joining onto Student
SELECT * FROM Student LEFT JOIN House USING (House_ID);

-- RIGHT JOINS 
-- Joining onto House
SELECT * FROM Student RIGHT JOIN House USING (House_ID);

-- 12 rows since three rows in house and 4 in student

-- Create empty table and copy and perform operations and joins 
SELECT * FROM Student CROSS JOIN House;
 CREATE TABLE Snow_cover (
               Site VARCHAR NOT NULL,
               Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
               Date DATE NOT NULL,
               Plot VARCHAR NOT NULL,
               Location VARCHAR NOT NULL,
               Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
               Water_cover REAL CHECK (Water_cover BETWEEN 0 AND 130),
               Land_cover REAL CHECK (Land_cover BETWEEN 0 AND 130),
               Total_cover REAL CHECK (Total_cover BETWEEN 0 AND 130),
               Observer VARCHAR,
               Notes VARCHAR,
               PRIMARY KEY (Site, Plot, Location, Date),
               FOREIGN KEY (Site) REFERENCES Site (Code)
           );
                                                          0 rows                                                        
COPY Snow_cover FROM "../ASDN_csv/snow_survey_fixed.csv" (header TRUE, nullstr "NA");
SELECT * FROM Snow_cover LIMIT 5;
CREATE TEMP TABLE Camp_assignment_copy AS
              SELECT * FROM Camp_assignment; 
SELECT * FROM Camp_assignment_copy LIMIT 5;
SELECT * FROM Personnel LIMIT 5;
SELECT Year, Site, Name FROM Camp_assignment_copy JOIN Personnel ON Observer = Abbreviation;

--- Using Views 
-- still appears in database when checking tables
-- Does not get deleted after exiting database
-- Use _v naming convention 
CREATE VIEW Camp_personnel_v AS
   SELECT Year, Site, Name 
   FROM Camp_assignment_copy JOIN Personnel ON Observer = Abbreviation;

-- Lets say we find out there is a bad site 
-- Use select first to check what you would delete 
SELECT * FROM Camp_assignment_copy WHERE Site == 'bylo';

-- Actually delete now 
DELETE FROM Camp_assignment_copy WHERE Site == 'bylo';

-- Check deletion 
SELECT * FROM Camp_personnel_v LIMIT 10;