# author; purpose; version; date
# Ansh Sharma; Lexer syntax corrected; 2.0; 04/26/2024
# Atharva Date; Improve lexer for True and False values; 3.0; 04/26/2024
# Vidya Rupak; Updated to include quotes around string values, brackets and boolean values; 4.0 ; 04/26/2024

import sys
import ply.lex as lex

# List of token names
tokens = (
    'BOOL', 'NUM', 'STRING', 'IDENTIFIER', 'BOOLEAN_VALUE', 'NUMERIC_VALUE',
    'STRING_VALUE', 'ARITHMETIC_OPERATOR', 'BOOLEAN_OPERATOR', 'COMPARISON_OPERATOR',
    'INCREMENT_OPERATOR', 'DECREMENT_OPERATOR', 'FOR', 'WHILE', 'IN', 'RANGE', 'IF',
    'ELSE', 'TRUE', 'FALSE', 'PRINT', 'MAIN', 'SEMICOLON', 'LEFT_PAREN', 'RIGHT_PAREN',
    'LEFT_BRACE', 'RIGHT_BRACE', 'EQUALS', 'COLON', 'QUESTION_MARK', 'COMMA'
)

# Regular expression rules for simple tokens
t_SEMICOLON = r';'
t_LEFT_PAREN = r'\('
t_RIGHT_PAREN = r'\)'
t_LEFT_BRACE = r'\{'
t_RIGHT_BRACE = r'\}'
t_EQUALS = r'='
t_COLON = r':'
t_QUESTION_MARK = r'\?'
t_COMMA = r','
t_INCREMENT_OPERATOR = r'\+\+'
t_DECREMENT_OPERATOR = r'\-\-'

# Define a rule for arithmetic operators
def t_ARITHMETIC_OPERATOR(t):
    r'[+\-\*/](?!\+|-)'
    return t

# Define a rule for boolean operators
def t_BOOLEAN_OPERATOR(t):
    r'and|or|not'
    return t

# Define a rule for comparison operators
def t_COMPARISON_OPERATOR(t):
    r'<|>|<=|>=|==|!='
    return t

# Define a rule for keywords and identifiers
def t_IDENTIFIER(t):
    r'[A-Za-z][A-Za-z0-9_]*'
    keywords = {
        'main': 'MAIN',
        'bool': 'BOOL',
        'num': 'NUM',
        'string': 'STRING',
        'if': 'IF',
        'else': 'ELSE',
        'for': 'FOR',
        'while': 'WHILE',
        'in': 'IN',
        'range': 'RANGE',
        'print': 'PRINT',
        'T': 'TRUE',
        'F': 'FALSE'
    }
    t.type = keywords.get(t.value, 'IDENTIFIER')
    return t

# Define a rule for numeric values
def t_NUMERIC_VALUE(t):
    r'\d+(\.\d+)?'
    t.value = float(t.value) if '.' in t.value else int(t.value)
    return t

# Define a rule for boolean values
def t_BOOLEAN_VALUE(t):
    r"'[TF]'"
    t.type = 'BOOLEAN_VALUE'
    return t

# Define a rule for string values
def t_STRING_VALUE(t):
    r'(\'[^\']*\'|\"[^\"]*\")'
    t.value = t.value[1:-1]  # Remove outer quotes
    return t

# Define a rule to track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# Define a rule to ignore whitespace and tabs
t_ignore = ' \t'

# Define a rule to skip comments
def t_COMMENT(t):
    r'\#.*'
    pass

# Error handling rule
def t_error(t):
    print(f"Illegal character '{t.value[0]}'")
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()

# Read input code from file specified as command-line argument
if len(sys.argv) < 2:
    print("Usage: python3 lexer.py <filename>")
    sys.exit(1)

filename = sys.argv[1]

try:
    with open(filename, 'r') as file:
        input_code = file.read()

        # Tokenize input code
        lexer.input(input_code)
        
        # List to store tokens
        tokens_list = []

        # Iterate over tokens and append to the list
        for token in lexer:
            token_value = str(token.value)
            # Surround with double quotes if not an identifier, keyword, or number
            if token.type in ['LEFT_PAREN', 'RIGHT_PAREN', 'LEFT_BRACE', 'RIGHT_BRACE', 'STRING_VALUE', 'COMMA', 'QUESTION_MARK', 'COLON']:
                tokens_list.append('"' + token_value + '"')
            else:
                tokens_list.append(token_value)

        # Print tokens without single quotes
        tokens_string = "program(P, [" + ", ".join(tokens_list) + "], [])."
        print(tokens_string)
        # if "'T'" in tokens_list:
        #     print("T exists in the list")

except FileNotFoundError:
    print(f"Error: File '{filename}' not found.")
    sys.exit(1)
