cd ..
cd ..

rm .\bin -Recurse
dotnet publish PointsSlip.csproj -c Release -r win-x64 -p:UseAppHost=true -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:IncludeAllContentForSelfExtract=true --self-contained true -p:PublishReadyToRunShowWarnings=true -o bin/win-x64

rm .\bin\win-x64\PointsSlip.pdb
rm .\bin\Release -Recurse
# Password is L@ckn3r(1)
signtool sign /t "http://timestamp.sectigo.com" /f ".\Certs\Windows\LGI_SectigoEVCodeSigningCert.cer" ".\bin\win-x64\PointsSlip.exe"
signtool verify /pa /v bin\win-x64\PointsSlip.exe

# Display a message to the user
Write-Host "Press Enter to finish"

# Wait for the user to press Enter
Read-Host