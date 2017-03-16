- module(second).
- export([hypo/2, per/2, area/2, foo/0, is_zero/1, xOr/2, howManyEqual/3, maxThree/3]).

hypo(A,B) ->
X = first:square(A) + first:square(B),
math:sqrt(X).

per(A,B) ->
A+B+hypo(A,B).

area(A,B) ->
(A*B)/2.

foo() ->
fir.

is_zero(0) ->
truefir;
is_zero(10) ->
onezero;
is_zero(_) ->
falsefir.


xOr(X,Y) ->
X =/=Y.

maxThree(X,Y,Z) ->
A = max(X,Y),
max(A,Z).

howManyEqual(X,X,X) ->
3;
howManyEqual(X,X,_) ->
2;
howManyEqual(X,_,X) ->
2;
howManyEqual(_,X,X) ->
2;
howManyEqual(_,_,_) ->
0.