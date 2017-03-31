- module(result).
- export([addOneToAll/1, addToAll/2,composed/1, sum/1, test/1]).

add(X) -> fun(Y) -> X+Y end.

addOneToAll(Xs) ->
    map(add(1),Xs).

addToAll(N,Xs) ->
    map(add(N), Xs).

map(_,[]) -> [];
map(F,[X|Xs]) -> [F(X)|map(F,Xs)].

compose(F,G) ->
    fun(X) -> G(F(X)) end.

fun1(X) -> X+1.
fun2(X) -> X+2.
fun3(X) -> X+3.

composed(X) ->
    A = compose(fun fun1/1, fun fun2/1),
    A(X).

sum(Xs) ->
    Add = fun(X,Y) -> X+Y end,
    lists:foldr(Add,0, Xs).

% function that takes a list of functions and composes them together
composeList([]) -> empty_list;
composeList([X]) -> X;
composeList([X|Xs]) ->
    A = composeList(Xs),
    fun (Y) -> X(A(Y)) end.

twice(F) ->
    fun(X) ->F(F(X)) end.

test(X) ->
    A = composeList([fun fun1/1, fun fun2/1, fun fun3/1]),
    A(X).