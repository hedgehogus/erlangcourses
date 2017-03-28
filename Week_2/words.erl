-module(words).
-export([split/1, return/1, read/0]).

split(Xs)->
    remove_short(split_words(lists:reverse(Xs),[])).

split_words([],A) -> [A];
split_words([X|Xs],A) ->
    case lists:member(X,[9,10,32,33,34,39,44,45,46,47,58,59,91,93]) of
    true -> [A|split_words(Xs,[])];
    false -> split_words(Xs,[nocap(X)|A])
    end.

return(Xs) ->
    Xs ++ [1].

remove_short([]) -> [];
remove_short([X|Xs]) ->
    case length(X) < 3 of 
    true -> remove_short(Xs);
    false -> [X| remove_short(Xs)]
    end.

nocap(X) ->
    case $A =< X andalso X =< $Z of
        true ->
            X + 32;
        false ->
            X
    end.

read() ->
    dictionary(add(split_file(index:get_file_contents("dickens-christmas.txt")))).

split_file([]) -> [];
split_file([[]|Xs]) -> split_file(Xs);
split_file([X|Xs]) ->
    [split(X)| split_file(Xs)].

add([]) -> [];
add([X|Xs]) ->
    X ++ add(Xs).

dictionary([]) -> [];
dictionary([X|Xs]) ->
    [X| dictionary(removeALL(X,Xs))].

removeALL (_,[]) -> [];
removeALL (X,[X|Xs]) ->
    removeALL(X, Xs);
removeALL (X, [Y|Xs]) ->
    [Y| removeALL(X, Xs)].