% author; purpose; version; date
% Ansh Sharma; Parser - Boolean Operators and Boolean Expressions Added; 2.0; 04/25/2024

:- use_rendering(svgtree).

program(Parse) --> block(Parse).

block(block([X])) --> [X].
block(block(Decls, Comms)) -->
    [main], ["{"], declarations(Decls), [;], commands(Comms), ["}"].
block(block(Comms)) --> commands(Comms).

declarations(declarations(Decl, Decls)) -->
    declaration(Decl), [;], declarations(Decls).
declarations(declarations(Decl)) --> declaration(Decl).

commands(commands(Comm, Comms)) --> command(Comm), [;], commands(Comms).
commands(commands(Comm)) --> command(Comm).

declaration(var_declaration(Type, Id, AssignOp, Value)) -->
    type(Type), id(Id), assign_op(AssignOp), value(Value).

command(assign_value(Id, AssignOp, Value)) -->
    id(Id), assign_op(AssignOp), value(Value), [;].
command(assign_expression_value(Id, AssignOp, Expr)) -->
    id(Id), assign_op(AssignOp), expression(Expr), [;].
command(if_else_condition(Condition, If_Block, Else_Block)) -->
	[if], ["("], condition(Condition), [")"],
    ["{"], block(If_Block), ["}"],
    [else], ["{"], block(Else_Block), ["}"].
command(ternary_condition(Type, Id, AssignOp, Condition, Value1, Value2)) -->
    type(Type), id(Id), assign_op(AssignOp),
    ["("], condition(Condition), [")"],
    ["?"], value(Value1), [":"], value(Value2).
command(increment_command(IncrementExpr)) --> increment_expression(IncrementExpr), [;].
command(decrement_command(DecrementExpr)) --> decrement_expression(DecrementExpr), [;].
command(for_loop(Decl, Condition, IncrementExpr, For_Block)) -->
    [for], ["("], declaration(Decl), [';'], condition(Condition), [';'], increment_expression(IncrementExpr), [")"],
    ["{"], block(For_Block), ["}"].
command(for_loop(Decl, Condition, DecrementExpr, For_Block)) -->
    [for], ["("], declaration(Decl), [';'], condition(Condition), [';'], decrement_expression(DecrementExpr), [")"],
    ["{"], block(For_Block), ["}"].
command(range_loop(Type, Id, Value1, Value2, Range_Block)) -->
    [for], type(Type), id(Id), [in], [range], ["("], value(Value1), [':'], value(Value2), [")"],
    ["{"], block(Range_Block), ["}"].
command(while_loop(Condition, While_Block)) -->
    [while], ["("], condition(Condition), [")"],
    ["{"], block(While_Block), ["}"].
command(assign_boolean_value(Id, AssignOp, Value)) -->
    id(Id), assign_op(AssignOp), value(Value), [;].
command(assign_boolean_expression_value(Id, AssignOp, Expr)) -->
    id(Id), assign_op(AssignOp), boolean_expression(Expr), [;].

expression(expression(Expr)) --> arithmetic_expression(Expr).
arithmetic_expression(arithmetic_expr(Term)) --> term(Term).
arithmetic_expression(arithmetic_expr(Term1, Op, Expr)) -->
    term(Term1),
    { precedence(Op, Precedence), Precedence > 0 },
    arithmetic_operator(Op),
    arithmetic_expression_higher_precedence(Expr, Precedence).
arithmetic_expression_higher_precedence(Expr, MinPrecedence) -->
    term(Term2),
    (   { precedence(Op, Precedence), Precedence > MinPrecedence }
    ->  arithmetic_operator(Op),
        arithmetic_expression_higher_precedence(Expr1, Precedence),
        { Expr = arithmetic_expr(Term2, Op, Expr1) }
    ;   { Expr = Term2 }
    ).
term(term(Factor)) --> factor(Factor).
term(term(Factor, Op, Term)) -->
    factor(Factor), arithmetic_operator(Op), term(Term).
factor(factor(Expr)) --> value(Expr).
factor(factor(Expr)) --> ["("], arithmetic_expression(Expr), [")"].

arithmetic_operator(arithmetic_operator('/')) --> ['/'].
arithmetic_operator(arithmetic_operator('*')) --> ['*'].
arithmetic_operator(arithmetic_operator('+')) --> ['+'].
arithmetic_operator(arithmetic_operator('-')) --> ['-'].

% Define operator precedence
precedence('/', 2).
precedence('*', 2).
precedence('+', 1).
precedence('-', 1).

type(type(num)) --> [num].
type(type(bool)) --> [bool].
type(type(string)) --> [string].

value(number(X)) --> [X], { number(X) }.
value(identifier(X)) --> id(identifier(X)).
value(string(X)) --> [X], { string(X) }.
value(boolean('T')) --> ['T'], { member('T', ['T']) }.
value(boolean('F')) --> ['F'], { member('F', ['F']) }.

id(identifier(X)) --> [X],
    { member(X, [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]) }.

assign_op(assign('=')) --> [=].

comparison_operator(comparison_operator('>')) --> [>].
comparison_operator(comparison_operator('<')) --> [<].
comparison_operator(comparison_operator('>=')) --> [>=].
comparison_operator(comparison_operator('<=')) --> [<=].
comparison_operator(comparison_operator('==')) --> [==].
comparison_operator(comparison_operator('<>')) --> [<>].

% Define boolean operators
boolean_operator('and') --> [and].
boolean_operator('or') --> [or].
boolean_operator('not') --> [not].

condition(condition(Value1, CompOp, Value2)) -->
    value(Value1), comparison_operator(CompOp), value(Value2).
condition(condition(BoolExpr)) --> boolean_expression(BoolExpr).

boolean_expression(boolean_expression(Value)) --> value(Value).
boolean_expression(boolean_expression(Value1, BoolOp, Value2)) -->
    value(Value1), boolean_operator(BoolOp), value(Value2).

increment_expression(increment(Id)) --> id(Id), [++].
decrement_expression(decrement(Id)) --> id(Id), [--].

%While_Loop
%program(P, [main, "{", num, y, =, 6, ;, while, "(", y, >, 5, ")", "{", y, =, 7, +, 4, -, 3 , ;, "}", "}"], []).

%Increment_Decrement
%program(P, [main, "{", num, y, =, 3, ;, y, ++, ;, "}"], []).
%program(P, [main, "{", num, y, =, 3, ;, y, --, ;, "}"], []).

%For_Loops
%program(P, [main, "{", num, y, =, 6, ;, for, "(", num, x, =, 7, ;, x, >, 5, ;, x, ++, ")", "{", y, =, 7, +, 4, -, 3 , ;, "}", "}"], []).
%program(P, [main, "{", num, y, =, 6, ;, for, "(", num, x, =, 7, ;, x, >, 5, ;, x, --, ")", "{", y, =, 7, +, 4, -, 3 , ;, "}", "}"], []).

%Range_Loop
%program(P, [main, "{", num, y, =, 6, ;, for, num, x, in, range, "(", 0, :, 3, ")", "{", y, =, 7, +, 4, -, 3 , ;, "}", "}"], []).

%Boolean Expression
%program(P, [main, "{", bool, y, =, 'T', ;, y, =, 'T', or, 'F', ;, "}"], []).