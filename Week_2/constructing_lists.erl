- module (constructing_lists).
- export([double/1, even/1, median/1, sort/1]).

% function to double the elements of a list of numbers
double([]) -> [];
double([X|Xs]) ->
    [X*2|double(Xs)].

% function that extracts the even numbers from a list of integers.
even([]) -> [];
even([X|Xs]) when X rem 2 == 0  ->
    [X| even (Xs)];
even([_|Xs]) -> even(Xs).

% the median of a list of numbers
median ([]) ->[];
median ([X]) -> [X];
median (Xs) ->
    median(sort(Xs), lists_first:lengthl(Xs) div 2, lists_first:lengthl(Xs) rem 2 ).

median ([X,Y|_], 1, D) ->
    case D of 
        0 -> [X,Y];
        _ -> [Y]
    end;    
median ([_X|Xs], L, D)  ->
    median(Xs, L-1, D).

% function to sort a list
sort (Xs) -> 
    S = sortloop (Xs),
    case Xs of
        S -> S;
        _ -> sort(S) end.  

sortloop ([X]) -> [X];
sortloop ([X,Y|Xs]) when X > Y ->
    [Y| sortloop([X|Xs])];
sortloop ([X,Y|Xs]) ->
    [X| sortloop([Y|Xs])].



    
