-module(words).
-export([indexfile/1]).

%  what has not been done:
% 1. the results of occuring in lines are not group into tuples. there are only the list of lines, where some word occurs. Like this
% { "foo" , [3,4,5,7,11,12,13] }
% 2. Not sorting the output so that the words occur in lexicographic order.
% 3. Normalising so that common endings, plurals etc. identified.


% the main function, that starts indexing of file.
indexfile(Xs)->
    indexall(getdictionary(Xs), read(Xs)).

% divides line into words and removs short words
split(Xs)->
    remove_short(split_words(lists:reverse(Xs),[])).

% divides line into words
split_words([],A) -> [A];
split_words([X|Xs],A) ->
    case lists:member(X,[9,10,32,33,34,39,44,41,45,46,47,58,59,63,62,64,91,93,96]) of
    true -> [A|split_words(Xs,[])];
    false -> split_words(Xs,[nocap(X)|A])
    end.

% Removing all short words (e.g. words of length less than 3) or all common words (you‘ll have to think about how to define these).
remove_short([]) -> [];
remove_short([X|Xs]) ->
    case length(X) < 3 of 
    true -> remove_short(Xs);
    false -> [X| remove_short(Xs)]
    end.

% Normalising the words so that capitalised ("Foo") and non capitalised versions ("foo") of a word are identified.
nocap(X) ->
    case $A =< X andalso X =< $Z of
        true ->
            X + 32;
        false ->
            X
    end.

% function for reading file
read(Xs) ->
    split_file(get_file_contents(Xs)).

% divides all lines in file into words
split_file([]) -> [];
split_file([[]|Xs]) -> split_file(Xs);
split_file([X|Xs]) ->
    [split(X)| split_file(Xs)].

% forms a full list of words in text
getdictionary(Xs) ->
    dictionary(add(read(Xs))).

dictionary([]) -> [];
dictionary([X|Xs]) ->
    [X| dictionary(removeALL(X,Xs))].

% removes words that repeat
removeALL (_,[]) -> [];
removeALL (X,[X|Xs]) ->
    removeALL(X, Xs);
removeALL (X, [Y|Xs]) ->
    [Y| removeALL(X, Xs)].

add([]) -> [];
add([X|Xs]) ->
    X ++ add(Xs).

% indexing occurences of some word in file
indexword(_,[],_) -> [];
indexword(Xs,[Y|Ys],N)->
    case lists:member(Xs,Y) of
        true -> [N|indexword(Xs, Ys, N+1)];
        false -> indexword(Xs, Ys, N+1)
    end.

% indexing occurences of all words in file
indexall([],_)->[];
indexall([X|Xs],Ys) ->
    [{X,indexword(X, Ys, 1)}|indexall(Xs,Ys)].


% Get the contents of a text file into a list of lines.
% Each line has its trailing newline removed.

get_file_contents(Name) ->
    {ok,File} = file:open(Name,[read]),
    Rev = get_all_lines(File,[]),
lists:reverse(Rev).

% Auxiliary function for get_file_contents.
% Not exported.

get_all_lines(File,Partial) ->
    case io:get_line(File,"") of
        eof -> file:close(File),
               Partial;
        Line -> {Strip,_} = lists:split(length(Line)-1,Line),
                get_all_lines(File,[Strip|Partial])
    end.



