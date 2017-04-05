- module (area).
- export ([area/1, area/0, return/0, return2/0]).

area({square, X}) ->
    X*X;
area({rectangle,X,Y}) ->
    X*Y.

area() ->
    timer:sleep(300),    
    receive
    {From,{square,X}} -> From ! {self(), X*X};
    {From,{rectangle,X,Y}} ->From ! {self(),X*Y}
    end,
    area().


return() ->
    Pid = spawn(area, area, []),       
    return(Pid,10).
    
return(_,0) -> stop;
return(Pid,N) ->
    Pid ! {self(), {square,N}}, 
    receive 
        {Pid,Reply} ->                      
             io:format("~p~n",[Reply])
    after 200 ->
        io:format("~s~n",["no reply"])
    end,
    return(Pid,N-1).

return2() -> 
    Pid = spawn(area, area, []),
    Pid ! {self(), {square,2}}, 
    Pid ! {self(), {square,10}}, 
    receive 
        {Pid,4} ->                      
             io:format("~p~n",[4]);
        {Pid,100} ->                      
             io:format("~p~n",[100])
        after 1000 ->
        io:format("~s~n",["no reply"])
    end,    
    ok.