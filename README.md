# cli
A simple Erlang-based CLI shell for managing your Erlang/OTP applications

## Usage
```console
12> c(cli).
{ok,cli}

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
