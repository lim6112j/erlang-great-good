-module(linkmon).

-compile(export_all).

myproc() ->
  timer:sleep(5000),
  exit(reason).

chain(0) ->
  receive
    _ ->
      ok
  after 2000 ->
    exit("chain dies here")
  end;
chain(N) ->
  Pid = spawn(fun() -> chain(N - 1) end),
  link(Pid),
  receive
    _ ->
      ok
  end.

%% named process
start_critic() ->
  spawn(?MODULE, critic, []).

judge(Pid, Band, Album) ->
  Pid ! {self(), {Band, Album}},
  receive
    {Pid, Criticism} ->
      Criticism
  after 2000 ->
    timeout
  end.

critic() ->
  receive
    {From, {"A", "B"}} ->
      From ! {self(), "They are great"};
    {From, {"C", "D"}} ->
      From ! {self(), "They are good"};
    {From, {"E", "F"}} ->
      From ! {self(), "They are bad"};
    {From, {_Band, _Album}} ->
      From ! {self(), "They are terrible"}
  end,
  critic().

start_critic2() ->
  spawn(?MODULE, restarter, []).

restarter() ->
  process_flag(trap_exit, true),
  Pid = spawn_link(?MODULE, critic, []),
  register(critic, Pid),
  receive
    {'EXIT', Pid, normal} ->
      ok;
    {'EXIT', Pid, shutdown} ->
      ok;
    {'EXIT', Pid, _} ->
      restarter()
  end.

judge2(Band, Album) ->
  critic ! {self(), {Band, Album}},
  Pid = whereis(critic),
  receive
    {Pid, Criticism} ->
      Criticism
  after 2000 ->
    timeout
  end.
