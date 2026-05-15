-- Who's the Culprit?
SELECT P.Name, COUNT(*) AS Num_floated_nests
FROM Bird_nests AS BN
    JOIN Personnel AS P ON BN.Observer = P.Abbreviation
WHERE BN.Site = 'nome'
    AND BN.Year BETWEEN 1998 AND 2008
    AND BN.ageMethod = 'float'
GROUP BY P.Name
HAVING COUNT(*) = 36;