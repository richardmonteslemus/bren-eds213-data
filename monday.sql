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

