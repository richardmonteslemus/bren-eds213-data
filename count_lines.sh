#!/bin/bash

for file in *.csv; do
    echo "$file has $(wc -l < $file) lines"
done