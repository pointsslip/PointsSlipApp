mkdir bin
dotnet publish PointsSlip.csproj -c Release -r osx-x64 -p:UseAppHost=true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:IncludeAllContentForSelfExtract=true --self-contained true -p:PublishReadyToRunShowWarnings=true -o bin/osx-x64
dotnet publish PointsSlip.csproj -c Release -r osx-arm64 -p:UseAppHost=true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:IncludeAllContentForSelfExtract=true --self-contained true -p:PublishReadyToRunShowWarnings=true -o bin/osx-arm64

rm bin/osx-x64/*.pdb
rm bin/osx-arm64/*.pdb
chmod +x bin/osx-arm64/PointsSlip
chmod +x bin/osx-x64/PointsSlip
mkdir bin/osx
lipo -create -output bin/osx/PointsSlip bin/osx-x64/PointsSlip bin/osx-arm64/PointsSlip
rm -fr bin/osx-x64
rm -fr bin/osx-arm64

codesign --remove-signature bin/osx/PointsSlip

cp -R Assets/Templates/PointsSlip.app/ bin/osx/PointsSlip.app/
cp bin/osx/PointsSlip bin/osx/PointsSlip.app/Contents/MacOS/PointsSlip
cp Assets/Logos/logo.icns bin/osx/PointsSlip.app/Contents/Resources/logo.icns

rm bin/osx/PointsSlip
rm -fr bin/Release

mkdir bin/osx/PointsSlip
mv bin/osx/PointsSlip.app bin/osx/PointsSlip/PointsSlip.app

codesign --remove-signature bin/osx/PointsSlip/PointsSlip.app

codesign --deep --timestamp --force --verify --verbose --sign "Developer ID Application: Andrew Cummings (XLA5QQ65S8)" bin/osx/PointsSlip/PointsSlip.app

codesign -vvv --deep --strict --verbose bin/osx/PointsSlip/PointsSlip.app

ln -s /Applications bin/osx/PointsSlip/Applications

create-dmg bin/osx/PointsSlip_osx.dmg bin/osx/PointsSlip/ --volname "Points Slip" --volicon /Users/hauchmahler/Dropbox/Mac/Documents/GitHub/PointsSlipApp/Assets/Logos/logo.icns --filesystem APFS --window-size 300 500 --background /Users/hauchmahler/Dropbox/Mac/Documents/GitHub/PointsSlipApp/Assets/Images/background.png

codesign --remove-signature bin/osx/PointsSlip_osx.dmg

codesign --deep --timestamp --force --verify --verbose --sign "Developer ID Application: Andrew Cummings (XLA5QQ65S8)" bin/osx/PointsSlip_osx.dmg

codesign -vvv --deep --strict --verbose bin/osx/PointsSlip_osx.dmg

sh Certs/Apple/Notarize.sh

codesign -vvv --deep --strict --verbose bin/osx/PointsSlip_osx_Notarized.dmg

mv bin/osx/PointsSlip_osx_Notarized.dmg bin/osx/PointsSlip_osx.dmg
