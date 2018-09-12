import StellarSdk from 'stellar-sdk'

function createServer(network) {
  const server = new StellarSdk.Server(network)

  if (network.includes('test')) {
    StellarSdk.Network.useTestNetwork()
  } else {
    StellarSdk.Network.usePublicNetwork()
  }

  return server
}

function processAsset({code, issuer}) {
  if (code === StellarSdk.Asset.native().code && !issuer) {
    return StellarSdk.Asset.native()
  } else {
    return new StellarSdk.Asset(code, issuer)
  }
}

function getAccountBalances(stellarNetwork) {
  const server = createServer(stellarNetwork)

  const balanceElements = document.querySelectorAll('[data-stellar-balance]')

  if (balanceElements) {
    balanceElements.forEach((balanceElement) => {
      const publicKey = balanceElement.dataset.stellarBalance

      server
        .loadAccount(publicKey)
        .then((account) => {
          balanceElement.innerHTML = ''
          for (const balance of account.balances) {
            const newDiv = document.createElement('div')
            const type =
              balance.asset_type === 'native' ? 'XLM' : balance.asset_type

            newDiv.textContent = `${balance.balance} ${type}`
            balanceElement.appendChild(newDiv)
          }
        })
        .catch(() => {
          balanceElement.textContent = 'Unable to get balance'
        })
    })
  }
}

export default {
  getAccountBalances,
  createServer,
  processAsset,
}
