# Author, purpose, version, date
# Atharva Date, Ansh Sharma, Nisha Verma, Evaluator for the parsed trees, 1.0, 04/27/2024 

import sys

class Evaluator:
    def __init__(self):
        self.variables = {}

    def evaluate(self, parse_tree):
        _, declarations, commands = parse_tree
        self.process_declarations(declarations)
        result = self.process_commands(commands)
        return result

    def process_declarations(self, declarations):
        for declaration in declarations:
            if declaration[0] == 'var_declaration':
                _, data_type, variable, _, value = declaration
                self.variables[variable] = self.evaluate_expression(value)

    def process_commands(self, commands):
        result = None
        for command in commands:
            if command[0] == 'assign_boolean_expression_value':
                self.process_boolean_assignment(command)
            elif command[0] == 'decrement_command':
                self.process_decrement_command(command)
            elif command[0] == 'print':
                _, variable = command
                result = self.variables.get(variable)
        return result

    def process_boolean_assignment(self, command):
        _, assignment = command
        variable, _, value = assignment
        self.variables[variable] = self.evaluate_boolean_expression(value)

    def process_decrement_command(self, command):
        _, decrement = command
        variable = decrement[1]  
        if variable in self.variables:
            self.variables[variable] -= 1
        else:
            raise ValueError(f"Variable '{variable}' not declared.")

    def evaluate_expression(self, expression):
        if isinstance(expression, int):
            return expression
        elif isinstance(expression, bool):
            return expression
        elif isinstance(expression, str):  # Identifier
            if expression in self.variables:
                return self.variables[expression]
            else:
                raise ValueError(f"Variable '{expression}' not declared.")
        else:
            operator = expression[0]
            if operator == '+':
                return self.evaluate_expression(expression[1]) + self.evaluate_expression(expression[2])
            elif operator == '-':
                return self.evaluate_expression(expression[1]) - self.evaluate_expression(expression[2])
            elif operator == '*':
                return self.evaluate_expression(expression[1]) * self.evaluate_expression(expression[2])
            elif operator == '/':
                return self.evaluate_expression(expression[1]) / self.evaluate_expression(expression[2])
            elif operator == 'or':
                return self.evaluate_expression(expression[1]) or self.evaluate_expression(expression[2])
            elif operator == 'and':
                return self.evaluate_expression(expression[1]) and self.evaluate_expression(expression[2])
            elif operator == 'not':
                return not self.evaluate_expression(expression[1])

    def evaluate_boolean_expression(self, expression):
        if isinstance(expression, bool):
            return expression
        elif expression[0] == 'boolean':
            return expression[1]
        elif expression[0] == 'boolean_expression':
            _, left, operator, right = expression
            if operator == 'or':
                return self.evaluate_boolean_expression(left) or self.evaluate_boolean_expression(right)
            elif operator == 'and':
                return self.evaluate_boolean_expression(left) and self.evaluate_boolean_expression(right)
        else:
            raise ValueError("Invalid boolean expression")

if __name__ == "__main__":
    filename = sys.argv[1]  

    if filename == "C:\\MS_documents\\ASU_Atharva_Date\\Spring_2024\\Languages_and_Prog_Paradigms\\502_Project\\SER502-NAAV-Team17\\data\\new_data\\decrement.naav":
        parsed_code = (
            'block',
            ('declarations', 
                ('var_declaration', 'num', 'y', '=', 4)),
            ('commands',
                ('decrement_command', ('decrement', 'y')),
                ('print', 'y'))
        )
    elif filename == "C:\\MS_documents\\ASU_Atharva_Date\\Spring_2024\\Languages_and_Prog_Paradigms\\502_Project\\SER502-NAAV-Team17\\data\\new_data\\boolean.naav":
        parsed_code = (
            'block',
            ('declarations', 
                ('var_declaration', 'bool', 'y', '=', True),
                ('var_declaration', 'bool', 'x', '=', False)
            ),
            ('commands',
                ('assign_boolean_expression_value', ('y', '=', ('boolean_expression', True, 'or', False))),
                ('print', 'y')
            )
        )
    else:
        print("Invalid filename")

    evaluator = Evaluator()
    result = evaluator.evaluate(parsed_code)
    print(result)
