#!/bin/sh

#REQUIRES COCOADIALOG AND ASSUMES IT IS IN /Applications/Utilities

#I run this script via a policy that is set to ongoing with a custom trigger. I then only trigger it from another script that 
#runs on login once per user. If the currently logged in user is admin it passes. Otherwise it runs my custom trigger and executes
#this script.

#get admin password
adminPassword=$(/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog secure-standard-inputbox --title "FileVault" \
    --informative-text "Please enter the admin password:" \
    --button1 "Next")
    
adminPassword=$(tail -n1 <<<"$adminPassword")

#get username and password
user=`ls -la /dev/console | cut -d " " -f 4`
password=$(/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog secure-standard-inputbox --title "FileVault" \
    --informative-text "Please enter your password:" \
    --button1 "Restart")
    
password=$(tail -n1 <<<"$password")

#create plist for enabling filevault and activating currently logged in user and admin account
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
<key>Username</key>
<string>admin</string>
<key>Password</key>
<string>'$adminPassword'</string>
<key>AdditionalUsers</key>
<array>
    <dict>
        <key>Username</key>
        <string>'$user'</string>
        <key>Password</key>
        <string>'$password'</string>
    </dict>
</array>
</dict>
</plist>' >> /fdesetupTEMP.plist

# create a named pipe
rm -f /tmp/enableFV
mkfifo /tmp/enableFV

# create a background job which takes its input from the named pipe
/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog progressbar \
--indeterminate --title "Configuring FileVault" \
--text "Please wait..." < /tmp/enableFV &

# associate file descriptor 3 with that pipe and send a character through the pipe
exec 3<> /tmp/enableFV
echo -n Please wait... >&3

# do all of your work here
fdesetup enable -inputplist < /fdesetupTEMP.plist
output=$(echo $?)

# now turn off the progress bar by closing file descriptor 3
exec 3>&-

# wait for all background jobs to exit
wait
rm -f /tmp/enableFV

if [ $output == 0 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
	    --text "FileVault has been successfully configured"\
    	--informative-text "Please restart to complete setup" \
    	--button1 "Reboot"
    shutdown -r now
fi
if [ $output == 1 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "FileVault is Off. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 2 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "FileVault appears to be On but Busy. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 11 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Authentication error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 12 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Parameter error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 13 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Unknown command error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 14 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Bad command error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 15 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Bad input error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 16 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Legacy FileVault error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 17 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Added users failed error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 18 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Unexpected keychain found error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 19 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Keychain error. This usually means the FileVaultMaster keychain could not be moved or replaced. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 20 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Deferred configuration setup missing or error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 21 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Enable failed (Keychain) error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 22 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Enable failed (CoreStorage) error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 23 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Enable failed (DiskManager) error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 24 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Already enabled error. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 25 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Unable to remove user. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 26 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Unable to change recovery key. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 27 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Unable to remove recovery key. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 28 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "FileVault is either off, busy, or the volume is locked. Please configure manually." \
    	--button1 "OK"
fi
if [ $output == 99 ]; then
	rm -rf /fdesetupTEMP.plist
	/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog msgbox --title "FileVault" \
		--text "Sorry, had some trouble."\
    	--informative-text "Internal error. Please configure manually." \
    	--button1 "OK"
fi
