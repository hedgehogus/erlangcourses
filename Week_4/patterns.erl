- module (patterns).
- export([testfor/0, call/1, pmap/1]).

for (Max, Max, F) -> [F(Max)];
for (I, Max, F) -> 
    [F(I)|for(I+1, Max,F)].

testfor() ->
    for(1,5,fun(I) -> I*I end).

% remote procedure call - something you can use on a local computer
% It will make a local function call look like a remote function call
% Pid conventionally stands for process identifier. The name of the process thats going to handlee the request
% Tag - the purpose of that is to pattern match on it and to associcate the correct response with the correct message
% rename: rpc - promise, wait_responce - yield

promise(Pid, Request) ->
    Tag = erlang:make_ref(),
    Pid ! {self(), Tag, Request},
    Tag.

yield(Tag) ->
    receive 
        {Tag, Response} ->        
            Response
        after 1000 -> timeout
    end.

% futures
call(Pid) ->
    Tag = promise(Pid, fun() -> request end),
    % do some computations
    _Val = yield(Tag).

% parallel do  - pmap
% par begin
%    F1,
%    F2,
%    F3,
% par end

pmap(L) ->
    S = self(),
    Pids = [do(S,F) || F <- L],
    [receive {Pid, Val} -> Val end || Pid <- Pids].

do (Parent, F) ->
    spawn (fun() -> Parent ! {self(), F()}
    end).