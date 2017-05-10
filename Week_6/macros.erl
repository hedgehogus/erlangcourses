% defs.hrl

- define(ONE, 1).
- define(TWICE(F), (fun(P) -> F(F(P))end)).
- define(FMT(S,As), io:format(S, As)).
- define(SHOW(X), ?FMT ("~p=~p~n",[??X,X])).


- module(macros).
- include("defs.hrl").

succ(X) -> X+?ONE.

add_two(X) -> ?TWICE(succ)(X).

show() -> ?SHOW(add_two(7)).
