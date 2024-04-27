import subprocess
import sys
import os

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
    process = subprocess.Popen(["python", "lexer.py", filename], stdout=subprocess.PIPE, text=True, cwd=os.path.join(os.getcwd(), "lexer"))
    output, _ = process.communicate()
    token_list = output
    return token_list

# Step 3: Pass tokenized output to Prolog parsing.pl
def parse_with_prolog(token_list):
    print(token_list)
    prolog_query = "program(P," + token_list + ",[])."
    print(prolog_query)
    process = subprocess.Popen(["swipl", "-q", "-f", "parsing.pl", "-g", prolog_query, "-t", "halt"], stdout=subprocess.PIPE, text=True, cwd=os.path.join(os.getcwd(), "parser"))
    print(process)
    output, _ = process.communicate()
    return output.strip()

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

    # Step 4: Process Prolog output
    print("Prolog Output:")
    print(prolog_output)
