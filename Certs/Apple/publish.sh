rm -fr bin
mkdir bin
dotnet publish PointsSlip.csproj -c Release -r osx-x64 -p:UseAppHost=true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:IncludeAllContentForSelfExtract=true --self-contained true -p:PublishReadyToRunShowWarnings=true -o bin/osx-x64
dotnet publish PointsSlip.csproj -c Release -r osx-arm64 -p:UseAppHost=true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:IncludeAllContentForSelfExtract=true --self-contained true -p:PublishReadyToRunShowWarnings=true -o bin/osx-arm64

chmod +x bin/osx-x64/PointsSlip
chmod +x bin/osx-arm64/PointsSlip

codesign --deep --force --verify --verbose --sign "Developer ID Application: Andrew Cummings (XLA5QQ65S8)" --options runtime "bin/osx-x64/PointsSlip"

codesign --deep --force --verify --verbose --sign "Developer ID Application: Andrew Cummings (XLA5QQ65S8)" --options runtime "bin/osx-arm64/PointsSlip"

mkdir bin/osx
lipo -create -output bin/osx/PointsSlip bin/osx-x64/PointsSlip bin/osx-arm64/PointsSlip
chmod +x bin/osx/PointsSlip

codesign --remove-signature bin/osx/PointsSlip

codesign --deep --force --verify --verbose --sign "Developer ID Application: Andrew Cummings (XLA5QQ65S8)" --options runtime "bin/osx/PointsSlip"

cp -R Assets/Templates/PointsSlip.app/ bin/osx/PointsSlip.app/
cp bin/osx/PointsSlip bin/osx/PointsSlip.app/Contents/MacOS/PointsSlip
cp Assets/Logos/logo.icns bin/osx/PointsSlip.app/Contents/Resources/logo.icns

rm bin/osx/PointsSlip
rm -fr bin/Release

mkdir bin/osx/PointsSlip
mv bin/osx/PointsSlip.app bin/osx/PointsSlip/PointsSlip.app

ln -s /Applications bin/osx/PointsSlip/Applications

codesign --remove-signature bin/osx/PointsSlip/PointsSlip.app

codesign --deep --force --verify --verbose --options runtime --sign "Developer ID Application: Andrew Cummings (XLA5QQ65S8)" "bin/osx/PointsSlip/PointsSlip.app"

codesign -vvv --deep --strict --verbose bin/osx/PointsSlip/PointsSlip.app



create-dmg bin/osx/PointsSlip_osx.dmg bin/osx/PointsSlip/ --volname "Points Slip" --volicon /Users/hauchmahler/Dropbox/Mac/Documents/GitHub/PointsSlipApp/Assets/Logos/logo.icns --window-size 300 500 --background /Users/hauchmahler/Dropbox/Mac/Documents/GitHub/PointsSlipApp/Assets/Images/background.png

codesign --deep --force --verify --verbose --sign "Developer ID Application: Andrew Cummings (XLA5QQ65S8)" --options runtime "bin/osx/PointsSlip_osx.dmg"


codesign -vvv --deep --strict --verbose bin/osx/PointsSlip_osx.dmg

echo
echo
echo ******************************************
echo
echo

xcrun notarytool submit "bin/osx/PointsSlip_osx.dmg" --apple-id "andrew@artistechendeavors.com" --password "voqy-gjtn-qqzv-jnap" --team-id "XLA5QQ65S8" --wait
xcrun stapler staple "bin/osx/PointsSlip_osx.dmg"
echo
echo
echo ******************************************
echo
echo

hdiutil attach "bin/osx/PointsSlip_osx.dmg"
spctl -a -vv "/Volumes/PointsSlip_osx 1/PointsSlip.app"
hdiutil detach "/Volumes/PointsSlip_osx 1/"

# to check the log of the notarization:
# xcrun notarytool log "fcd59afc-e801-4890-9cfc-73ab9f8cb77d" --apple-id "andrew@artistechendeavors.com" --password "voqy-gjtn-qqzv-jnap" --team-id "XLA5QQ65S8"

