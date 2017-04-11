- module(first).
- export([start/0, start2/0]).
- export([loop/0, loop2/0, loop3/0, loop4/0]).

start() ->
    register(first,spawn(?MODULE, loop4, [])).

% spawn and link process
start2() ->
    register(first,spawn_link(?MODULE, loop, [])).

% never terminates
loop() -> 
    receive
        {msg, exit} -> exit(fir),
            io:format("ack~n"),
            loop();
        {msg, M} ->
            io:format("ack~n"),
            loop();
        _Msg ->
            loop()
    end.

% terminates if message does not acknowleged
loop2() -> 
    receive
        {msg, M} ->
            io:format("ack~n"),
            loop2();
        _Msg ->
            ok
    end.

% terminates in both cases. Terminates normally
loop3() -> 
    receive
        {msg, M} ->
            io:format("ack~n");     
        _Msg ->
            ok
    end.

% processes can fail. Terminates abnormally
loop4() -> 
    receive
        {msg, M} ->
            N = M+1,
            io:format("~b~n", [N]),
            loop4();     
        _Msg ->
            loop4()
    end.
