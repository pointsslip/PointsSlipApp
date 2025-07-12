#!/bin/sh

###########################################################################################################
###########################################################################################################
###
### Copyright 2025, The Lackner Group, Inc.
###
### Purpose:        Submits for notarization & 'staples' each of the files, places notarized copy
###                 in the '_ Signed' folder.
###
### Usage & Notes:  This assumes a valid Developer ID certificate is installed, and the Packages have
###                 all been compiled using that Developer ID Installer cert.
##                 
### Revisions:      2024.12.20 - Andrew Cummings; Created.
###
###########################################################################################################
###########################################################################################################

# Setup variables
appleID="andrew@artistechendeavors.com"
password="voqy-gjtn-qqzv-jnap"
teamID="XLA5QQ65S8"

echo
echo "************************************************************"
echo


# For each set of files... we'll assume they each been newly built.  Copy to signed folder, then sign.
src="/Users/hauchmahler/Dropbox/Mac/Documents/GitHub/PointsSlipApp/bin/osx-arm64/PointsSlip_osx-arm64.dmg"
dst="/Users/hauchmahler/Dropbox/Mac/Documents/GitHub/PointsSlipApp/bin/osx-arm64/PointsSlip_osx-arm64_Notarized.dmg"
mv ${src} ${dst}
echo BEGIN: $dst
xcrun notarytool submit "${dst}" --apple-id "${appleID}" --password "${password}" --team-id "${teamID}" --wait
xcrun stapler staple "${dst}"
echo DONE: $dst
echo
echo "************************************************************"
echo
