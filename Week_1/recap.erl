- module(recap).
- export ([perimeter/1, area/1, enclosing/1]).

perimeter({circle, {_X,_Y}, R}) % shape circle, the centre, radius
    -> R*2*math:pi();
perimeter({rectangle, {_X,_Y}, H, W}) % shape rectangle, the centre, height, width
    -> (H+W)*2;
perimeter({triangle, {X,Y}, {Q,W}, {Z,E}}) % shape triangle, tops of triangle
    -> {A,B,C} = sides({X,Y}, {Q,W}, {Z,E}),
    A+B+C.

sides({X,Y}, {Q,W}, {Z,E}) % return sides of triangle 
    -> {hypo(abs(X-Q),abs(Y-W)), hypo(abs(Z-Q),abs(E-W)), hypo(abs(X-Z),abs(Y-E))}.

hypo(A,B) ->
X = first:square(A) + first:square(B),
math:sqrt(X).

area({circle, {_X,_Y}, R})
    -> math:pi()*R*R;
area({rectangle, {_X,_Y}, H, W}) 
    -> H*W;
area({triangle, {X,Y}, {Q,W}, {Z,E}})
    -> {A,B,C} = sides({X,Y}, {Q,W}, {Z,E}),
    S = (A+B+C)/2,
    math:sqrt(S*(S-A)*(S-B) *(S-C)). 

enclosing({circle, {X,Y}, R})
    ->{rectangle, {X,Y}, R*2,R*2}; 
enclosing({rectangle, {X,Y}, H, W})
    ->{rectangle, {X,Y}, H, W};
enclosing({triangle, {X,Y}, {Q,W}, {Z,E}})
    -> P = minThree(Y,W,E), % top of rectangle 
    O = maxThree(Y,W,E), % bottom of rectangle
    I = minThree(X,Q,Z), % left side of rectangle
    U = maxThree(X,Q,Z), % right side of rectangle
    WR = U-I,
    HR = O-P,
    XR = I + WR/2,
    YR = P + HR/2,
    {rectangle, {XR,YR}, HR, WR}.

maxThree(X,Y,Z) ->
    A = max(X,Y),
    max(A,Z).

minThree(X,Y,Z) ->
    A = min(X,Y),
    min(A,Z).