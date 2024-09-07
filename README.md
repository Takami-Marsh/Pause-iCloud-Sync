# Pause iCloud Sync on Mac OS

## General 

### Description 

This script will look on *nsurlsessiond* and *cloudd* processus and will kill them by getting their **PID**, effectively pausing iCloud Sync on Mac OS.

### Installation 

- Download the script
- Make sure you have the right permissions to execute the command (`chmod u+x ./stop_icloud.sh`)

### Utilisation 

Launch it with just `./stop_icloud.sh`.

**Verbose mode :** You can acces to the verbose mode by taping `./stop_icloud.sh -v`

I personally reccomend placing this script in a safe location and creating an alias in your shell profile like this: `alias [name of alias]='[the script's saved path]'`

Be sure to not include the brackets!

By setting an alias, you can run this script in the terminal by simply typing the name of this alias which'll probably make your life a lot easier!

### Stopping the script

You can stop the script by pressing `ctrl + c` on the terminal where the script is running.


## Copyright

Created by **Lucas Tarasconi** the 07/04/2017 
Modified by **Takami Marsh** 09/07/2024
