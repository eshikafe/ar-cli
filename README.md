# About cli
A simple Erlang-based CLI shell for managing your Erlang/OTP applications

### Usage (from Erlang)
```console
# Compile cli.erl

12> c(cli).
{ok,cli}

# Run the start function

13> cli:start().
 Display your banner here 
eshikafe> 
eshikafe> ?
Exec commands:
exit 	 Exit from EXEC mode
help 	 Description of the interactive help system
enable	 Turn on privileged commands
show      
eshikafe> enable
eshikafe# 
eshikafe# 
eshikafe# ?
Privileged Exec commands:
disable 	Exit from Privileged Exec mode
help 		Description of the interactive help system
configure 	Enter global configuration mode.
eshikafe# 
eshikafe# disable
eshikafe> 
eshikafe> 

```

### Usage (from the Windows/Linux shell)
``` console
# Change directory to the bin folder
# Or add the bin folder to your PATH. The compiled cli.beam file must be in the same folder ass
# the python script (cli.py)

C:\Users\eshikafe\Documents\GitHub\cli\bin>dir
 Volume in drive C is OSDISK
 Directory of C:\Users\eshikafe\Documents\GitHub\cli\bin

09/23/2017  08:03 PM             2,908 cli.beam
09/22/2017  08:17 AM                70 cli.py

# Run the python script (cli.py)

C:\Users\eshikafe\Documents\GitHub\cli\bin>python cli.py
 Display your banner here
eshikafe>
eshikafe>
eshikafe> ?
Exec commands:
exit     Exit from EXEC mode
help     Description of the interactive help system
enable   Turn on privileged commands
show
eshikafe> enable
eshikafe#
eshikafe# ?
Privileged Exec commands:
disable         Exit from Privileged Exec mode
help            Description of the interactive help system
configure       Enter global configuration mode.
eshikafe#
eshikafe# disable
eshikafe>
eshikafe>
eshikafe> exit

=INFO REPORT==== 23-Sep-2017::20:14:36 ===
    application: mnesia
    exited: stopped
    type: temporary

C:\Users\eshikafe\Documents\GitHub\cli\bin>
```

### Customizing cli
``` console
# You can edit cli.erl to suit your purpose

# Editing the banner
# Change the following line of code
banner() ->
	io:format(" Display your banner here ~n").

# Edited code
banner() ->
	io:format(" Copyright blah blah blah ~n"),
 io:format(" IF YOU ARE NOT AN AUTHORIZED USER PLEASE EXIT IMMEDIATELY~n").
 
# Compile cli.erl and run cli:start()
17> c(cli).
{ok,cli}
18> cli:start().
 Copyright blah blah blah 
 IF YOU ARE NOT AN AUTHORIZED USER PLEASE EXIT IMMEDIATELY
eshikafe> 
eshikafe> 
```
