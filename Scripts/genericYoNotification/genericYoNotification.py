#!/usr/bin/python
import subprocess
import sys

##########################################################################################
# Written by Tulgeywood 04/24/2015
#
# Name the Casper Parameters:
# 4 Title 
# 5 Subtitle
# 6 Info
# 7 Button
# 8 Other Button
# 9 Icon
# 10 Content Image
# 11 Action Path
#
# All file paths need escaped spaces /path/to\ file/like\ this/
##########################################################################################

YO = "/Applications/Utilities/Yo.app/Contents/MacOS/yo"
title = ['-t',str(sys.argv[4])]
subtitle = ['-s',str(sys.argv[5])]
info = ['-n',str(sys.argv[6])]
button1 = ['-b',str(sys.argv[7])]
button2 = ['-o',str(sys.argv[8])]
icon = ['-i',str(sys.argv[9])]
image = ['-c',str(sys.argv[10])]
action = ['-a',str(sys.argv[11])]

flags = [title,subtitle,info,button1,button2,icon,image,action]

command_string = ''

for flag in flags:
    if len(flag[1]) > 0:
        command_string += flag[0] + ' ' + flag[1] + ' '

print command_string

subprocess.call([YO + ' ' + command_string ],shell=True)
