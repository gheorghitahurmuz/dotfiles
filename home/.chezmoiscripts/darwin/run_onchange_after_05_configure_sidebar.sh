#!/bin/bash
# Script uses mysides ( https://github.com/mosen/mysides ) to clear the sidebar and add our prefs.
# Our script is run by the local user in conjunction with other applescripts wrapped in an app
# before deployment to the end-user

# Get the Username of the currently logged user
loggedInUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')

# Removes all sides and adds /Applications, User Desktop, Documents, Downloads, Home Folder
if [ -e /usr/local/bin/mysides ]; then
    mysides=$(which mysides)
    $mysides remove all
    $mysides add $loggedInUser file:///Users/$loggedInUser
    $mysides add Applications file:///Applications
    $mysides add Desktop file:///Users/$loggedInUser/Desktop
    $mysides add Documents file:///Users/$loggedInUser/Documents
    $mysides add Downloads file:///Users/$loggedInUser/Downloads
    $mysides add Code file:///Users/$loggedInUser/Code
fi

killall Finder
