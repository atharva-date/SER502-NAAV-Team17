% author; purpose; version; date
% Nisha Verma; Parser for print statement; 1.0; 04/20/2024
:- use_rendering(svgtree).

program(Parse) --> main_method(Parse).

main_method(main_block(Block)) --> ["main"], block(Block).
block(block(Statements)) -->  ["{"], statement_list(Statements), ["}"].
statement_list(sl(S,R)) --> statement(S),statement_list(R).
statement_list(sl(S))--> statement(S).
statement(st(P)) --> print_statement(P), [";"].

value(number(X)) --> [X], { number(X) }.
value(string(V)) --> string_value(V).
value(identifier(X)) --> id(identifier(X)).

value(boolean('T')) --> [T], { member(T, ['T']) }.
value(boolean('F')) --> [F], { member(F, ['F']) }.
numeric_value(I) --> integer(I).
numeric_value(F) --> float(F).

id(identifier(X)) --> [X],
    { member(X, [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]) }.

integer(int(I)) --> digit_sequence(I).
float(float(I,D)) --> digit_sequence(I), [“.”], digit_sequence(D).
digit_sequence((I,D)) --> digit(I), digit_sequence(D).
digit_sequence(D) --> digit(D).
digit(0) --> "0".
digit(1) --> "1".
digit(2) --> "2".
digit(3) --> "3".
digit(4) --> "4".
digit(5) --> "5".
digit(6) --> "6".
digit(7) --> "7".
digit(8) --> "8".
digit(9) --> "9".

string_value(V) --> [V], { string(V) }.

print_statement(print(V)) --> ["print"], ["("], value(V), [")"].

% program(P, ["main", "{", "print", "(", 5, ")", ";", "print", "(", 6, ")", ";","}"],[]).
% program(P, ["main", "{", "print", "(", 4.2, ")", ";", "print", "(", 6.0, ")", ";","}"],[]).
% program(P, ["main", "{", "print", "(", a, ")", ";", "print", "(", 6.0, ")", ";","}"],[]).
% program(P, ["main", "{", "print", "(", "Hello World!", ")", ";", "print", "(", b, ")", ";","}"],[]).