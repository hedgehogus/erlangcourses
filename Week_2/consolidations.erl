- module (consolidations).
- export([join/2, concat/1, member/2,  spl/1, merge/2]).


join(Xs,Ys) ->
    lists:reverse(shunt(Ys,shunt(Xs,[]))).

shunt([], Ys) -> Ys;
shunt([X|Xs], Ys) ->
    shunt(Xs, [X|Ys]).

concat([]) -> [];
concat([X|Xs]) ->
    join(X,concat(Xs)).

member(_, [])-> false;
member(X,[X|_]) -> true;
member(X, [_|Xs]) ->
    member(X, Xs).

spl([]) -> [];
spl([X]) -> [X];
spl(Xs) ->
    {A,B} = lists:split(length(Xs) div 2, Xs),
    merge(spl(A),spl(B)).

merge([],[]) -> [];
merge(Xs,[]) -> Xs;
merge([],Xs) -> Xs;
merge([X|Xs], [Y|Ys]) ->
    case X < Y of
        true -> [X| merge(Xs,[Y|Ys])];
        false -> [Y| merge([X|Xs],Ys)]
    end.

