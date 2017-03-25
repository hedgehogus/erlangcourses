- module (solving).
- export([take/2, take1/2, split/2]).


%% takes the first N elements from a list
take(0, _) -> [];
take(_, []) -> [];
take(N, [X|Xs]) when N>0->
    [X| take(N-1,Xs)].

take1(N,Xs) ->
    {Front, _Back} = split(N,Xs),
    Front.

take2(0, L, R) ->
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