%% cli.hrl - Header


% command structure
-record(cmd, {
	name,         % command name
	description,  % command description
	func_name,    % function to execute command
	func_param,    % function parameter
	sub_command
	}).
