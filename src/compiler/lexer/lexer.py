# author; purpose; version; date
# Ansh Sharma; Lexer syntax corrected; 2.0; 04/26/2024

import sys
import ply.lex as lex

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
    'TERNARY_OP',
    'COLON',
    'COMMA',
)

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
t_TERNARY_OP = r'\?'
t_COLON = r':'
t_COMMA = r','

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

t_ignore = " \t"

def t_comment(t):
    r'\#.*'
    pass

def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

def t_BOOLEAN(t):
    r'T|F'
    t.value = f'{t.value}'
    return t

def t_NUMERIC(t):
    r'\d+(\.\d+)?'
    t.value = t.value
    return t

def t_STRING(t):
    r'"([^\\"]|\\.)+"'
    t.value = f"{t.value}"
    return t

def t_ID(t):
    r'[a-zA-Z_][a-zA-Z0-9_]*'
    t.value = f"{t.value}"
    return t

def t_FOR(t):
    r'for\s+(\w+)\s+in\s+range\s*\(\s*(\d+)\s*,\s*(\d+)\s*\)'
    t.type = 'FOR'
    return t

lexer = lex.lex()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python lexer.py <filename>")
        sys.exit(1)

    filename = sys.argv[1]

    try:
        with open(filename, "r") as f:
            data = f.read()

        lexer.input(data)

        token_list = []
        while True:
            tok = lexer.token()
            if not tok:
                break
            token_list.append(str(tok.value) if isinstance(tok.value, str) else tok.value)

        print(token_list)

    except FileNotFoundError:
        print(f"File '{filename}' not found.")
        sys.exit(1)
