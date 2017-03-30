- module(practice).
- export([doubleAll/1, evens/1, product/1, zip/2, zip_with/3,zip2/2]).

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

% 1) Define a function zip/2 that “zips together” pairs of elements from two lists
zip(_,[]) ->[];
zip([],_) ->[]; 
zip([X|Xs],[Y|Ys]) ->
    [{X,Y}| zip(Xs,Ys)].

% 2) Define a function zip_with/3 that “zips together” pairs of elements from two lists using the function in the first argument, like this:

zip_with(_,[],_) -> [];
zip_with(_,_,[]) -> [];
zip_with(F,[X|Xs],[Y|Ys])->
    [F(X,Y)|zip_with(F,Xs,Ys)].

% c) Re-define the function zip_with/3 using zip and lists:map.
zip1({F,A,B}) -> F(A,B).

zip_with1(F, Xs, Ys) ->
    A = zip(Xs, Ys),    
    B = lists:map(fun({X,Y}) -> {F,X,Y} end, A),
    lists:map(fun zip1/1, B).

% d) Re-define zip/2 using zip_with/3.
zip2(X, Y) ->
    zip_with1(fun(A,B) -> {A, B} end, X, Y).

