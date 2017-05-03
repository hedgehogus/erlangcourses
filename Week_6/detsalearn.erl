- module(detsalearn).
- export([createtable/0, insert/0, lookup/0, delete/0]).
- export([d_createtable/0, d_opentable/0, d_close/0, d_insert/0, d_lookup/1, d_delete/0]).

% ETS functions
createtable() -> 
    ets:new(table_name, [set, named_table]).

insert() ->
    ets:insert(table_name, {first, [1,10,11,12,13]}).

lookup() ->
    ets:lookup(table_name, first).

delete() -> 
    ets:delete(table_name, first).

% DETS functions
d_createtable() -> 
    dets:open_file('mydata.file',[]).

d_opentable() -> 
    {ok,Ref}=dets:open_file('mydata.file',[]),
    d_lookup(Ref).

d_close() ->
    dets:close('mydata.file').

d_insert() ->
    dets:insert('mydata.file', {first, [1,10,11,12,13]}).

d_lookup(Ref) ->
    dets:lookup(Ref, first).

d_delete() -> 
    dets:delete('mydata.file', first).

