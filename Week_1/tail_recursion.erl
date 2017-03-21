- module(tail_recursion).
- export([fac/1, loop/1, fib/1, perf/1, perfect/3]).

fac(N) -> fac(N,1).

fac(0,P) -> P;
fac (N,P) when N>0 -> 
fac (N-1,P*N).

loop(N) when N>0 ->
io:format("~p~n", [N]),
loop(N-1);
loop(_N) -> 
io:format("bye~n").

fib(N) -> fib(N,0,1).

fib(0,P,_S) -> P;
fib (N,P,S) when N>0 ->
    fib (N-1, S, P+S).

perf(N) -> perf(N,0,N).

perf(0,S,A) ->
S == A;
perf(N,S,A) when (A rem (N-1)) == 0 ->
    perf (N-1, S+(N-1), A);
perf(N,S,A) ->
    perf (N-1, S, A).

perfect(N,N,S) -> N==S;
perfect(N,M,S) when N rem M == 0 ->
    perfect(N,M+1,S+M);
perfect(N,M,S) ->
    perfect(N, M+1,S).

perfect(N)-> perfect(N,1,0).
