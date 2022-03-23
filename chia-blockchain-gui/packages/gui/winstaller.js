const createWindowsInstaller = require('electron-winstaller').createWindowsInstaller
const path = require('path')

getInstallerConfig()
  .then(createWindowsInstaller)
  .catch((error) => {
    console.error(error.message || error)
    process.exit(1)
  })

function getInstallerConfig () {
  console.log('Creating windows installer')
  const rootPath = path.join('./')
  const outPath = path.join(rootPath, 'release-builds')

  return Promise.resolve({
    name: "gold-light-wallet",
    appDirectory: path.join(rootPath, 'Gold-Light-Wallet-win32-x64'),
    authors: 'Gold Network',
    version: process.env.GOLD_INSTALLER_VERSION,
    noMsi: true,
    iconUrl: 'https://raw.githubusercontent.com/gold-network/gold-blockchain/master/electron-react/src/assets/img/chia.ico',
    outputDirectory: path.join(outPath, 'windows-installer'),
    certificateFile: 'win_code_sign_cert.p12',
    certificatePassword: process.env.WIN_CODE_SIGN_PASS,
    exe: 'Gold-Light-Wallet.exe',
    setupExe: 'Gold-Light-Wallet-Setup-' + process.env.GOLD_INSTALLER_VERSION + '.exe',
    setupIcon: path.join(rootPath, 'src', 'assets', 'img', 'chia.ico')
  })
}
