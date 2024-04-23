%author; purpose; version; date
% Atharva Date; Parser for type declaration and condition; 1.0;
% 04/19/2024

:- use_rendering(svgtree).

program(Parse) --> block(Parse), [;] | block(Parse).

block(block([X])) --> [X].
block(block(declaration(Type, Id, AssignOp, Value))) -->
    type(Type), id(Id), assign_op(AssignOp), value(Value).
block(block(if_else_condition(Condition, If_Block, Else_Block))) -->
	[if], ["("], condition(Condition), [")"], block(If_Block),
    [else], block(Else_Block).
block(block(ternary_condition(Type, Id, AssignOp, Condition, Value1, Value2))) -->
    type(Type), id(Id), assign_op(AssignOp),
    ["("], condition(Condition), [")"],
    ["?"], value(Value1), [":"], value(Value2).

type(type(num)) --> [num].
type(type(bool)) --> [bool].
type(type(string)) --> [string].

id(identifier(X)) --> [X],
    { member(X, [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]) }.

value(number(X)) --> [X], { number(X) }.
value(identifier(X)) --> id(identifier(X)).
value(string(X)) --> [X], { string(X) }.
value(boolean('T')) --> [T], { member(T, ['T']) }.
value(boolean('F')) --> [F], { member(F, ['F']) }.

assign_op(assign('=')) --> [=].

comparison_operator(comparison_operator('>')) --> [>].
comparison_operator(comparison_operator('<')) --> [<].
comparison_operator(comparison_operator('>=')) --> [>=].
comparison_operator(comparison_operator('<=')) --> [<=].
comparison_operator(comparison_operator('==')) --> [==].
comparison_operator(comparison_operator('<>')) --> [<>].

condition(condition(Value1, CompOp, Value2)) -->
    value(Value1), comparison_operator(CompOp), value(Value2).

%program(P, [bool, y, =, 'T', ;], []).
%program(P, [string, y, =, "Strong candidates", ;], []).
%program(P, [num, y, =, 5, ;], []).

%For now, X is a code block
%program(P, [if, "(", 6, >, 5, ")", X, else, X], []).

%program(P, [num, y, =, "(", 6, >, 5, ")", "?", 7, ":", 0], []).
