The launchdaemon will run whenever the user plugs or unplugs the powercable. It does a quick ping test to make sure you are in the office before it logs anything (incase users have TB displays at home.)

Two files are generated to help with tracking when a display has switched. This is also meant to be paired with an API updating script to assign the TB displays as peripherals to the user in the JSS. Sadly, due to a bug in the API you cannot unassign a peripheral from a user and thus that portion is not currently operational.
