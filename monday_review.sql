First review item: tri-value logix 
Expressions can have a value (if Boolean, TRUE or FALSE), but they can also be NULL 
In selecting rows, NULL doesn't cut it, NULL doesn't count as TRUE 

SELECT COUNT(*) FROM Bird_nests 
    WHERE floatAge < 7 OR floatAGE >= 7;

SELECT COUNT(*) FROM Bird_nests
    WHERE floatAGE is NULL;

Review item: relational algebra
Everything is a table! Every operation returns a table!
Even a simple COUNT(*) reuturns a table 

SELECT COUNT(*) FROM Bird_nests;

We looked at one example of nesting SELECTs

SELECT Scientific_name
    FROM Species 
    WHERE Code  NOT IN ( SELECT DISTINCT Species FROM Bird_nests );

Let's pretend that SQL didn't have a HAVING clause. Could we somehow get the same functionality? 
Let's go back to the example where we used a HAVING clause

SELECT Location, MAX(Area) AS Max_area
    FROM Site 
    WHERE Location LIKE '%Canada'
    GROUP By Location 
    HAVING Max_area > 200;

As a reminder, the site table:
SELECT * FROM Site LIMIT 5;

SELECT * FROM 
        (SELECT Location, MAX(Area) AS Max_area
        FROM Site 
        WHERE Location LIKE '%Canada'
        GROUP By Location)
    WHERE Max_area > 200;

REVIEW AND CONTINUING DISCUSSION Of JOINS 

What is a join? Conceptually, the database performs a "Cartesian product" of the tables, 
then matches up rows based on some kind of join. 

In Soem databses , todo a Cartesian product you would just do a JOIN without a condition, e.g.,
SELECT * FROM a JOIN B; 
**But** in DuckDB 
SELECT * FROM a CROSS JOIN B; 
SELECT * FROM A;
SELECT * FROM B; 

Here's what the cartesian Product looks like:

SELECT * FROM A CROSS JOIN B; 

Let's a join condition,m which can be *any* expression! 

SELECT * FROM A INNER JOIN B  acol1 < bcol1; 

This is what is referred to as an INNER JOIN
SELECT * FROM A INNER JOIN B on acol1 < bcol1;

Outer join: we're adding rows from one table that never got matched. 

SELECT * FROM A RIGHT JOIN B ON acol1 < bcol1; 

SELECT * FROM A LEFT JOIN B on acol1 < bcol1;

Just for completenes (This is way more rare thaat you would want to do this): 
SELECT * FROM A FULL OUTER JOIN B ON acol1 < bcol1;

Now, joining on a foreign key relationship is way more common
.schema 

SELECT * FROM House; 
SELECT * FROM Student; 

Typical thing to do: 
SELECT * FROM Student S JOIN House H ON S.House_ID = H.House_ID;

As an aside without the alises: 
SELECT * FROM Student JOIN House on Student.House_ID = House.House_ID;

One nice benefit of joining on a column that has the same name (i.e., House_ID here)
is you can use USING clause

SELECT * FROM Student JOIN House USING (House_ID);
