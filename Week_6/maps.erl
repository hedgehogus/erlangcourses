- module(maps).

mapl() -> #{name => "simon", handle => "@si"}.

get_name(#{name := Y}) -> Y.

update_si(#{name := "simon"} = X) -> X#{name := "si"};
update_si(X) -> X. 