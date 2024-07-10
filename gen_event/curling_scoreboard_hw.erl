%% from https://learnyousomeerlang.com/event-handlers#handle-this
-module(curling_scoreboard_hw).
-export([set_teams/2]).
-export([next_round/0]).
-export([add_point/1]).
-export([reset_board/0]).

set_teams(TeamA, TeamB) ->
		io:format("Scoreboard: Team ~s vs. Team ~s~n", [TeamA, TeamB]).
next_round() ->
		io:format("Scoreboard: round over~n").
add_point(Team) ->
		io:format("Scoreboard: increased score of team ~s by 1~n", [Team]).
reset_board() ->
		io:format("Scoreboard: All teams are undefined and all scores are 0~n").
