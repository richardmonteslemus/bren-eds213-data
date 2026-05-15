-- Which sites have no egg data? 
SELECT Code, Site_name FROM Site;

-- Technique 1: Find sites not in bird eggs table 
SELECT DISTINCT Code FROM Site
    WHERE Code NOT IN (SELECT DISTINCT Site FROM Bird_eggs)
    ORDER BY Code;

-- Technique 2: Use outer join to find sites not in bird eggs table 
SELECT S.Code FROM Site AS S
    LEFT JOIN Bird_eggs AS BE ON S.Code = BE.Site
    WHERE BE.Site IS NULL
    ORDER BY S.Code;


