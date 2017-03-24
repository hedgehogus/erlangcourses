- module (constructing_lists).
- export([double/1, even/1]).

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
median (Xs) ->
    median(Xs, lists_first:lengthl(Xs)).

median ([X|Xs], L) when L rem 2 == 0 ->

    
