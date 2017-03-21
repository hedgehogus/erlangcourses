- module(tail_recursion).
- export([fac/1, loop/1, fib/1, perf/1]).

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

perf(N) -> perf(N,0,N).

perf(0,S,A) ->
S == A;
perf(N,S,A) when (N>0) ->
perf (N-1, S+divide(A,N-1), A).

divide(X,Y) when (X - ((X div Y)*Y) == 0) -> Y;
divide(X,Y) -> 0. 


