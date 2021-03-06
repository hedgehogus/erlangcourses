- module(game).
- export([beat/1, lose/1, tournament/2, play/0, frequency/1, leastfreaquent/1]).

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
    play(random_strategy()).

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

leastfreaquent(Xs) ->
    {R,P,S} = frequency(Xs),
    case R<P andalso R<S of
    true -> rock;
    false ->
        case P<S of
        true -> paper;
        false -> scissors
        end
    end.

mostfreaquent(Xs) ->
    {R,P,S} = frequency(Xs),
    case R>P andalso R>S of
    true -> rock;
    false ->
        case P>S of
        true -> paper;
        false -> scissors
        end
    end.

random_strategy() ->
    All = [fun rock/1, fun echo/1, fun random/1, fun cycles/1, fun leastfreaquent/1, fun mostfreaquent/1],
    N = rand:uniform(length(All)),
    random_strategy(All,N).

random_strategy([Y|_], 1) -> Y;
random_strategy([_|Ys],N) ->
    random_strategy(Ys, N-1).

% supporting functions


frequency(Xs) -> frequency(Xs,{0,0,0}).

frequency([],A) -> A;
frequency([X|Xs],{R,P,S}) ->
    case X of 
    rock -> frequency(Xs,{R+1,P,S});
    paper -> frequency(Xs,{R,P+1,S});
    scissors -> frequency(Xs,{R,P,S+1})
    end.
    

