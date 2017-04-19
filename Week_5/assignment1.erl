-module(assignment1).
-export([start/1,allocate/0,deallocate/1,stop/0,
         spawn_client/2, spawn_supervisor/0]).
-export([init/1,
         client/2, supervisor/0]).

%% These are the start functions used to create and
%% initialize the server.

start(Supervisor_pid) ->                                        %% ADDED PARAMETER
    register(frequency,
	     spawn(assignment1, init, [Supervisor_pid])).

init(Supervisor_pid) ->                                         %% ADDED PARAMETER
  process_flag(trap_exit, true),
  Frequencies = {get_frequencies(), []},
  loop(Frequencies, Supervisor_pid).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%% The Main Loop

loop(Frequencies, Supervisor_pid) ->                            %% ADDED PARAMETER
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      Pid ! {reply, Reply},
      loop(NewFrequencies, Supervisor_pid);
    {request, Pid , {deallocate, Freq}} ->
      NewFrequencies = deallocate(Frequencies, Freq),
      Pid ! {reply, ok},
      loop(NewFrequencies, Supervisor_pid);
    {request, Pid, stop} ->
      Pid ! {reply, stopped};
    {'EXIT', Supervisor_pid, _Reason} ->                        %% ADDED CLAUSE
      exit(supervisor_terminated);
    {'EXIT', Pid, _Reason} ->
      NewFrequencies = exited(Frequencies, Pid), 
      loop(NewFrequencies, Supervisor_pid);
    simulate_abnormal_termination ->                            %% ADDED CLAUSE
      exit(abnormal_termination)
  end.

%% Functional interface

allocate() -> 
    frequency ! {request, self(), allocate},
    receive 
	    {reply, Reply} -> Reply
    end.

deallocate(Freq) -> 
    frequency ! {request, self(), {deallocate, Freq}},
    receive 
	    {reply, Reply} -> Reply
    end.

stop() -> 
    frequency ! {request, self(), stop},
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
  {value,{Freq,Pid}} = lists:keysearch(Freq,1,Allocated),
  unlink(Pid),
  NewAllocated=lists:keydelete(Freq, 1, Allocated),
  {[Freq|Free],  NewAllocated}.

exited({Free, Allocated}, Pid) ->
    case lists:keysearch(Pid,2,Allocated) of
      {value,{Freq,Pid}} ->
        NewAllocated = lists:keydelete(Freq,1,Allocated),
        {[Freq|Free],NewAllocated}; 
      false ->
        {Free,Allocated} 
    end.


%% ADDED ALL FUNCTIONS BELOW

client(Allocate_time, Deallocate_time) ->
    {ok, Freq} = allocate(),
    receive
        simulate_abnormal_termination ->
            exit(abnormal_termination)
        after Allocate_time ->
            ok
    end,
    ok = deallocate(Freq),
    timer:sleep(Deallocate_time),
    client(Allocate_time, Deallocate_time).

spawn_client(Allocate_time, Deallocate_time) ->
    spawn(?MODULE, client, [Allocate_time, Deallocate_time]).


supervisor() ->
    start(self()),
    Frequency_pid = whereis(frequency),
    link(Frequency_pid),
    process_flag(trap_exit, true),
    receive
        {'EXIT', Frequency_pid, _Reason} ->
            supervisor();
        simulate_abnormal_termination ->
            exit(abnormal_termination)
    end.

spawn_supervisor() ->
    spawn(?MODULE, supervisor, []).