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
          for (const balance of account.balances) {
            if (balance.asset_type === 'native') {
              balanceElement.textContent = `${balance.balance} XLM`
            } else {
              balanceElement.textContent = `${balance.balance} ${
                balance.asset_type
              }`
            }
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
