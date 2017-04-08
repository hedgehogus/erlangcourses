- module (calc).
- export([start/0, stop/0, execute/1]).
- export([init/0]).

start() -> spawn(calc, init, []).

init() ->
    io:format("Starting...~n"),
    register(calc, self()),
    loop().

loop() ->
    receive
        {request, From, Expr} ->
            From ! {reply, expr:eval(Expr)},
            loop();
        stop ->
            io:format("Terminating ...~n")
    end.

stop() ->
    calc ! stop.

execute(X) ->
    calc ! {request, self(), X},
    receive
        {reply, Reply} ->
            Reply
    end.