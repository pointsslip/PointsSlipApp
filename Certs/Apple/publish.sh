dotnet publish PointsSlip.csproj -c Release -r osx-x64 -p:UseAppHost=true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:IncludeAllContentForSelfExtract=true --self-contained true -p:PublishReadyToRunShowWarnings=true -o bin/osx-x64

rm bin/osx-x64/*.pdb
chmod +x bin/osx-x64/PointsSlip

codesign --remove-signature bin/osx-x64/PointsSlip

cp Assets/Templates/PointsSlip.app bin/osx-x64/PointsSlip.app
cp bin/osx-x64/PointsSlip bin/osx-x64/PointsSlip.app/Contents/MacOS/PointsSlip
cp Assets/Logos/logo.icns bin/osx-x64/PointsSlip.app/Contents/Resources/logo.icns
