- module(tail_recursion).
- export([fac/1, loop/1, fib/1]).

fac(N) -> fac(N,1).

fac(0,P) -> P;
fac (N,P) when N>0 -> 
fac (N-1,P*N).

loop(N) when N>0 ->
io:format("~p~n", [N]),
loop(N-1);
loop(N) -> 
io:format("bye~n").

fib(N) -> fib(N-2,0,1).

fib(0,P,S) ->
P+S;
fib (N,P,S) when N>0 ->
fib (N-1, P+S, P).
