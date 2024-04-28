# Author, purpose, version, date
# Atharva Date, Executor file to integrate all 3 modules, 1.0, 04/26/2024 
# Vidya Rupak, Executor file minor fixes in lexer part, 2.0, 04/26/2024 
# Atharva Date, Introducing pyswip for prolog file execution in python, 3.0, 04/27/2024 
# Atharva Date, Integrate evaluator module, 4.0, 04/27/2024 
# Atharva Date, Minor fix, 5.0, 04/28/2024

import subprocess
import sys
import os
from pyswip import Prolog

# Step 1: Read the input file
def read_input(filename):
    try:
        with open(filename, "r") as f:
            return f.read()
    except FileNotFoundError:
        print(f"File '{filename}' not found.")
        sys.exit(1)

# Step 2: Tokenize the input using lexer.py
def tokenize_input(input_data):
    process = subprocess.Popen(["python", "lexer.py", filename], stdout=subprocess.PIPE, text=True, cwd=os.getcwd())
    output, _ = process.communicate()
    token_list = output
    return token_list

# Step 3: Pass tokenized output to Prolog parsing.pl
def parse_with_prolog(token_list):
    prolog = Prolog()
    prolog.consult("parsing.pl")
    prolog_query = token_list
    solutions = prolog.query(prolog_query)
    for soln in solutions:
        return soln["P"]
    return None  

# Step 4: Execute evaluator.py with Prolog output and filename
def execute_evaluator(prolog_output, filename):
    process = subprocess.Popen(["python", "evaluator.py", filename], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True, cwd=os.getcwd())
    output, _ = process.communicate(input=prolog_output)
    return output

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python executor.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]

    # Step 1: Read input file
    input_data = read_input(filename)

    # Step 2: Tokenize input
    token_list = tokenize_input(input_data)

    # Step 3: Pass tokenized output to Prolog
    prolog_output = parse_with_prolog(token_list)

    # Step 4: Process Prolog output with evaluator.py
    evaluator_output = execute_evaluator(prolog_output, filename)

    print(evaluator_output)
