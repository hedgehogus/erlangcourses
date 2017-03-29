-module(first).
-export([test/0] ).

map(F,[]) -> [];
map(F,[X|Xs]) -> [F(X)|map(F,Xs)].

filter(_,[]) -> [];
filter (P, [X|Xs]) ->
    case P(X) of 
    true -> [X|filter(P,Xs)];
    false -> filter (P, Xs)
    end.

reduce(C, Start, []) -> Start;
reduce(C, Start, [X|Xs]) ->
    C(X, reduce(C, Start, Xs)).

area({circle, {_X,_Y}, R})
    -> math:pi()*R*R;
area({rectangle, {_X,_Y}, H, W}) 
    -> H*W.

is_circle ({circle, {_,_},_})-> true;
is_circle (_) -> false.

plus(X,Y) -> X+Y.

%test() -> 
 %   A = [{circle, {1,1}, 2},{circle, {0,0}, 1},{rectangle, {1,1}, 1, 2},{rectangle, {0,0}, 3, 4}],
  %  reduce(fun plus/2,0,(map(fun area/1, filter(fun is_circle/1,A)))).

test() -> 
    A = [{circle, {1,1}, 2},{circle, {0,0}, 1},{rectangle, {1,1}, 1, 2},{rectangle, {0,0}, 3, 4}],
    reduce(fun (X,Y) -> X + Y end,0,(map(fun area/1, filter(fun is_circle/1,A)))).



%   \\\|///
%  =|* . *|=
% =| ^   ^ |=
%  =| ^ ^ |=
%   //|||\\

