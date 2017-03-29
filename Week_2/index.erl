-module(index).
-export([get_file_contents/1,show_file_contents/1]).
-export([index_text/1, lookup/2]).

% Used to read a file into a list of lines.
% Example files available in:
%   gettysburg-address.txt (short)
%   dickens-christmas.txt  (long)


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

% Show the contents of a list of strings.
% Can be used to check the results of calling get_file_contents.
show_file_contents([L|Ls]) ->
    io:format("~s~n",[L]),
    show_file_contents(Ls);
show_file_contents([]) ->
    ok.

% Adds a number to an ordered disjoint sequence of intervals. Assumes that the
% number to add is an upper bound to all intervals in the sequence.
add_line([], Line) -> [{Line, Line}];
add_line([{_, Line}]=I, Line) -> I;
add_line([{L, H}], Line) when Line == H + 1 -> [{L, Line}];
add_line([{L, H}], Line) when Line > H + 1 -> [{L, H} | add_line([], Line)];
add_line([I|R], L) -> [I | add_line(R, L)].

% Returns index Ix to which the single word K with line number N is added.
add_word([{K, Lines} | Ix], K, N) ->
    [{K, add_line(Lines, N)}|Ix];
add_word([], K, N) -> [{K, add_line([], N)}];
add_word([E|Ix], K, N) -> [E | add_word(Ix, K, N)].

% Strip of leading spaces.
trim([32|L]) -> trim(L);
trim(L) -> L.

split_word([], A) -> {lists:reverse(A), []};
split_word([32|L], A) -> {lists:reverse(A), trim(L)};
split_word([C|L], A) -> split_word(L, [C | A]).

% Returns a tuple consisting of the first word in the line and the remainder of
% the line.
split_word(L) -> split_word(L, []).

% Adds a single line to the index.
index_line(Ix, [], _) -> Ix;
index_line(Ix, L, N) ->
    {K, R} = split_word(L),
    index_line(add_word(Ix, K, N), R, N).

% Creates a word index for a list of lines.
%
% The index is a list consisting of pairs. Each pair consists of a word that
% occurs in the text and the lines on which the word occurs. The lines are
% represented as an ordered sequence of disjoint intervals. For example, the
% index
%
%     [{"foo", [{1,3}, {5,5}]}, {"bar", [{2,2}]}],
%
% is of a text in which 'foo' occurs on lines 1,2,3 and 5, and 'bar' occurs on
% line 2.
%
% Note that the intervals in the lines representation are maximal, for example,
%
%     [{1, 3}, {4, 4}]
%
% is illegal. It has legal representation,
%
%     [{1, 4}].
%
index_text(T) -> index_text([], T, 1).

index_text(Ix, [], _) -> Ix;
index_text(Ix, [L|T], N) ->
    index_text(index_line(Ix, L, N), T, N + 1).

% Looks up a word in the index.
% Not part of the exercise.
lookup([{K, Lines}|_], K) -> Lines;
lookup([_|Ix], K) -> lookup(Ix, K);
lookup([], _) -> [].
     

