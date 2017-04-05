-module(palin).
-export([palindrome/1, server/1]).

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

server(Pid) ->
    receive 
    {check, String} ->
        case palindrome(String) of
        true -> Pid ! {result, "\"" ++ String ++ "\" is palindrome"};     
        false -> Pid ! {result, "\"" ++ String ++ "\" is not palindrome"}       
        end,
    server(Pid);
    _ ->
        io:format("stopped ~n")        
    end.






