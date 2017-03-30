- module(practice).
- export([doubleAll/1, evens/1, product/1]).

map (_, []) -> [];
map (F, [X|Xs]) ->
    [F(X)|map(F,Xs)].

double (X) -> X*2.

doubleAll(Xs) ->
    map(fun double/1,Xs).

filter(_,[]) -> [];
filter(F, [X|Xs]) ->
    case F(X) of 
        true -> [X|filter(F,Xs)];
        false -> filter(F,Xs)
    end.

even(X) when X rem 2 == 0 -> true;
even(_) -> false.

evens(X) ->
    filter(fun even/1, X).

reduce(_, S, []) -> S;
reduce(F, S, [X|Xs]) ->
    F(X, reduce(F,S,Xs)).

multiply(A,B) -> A*B.

product(X) ->
    reduce(fun multiply/2, 1, X).
