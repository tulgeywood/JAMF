#!/usr/bin/python
import os

user = os.popen("echo $(ls -la /dev/console | cut -d \" \" -f 4)").read().split("\n")[0]

signatures = os.popen("curl http://www.adwaremedic.com/signatures.xml").readlines()

result = "<result>"

for line in signatures:
    if "<adware name=" in line:
        adware = line.split('\"')[1]
        print "Checking for " + adware
    else:
        if "type=\"path\"" in line and "havingContent" not in line:
            if "relativeTo=" in line:
                path = line.split("relativeTo=\"")[1].split("\"")[0]
                if path == "home":
                    path = "/Users/" + user + "/" + line.split("</item>")[0].split(">")[1]
                    if "." in path:
                        if os.path.isfile(path) and adware not in result:
                            result = result + adware + "\n"
                    else:
                        if os.path.isdir(path) and adware not in result:
                            result = result + adware + "\n"
            else:
                path = line.split("</item>")[0].split(">")[1]
                if "." in path:
                    if os.path.isfile(path) and adware not in result:
                        result = result + adware + "\n"
                else:
                    if os.path.isdir(path) and adware not in result:
                       result = result + adware + "\n"

if result == "<result>":
    print result + "No adware detected</result>"
else:
    print result[:-1] + "</result>"
