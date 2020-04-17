-module(demo).
-export([start/0]).

start()->
    Fun1 = create_print_out_fun("If hungry?~n"),
    Leaf1 = behavior_tree:create_leaf(Fun1),

    Fun2 = create_print_out_fun("Have food?~n"),
    Leaf2 = behavior_tree:create_leaf(Fun2),

    Fun3 = create_print_out_fun("Action: Eat apple~n"),
    Leaf3 = behavior_tree:create_leaf(Fun3),

    Fun4 = create_print_out_fun("Action: Eat cake~n"),
    Leaf4 = behavior_tree:create_leaf(Fun4),

    SelectorNode = behavior_tree:create_composite(selector, [Leaf3, Leaf4]),
    
    RootNode = behavior_tree:create_composite(sequence, [Leaf1, Leaf2, SelectorNode]),

    behavior_tree:tick(RootNode).

create_print_out_fun(String)->
    fun()->
        io:format(String)
    end.