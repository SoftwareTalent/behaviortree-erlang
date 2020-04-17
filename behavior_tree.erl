-module(behavior_tree).

-export([
  tick/1,
  create_leaf/1,
  create_composite/2
]).

-record(node, {
	type  :: leaf | selector | sequence,
	func = undefined,
	childs = undefined
}).

tick(Node) ->
    run(Node).

create_leaf(Func)->
    #node{type = leaf, func = Func}.

create_composite(Type, Childs) when Type == selector;
                                   Type == sequence ->
    #node{type = Type, childs = Childs}.

run(#node{type = leaf,
          func = Func}) ->
    case Func() of
        ok -> success;
        _ -> failure
    end;

run(#node{type = selector,
          childs = Childs}) ->
    run_selector(Childs);

run(#node{type = sequence,
          childs = Childs}) ->
    run_sequence(Childs).

run_sequence([Child|T])->
    case run(Child) of
        success ->
            run_sequence(T);
        failure ->
            failure
    end;

run_sequence([]) -> success.

run_selector([Child|T])->
    case run(Child) of
        failure ->
            run_selector(T);
        success ->
            success
    end;

run_selector([]) -> failure.