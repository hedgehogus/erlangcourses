- module (lists_tail).
- export([suml/1, lengthl/1, sumeven/1, sumodd/1, getelement/2]).

% sums all elements in list
suml([], S) -> S;
suml([X|Xs], S) ->
    suml(Xs, X+S).

suml(Xs) -> suml(Xs, 0).

% counts number of elements in list
lengthl([], N) -> N;
lengthl([_X| Xs],N) ->
    lengthl(Xs, N+1).

lengthl(Xs) -> lengthl(Xs, 0).

% sums all even elements in list 
sumeven([],N) -> N;
sumeven([_X],N) -> N;
sumeven([_X,Y|Xs],N) ->
    sumeven(Xs, N+Y).

sumeven(Xs)->sumeven(Xs,0).

% sums all odd elements in list
sumodd([],N) -> N;
sumodd([X],N) -> N+X;
sumodd([X,_Y|Xs],N) ->
    sumodd(Xs, N+X).

sumodd(Xs) -> sumodd(Xs, 0).

% returns element from N position, OR no_such_element if the number of elements < N
getelement([],_N) ->no_such_element;
getelement([X|_Xs], 0) -> X;
getelement([_X|Xs],N)->
    getelement(Xs, N-1).
