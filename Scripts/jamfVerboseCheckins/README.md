Running this script enables you to get full verbose logging of the JAMF checkin policy. This is accomplished by replacing the existing checkin LaunchDaemon with a new one that runs in verbose mode and saves output to /var/log/jamfv.log. This can be useful in figuring out why checkins may be failing or if some policies take far longer than necessary.

You can deploy this easily in a policy or by running locally as root. You can revert this change by running 'sudo jamf manage'
