- module(assignment).
- export([test/0, deallocate/1, start/0, stop/1]).
- export([allocate/1, init_server/0, init_supervisor/0]).

% adding a supervisor
start()->
    register(supervisor,spawn(assignment,init_supervisor,[])).   
    
init_supervisor() ->
    process_flag(trap_exit,true),
    register(frequency1, Pid1 =
	    spawn_link(assignment, init_server, [])),
    register(frequency2, Pid2 =
        spawn_link(assignment, init_server, [])),
    
    supervisor_loop([Pid1,Pid2]).

supervisor_loop([null,null]) -> io:format("supervisor stopped");
supervisor_loop([Pid1,Pid2]) ->
    receive    
        {'EXIT', Pid1, normal} ->
            supervisor_loop([null,Pid2]);
        {'EXIT', Pid2, normal} ->
            supervisor_loop([Pid1,null]);
        {'EXIT', Pid1, _Reason} ->
            io:format("restart frequency1~n"),
            register(frequency1, A = spawn_link(assignment, init_server, [])),
            supervisor_loop([A,Pid2]);
        {'EXIT', Pid2, _Reason} ->
            io:format("restart frequency2~n"),
            register(frequency2, A = spawn_link(assignment, init_server, [])),
            supervisor_loop([Pid1,A]);
        crash -> exit(killed)
    end.

init_server() ->
    process_flag(trap_exit, true),
    Frequencies = {get_frequencies(), []},
    loop(Frequencies).

get_frequencies() -> [10,11,12,13,14,15].

loop(Frequencies) ->   
    SupervisorPid = whereis(supervisor),
    receive
    {request, Pid, allocate} ->
        {NewFrequencies, Reply} = allocate(Frequencies, Pid),
        Pid ! {reply, Reply},
        loop(NewFrequencies);
    {request, Pid , {deallocate, Freq}} ->
        NewFrequencies = deallocate(Frequencies, Freq),
        Pid ! {reply, ok},
        loop(NewFrequencies);
    % receives exit message
    {'EXIT', SupervisorPid, _Reason} ->
       stopped;      
    {'EXIT', Pid, _Reason} ->
        NewFrequencies = exited(Frequencies, Pid),
        loop(NewFrequencies);        
    crash -> exit(killed);
    {request, Pid, stop} ->
        Pid ! {reply, stopped}
  end.

%% Functional interface

test() -> 
    spawn(assignment,allocate, [frequency1]),
    spawn(assignment,allocate, [frequency2]).

allocate(Pid) -> 
    Pid ! {request, self(), allocate},  
    io:format ("client Pid:~w~n~w~n", [self(), Pid]), 
    receive 
	    {reply, Reply} -> Reply,
        loop1()    
    end.

deallocate(Freq) ->    
    frequency1 ! {request, self(), {deallocate, Freq}},
    receive 
	    {reply, Reply} -> Reply,
        loop1()
    end.

loop1() -> 
    timer:sleep(1000),
    loop1().

stop(Name) -> 
    Name ! {request, self(), stop},
    receive 
	    {reply, Reply} -> Reply
    end.

%% The Internal Help Functions used to allocate and
%% deallocate frequencies.

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
    link(Pid),
    {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->
    {value, {Freq, Pid}} = lists:keysearch(Freq,1, Allocated),
    unlink(Pid),
    NewAllocated = lists:keydelete(Freq, 1, Allocated),
    {{[Freq|Free], NewAllocated}, ok}.

% handling the exit in the server
exited ({Free, Allocated}, Pid) ->
    case lists:keysearch(Pid, 2, Allocated) of
        {value, {Freq, Pid}} ->
            NewAllocated = lists:keydelete(Freq,1,Allocated),
            {[Freq|Free], NewAllocated};
        false ->
            {Free, Allocated}
        end.

