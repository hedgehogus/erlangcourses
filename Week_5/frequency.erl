-module(frequency).
-export([start/0,allocate/0, deallocate/1, stop/0, clear/0, test/0]).
-export([init/0]).

%% These are the start functions used to create and
%% initialize the server.

start() ->
    register(frequency,
	     spawn(frequency, init, [])).

init() ->
    %firewall
    process_flag(trap_exit, true),
    Frequencies = {get_frequencies(), []},
    loop(Frequencies).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%% The Main Loop
%% simulating the frequency server being overloaded
loop(Frequencies) ->
  timer:sleep(2000),
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
    {'EXIT', Pid, _Reason} ->
        NewFrequencies = exited(Frequencies, Pid),
        loop(NewFrequencies);
    {request, Pid, stop} ->
      Pid ! {reply, stopped}
  end.

%% Functional interface

test() -> 
    io:format ("message:~w~n", [allocate()]).    

%% Adding timeouts to the client code
allocate() -> 
    clear(),
    frequency ! {request, self(), allocate},  
    io:format ("message:~w~n", [self()]), 
    receive 
	    {reply, Reply} -> Reply
    after 500 -> {error, timeout}
    end.

deallocate(Freq) -> 
    clear(),
    frequency ! {request, self(), {deallocate, Freq}},
    receive 
	    {reply, Reply} -> Reply
    after 500 -> {error, timeout}
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
    % link to the Pid that has got that frequency
    link(Pid),
    {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->
    {value, {Freq, Pid}} = lists:keysearch(Freq,1, Allocated),
    % unlink to the Pid that holds it
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

% flushing the mailbox
clear() ->
  receive 
    Msg -> io:format ("clear message:~w~n", [Msg]),
    clear()
    after 0 -> ok
  end.