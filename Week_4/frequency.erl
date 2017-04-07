%% Based on code from 
%%   Erlang Programming
%%   Francecso Cesarini and Simon Thompson
%%   O'Reilly, 2008
%%   http://oreilly.com/catalog/9780596518189/
%%   http://www.erlangprogramming.org/
%%   (c) Francesco Cesarini and Simon Thompson

-module(frequency).
-export([start/0,allocate/0,deallocate/1,stop/0, clear/0, test/0]).
-export([init/0]).

%% These are the start functions used to create and
%% initialize the server.

start() ->
    register(frequency,
	     spawn(frequency, init, [])).

init() ->
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
    {request, Pid, stop} ->
      Pid ! {reply, stopped}
  end.

%% Functional interface

test() -> 
    io:format ("message:~w~n", [allocate()]).    

%% Adding timeouts to the client code
allocate() -> 
    frequency ! {request, self(), allocate},   
    receive 
	    {reply, Reply} -> Reply
    after 500 -> clear()
    end.

deallocate(Freq) -> 
    frequency ! {request, self(), {deallocate, Freq}},
    receive 
	    {reply, Reply} -> Reply
    after 500 -> clear()
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
 case  lists:keymember(Pid,2,Allocated)  of
      true -> {[Freq|Free], {error, already_allocated}};
      false -> {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}
    end.

deallocate({Free, Allocated}, Freq) ->
  case lists:keymember(Freq, 1,Allocated) of
        true -> NewAllocated = lists:keydelete(Freq, 1, Allocated),
         {{[Freq|Free], NewAllocated}, ok};
        false -> {{[Free],Allocated}, not_currently_using}
    end.

% flushing the mailbox
clear() ->
  receive 
    Msg -> io:format ("clear message:~w~n", [Msg]),
    clear()
    after 0 -> ok
  end.
