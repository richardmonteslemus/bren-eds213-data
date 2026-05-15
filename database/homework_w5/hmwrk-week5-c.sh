#!/bin/bash

# Part 1 
label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

# Get current time 
initial_time=$(date +%s)

i=0
while [ $i -lt $num_reps ]; do
    duckdb $db_file "$query" > /dev/null 2>&1
    i=$((i+1))
done

final_time=$(date +%s)

elapsed=$((final_time - initial_time))

per_rep=$(python -c "print($elapsed/$num_reps)")
echo "$label, $per_rep" >> $csv_file

# Bash Command Used: bash hmwrk_week5-c.sh with_index_a 100 'SELECT Species, COUNT(Species) FROM Bird_nests GROUP BY Species' database.duckdb timings.csv

# Part 2 
# Test the speed of the following queries
# 1) SELECT Code FROM Species WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
# Bash command: bash hmwrk_week5-c.sh  subquery 1000 'SELECT Code FROM Species WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests)' database.duckdb timings.csv

# 2) SELECT Code FROM Bird_nests RIGHT JOIN Species ON Species = Code WHERE Nest_ID IS NULL;
# Bash command: bash hmwrk_week5-c.sh  outer_join 1000 'SELECT Code FROM Bird_nests RIGHT JOIN Species ON Species = Code WHERE Nest_ID IS NULL' database.duckdb timings.csv

# 3) SELECT Code FROM Species EXCEPT SELECT DISTINCT Species FROM Bird_nests;
# Bash command: bash hmwrk_week5-c.sh  except 1000 'SELECT Code FROM Species EXCEPT SELECT DISTINCT Species FROM Bird_nests' database.duckdb timings.csv

# Reflection
# I had to use 1000 repetitions to get good timings for three query methods that find out which species we do not have nest data for. 
# The outer join method followed by dropping NULL rows in the Nest_ID column is the fastest method. On average it took 0.029 seconds to run each outer join query. 

