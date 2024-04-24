# author; purpose; version; date
# Ansh Sharma; Lexer for the Tokenization of the code; 1.0; 04/17/2024

import sys
import ply.lex as lex

# List of token names. This is always required.
tokens = (
    'BOOLEAN',
    'NUMERIC',
    'STRING',
    'ID',
    'ARITHMETIC_OP',
    'BOOL_OP',
    'COMPARISON_OP',
    'ASSIGNMENT_OP',
    'INCREMENT_OP',
    'DECREMENT_OP',
    'IF',
    'ELSE',
    'FOR',
    'WHILE',
    'PRINT',
    'MAIN',
    'L_BRACE',
    'R_BRACE',
    'L_PAREN',
    'R_PAREN',
    'SEMICOLON',
)

# Regular expression rules for simple tokens
t_ARITHMETIC_OP = r'[+\-*/]'
t_BOOL_OP = r'and|or|not'
t_COMPARISON_OP = r'[<>]=?|==|!='
t_ASSIGNMENT_OP = r'='
t_INCREMENT_OP = r'\+\+'
t_DECREMENT_OP = r'--'
t_L_BRACE = r'{'
t_R_BRACE = r'}'
t_L_PAREN = r'\('
t_R_PAREN = r'\)'
t_SEMICOLON = r';'

# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# A string containing ignored characters (spaces, tabs, and comments)
t_ignore = " \t"

# Define a rule to ignore comments starting with #
def t_comment(t):
    r'\#.*'
    pass

# Define a rule to handle errors
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Define a rule for boolean literals
def t_BOOLEAN(t):
    r'T|F'
    t.value = f"{t.value}"
    return t

# Define a rule for numeric literals
def t_NUMERIC(t):
    r'\d+(\.\d+)?'
    t.value = t.value
    return t

# Define a rule for string literals
def t_STRING(t):
    r'"([^\\"]|\\.)*"'
    t.value = f"{t.value}"
    return t

# Define a rule for identifiers
def t_ID(t):
    r'[a-zA-Z_][a-zA-Z0-9_]*'
    t.value = f"{t.value}"
    return t

# Build the lexer
lexer = lex.lex()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python lexer.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]

    try:
        # Read the contents of the file
        with open(filename, "r") as f:
            data = f.read()

        # Give the lexer the file content as input
        lexer.input(data)

        # Tokenize
        token_list = []
        while True:
            tok = lexer.token()
            if not tok:
                break
            token_list.append(str(tok.value) if isinstance(tok.value, str) else tok.value)

        # Print tokens in one line
        print(token_list)

    except FileNotFoundError:
        print(f"File '{filename}' not found.")
        sys.exit(1)
