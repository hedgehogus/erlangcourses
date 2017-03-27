- module (solving).
- export([take/2, take1/2, split/2, nub/1, nubb/1, nub1/1, nub2/1, palindrome/1]).


%% takes the first N elements from a list
take(0, _) -> [];
take(_, []) -> [];
take(N, [X|Xs]) when N>0->
    [X| take(N-1,Xs)].

take1(N,Xs) ->
     take2(N, Xs, []).

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
    lists:reverse(nub(nub(Xs),X, [X])).

nub([], _, A) -> A;
nub([X|Xs],X, A) ->
    nub(Xs,X, A);
nub ([X|Xs],Y, A) ->
    nub (Xs, Y , [X|A]).

nubb([]) -> [];
nubb (A) ->
    [X|Xs] = lists:reverse(A, []),
    nub(nub(Xs),X, [X]).

nub1([]) -> [];
nub1([X|Xs]) ->
    [X| nub(removeALL(X,Xs))].

% removes all occurenses of X in Xs
removeALL (_,[]) -> [];
removeALL (X,[X|Xs]) ->
    removeALL(X, Xs);
removeALL (X, [Y|Xs]) ->
    [Y| removeALL(X, Xs)].

nub2([]) -> [];
nub2([X|Xs]) ->
    case member(X,Xs) of
        true -> nub2(Xs);
        false -> [X|nub2(Xs)]
    end.

% defines if X has duplicates in Xs
member(_, []) -> false;
member(X,[X|_]) -> true;
member(X, [_|Xs]) ->
    member(X,Xs).

% returns true or false depending on whether the list is a palindrome

palindrome(Xs) ->
    F = remove_spase(string:to_lower(Xs)),
    N = lengthl(F) div 2,
    {A,B} = split(N, F),
    equals(A, lists:reverse(B)).

equals([], []) -> true;
equals([],[X]) -> true;
equals ([X|Xs], [X|Ys]) ->
    equals(Xs, Ys);
equals ([X|_], [Y|_]) -> false.

remove_spase([]) -> [];
remove_spase([32|Xs]) ->
    remove_spase(Xs);
remove_spase([39|Xs]) ->
    remove_spase(Xs);
remove_spase([X|Xs])->
    [X |remove_spase(Xs)].

% counts number of elements in list
lengthl([]) -> 0;
lengthl([_X| Xs]) ->
    1 + lengthl(Xs).
