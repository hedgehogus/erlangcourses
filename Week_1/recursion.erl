- module(recursion).
- export([fac/1, fibo/1, piec/1, piecsq/1]).

fac(0) ->
1;
fac (N) when N>0 ->
fac (N-1)*N.

fibo(0) ->
0;
fibo(1) ->
1;
fibo (N)  when N>0->
fibo (N-1)+fibo(N-2).

piec(1) ->
2;
piec(N) when N>1->
piec(N-1)+N.

piecsq(1) ->
2;
piecsq(N) when N>1->
piecsq(N-1)*2.
