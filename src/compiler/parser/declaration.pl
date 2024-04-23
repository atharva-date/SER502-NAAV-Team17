% author; purpose; version; date
% Atharva Date; Parser for type declaration; 1.0; 04/19/2024
% Atharva Date; Allowing float values into num type; 2.0; 04/22/2024

:- use_rendering(svgtree).

program(Parse) --> declaration(Parse), [;].

declaration(declaration(Type, Id, AssignOp, Value)) -->
    type(Type), id(Id), assign_op(AssignOp), value(Value).

type(type(num)) --> [num].
type(type(bool)) --> [bool].
type(type(string)) --> [string].

id(identifier(X)) --> [X],
    { member(X, [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]) }.

value(number(X)) --> [X], { number(X) }.
value(number(X)) --> [X], { float(X) }. 
value(identifier(X)) --> id(identifier(X)).
value(string(X)) --> [X], { string(X) }.
value(boolean('T')) --> [T], { member(T, ['T']) }.
value(boolean('F')) --> [F], { member(F, ['F']) }.

assign_op(assign('=')) --> [=].


%program(P, [bool, y, =, 'T', ;], []).
%program(P, [string, y, =, "Strong candidates", ;], []).
%program(P, [num, y, =, 5, ;], []).
%program(P, [num, y, =, 5.5, ;], []).
