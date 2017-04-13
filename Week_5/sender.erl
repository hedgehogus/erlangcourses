- module(sender).
- export([allocate/0, start/0]).

start() ->
 spawn(sender,allocate, []).

allocate() ->     
    frequency ! {request, self(), allocate},  
    io:format ("message:~w~n", [self()]),  
    receive 
	    {reply, Reply} -> Reply,
        io:format ("message:~w~n", [Reply]) ,
        loop()
    after 500 -> {error, timeout}
    end.

loop() -> 
    timer:sleep(6000),
    io:format ("message:~w~n", [{terminate}]),
    exit(crash),
    loop().
