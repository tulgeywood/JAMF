#!/bin/sh
#Unload the daemon and make a backup
launchctl unload /Library/LaunchDaemons/com.jamfsoftware.task.1.plist
mv /Library/LaunchDaemons/com.jamfsoftware.task.1.plist /Library/LaunchDaemons/com.jamfsoftware.task.1.plist.bak

#Create the new verbose daemon
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>com.jamfsoftware.task.Every 15 Minutes</string>
        <key>ProgramArguments</key>
        <array>
                <string>sh</string>
                <string>-c</string>
                <string>echo Starting; date; /usr/sbin/jamf policy -randomDelaySeconds 300 --verbose; echo Done; date</string>
        </array>
        <key>StartInterval</key>
        <integer>900</integer>
        <key>UserName</key>
        <string>root</string>
        <key>StandardOutPath</key>
        <string>/var/log/jamfv.log</string>
</dict>
</plist>' > /Library/LaunchDaemons/com.jamfsoftware.task.1.plist

#Load the agent
launchctl load /Library/LaunchDaemons/com.jamfsoftware.task.1.plist
