-module(curling_scoreboard).
-behavior(gen_event).

%%% gen_event callbacks
-export([init/1]).
-export([handle_event/2]).
-export([handle_call/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).




%%% gen_event callbacks
-spec init(InitArgs :: term()) ->
    {ok, State :: term()} |
    {ok, State :: term(), hibernate} |
    {error, Reason :: term()}.
init([]) ->
		{ok, []}.

-spec handle_event(Event :: term(), State :: term()) ->
    {ok, NewState :: term()} |
    {ok, NewState :: term(), hibernate} |
    {swap_handler, Args1 :: term(), NewState :: term(),
     Handler2 :: (atom() | {atom(), Id :: term()}), Args2 :: term()} |
    remove_handler.
handle_event({set_teams, TeamA, TeamB},State ) ->
		curling_scoreboard_hw:set_teams(TeamA, TeamB),
		{ok, State};
handle_event({add_points, Team, N}, State) ->
		[curling_scoreboard_hw:add_point(Team) || _ <- lists:seq(1, N)],
		{ok, State};
handle_event(next_round, State) ->
		curling_scoreboard_hw:next_round(),
		{ok, State};
handle_event(_, State) ->
		{ok, State}.
-spec handle_call(Request :: term(), State :: term()) ->
    {ok, Reply :: term(), NewState :: term()} |
    {ok, Reply :: term(), NewState :: term(), hibernate} |
    {swap_handler, Reply :: term(), Args1 :: term(), NewState :: term(),
     Handler2 :: (atom() | {atom(), Id :: term()}), Args2 :: term()} |
    {remove_handler, Reply :: term()}.
handle_call(_, State) ->
		{ok, ok, State}.

-spec handle_info(Info :: term(), State :: term()) ->
    {ok, NewState :: term()} |
    {ok, NewState :: term(), hibernate} |
    {swap_handler, Args1 :: term(), NewState :: term(),
     Handler2 :: (atom() | {atom(), Id :: term()}), Args2 :: term()} |
    remove_handler.
handle_info(_, State) ->
		{ok, State}.

-spec terminate(Args :: (term() | {stop, Reason :: term()} |
                             stop | remove_handler |
                             {error, {'EXIT', Reason :: term()}} |
                             {error, term()}),
                    State :: term()) ->
    term().
terminate(_, _) ->
  ok.

-spec code_change(OldVsn :: (term() | {down, term()}),
                      State :: term(), Extra :: term()) ->
    {ok, NewState :: term()}.
code_change(_OlvVsn, State, _Extra) ->
		{ok, State}.
