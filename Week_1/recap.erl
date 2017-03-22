- module(recap).
- export ([perimeter/1, area/1, enclosing/1]).

perimeter({circle, {_X,_Y}, R}) % shape circle, the centre, radius
    -> R*2*math:pi();
perimeter({rectangle, {_X,_Y}, H, W}) % shape rectangle, the centre, height, width
    -> (H+W)*2;
perimeter({triangle, {_X,_Y}, A, B, C}) % shape triangle, centroid, sides of the triangle
    -> A+B+C.

area({circle, {_X,_Y}, R})
    -> math:pi()*R*R;
area({rectangle, {_X,_Y}, H, W})
    -> H*W;
area({triangle, {_X,_Y}, A, B, C})
    -> S = (A+B+C)/2,
    math:sqrt(S*(S-A)*(S-B) *(S-C)). 

enclosing({circle, {_X,_Y}, R})
    ->{R*2,R*2}; % height and width of smallest enclosing rectangle
enclosing({rectangle, {_X,_Y}, H, W})
    ->{H,W};
enclosing({triangle, {X,Y}, A, B, C})
    -> Z = maxThree(A,B,C),
    {Z,area({triangle,{X,Y},A,B,C})*2/Z}.

maxThree(X,Y,Z) ->
    A = max(X,Y),
    max(A,Z).