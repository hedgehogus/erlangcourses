- module (lists_first).
- export([head/1, second/1, tail/1, suml/1, lengthl/1, sumeven/1, sumodd/1, getelement/2]).

% returns first element of list(head) 
head([X|_Xs]) -> X.

% returns second element of list
second([_X,Y|_Zs]) -> Y.

% returns tail of list
tail([_X|Xs]) -> Xs.

% sums all elements in list
suml([]) -> 0;
suml([X|Xs]) ->
    X + suml(Xs).

% sums all even elements in list 
sumeven([]) -> 0;
sumeven([_X]) -> 0;
sumeven([_X,Y|Xs]) ->
    Y + sumeven(Xs).

% sums all odd elements in list
sumodd([]) -> 0;
sumodd([X]) -> X;
sumodd([X,_Y|Xs]) ->
    X + sumodd(Xs).

% returns element from N position, OR no_such_element if the number of elements < N
getelement([],_N) ->no_such_element;
getelement([X|_Xs], 0) -> X;
getelement([_X|Xs],N)->
    getelement(Xs, N-1).

% counts number of elements in list
lengthl([]) -> 0;
lengthl([_X| Xs]) ->
    1 + lengthl(Xs).