- module (lists_practice).
- export([productd/1, productt/1, maximumd/1, maximumt/1]).

% the product of a list of numbers, direct recursion
productd([]) -> 1;
productd([X|Xs]) ->
    X*productd(Xs).

% the product of a list of numbers, tail recursion
productt([],N) -> N;
productt([X|Xs],N) ->
    productt(Xs, N*X).

productt(Xs) ->
    productt(Xs, 1).

%% the maximum of a list, direct recursion
maximumd([]) -> no_elements;
maximumd([X]) -> X;
maximumd([X|Xs]) ->
    max(X,maximumd(Xs)).

%% the maximum of a list, tail recursion
maximumt([],N) -> N;
maximumt([X|Xs],N) ->
    maximumt(Xs, max(N,X)).

maximumt([]) -> no_elements;
maximumt(Xs) -> 
    [X|Xs] = Xs,
    maximumt(Xs,X).


