-module(frequency).
-export([init/1,start/0,start/1,allocate/0,deallocate/1,stop/0]).
-export([current_state/0]).

% Timeout to process messages
-define(ProcessTimeout, 300).

%% These are the start functions used to create and
%% initialize the server.

start() ->
  register_and_spawn(0).

% Add delay to simulate server load
start(ServerDelay) ->
  register_and_spawn(ServerDelay).

register_and_spawn(ServerDelay) ->
  register(frequency,
           spawn(frequency, init, [ServerDelay])).

init(ServerDelay) ->
  Frequencies = {get_frequencies(), []},
  loop(Frequencies, ServerDelay).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%% The Main Loop

loop(Frequencies, ServerDelay) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      delay(ServerDelay),
      Pid ! {reply, Reply},
      loop(NewFrequencies, ServerDelay);
    {request, Pid , {deallocate, Freq}} ->
      {NewFrequencies, Reply} = deallocate(Frequencies, Freq),
      delay(ServerDelay),
      Pid ! {reply, Reply},
      loop(NewFrequencies, ServerDelay);
    {request, Pid, stop} ->
      delay(ServerDelay),
      Pid ! {reply, stopped};
    {request, Pid, state} ->
      Pid ! {reply, Frequencies},
      loop(Frequencies, ServerDelay)
  end.

%% Functional interface

allocate() -> 
  clear(),
  frequency ! {request, self(), allocate},
  receive 
    {reply, Reply} -> Reply
  after
    ?ProcessTimeout -> {error, timeout}
  end.

deallocate(Freq) -> 
  clear(),
  frequency ! {request, self(), {deallocate, Freq}},
  receive 
    {reply, Reply} -> Reply
  after
    ?ProcessTimeout -> {error, timeout}
  end.

stop() -> 
  clear(),
  frequency ! {request, self(), stop},
  receive 
    {reply, Reply} -> Reply
  after
    ?ProcessTimeout -> {error, timeout}
  end.

current_state() ->
  clear(),
  frequency ! {request, self(), state},
  receive
    {reply, Reply} -> Reply
  after
    ?ProcessTimeout -> {error, timeout}
  end.

%% The Internal Help Functions used to allocate and
%% deallocate frequencies.

% Allocate frequencies
allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
  {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

% Deallocate frequencies
deallocate({Free, Allocated}, Freq) ->
  case lists:keymember(Freq, 1, Allocated) of
    true ->
      NewAllocated=lists:keydelete(Freq, 1, Allocated),
      {{[Freq|Free], NewAllocated}, ok};
    _Else ->
      {{Free, Allocated}, {error, no_frequency}}
  end.

clear() ->
  receive
    Msg ->
      io:format("Clearing Msg ~w~n", [Msg]),
      clear()
  after
    0 -> ok
  end.

% Simulate server delay
delay(ServerDelay) -> timer:sleep(ServerDelay).