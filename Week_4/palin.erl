-module(palin).
-export([palindrome/1]).

% palindrome problem
%
% palindrome("Madam I\'m Adam.") = true

palindrome(Xs) ->
    N = nocaps(nopunct(Xs)),
    N == lists:reverse(N).

nopunct(String) ->
    lists:filter(fun (Ch) -> not(lists:member(Ch,"\"\'\t\n .")) end, String).

nocaps(String) -> 
    lists:map(fun (Ch) -> 
        case ($A =< Ch andalso Ch =< $Z) of 
        true -> Ch + 32;
        false -> Ch
        end
    end, String).




