- module (lists_first).
- export([head/1, second/1, tail/1, suml/1, lengthl/1]).

head([X|_Xs]) ->
    X.

second([_X,Y|_Zs]) ->
    Y.

tail([_X|Xs]) ->
    Xs.

suml([]) ->
    0;
suml([X|Xs]) ->
    X + suml(Xs).

lengthl([]) ->
    0;
lengthl([_X| Xs]) ->
    1 + lengthl(Xs).