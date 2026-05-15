# 1 
ls lists every file in my directory 
ls . also lists all the files in my directory 
ls "$(pwd)/../for_bash_essentials" also lists all the files in my directory, except there is a space before they are output 

# 2 
The second one prints the total number of lines for all CSV files, but not their names because using | wc -1 means it grabs the output of the concatinated csv file produced with cat. This csv files just has a number of lines, but not a name associated with the file. 

# 3 
I only get 2 for a.csv. This is because it is only getting the lines from the a.csv file it ignores the csv file made from concantinating. 

# 4 
You can add {} curly brackets to make to make it clear what part of that statement refers to a variable name. 

# 5 
It does not just see one variable passed to it because the * gets all csv file located in the directory which it is not able to run. 

# 6 
$ 1 would be the full date string 
    Thu May 1 10:30:00 PDT 2026 
$ 3 would be the third word in the date string 
    1 

# 7 
junk_file.txt ends up being empty. the > operator is destructive. 
I can fix this by creating a table that gets as an input > the sorted table and then rename it back to junk_file.txt

sort junk_file.txt > sorted_file.txt
mv sorted_file.txt junk_file.txt

# 8 
rm will remove all files in the current directory, but just the csv files. 


