- module(game).
- export([beat/1, lose/1, tournament/2, play/0]).

% give the play which the argument beats
beat(rock) -> paper;
beat(paper) -> scissors;
beat(scissors) -> rock.

lose(rock) -> scissors;
lose(paper) -> rock;
lose(scissors) -> paper.

% result of one set of plays

result(rock,rock) -> draw;
result(rock,paper) -> lose;
result(rock,scissors) -> win;
result(paper,rock) -> win;
result(paper,paper) -> draw;
result(paper,scissors) -> lose;
result(scissors,rock) -> lose;
result(scissors,paper) -> win;
result(scissors,scissors) -> draw.

% result of tournament

tournament(PlaysL,PlaysR) ->
    lists:sum(
        lists:map(fun outcome/1,
            lists:zipwith(fun result/2, PlaysL,PlaysR))).

outcome(win) -> 1;
outcome(lose) -> -1;
outcome(draw) -> 0.

% transform 0,1,2 to rock,paper,scissors and vice versa

enum(0) -> rock;
enum(1) -> paper;
enum(2) -> scissors.

val(rock) -> 0;
val(paper) -> 1;
val(scissors) -> 2.

expand(s) -> scissors;
expand(r) -> rock;
expand(p) -> paper;
expand(stop) -> stop.

% interactively play against a strategy, provided as argument.
play() ->
    play(fun cycles/1).

play(Strategy) ->
    io:format("rock - paper - scissors~n"),
    io:format("Play one of rock, paper, scissors, ...~n"),
    io:format(" ... r, p, s, followed by '.'~n"),
    play(Strategy,[]).

% tail recursive loop for play/1

play(Strategy, Moves) ->
    {ok,P} = io:read("Play: "),
    Play = expand(P),
    case Play of
        stop ->
            io:format("stopped~n");
            _ ->
                Result = result(Play,Strategy(Moves)),
                io:format("result: ~p~n", [Result]),
                play(Strategy,[Play|Moves])
    end.

% strategies

echo([]) -> paper;
echo([Last|_]) -> Last.

rock(_) ->rock.

random(_) ->
    enum(rand:uniform(3)-1).

cycles(Xs) ->
    case length(Xs) rem 3 of
    0 -> rock;
    1 -> paper;
    2 -> scissors
    end.
