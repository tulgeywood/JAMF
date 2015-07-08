#!/bin/sh
#clean up legacy version if it exists
if [ -e /Library/LaunchDaemons/com.company.displayInventoryCollector.plist ]; then
    launchctl unload /Library/LaunchDaemons/com.company.displayInventoryCollector.plist
    rm -rf /Library/LaunchDaemons/com.company.displayInventoryCollector.plist
fi

#make Company scripts dir if it doesn't exist
if [ ! -d /Library/Scripts/Company ]; then
    mkdir /Library/Scripts/Company
fi

#create LaunchAgent
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>com.company.displayInventoryCollector</string>
        <key>ProgramArguments</key>
        <array>
                <string>/Library/Scripts/Company/displayInventoryCollector.sh</string>
        </array>
        <key>WatchPaths</key>
        <array>
                <string>/private/var/root/Library/Preferences/com.apple.telemetry.battery.charge-cycle.plist</string>
        </array>
</dict>
</plist>' > /Library/LaunchDaemons/com.company.displayInventoryCollector.plist

#create ejector.sh script
echo '#!/bin/sh
sleep 20
if $(ping -q -c 1 ldapmaster.colo.lair > /dev/null); then
        if $(system_profiler SPDisplaysDataType | grep -q "Display Serial Number:"); then
                while read line; do
                        if $(system_profiler SPDisplaysDataType | grep -q "$line") &&                             \
                                [[ $(wc -l < /var/db/.ThunderboltDisplays) -eq                                    \
                                $(system_profiler SPDisplaysDataType |                                            \
                                awk '"'"'/Display Serial Number:/ { count++ } END { print count }'"'"') ]]; then
                                echo "no change"
                        else
                                echo "updating"
                                if [ -f /var/db/.ThunderboltDisplays ]; then
                                        cat /var/db/.ThunderboltDisplays > /var/db/.ThunderboltDisplaysPrevious
                                fi
                                system_profiler SPDisplaysDataType |                                              \
                                awk '"'"'/Display Serial Number:/{print $NF}'"'"' > /var/db/.ThunderboltDisplays
                                exit 0
                        fi
                done < /var/db/.ThunderboltDisplays
        fi
fi' > /Library/Scripts/Company/displayInventoryCollector.sh

#make ejector.sh executable
chmod +x /Library/Scripts/Company/displayInventoryCollector.sh

#load the LaunchAgent
launchctl load /Library/LaunchDaemons/com.company.displayInventoryCollector.plist
exit 0
