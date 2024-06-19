%%% Naive version
-module(kitty_server).

-export([start_link/0, order_cat/4]).

-record(cat, {name, color = green, description}).

%%% client api
start_link() ->
  spawn_link(fun init/0).

%%% Synchronous call
order_cat(Pid, Name, Color, Description) ->
  Ref = erlang:monitor(process, Pid),
  Pid ! {self(), Ref, {order, Name, Color, Description}},
  receive
    {Ref, Cat} ->
      erlang:demonitor(Ref, [flush]),
      Cat;
    {'Down', Ref, process, Pid, Reason} ->
      erlang:error(Reason)
  after 5000 ->
    erlang:error(timeout)
  end.

init() ->
  loop([]).

loop(Cats) ->
  receive
    {Pid, REf, {order, Name, Color, Description}} ->
      if Cats =:= [] ->
           Pid ! {Ref, make_cat(Name, Color, Description)},
           loop(Cats);
         Cats =/= [] ->
           Pid ! {Ref, hd(Cats)},
           loop(tl(Cats))
      end;
    {return, Cat = #cat{}} ->
      loop([Cat | Cats]);
    {Pid, Ref, terminate} ->
      Pid ! {Ref, ok},
      terminate(Cats);
    Unknown ->
      io:format("Unknown message: ~p~n", [Unknown]),
      loop(Cats)
  end.
