#!/bin/bash
###############################################################################
# Title: PTS Relocate Repositories
# Coder: iDoMnCi
# GNU: General Public License v3.0E
#
################################################################################
### FUNCTIONS START #####################################################
###################################
old=https://github.com/PTS-Team/
new=https://github.com/smashingtags/

sudocheck() {
    if [[ $EUID -ne 0 ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
        exit 0
    fi
}
agreebase() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ READ THIS NOTE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This script is for use of moving from /PTS-Team/ to /MHA-Team/ Github
repository. This should only be executed if you are currently on the old
/PTS-Team/ repo. If you are unsure running this script should do not harm
if you're already on the right repo.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    timer
}
timer() {
    seconds=5; date1=$((`date +%s` + $seconds));
    while [ "$date1" -ge `date +%s` ]; do
        echo -ne "$(date -u --date @$(($date1 - `date +%s` )) +%H:%M:%S)\r";
    done
}
existpg() {
    file="/opt/plexguide/menu/pg.yml"
    if [[ -f $file ]]; then
        confirmEdits
else nopg ; fi
}
confirmEdits() {
    echo
    read -p '⛔️ BEGIN Migraton? | Press [ENTER] to Start ' typed </dev/tty
    updaterepos
}
updaterepos() {
    updatefiles
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Migration Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

You have successfully migrated to the /MHA-Team/ project repository.
Running ptsupdate should now work along with any redeployment of
traefik, shield, clone and so forth.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}
updatefiles() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ Starting Search & Replace
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    cd /bin
    find . -type f -print0 | xargs -0 grep -l -r "$old" |tee /dev/tty | xargs sed -i "s+${old}+${new}+g"
    echo
    read -p '✅ | /bin Files Updated | Press [ENTER] to Continue ' typed </dev/tty
    sleep 0.5
    cd /var/plexguide
    find . -type f -print0 | xargs -0 grep -l -r "$old" |tee /dev/tty | xargs sed -i "s+${old}+${new}+g"
    echo
    read -p '✅ | /var/plexguide Files Updated | Press [ENTER] to Continue ' typed </dev/tty
    sleep 0.5
    cd /opt
    find . -type f -print0 | xargs -0 grep -l -r "$old" |tee /dev/tty | xargs sed -i "s+${old}+${new}+g"
    echo
    read -p '✅ | /opt Files Updated | Press [ENTER] to Continue ' typed </dev/tty
}
doneokay() {
    echo
    read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
}

###  FUNCTIONS END #####################################################
#### function layout for order one by one

sudocheck
agreebase
existpg
