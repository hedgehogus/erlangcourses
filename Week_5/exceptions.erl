- module(exceptions).
- export([area/2, eval/2, test1/2, test2/2, test3/2]).

area (H, W) when H>0, W>0 -> H*W;
area (_H, _W) -> throw(negative_args).

eval(Env, {'div', Num, Denom}) ->
    N = eval (Env,Num),
    D = eval (Env, Denom),
    case D of
        0 -> throw(div_by_zero);
        _NZ -> N div D
    end.

test1(Env, Expr) ->
    try eval(Env, Expr) of
        Res -> {ok, Res}
    catch 
        throw:div_by_zero -> {error,div_by_zero}
    end.

test2(H, W) -> 
    try area(H, W) of
        Res -> {ok, Res}
    catch
        throw:negative_args -> {error, negative_args}
    end.

test3(H, W) -> 
    try area(H, W) of
        Res -> Res
    catch
        throw:negative_args -> 0
    end.