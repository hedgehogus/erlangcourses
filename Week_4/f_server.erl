- module(f_server).
- export([start/0, init/0, allocate/0, deallocate/1]).

allocate({[],Allocated}, _Pid) ->
    {{[], Allocated},{error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
    case  lists:keymember(Pid,2,Allocated)  of
      true -> {[Freq|Free], {error, already_allocated}};
      false -> {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}
    end.

deallocate ({Free, Allocated}, Freq) ->
    case lists:keymember(Freq, 1,Allocated) of
        true -> NewAllocated = lists:keydelete(Freq, 1, Allocated),
         {{[Freq|Free], NewAllocated}, ok};
        false -> {{[Free],Allocated}, not_currently_using}
    end.

loop (Frequencies) ->
    receive
    {request, Pid, allocate} -> 
        {NewFrequancies,Reply} = allocate (Frequencies, Pid),
        Pid ! {reply,Reply},
        loop(NewFrequancies);
    {request, Pid, {deallocate, Freq}} ->
        {NewFrequancies, Reply} = deallocate(Frequencies, Freq),
        Pid ! {reply, Reply},
        loop (NewFrequancies);
    {request, Pid, stopped} ->
        Pid ! {reply, stopped}
    end.

init() ->
    Frequencies = {get_frequencies(), []},
    loop(Frequencies).

% hard coded
get_frequencies() -> [10,11,12,13,14,15].

start()->
    Server = spawn(f_server, init, []),
    register(f_server, Server).


allocate() -> 
    f_server ! {request, self(), allocate},
    receive
        {reply, Reply} -> Reply
    end.

deallocate(Freq) ->
    f_server ! {request, self(), {deallocate,Freq}},
    receive
        {reply, Reply} -> Reply
    end.

stop() ->
    f_server ! {request,self(), stopped}.