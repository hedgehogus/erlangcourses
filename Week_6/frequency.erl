-module(frequency).
-export([start/0,allocate/0, deallocate/1, stop/0, test/0]).
-export([init/1, init_router/0]).

%% These are the start functions used to create and
%% initialize the server.

start() ->   
    register(frequency1,
	    spawn(frequency, init, [fun get_frequencies1/0])),
    register(frequency2,
	    spawn(frequency, init, [fun get_frequencies2/0])),
    register(router,
        spawn(frequency, init_router, [])).   

init_router() ->
    loop_router().

loop_router() ->
    A1 = get_free(frequency1),
    A2 = get_free(frequency2),
    receive
        {request, Pid, allocate} ->        
            case A1>=A2 of 
                true -> frequency1 ! {request, Pid, allocate};               
                false -> frequency2 ! {request, Pid, allocate}
            end,
            loop_router();
        {request, Pid , {deallocate, Freq}} ->
            case lists:member(Freq, get_frequencies1()) of
                true -> frequency1 ! {request, Pid , {deallocate, Freq}};
                false -> 
                    case lists:member(Freq, get_frequencies2()) of 
                    true -> frequency2 ! {request, Pid , {deallocate, Freq}};
                    false -> Pid ! {reply,no_frequency}
                    end
            end,
            loop_router()
    end.

get_free(S) ->
    S ! {request, self(), get_free},
    receive
      {reply, L} -> L
    end.



init(F) ->
    %firewall
    process_flag(trap_exit, true),
    Frequencies = {F(), []},
    loop(Frequencies).

% Hard Coded
get_frequencies1() -> [10,11,12,13,14,15].
get_frequencies2() -> [20,21,22,23,24,25].

%% The Main Loop

loop(Frequencies) ->   
    Router_Pid = whereis(router), 
    receive
    {request, Pid, allocate} ->
        {NewFrequencies, Reply} = allocate(Frequencies, Pid),
        Pid ! {reply, Reply},
        loop(NewFrequencies);
    {request, Pid , {deallocate, Freq}} ->
        {NewFrequencies, Reply} = deallocate(Frequencies, Freq),
        io:format("dealoc ~w~n", [{NewFrequencies}]),
        Pid ! {reply, Reply},
        loop(NewFrequencies);   
    {'EXIT', Pid, _Reason} ->
        NewFrequencies = exited(Frequencies, Pid),
        loop(NewFrequencies);
    {request, Pid, stop} ->
        Pid ! {reply, stopped};
    {request, Router_Pid, get_free} ->
        {Free, _} = Frequencies,
        Router_Pid ! {reply, length(Free)},
        loop(Frequencies)
  end.


%% Functional interface

test() -> 
    io:format ("message:~w~n", [allocate()]).    

allocate() ->     
    router ! {request, self(), allocate},  
    io:format ("message:~w~n", [self()]), 
    receive 
	    {reply, Reply} -> Reply    
    end.

deallocate(Freq) ->     
    router ! {request, self(), {deallocate, Freq}},
    receive 
	    {reply, Reply} -> Reply  
    end.

stop() -> 
    router ! {request, self(), stop},
    receive 
	    {reply, Reply} -> Reply
    end.



allocate({[], Allocated}, _Pid) ->
    {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->   
    {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->     
    case lists:keysearch(Freq,1,Allocated) of
    false -> {{Free, Allocated}, not_ok};
    _ ->  NewAllocated = lists:keydelete(Freq, 1, Allocated),
         {{[Freq|Free], NewAllocated}, ok}
    end.

% handling the exit in the server
exited ({Free, Allocated}, Pid) ->
    case lists:keysearch(Pid, 2, Allocated) of
        {value, {Freq, Pid}} ->
            NewAllocated = lists:keydelete(Freq,1,Allocated),
            {[Freq|Free], NewAllocated};
        false ->
            {Free, Allocated}
        end.

