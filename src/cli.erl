%% cli.erl - Erlang CLI Shell
%% Copyright 2017 Austin Aigbe


-module(cli).
-export([start/0]).

-include("../include/cli.hrl").

-define(HOSTNAME, chomp1(os:cmd(hostname))).


% CLI entry point to manage the configuration of your Erlang application
% Erlang shell: cli:start()
% CLI: erl -run cli -noshell
start() ->
	banner(),
	config_db(),
	exec_mode().


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% You can edit the banner to suit your purpose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
banner() ->
	io:format(" Display your banner here ~n").

get_otp_rel() ->
    erlang:system_info(otp_release).

prompt(P) ->
    case get_otp_rel() of
        "20" ->
            string:chomp(io:get_line(P));
        _ ->
            % pre rel 20
            chomp1(io:get_line(P))
    end.
            
% Remove any trailing \n or \r\n from string S
chomp1(S) ->
    case get_otp_rel() of
        "20" ->
            string:chomp(S);
        _ ->
            L = length(S),
            PosN = string:chr(S,10), %\n
            PosR = string:chr(S, 13), %\r
            if 
                PosN == (PosR +1) ->
                    string:left(S, L-2);
                L == PosN ->
                    string:left(S, L-1);
                true ->
                    S
            end
    end.

% Modes

% EXEC mode - default mode
exec_mode() ->
	Prompt = [?HOSTNAME ++ "> "],
	Cmd = prompt(Prompt),
	[M|P] = string:split(Cmd," ", all),
	case M of
		"exit" ->
			mnesia:stop(), % switch to ets
			bye;
		"enable" -> 
			priv_exec_mode(); % process_command(M, P);
		"?" ->
			exec_mode_help(),
			exec_mode();
		"help" ->
			exec_mode_help(),
			exec_mode();
		"show" ->
			process_command(M, P),
			exec_mode();
		[] -> 
			exec_mode();
		_ -> 

			exec_mode()
	end.

% Global Configuration Mode
config_mode() ->
	Prompt = [?HOSTNAME ++ "(config)# "],
	Cmd = prompt(Prompt),
	[M|P] = string:split(Cmd," ", all),
	case M of
		"end" ->
			priv_exec_mode();
		[] ->
			config_mode();
		"?" ->
			config_mode_help(),
			config_mode();
		"help" ->
			config_mode_help(),
			config_mode();
		_ ->
			process_command(M, P)
	end.

% Privileged EXEC Mode
priv_exec_mode() ->
	Prompt = [?HOSTNAME ++ "# "],
	Cmd = prompt(Prompt),
	[M|_] = string:split(Cmd," ", all),
	case M of
		"disable" ->
			ok,
			exec_mode();
		[] ->
			priv_exec_mode();
		"configure" ->
			config_mode();
		"?" ->
			priv_mode_help(),
			priv_exec_mode();
		"help" ->
			priv_mode_help(),
			priv_exec_mode();
		_ ->
			priv_exec_mode()
	end.


% Display the user EXEC commands
exec_mode_help() ->
	io:format("Exec commands:
exit 	 Exit from EXEC mode
help 	 Description of the interactive help system
enable	 Turn on privileged commands
show      \n").

% Display the privileged EXEC commands
priv_mode_help() ->
	io:format("Privileged Exec commands:
disable 	Exit from Privileged Exec mode
help 		Description of the interactive help system
configure 	Enter global configuration mode.\n").


% Display the privileged EXEC commands
config_mode_help() ->
	io:format("Global Confiuration commands:
end 		Ends the current configuration session and returns to privileged EXEC mode.
help 		Description of the interactive help system.\n").


% Process user commands
process_command(M, Param) ->
	case M of
		"show" ->
			show(Param);
		"config" ->
			config_mode()
	end.

% CLI Commands

% show command
show(P) ->
	case P of
		["?"] ->
			exec_mode_help()
	end.	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Configuration database 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

config_db() ->
	mnesia:start(),
	case mnesia:create_table(cmd, [{attributes, record_info(fields, cmd)}]) of
		{atomic, ok} -> ok;
		{aborted, {already_exists, _}} -> ok
	end.

config_db_get(Command) ->
	F = fun() ->
			[P] = mnesia:read(cmd, Command)
		end,
	mnesia:transaction(F).
	
config_db_insert(Data) ->
	F = fun() ->
			mnesia:write(Data)
		end,
	mnesia:transaction(F).

config_db_info() ->
	mnesia:info().