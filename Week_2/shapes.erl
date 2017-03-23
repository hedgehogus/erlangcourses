- module (shapes).
- export([total_area/1]).

area({circle, {_X,_Y}, R})
    -> math:pi()*R*R;
area({rectangle, {_X,_Y}, H, W}) 
    -> H*W.

sum([]) -> 0;
sum([X|Xs]) ->
    X + sum(Xs).

total_area(Shapes) ->
    sum(all_areas(Shapes)).

all_areas([]) -> [];
all_areas([X|Xs]) -> [area(X)| all_areas(Xs)].
