
-- The Camp_assignment table lists where each person worked and when. Your goal is to answer, Who worked with whom? That is, you are to find all pairs of people who worked at the same site, and whose date ranges overlap while at that site. This can be solved using a self-join.
SELECT A.Site, A.Observer AS Observer_1, B.Observer AS Observer_2
FROM Camp_assignment A 
    JOIN Camp_assignment B 
        ON A.Site = B.Site
        AND A.Start <= B.End
        AND A.End >= B.Start
        AND A.Observer < B.Observer
-- WHERE A.Site = 'lkri'
ORDER BY A.Site, Observer_1, Observer_2;

-- Bonus 
SELECT A.Site, 
        P1.Name AS Name1, 
        P2.Name AS Name2
    FROM Camp_assignment A 
        JOIN Camp_assignment B
            On A.Site = B.Site 
            AND B.Start <= A.End
            AND A.Start <= B.End 
            AND A.Observer > B.Observer
        JOIN Personnel AS P1 ON P1.abbreviation = B.Observer
        JOIN Personnel AS P2 ON P2.abbreviation = A.Observer
    WHERE A.Site = 'lkri'  -- filter to desired site 
    ORDER BY A.Site, Name1, Name2;