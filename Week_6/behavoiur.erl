% behaviour, not working, only example

- module(set).
- export([behavoiour_info/1]).
- export([insert/3,nil/1]).

behavoiour_info(callbacks) ->
    [{lt,2},{eq,2} ...]; ...

insert(Mod, X, [Y|Ys]) ->
    case Mod:lt(X,Y) of ...

nil (_Mod) -> [].

% another module, uses behavoiur

- module(nums).
- behaviour(set).
- export([lt/2, eq/2]).
- export([insert/2, nil/0]).

lt(A,B) -> A<B.
eq(A,B) -> A==B.

insert(A,As) -> set:insert(?MODULE, A, As).
nil()        -> set:nil(?MODULE).