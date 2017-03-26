- module (solving).
- export([take/2, take1/2, split/2, nub/1, nubb/1]).


%% takes the first N elements from a list
take(0, _) -> [];
take(_, []) -> [];
take(N, [X|Xs]) when N>0->
    [X| take(N-1,Xs)].

take1(N,Xs) ->
    {Front, _Back} = take2(N, Xs, []),
    Front.

take2(0, _L, R) ->
    lists:reverse(R, []);
take2(N, [H|T], R) ->
    take2 (N-1, T, [H|R]);
take2(_, [], R) ->
    lists:reverse(R, []).

split(N, List) ->
    split(N, List, []).

split(0, L, R) ->
    {lists:reverse(R, []), L};
split(N, [H|T], R) ->
    split (N-1, T, [H|R]);
split(_, [], _) ->
    badarg.

%  removes all the duplicate elements from a list
nub([]) -> [];
nub ([X|Xs]) ->
    [X| nub(nub(Xs),X)].

nub([], _) -> [];
nub ([X|Xs],X) ->
    nub(Xs,X);
nub ([X|Xs],Y) ->
    [X | nub (Xs, Y)].

nubb([]) -> [];
nubb (A) ->
    [X|Xs] = lists:reverse(A, []),
    lists:reverse([X| nub(nub(Xs),X)]).