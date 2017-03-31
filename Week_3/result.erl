- module(result).
- export([addOneToAll/1, addToAll/2,composed/1]).

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
fun2(X) -> X*2.

composed(X) ->
    map(compose(fun fun1/1, fun fun2/1),X).
