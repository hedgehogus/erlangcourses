- module(f_server).
- export([start/0, init/0]).

allocate({[],Allocated}, _Pid) ->
    {{[], Allocated},{error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
    {{Free, [{Freq,Pid}|Allocated]}, {ok, Freq}}.

deallocate ({Free, Allocated}, Freq) ->
    NewAllocated = lists:keydelete(Freq, 1, Allocated),
    {[Freq|Free], NewAllocated}.

loop (Frequencies) ->
    receive
    {request, Pid, allocate} -> 
        {NewFrequancies,Reply} = allocate (Frequencies, Pid),
        Pid ! {reply,Reply},
        loop(NewFrequancies);
    {request, Pid, {deallocate, Freq}} ->
        NewFrequancies = deallocate(Frequencies, Freq),
        Pid ! {reply, ok},
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
    register(serv, Server).