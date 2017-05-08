- module(calc).
- export([start/1, stop/0, eval/1]).
- export([init/1]).

% functional interface: start function. Env - state
start(Env) -> register(?MODULE, spawn(?MODULE, init, [Env])).

% functional interface: stopping function
stop() -> calc ! stop.

% functional interface: evaluate expression and receive reply
eval(Expr) -> 
    calc ! {request, self(), {eval, Expr}},
    receive
        {reply, Reply} -> Reply
    end.

% initialising (arg in spawn func). starts the loop
init(Env) -> 
    io:format("startting... ~n"),
    loop(Env).

% receiving messages
loop(Env) ->
    receive
        {request, From, {eval, Expr}} ->
            From ! {reply, expr:eval(Env, Expr)},
            loop(Env);
        stop -> io:format("terminating... ~n")
    end.