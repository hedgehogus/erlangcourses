- module (consolidations).
- export([join/2, concat/1, member/2,  merge_sort/1, quicksort/1, insertionsort/1, perms/1,  per/3, plusfirst/2, eachper/1]).


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

% split the list into two according to whether the items are smaller than (or equal to) or larger than the pivot,
% often taken to be the head element of the list; sort the two halves and join the results together.

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

% sort the tail of the list and then insert the head of the list in the correct place.

insertionsort([X]) ->[X];
insertionsort([X|Xs]) -> 
    insert(insertionsort(Xs),X).
    
insert([],A)->[A];
insert([X|Xs], A) ->
    case A < X of
    true -> [A|[X|Xs]];
    false -> [X| insert(Xs, A)]
    end.

% A permutation of a list xs consists of the same elements in a (potentially) different order. 
perms(Xs) -> lists:reverse(perm(Xs)).

perm([X]) -> [[X]];
perm([X|Xs]) ->
    eachper(plusfirst(X,perm(Xs))).    

eachper([]) -> [];     
eachper([X|Xs]) ->
    per(X,[],length(X)) ++ eachper(Xs).

per(_,A,0) -> A;
per([X|Xs],A,L) ->    
    per(Xs++[X], [[X|Xs]|A], L-1).

plusfirst(A,[]) -> [];
plusfirst(A,[X|Xs]) ->
    [[A] ++ X| plusfirst(A,Xs)].