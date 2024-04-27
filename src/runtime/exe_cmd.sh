# Author, purpose, version, date
# Atharva Date, Shell script to integrate modules, 1.0, 04/27/2024 

#!/bin/bash

# Step 1: Run lexer.py and capture its output
python lexer.py sample.naav > lexer_output.txt

# Step 2: Run SWI-Prolog and load parsing.pl
echo "consult('parsing.pl')." | swipl -q > prolog_output.txt

# Step 3: Read the contents of lexer_output.txt and use it in the Prolog query
lexer_contents=$(cat lexer_output.txt)

# Step 4: Run the Prolog query with lexer_contents
echo "program(P, $lexer_contents, []), write(P), halt." | swipl -q >> prolog_output.txt

# Display the Prolog output
cat prolog_output.txt
