- module (esp).
- export([start_link/0, count/0, echo/1, reset/1, stop/0]).

start_link() ->
    register(?MODULE, spawn_link(?MODULE, init,[])).

count() -> 
    ?MODULE ! {count, self()},
    receive 
        Reply -> Reply
    end.

echo(X) ->
    ?MODULE ! {X, self()},
    receive
        Reply -> Reply
    end.

reset(N) ->
    ?MODULE ! {{reset, N}, self()},
    ok.

stop() ->
    ?MODULE ! {stop, self()},
    ok.