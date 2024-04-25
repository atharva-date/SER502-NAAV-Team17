% author; purpose; version; date
% Nisha Verma; Parser for assignment; 1.0; 04/20/2024

:- use_rendering(svgtree).

program(Parse) --> main_method(Parse).
main_method(main_block(Block)) --> ["main"], block(Block).
block(block(Statements)) --> ["{"], statement_list(Statements), ["}"].
statement_list([Statement|Rest]) --> statement(Statement), statement_list(Rest).
statement_list([]) --> [].
statement(assignment(Identifier, Value)) --> identifier(Identifier), ["="], value(Value), [";"].
identifier(identifier(Id)) --> [Id], { atom_chars(Id, [X|Rest]), char_type(X, alpha), maplist(char_type, Rest, [alnum|_]) }.
value(boolean_value(true)) --> ["T"].
value(boolean_value(false)) --> ["F"].
value(numeric_value(Int)) --> integer(Int).
value(string_value(String)) --> string_value(String).
integer(Int) --> digit_sequence(Seq), { number_chars(Int, Seq) }.
digit_sequence([Digit|Rest]) --> digit(Digit), digit_sequence(Rest).
digit_sequence([Digit]) --> digit(Digit).
digit(D) --> [D], { char_type(D, digit) }.
string_value(String) --> "\"", string_characters(String), "\"".
string_characters([Char|Rest]) --> [Char], { dif(Char, "\"") }, string_characters(Rest).
string_characters([]) --> [].