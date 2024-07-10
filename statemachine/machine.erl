%% example from  https://www.erlang.org/doc/apps/stdlib/gen_statem
-module(machine).
-behaviour(gen_statem).

-export([start/0, push/0, get_count/0, stop/0]).
-export([terminate/3, code_change/4, init/1, callback_mode/0]).
-export([on/3, off/3]).

name() ->
		pushbutton_statem.

%% API
%% and does not link to the caller

start() ->
		gen_statem:start({local, name()}, ?MODULE, [], []).
push() ->
		gen_statem:call(name(), push).
get_count() ->
		gen_statem:call(name(), get_count).
stop() ->
		gen_statem:stop(name()).

%% Mandatory callback functions
terminate(_Reason, _State, _Data) ->
		void.
code_change(_Vsn, State, Data, _Extra) ->
		{ok, State, Data}.
init([]) ->
		State = off,
		Data = 0,
		{ok, State, Data}.
callback_mode() ->
		state_functions.

%%% state callback(s)
off({call, From}, push, Data) ->
		{next_state, on, Data+1, [{reply, From, on}]};
off(EventType, EventContent, Data) ->
		handle_event(EventType, EventContent, Data).
on({call, From}, push, Data) ->
		{next_state, off, Data, [{reply, From, off}]};
on(EventType, EventContent, Data) ->
		handle_event(EventType, EventContent, Data).

%% Handle events common to all states

handle_event({call, From}, get_count, Data) ->
		{keep_state, Data, [{reply, From, Data}]};
handle_event(_, _, Data) ->
		{keep_state, Data}.
