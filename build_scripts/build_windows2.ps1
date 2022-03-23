
param (
    [Parameter(Mandatory=$true)][string]$version
)
$env:GOLD_INSTALLER_VERSION = $version
$packageVersion = "$env:GOLD_INSTALLER_VERSION"
$packageName = "Gold-Light-Wallet-$packageVersion"
Write-Output "Gold Version is: $env:GOLD_INSTALLER_VERSION"
Write-Output "   ---"

Write-Output "   ---"
Write-Output "Setup npm packager"
Write-Output "   ---"
Set-Location -Path ".\build_scripts\npm_windows" -PassThru
#npm ci
$Env:Path = $(npm bin) + ";" + $Env:Path
Set-Location -Path "..\.." -PassThru

Set-Location -Path "chia-blockchain-gui" -PassThru
# We need the code sign cert in the gui subdirectory so we can actually sign the UI package
#If ($env:HAS_SECRET) {
#    Copy-Item "win_code_sign_cert.p12" -Destination "packages\gui\"
#}

#git status

Write-Output "   ---"
Write-Output "Prepare Electron packager"
Write-Output "   ---"
$Env:NODE_OPTIONS = "--max-old-space-size=3000"

#lerna clean -y
#npm ci
# Audit fix does not currently work with Lerna. See https://github.com/lerna/lerna/issues/1663
# npm audit fix

# git status

Write-Output "   ---"
Write-Output "Electron package Windows Installer"
Write-Output "   ---"
npm run build
If ($LastExitCode -gt 0){
    Throw "npm run build failed!"
}

# Change to the GUI directory
Set-Location -Path "packages\gui" -PassThru

#Write-Output "   ---"
#Write-Output "Increase the stack for chia command for (chia plots create) chiapos limitations"
# editbin.exe needs to be in the path
#editbin.exe /STACK:8000000 daemon\gold.exe
Write-Output "   ---"


Write-Output "packageName is $packageName"

#Write-Output "   ---"
#Write-Output "fix version in package.json"
#choco install jq
#cp package.json package.json.orig
#jq --arg VER "$env:GOLD_INSTALLER_VERSION" '.version=$VER' package.json > temp.json
#rm package.json
#mv temp.json package.json
#Write-Output "   ---"

Write-Output "   ---"
Write-Output "electron-packager"
electron-packager . Gold-Light-Wallet --asar.unpack="**\daemon\**" --overwrite --icon=.\src\assets\img\chia.ico --app-version=$packageVersion
Write-Output "   ---"

Write-Output "   ---"
Write-Output "node winstaller.js"
C:\"Program Files"\nodejs\node.exe winstaller.js
Write-Output "   ---"

#git status

#If ($env:HAS_SECRET) {
#   Write-Output "   ---"
#   Write-Output "Add timestamp and verify signature"
#   Write-Output "   ---"
#   signtool.exe timestamp /v /t http://timestamp.comodoca.com/ .\release-builds\windows-installer\GoldSetup-$packageVersion.exe
#   signtool.exe verify /v /pa .\release-builds\windows-installer\GoldSetup-$packageVersion.exe
#   }   Else    {
#   Write-Output "Skipping timestamp and verify signatures - no authorization to install certificates"
#}

#git status

#Write-Output "   ---"
#Write-Output "Moving final installers to expected location"
#Write-Output "   ---"
#Copy-Item ".\Gold-win32-x64" -Destination "$env:GITHUB_WORKSPACE\chia-blockchain-gui\" -Recurse
#Copy-Item ".\release-builds" -Destination "$env:GITHUB_WORKSPACE\chia-blockchain-gui\" -Recurse

Write-Output "   ---"
Write-Output "Windows Installer complete"
Write-Output "   ---"
Set-Location -Path "..\..\.." -PassThru
