:- use_rendering(svgtree).

program(Parse) --> main_method(Parse).

main_method(main_block(Block)) --> ["main"], block(Block).
block(block(Statements)) -->  ["{"], statement_list(Statements), ["}"].
statement_list(sl(S,R)) --> statement(S),statement_list(R).
statement_list(sl(S))--> statement(S).
statement(st(P)) --> print_statement(P), [";"].

value(bool(B)) --> boolean_value(B).
value(num(N)) --> numeric_value(N).
value(string(V)) --> string_value(V).
value(iden(I)) --> identifier(I).

boolean_value --> ["T"] | ["F"].
numeric_value --> integer(I).
numeric_value --> float(F).

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