-- Week 8.2 How walkable is my favorite location in the US?

-- Build query 
duckdb mywalkability_richardmonteslemus.duckdb < mywalkability_richardmonteslemus.sql

-- INSTALL spatial;
LOAD spatial;

-- INSTALL httpfs;
LOAD httpfs;

-- City selection: 

-- Capitol Hill, Seattle Washington 

-- Latitude: 47.6152
-- Longitude: -122.3191

-- Data Import
CREATE OR REPLACE TABLE Fips AS (
    SELECT * FROM read_csv('https://apps.bren.ucsb.edu/eds213-data/walkability/fips_state_county.csv')
);

-- Create a VIEW for neighborhood of interest walkability data
CREATE OR REPLACE VIEW Walkability_wa AS (
    SELECT GEOID10, STATEFP, COUNTYFP, TRACTCE, BLKGRPCE, 
           CBSA, CBSA_Name, TotPop, NatWalkInd, geom_wgs84
    FROM read_parquet('https://apps.bren.ucsb.edu/eds213-data/walkability/walkability_wgs84.parquet')
    WHERE STATEFP = '53'
);

-- Join tables 
CREATE OR REPLACE VIEW Walkind_wa AS (
    SELECT w.GEOID10, w.STATEFP, w.COUNTYFP, w.TRACTCE, w.BLKGRPCE,
           w.CBSA, w.CBSA_Name, w.TotPop, w.NatWalkInd, w.geom_wgs84,
           f.State_name, f.County_name
    FROM Walkability_wa w
    JOIN Fips f
        ON w.STATEFP = f.STATEFP
        AND w.COUNTYFP = f.COUNTYFP
);

-- Select geo info for location choice
SELECT GEOID10, TRACTCE, COUNTYFP, County_name, NatWalkInd
FROM Walkind_wa
WHERE ST_Within(ST_Point(-122.3191, 47.6152), geom_wgs84);

-- Capitol hill is located in an area with a walkability score of 18.83 which is extremely close to the max of 20. This means this area is extremely walkable. 
-- This alligns with my expectations, it is a densely populated area. 

-- Average Walkability Index at your Census Tract
SELECT
    TRACTCE,
    COUNT(*) AS Block_count,
    AVG(NatWalkInd) AS Walkind_tract_avg
FROM Walkind_wa
WHERE TRACTCE = '007500'
  AND COUNTYFP = '033'
  AND STATEFP = '53'
GROUP BY TRACTCE;

-- Average Walkability index at your county-level
SELECT
    COUNTYFP,
    County_name,
    COUNT(*) AS Block_count,
    AVG(NatWalkInd) AS Walkind_county_avg
FROM Walkind_wa
WHERE COUNTYFP = '033'
  AND STATEFP = '53'
GROUP BY COUNTYFP, County_name;

-- Discuss Results 
-- Capitol hill is much more walkable than the rest of the county. This makes sense, Capitol hill is densely populated and urban while the county as a whole is a mix of spread out rural areas and dense urban areas. 

-- Export your results
COPY (
    SELECT
        w.*,
        (SELECT AVG(NatWalkInd) FROM Walkind_wa
         WHERE TRACTCE = '007500' AND COUNTYFP = '033' AND STATEFP = '53'
        ) AS Walkind_tract_avg,
        (SELECT AVG(NatWalkInd) FROM Walkind_wa
         WHERE COUNTYFP = '033' AND STATEFP = '53'
        ) AS Walkind_county_avg
    FROM Walkind_wa w
    WHERE w.TRACTCE = '007500'
      AND w.COUNTYFP = '033'
      AND w.STATEFP = '53'
) TO 'mywalkability_richardmonteslemus.csv' (FORMAT CSV, HEADER true);

-- The geometry column was still there but not saved correctly. The geometry was not preserved. A better format could be GeoParquet. 