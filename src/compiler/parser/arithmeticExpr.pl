% author; purpose; version; date
% Atharva Date; Parser for block, declarations, commands and
% arithmetic expressions; 1.0; 04/20/2024


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


expression(expression(Expr)) --> arithmetic_expression(Expr).
arithmetic_expression(arithmetic_expr(Term)) --> term(Term).
arithmetic_expression(arithmetic_expr(Term, Op, Expr)) -->
    term(Term), arithmetic_operator(Op), arithmetic_expression(Expr).
term(term(Factor)) --> factor(Factor).
term(term(Factor, Op, Term)) -->
    factor(Factor), arithmetic_operator(Op), term(Term).
factor(factor(Expr)) --> value(Expr).
factor(factor(Expr)) --> ["("], arithmetic_expression(Expr), [")"].

arithmetic_operator(arithmetic_operator('+')) --> ['+'].
arithmetic_operator(arithmetic_operator('-')) --> ['-'].
arithmetic_operator(arithmetic_operator('*')) --> ['*'].
arithmetic_operator(arithmetic_operator('/')) --> ['/'].

type(type(num)) --> [num].
type(type(bool)) --> [bool].
type(type(string)) --> [string].

value(number(X)) --> [X], { number(X) }.
value(identifier(X)) --> id(identifier(X)).
value(string(X)) --> [X], { string(X) }.
value(boolean('T')) --> [T], { member(T, ['T']) }.
value(boolean('F')) --> [F], { member(F, ['F']) }.

id(identifier(X)) --> [X],
    { member(X, [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]) }.

assign_op(assign('=')) --> [=].

comparison_operator(comparison_operator('>')) --> [>].
comparison_operator(comparison_operator('<')) --> [<].
comparison_operator(comparison_operator('>=')) --> [>=].
comparison_operator(comparison_operator('<=')) --> [<=].
comparison_operator(comparison_operator('==')) --> [==].
comparison_operator(comparison_operator('<>')) --> [<>].

condition(condition(Value1, CompOp, Value2)) -->
    value(Value1), comparison_operator(CompOp), value(Value2).

%program(P, [main, "{", num, y, =, 6, ;, if, "(", 6, >, 5, ")", "{", y, =, 7, +, 4, -, 3 , ;, "}", else, "{", y, =, 8, /, 2, ;, "}", "}"], []).
%program(P, [main, "{", num, y, =, 6, ;, y, =, 8, /, 2, -, 6, +, 0, ;, "}"], []).
