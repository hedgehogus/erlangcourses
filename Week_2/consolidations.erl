- module (consolidations).
- export([join/2, concat/1, member/2,  merge_sort/1, quicksort/1, insertionsort/1, insert/2]).


join([],Ys) -> Ys;
join([X|Xs],Ys) ->
    [X|join(Xs,Ys)].

concat([]) -> [];
concat([X|Xs]) ->
    join(X,concat(Xs)).

%  tests whether its first argument is a member of its second argument, which is a list
member(_, [])-> false;
member(X,[X|_]) -> true;
member(X, [_|Xs]) ->
    member(X, Xs).

% Merge sort: divide the list into two halves of (approximately) equal length, sort them (recursively) and then merge the results.

merge_sort([]) -> [];
merge_sort([X]) -> [X];
merge_sort(Xs) ->
    {A,B} = lists:split(length(Xs) div 2, Xs),
    merge(merge_sort(A),merge_sort(B)).

merge([],[]) -> [];
merge(Xs,[]) -> Xs;
merge([],Xs) -> Xs;
merge([X|Xs], [Y|Ys]) ->
    case X < Y of
        true -> [X| merge(Xs,[Y|Ys])];
        false -> [Y| merge([X|Xs],Ys)]
    end.

quicksort([])-> [];
quicksort([X])-> [X];
quicksort([X|Xs]) -> 
    {A,B, M} = quick([X|Xs], X, [], [], []),
    quicksort(A)++ M ++ quicksort(B).


quick([],_, A, B, M) -> {A,B, M};
quick([X|Xs],X,A,B,M) ->quick(Xs,X, A, B, [X|M]);
quick([X|Xs],Y,A,B,M) ->
    case X > Y of 
    false -> quick(Xs,Y, [X|A], B, M);
    true -> quick(Xs,Y, A, [X|B], M)
    end.

insertionsort([X]) ->[X];
insertionsort([X|Xs]) -> 
    insert(insertionsort(Xs),X).
    
insert([],A)->[A];
insert([X|Xs], A) ->
    case A < X of
    true -> [A|[X|Xs]];
    false -> [X| insert(Xs, A)]
    end.


