This script uses AdwareMedic’s signatures to scan and detect installed adware on macs.
The below cURL grabs the signatures and the URL itself is subject to change as it is not publicly made available.

curl http://www.adwaremedic.com/signatures.xml

In it's current version this script should find about 99% of what AdwareMedic does. I'll be adding some more string
processing soon that will fill in that last 1%.
