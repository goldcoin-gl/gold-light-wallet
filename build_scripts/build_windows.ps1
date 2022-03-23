# $env:path should contain a path to editbin.exe and signtool.exe

mkdir build_scripts\win_build
Set-Location -Path ".\build_scripts\win_build" -PassThru

Write-Output "   ---"
Write-Output "curl miniupnpc"
Write-Output "   ---"
Invoke-WebRequest -Uri "https://pypi.chia.net/simple/miniupnpc/miniupnpc-2.2.2-cp39-cp39-win_amd64.whl" -OutFile "miniupnpc-2.2.2-cp39-cp39-win_amd64.whl"
Write-Output "Using win_amd64 python 3.9 wheel from https://github.com/miniupnp/miniupnp/pull/475 (2.2.0-RC1)"
Write-Output "Actual build from https://github.com/miniupnp/miniupnp/commit/7783ac1545f70e3341da5866069bde88244dd848"
If ($LastExitCode -gt 0){
    Throw "Failed to download miniupnpc!"
}
else
{
    Set-Location -Path "../.." -PassThru
    Write-Output "miniupnpc download successful."
}

Write-Output "   ---"
Write-Output "Create venv - python3.9 is required in PATH"
Write-Output "   ---"
python -m venv venv
. .\venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install wheel pep517
pip install pywin32
pip install pyinstaller==4.9
pip install setuptools_scm

Write-Output "   ---"
Write-Output "Build chia-blockchain wheels"
Write-Output "   ---"
pip wheel --use-pep517 --extra-index-url https://pypi.chia.net/simple/ -f . --wheel-dir=.\build_scripts\win_build .

Write-Output "   ---"
Write-Output "Install chia-blockchain wheels into venv with pip"
Write-Output "   ---"

Write-Output "pip install miniupnpc"
Set-Location -Path ".\build_scripts" -PassThru
pip install --no-index --find-links=.\win_build\ miniupnpc
# Write-Output "pip install setproctitle"
# pip install setproctitle==1.2.2

Write-Output "pip install chia-blockchain"
pip install --no-index --find-links=.\win_build\ chia-blockchain

Write-Output "   ---"
Write-Output "Use pyinstaller to create gold.exe's"
Write-Output "   ---"
$SPEC_FILE = (python -c 'import chia; print(chia.PYINSTALLER_SPEC_PATH)') -join "`n"
pyinstaller --log-level INFO $SPEC_FILE

Write-Output "   ---"
Write-Output "Copy chia executables to chia-blockchain-gui\"
Write-Output "   ---"
Copy-Item "dist\daemon" -Destination "..\chia-blockchain-gui\packages\gui\" -Recurse
Set-Location -Path ".." -PassThru

