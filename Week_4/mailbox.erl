- module (mailbox).
- export ([test/0, receiver/0, receiver2/0, receiver3/0]).

% treats different cases of incoming message at the top level of the receive statement.
receiver() ->
    timer:sleep(800),
    receive
        stop -> io:format ("stopped~n");
        X -> io:format ("message:~w~n", [X]),
        receiver()
    end.

% matches incoming messages with a variable, and then pattern match each message using a case expression;
receiver2() ->
    timer:sleep(800),
    receive    
    X -> case X == stop of
        true -> io:format ("stopped~n");
        false -> io:format ("message:~w~n", [X]),
        receiver2()
        end   
    end.

% deals with messages in order, irrespective of the order in which they arrive in the mailbox. 
receiver3() ->    
    receive 
    {ok, Pid1, Pid2, first} -> 
        io:format ("message:~w~n", [{ok, Pid1, Pid2, first}]),
        receive
        {ok, Pid1, Pid2, second} -> io:format ("message:~w~n", [{ok, Pid1, Pid2, second}]);
        X -> io:format ("message:~w~n", [X])
        end
    end.
    
test() ->
    Pid = spawn(mailbox,receiver3,[]),
    Pid ! {ok, Pid, self(), second},
    timer:sleep(800),
    Pid ! {ok, Pid, self(), first},    
    Pid ! stop.