-module(test).
-export([foo/2, baz/1]).

foo(_,[])              -> [];
foo(Y,[X|_]) when X==Y -> [X];
foo(Y,[X|Xs])          -> [X | foo(Y,Xs) ].

baz([])     -> [];
baz([X|Xs]) -> [X | baz(zab(X,Xs))].

zab(N,[])     -> [];
zab(N,[N|Xs]) -> zab(N,Xs);
zab(N,[X|Xs]) -> [X | zab(N,Xs)].
