- module (solving).
- export([take/2]).
- spec take(integer(), [T]) -> [T].

%% takes the first N elements from a list
take(0, _) -> [];
take(_, []) -> [];
take(N, [X|Xs]) ->
    [X| take(N-1,Xs)].

