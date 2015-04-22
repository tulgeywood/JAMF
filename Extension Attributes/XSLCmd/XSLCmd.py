import os

user = os.popen("echo $(ls -la /dev/console | cut -d \" \" -f 4)").read().split("\n")[0]

files = ["/Users/" + user + "/Library/LaunchAgents/clipboardd",
         "/Users/" + user + "/Library/Logs/clipboardd",
         "/Users/" + user + "/Library/LaunchAgents/com.apple.service.clipboardd.plist",
         "/Users/" + user + "/.fontset/pxupdate.ini",
         "/Users/" + user + "/.fontset/chkdiska.dat",
         "/Users/" + user + "/.fontset/chkdiskc.dat",
         "/Users/" + user + "/Library/Logs/BackupData/<year><month><day>_<hr>_<min>_<sec>_keys.log"]

files_found = ""

for file in files:
    if os.path.isfile(file):
        if len(files_found) == 0:
            files_found += file
        else:
            files_found.append(", " + file)

if len(files_found) > 0:
    print "<result>" + files_found + "</result>"
else:
    print "<result>Clean</result>"
