- module (shapes).
- export([total_area/1, circles/1, total_circle_area/1]).

% area of different shapes
area({circle, {_X,_Y}, R})
    -> math:pi()*R*R;
area({rectangle, {_X,_Y}, H, W}) 
    -> H*W.

% sum of elements in the list
sum([]) -> 0;
sum([X|Xs]) ->
    X + sum(Xs).

% counts total area of all shapes
total_area(Shapes) ->
    sum(all_areas(Shapes)).

% counts total area of circles
total_circle_area(Shapes) ->
    sum(all_areas(ccircles(Shapes))).

% returns list of each area
all_areas([]) -> [];
all_areas([X|Xs]) -> [area(X)| all_areas(Xs)].

% separetes circles from rectangles
circles([]) -> [];
circles([{circle,{_,_},_} = C |Xs] ) ->
    [ C | circles (Xs)];
circles([{rectangle,{_,_},_,_}|Xs]) -> circles(Xs).

% separetes circles from rectangles using case statement
ccircles([]) -> [];
ccircles([X|Xs]) ->
    case X of
        {circle, {_,_},_ } = C ->
        [C| ccircles(Xs)];
        _ -> ccircles(Xs)
    end.