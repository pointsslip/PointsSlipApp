mkdir bin
dotnet publish PointsSlip.csproj -c Release -r osx-x64 -p:UseAppHost=true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:IncludeAllContentForSelfExtract=true --self-contained true -p:PublishReadyToRunShowWarnings=true -o bin/osx-x64

rm bin/osx-x64/*.pdb
chmod +x bin/osx-x64/PointsSlip

codesign --remove-signature bin/osx-x64/PointsSlip

cp -R Assets/Templates/PointsSlip.app/ bin/osx-x64/PointsSlip.app/
cp bin/osx-x64/PointsSlip bin/osx-x64/PointsSlip.app/Contents/MacOS/PointsSlip
cp Assets/Logos/logo.icns bin/osx-x64/PointsSlip.app/Contents/Resources/logo.icns

rm bin/osx-x64/PointsSlip
rm -fr bin/Release

mkdir bin/osx-x64/PointsSlip
mv bin/osx-x64/PointsSlip.app bin/osx-x64/PointsSlip/PointsSlip.app

codesign --remove-signature bin/osx-x64/PointsSlip/PointsSlip.app

codesign --deep --timestamp --force --verify --verbose --sign "Developer ID Application: Andrew Cummings (XLA5QQ65S8)" bin/osx-x64/PointsSlip/PointsSlip.app

codesign -vvv --deep --strict --verbose bin/osx-x64/PointsSlip/PointsSlip.app

ln -s /Applications bin/osx-x64/PointsSlip/Applications

create-dmg bin/osx-x64/PointsSlip_osx-x64.dmg bin/osx-x64/PointsSlip/ --volname "Points Slip" --volicon /Users/hauchmahler/Dropbox/Mac/Documents/GitHub/PointsSlipApp/Assets/Logos/logo.icns --filesystem APFS --window-size 300 500 --background /Users/hauchmahler/Dropbox/Mac/Documents/GitHub/PointsSlipApp/Assets/Images/background.png

codesign --remove-signature bin/osx-x64/PointsSlip_osx-x64.dmg

codesign --deep --timestamp --force --verify --verbose --sign "Developer ID Application: Andrew Cummings (XLA5QQ65S8)" bin/osx-x64/PointsSlip_osx-x64.dmg

codesign -vvv --deep --strict --verbose bin/osx-x64/PointsSlip_osx-x64.dmg

sh Certs/Apple/Notarize-x64.sh

codesign -vvv --deep --strict --verbose bin/osx-x64/PointsSlip_osx-x64_Notarized.dmg

mv bin/osx-x64/PointsSlip_osx-x64_Notarized.dmg bin/osx-x64/PointsSlip_osx-x64.dmg
