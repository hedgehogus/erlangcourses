%% recs.hrl

- record(twitter, {name, handle}).


- module(record).
- include("recs.hrl").

rl() -> #twitter{name="simon", handle="@si"}.

get_name(X) -> X#twitter.name.

update_si(#twitter{name="simon"} = X) ->
    X#twitter{name="si"};
update_si(X) -> X.