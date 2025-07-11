echo "======== INPUTS ========"
echo "RunFile: $1"
echo "Directory: $2"
echo "CertName: $3"
echo "Entitlements: $4"
echo "======== END INPUTS ========"

for f in $2
do 
    if [ "$f" = "$1" ]; 
    then 
        echo "Runtime Signing $f" 
        codesign --timestamp --sign "$3" $f --options=runtime --no-strict --entitlements $4
    else 
        echo "Signing $f" 
        codesign --timestamp --sign "$3" $f --no-strict 
    fi
done
