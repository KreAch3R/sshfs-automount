sshfs-automount
===============

If you use an ssh server regularly, you know the struggle of wanting to just check something through a regular file explorer. Of course there are sftp clients like FileZilla, but there's also sshfs, which helps you mount the remote HDD as a local one. Sshfs-automount can be run at system startup and it will notify you about its actions with a popup. It can ping the remote server before trying to automount. There are other bash implementations too, and this one is what works for me. 

First time instructions
-----------------------

1. git clone
2. cd into cloned folder
3. cp sshfs-server.cfg ~/.sshfs-server.cfg
4. Edit ~/.sshfs-server.cfg and edit the necessary variables (ssh keys are required)
5. mkdir ~/"localFolder"
6. ./sshfs-automount.sh
