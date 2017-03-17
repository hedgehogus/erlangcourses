-module(simple).
-export([howManyEqual/2,exOr/2, sss/1]).

howManyEqual(X,X) ->
    2;
howManyEqual(_X,_Y) ->
    0.


exOr(false,X) ->
    X;
exOr(true,X) ->
    not(X).

sss(X) ->
[$w,$e,$l,$l].