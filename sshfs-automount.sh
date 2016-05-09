#!/bin/bash
# Automount sshfs volume automatically

# Dependencies
# sudo apt-get install sshfs
# sudo apt-get install notify-osd
# sudo apt-get install libnotify-bin

# internal variables
t=1
c=0
s=1

# Load server variables
source ~/.sshfs-server.cfg

#functions
function notify() {
    if [ "$1" = 1 ]; then
        while [ $c = 0 ]; do
            notify-send "SSHFS" "There was a problem mounting the SSHFS volume. Check if the server is running Linux and/or if the mount is already mounted."
            (( c++ ))
        done
        while [ $c = 1 ]; do
            sleep 10
            notify-send "SSHFS" "The service will keep on trying to mount the volume."
            (( c++ ))
        done
    else
        notify-send "SSHFS" "The sshfs mount \"~/"$mountpoint"\" completed successfully."
        echo "Success."
    fi
}
 
function sshfs_mount() {
    # Unmount local mountpoint first (this solves "endpoint not connected" error)
    fusermount -uzq $mountpoint
    sshfs $user@$host:/ $mountpoint -o IdentityFile=$sshprivatekey -o idmap=user -p $port
    s=$?
}

# Start of the script

echo "Starting sshfs-automount..."
until [ $s = 0 ]; do # check for the sshfs mount
    # Count to 120s and ping the server until the server is online
    until [ $t = 0 ]; do
        min=$(( $interval/60 ))
        echo "waiting $min minutes..."
        sleep $interval
        echo "Pinging the host..."
        ping -c 2 $host
        t=$? # setting the t variable to the ping error code, so that the loop continues. It's 0 only when it is successful.
    done
    sleep 5 # just for the sake of it
    echo "Trying to mount the remote sshfs volume..."
    sshfs_mount
    notify $s # notify about the result
done
